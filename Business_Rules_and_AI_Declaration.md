# Çevrimiçi Yemek Sipariş Platformu ve Askıda Yemek Modülü

## 1. Sistem İş Kuralları (Business Rules)

Bu veritabanı, klasik bir yemek sipariş uygulamasının yanı sıra sosyal bir sorumluluk projesi olan "Askıda Yemek" sistemini yönetmek üzere tasarlanmıştır.

### 1.1 Kullanıcı ve Yetki Kuralları
- **Kullanıcı Tipleri**: Sistemde 3 tip kullanıcı vardır: `Müşteri`, `İhtiyaç Sahibi` ve `Kurye`. Rol bazlı ayrım `UserType` alanı üzerinden yapılır.
- **Kayıt Kuralları**: Her kullanıcının e-posta adresi ve telefon numarası sistemde **benzersiz (UNIQUE)** olmalıdır. Şifreler hash'lenmiş varsayılarak tutulur.
- **Veri Silme**: Veritabanından fiziksel silme (DELETE) işlemi yapılmaz. Bunun yerine kullanıcılar, restoranlar, ürünler veya siparişler `IsActive = 0` yapılarak pasife çekilir (Soft Delete).

### 1.2 Restoran ve Menü Kuralları
- **Restoran Değerlendirmesi**: Bir restoranın puanı 1 ile 5 arasında olmalıdır (CHECK Constraint).
- **Menü Fiyatlandırması**: Ürün fiyatları her zaman 0'dan büyük olmalıdır. Negatif veya sıfır fiyatlı ürün eklenemez.
- **Menü Güncelleme**: Menüden kalkan ürünler silinmez, aktiflik durumu değiştirilir (`IsActive = 0`). Bu sayede geçmiş sipariş detaylarında veri tutarlılığı (Referential Integrity) bozulmaz.

### 1.3 Askıda Yemek Modülü Çalışma Mantığı
Bu modül, maddi durumu yetersiz olan onaylı "İhtiyaç Sahibi" kullanıcıların platformdaki hayırseverlerin bağışladığı bakiye havuzunu kullanarak ücretsiz sipariş verebilmesini sağlar.

1. **Bağış Yapma**: Müşteriler "Askıda Yemek" havuzuna diledikleri miktarda bakiye bağışlayabilir. 
2. **Gizlilik**: Bağış yaparken `IsAnonymous` (Anonim mi?) bayrağı kullanılarak bağışçının kimliği gizlenebilir. Eğer anonim istenmişse, bağış hareketlerinde kullanıcı bilgisi arayüzde gösterilmez (ancak veritabanında log amaçlı tutulabilir).
3. **Havuz Bakiyesi**: `AskidaYemekHavuzu` tablosunda sistemde biriken toplam kullanılabilir bakiye tek bir satır halinde güncel olarak tutulur. Yapılan her bağış, bir Trigger (`trg_AskidaYemekBagisi`) ile bu bakiyeyi otomatik artırır.
4. **Sipariş ve Bakiye Kullanımı**: "İhtiyaç Sahibi" statüsündeki bir kullanıcı sipariş verirken `IsAskidaYemek = 1` bayrağı ile sipariş oluşturur.
5. **Otomatik Bakiye Düşümü**: Sipariş onaylandığında, sepet tutarı Trigger (`trg_AskidaYemekKullanimi`) aracılığıyla `AskidaYemekHavuzu`'ndan otomatik olarak düşülür. Havuzda yeterli bakiye yoksa bu sipariş oluşturulamaz (Stored Procedure veya uygulama katmanında bu kontrol yapılır).

### 1.4 Sipariş Kuralları
- **Sepet Tutarı**: Siparişin toplam tutarı 0'dan büyük olmalıdır (İstisna: Askıda Yemek ise uygulama katmanı 0 gösterebilir ama veritabanında asıl tutar tutulur ve havuzdan düşülür).
- **Ciro Hesaplama**: Bir sipariş kurye tarafından "Teslim Edildi" (Delivered) statüsüne çekildiğinde, restoranın toplam kazancı (`TotalRevenue`) Trigger (`trg_SiparisTeslimCiroGuncelle`) ile otomatik olarak güncellenir.

---

## 2. Yapay Zeka (AI) Kullanım Beyanı

Bu projenin tasarımı ve geliştirilmesi sırasında **Google Gemini** yapay zeka asistanı olarak kullanılmıştır.

**Kullanım Aşamaları ve Amaçları:**
1. **Şema Tasarımı ve Fikir Alışverişi**: "Askıda Yemek" modülünün bakiyesini yönetmek için en mantıklı ilişkinin nasıl kurulacağı konusunda (havuz tablosu vs log tablosu mantığı) tartışılmış ve tek satırlık havuz + detaylı log tablosu mimarisine karar verilmiştir.
2. **Mock Data (Test Verisi) Üretimi**: DML aşamasında istenen "5 restoran, 50 ürün, 100 sipariş" gibi yoğun test verilerinin anlamlı (gerçekçi yemek isimleri, fiyatları vb.) ve hızlı bir şekilde oluşturulması için AI destekli veri üretimi yapılmıştır.
3. **Trigger ve Analitik Sorgu Optimizasyonu**: Yazılan GROUP BY, HAVING ve alt sorguların (Subquery) doğru çalışıp çalışmadığını doğrulamak ve trigger'ların mutation hatalarına düşmesini engellemek için AI'dan syntax kontrolü desteği alınmıştır.

*Bu beyan doğrultusunda, veritabanı projemde bulunan tüm tabloların yapılarına, kısıtlamalarına ve ileri düzey SQL nesnelerinin çalışma mantığına tamamen hakim olduğumu, olası bir rastgele doğrulama veya kod inceleme sınavında her bir satırı bağımsız olarak savunabileceğimi taahhüt ederim.*
