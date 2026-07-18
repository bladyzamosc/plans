# MVP Backlog - Tuswoi

## Epiki

| Epic | Opis | Priorytet |
|------|------|-----------|
| E1 | Setup projektu | 1 |
| E2 | Auth | 1 |
| E3 | Backend Core | 1 |
| E4 | Backend Panele | 2 |
| E5 | Mobile (klient) | 1 |
| E6 | Web | 2 |
| E7 | Integracje | 2 |
| E8 | Deploy | 3 |

---

## E1: Setup projektu

### E1-01: Utworzenie monorepo
**Opis:** Struktura projektu z pnpm workspaces
```
swoi/
├── apps/
│   ├── mobile/
│   ├── web/
│   └── backend/
├── packages/
│   ├── shared/
│   └── api-client/
├── docs/
├── pnpm-workspace.yaml
└── package.json
```
**Akceptacja:**
- [ ] pnpm install działa
- [ ] Wspólne dependencies w packages/

### E1-02: Setup backend (JHipster)
**Opis:** JHipster Spring Boot z PostgreSQL (--skip-client)
**Akceptacja:**
- [ ] mvn clean package działa
- [ ] Aplikacja startuje
- [ ] Połączenie z PostgreSQL

### E1-03: Setup mobile (Expo)
**Opis:** Expo z TypeScript, React Navigation
**Akceptacja:**
- [ ] expo start działa
- [ ] Działa na iOS/Android simulator
- [ ] Podstawowa nawigacja

### E1-04: Setup web (React)
**Opis:** React + Vite + TypeScript + TailwindCSS
**Akceptacja:**
- [ ] npm run dev działa
- [ ] Routing (React Router)
- [ ] Styl Apple Navy zaimportowany

### E1-05: CI/CD pipeline
**Opis:** GitHub Actions - build, test, deploy
**Akceptacja:**
- [ ] Build przy każdym PR
- [ ] Testy przy każdym PR
- [ ] Deploy staging po merge do main

---

## E2: Auth

### E2-01: Google OAuth
**Opis:** Logowanie przez Google (Spring Security OAuth2)
**Akceptacja:**
- [ ] Redirect do Google
- [ ] Callback tworzy/aktualizuje User
- [ ] Zwraca JWT

### E2-02: Apple OAuth
**Opis:** Logowanie przez Apple (wymagane na iOS)
**Akceptacja:**
- [ ] Redirect do Apple
- [ ] Zapisuje email (tylko pierwszy raz)
- [ ] Zwraca JWT

### E2-03: Magic link
**Opis:** Logowanie przez email (link ważny 15 min)
**Akceptacja:**
- [ ] Endpoint wysyła email z linkiem
- [ ] Klik w link → walidacja tokenu
- [ ] Zwraca JWT

### E2-04: JWT refresh
**Opis:** Silent refresh tokenów (access 1h, refresh 90 dni)
**Akceptacja:**
- [ ] Access token 1h
- [ ] Refresh token 90 dni
- [ ] Endpoint /auth/refresh
- [ ] Automatyczny refresh w mobile/web

### E2-05: Rejestracja klienta
**Opis:** Flow po pierwszym logowaniu
**Akceptacja:**
- [ ] Wybór okolicy (required)
- [ ] Wybór ulicy (required)
- [ ] Zgoda regulamin (required)
- [ ] Zgoda personalizacja (optional)

### E2-06: Zaproszenie właściciela
**Opis:** Admin tworzy lokal → email do właściciela
**Akceptacja:**
- [ ] Admin tworzy lokal + podaje email
- [ ] System wysyła email z linkiem + kodem
- [ ] Właściciel klika, uzupełnia dane, ustawia hasło
- [ ] Konto aktywne

---

## E3: Backend Core

### E3-01: Model danych - migracje
**Opis:** Liquibase/Flyway migracje dla wszystkich encji
**Akceptacja:**
- [ ] User, District, Venue, Offer, Redemption, etc.
- [ ] Indeksy zgodnie z MODEL-DANYCH.md
- [ ] Migracje działają na czystej bazie

### E3-02: CRUD Okolice (District)
**Opis:** API dla okolic
**Akceptacja:**
- [ ] GET /districts (lista)
- [ ] GET /districts/{id}
- [ ] GET /districts/search?lat=&lng= (geo)
- [ ] Admin: POST, PUT, DELETE

### E3-03: CRUD Lokale (Venue)
**Opis:** API dla lokali
**Akceptacja:**
- [ ] GET /venues (lista w okolicy)
- [ ] GET /venues/{id}
- [ ] Admin: POST, PUT, DELETE
- [ ] Owner: PUT (swój lokal)

### E3-04: CRUD Oferty (Offer)
**Opis:** API dla ofert
**Akceptacja:**
- [ ] GET /offers (lista aktywnych)
- [ ] GET /offers/{id}
- [ ] Owner/Manager: POST, PUT, DELETE (swoje)
- [ ] Status flow: DRAFT → PENDING → SCHEDULED → ACTIVE

### E3-05: Generowanie QR
**Opis:** User generuje kod QR do realizacji
**Akceptacja:**
- [ ] POST /offers/{id}/qr → QR code + expiry
- [ ] Format: RDM-XXXXXX
- [ ] Ważność: konfigurowana (5-60 min)
- [ ] Sprawdzenie czy user może (limit dzienny)

### E3-06: Walidacja QR
**Opis:** Pracownik waliduje QR kodem PIN
**Akceptacja:**
- [ ] GET /validate/{code} → info o ofercie
- [ ] POST /validate/{code} + PIN → realizacja
- [ ] Błędy: expired, already_used, wrong_pin

### E3-07: Limit dzienny
**Opis:** 1 oferta z lokalu na dzień per user
**Akceptacja:**
- [ ] Sprawdzenie przy generowaniu QR
- [ ] Reset o północy (kalendarzowo)
- [ ] Komunikat błędu

### E3-08: Moderacja treści
**Opis:** Słownik + Perspective API
**Akceptacja:**
- [ ] Własny słownik wulgaryzmów
- [ ] Integracja Perspective API
- [ ] Score < 0.3 → auto-approve
- [ ] Score 0.3-0.7 → pending
- [ ] Score > 0.7 → auto-reject

### E3-09: Ulubione lokale
**Opis:** User może dodać lokal do ulubionych
**Akceptacja:**
- [ ] POST /favorites/{venueId}
- [ ] DELETE /favorites/{venueId}
- [ ] GET /favorites

### E3-10: Historia realizacji
**Opis:** Lista zrealizowanych rabatów usera
**Akceptacja:**
- [ ] GET /redemptions (moje)
- [ ] Sortowanie po dacie
- [ ] Paginacja

---

## E4: Backend Panele

### E4-01: API właściciela - Dashboard
**Opis:** Statystyki lokalu
**Akceptacja:**
- [ ] GET /owner/dashboard
- [ ] Liczba realizacji (dziś, tydzień, miesiąc)
- [ ] Średnia ocena
- [ ] Top oferty

### E4-02: API właściciela - Oferty
**Opis:** Zarządzanie ofertami
**Akceptacja:**
- [ ] CRUD ofert (swój lokal)
- [ ] Lista z filtrami (status, data)
- [ ] Statystyki per oferta

### E4-03: API właściciela - Managerowie
**Opis:** Dodawanie/usuwanie managerów
**Akceptacja:**
- [ ] GET /owner/managers
- [ ] POST /owner/managers (invite)
- [ ] DELETE /owner/managers/{id}

### E4-04: API właściciela - Ustawienia
**Opis:** Edycja lokalu, zmiana PIN
**Akceptacja:**
- [ ] PUT /owner/venue (opis, godziny, etc.)
- [ ] PUT /owner/pin
- [ ] Zmiana nazwy/logo → pending review

### E4-05: API admina - Dashboard
**Opis:** Statystyki globalne
**Akceptacja:**
- [ ] Liczba userów, lokali, ofert, realizacji
- [ ] Wykresy (ostatnie 7/30 dni)
- [ ] Pending moderations count

### E4-06: API admina - Zarządzanie
**Opis:** CRUD dla wszystkich encji
**Akceptacja:**
- [ ] Okolice: CRUD
- [ ] Lokale: CRUD + aktywacja/deaktywacja
- [ ] Użytkownicy: lista, blokowanie
- [ ] Kategorie: CRUD

### E4-07: API admina - Moderacja
**Opis:** Zatwierdzanie/odrzucanie treści
**Akceptacja:**
- [ ] GET /admin/moderations (pending)
- [ ] POST /admin/moderations/{id}/approve
- [ ] POST /admin/moderations/{id}/reject

### E4-08: API admina - Zaproszenia
**Opis:** Zarządzanie zaproszeniami właścicieli
**Akceptacja:**
- [ ] GET /admin/invitations
- [ ] POST /admin/invitations (nowe)
- [ ] DELETE /admin/invitations/{id} (anuluj)
- [ ] POST /admin/invitations/{id}/resend

---

## E5: Mobile (klient)

### E5-01: Splash + logowanie
**Opis:** Ekran startowy z opcjami logowania
**Akceptacja:**
- [ ] Logo + hasło
- [ ] Przyciski: Google, Apple, Email
- [ ] Link: "Przeglądaj bez konta"

### E5-02: Onboarding (wybór okolicy)
**Opis:** Wybór okolicy po pierwszym logowaniu
**Akceptacja:**
- [ ] Geo-search (lub ręczny wybór)
- [ ] Lista okolic
- [ ] Wybór ulicy (autocomplete)

### E5-03: Lista ofert (Home)
**Opis:** Główny ekran z ofertami
**Akceptacja:**
- [ ] Lista ofert w okolicy
- [ ] Filtr po kategorii
- [ ] Pull-to-refresh
- [ ] Skeleton loading

### E5-04: Szczegóły oferty
**Opis:** Pełne info o ofercie
**Akceptacja:**
- [ ] Zdjęcie, tytuł, opis
- [ ] Info o lokalu
- [ ] Przycisk "Pokaż kod QR"
- [ ] Dodaj do ulubionych

### E5-05: Ekran QR
**Opis:** Wyświetlanie kodu QR
**Akceptacja:**
- [ ] Duży kod QR
- [ ] Timer odliczający
- [ ] Info o rabacie
- [ ] Jasność ekranu max

### E5-06: Profil
**Opis:** Dane użytkownika i ustawienia
**Akceptacja:**
- [ ] Avatar, imię, email
- [ ] Moje dzielnice
- [ ] Historia rabatów
- [ ] Ulubione
- [ ] Wyloguj

### E5-07: Historia
**Opis:** Lista zrealizowanych rabatów
**Akceptacja:**
- [ ] Lista z datą, lokalem, ofertą
- [ ] Możliwość oceny (1-5 + komentarz)

### E5-08: Ulubione
**Opis:** Lista ulubionych lokali
**Akceptacja:**
- [ ] Lista lokali
- [ ] Usuń z ulubionych
- [ ] Przejdź do lokalu

### E5-09: Push notifications
**Opis:** Obsługa powiadomień FCM
**Akceptacja:**
- [ ] Rejestracja tokenu FCM
- [ ] Odbieranie push
- [ ] Deep link do oferty

### E5-10: Wybór języka
**Opis:** PL/EN
**Akceptacja:**
- [ ] Dropdown w profilu
- [ ] Zapisanie preferencji
- [ ] i18n wszystkich tekstów

---

## E6: Web

### E6-01: Landing page
**Opis:** Strona główna (marketing)
**Akceptacja:**
- [ ] Hero + CTA
- [ ] Jak to działa
- [ ] Dla biznesu
- [ ] FAQ
- [ ] Footer (regulamin, prywatność, kontakt)

### E6-02: Strony statyczne
**Opis:** Regulamin, prywatność, FAQ, kontakt
**Akceptacja:**
- [ ] Treści z docs/legal/
- [ ] Styl Apple Navy
- [ ] Responsywne

### E6-03: Strona walidacji QR
**Opis:** Pracownik skanuje QR → otwiera tę stronę
**Akceptacja:**
- [ ] Info o ofercie
- [ ] Input na PIN
- [ ] Przycisk "Potwierdź"
- [ ] Komunikaty sukces/błąd

### E6-04: Panel właściciela - Dashboard
**Opis:** Strona główna panelu
**Akceptacja:**
- [ ] Statystyki (karty)
- [ ] Wykres realizacji
- [ ] Ostatnie realizacje

### E6-05: Panel właściciela - Oferty
**Opis:** Zarządzanie ofertami
**Akceptacja:**
- [ ] Lista ofert (tabela)
- [ ] Filtry (status)
- [ ] Tworzenie/edycja (formularz)
- [ ] Usuwanie

### E6-06: Panel właściciela - Realizacje
**Opis:** Historia realizacji
**Akceptacja:**
- [ ] Tabela z datą, ofertą, userem
- [ ] Filtry (data, oferta)
- [ ] Eksport CSV

### E6-07: Panel właściciela - Managerowie
**Opis:** Zarządzanie managerami
**Akceptacja:**
- [ ] Lista managerów
- [ ] Zaproszenie nowego
- [ ] Usunięcie

### E6-08: Panel właściciela - Ustawienia
**Opis:** Ustawienia lokalu i konta
**Akceptacja:**
- [ ] Edycja lokalu (opis, godziny)
- [ ] Zmiana PIN
- [ ] Zmiana hasła

### E6-09: Panel admina - Dashboard
**Opis:** Statystyki globalne
**Akceptacja:**
- [ ] Karty: userzy, lokale, oferty, realizacje
- [ ] Wykresy
- [ ] Alert: pending moderations

### E6-10: Panel admina - Okolice
**Opis:** Zarządzanie okolicami
**Akceptacja:**
- [ ] Tabela
- [ ] CRUD (modal/formularz)

### E6-11: Panel admina - Lokale
**Opis:** Zarządzanie lokalami
**Akceptacja:**
- [ ] Tabela z filtrami
- [ ] Szczegóły lokalu
- [ ] Aktywacja/deaktywacja

### E6-12: Panel admina - Użytkownicy
**Opis:** Lista użytkowników
**Akceptacja:**
- [ ] Tabela z wyszukiwaniem
- [ ] Szczegóły usera
- [ ] Blokowanie

### E6-13: Panel admina - Moderacja
**Opis:** Zatwierdzanie treści
**Akceptacja:**
- [ ] Lista pending
- [ ] Podgląd treści
- [ ] Approve/Reject

### E6-14: Panel admina - Zaproszenia
**Opis:** Zarządzanie zaproszeniami właścicieli
**Akceptacja:**
- [ ] Lista zaproszeń (status)
- [ ] Nowe zaproszenie
- [ ] Ponów/anuluj

---

## E7: Integracje

### E7-01: Firebase FCM
**Opis:** Push notifications
**Akceptacja:**
- [ ] Konfiguracja Firebase
- [ ] Wysyłanie push (backend)
- [ ] Odbieranie (mobile)

### E7-02: SendGrid
**Opis:** Emaile transakcyjne
**Akceptacja:**
- [ ] Konfiguracja SendGrid
- [ ] Szablony (magic link, zaproszenie, welcome)
- [ ] Wysyłanie z backendu

### E7-03: Sentry
**Opis:** Error tracking
**Akceptacja:**
- [ ] Konfiguracja (backend, mobile, web)
- [ ] Błędy raportowane
- [ ] Source maps (frontend)

### E7-04: Perspective API
**Opis:** Moderacja AI
**Akceptacja:**
- [ ] Konfiguracja klucza API
- [ ] Analiza tekstu ofert/komentarzy
- [ ] Zapis score w DB

---

## E8: Deploy

### E8-01: Staging environment
**Opis:** Środowisko testowe
**Akceptacja:**
- [ ] Backend + DB działają
- [ ] Web dostępny
- [ ] Auto-deploy po merge

### E8-02: Production environment
**Opis:** Środowisko produkcyjne
**Akceptacja:**
- [ ] Backend + DB (osobna instancja)
- [ ] Web (CDN)
- [ ] SSL certyfikaty
- [ ] Domena skonfigurowana

### E8-03: App Store submission
**Opis:** Publikacja iOS
**Akceptacja:**
- [ ] EAS Build (production)
- [ ] App Store Connect skonfigurowany
- [ ] Screenshots, opisy
- [ ] Submitted to review

### E8-04: Google Play submission
**Opis:** Publikacja Android
**Akceptacja:**
- [ ] EAS Build (production)
- [ ] Google Play Console skonfigurowany
- [ ] Screenshots, opisy
- [ ] Submitted to review

---

## Podsumowanie

| Epic | Tasków | Estymata |
|------|--------|----------|
| E1: Setup | 5 | 1 tydzień |
| E2: Auth | 6 | 1-2 tygodnie |
| E3: Backend Core | 10 | 2-3 tygodnie |
| E4: Backend Panele | 8 | 1-2 tygodnie |
| E5: Mobile | 10 | 2-3 tygodnie |
| E6: Web | 14 | 2-3 tygodnie |
| E7: Integracje | 4 | 1 tydzień |
| E8: Deploy | 4 | 1 tydzień |
| **TOTAL** | **61** | **10-15 tygodni** |

---

*Ostatnia aktualizacja: 2026-07-18*
