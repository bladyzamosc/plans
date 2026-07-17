# Swoi — Model Danych MVP v2

## Diagram relacji

```
District ←──────────────── Venue ────────────────→ Category
    ↑                    ↑     ↑
    │                    │     │
UserDistrict        VenueUser  VenueChangeRequest
    │                    │
    ↓                    │
  User ←── UserFavoriteVenue
    ↑
    ├──────── Redemption ─────→ Offer ←── OfferReview
    │              ↑
    ├──────── PushToken        │
    │                          │
    └──────── PushLog          │
                               │
              ContentModeration ←┘
```

## Zmiany v2

- **VenueUser** — wielu użytkowników na lokal (OWNER, MANAGER)
- **VenueChangeRequest** — akceptacja zmian nazwy/logo przez admina
- **OfferReview** — oceny zrealizowanych ofert przez klientów
- **ContentModeration** — moderacja treści ofert (AI + admin)
- **User.street** — wymagana ulica przy rejestracji
- **Venue.status** — rozszerzony o TERMINATING, TERMINATED
- **Offer.status** — rozszerzony o PENDING_REVIEW, SCHEDULED
- **Redemption.qr_expires_at** — konfigurowalny czas ważności QR
- **Offer.qr_validity_minutes** — czas ważności QR per oferta

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
├── password_hash: VARCHAR(255)   -- NULL dla OAuth, set dla owner/manager
├── name: VARCHAR(100)
├── avatar_url: VARCHAR(500)
├── auth_provider: ENUM('GOOGLE', 'APPLE', 'EMAIL', 'ADMIN_CREATED')
├── role: ENUM('CLIENT', 'VENUE_USER', 'ADMIN')  -- globalna rola
├── 
├── # Lokalizacja (wymagana przy rejestracji)
├── district_id: UUID FK          -- główna dzielnica
├── street: VARCHAR(200)          -- wymagana ulica
├── 
├── # Ustawienia push
├── push_enabled: BOOLEAN DEFAULT true
├── digest_time: TIME DEFAULT '10:00'
├── 
├── # Zgody (RODO)
├── marketing_consent: BOOLEAN DEFAULT false
├── personalized_offers_consent: BOOLEAN DEFAULT false  -- zgoda na personalizację po walidacji
├── consent_date: TIMESTAMP
├── 
├── # Timestamps
├── created_at: TIMESTAMP
├── last_active_at: TIMESTAMP
├── deleted_at: TIMESTAMP        -- soft delete (GDPR)
└── must_change_password: BOOLEAN DEFAULT false  -- dla kont tworzonych przez admina
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
├── 
├── # Dane lokalu
├── name: VARCHAR(100)           -- "Beer & Burger Kufloteka"
├── address: VARCHAR(200)
├── description: TEXT
├── logo_url: VARCHAR(500)
├── 
├── # Walidacja
├── validation_pin: CHAR(4)      -- PIN do walidacji rabatów
├── 
├── # Status
├── status: ENUM('ACTIVE', 'INACTIVE', 'TERMINATING', 'TERMINATED', 'DELETED')
├── termination_requested_at: TIMESTAMP  -- kiedy złożono wypowiedzenie
├── termination_effective_at: TIMESTAMP  -- kiedy umowa wygasa (np. +30 dni)
├── termination_reason: TEXT
├── 
├── # Zgody właściciela (data zaakceptowania)
├── terms_accepted_at: TIMESTAMP
├── privacy_accepted_at: TIMESTAMP
├── 
├── # Timestamps
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP
```

### VenueUser (Użytkownicy lokalu)

```
VenueUser
├── id: UUID
├── venue_id: UUID FK
├── user_id: UUID FK
├── role: ENUM('OWNER', 'MANAGER')
├── 
├── # OWNER: wszystkie uprawnienia (zmiana nazwy/logo, oferty, PIN, wypowiedzenie)
├── # MANAGER: tylko oferty (tworzenie, edycja, pauzowanie)
├── 
├── invited_by: UUID FK          -- kto zaprosił (user_id)
├── invited_at: TIMESTAMP
├── accepted_at: TIMESTAMP       -- NULL = oczekuje na akceptację
├── 
├── created_at: TIMESTAMP
└── deleted_at: TIMESTAMP        -- soft delete
└── UNIQUE (venue_id, user_id)
```

### VenueChangeRequest (Wnioski o zmianę nazwy/logo)

```
VenueChangeRequest
├── id: UUID
├── venue_id: UUID FK
├── requested_by: UUID FK        -- user_id właściciela
├── 
├── # Co się zmienia
├── change_type: ENUM('NAME', 'LOGO', 'NAME_AND_LOGO')
├── new_name: VARCHAR(100)       -- NULL jeśli tylko logo
├── new_logo_url: VARCHAR(500)   -- NULL jeśli tylko nazwa
├── 
├── # Status
├── status: ENUM('PENDING', 'APPROVED', 'REJECTED')
├── reviewed_by: UUID FK         -- admin user_id
├── reviewed_at: TIMESTAMP
├── rejection_reason: TEXT
├── 
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP
```

### Offer (Oferta/Rabat)

```
Offer
├── id: UUID
├── venue_id: UUID FK
├── created_by: UUID FK          -- user_id (owner lub manager)
├── 
├── # Treść
├── title: VARCHAR(100)          -- "Drugie piwo gratis"
├── description: TEXT            -- "Przy zakupie zestawu..."
├── 
├── # Forma rabatu
├── discount_type: ENUM('PERCENTAGE', 'FIXED_AMOUNT', 'FREE_ITEM')
├── discount_value: DECIMAL(10,2) -- 30 dla %, 15.00 dla kwoty, NULL dla FREE_ITEM
├── free_item_name: VARCHAR(100)  -- "piwo z kranu" (tylko dla FREE_ITEM)
├── 
├── # Czas obowiązywania
├── valid_from: DATE
├── valid_to: DATE
├── 
├── # Konfiguracja QR
├── qr_validity_minutes: INT DEFAULT 15  -- czas ważności QR (min), NULL = do końca oferty
├── 
├── # Status i moderacja
├── status: ENUM('DRAFT', 'PENDING_REVIEW', 'SCHEDULED', 'ACTIVE', 'PAUSED', 'EXPIRED', 'REJECTED')
├── scheduled_publish_at: TIMESTAMP      -- kiedy ma się aktywować (min. 3 dni od utworzenia)
├── auto_approved: BOOLEAN DEFAULT false -- czy przeszło auto-moderację
├── 
├── # Moderacja
├── moderation_score: DECIMAL(3,2)       -- 0.00-1.00, wynik AI
├── moderation_flags: JSONB              -- ["profanity", "hate_speech"] 
├── moderation_reviewed_by: UUID FK      -- admin user_id (jeśli ręcznie)
├── moderation_reviewed_at: TIMESTAMP
├── rejection_reason: TEXT
├── 
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP
```

### ContentModeration (Log moderacji treści)

```
ContentModeration
├── id: UUID
├── entity_type: ENUM('OFFER', 'VENUE_CHANGE_REQUEST')
├── entity_id: UUID              -- offer_id lub venue_change_request_id
├── 
├── # Analiza AI
├── ai_provider: VARCHAR(50)     -- "perspective", "dictionary" (lub w przyszłości "openai", "azure")
├── ai_score: DECIMAL(3,2)       -- 0.00 = bezpieczne, 1.00 = niebezpieczne
├── ai_categories: JSONB         -- {"profanity": 0.1, "hate": 0.0, "violence": 0.0}
├── ai_explanation: TEXT
├── 
├── # Decyzja
├── auto_decision: ENUM('APPROVED', 'FLAGGED', 'REJECTED')
├── threshold_used: DECIMAL(3,2) -- próg użyty do decyzji
├── 
├── created_at: TIMESTAMP
└── processing_time_ms: INT
```

### Redemption (Realizacja rabatu)

```
Redemption
├── id: UUID
├── offer_id: UUID FK
├── user_id: UUID FK
├── 
├── # QR kod
├── qr_code: VARCHAR(20) UNIQUE  -- "RDM-A7X2K9"
├── qr_generated_at: TIMESTAMP
├── qr_expires_at: TIMESTAMP     -- qr_generated_at + offer.qr_validity_minutes
├── 
├── # Status
├── status: ENUM('PENDING', 'REDEEMED', 'EXPIRED')
├── redeemed_at: TIMESTAMP       -- kiedy zrealizowano
├── redeemed_by_pin: CHAR(4)     -- który PIN użyto
├── 
├── 
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP
```

### OfferReview (Ocena zrealizowanej oferty)

```
OfferReview
├── id: UUID
├── redemption_id: UUID FK UNIQUE  -- 1 ocena per realizacja
├── user_id: UUID FK
├── offer_id: UUID FK              -- denormalizacja dla statystyk
├── venue_id: UUID FK              -- denormalizacja dla statystyk
├── 
├── # Ocena
├── rating: SMALLINT               -- 1-5 gwiazdek
├── comment: TEXT                  -- opcjonalny komentarz
├── 
├── # Moderacja komentarza (jeśli jest)
├── comment_moderation_score: DECIMAL(3,2)
├── comment_visible: BOOLEAN DEFAULT true  -- czy pokazywać publicznie
├── 
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP
```

### PushToken (Token push)

```
PushToken
├── id: UUID
├── user_id: UUID FK
├── token: VARCHAR(500)
├── platform: ENUM('WEB', 'IOS', 'ANDROID')
├── active: BOOLEAN DEFAULT true
├── created_at: TIMESTAMP
└── last_used_at: TIMESTAMP
```

### PushLog (Historia wysłanych push)

```
PushLog
├── id: UUID
├── user_id: UUID FK
├── type: ENUM('DIGEST', 'WELCOME', 'WINBACK', 'REMINDER', 'FAVORITE', 'FIRST_N', 'REVIEW_REQUEST')
├── title: VARCHAR(100)
├── body: VARCHAR(200)
├── sent_at: TIMESTAMP
├── delivered: BOOLEAN
├── opened: BOOLEAN
├── opened_at: TIMESTAMP
└── error: TEXT
```

### OwnerInvitation (Zaproszenie właściciela przez admina)

```
OwnerInvitation
├── id: UUID
├── email: VARCHAR(255)
├── venue_id: UUID FK             -- do jakiego lokalu
├── 
├── # Token
├── token: VARCHAR(100) UNIQUE    -- jednorazowy token w linku
├── token_expires_at: TIMESTAMP   -- np. 7 dni
├── 
├── # Status
├── status: ENUM('PENDING', 'ACCEPTED', 'EXPIRED')
├── 
├── # Admin
├── created_by: UUID FK           -- admin user_id
├── created_at: TIMESTAMP
├── 
├── # Akceptacja
├── accepted_at: TIMESTAMP
├── accepted_by: UUID FK          -- utworzony user_id
└── temp_password_hash: VARCHAR(255)  -- jednorazowe hasło
```

## Indeksy

```sql
-- Wyszukiwanie lokali w dzielnicy
CREATE INDEX idx_venue_district ON Venue(district_id) WHERE status = 'ACTIVE';

-- Użytkownicy lokalu
CREATE INDEX idx_venue_user_venue ON VenueUser(venue_id) WHERE deleted_at IS NULL;
CREATE INDEX idx_venue_user_user ON VenueUser(user_id) WHERE deleted_at IS NULL;

-- Aktywne oferty lokalu
CREATE INDEX idx_offer_venue_status ON Offer(venue_id, status);

-- Oferty do auto-publikacji
CREATE INDEX idx_offer_scheduled ON Offer(scheduled_publish_at) 
  WHERE status = 'SCHEDULED';

-- Oferty po dacie (do wygaszania)
CREATE INDEX idx_offer_valid_to ON Offer(valid_to) WHERE status = 'ACTIVE';

-- Realizacje usera
CREATE INDEX idx_redemption_user ON Redemption(user_id);

-- Realizacje oferty (licznik)
CREATE INDEX idx_redemption_offer ON Redemption(offer_id, status);

-- QR lookup
CREATE UNIQUE INDEX idx_redemption_qr ON Redemption(qr_code);

-- Wygasające QR kody
CREATE INDEX idx_redemption_expires ON Redemption(qr_expires_at) 
  WHERE status = 'PENDING';

-- Oceny oferty
CREATE INDEX idx_review_offer ON OfferReview(offer_id);
CREATE INDEX idx_review_venue ON OfferReview(venue_id);

-- Subskrypcje usera
CREATE INDEX idx_user_district_user ON UserDistrict(user_id);

-- Geolokalizacja dzielnic
CREATE INDEX idx_district_geo ON District(center_lat, center_lng) WHERE active = true;

-- Push tokeny usera
CREATE INDEX idx_push_token_user ON PushToken(user_id) WHERE active = true;

-- Push logi (ostatnie wysłane)
CREATE INDEX idx_push_log_user_type ON PushLog(user_id, type, sent_at DESC);

-- Pending venue changes
CREATE INDEX idx_venue_change_pending ON VenueChangeRequest(status) 
  WHERE status = 'PENDING';

-- Pending offer moderation
CREATE INDEX idx_offer_pending_review ON Offer(status, created_at) 
  WHERE status = 'PENDING_REVIEW';

-- Owner invitations
CREATE INDEX idx_invitation_token ON OwnerInvitation(token) 
  WHERE status = 'PENDING';
```

## Reguły biznesowe

### Moderacja treści ofert

1. **Własny słownik** — lista zakazanych słów (wulgaryzmy, konkurencja, obraźliwe)
2. **Perspective API (Google)** — darmowe API do wykrywania toksyczności
3. **Progi (na podstawie Perspective score):**
   - score < 0.3 → auto-approve, scheduled_publish_at = now + 3 dni
   - score 0.3-0.7 → PENDING_REVIEW (wymaga admina)
   - score > 0.7 → auto-reject z powiadomieniem
4. **Admin override** — admin może zatwierdzić/odrzucić niezależnie od AI

**Notatka na przyszłość:** Rozważyć Azure Content Safety (enterprise, RODO) lub OpenAI Moderation (darmowe) przy większej skali.

### Publikacja ofert

1. Oferta NIGDY nie wchodzi natychmiast — minimum 3 dni lub akceptacja admina
2. Status flow: DRAFT → PENDING_REVIEW → SCHEDULED → ACTIVE
3. Admin może przyspieszyć (skip do ACTIVE)
4. Cron job o scheduled_publish_at zmienia SCHEDULED → ACTIVE

### Ważność QR kodu

1. Domyślnie 15 minut (Offer.qr_validity_minutes)
2. Właściciel może ustawić: 5, 10, 15, 30, 60 min lub NULL (do końca oferty)
3. Timer wyświetlany przy QR kodzie
4. Po wygaśnięciu: można wygenerować nowy

### Oceny ofert

1. Ocena opcjonalna (1-5 gwiazdek + komentarz) — z poziomu historii realizacji
2. Komentarze moderowane (własny słownik + Perspective API)
3. Średnia ocen widoczna **tylko dla właściciela** w dashboardzie (nie publicznie)
4. ❌ BEZ automatycznego push z prośbą o ocenę

### Role w lokalu

| Uprawnienie | OWNER | MANAGER |
|-------------|-------|---------|
| Tworzenie ofert | ✅ | ✅ |
| Edycja ofert | ✅ | ✅ |
| Pauzowanie ofert | ✅ | ✅ |
| Zmiana nazwy/logo | ✅ (wymaga akceptacji) | ❌ |
| Zmiana PIN | ✅ | ❌ |
| Zapraszanie managerów | ✅ | ❌ |
| Usuwanie managerów | ✅ | ❌ |
| Wypowiedzenie umowy | ✅ | ❌ |
| Podgląd statystyk | ✅ | ✅ |

### Wypowiedzenie umowy

1. OWNER składa wniosek → status = TERMINATING
2. termination_effective_at = now + 30 dni
3. W okresie wypowiedzenia: oferty działają, nowych nie można tworzyć
4. Po termination_effective_at → status = TERMINATED
5. Dane archiwizowane, lokal niewidoczny

### Rejestracja klienta

1. Wybór dzielnicy (obowiązkowy)
2. Wybór ulicy w dzielnicy (obowiązkowy) — autocomplete z bazy ulic
3. Zgoda na regulamin (obowiązkowa)
4. Zgoda na personalizację ofert (opcjonalna, ale wyświetlana przy walidacji QR)

### Regulamin — klauzule do przegadania z prawnikiem

1. **Zgoda na personalizację** — "Wyrażam zgodę na otrzymywanie spersonalizowanych ofert na podstawie historii moich zakupów"
2. **Klauzula przy walidacji QR** — "Realizując tę ofertę, wyrażasz zgodę na otrzymywanie kolejnych ofert dopasowanych do Twoich preferencji"
3. **Prawo do wycofania zgody** — w ustawieniach profilu
