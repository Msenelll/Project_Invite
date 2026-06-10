# PROJE BACKLOG & TICKET TRACKER

Bu doküman, projedeki tüm işlerin durumunu, öncelik sırasını ve izlenebilirliğini takip etmek için kullanılır. Hiçbir kod satırı bu backlog'da tanımlı bir **Ticket ID** olmadan yazılamaz.

---

## 1. MEVCUT DURUM ÖZETİ
* **Aktif Versiyon:** `v0.0:0` (Başlangıç)
* **Aktif Sprint:** Sprint 0 (Altyapı Kurulumu)
* **Hedef Dal:** `develop`

---

## 2. ETKİN TİCKET LİSTESİ

### Sprint 0: Altyapı ve Klasör Düzeni
| Ticket ID | Başlık | Rol | Durum | Hedef Sürüm |
| :--- | :--- | :--- | :--- | :--- |
| `TCK-001` | Proje klasör yapısının ve CONTEXT.md'nin oluşturulması | `@prime` | Başlanmadı | `v0.1:0` |
| `TCK-002` | Rollerin ve standart kılavuzlarının yazılması | `@prime` | Başlanmadı | `v0.1:0` |
| `TCK-003` | Ajan uzmanlık alanlarının `/neededAgents` altına eklenmesi | `@nexus` | Başlanmadı | `v0.1:0` |
| `TCK-004` | Temel teknik yeteneklerin `/skills` altına tanımlanması | `@arch` | Başlanmadı | `v0.1:0` |
| `TCK-005` | Git deposunun kurulması ve ilk develop push'unun yapılması | `@pub` | Başlanmadı | `v0.1:0` |

---

## 3. İLERİYE DÖNÜK PLANLANAN İŞLER (BACKLOG)

### Epik 1: Supabase & Veri Tabanı Mimarisi
* [ ] `TCK-101`: Müşteri ve Davetiye Tablolarının Oluşturulması (`@arch`)
* [ ] `TCK-102`: RLS (Row-Level Security) Politikalarının Tanımlanması (`@arch`)
* [ ] `TCK-103`: RSVP/LCV Formu Tablosu ve Entegrasyonu (`@arch`)

### Epik 2: SaaS WYSIWYG Editör & Zustand
* [ ] `TCK-201`: Zustand State Modüllerinin Tasarlanması (`@arch`)
* [ ] `TCK-202`: Editör Sürükle-Bırak/Düzenleme Bileşenlerinin Görsel Standartları (`@virtuoso`)
* [ ] `TCK-203`: Next.js ISR Render Optimizasyonu (`@arch`)

### Epik 3: Premium Manuel Davetiye Yönlendirme
* [ ] `TCK-301`: Dinamik Subdomain Wildcard Middleware Tasarımı (`@arch`)
