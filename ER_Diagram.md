# Varlık-İlişki (ER) Diyagramı

Aşağıdaki diyagram, Çevrimiçi Yemek Sipariş Platformu ve "Askıda Yemek" modülünün veritabanı tablolarını ve aralarındaki ilişkileri (Primary Key - Foreign Key) göstermektedir.

```mermaid
erDiagram
    USERS {
        int UserID PK
        varchar UserType "Customer, Courier, VerifiedNeedy"
        varchar FirstName
        varchar LastName
        varchar Email "UNIQUE"
        varchar Phone "UNIQUE"
        varchar PasswordHash
        bit IsActive
        datetime CreatedAt
    }

    RESTAURANTS {
        int RestaurantID PK
        varchar Name
        varchar Address
        varchar Phone
        decimal Rating "CHECK 1-5"
        decimal TotalRevenue
        bit IsActive
        datetime CreatedAt
    }

    CATEGORIES {
        int CategoryID PK
        varchar Name
        bit IsActive
    }

    PRODUCTS {
        int ProductID PK
        int RestaurantID FK
        int CategoryID FK
        varchar Name
        varchar Description
        decimal Price "CHECK > 0"
        bit IsActive
    }

    ASKIDA_YEMEK_HAVUZU {
        int PoolID PK
        decimal CurrentBalance "CHECK >= 0"
        decimal TotalDonated
        datetime LastUpdatedAt
    }

    ASKIDA_YEMEK_BAGISLARI {
        int DonationID PK
        int DonorID FK "Can be NULL if anonymous"
        varchar DonationType "Money or Food"
        decimal Amount "Para bağışıysa tutar"
        int ProductID FK "Yemek bağışıysa ürün"
        int Quantity "Yemek bağışıysa adet"
        bit IsAnonymous
        datetime DonationDate
    }

    ORDERS {
        int OrderID PK
        int CustomerID FK
        int RestaurantID FK
        int CourierID FK "Can be NULL initially"
        datetime OrderDate
        decimal TotalAmount "CHECK >= 0"
        varchar OrderStatus "Pending, Preparing, OnTheWay, Delivered, Cancelled"
        bit IsAskidaYemekUsed
        bit IsActive
    }

    ORDER_DETAILS {
        int OrderDetailID PK
        int OrderID FK
        int ProductID FK
        int Quantity "CHECK > 0"
        decimal UnitPrice
        decimal SubTotal
    }

    %% İLİŞKİLER (RELATIONSHIPS)
    USERS ||--o{ ORDERS : "Places/Receives (Customer)"
    USERS ||--o{ ORDERS : "Delivers (Courier)"
    USERS ||--o{ ASKIDA_YEMEK_BAGISLARI : "Donates"
    PRODUCTS ||--o{ ASKIDA_YEMEK_BAGISLARI : "Donated As"
    RESTAURANTS ||--o{ PRODUCTS : "Has Menu"
    RESTAURANTS ||--o{ ORDERS : "Receives Order"
    CATEGORIES ||--o{ PRODUCTS : "Categorizes"
    ORDERS ||--|{ ORDER_DETAILS : "Contains"
    PRODUCTS ||--o{ ORDER_DETAILS : "Included in"
```

## İlişki Açıklamaları
- **1:N (Bire Çok)**: Bir müşteri (Users) birden fazla sipariş (Orders) verebilir. (Aynı şekilde kurye birden çok sipariş taşıyabilir).
- **1:N (Bire Çok)**: Bir restoranın birden fazla ürünü (Products) ve siparişi (Orders) olabilir.
- **1:N (Bire Çok)**: Bir kategoride birden fazla ürün bulunabilir.
- **1:N (Bire Çok)**: Bir müşteri (veya ihtiyaç sahibi olmayanlar) birden fazla askıda yemek bağışı (AskidaYemekBagislari) yapabilir.
- **1:N (Bire Çok)**: Bir siparişin içinde birden fazla sipariş detayı (OrderDetails) yani farklı ürün kalemleri bulunabilir.
- **1:N (Bire Çok)**: Bir ürün, birden fazla sipariş detayında (OrderDetails) yer alabilir.
- *AskidaYemekHavuzu* tablosu sistemde tek satır olarak (Singleton benzeri) durur, doğrudan bir Foreign Key bağı yoktur ancak Trigger'lar aracılığıyla Siparişler ve Bağışlar tablolarıyla iş kuralları (Business Logic) gereği bağlantılıdır.
