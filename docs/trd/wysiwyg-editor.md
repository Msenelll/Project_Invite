# TRD: SaaS WYSIWYG Editörü & Zustand Durum Yönetimi
**Ticket ID:** TCK-200  
**Yazar:** `@arch`  
**Referans PRD:** [PRD: SaaS WYSIWYG Editörü](file:///C:/repo/11_Project_Invite/docs/prd/wysiwyg-editor.md)  
**Durum:** Hazırlanıyor  

---

## 1. DURUM YÖNETİMİ (ZUSTAND STATE ARCHITECTURE)
İstemci tarafındaki düzenleme durumunu (editing state) ve canlı önizleme eşitlemesini yönetmek için Zustand kütüphanesi kullanılacaktır. Store, `/src/store/useEditorStore.js` altında konumlanacaktır.

### A. State Şeması (State Shape)
```javascript
{
  invitationId: string | null, // Düzenlenen davetiyenin UUID'si
  slug: string,               // davetiyem.com/[slug]
  subdomain: string | null,   // [subdomain].davetiyem.com
  title: string,              // Davetiye başlığı (Metadata)
  themeId: string,            // Seçili tema ID'si (Örn: 'romantic-gold')
  isDirty: boolean,           // Kaydedilmemiş değişiklik var mı?
  isSaving: boolean,          // Kaydediliyor mu? (Loading state)
  
  // Davetiyenin asıl dinamik içeriği (Supabase content JSONB kolonu)
  content: {
    couple: {
      groomName: string,      // Damat ismi
      brideName: string,      // Gelin ismi
      groomPhoto: string,     // Damat fotoğraf URL'si
      bridePhoto: string,     // Gelin fotoğraf URL'si
      mainPhoto: string       // Ana kapak fotoğrafı URL'si
    },
    event: {
      date: string,           // ISO Date String
      locationName: string,   // Salon/Mekan adı
      address: string,        // Açık adres
      latitude: number,       // Harita koordinatı
      longitude: number       // Harita koordinatı
    },
    sections: {
      story: { active: boolean, title: string, text: string },
      gallery: { active: boolean, images: string[] },
      map: { active: boolean },
      rsvp: { active: boolean, deadline: string },
      music: { active: boolean, songId: string }
    },
    sectionOrder: string[]   // Görsel sıralama düzeni: ['story', 'gallery', 'map', 'rsvp']
  }
}
```

### B. Store Actions
* `updateField(path: string, value: any)`: İçerik alanlarını derinlemesine günceller (Örn: `content.couple.groomName`).
* `toggleSection(sectionId: string)`: İlgili bölümün aktiflik durumunu değiştirir.
* `setTheme(themeId: string)`: Temayı günceller ve önizlemedeki CSS sınıflarını tetikler.
* `reorderSections(newOrder: string[])`: Bölüm sıralama dizisini günceller.
* `saveInvitation()`: API'ye POST isteği atarak güncel durum verisini veri tabanına yazar.

---

## 2. API VE ENDPOINT TASARIMI (NEXT.JS SERVERLESS)
İstemci ile Supabase arasındaki iletişimi güvenli kılmak ve RLS kurallarını doğrulamak için Next.js API Routes (App Router) kullanılacaktır.

### A. `POST /api/invitations/save` (Kaydet ve Yayınla)
* **Yetkilendirme:** İstek başlığında (Header) JWT token veya Supabase Auth Session bulunmalıdır.
* **Payload:**
  ```json
  {
    "id": "invitation-uuid-or-null",
    "slug": "ayse-ahmet-evleniyor",
    "subdomain": null,
    "title": "Ayşe & Ahmet Düğün Davetiyesi",
    "theme_id": "romantic-gold",
    "content": { ... },
    "is_published": true
  }
  ```
* **İş Akışı:**
  1. Kullanıcı oturumu doğrulanır (`supabase.auth.getUser()`).
  2. Slug benzersizliği kontrol edilir (Eğer yeni davetiyeyse veya slug değiştiyse).
  3. Supabase client aracılığıyla `invitations` tablosuna UPSERT işlemi yapılır.
  4. İşlem başarılı ise **ISR Revalidation** tetiklenir (Detaylar 3. Bölümde).
* **Cevap (Response):**
  * `200 OK`: `{ "success": true, "id": "invitation-uuid", "url": "/ayse-ahmet-evleniyor" }`
  * `400 Bad Request`: `{ "error": "Slug zaten kullanımda." }`
  * `401 Unauthorized`: `{ "error": "Yetkisiz erişim." }`

---

## 3. ISR (INCREMENTAL STATIC REGENERATION) VE YÖNLENDİRME
SaaS davetiyeleri, TTFB süresini <200ms tutmak için statik olarak sunulmalı ve güncelleme anında derlenmelidir.

### A. Rota Yapısı
* `/app/[slug]/page.jsx`: Dinamik rota dosyası.
* Sayfa içinde `generateStaticParams()` fonksiyonu kullanılarak sadece en aktif davetiyeler build anında derlenir. Diğer davetiyeler ilk talep anında arka planda oluşturulur.

### B. On-Demand Revalidation Tetikleyicisi
`save` işlemi başarıyla tamamlandıktan sonra Next.js API katmanında revalidation tetiklenir:
```javascript
import { revalidatePath } from 'next/cache';

// API Handler içinde:
try {
  // Veritabanı kaydı tamamlandıktan sonra...
  revalidatePath(`/${slug}`); // İlgili slug statik cache'ini temizler ve arka planda yeniden derler.
} catch (err) {
  console.error("ISR revalidation failed:", err);
}
```

---

## 4. GÖRSEL TEMA ENTEGRASYONU VE CSS STANDARTLARI
* Temalar `/src/styles/themes/` altında Vanilla CSS modülleri olarak yazılacaktır.
* Seçili `themeId` parametresi, davetiye önizleme penceresinin en üst kapsayıcısına CSS sınıfı olarak eklenecektir (`class="theme-romantic-gold"`).
* Her tema kendi renk değişkenlerini tanımlayacaktır:
  ```css
  .theme-romantic-gold {
    --primary-color: #d4af37;
    --background-color: #fffdf5;
    --font-family: 'Playfair Display', serif;
  }
  ```
