# Kazimierza — Model Danych MVP

## Diagram relacji

```
District ←──────────────── Venue ────────────────→ Category
    ↑                         ↑
    │                         │
UserDistrict              Offer
    │                         ↑
    ↓                         │
  User ←── UserFavoriteVenue  │
    ↑                         │
    └──────── Redemption ─────┘
```

## Encje

### District (Dzielnica)

```
District
├── id: UUID
├── name: VARCHAR(100)           -- "Jana Kazimierza"
├── slug: VARCHAR(50) UNIQUE     -- "kazimierza"
├── center_lat: DECIMAL(10,8)
├── center_lng: DECIMAL(11,8)
├── radius_km: DECIMAL(3,1)      -- np. 2.5
├── active: BOOLEAN DEFAULT true
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP
```

### Category (Kategoria lokalu)

```
Category
├── id: UUID
├── name: VARCHAR(50)            -- "Restauracja"
├── slug: VARCHAR(50) UNIQUE     -- "restaurant"
├── icon: VARCHAR(50)            -- nazwa ikony, np. "utensils"
├── sort_order: INT DEFAULT 0
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP
```

### User

```
User
├── id: UUID
├── email: VARCHAR(255) UNIQUE
├── name: VARCHAR(100)
├── avatar_url: VARCHAR(500)
├── auth_provider: ENUM('GOOGLE', 'APPLE', 'EMAIL')
├── created_at: TIMESTAMP
├── last_active_at: TIMESTAMP
└── deleted_at: TIMESTAMP        -- soft delete (GDPR)
```

### UserDistrict (Subskrypcja dzielnicy)

```
UserDistrict
├── user_id: UUID FK
├── district_id: UUID FK
├── notifications_enabled: BOOLEAN DEFAULT true
├── subscribed_at: TIMESTAMP
└── PRIMARY KEY (user_id, district_id)
```

### UserFavoriteVenue (Ulubione lokale)

```
UserFavoriteVenue
├── user_id: UUID FK
├── venue_id: UUID FK
├── added_at: TIMESTAMP
└── PRIMARY KEY (user_id, venue_id)
```

### Venue (Lokal)

```
Venue
├── id: UUID
├── district_id: UUID FK
├── category_id: UUID FK
├── owner_id: UUID FK            -- User będący właścicielem
├── name: VARCHAR(100)           -- "Burger u Kazika"
├── address: VARCHAR(200)
├── description: TEXT
├── logo_url: VARCHAR(500)
├── validation_pin: CHAR(4)      -- PIN do walidacji rabatów
├── active: BOOLEAN DEFAULT true
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP
```

### Offer (Oferta/Rabat)

```
Offer
├── id: UUID
├── venue_id: UUID FK
├── title: VARCHAR(100)          -- "Pizza -30%"
├── description: TEXT            -- "Na wszystkie pizze z menu"
├── 
├── # Forma rabatu
├── discount_type: ENUM('PERCENTAGE', 'FIXED_AMOUNT', 'FREE_ITEM')
├── discount_value: DECIMAL(10,2) -- 30 dla %, 15.00 dla kwoty, NULL dla FREE_ITEM
├── free_item_name: VARCHAR(100)  -- "kawa" (tylko dla FREE_ITEM)
├── 
├── # Czas obowiązywania
├── valid_from: DATE
├── valid_to: DATE
├── 
├── # Status
├── status: ENUM('DRAFT', 'ACTIVE', 'PAUSED', 'EXPIRED')
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP
```

### Redemption (Realizacja rabatu)

```
Redemption
├── id: UUID
├── offer_id: UUID FK
├── user_id: UUID FK
├── qr_code: VARCHAR(20) UNIQUE  -- "RDM-A7X2K9"
├── qr_generated_at: TIMESTAMP
├── status: ENUM('PENDING', 'REDEEMED', 'EXPIRED')
├── redeemed_at: TIMESTAMP       -- kiedy zrealizowano
├── redeemed_by_pin: CHAR(4)     -- który PIN użyto
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP
```

## Indeksy

```sql
-- Wyszukiwanie lokali w dzielnicy
CREATE INDEX idx_venue_district ON Venue(district_id) WHERE active = true;

-- Aktywne oferty lokalu
CREATE INDEX idx_offer_venue_status ON Offer(venue_id, status);

-- Oferty po dacie (do wygaszania)
CREATE INDEX idx_offer_valid_to ON Offer(valid_to) WHERE status = 'ACTIVE';

-- Realizacje usera
CREATE INDEX idx_redemption_user ON Redemption(user_id);

-- Realizacje oferty (licznik)
CREATE INDEX idx_redemption_offer ON Redemption(offer_id, status);

-- QR lookup
CREATE UNIQUE INDEX idx_redemption_qr ON Redemption(qr_code);

-- Subskrypcje usera
CREATE INDEX idx_user_district_user ON UserDistrict(user_id);

-- Geolokalizacja dzielnic
CREATE INDEX idx_district_geo ON District(center_lat, center_lng) WHERE active = true;
```
