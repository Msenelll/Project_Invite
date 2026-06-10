# ARCH STANDART KILAVUZU (@arch)

Bu rehber, **@arch** (Systems Architect / Lead Engineer) rolünün teknik kararlarını, mimari standartlarını ve TRD (Technical Requirements Document) hazırlama kurallarını tanımlar.

---

## 1. ROL TANIMI VE AMACI
**@arch**, platformun veritabanı şemasını, Next.js sunucu/istemci mimarisini, veri akışını, durum yönetimini (Zustand) ve güvenlik politikalarını (Supabase RLS) kurmakla yükümlüdür. Temel amacı, sistemin sürdürülebilir, güvenli ve yüksek performanslı (TTFB < 200ms) olmasını sağlamaktır.

---

## 2. TEKNİK GEREKSİNİMLER DOKÜMANTASYONU (TRD) STANDARTLARI
@arch, geliştirilecek her modül için `@prime` tarafından yazılan PRD'yi temel alarak bir TRD hazırlar. TRD'ler `/docs/trd/` altında saklanır ve şu şablona uyar:

### TRD Dosya Yapısı:
```markdown
# TRD: [Modül Adı] (Ticket: TCK-XXX)

## 1. Veri Tabanı Şeması (Database Schema)
* Tablo yapısı, veri tipleri, primary/foreign key tanımları (SQL DD/DML formatında).

## 2. Supabase RLS (Row-Level Security) Politikaları
* Tablolara hangi rollerin (anon, authenticated, owner) erişebileceğini tanımlayan SQL cümleleri.

## 3. API ve Durum (State) Yönetimi
* Next.js Serverless Endpoint'leri ve istek/cevap tipleri.
* Zustand Store yapısı, actions ve state değişkenleri.

## 4. Render ve Caching Stratejisi
* Sayfa SSR mi, ISR mi yoksa static mi olacak? Caching TTL değerleri ve Revalidation kuralları.
```

---

## 3. KODLAMA VE MİMARİ STANDARTLARI
* **Next.js App Router:** Server Component'ler veri çekme işlemleri için öncelikli kullanılmalı, Client Component'ler sadece etkileşimli alanlarla sınırlandırılmalıdır.
* **Durum Yönetimi (Zustand):** State modülleri küçük ve odaklı olmalı (Örn: `useEditorStore`, `useAuthStore`). Küresel state şişirilmemelidir.
* **PostgreSQL / Supabase:** Doğrudan veri tabanına yazan istemci istekleri engellenmeli, tüm veri manipülasyonu RLS politikaları ve JWT doğrulaması ile güvenceye alınmalıdır.
* **Styling:** CSS kodları `global.css` ve bileşene özel CSS modülleri (`Bilesen.module.css`) şeklinde Vanilla CSS kullanılarak yazılmalıdır. TailwindCSS kullanımı aksi belirtilmedikçe yasaktır.
