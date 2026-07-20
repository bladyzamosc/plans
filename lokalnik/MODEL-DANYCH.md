# Lokalnik.pl — Model Danych MVP

## Diagram relacji

```
                    Location
                        │
          ┌─────────────┼─────────────┐
          ▼             ▼             ▼
      Property       Partner      DiscountCode
          │             │             │
          │             ▼             │
          │         Discount          │
          │             │             │
          ▼             ▼             ▼
      Manager ◄──── Redemption ────► Guest (optional)
```

## Encje

### Location (Lokalizacja)

Miejscowość turystyczna gdzie działamy.

```sql
Location
├── id: UUID
├── name: VARCHAR(100)              -- "Jastrzębia Góra"
├── slug: VARCHAR(50) UNIQUE        -- "jastrzebia-gora"
├── region: VARCHAR(100)            -- "Pomorskie"
├── country: VARCHAR(50)            -- "Polska"
├── center_lat: DECIMAL(10,8)
├── center_lng: DECIMAL(11,8)
├── radius_km: DECIMAL(4,1)         -- obszar lokalizacji
├── timezone: VARCHAR(50)           -- "Europe/Warsaw"
├── active: BOOLEAN DEFAULT false   -- aktywujemy gdy mamy Partnerów
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP
```

### Manager (Zarządca)

Osoba zarządzająca mieszkaniami wakacyjnymi.

```sql
Manager
├── id: UUID
├── email: VARCHAR(255) UNIQUE
├── password_hash: VARCHAR(255)
├── name: VARCHAR(100)              -- "Jan Kowalski"
├── company_name: VARCHAR(200)      -- "Apartamenty Morskie" (opcjonalne)
├── phone: VARCHAR(20)
├── nip: VARCHAR(15)                -- opcjonalne
├── 
├── # Status
├── status: ENUM('PENDING', 'ACTIVE', 'SUSPENDED')
├── verified_at: TIMESTAMP          -- kiedy zweryfikowany przez admina
├── 
├── created_at: TIMESTAMP
├── updated_at: TIMESTAMP
└── deleted_at: TIMESTAMP           -- soft delete
```

### Property (Mieszkanie/Apartament)

Pojedyncze mieszkanie zarządzane przez Managera.

```sql
Property
├── id: UUID
├── manager_id: UUID FK
├── location_id: UUID FK
├── 
├── # Dane podstawowe
├── name: VARCHAR(100)              -- "Apartament Słoneczny"
├── address: VARCHAR(200)           -- "ul. Morska 15/3"
├── description: TEXT
├── reservation_code: VARCHAR(20) UNIQUE  -- "JG-2024-0742" (do wpisania przez gościa)
├── 
├── # Zdjęcie (opcjonalne, do materiałów)
├── image_url: VARCHAR(500)
├── 
├── # Status
├── active: BOOLEAN DEFAULT true
├── 
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP
```

### GuestSession (Sesja gościa)

Zapamiętuje rezerwację gościa (po wpisaniu kodu lub kliknięciu w link z emaila).

```sql
GuestSession
├── id: UUID
├── property_id: UUID FK
├── 
├── # Token do linku w emailu
├── email_token: VARCHAR(64) UNIQUE -- losowy token w URL
├── 
├── # Identyfikacja (opcjonalne)
├── guest_email: VARCHAR(255)       -- email gościa (jeśli wysłano link)
├── guest_name: VARCHAR(100)        -- imię (opcjonalne)
├── 
├── # Daty pobytu (opcjonalne, do limitu kodów)
├── check_in: DATE
├── check_out: DATE
├── 
├── # Status
├── created_at: TIMESTAMP
├── last_active_at: TIMESTAMP
├── expires_at: TIMESTAMP           -- np. check_out + 1 dzień
└── 
```

### Partner (Punkt usługowy)

Restauracja, kawiarnia, sklep oferujący zniżki.

```sql
Partner
├── id: UUID
├── location_id: UUID FK
├── 
├── # Dane firmy
├── name: VARCHAR(100)              -- "Pizzeria Napoli"
├── company_name: VARCHAR(200)      -- "Napoli Sp. z o.o."
├── nip: VARCHAR(15)
├── address: VARCHAR(200)
├── phone: VARCHAR(20)
├── email: VARCHAR(255)
├── website: VARCHAR(255)
├── 
├── # Kategoria
├── category: ENUM('RESTAURANT', 'CAFE', 'BAR', 'PIZZERIA', 
│                  'GROCERY', 'PHARMACY', 'BAKERY', 'ICE_CREAM',
│                  'PUB', 'FAST_FOOD', 'OTHER')
├── 
├── # Lokalizacja dokładna
├── lat: DECIMAL(10,8)
├── lng: DECIMAL(11,8)
├── 
├── # Logo (do materiałów)
├── logo_url: VARCHAR(500)
├── 
├── # Walidacja
├── validation_pin: CHAR(4)         -- PIN do walidacji kodów
├── 
├── # Status i umowa (KLUCZOWE)
├── status: ENUM('PENDING', 'ACTIVE', 'SUSPENDED', 'TERMINATED')
├── contract_signed_at: TIMESTAMP   -- kiedy podpisano umowę
├── contract_valid_to: TIMESTAMP    -- do kiedy ważna umowa
├── contract_file_url: VARCHAR(500) -- skan/PDF umowy
├── contract_notes: TEXT            -- notatki admina o umowie
├── 
├── # Konto do panelu (opcjonalne)
├── panel_email: VARCHAR(255)
├── panel_password_hash: VARCHAR(255)
├── 
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP
```

### Discount (Zniżka)

Definicja zniżki oferowanej przez Partnera.

```sql
Discount
├── id: UUID
├── partner_id: UUID FK
├── 
├── # Opis zniżki
├── title: VARCHAR(100)             -- "-20% na pizze"
├── description: TEXT               -- "Rabat na wszystkie pizze z menu"
├── terms: TEXT                     -- "Nie łączy się z innymi promocjami"
├── 
├── # Forma rabatu
├── discount_type: ENUM('PERCENTAGE', 'FIXED_AMOUNT', 'FREE_ITEM')
├── discount_value: DECIMAL(10,2)   -- 20 dla %, 15.00 dla kwoty
├── free_item_name: VARCHAR(100)    -- "kawa" (tylko FREE_ITEM)
├── 
├── # Limity
├── min_order_value: DECIMAL(10,2)  -- minimalna wartość zamówienia
├── max_discount_value: DECIMAL(10,2) -- max zniżka (dla %)
├── 
├── # Ważność
├── valid_from: DATE
├── valid_to: DATE                  -- NULL = bezterminowo
├── 
├── # Dostępność
├── available_days: VARCHAR(20)     -- "1,2,3,4,5" (pon-pt) lub NULL (wszystkie)
├── available_hours_from: TIME      -- np. 11:00
├── available_hours_to: TIME        -- np. 22:00
├── 
├── # Status
├── status: ENUM('DRAFT', 'ACTIVE', 'PAUSED', 'EXPIRED')
├── 
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP
```

### DiscountCode (Kod zniżkowy)

Jednorazowy kod wygenerowany przez gościa.

```sql
DiscountCode
├── id: UUID
├── discount_id: UUID FK
├── property_id: UUID FK            -- z jakiego mieszkania
├── 
├── # Kod
├── code: VARCHAR(10) UNIQUE        -- "LNK-A7X2K9"
├── 
├── # Identyfikacja gościa (opcjonalne)
├── guest_name: VARCHAR(100)        -- opcjonalne
├── guest_email: VARCHAR(255)       -- opcjonalne (do historii)
├── 
├── # Status
├── status: ENUM('ACTIVE', 'REDEEMED', 'EXPIRED', 'CANCELLED')
├── 
├── # Timestamps
├── generated_at: TIMESTAMP
├── expires_at: TIMESTAMP           -- +1h od wygenerowania
├── redeemed_at: TIMESTAMP
├── 
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP
```

### Redemption (Realizacja)

Zapis realizacji kodu zniżkowego.

```sql
Redemption
├── id: UUID
├── discount_code_id: UUID FK
├── 
├── # Kto zrealizował
├── validated_by_pin: CHAR(4)       -- PIN Partnera
├── 
├── # Wartość transakcji (opcjonalne, do statystyk)
├── order_value: DECIMAL(10,2)      -- wartość zamówienia
├── discount_applied: DECIMAL(10,2) -- ile zniżki udzielono
├── 
├── # Notatka (opcjonalna)
├── note: VARCHAR(255)              -- np. "2x pizza margherita"
├── 
├── redeemed_at: TIMESTAMP
└── created_at: TIMESTAMP
```

### Admin (Administrator platformy)

```sql
Admin
├── id: UUID
├── email: VARCHAR(255) UNIQUE
├── password_hash: VARCHAR(255)
├── name: VARCHAR(100)
├── role: ENUM('SUPER_ADMIN', 'ADMIN', 'SUPPORT')
├── active: BOOLEAN DEFAULT true
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP
```

### MaterialRequest (Zamówienie materiałów)

Dla Fazy 2 — zamówienia pleks, wydruków.

```sql
MaterialRequest
├── id: UUID
├── manager_id: UUID FK
├── property_id: UUID FK            -- dla którego mieszkania
├── 
├── # Typ materiału
├── material_type: ENUM('PDF', 'PLEXIGLASS', 'POSTER', 'CARDS')
├── quantity: INT DEFAULT 1
├── 
├── # Shipping (dla fizycznych)
├── shipping_address: TEXT
├── shipping_name: VARCHAR(100)
├── shipping_phone: VARCHAR(20)
├── 
├── # Status
├── status: ENUM('PENDING', 'PROCESSING', 'SHIPPED', 'DELIVERED')
├── 
├── # Tracking
├── tracking_number: VARCHAR(50)
├── shipped_at: TIMESTAMP
├── delivered_at: TIMESTAMP
├── 
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP
```

## Indeksy

```sql
-- Lokalizacje aktywne
CREATE INDEX idx_location_active ON Location(active) WHERE active = true;

-- Mieszkania Zarządcy
CREATE INDEX idx_property_manager ON Property(manager_id) WHERE active = true;

-- Mieszkania w lokalizacji
CREATE INDEX idx_property_location ON Property(location_id) WHERE active = true;

-- Partnerzy w lokalizacji
CREATE INDEX idx_partner_location ON Partner(location_id, status);

-- Zniżki Partnera
CREATE INDEX idx_discount_partner ON Discount(partner_id, status);

-- Aktywne zniżki (do listowania)
CREATE INDEX idx_discount_active ON Discount(status, valid_to) 
    WHERE status = 'ACTIVE';

-- Lookup kodu
CREATE UNIQUE INDEX idx_discount_code ON DiscountCode(code);

-- Kody dla mieszkania
CREATE INDEX idx_discount_code_property ON DiscountCode(property_id, status);

-- Realizacje dla zniżki (statystyki)
CREATE INDEX idx_redemption_discount ON Redemption(discount_code_id);

-- Manager email (login)
CREATE UNIQUE INDEX idx_manager_email ON Manager(email) WHERE deleted_at IS NULL;
```

## Widoki pomocnicze

### Statystyki dla Partnera

```sql
CREATE VIEW v_partner_stats AS
SELECT 
    p.id as partner_id,
    p.name as partner_name,
    COUNT(DISTINCT dc.id) as codes_generated,
    COUNT(DISTINCT r.id) as codes_redeemed,
    COALESCE(SUM(r.discount_applied), 0) as total_discount_given,
    COALESCE(SUM(r.order_value), 0) as total_order_value
FROM Partner p
LEFT JOIN Discount d ON d.partner_id = p.id
LEFT JOIN DiscountCode dc ON dc.discount_id = d.id
LEFT JOIN Redemption r ON r.discount_code_id = dc.id
GROUP BY p.id, p.name;
```

### Statystyki dla Zarządcy

```sql
CREATE VIEW v_manager_stats AS
SELECT 
    m.id as manager_id,
    m.name as manager_name,
    COUNT(DISTINCT pr.id) as properties_count,
    COUNT(DISTINCT dc.id) as codes_generated,
    COUNT(DISTINCT r.id) as codes_redeemed
FROM Manager m
LEFT JOIN Property pr ON pr.manager_id = m.id
LEFT JOIN DiscountCode dc ON dc.property_id = pr.id
LEFT JOIN Redemption r ON r.discount_code_id = dc.id
GROUP BY m.id, m.name;
```

## Kategorie Partnerów

```sql
INSERT INTO ... VALUES
('RESTAURANT', 'Restauracja', 'utensils', 1),
('PIZZERIA', 'Pizzeria', 'pizza-slice', 2),
('CAFE', 'Kawiarnia', 'coffee', 3),
('BAR', 'Bar', 'glass-martini', 4),
('PUB', 'Pub', 'beer', 5),
('FAST_FOOD', 'Fast Food', 'hamburger', 6),
('ICE_CREAM', 'Lodziarnia', 'ice-cream', 7),
('BAKERY', 'Piekarnia', 'bread-slice', 8),
('GROCERY', 'Sklep spożywczy', 'shopping-basket', 9),
('PHARMACY', 'Apteka', 'pills', 10),
('OTHER', 'Inne', 'store', 99);
```

## Ograniczenia biznesowe

1. **Kod ważny 1 godzinę** od wygenerowania (generuj przed wejściem)
2. **1 kod na zniżkę na mieszkanie dziennie** (limit nadużyć)
3. **Partner może mieć max 5 aktywnych zniżek** (MVP)
4. **Zarządca może mieć max 50 mieszkań** (MVP tier)

---

## Powiązane

- WIZJA.md — wizja projektu, flow, decyzje
- FAZY.md — roadmap rozwoju
