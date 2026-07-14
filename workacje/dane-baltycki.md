# Apartament Bałtycki - Dane do MVP

## Właściciel (User)

| Pole | Wartość |
|------|---------|
| login | owner_baltycki |
| email | rezerwacje@wynajemapartamentow.com |
| firstName | Izabela |
| lastName | Roeske |
| phone | +48 505 763 202 |
| phoneSecondary | +48 513 028 238 |
| authorities | ROLE_OWNER |
| activated | true |

## Property

| Pole | Wartość |
|------|---------|
| **slug** | `baltycki` |
| **title** | Apartament Bałtycki |
| **propertyType** | DUPLEX |
| **status** | ACTIVE |
| **city** | Tupadły |
| **address** | ul. Podgrzybkowa 17c/2, Tupadły |
| **latitude** | 54.826526 |
| **longitude** | 18.328054 |
| **rooms** | 2 |
| **bathrooms** | 2 |
| **floors** | 2 |
| **area** | 54 |
| **maxGuests** | 4 |
| **kitchenType** | KITCHENETTE |
| **minStay** | 7 |
| **checkInTime** | 15:00 |
| **checkOutTime** | 11:00 |
| **cancellationPolicy** | MODERATE |

## Opis

```
Dwupoziomowy apartament w Tupadłach, 800 metrów od plaży (zejście Lisi Jar). 
Idealne miejsce dla osób pracujących zdalnie - szybki internet 300 Mbps, cisza i spokój.

GÓRNY POZIOM:
• Sypialnia małżeńska (łóżko 160x200 cm)
• Sypialnia z 2 łóżkami pojedynczymi (90x200 cm)
• Łazienka z prysznicem

DOLNY POZIOM:
• Przestronny salon z rozkładaną sofą i dużym stołem do pracy
• Aneks kuchenny: lodówka z zamrażalnikiem, zmywarka, płyta indukcyjna, mikrofalówka
• Łazienka z wanną i pralką
• Balkon z meblami ogrodowymi

W cenie: WiFi 300 Mbps, Smart TV, pościel, ręczniki, miejsce parkingowe (nr 3).

Lokalizacja: 800m do plaży, 1.6 km do centrum Jastrzębiej Góry.
```

## Cennik (PricingTier)

Sezon: połowa września - połowa czerwca

| weeksFrom | weeksTo | priceTotal |
|-----------|---------|------------|
| 1 | 1 | 1100.00 |
| 2 | 2 | 2000.00 |
| 3 | 3 | 2800.00 |
| 4 | 99 | 3500.00 |

## Udogodnienia (PropertyAmenity)

| code | value |
|------|-------|
| WIFI_SPEED | 300 |
| BEACH_DISTANCE | 800 |
| PARKING | |
| BALCONY | |
| DUPLEX | |
| SMART_TV | |
| WASHER | |
| DISHWASHER | |
| BATHTUB | |
| SHOWER | |
| FRIDGE | |
| MICROWAVE | |
| INDUCTION | |
| KETTLE | |
| VACUUM | |
| TABLE_WORKSPACE | |

## Zdjęcia (Photo)

Źródło: https://www.wynajemapartamentow.com/pokoj/apartament-baltycki-all-438624

| position | isMain | url |
|----------|--------|-----|
| 1 | true | https://r.profitroom.pl/apartamentynadmorzem/images/gallery/thumbs/1600x900/fb491323-abb0-4bf8-afd6-80ba446a8cda.jpg |
| 2 | false | https://r.profitroom.pl/apartamentynadmorzem/images/gallery/thumbs/1600x900/c7a01558-0e3f-4bb5-b115-22f4bd73bff0.jpg |
| 3 | false | https://r.profitroom.pl/apartamentynadmorzem/images/gallery/thumbs/1600x900/c34d9858-bb12-4cff-870e-5a1f7f36587d.jpg |
| 4 | false | https://r.profitroom.pl/apartamentynadmorzem/images/gallery/thumbs/1600x900/1547fe1e-c809-4b75-8098-1005ac53c8a1.jpg |
| 5 | false | https://r.profitroom.pl/apartamentynadmorzem/images/gallery/thumbs/1600x900/4562a995-210a-413f-93da-77a997c42c33.jpg |
| 6 | false | https://r.profitroom.pl/apartamentynadmorzem/images/gallery/thumbs/1600x900/5b918884-abcd-4105-82e6-8e6dcea6f2e0.jpg |
| 7 | false | https://r.profitroom.pl/apartamentynadmorzem/images/gallery/thumbs/1600x900/fb06c777-2fa9-4464-bfbd-39f0fb65c964.jpg |
| 8 | false | https://r.profitroom.pl/apartamentynadmorzem/images/gallery/thumbs/1600x900/766ad519-9bd3-4c73-b325-1a52ee1d78fc.jpg |
| 9 | false | https://r.profitroom.pl/apartamentynadmorzem/images/gallery/thumbs/1600x900/26511447-0303-444a-afea-b7b579ab9dc3.jpg |
| 10 | false | https://r.profitroom.pl/apartamentynadmorzem/images/gallery/thumbs/1600x900/36936aa0-ce4b-4631-82f9-7205a5f6c872.jpg |

**Uwaga:** Na MVP bierzemy 10 zdjęć z 21 dostępnych. Pozostałe można dodać później lub wybrać lepsze.

---

## SQL do wstawienia (MVP)

```sql
-- User (właściciel)
INSERT INTO jhi_user (login, email, password_hash, first_name, last_name, activated, lang_key, created_by, created_date)
VALUES ('owner_baltycki', 'rezerwacje@wynajemapartamentow.com', '$2a$10$...', 'Izabela', 'Roeske', true, 'pl', 'system', NOW());

-- User authorities
INSERT INTO jhi_user_authority (user_id, authority_name) VALUES ((SELECT id FROM jhi_user WHERE login = 'owner_baltycki'), 'ROLE_OWNER');

-- Extended user data (phone)
-- Zależnie od struktury JHipster - może być w osobnej tabeli lub rozszerzeniu

-- Property
INSERT INTO property (owner_id, slug, title, property_type, status, city, address, latitude, longitude, rooms, bathrooms, floors, area, max_guests, kitchen_type, min_stay, check_in_time, check_out_time, cancellation_policy, description, created_at, updated_at)
VALUES (
  (SELECT id FROM jhi_user WHERE login = 'owner_baltycki'),
  'baltycki',
  'Apartament Bałtycki',
  'DUPLEX',
  'ACTIVE',
  'Tupadły',
  'ul. Podgrzybkowa 17c/2, Tupadły',
  54.826526,
  18.328054,
  2,
  2,
  2,
  54,
  4,
  'KITCHENETTE',
  7,
  '15:00',
  '11:00',
  'MODERATE',
  'Dwupoziomowy apartament w Tupadłach, 800 metrów od plaży...',
  NOW(),
  NOW()
);

-- PricingTier
INSERT INTO pricing_tier (property_id, weeks_from, weeks_to, price_total) VALUES
((SELECT id FROM property WHERE slug = 'baltycki'), 1, 1, 1100.00),
((SELECT id FROM property WHERE slug = 'baltycki'), 2, 2, 2000.00),
((SELECT id FROM property WHERE slug = 'baltycki'), 3, 3, 2800.00),
((SELECT id FROM property WHERE slug = 'baltycki'), 4, 99, 3500.00);

-- Photos (10)
INSERT INTO photo (property_id, url, position, is_main) VALUES
((SELECT id FROM property WHERE slug = 'baltycki'), 'https://r.profitroom.pl/apartamentynadmorzem/images/gallery/thumbs/1600x900/fb491323-abb0-4bf8-afd6-80ba446a8cda.jpg', 1, true),
((SELECT id FROM property WHERE slug = 'baltycki'), 'https://r.profitroom.pl/apartamentynadmorzem/images/gallery/thumbs/1600x900/c7a01558-0e3f-4bb5-b115-22f4bd73bff0.jpg', 2, false),
-- ... pozostałe zdjęcia
;

-- PropertyAmenity
INSERT INTO property_amenity (property_id, amenity_id, value) VALUES
((SELECT id FROM property WHERE slug = 'baltycki'), (SELECT id FROM amenity WHERE code = 'WIFI_SPEED'), '300'),
((SELECT id FROM property WHERE slug = 'baltycki'), (SELECT id FROM amenity WHERE code = 'BEACH_DISTANCE'), '800'),
((SELECT id FROM property WHERE slug = 'baltycki'), (SELECT id FROM amenity WHERE code = 'PARKING'), NULL),
-- ... pozostałe amenities
;
```

---

## GOTOWE - Wszystkie dane kompletne!

Następne kroki:
1. Zakup domeny workacje.pl
2. JHipster init
3. Pipeline CI/CD
