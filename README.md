# Çevrimiçi Yemek Sipariş Platformu Veritabanı Tasarımı

Bu proje, VTYS-1 Dönem Projesi kapsamında geliştirilmiş, ölçeklenebilir ve 3. Normal Form (3NF) kurallarına uygun olarak tasarlanmış bir **Çevrimiçi Yemek Sipariş Platformu** veritabanı projesidir.

Klasik bir yemek sipariş sisteminin (Müşteri, Restoran, Kurye, Menü, Sipariş vb.) tüm gereksinimlerini sağlamakla birlikte, sosyal sorumluluk odaklı özel bir **"Askıda Yemek"** modülü içermektedir.

---

## Özel Modül: "Askıda Yemek" (Pay It Forward)
Projenin en belirgin özelliği olan bu modül sayesinde, hayırsever müşteriler platform üzerinden bağış yapabilmekte ve maddi durumu yetersiz olan "İhtiyaç Sahibi" kullanıcılar bu bağışlarla ücretsiz sipariş verebilmektedir.

**Sistem şu özelliklere sahiptir:**
- **Esnek Bağış Türü:** Hayırseverler dilerlerse direkt **Para (Bakiye)** bağışlayabilir, dilerlerse belirli bir restorandan **Yemek (Örn: 2 Adet Pizza)** bağışlayabilir. Yemek bağışları arka planda otomatik olarak o günkü fiyat üzerinden hesaplanıp toplam havuza parasal değer olarak aktarılır.
- **Gizlilik:** Bağışçılar `IsAnonymous` bayrağı sayesinde kimliklerini gizleyebilirler.
- **Otomasyon (Triggers):** 
  - Bağış yapıldığında havuz bakiyesi otomatik olarak artar (`trg_AskidaYemekBagisi`).
  - İhtiyaç sahibi sipariş verdiğinde, sepet tutarı havuzdan otomatik olarak düşülür (`trg_AskidaYemekKullanimi`).

---

## Proje Dosya Yapısı ve Aşamalar
Proje dosyaları mantıksal aşamalara bölünmüş olup sırasıyla şu şekildedir:

1. **`01_DDL.sql`**: Veritabanı iskeleti. Tüm tablolar (Users, Restaurants, Products vb.), PRIMARY KEY, FOREIGN KEY, CHECK kısıtlamaları (Fiyat > 0 vb.) ve performans artırıcı İndeksler (Index) bulunur. Soft Delete mantığı (`IsActive` kolonu) ile tasarlanmıştır.
2. **`02_Views.sql`**: Karmaşık sorguları basitleştiren görünümler (Örn: Sadece aktif restoranların menülerini listeleyen view).
3. **`03_Triggers.sql`**: Sistemdeki iş kurallarını (Askıda Yemek bakiye düşümü, sipariş teslim edildiğinde restoran cirosunun otomatik artması) yürüten tetikleyiciler.
4. **`04_DML_MockData.sql`**: Sistemin test edilebilmesi için yazılmış, 5 restoran, 50 ürün, 25 kullanıcı ve 100 sipariş hareketini içeren geniş test verisi bloğu.
5. **`05_DQL_Queries.sql`**: İstenen analitik sorgular (INNER/LEFT JOIN ile detaylı sipariş fişi, GROUP BY ve HAVING ile restoran analizi, NOT EXISTS alt sorgusu ile müşteri filtreleme).
6. **`Business_Rules_and_AI_Declaration.md`**: Sistemin detaylı çalışma kurallarını ve geliştirme sürecindeki Yapay Zeka (AI) dürüstlük beyanını içeren rapor.
7. **`ER_Diagram.md`**: Tablolar arası ilişkileri (M:N, 1:N) gösteren Varlık-İlişki şeması.

---

## Teknik Gereksinimler & Kullanılan Yapılar
- **DDL (Data Definition Language)**: CREATE TABLE, ALTER
- **DML (Data Manipulation Language)**: INSERT, UPDATE (Soft Delete)
- **DQL (Data Query Language)**: SELECT, JOIN, GROUP BY, HAVING, Subqueries
- **Constraints**: PRIMARY KEY, FOREIGN KEY, UNIQUE, NOT NULL, CHECK
- **Advanced Objects**: Views, Triggers, Non-Clustered Indexes

---

## Kurulum / Çalıştırma
Veritabanını MS SQL Server (veya uyumlu herhangi bir T-SQL veritabanı yönetim sistemi) üzerinde çalıştırmak için numaralandırılmış dosyaları (`01` -> `05` sırasıyla) çalıştırarak (Execute) test edebilirsiniz. 
