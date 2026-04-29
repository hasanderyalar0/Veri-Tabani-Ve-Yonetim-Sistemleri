-- =======================================================================================
-- VTYS-1 Dönem Projesi: Çevrimiçi Yemek Sipariş Platformu ve Askıda Yemek Modülü
-- Aşama 4: Veri Manipülasyonu (DML - Mock Data) ve Soft Delete
-- =======================================================================================

SET NOCOUNT ON;

-- 1. USERS (Müşteriler, Kuryeler, İhtiyaç Sahipleri) (En az 20 istenmişti, 25 adet ekliyoruz)
INSERT INTO Users (UserType, FirstName, LastName, Email, Phone, PasswordHash) VALUES
('Customer', 'Ahmet', 'Yilmaz', 'ahmet.yilmaz@mail.com', '5321112233', 'hash1'),
('Customer', 'Ayse', 'Kaya', 'ayse.kaya@mail.com', '5332223344', 'hash2'),
('Customer', 'Mehmet', 'Demir', 'mehmet.demir@mail.com', '5343334455', 'hash3'),
('Customer', 'Fatma', 'Celik', 'fatma.celik@mail.com', '5354445566', 'hash4'),
('Customer', 'Ali', 'Can', 'ali.can@mail.com', '5365556677', 'hash5'),
('Customer', 'Veli', 'Gok', 'veli.gok@mail.com', '5376667788', 'hash6'),
('Customer', 'Zeynep', 'Turk', 'zeynep.turk@mail.com', '5387778899', 'hash7'),
('Customer', 'Elif', 'Yildiz', 'elif.yildiz@mail.com', '5398889900', 'hash8'),
('Customer', 'Burak', 'Sahin', 'burak.sahin@mail.com', '5411112233', 'hash9'),
('Customer', 'Cem', 'Ozturk', 'cem.ozturk@mail.com', '5422223344', 'hash10'),
('Customer', 'Deniz', 'Arslan', 'deniz.arslan@mail.com', '5433334455', 'hash11'),
('Customer', 'Emre', 'Tekin', 'emre.tekin@mail.com', '5444445566', 'hash12'),
('Customer', 'Fatih', 'Bulut', 'fatih.bulut@mail.com', '5455556677', 'hash13'),
('Customer', 'Gizem', 'Koc', 'gizem.koc@mail.com', '5466667788', 'hash14'),
('Customer', 'Hasan', 'Turan', 'hasan.turan@mail.com', '5477778899', 'hash15'),
('VerifiedNeedy', 'Ihsan', 'Garip', 'ihsan.garip@mail.com', '5511112233', 'hash16'),
('VerifiedNeedy', 'Kemal', 'Yoksul', 'kemal.yoksul@mail.com', '5522223344', 'hash17'),
('VerifiedNeedy', 'Leyla', 'Dertli', 'leyla.dertli@mail.com', '5533334455', 'hash18'),
('VerifiedNeedy', 'Murat', 'Fakir', 'murat.fakir@mail.com', '5544445566', 'hash19'),
('VerifiedNeedy', 'Nermin', 'Muhtac', 'nermin.muhtac@mail.com', '5555556677', 'hash20'),
('Courier', 'Osman', 'Hizli', 'osman.hizli@mail.com', '5611112233', 'hash21'),
('Courier', 'Pelin', 'Ucan', 'pelin.ucan@mail.com', '5622223344', 'hash22'),
('Courier', 'Riza', 'Kosan', 'riza.kosan@mail.com', '5633334455', 'hash23'),
('Courier', 'Selin', 'Kurye', 'selin.kurye@mail.com', '5644445566', 'hash24'),
('Courier', 'Tolga', 'Motor', 'tolga.motor@mail.com', '5655556677', 'hash25');

-- 2. RESTAURANTS (En az 5 restoran)
INSERT INTO Restaurants (Name, Address, Phone, Rating) VALUES
('Burger King', 'Kadıköy Meydan', '02161112233', 4.2),
('Dominos Pizza', 'Besiktas Carsi', '02122223344', 4.5),
('Kebapci Celal', 'Sisli Merkez', '02123334455', 4.8),
('Vegan Mutfak', 'Moda Kadıkoy', '02164445566', 4.1),
('Tatli Dunyasi', 'Uskudar Sahil', '02165556677', 4.6),
('Sushico', 'Nisantasi', '02126667788', 4.3);

-- 3. CATEGORIES (Kategoriler)
INSERT INTO Categories (Name) VALUES
('Ana Yemek'), ('Ara Sicak'), ('Icecek'), ('Tatli'), ('Fast Food');

-- 4. PRODUCTS (En az 50 ürün, farklı restoranlara dağıtılmış)
-- Burger King (Restoran 1)
INSERT INTO Products (RestaurantID, CategoryID, Name, Description, Price) VALUES
(1, 5, 'Whopper Menü', 'Büyük boy patates ve içecek ile', 150.00),
(1, 5, 'Chicken Royale', 'Tavuklu burger', 120.00),
(1, 5, 'King Chicken Menü', 'Orta boy patates ve içecek ile', 130.00),
(1, 5, 'Steakhouse Burger', 'Özel soslu et burger', 180.00),
(1, 5, 'Texas Smokehouse', 'Füme etli burger', 190.00),
(1, 2, 'Soğan Halkası (8li)', 'Çıtır soğan halkası', 40.00),
(1, 2, 'Tavuk Parçaları (6lı)', 'Nugget', 50.00),
(1, 3, 'Kutu Kola', '330 ml', 30.00),
(1, 3, 'Ayran', 'Büyük boy', 20.00),
(1, 4, 'Sundae Çikolata', 'Sütlü dondurma', 45.00);

-- Dominos Pizza (Restoran 2)
INSERT INTO Products (RestaurantID, CategoryID, Name, Description, Price) VALUES
(2, 5, 'Margarita Pizza', 'Domates sos ve mozzarella', 160.00),
(2, 5, 'Karışık Pizza', 'Sucuk, sosis, mantar, biber', 200.00),
(2, 5, 'Pepperoni Pizza', 'Bol baharatlı pepperoni', 190.00),
(2, 5, 'Extravaganzza', 'Özel Dominos spesiyal', 220.00),
(2, 5, 'Tavuklu Pizza', 'Barbekü soslu tavuk', 180.00),
(2, 2, 'Sarımsaklı Ekmek', 'Özel soslu fırınlanmış ekmek', 40.00),
(2, 2, 'Tavuk Kanatları', 'Acı soslu kanat', 80.00),
(2, 3, 'Kutu Sprite', '330 ml', 30.00),
(2, 3, 'Büyük Ayran', '300 ml', 20.00),
(2, 4, 'Sufle', 'Akışkan çikolatalı sufle', 60.00);

-- Kebapci Celal (Restoran 3)
INSERT INTO Products (RestaurantID, CategoryID, Name, Description, Price) VALUES
(3, 1, 'Adana Kebap', 'Acılı zırh kıyması', 250.00),
(3, 1, 'Urfa Kebap', 'Acısız kıyma kebabı', 240.00),
(3, 1, 'Kuzu Şiş', 'Özel terbiye edilmiş kuzu eti', 280.00),
(3, 1, 'Tavuk Şiş', 'Mangalda tavuk', 180.00),
(3, 1, 'İskender', 'Tereyağlı, yoğurtlu özel soslu', 300.00),
(3, 2, 'İçli Köfte', 'Cevizli ve kıymalı (Adet)', 45.00),
(3, 2, 'Lahmacun', 'Çıtır hamur, bol malzeme', 60.00),
(3, 3, 'Şalgam Suyu', 'Acılı / Acısız', 25.00),
(3, 3, 'Açık Ayran', 'Köpüklü yayık ayranı', 30.00),
(3, 4, 'Künefe', 'Hatay usulü peynirli künefe', 90.00);

-- Vegan Mutfak (Restoran 4)
INSERT INTO Products (RestaurantID, CategoryID, Name, Description, Price) VALUES
(4, 1, 'Vegan Burger', 'Bitkisel köfteli', 160.00),
(4, 1, 'Falafel Dürüm', 'Humus ve taze yeşillik ile', 130.00),
(4, 1, 'Kinoa Salatası', 'Avokado ve nar ekşisi ile', 140.00),
(4, 1, 'Vegan Mantı', 'Mercimek dolgulu', 150.00),
(4, 1, 'Sebze Izgara', 'Mevsim sebzeleri', 120.00),
(4, 2, 'Humus', 'Zeytinyağlı', 60.00),
(4, 2, 'Mücver', 'Fırınlanmış', 70.00),
(4, 3, 'Taze Portakal Suyu', 'Sıkma portakal', 50.00),
(4, 3, 'Kombucha', 'Ev yapımı fermente çay', 60.00),
(4, 4, 'Vegan Brownie', 'Sütsüz, şekersiz', 80.00);

-- Tatli Dunyasi (Restoran 5)
INSERT INTO Products (RestaurantID, CategoryID, Name, Description, Price) VALUES
(5, 4, 'Sütlaç', 'Fırın sütlaç', 70.00),
(5, 4, 'Kazandibi', 'Yanık sütlü tatlı', 75.00),
(5, 4, 'Tiramisu', 'Mascarpone peynirli', 90.00),
(5, 4, 'Cheesecake', 'Limonlu veya Frambuazlı', 95.00),
(5, 4, 'Profiterol', 'Bol çikolata soslu', 85.00),
(5, 4, 'Baklava', 'Fıstıklı (Porsiyon)', 120.00),
(5, 4, 'Trileçe', 'Karamelli', 80.00),
(5, 3, 'Türk Kahvesi', 'Sade/Orta/Şekerli', 40.00),
(5, 3, 'Filtre Kahve', 'Taze demlenmiş', 50.00),
(5, 3, 'Çay', 'İnce belli bardakta', 15.00);

-- 5. ASKIDA YEMEK BAĞIŞLARI (Mock Data)
-- Trigger (trg_AskidaYemekBagisi) sayesinde bu kayıtlar eklendikçe havuz tablosu da güncellenecektir.
INSERT INTO AskidaYemekBagislari (DonorID, DonationType, Amount, ProductID, Quantity, IsAnonymous, DonationDate) VALUES
(1, 'Money', 500.00, NULL, NULL, 0, DATEADD(day, -10, GETDATE())),
(2, 'Food', NULL, 1, 2, 1, DATEADD(day, -8, GETDATE())), -- 2 adet Whopper Menu (150x2 = 300 TL havuza yansır)
(5, 'Money', 1000.00, NULL, NULL, 0, DATEADD(day, -5, GETDATE())),
(10, 'Food', NULL, 12, 1, 1, DATEADD(day, -2, GETDATE())), -- 1 adet Karışık Pizza (200 TL havuza yansır)
(12, 'Money', 450.00, NULL, NULL, 0, GETDATE());

-- 6. ORDERS VE ORDERDETAILS (En az 100 sipariş hareketi)
-- 100 adet siparişi T-SQL WHILE döngüsü ile rastgele oluşturuyoruz
DECLARE @Counter INT = 1;
DECLARE @RandCust INT, @RandRest INT, @RandCour INT, @RandProd INT, @RandQty INT, @RandStatus INT;
DECLARE @UnitPrice DECIMAL(10,2), @SubTotal DECIMAL(18,2), @TotalAmount DECIMAL(18,2);
DECLARE @OrderID INT, @IsAskida BIT, @OrderDate DATETIME;

WHILE @Counter <= 100
BEGIN
    -- Rastgele değerler üret
    SET @RandCust = (ABS(CHECKSUM(NEWID())) % 15) + 1; -- 1-15 arası Müşteri
    SET @RandRest = (ABS(CHECKSUM(NEWID())) % 5) + 1; -- 1-5 arası Restoran
    SET @RandCour = (ABS(CHECKSUM(NEWID())) % 5) + 21; -- 21-25 arası Kurye
    SET @RandStatus = ABS(CHECKSUM(NEWID())) % 4; -- 0,1,2,3
    
    DECLARE @StatusStr VARCHAR(20);
    SET @StatusStr = CASE @RandStatus 
                        WHEN 0 THEN 'Pending' 
                        WHEN 1 THEN 'Preparing' 
                        WHEN 2 THEN 'OnTheWay' 
                        WHEN 3 THEN 'Delivered' 
                     END;

    -- Tarihi son 30 gün içinde rastgele belirle
    SET @OrderDate = DATEADD(day, -(ABS(CHECKSUM(NEWID())) % 30), GETDATE());

    -- %10 ihtimalle Askıda Yemek kullanılsın (ve Müşteri İhtiyaç Sahibi olsun)
    IF (@Counter % 10 = 0)
    BEGIN
        SET @IsAskida = 1;
        SET @RandCust = (ABS(CHECKSUM(NEWID())) % 5) + 16; -- 16-20 arası İhtiyaç Sahibi
    END
    ELSE
    BEGIN
        SET @IsAskida = 0;
    END

    -- Siparişi Başlangıçta 0 Tutar ile oluştur
    INSERT INTO Orders (CustomerID, RestaurantID, CourierID, OrderDate, TotalAmount, OrderStatus, IsAskidaYemekUsed)
    VALUES (@RandCust, @RandRest, @RandCour, @OrderDate, 0, @StatusStr, @IsAskida);
    
    SET @OrderID = SCOPE_IDENTITY();
    SET @TotalAmount = 0;

    -- Siparişe rastgele 1 ila 3 ürün ekle
    DECLARE @DetailCount INT = (ABS(CHECKSUM(NEWID())) % 3) + 1;
    DECLARE @D INT = 1;
    
    WHILE @D <= @DetailCount
    BEGIN
        -- Bu restoranın rastgele bir ürününü seç
        SELECT TOP 1 @RandProd = ProductID, @UnitPrice = Price 
        FROM Products 
        WHERE RestaurantID = @RandRest 
        ORDER BY NEWID();

        SET @RandQty = (ABS(CHECKSUM(NEWID())) % 3) + 1; -- 1-3 adet
        SET @SubTotal = @RandQty * @UnitPrice;
        SET @TotalAmount = @TotalAmount + @SubTotal;

        INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, SubTotal)
        VALUES (@OrderID, @RandProd, @RandQty, @UnitPrice, @SubTotal);

        SET @D = @D + 1;
    END

    -- Toplam tutarı güncelle
    UPDATE Orders SET TotalAmount = @TotalAmount WHERE OrderID = @OrderID;

    SET @Counter = @Counter + 1;
END;

-- =======================================================================================
-- SOFT DELETE (PASİFE ÇEKME) SENARYO TESTLERİ
-- =======================================================================================

-- 1. Senaryo: Menüden ürün kaldırma (Fiziksel olarak silinmez, pasife çekilir)
-- Örn: Burger King'in Sundae Çikolata'sı (ProductID=10) menüden kaldırılıyor.
UPDATE Products SET IsActive = 0 WHERE ProductID = 10;

-- 2. Senaryo: Restoran sistemden ayrılıyor
-- Örn: Sushico (RestaurantID=6) platformdan çekildi.
UPDATE Restaurants SET IsActive = 0 WHERE RestaurantID = 6;
UPDATE Products SET IsActive = 0 WHERE RestaurantID = 6; -- Ürünleri de pasife çekiliyor

-- 3. Senaryo: Müşteri hesabını donduruyor
-- Örn: Gizem Koc (UserID=14)
UPDATE Users SET IsActive = 0 WHERE UserID = 14;

GO
