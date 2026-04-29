-- =======================================================================================
-- VTYS-1 Dönem Projesi: Çevrimiçi Yemek Sipariş Platformu ve Askıda Yemek Modülü
-- Aşama 3: İleri Düzey Nesneler (Tetikleyiciler - Triggers)
-- =======================================================================================

-- =======================================================================================
-- TETİKLEYİCİLER (TRIGGERS)
-- =======================================================================================

-- 1. Trigger: Sipariş "Teslim Edildi" olduğunda restoranın toplam cirosunu güncelle (trg_SiparisTeslimCiroGuncelle)
CREATE TRIGGER trg_SiparisTeslimCiroGuncelle
ON Orders
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Eğer OrderStatus güncellenmişse ve yeni durum 'Delivered' ise
    IF UPDATE(OrderStatus)
    BEGIN
        -- Ciro artışı yapılacak restoranları bul ve güncelle
        UPDATE r
        SET r.TotalRevenue = r.TotalRevenue + i.TotalAmount
        FROM Restaurants r
        INNER JOIN inserted i ON r.RestaurantID = i.RestaurantID
        INNER JOIN deleted d ON i.OrderID = d.OrderID
        WHERE i.OrderStatus = 'Delivered' 
          AND d.OrderStatus <> 'Delivered'; -- Sadece yeni teslim edildiyse (mükerrer güncellemeyi önler)
    END
END;
GO

-- 2. Trigger: Yeni bağış yapıldığında havuz bakiyesini otomatik artır (trg_AskidaYemekBagisi)
CREATE TRIGGER trg_AskidaYemekBagisi
ON AskidaYemekBagislari
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ToplamYeniBagis DECIMAL(18,2);

    -- Yeni eklenen bağışların toplamını al (Bulk insert ihtimaline karşı SUM kullanılır)
    -- Özel Kural: Para bağışıysa tutarı doğrudan al, Yemek bağışıysa (Ürün Fiyatı * Adet) hesaplayıp havuza parasal değer olarak ekle
    SELECT @ToplamYeniBagis = SUM(
        CASE 
            WHEN i.DonationType = 'Money' THEN i.Amount
            WHEN i.DonationType = 'Food' THEN p.Price * i.Quantity
            ELSE 0
        END
    ) 
    FROM inserted i
    LEFT JOIN Products p ON i.ProductID = p.ProductID;

    IF @ToplamYeniBagis IS NOT NULL
    BEGIN
        -- Havuzu güncelle (Eğer havuz tablosu boşsa ilk satırı ekle, doluysa güncelle)
        IF EXISTS (SELECT 1 FROM AskidaYemekHavuzu)
        BEGIN
            UPDATE AskidaYemekHavuzu
            SET CurrentBalance = CurrentBalance + @ToplamYeniBagis,
                TotalDonated = TotalDonated + @ToplamYeniBagis,
                LastUpdatedAt = GETDATE();
        END
        ELSE
        BEGIN
            INSERT INTO AskidaYemekHavuzu (CurrentBalance, TotalDonated, LastUpdatedAt)
            VALUES (@ToplamYeniBagis, @ToplamYeniBagis, GETDATE());
        END
    END
END;
GO

-- 3. Trigger: Askıda yemek kullanılarak sipariş verilirse havuzdan bakiyeyi düş (trg_AskidaYemekKullanimi)
CREATE TRIGGER trg_AskidaYemekKullanimi
ON Orders
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @KullanilanToplam DECIMAL(18,2);

    -- Askıda yemek kullanılan (IsAskidaYemekUsed = 1) yeni siparişlerin toplam tutarını hesapla
    SELECT @KullanilanToplam = SUM(TotalAmount) 
    FROM inserted 
    WHERE IsAskidaYemekUsed = 1;

    IF @KullanilanToplam IS NOT NULL AND @KullanilanToplam > 0
    BEGIN
        -- Mevcut bakiyeyi kontrol et
        DECLARE @MevcutBakiye DECIMAL(18,2);
        SELECT @MevcutBakiye = CurrentBalance FROM AskidaYemekHavuzu;

        IF @MevcutBakiye >= @KullanilanToplam
        BEGIN
            -- Yeterli bakiye varsa düş
            UPDATE AskidaYemekHavuzu
            SET CurrentBalance = CurrentBalance - @KullanilanToplam,
                LastUpdatedAt = GETDATE();
        END
        ELSE
        BEGIN
            -- Yeterli bakiye yoksa hata fırlat ve işlemi iptal et (Rollback)
            RAISERROR ('Hata: Askida Yemek Havuzunda yeterli bakiye bulunmamaktadir.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
    END
END;
GO
