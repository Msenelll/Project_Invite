# TEKNİK YETENEK: NEXT.JS ISR VE PERFORMANS OPTİMİZASYONU

Bu doküman, SaaS davetiye platformunda statik davetiye sayfalarının **ISR (Incremental Static Regeneration)** ile anında derlenmesi, CDN caching stratejileri ve TTFB < 200ms hedefinin yakalanması için teknik kuralları açıklar.

---

## 1. YETENEK KAPSAMI
* **Dinamik Rota (Dynamic Route) Yönetimi:** `davetiyem.com/[slug]` rotasının statik olarak derlenmesi.
* **Incremental Static Regeneration (ISR):** Davetiye güncellendiğinde veya yeni bir davetiye oluşturulduğunda sayfanın arka planda yeniden derlenmesi (On-Demand Revalidation).
* **CDN Caching Stratejileri:** Statik HTML ve varlıkların Edge sunucularında önbelleğe alınması, veritabanı sorgu sayısının azaltılması.

---

## 2. RENDER STRATEJİLERİ
1. **Ziyaretçi Sayfaları (Davetiyeler):** Tamamen statik ve ISR tabanlı olmalıdır. Ziyaretçi davetiye linkine tıkladığında sayfa doğrudan CDN üzerinden <200ms içinde yüklenmelidir.
2. **On-Demand Revalidation:** Kullanıcı WYSIWYG editörü üzerinden davetiyesini kaydedip yayınladığında, Next.js revalidate API ucu tetiklenmeli ve sadece o slug'a ait sayfa yeniden derlenmelidir:
   ```javascript
   // app/api/revalidate/route.js
   import { revalidatePath } from 'next/cache';
   
   export async function POST(request) {
     const { slug } = await request.json();
     revalidatePath(`/${slug}`);
     return Response.json({ revalidated: true });
   }
   ```
3. **Yönetim Paneli (Dashboard):** Tamamen dinamik (SSR / Client-Side Render) ve Zustand state odaklı olmalıdır. önbellekleme yapılmamalıdır.

---

## 3. PERFORMANS KRİTERLERİ
* Tüm harici görseller (davetli fotoğrafları vb.) Next.js `<Image />` bileşeni kullanılarak optimize edilmeli ve WebP/AVIF formatlarında sunulmalıdır.
* CSS dosyaları minimal tutulmalı, JavaScript bundle boyutu optimize edilmelidir.
