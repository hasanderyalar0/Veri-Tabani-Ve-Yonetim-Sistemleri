-- =======================================================================================
-- VTYS-1 Dönem Projesi: Çevrimiçi Yemek Sipariş Platformu ve Askıda Yemek Modülü
-- Aşama 5: İleri Düzey Sorgular (DQL & Analitik)
-- =======================================================================================

-- =======================================================================================
-- 1. JOIN KULLANIMI: Detaylı Sipariş Fişi Sorgusu (En az 3 tablo)
-- Siparişin hangi müşteri tarafından, hangi restorandan, hangi kurye ile teslim edildiğini 
-- ve içinde hangi ürünlerin bulunduğunu listeleyen detaylı fiş.
-- (LEFT JOIN kullanılarak henüz kuryesi atanmamış siparişler de listelenir)
-- =======================================================================================

SELECT 
    O.OrderID AS SiparisNo,
    O.OrderDate AS SiparisTarihi,
    C.FirstName + ' ' + C.LastName AS MusteriAdi,
    R.Name AS RestoranAdi,
    ISNULL(Cr.FirstName + ' ' + Cr.LastName, 'Kurye Atanmadi') AS KuryeAdi,
    P.Name AS UrunAdi,
    OD.Quantity AS Adet,
    OD.UnitPrice AS BirimFiyat,
    OD.SubTotal AS AraToplam,
    O.TotalAmount AS FisToplami,
    CASE 
        WHEN O.IsAskidaYemekUsed = 1 THEN 'Askıda Yemek Kullanıldı (Ücretsiz)'
        ELSE 'Müşteri Ödedi'
    END AS OdemeYontemi
FROM Orders O
INNER JOIN Users C ON O.CustomerID = C.UserID
INNER JOIN Restaurants R ON O.RestaurantID = R.RestaurantID
LEFT JOIN Users Cr ON O.CourierID = Cr.UserID
INNER JOIN OrderDetails OD ON O.OrderID = OD.OrderID
INNER JOIN Products P ON OD.ProductID = P.ProductID
WHERE O.IsActive = 1
ORDER BY O.OrderDate DESC;

-- =======================================================================================
-- 2. AGREGASYON VE GRUPLAMA: Analitik Performans Sorgusu
-- Son 1 ayda (30 gün) toplam 5'ten fazla sipariş alan restoranların
-- ortalama sepet tutarlarını ve toplam sipariş sayılarını listeleyen sorgu.
-- (COUNT, AVG, GROUP BY, HAVING kullanımı)
-- =======================================================================================

SELECT 
    R.Name AS RestoranAdi,
    COUNT(O.OrderID) AS ToplamSiparisSayisi,
    SUM(O.TotalAmount) AS ToplamCiro,
    AVG(O.TotalAmount) AS OrtalamaSepetTutari
FROM Restaurants R
INNER JOIN Orders O ON R.RestaurantID = O.RestaurantID
WHERE O.OrderDate >= DATEADD(day, -30, GETDATE())
  AND O.OrderStatus = 'Delivered'
GROUP BY R.Name
HAVING COUNT(O.OrderID) > 5
ORDER BY OrtalamaSepetTutari DESC;

-- =======================================================================================
-- 3. ALT SORGU (SUBQUERY): Müşteri Analizi (NOT EXISTS / IN Kullanımı)
-- Platformu aktif kullanan (en az 1 sipariş vermiş) ANCAK şu ana kadar "Askıda Yemek" 
-- havuzuna HİÇ BAĞIŞ YAPMAMIŞ müşterilerin listesi.
-- Bu sorgu, pazarlama ekibinin bu kişilere "Bağış yapmak ister misiniz?" bildirimi 
-- göndermesi için kullanılabilir.
-- =======================================================================================

SELECT 
    U.UserID,
    U.FirstName,
    U.LastName,
    U.Email,
    (SELECT COUNT(*) FROM Orders O WHERE O.CustomerID = U.UserID) AS VerdigiSiparisSayisi
FROM Users U
WHERE U.UserType = 'Customer'
  AND U.IsActive = 1
  -- Alt Sorgu 1: Platformu aktif kullanmış (en az 1 sipariş vermiş)
  AND U.UserID IN (
      SELECT DISTINCT CustomerID 
      FROM Orders
  )
  -- Alt Sorgu 2: Askıda Yemek havuzuna hiç bağış yapmamış (NOT EXISTS)
  AND NOT EXISTS (
      SELECT 1 
      FROM AskidaYemekBagislari A 
      WHERE A.DonorID = U.UserID
  )
ORDER BY VerdigiSiparisSayisi DESC;
