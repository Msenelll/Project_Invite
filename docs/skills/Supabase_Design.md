# TEKNİK YETENEK: SUPABASE VE RLS TASARIMI

Bu doküman, platform geliştirilirken kullanılacak Supabase PostgreSQL veritabanı şemalarının tasarımı, RLS (Row-Level Security) politikaları ve optimizasyon standartlarını açıklar.

---

## 1. YETENEK KAPSAMI
* **PostgreSQL Şema Tasarımı:** Dijital davetiye projesinde kullanılacak tabloların (müşteri, davetiyeler, davetli listesi/RSVP vb.) ilişkisel şemalarının kurulması.
* **RLS Politikaları:** Supabase güvenlik katmanında authenticated/anon kullanıcı ayrımı, veri sahipliği (owner) kontrolleri.
* **Supabase SQL Functions ve Triggers:** Otomatik tarih güncellemeleri, loglama ve otomatik profil oluşturma işlevleri.

---

## 2. RLS VE GÜVENLİK STANDARTLARI
Tüm tablolarda RLS aktif olmak zorundadır. RLS politikaları yazılırken şu kurallar izlenir:
1. **İstemci Erişim Sınırları:** İstemci tarafında çalışan Supabase client (`supabase-js`), yetkisiz okuma/yazma yapamamalıdır.
2. **Sahiplik Kontrolü (Ownership):** Bir kullanıcı sadece kendi oluşturduğu davetiyeyi düzenleyebilmelidir.
   * *Örnek RLS:*
     ```sql
     CREATE POLICY "Kullanıcı kendi davetiyelerini düzenleyebilir"
     ON public.invitations
     FOR UPDATE
     TO authenticated
     USING (auth.uid() = user_id)
     WITH CHECK (auth.uid() = user_id);
     ```
3. **Anonim Erişim (Public Access):** Davetiyeleri ziyaret eden misafirler (anon), davetiye detaylarını okuyabilmeli (`SELECT`), ancak düzenleme/silme yetkisine sahip olmamalıdır. LCV (RSVP) formunu doldururken ise sadece ilgili LCV tablosuna `INSERT` yapabilmelidirler.

---

## 3. VERİ TABANI TABLO ŞABLONLARI (SQL DDL)
Tasarlanan tablolar her zaman standart PostgreSQL veri tiplerini (`uuid`, `timestamptz`, `text`, `jsonb`) kullanmalıdır. Durum alanları için `text` veya `enum` tipleri tercih edilmelidir.
