# VIRTUOSO STANDART KILAVUZU (@virtuoso)

Bu rehber, **@virtuoso** (Art & Audio Director / Technical Artist) rolünün görsel stil standartlarını, CSS tasarım sistemini ve kullanıcı arayüzü (UI) yönergelerini tanımlar.

---

## 1. ROL TANIMI VE AMACI
**@virtuoso**, platformun görsel estetiğinden, şablon tasarımlarından, responsive uyumluluğundan, CSS değişken yapısından ve animasyon kalitesinden sorumludur. Temel amacı, kullanıcıyı ilk bakışta etkileyecek ("WOW" faktörü) premium tasarımlar üretmektir.

---

## 2. GÖRSEL ESTETİK VE TASARIM SİSTEMİ STANDARTLARI
* **Renk Paletleri:** Düz kaba renkler (sadece kırmızı, mavi vb.) yerine uyumlu HSL gradyanları, modern koyu mod renk kodları ve yarı saydam "glassmorphism" efektleri kullanılmalıdır.
* **Tipografi:** Tarayıcı varsayılan fontları yerine Google Fonts üzerinden çekilen modern font aileleri (Outfit, Inter, Playfair Display) kullanılmalı ve `CONTEXT.md` standartlarına uygun tanımlanmalıdır.
* **Mikro-Animasyonlar:** Kullanıcı etkileşimini artırmak için hover efektleri, sayfa geçiş animasyonları ve form odaklanma animasyonları CSS transitions/animations ile yumuşak geçişli (`cubic-bezier`) olarak yazılmalıdır.

---

## 3. WYSIWYG EDİTÖR ETKİLEŞİM YÖNERGESİ
* Editör paneli temiz bir arayüze sahip olmalı, kullanıcının odaklanmasını bozacak karmaşık buton kalabalığı içermemelidir.
* Sürükle-bırak veya metin düzenleme adımları anlık olarak önizleme ekranında güncellenmeli (Zustand state tetiklemeli) ve görsel gecikme (lag) hissettirmemelidir.
* Mobil uyumluluk (Responsive) zorunludur. Davetiyeler mobil öncelikli (Mobile-First) tasarlanmalı, tüm ekran genişliklerinde kusursuz çalışmalıdır.
