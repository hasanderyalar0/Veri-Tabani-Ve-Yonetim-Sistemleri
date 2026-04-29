-- =======================================================================================
-- VTYS-1 Dönem Projesi: Çevrimiçi Yemek Sipariş Platformu ve Askıda Yemek Modülü
-- Aşama 1: Veri Tanımlama Dili (DDL) ve Kısıtlamalar (Constraints)
-- =======================================================================================

-- 1. USERS (Kullanıcılar) Tablosu
-- Müşteriler, İhtiyaç Sahipleri ve Kuryeler bu tabloda tutulur.
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    UserType VARCHAR(20) NOT NULL CHECK (UserType IN ('Customer', 'Courier', 'VerifiedNeedy')),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20) NOT NULL UNIQUE,
    PasswordHash VARCHAR(256) NOT NULL,
    IsActive BIT DEFAULT 1, -- Soft Delete mekanizması
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 2. RESTAURANTS (Restoranlar) Tablosu
CREATE TABLE Restaurants (
    RestaurantID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Phone VARCHAR(20) NOT NULL UNIQUE,
    Rating DECIMAL(3,2) DEFAULT 0.0 CHECK (Rating BETWEEN 1 AND 5 OR Rating = 0.0), -- 0.0 henüz puan almamış demek
    TotalRevenue DECIMAL(18,2) DEFAULT 0.0,
    IsActive BIT DEFAULT 1, -- Soft Delete
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 3. CATEGORIES (Kategoriler) Tablosu
-- Menü kategorileri (Örn: Tatlılar, İçecekler, Ana Yemekler)
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(50) NOT NULL,
    IsActive BIT DEFAULT 1
);

-- 4. PRODUCTS (Ürünler) Tablosu
-- Restoranların menü kalemleri
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    RestaurantID INT NOT NULL,
    CategoryID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Description VARCHAR(255),
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0), -- Fiyat 0'dan büyük olmalı (CHECK Constraint)
    IsActive BIT DEFAULT 1, -- Soft Delete
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- 5. ASKIDA YEMEK HAVUZU (ÖZEL MODÜL)
-- Sistemdeki toplam askıda yemek bakiyesini tutan tablo (Tek satır mantığıyla çalışır)
CREATE TABLE AskidaYemekHavuzu (
    PoolID INT PRIMARY KEY IDENTITY(1,1),
    CurrentBalance DECIMAL(18,2) DEFAULT 0.0 CHECK (CurrentBalance >= 0), -- Bakiye eksiye düşemez
    TotalDonated DECIMAL(18,2) DEFAULT 0.0,
    LastUpdatedAt DATETIME DEFAULT GETDATE()
);

-- 6. ASKIDA YEMEK BAĞIŞLARI (LOG TABLOSU)
-- Kimin, ne zaman havuz için ne bağışladığını tutar (Yemek veya Para).
CREATE TABLE AskidaYemekBagislari (
    DonationID INT PRIMARY KEY IDENTITY(1,1),
    DonorID INT NULL, -- Anonim bağışlarda NULL olabilir
    DonationType VARCHAR(10) NOT NULL CHECK (DonationType IN ('Money', 'Food')), -- Para mı, Yemek mi?
    Amount DECIMAL(18,2) NULL CHECK (Amount > 0 OR Amount IS NULL), -- Para bağışıysa tutar
    ProductID INT NULL, -- Yemek bağışıysa hangi ürün
    Quantity INT NULL CHECK (Quantity > 0 OR Quantity IS NULL), -- Yemek bağışıysa kaç adet
    IsAnonymous BIT DEFAULT 0,
    DonationDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (DonorID) REFERENCES Users(UserID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    -- Kısıtlama: Para ise Amount dolu olmalı, Yemek ise ProductID ve Quantity dolu olmalı
    CHECK (
        (DonationType = 'Money' AND Amount IS NOT NULL AND ProductID IS NULL AND Quantity IS NULL) OR
        (DonationType = 'Food' AND ProductID IS NOT NULL AND Quantity IS NOT NULL AND Amount IS NULL)
    )
);

-- 7. ORDERS (Siparişler) Tablosu
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    RestaurantID INT NOT NULL,
    CourierID INT NULL, -- Sipariş ilk verildiğinde kurye atanmamış olabilir
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(18,2) NOT NULL CHECK (TotalAmount >= 0),
    OrderStatus VARCHAR(20) DEFAULT 'Pending' CHECK (OrderStatus IN ('Pending', 'Preparing', 'OnTheWay', 'Delivered', 'Cancelled')),
    IsAskidaYemekUsed BIT DEFAULT 0, -- 1 ise ödeme havuzdan karşılanmış demektir.
    IsActive BIT DEFAULT 1, -- Soft Delete
    FOREIGN KEY (CustomerID) REFERENCES Users(UserID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurants(RestaurantID),
    FOREIGN KEY (CourierID) REFERENCES Users(UserID)
);

-- 8. ORDER DETAILS (Sipariş Detayları) Tablosu
-- Bir siparişteki kalemlerin (ürünlerin) listesi
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0), -- En az 1 adet alınmalı
    UnitPrice DECIMAL(10,2) NOT NULL,
    SubTotal DECIMAL(18,2) NOT NULL, -- Quantity * UnitPrice
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- =======================================================================================
-- İNDEKS (INDEX) OLUŞTURMA
-- Performans artışı için aramaların sık yapılacağı sütunlara Non-Clustered index ekleniyor.
-- =======================================================================================

-- 1. Index: Kullanıcıların Email ve Telefon ile giriş yapmalarını hızlandırmak için
CREATE NONCLUSTERED INDEX IX_Users_Email ON Users(Email);
CREATE NONCLUSTERED INDEX IX_Users_Phone ON Users(Phone);

-- 2. Index: Restoran arama ve listelemelerini hızlandırmak için (Sadece Aktif olanlar)
CREATE NONCLUSTERED INDEX IX_Restaurants_IsActive ON Restaurants(IsActive);

-- 3. Index: Müşterinin kendi geçmiş siparişlerini hızlıca listelemesi için
CREATE NONCLUSTERED INDEX IX_Orders_CustomerID ON Orders(CustomerID);
