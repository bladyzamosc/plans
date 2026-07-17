# Kontrola dostępu - API Swoi v2

## Role użytkowników

| Rola | Opis | Jak uzyskać |
|------|------|-------------|
| `CLIENT` | Zwykły użytkownik aplikacji | Automatycznie po rejestracji (OAuth) |
| `VENUE_USER` | Użytkownik przypisany do lokalu | Admin zaprasza lub Owner dodaje managera |
| `ADMIN` | Administrator systemu | Manualnie w bazie |

Użytkownik może mieć wiele ról (np. CLIENT + VENUE_USER).

---

## Role w lokalu (VenueUser)

Użytkownik VENUE_USER może mieć różne uprawnienia w różnych lokalach:

| Rola w lokalu | Opis | Nadawana przez |
|---------------|------|----------------|
| `OWNER` | Właściciel - pełne uprawnienia | Admin (zaproszenie) |
| `MANAGER` | Manager - tylko oferty | Owner (zaproszenie) |

### Macierz uprawnień w lokalu

| Uprawnienie | OWNER | MANAGER |
|-------------|-------|---------|
| Tworzenie/edycja ofert | ✅ | ✅ |
| Pauzowanie/wznawianie ofert | ✅ | ✅ |
| Podgląd statystyk | ✅ | ✅ |
| Podgląd średniej ocen | ✅ | ✅ |
| Zmiana nazwy/logo (wniosek) | ✅ | ❌ |
| Zmiana PIN | ✅ | ❌ |
| Zapraszanie managerów | ✅ | ❌ |
| Usuwanie managerów | ✅ | ❌ |
| Wypowiedzenie umowy | ✅ | ❌ |

---

## Matryca dostępu - Endpointy

### Publiczne (bez autoryzacji)

| Endpoint | Metoda | Opis |
|----------|--------|------|
| `/auth/google` | POST | Logowanie Google |
| `/auth/apple` | POST | Logowanie Apple |
| `/auth/magic-link` | POST | Wysłanie magic link |
| `/auth/magic-link/verify` | POST | Weryfikacja magic link |
| `/auth/owner-invitation/accept` | POST | Akceptacja zaproszenia właściciela |
| `/auth/login` | POST | Logowanie hasłem (owner/manager) |
| `/auth/refresh` | POST | Odświeżenie tokena |
| `/districts` | GET | Lista dzielnic |
| `/districts/{id}` | GET | Szczegóły dzielnicy |
| `/districts/{id}/streets` | GET | Lista ulic (autocomplete) |
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
| `/auth/register` | POST | Uzupełnienie danych po OAuth |
| `/auth/change-password` | POST | Zmiana hasła |
| `/auth/logout` | POST | Wylogowanie |
| `/user/me` | GET, PATCH, DELETE | Profil |
| `/user/consents` | GET, PATCH | Zgody (personalizacja, marketing) |
| `/user/districts` | GET, POST | Subskrypcje dzielnic |
| `/user/districts/{id}` | PATCH, DELETE | Zarządzanie subskrypcją |
| `/user/favorites` | GET, POST | Ulubione lokale |
| `/user/favorites/{id}` | DELETE | Usuń z ulubionych |
| `/user/push-token` | POST, DELETE | Rejestracja/wyrejestrowanie push |
| `/user/push-settings` | GET, PATCH | Ustawienia push |
| `/redemptions` | GET, POST | Historia i generowanie QR |
| `/redemptions/{redemptionId}/review` | POST | Dodaj ocenę |

### VENUE_USER (właściciel/manager lokalu)

Wszystkie endpointy CLIENT plus:

| Endpoint | Metoda | Opis | Kto ma dostęp |
|----------|--------|------|---------------|
| `/owner/venues` | GET | Lista moich lokali | OWNER, MANAGER |
| `/owner/venues/{venueId}` | GET | Szczegóły lokalu | OWNER, MANAGER |
| `/owner/venues/{venueId}/stats` | GET | Statystyki (ze średnią ocen) | OWNER, MANAGER |
| `/owner/venues/{venueId}/offers` | GET, POST | Oferty | OWNER, MANAGER |
| `/owner/venues/{venueId}/offers/{id}` | GET, PATCH, DELETE | Zarządzanie ofertą | OWNER, MANAGER |
| `/owner/venues/{venueId}/offers/{id}/submit` | POST | Wyślij do moderacji | OWNER, MANAGER |
| `/owner/venues/{venueId}/offers/{id}/pause` | POST | Wstrzymanie | OWNER, MANAGER |
| `/owner/venues/{venueId}/offers/{id}/resume` | POST | Wznowienie | OWNER, MANAGER |
| `/owner/venues/{venueId}/change-request` | POST | Wniosek o zmianę nazwy/logo | **tylko OWNER** |
| `/owner/venues/{venueId}/change-requests` | GET | Historia wniosków | **tylko OWNER** |
| `/owner/venues/{venueId}/logo` | POST | Upload logo | **tylko OWNER** |
| `/owner/venues/{venueId}/pin` | PATCH | Zmiana PIN | **tylko OWNER** |
| `/owner/venues/{venueId}/terminate` | POST | Wypowiedzenie umowy | **tylko OWNER** |
| `/owner/venues/{venueId}/managers` | GET, POST | Lista/zapraszanie managerów | **tylko OWNER** |
| `/owner/venues/{venueId}/managers/{userId}` | DELETE | Usunięcie managera | **tylko OWNER** |

**Ograniczenia:**
- MANAGER widzi tylko lokale, do których jest przypisany
- OWNER widzi swoje lokale i może zarządzać managerami
- Edycja oferty możliwa tylko w statusie DRAFT lub REJECTED
- W okresie wypowiedzenia (TERMINATING) nie można tworzyć nowych ofert
- MVP: max 1 aktywna oferta dziennie

### ADMIN (administrator)

Wszystkie endpointy CLIENT i VENUE_USER plus:

| Endpoint | Metoda | Opis |
|----------|--------|------|
| `/admin/stats` | GET | Statystyki globalne (+ pending) |
| `/admin/owner-invitations` | GET, POST | Zaproszenia właścicieli |
| `/admin/offer-moderations` | GET | Oferty do moderacji |
| `/admin/offer-moderations/{id}/approve` | POST | Zatwierdź ofertę |
| `/admin/offer-moderations/{id}/reject` | POST | Odrzuć ofertę |
| `/admin/venue-change-requests` | GET | Wnioski o zmianę nazwy/logo |
| `/admin/venue-change-requests/{id}/approve` | POST | Zatwierdź zmianę |
| `/admin/venue-change-requests/{id}/reject` | POST | Odrzuć zmianę |
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
| `/auth/login` | 5 req | 5 min | Email |

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
  "blockedUntil": "2026-07-17T15:30:00Z"
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

**403 Forbidden** - manager próbuje zmienić PIN:
```json
{
  "error": "FORBIDDEN",
  "message": "Tylko właściciel może zmieniać PIN"
}
```

**403 Forbidden** - próba tworzenia oferty w wypowiedzeniu:
```json
{
  "error": "VENUE_TERMINATING",
  "message": "Nie można tworzyć nowych ofert w okresie wypowiedzenia"
}
```

---

## Reguły biznesowe

### Rejestracja klienta (POST /auth/register)

| Warunek | Błąd |
|---------|------|
| Brak dzielnicy | `DISTRICT_REQUIRED` |
| Brak ulicy | `STREET_REQUIRED` |
| Brak zgody na regulamin | `TERMS_REQUIRED` |

### Generowanie QR (POST /redemptions)

| Warunek | Błąd |
|---------|------|
| Oferta wygasła | `OFFER_EXPIRED` |
| Oferta nieaktywna | `OFFER_NOT_ACTIVE` |
| Już wykorzystano dziś | `DAILY_LIMIT_REACHED` |

### Tworzenie oferty (POST /owner/venues/{id}/offers)

| Warunek | Błąd |
|---------|------|
| Już 1 aktywna oferta (MVP) | `DAILY_OFFER_LIMIT` |
| Data validTo < validFrom | `INVALID_DATE_RANGE` |
| PERCENTAGE bez wartości | `MISSING_DISCOUNT_VALUE` |
| FREE_ITEM bez nazwy | `MISSING_FREE_ITEM_NAME` |
| Lokal w wypowiedzeniu | `VENUE_TERMINATING` |
| Treść odrzucona przez AI | `CONTENT_REJECTED` |

### Walidacja QR (POST /redemptions/{qr}/validate)

| Warunek | Błąd |
|---------|------|
| Kod nie istnieje | `NOT_FOUND` |
| Już zrealizowano | `ALREADY_REDEEMED` |
| QR wygasł | `QR_EXPIRED` |
| Błędny PIN | `INVALID_PIN` |
| Zbyt wiele prób | `REDEMPTION_TEMPORARILY_BLOCKED` |

### Oceny (POST /redemptions/{id}/review)

| Warunek | Błąd |
|---------|------|
| Nie zrealizowano oferty | `NOT_REDEEMED` |
| Już oceniono | `ALREADY_REVIEWED` |
| Komentarz odrzucony | `COMMENT_REJECTED` |

### Zmiana nazwy/logo (POST /owner/venues/{id}/change-request)

| Warunek | Błąd |
|---------|------|
| Nie jest właścicielem | `FORBIDDEN` |
| Wniosek już w toku | `CHANGE_REQUEST_PENDING` |

### Wypowiedzenie (POST /owner/venues/{id}/terminate)

| Warunek | Błąd |
|---------|------|
| Nie jest właścicielem | `FORBIDDEN` |
| Już w wypowiedzeniu | `ALREADY_TERMINATING` |

---

## Flow moderacji ofert

1. Owner/Manager tworzy ofertę → status `DRAFT`
2. Wysyła do moderacji → status `PENDING_REVIEW`
3. AI analizuje (Perspective API + słownik):
   - score < 0.3 → auto-approve → `SCHEDULED` (za 3 dni)
   - score 0.3-0.7 → czeka na admina
   - score > 0.7 → auto-reject → `REJECTED`
4. Admin może:
   - Zatwierdzić → `SCHEDULED` (za 3 dni) lub `ACTIVE` (natychmiast)
   - Odrzucić → `REJECTED`
5. Cron job: `SCHEDULED` → `ACTIVE` w `scheduled_publish_at`

---

## Flow zmiany nazwy/logo

1. Owner składa wniosek → `VenueChangeRequest` status `PENDING`
2. Admin widzi w kolejce `/admin/venue-change-requests`
3. Admin zatwierdza lub odrzuca
4. Po zatwierdzeniu: nazwa/logo aktualizowane natychmiast

---

## Flow wypowiedzenia umowy

1. Owner klika "Wypowiedz umowę" → Venue status `TERMINATING`
2. `termination_effective_at` = teraz + 30 dni
3. W okresie wypowiedzenia:
   - Istniejące oferty działają normalnie
   - Nie można tworzyć nowych ofert
   - Managerowie nadal mają dostęp
4. Po 30 dniach → status `TERMINATED`
5. Lokal niewidoczny, dane archiwizowane

---

## JWT Claims

```json
{
  "sub": "uuid-użytkownika",
  "email": "jan@example.com",
  "name": "Jan Kowalski",
  "role": "VENUE_USER",
  "venues": [
    {"venueId": "uuid-1", "role": "OWNER"},
    {"venueId": "uuid-2", "role": "MANAGER"}
  ],
  "iat": 1700000000,
  "exp": 1700000900
}
```

- `role` - globalna rola (CLIENT, VENUE_USER, ADMIN)
- `venues` - lista lokali z rolami (tylko dla VENUE_USER)
- Access token: 15 minut
- Refresh token: 30 dni
