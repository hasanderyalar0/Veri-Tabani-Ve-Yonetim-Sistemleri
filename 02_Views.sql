-- =======================================================================================
-- VTYS-1 Dönem Projesi: Çevrimiçi Yemek Sipariş Platformu ve Askıda Yemek Modülü
-- Aşama 2: İleri Düzey Nesneler (Görünümler - Views)
-- =======================================================================================

-- =======================================================================================
-- GÖRÜNÜMLER (VIEWS)
-- =======================================================================================

-- 1. View: Aktif Restoran Menüleri (vw_AktifRestoranMenuleri)
-- Sadece silinmemiş (IsActive=1) restoranların silinmemiş ürünlerini ve kategorilerini listeler.
CREATE VIEW vw_AktifRestoranMenuleri AS
SELECT 
    r.Name AS RestoranAdi,
    c.Name AS KategoriAdi,
    p.Name AS UrunAdi,
    p.Description AS Aciklama,
    p.Price AS Fiyat
FROM 
    Products p
INNER JOIN 
    Restaurants r ON p.RestaurantID = r.RestaurantID
INNER JOIN 
    Categories c ON p.CategoryID = c.CategoryID
WHERE 
    p.IsActive = 1 
    AND r.IsActive = 1 
    AND c.IsActive = 1;
GO

-- 2. View: Askıda Yemek Havuz Durumu (vw_AskidaYemekHavuzDurumu)
-- Havuzun anlık bakiyesini ve şu ana kadar yapılan toplam bağışı güvenli bir şekilde görüntüler.
CREATE VIEW vw_AskidaYemekHavuzDurumu AS
SELECT 
    PoolID,
    CurrentBalance AS MevcutKullanilabilirBakiye,
    TotalDonated AS BuguneKadarToplananBagis,
    LastUpdatedAt AS SonGuncellemeTarihi
FROM 
    AskidaYemekHavuzu;
