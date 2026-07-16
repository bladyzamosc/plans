# Kontrola dostępu - API Swoi

## Role użytkowników

| Rola | Opis | Jak uzyskać |
|------|------|-------------|
| `CLIENT` | Zwykły użytkownik | Automatycznie po rejestracji |
| `OWNER` | Właściciel lokalu | Admin przypisuje do lokalu (MVP) |
| `ADMIN` | Administrator | Manualnie w bazie |

Użytkownik może mieć wiele ról (np. CLIENT + OWNER).

---

## Matryca dostępu - Endpointy

### Publiczne (bez autoryzacji)

| Endpoint | Metoda | Opis |
|----------|--------|------|
| `/auth/*` | POST | Logowanie, rejestracja |
| `/districts` | GET | Lista dzielnic |
| `/districts/{id}` | GET | Szczegóły dzielnicy |
| `/districts/nearby` | GET | Geolokalizacja |
| `/categories` | GET | Lista kategorii |
| `/venues` | GET | Lista lokali |
| `/venues/{id}` | GET | Szczegóły lokalu |
| `/offers` | GET | Lista ofert |
| `/offers/{id}` | GET | Szczegóły oferty |
| `/redemptions/{qrCode}` | GET | Dane do walidacji QR |
| `/redemptions/{qrCode}/validate` | POST | Walidacja PIN |

### CLIENT (zalogowany użytkownik)

| Endpoint | Metoda | Opis |
|----------|--------|------|
| `/user/me` | GET, PATCH, DELETE | Profil |
| `/user/districts` | GET, POST | Subskrypcje dzielnic |
| `/user/districts/{id}` | PATCH, DELETE | Zarządzanie subskrypcją |
| `/user/favorites` | GET, POST | Ulubione lokale |
| `/user/favorites/{id}` | DELETE | Usuń z ulubionych |
| `/user/push-token` | POST | Rejestracja push |
| `/redemptions` | GET, POST | Historia i generowanie QR |

### OWNER (właściciel lokalu)

Wszystkie endpointy CLIENT plus:

| Endpoint | Metoda | Opis |
|----------|--------|------|
| `/owner/venue` | GET, PATCH | Dane lokalu |
| `/owner/venue/logo` | POST | Upload logo |
| `/owner/venue/pin` | PATCH | Zmiana PIN |
| `/owner/stats` | GET | Statystyki |
| `/owner/offers` | GET, POST | Oferty |
| `/owner/offers/{id}` | GET, PATCH, DELETE | Zarządzanie ofertą |
| `/owner/offers/{id}/publish` | POST | Publikacja |
| `/owner/offers/{id}/pause` | POST | Wstrzymanie |
| `/owner/offers/{id}/resume` | POST | Wznowienie |

**Ograniczenia OWNER:**
- Widzi tylko swój lokal i swoje oferty
- Może edytować tylko oferty w statusie DRAFT
- MVP: max 1 aktywna oferta dziennie

### ADMIN (administrator)

Wszystkie endpointy CLIENT i OWNER plus:

| Endpoint | Metoda | Opis |
|----------|--------|------|
| `/admin/stats` | GET | Statystyki globalne |
| `/admin/districts` | GET, POST | Dzielnice |
| `/admin/districts/{id}` | PATCH, DELETE | Zarządzanie |
| `/admin/venues` | GET, POST | Lokale |
| `/admin/venues/{id}` | PATCH, DELETE | Zarządzanie |
| `/admin/categories` | GET, POST | Kategorie |
| `/admin/categories/{id}` | PATCH, DELETE | Zarządzanie |
| `/admin/categories/reorder` | POST | Kolejność |
| `/admin/users` | GET | Lista użytkowników |
| `/admin/users/{id}` | GET | Szczegóły użytkownika |

---

## Rate Limiting

### Limity globalne

| Endpoint | Limit | Okno | Klucz |
|----------|-------|------|-------|
| Wszystkie | 100 req | 1 min | IP |
| `/auth/*` | 10 req | 1 min | IP |
| `/auth/magic-link` | 3 req | 15 min | Email |

### Limity walidacji QR (krytyczne)

| Endpoint | Limit | Okno | Klucz | Powód |
|----------|-------|------|-------|-------|
| `GET /redemptions/{qrCode}` | 10 req | 1 min | IP | Anti-enumeration |
| `POST /redemptions/{qrCode}/validate` | 5 req | 5 min | qrCode | Anti brute-force PIN |
| `POST /redemptions/{qrCode}/validate` | 20 req | 1 min | IP | Anti DDoS |

### Odpowiedź przy przekroczeniu

**429 Too Many Requests:**
```json
{
  "error": "TOO_MANY_REQUESTS",
  "message": "Zbyt wiele prób. Spróbuj za 5 minut.",
  "retryAfter": 300
}
```

Header: `Retry-After: 300`

### Blokada po błędnych PINach

Po **3 błędnych PINach** dla danego kodu QR:
- Kod blokowany na **15 minut**
- Logowanie incydentu (alert dla admina)
- Odpowiedź: `REDEMPTION_TEMPORARILY_BLOCKED`

```json
{
  "error": "REDEMPTION_TEMPORARILY_BLOCKED",
  "message": "Zbyt wiele błędnych prób. Kod zablokowany na 15 minut.",
  "blockedUntil": "2026-07-16T15:30:00Z"
}
```

---

## Walidacja uprawnień

### Przykłady odpowiedzi błędów

**401 Unauthorized** - brak tokenu lub token wygasł:
```json
{
  "error": "UNAUTHORIZED",
  "message": "Wymagane zalogowanie"
}
```

**403 Forbidden** - brak uprawnień do zasobu:
```json
{
  "error": "FORBIDDEN",
  "message": "Brak dostępu do tego zasobu"
}
```

**403 Forbidden** - właściciel próbuje edytować cudzy lokal:
```json
{
  "error": "FORBIDDEN",
  "message": "To nie jest Twój lokal"
}
```

---

## Reguły biznesowe

### Generowanie QR (POST /redemptions)

| Warunek | Błąd |
|---------|------|
| Oferta wygasła | `OFFER_EXPIRED` |
| Oferta nieaktywna | `OFFER_NOT_ACTIVE` |
| Już wykorzystano dziś | `DAILY_LIMIT_REACHED` |

### Tworzenie oferty (POST /owner/offers)

| Warunek | Błąd |
|---------|------|
| Już 1 aktywna oferta (MVP) | `DAILY_OFFER_LIMIT` |
| Data validTo < validFrom | `INVALID_DATE_RANGE` |
| PERCENTAGE bez wartości | `MISSING_DISCOUNT_VALUE` |
| FREE_ITEM bez nazwy | `MISSING_FREE_ITEM_NAME` |

### Walidacja QR (POST /redemptions/{qr}/validate)

| Warunek | Błąd |
|---------|------|
| Kod nie istnieje | `NOT_FOUND` |
| Już zrealizowano | `ALREADY_REDEEMED` |
| Kod wygasł | `REDEMPTION_EXPIRED` |
| Błędny PIN | `INVALID_PIN` |

---

## JWT Claims

```json
{
  "sub": "uuid-użytkownika",
  "email": "jan@example.com",
  "name": "Jan Kowalski",
  "roles": ["CLIENT", "OWNER"],
  "venueIds": ["uuid-lokalu"],
  "iat": 1700000000,
  "exp": 1700000900
}
```

- `venueIds` - lista lokali właściciela (tylko dla OWNER)
- Access token: 15 minut
- Refresh token: 30 dni
