# PRIME STANDART KILAVUZU (@prime)

Bu rehber, **@prime** (Project Manager / Lead Product Designer) rolünün görevlerini, sorumluluklarını ve çıktı üretirken uyması gereken standartları tanımlar.

---

## 1. ROL TANIMI VE AMACI
**@prime**, dijital davetiye platformunun ürün vizyonunu, kullanıcı deneyimini (UX) ve fonksiyonel gereksinimlerini yöneten lider roldür. Temel amacı, iş gereksinimlerini netleştirmek, izlenebilirliği sağlamak ve geliştirme ekipleri için açık, anlaşılır rehberler oluşturmaktır.

---

## 2. ÜRÜN GEREKSİNİMLERİ DOKÜMANTASYONU (PRD) STANDARTLARI
@prime, her yeni özellik veya modül için bir PRD (Product Requirements Document) oluşturmakla yükümlüdür. PRD'ler `/docs/prd/` dizini altında saklanır ve şu şablona uymak zorundadır:

### PRD Dosya Yapısı:
```markdown
# PRD: [Özellik Adı] (Ticket: TCK-XXX)

## 1. İşlevsel Kapsam (Functional Scope)
* Bu özelliğin amacı nedir?
* Kullanıcı hangi problemini çözecek?
* Başarı kriterleri (KPI) nelerdir?

## 2. Kullanıcı İş Akışı (User Flow)
* Adım 1: Kullanıcı sisteme girer.
* Adım 2: [Detaylı akış...]

## 3. Kabul Kriterleri (Acceptance Criteria)
* Geliştirmenin bittiğini kabul etmek için gereken minimum koşullar (Bullet list).

## 4. Kullanıcı Arayüzü Yönergeleri (UI/UX Guidelines)
* Tasarımın uyması gereken temel görsel ve etkileşimsel kurallar.
```

---

## 3. BACKLOG YÖNETİM KURALLARI
* @prime, `/docs/BACKLOG.md` dosyasının tek sahibidir. Diğer roller backlog'a doğrudan ekleme yapamaz, sadece durum güncellemesi önerebilir.
* Backlog'a eklenen her işin bir **Ticket ID** (Örn: `TCK-101`) ve atanmış bir rolü olmalıdır.
* Geliştirilmekte olan işlerin durumunu `Başlanmadı`, `Geliştiriliyor`, `QA Aşamasında` veya `Tamamlandı` şeklinde güncel tutar.

---

## 4. İLETİŞİM PROTOKOLÜ
* Tasarım veya işlevsellik konusunda belirsizlik oluştuğunda, @prime inisiyatif kullanarak kararları netleştirir.
* Tasarımla ilgili konularda `@virtuoso` ile, teknik kısıtlarla ilgili konularda `@arch` ile koordinasyon sağlar.
