# Workacje.pl - Fazy rozwoju

## MVP (Faza 0) - Landing page jednej oferty

**Cel:** Wystawić https://workacje.pl/baltycki jako działającą stronę oferty

### Zakres funkcjonalny
- [x] Strona oferty `/baltycki` (slug z nazwy)
- [x] Mapa z lokalizacją (Leaflet/OpenStreetMap)
- [x] Galeria zdjęć
- [x] Opis, udogodnienia, cennik
- [x] Dane kontaktowe właściciela (telefon, email)
- [ ] Formularz kontaktowy (wysyła email do właściciela)
- [ ] SEO: meta tags, Open Graph

### Czego NIE MA w MVP
- Rejestracja / logowanie
- Panel właściciela
- Panel admina
- Wyszukiwarka
- System rezerwacji / zapytań w bazie
- Synchronizacja kalendarza (iCal)
- Strona główna (redirect na /baltycki lub prosta landing)

### Dane w bazie
```
Property:
  id: 1
  slug: "baltycki"
  title: "Bałtycki"
  description: "..."
  city: "Tupadły"
  address: "..."
  latitude: ...
  longitude: ...
  rooms, bathrooms, area, maxGuests
  ownerPhone, ownerEmail (denormalizowane - bez User)

Photo:
  property_id: 1
  url: "..."
  position: 1-10
  isMain: true/false

PricingTier:
  property_id: 1
  weeksFrom, weeksTo, priceTotal

PropertyAmenity:
  property_id: 1
  amenity_code: "WIFI_SPEED"
  value: "300"
```

### Routing
| URL | Co wyświetla |
|-----|--------------|
| `/` | Redirect na `/baltycki` LUB prosta strona "Wkrótce więcej ofert" |
| `/baltycki` | Strona oferty |
| `/[slug]` | 404 (tylko baltycki istnieje) |

### Infrastruktura (do zrobienia teraz)
- [ ] Domena workacje.pl (OVH/home.pl/nazwa.pl?)
- [ ] Hosting (Azure App Service / VPS?)
- [ ] SSL (Let's Encrypt)
- [ ] PostgreSQL (Azure Database / własny?)
- [ ] Pipeline CI/CD (GitHub Actions)
- [ ] Środowiska: test.workacje.pl, workacje.pl

### Stack techniczny
- JHipster monolith (Spring Boot + Angular)
- PostgreSQL
- Leaflet + OpenStreetMap (mapa)
- Lucide icons

---

## Faza 1 - Strona główna + wyszukiwarka

**Cel:** Możliwość dodawania kolejnych ofert i ich wyszukiwania

### Zakres
- [ ] Strona główna z wyszukiwarką
- [ ] Lista wyników wyszukiwania
- [ ] Filtrowanie (miasto, cena, udogodnienia)
- [ ] Panel właściciela: CRUD ofert
- [ ] Rejestracja/logowanie właścicieli
- [ ] Dodawanie zdjęć (upload)

### Routing
| URL | Co wyświetla |
|-----|--------------|
| `/` | Strona główna z wyszukiwarką |
| `/szukaj` | Wyniki wyszukiwania |
| `/[slug]` | Strona oferty |
| `/panel/oferty` | Lista ofert właściciela |
| `/panel/oferty/nowa` | Formularz nowej oferty |

---

## Faza 2 - System rezerwacji

**Cel:** Goście mogą wysyłać zapytania, właściciele zarządzają rezerwacjami

### Zakres
- [ ] Formularz zapytania na stronie oferty
- [ ] Lazy registration gościa (konto tworzone przy zapytaniu)
- [ ] Panel właściciela: lista rezerwacji
- [ ] Panel właściciela: szczegóły rezerwacji, zmiana statusu
- [ ] Panel gościa: moje rezerwacje
- [ ] Powiadomienia email (zapytanie, potwierdzenie, odrzucenie)
- [ ] Cron: auto-expire po 24h bez odpowiedzi

### Statusy rezerwacji
INQUIRY → CONFIRMED / REJECTED / EXPIRED
CONFIRMED → PREPAID → COMPLETED
CONFIRMED → CANCELLED

---

## Faza 3 - Wiadomości + kalendarz

**Cel:** Komunikacja między gościem a właścicielem, zarządzanie dostępnością

### Zakres
- [ ] System wiadomości (chat per rezerwacja)
- [ ] Panel właściciela: kalendarz z rezerwacjami
- [ ] Okresy dostępności (Availability)
- [ ] Import iCal (Airbnb, Booking)
- [ ] Eksport iCal

---

## Faza 4 - Statystyki + wyróżnienia

**Cel:** Właściciele widzą performance, możliwość promowania ofert

### Zakres
- [ ] Panel właściciela: statystyki (wyświetlenia, zapytania, konwersja)
- [ ] PageView tracking
- [ ] Wyróżnione oferty na stronie głównej
- [ ] Panel admina: zarządzanie wyróżnieniami

---

## Faza 5 - Panel admina + moderacja

**Cel:** Pełna kontrola nad platformą

### Zakres
- [ ] Dashboard admina
- [ ] Zarządzanie użytkownikami
- [ ] Zarządzanie ofertami (wyłączanie naruszeń)
- [ ] Zarządzanie tagami/amenities
- [ ] Ustawienia platformy
- [ ] Logi audytu

---

## Faza 6 - Płatności + prowizja

**Cel:** Monetyzacja platformy

### Zakres
- [ ] Płatność za wyróżnienie (Stripe/PayU)
- [ ] Prowizja od rezerwacji (opcjonalnie)
- [ ] Faktury

---

## Promocja ofert - Poradnik dla właścicieli

**Cel:** Pomóc właścicielom promować swoje oferty i przyciągać gości

### Social media

#### Facebook
- [ ] Post na własnym profilu z linkiem do oferty
- [ ] Grupy tematyczne: "Praca zdalna Polska", "Workation Polska", "Digital Nomads Poland"
- [ ] Grupy lokalne: "Wynajem nad morzem", grupy miast (Trójmiasto, Gdańsk, Sopot)
- [ ] Facebook Marketplace (kategoria: Wynajem wakacyjny)

#### Instagram
- [ ] Profil oferty z zdjęciami wnętrza i okolicy
- [ ] Stories z "behind the scenes"
- [ ] Reels: krótkie wideo pokazujące przestrzeń do pracy
- [ ] Hashtagi: #workation #pracazdalna #workationpolska #nadmorze #remotework

#### TikTok
- [ ] Krótkie wideo "Tour po mieszkaniu"
- [ ] "Dzień z życia" pracującego zdalnie w lokalizacji
- [ ] Trending sounds + pokazanie widoków/wnętrza

### Google

#### Wizytówka Google (Google Business Profile)
- [ ] Dodaj wizytówkę jako "Wynajem krótkoterminowy" lub "Apartament"
- [ ] Adres, telefon, godziny (zawsze dostępne)
- [ ] Link do oferty: `https://workacje.pl/[slug]`
- [ ] Zdjęcia (minimum 10)
- [ ] Zbieraj opinie od gości

#### SEO
- [ ] Link do oferty w opisach social media
- [ ] Wpis na blogu (jeśli masz) z linkiem

### Inne kanały

#### Poczta pantoflowa
- [ ] Powiedz znajomym i rodzinie
- [ ] Wizytówki w lokalnych kawiarniach/coworkingach
- [ ] Lokalne grupy na WhatsApp/Signal

#### Portale ogłoszeniowe (z linkiem do workacje.pl)
- [ ] OLX (w opisie link do pełnej oferty)
- [ ] Gumtree
- [ ] Lokalne portale ogłoszeniowe

#### Współpraca
- [ ] Lokalne firmy (catering, sprzątanie) - wzajemna promocja
- [ ] Influencerzy travel/remote work - zaproszenie na pobyt za recenzję

### Szablon posta

```
🏠 Szukasz miejsca na workation nad morzem?

Polecam [NAZWA] w [MIASTO] - idealne dla pracujących zdalnie:
✅ Szybki internet [X] Mbps
✅ Wygodne biurko do pracy
✅ [X] min do plaży
✅ Cisza i spokój

📅 Dostępne terminy i ceny: https://workacje.pl/[slug]

#workation #pracazdalna #nadmorze
```

### Materiały do pobrania (TODO: Faza 2+)
- [ ] Szablony grafik do social media
- [ ] QR code do oferty
- [ ] Gotowe teksty postów

---

## Infrastruktura - decyzje do podjęcia

### Domena
| Opcja | Cena/rok | Uwagi |
|-------|----------|-------|
| OVH | ~50 PLN | Popularny w PL |
| home.pl | ~60 PLN | Polski support |
| nazwa.pl | ~55 PLN | Polski |
| Cloudflare | ~45 PLN | + CDN gratis |

### Hosting

**Strategia:** Zaczynamy od free tier (dev/test), po Fazie 1 przenosimy na płatny.

| Faza | Środowisko | Hosting | Koszt |
|------|------------|---------|-------|
| MVP-1 | dev/test | fly.io / Railway / Render | FREE |
| 2+ | prod | Azure App Service / Hetzner VPS | 50-100 PLN/mies |

| Opcja free | Limity | Uwagi |
|------------|--------|-------|
| fly.io | 3 shared VMs, 3GB storage | Dobry na start |
| Railway | 500h/mies, 1GB RAM | Łatwy deploy |
| Render | 750h/mies | Auto-sleep po 15min |

### Baza danych
| Opcja | Cena/mies | Uwagi |
|-------|-----------|-------|
| Azure Database for PostgreSQL | ~100 PLN | Managed, backup |
| Supabase | Free tier | PostgreSQL + API |
| Na VPS | 0 PLN | Sam zarządzasz |

### CI/CD
- GitHub Actions (free dla public repo)
- Środowiska:
  - `test.workacje.pl` - deploy z brancha `develop`
  - `workacje.pl` - deploy z brancha `main` (manual trigger)

---

## Architektura MVP

```
┌─────────────────────────────────────────────────┐
│                   Internet                       │
└─────────────────────┬───────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│              Cloudflare (DNS + CDN)              │
│         workacje.pl → Azure/VPS IP               │
└─────────────────────┬───────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────┐
│            Azure App Service / VPS               │
│  ┌───────────────────────────────────────────┐  │
│  │         JHipster Monolith                 │  │
│  │  ┌─────────────┐    ┌─────────────────┐   │  │
│  │  │   Angular   │    │   Spring Boot   │   │  │
│  │  │  (Frontend) │◄──►│    (Backend)    │   │  │
│  │  └─────────────┘    └────────┬────────┘   │  │
│  └──────────────────────────────┼────────────┘  │
└─────────────────────────────────┼───────────────┘
                                  │
                                  ▼
                      ┌───────────────────────┐
                      │     PostgreSQL        │
                      │   (Azure/Supabase)    │
                      └───────────────────────┘
```

---

## Pipeline CI/CD

```yaml
# .github/workflows/deploy.yml

name: Build & Deploy

on:
  push:
    branches: [main, develop]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          java-version: '21'
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      
      - name: Build
        run: ./mvnw -Pprod clean verify
      
      - name: Upload artifact
        uses: actions/upload-artifact@v4
        with:
          name: app
          path: target/*.jar

  deploy-test:
    needs: build
    if: github.ref == 'refs/heads/develop'
    runs-on: ubuntu-latest
    environment: test
    steps:
      - name: Deploy to test.workacje.pl
        run: # deploy script

  deploy-prod:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: production
    steps:
      - name: Deploy to workacje.pl
        run: # deploy script
```

---

## Następne kroki (teraz)

1. [ ] **Decyzja: hosting** - Azure vs VPS vs fly.io
2. [ ] **Decyzja: domena** - gdzie kupić
3. [ ] **Zakup domeny** workacje.pl
4. [ ] **Setup repo** GitHub + branch strategy (main/develop)
5. [ ] **JHipster init** - wygenerować projekt
6. [ ] **Model danych MVP** - tylko Property, Photo, PricingTier, Amenity
7. [ ] **Pipeline CI/CD** - GitHub Actions
8. [ ] **Deploy test** - test.workacje.pl
9. [ ] **Strona /baltycki** - implementacja
10. [ ] **Deploy prod** - workacje.pl

---

## Dane oferty "Bałtycki" (do uzupełnienia)

```yaml
title: "Bałtycki"
slug: "baltycki"
city: "Tupadły"
address: "???"
latitude: ???
longitude: ???
rooms: ???
bathrooms: ???
area: ??? m²
maxGuests: ???
description: |
  ???

ownerPhone: "???"
ownerEmail: "???"

pricing:
  - weeks: 1, price: ??? PLN
  - weeks: 2, price: ??? PLN
  - weeks: 3, price: ??? PLN
  - weeks: 4+, price: ??? PLN

amenities:
  - WIFI_SPEED: ??? Mbps
  - BEACH_DISTANCE: ??? m
  - DESK: true
  - ???

photos:
  - ??? (10 zdjęć)
```
