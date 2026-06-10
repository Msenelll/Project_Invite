-- ==========================================
-- SUPABASE POSTGRESQL VERİ TABANI ŞEMASI
-- PROJE: la-vie-digital (Dijital Davetiye Platformu)
-- TİCKETLAR: TCK-101, TCK-102, TCK-103
-- SÜRÜM: v0.1:2
-- ==========================================

-- Gerekli Uzantıların (Extensions) Aktif Edilmesi
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==========================================
-- 1. TABLO TANIMLARI (TABLE SCHEMAS)
-- ==========================================

-- A. Profiller Tablosu (profiles)
-- auth.users tablosu ile 1-1 ilişkilidir.
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL DEFAULT '',
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- B. Davetiyeler Tablosu (invitations)
-- SaaS modelinde "slug", Premium modelinde "subdomain" kullanılır.
CREATE TABLE IF NOT EXISTS public.invitations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    slug TEXT UNIQUE NOT NULL,
    subdomain TEXT UNIQUE,
    title TEXT NOT NULL,
    event_date TIMESTAMPTZ NOT NULL,
    theme_id TEXT NOT NULL,
    content JSONB NOT NULL DEFAULT '{}'::jsonb,
    is_published BOOLEAN NOT NULL DEFAULT false,
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    -- Subdomain boş olmalıdır ya da tamamen benzersiz olmalıdır (PostgreSQL UNIQUE constraint bunu destekler)
    CONSTRAINT slug_length CHECK (char_length(slug) >= 3)
);

-- C. RSVP / LCV Katılım Tablosu (rsvps)
-- Ziyaretçilerin katılım formlarından gelen verileri tutar.
CREATE TABLE IF NOT EXISTS public.rsvps (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invitation_id UUID NOT NULL REFERENCES public.invitations(id) ON DELETE CASCADE,
    guest_name TEXT NOT NULL,
    is_attending BOOLEAN NOT NULL,
    guest_count INT NOT NULL DEFAULT 1 CONSTRAINT guest_count_positive CHECK (guest_count >= 1),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ==========================================
-- 2. TETİKLEYİCİLER VE FONKSİYONLAR (TRIGGERS & FUNCTIONS)
-- ==========================================

-- A. updated_at Kolonunu Otomatik Güncelleyen Fonksiyon
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- B. updated_at Tetikleyicilerinin Tablolara Eklenmesi
CREATE OR REPLACE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

CREATE OR REPLACE TRIGGER update_invitations_updated_at
    BEFORE UPDATE ON public.invitations
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

-- C. auth.users Üzerinden Otomatik Profil Oluşturan Fonksiyon
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, full_name)
    VALUES (
        NEW.id,
        COALESCE(NEW.raw_user_meta_data->>'full_name', '')
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- D. Yeni Kayıtta Profil Tetikleyicisi
CREATE OR REPLACE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_new_user();

-- ==========================================
-- 3. RLS (ROW-LEVEL SECURITY) POLİTİKALARI
-- ==========================================

-- A. Tablolarda RLS'in Aktif Edilmesi
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invitations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.rsvps ENABLE ROW LEVEL SECURITY;

-- B. profiles Tablosu RLS Politikaları
CREATE POLICY "Kullanıcılar kendi profillerini görebilir"
    ON public.profiles FOR SELECT
    TO authenticated
    USING (auth.uid() = id);

CREATE POLICY "Kullanıcılar kendi profillerini güncelleyebilir"
    ON public.profiles FOR UPDATE
    TO authenticated
    USING (auth.uid() = id);

-- C. invitations Tablosu RLS Politikaları
CREATE POLICY "Yayınlanmış davetiyeleri herkes görebilir"
    ON public.invitations FOR SELECT
    TO anon, authenticated
    USING (is_published = true OR auth.uid() = user_id);

CREATE POLICY "Kullanıcılar davetiye oluşturabilir"
    ON public.invitations FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi davetiyelerini güncelleyebilir"
    ON public.invitations FOR UPDATE
    TO authenticated
    USING (auth.uid() = user_id);

CREATE POLICY "Kullanıcılar kendi davetiyelerini silebilir"
    ON public.invitations FOR DELETE
    TO authenticated
    USING (auth.uid() = user_id);

-- D. rsvps Tablosu RLS Politikaları
CREATE POLICY "Ziyaretçiler RSVP (LCV) kaydı oluşturabilir"
    ON public.rsvps FOR INSERT
    TO anon, authenticated
    WITH CHECK (true);

CREATE POLICY "Davetiye sahipleri RSVP kayıtlarını görebilir"
    ON public.rsvps FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.invitations
            WHERE invitations.id = rsvps.invitation_id 
            AND invitations.user_id = auth.uid()
        )
    );

CREATE POLICY "Davetiye sahipleri RSVP kayıtlarını güncelleyebilir"
    ON public.rsvps FOR UPDATE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.invitations
            WHERE invitations.id = rsvps.invitation_id 
            AND invitations.user_id = auth.uid()
        )
    );

CREATE POLICY "Davetiye sahipleri RSVP kayıtlarını silebilir"
    ON public.rsvps FOR DELETE
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM public.invitations
            WHERE invitations.id = rsvps.invitation_id 
            AND invitations.user_id = auth.uid()
        )
    );
