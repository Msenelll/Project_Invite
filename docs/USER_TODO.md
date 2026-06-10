# KULLANICI YAPILACAKLAR LİSTESİ (USER_TODO)

Bu dosya, yazılım süreçleri dışındaki manuel tasarım, varlık (asset) yönetimi veya dış platform entegrasyonu gibi insan müdahalesi gerektiren adımları takip etmek için kullanılır. 

Lütfen aşağıdaki adımları tamamladıktan sonra durum kutusunu `[x]` olarak güncelleyin.

---

## 1. TASARIM VE GÖRSEL VARLIKLAR (ASSETS)
* [ ] **Figma Şablonlarının Hazırlanması:**
  * Manuel Premium model için kullanılacak ilk 3 premium davetiye tasarımının Figma export'larının çıkarılması.
  * Tasarımlardaki font ailelerinin ve renk kodlarının listelenmesi.
* [ ] **Görsel Asset Yüklemeleri:**
  * Varsayılan davetiye arka plan görsellerinin `/public/assets/images/backgrounds/` altına yerleştirilmesi.
  * Platform logosunun `/public/assets/brand/logo.png` olarak eklenmesi.

---

## 2. MEDYA VE MÜZİK (AUDIO)
* [ ] **Fon Müziklerinin Eklenmesi:**
  * Davetiyelerde çalınabilecek telifsiz premium müziklerin (MP3 formatında) `/public/assets/audio/` klasörüne yerleştirilmesi.
  * Müziklerin isim ve sanatçı bilgilerinin veri tabanına girilmeye hazır hale getirilmesi.

---

## 3. SUPABASE & ALTYAPI ERİŞİMLERİ
* [ ] **Supabase Proje Oluşturma:**
  * Bir Supabase projesi oluşturulması ve API anahtarları ile URL bilgisinin `.env.local` dosyasına eklenmesi.
* [ ] **SQL Şemasının Uygulanması:**
  * [schema.sql](file:///C:/repo/11_Project_Invite/docs/skills/schema.sql) dosyasındaki SQL kodunun Supabase paneli -> SQL Editor sekmesine yapıştırılarak `RUN` butonuna basılması ve tabloların/RLS kurallarının oluşturulması.
* [ ] **Domain DNS Ayarları:**
  * SaaS modeli için wildcard subdomain (`*.davetiyem.com`) DNS yönlendirmelerinin CNAME kayıtları ile Vercel'e yapılması.
