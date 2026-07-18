# ============================================
# Tuswoi MVP - GitHub Issues Creator
# ============================================
#
# Wymagania:
# 1. GitHub CLI zainstalowane: https://cli.github.com/
# 2. Zalogowany: gh auth login
# 3. Repo utworzone i ustawione jako remote
#
# Użycie:
# .\create-issues.ps1 -Repo "username/swoi"
#
# ============================================

param(
    [Parameter(Mandatory=$true)]
    [string]$Repo
)

$ErrorActionPreference = "Stop"

Write-Host "Creating GitHub Issues for: $Repo" -ForegroundColor Cyan
Write-Host ""

# Sprawdź czy gh jest zainstalowane
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: GitHub CLI (gh) not installed. Install from https://cli.github.com/" -ForegroundColor Red
    exit 1
}

# Sprawdź czy zalogowany
$authStatus = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Not logged in to GitHub. Run: gh auth login" -ForegroundColor Red
    exit 1
}

# ============================================
# Labels
# ============================================
Write-Host "Creating labels..." -ForegroundColor Yellow

$labels = @(
    @{ name = "epic:setup"; color = "0052CC"; description = "E1: Setup projektu" },
    @{ name = "epic:auth"; color = "5319E7"; description = "E2: Auth" },
    @{ name = "epic:backend-core"; color = "006B75"; description = "E3: Backend Core" },
    @{ name = "epic:backend-panels"; color = "1D76DB"; description = "E4: Backend Panele" },
    @{ name = "epic:mobile"; color = "D93F0B"; description = "E5: Mobile" },
    @{ name = "epic:web"; color = "FBCA04"; description = "E6: Web" },
    @{ name = "epic:integrations"; color = "B60205"; description = "E7: Integracje" },
    @{ name = "epic:deploy"; color = "0E8A16"; description = "E8: Deploy" },
    @{ name = "priority:high"; color = "D93F0B"; description = "High priority" },
    @{ name = "priority:medium"; color = "FBCA04"; description = "Medium priority" },
    @{ name = "priority:low"; color = "0E8A16"; description = "Low priority" }
)

foreach ($label in $labels) {
    gh label create $label.name --repo $Repo --color $label.color --description $label.description --force 2>$null
}

Write-Host "Labels created." -ForegroundColor Green
Write-Host ""

# ============================================
# Issues
# ============================================

$issues = @(
    # E1: Setup
    @{
        title = "[E1-01] Utworzenie monorepo"
        labels = "epic:setup,priority:high"
        body = @"
## Opis
Struktura projektu z pnpm workspaces

## Struktura
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

## Akceptacja
- [ ] pnpm install działa
- [ ] Wspólne dependencies w packages/
"@
    },
    @{
        title = "[E1-02] Setup backend (JHipster)"
        labels = "epic:setup,priority:high"
        body = @"
## Opis
JHipster Spring Boot z PostgreSQL (--skip-client)

## Akceptacja
- [ ] mvn clean package działa
- [ ] Aplikacja startuje
- [ ] Połączenie z PostgreSQL
"@
    },
    @{
        title = "[E1-03] Setup mobile (Expo)"
        labels = "epic:setup,priority:high"
        body = @"
## Opis
Expo z TypeScript, React Navigation

## Akceptacja
- [ ] expo start działa
- [ ] Działa na iOS/Android simulator
- [ ] Podstawowa nawigacja
"@
    },
    @{
        title = "[E1-04] Setup web (React)"
        labels = "epic:setup,priority:high"
        body = @"
## Opis
React + Vite + TypeScript + TailwindCSS

## Akceptacja
- [ ] npm run dev działa
- [ ] Routing (React Router)
- [ ] Styl Apple Navy zaimportowany
"@
    },
    @{
        title = "[E1-05] CI/CD pipeline"
        labels = "epic:setup,priority:medium"
        body = @"
## Opis
GitHub Actions - build, test, deploy

## Akceptacja
- [ ] Build przy każdym PR
- [ ] Testy przy każdym PR
- [ ] Deploy staging po merge do main
"@
    },

    # E2: Auth
    @{
        title = "[E2-01] Google OAuth"
        labels = "epic:auth,priority:high"
        body = @"
## Opis
Logowanie przez Google (Spring Security OAuth2)

## Akceptacja
- [ ] Redirect do Google
- [ ] Callback tworzy/aktualizuje User
- [ ] Zwraca JWT
"@
    },
    @{
        title = "[E2-02] Apple OAuth"
        labels = "epic:auth,priority:high"
        body = @"
## Opis
Logowanie przez Apple (wymagane na iOS)

## Akceptacja
- [ ] Redirect do Apple
- [ ] Zapisuje email (tylko pierwszy raz)
- [ ] Zwraca JWT
"@
    },
    @{
        title = "[E2-03] Magic link"
        labels = "epic:auth,priority:high"
        body = @"
## Opis
Logowanie przez email (link ważny 15 min)

## Akceptacja
- [ ] Endpoint wysyła email z linkiem
- [ ] Klik w link → walidacja tokenu
- [ ] Zwraca JWT
"@
    },
    @{
        title = "[E2-04] JWT refresh"
        labels = "epic:auth,priority:high"
        body = @"
## Opis
Silent refresh tokenów (access 1h, refresh 90 dni)

## Akceptacja
- [ ] Access token 1h
- [ ] Refresh token 90 dni
- [ ] Endpoint /auth/refresh
- [ ] Automatyczny refresh w mobile/web
"@
    },
    @{
        title = "[E2-05] Rejestracja klienta"
        labels = "epic:auth,priority:high"
        body = @"
## Opis
Flow po pierwszym logowaniu

## Akceptacja
- [ ] Wybór okolicy (required)
- [ ] Wybór ulicy (required)
- [ ] Zgoda regulamin (required)
- [ ] Zgoda personalizacja (optional)
"@
    },
    @{
        title = "[E2-06] Zaproszenie właściciela"
        labels = "epic:auth,priority:high"
        body = @"
## Opis
Admin tworzy lokal → email do właściciela

## Akceptacja
- [ ] Admin tworzy lokal + podaje email
- [ ] System wysyła email z linkiem + kodem
- [ ] Właściciel klika, uzupełnia dane, ustawia hasło
- [ ] Konto aktywne
"@
    },

    # E3: Backend Core
    @{
        title = "[E3-01] Model danych - migracje"
        labels = "epic:backend-core,priority:high"
        body = @"
## Opis
Liquibase/Flyway migracje dla wszystkich encji

## Akceptacja
- [ ] User, District, Venue, Offer, Redemption, etc.
- [ ] Indeksy zgodnie z MODEL-DANYCH.md
- [ ] Migracje działają na czystej bazie
"@
    },
    @{
        title = "[E3-02] CRUD Okolice (District)"
        labels = "epic:backend-core,priority:high"
        body = @"
## Opis
API dla okolic

## Akceptacja
- [ ] GET /districts (lista)
- [ ] GET /districts/{id}
- [ ] GET /districts/search?lat=&lng= (geo)
- [ ] Admin: POST, PUT, DELETE
"@
    },
    @{
        title = "[E3-03] CRUD Lokale (Venue)"
        labels = "epic:backend-core,priority:high"
        body = @"
## Opis
API dla lokali

## Akceptacja
- [ ] GET /venues (lista w okolicy)
- [ ] GET /venues/{id}
- [ ] Admin: POST, PUT, DELETE
- [ ] Owner: PUT (swój lokal)
"@
    },
    @{
        title = "[E3-04] CRUD Oferty (Offer)"
        labels = "epic:backend-core,priority:high"
        body = @"
## Opis
API dla ofert

## Akceptacja
- [ ] GET /offers (lista aktywnych)
- [ ] GET /offers/{id}
- [ ] Owner/Manager: POST, PUT, DELETE (swoje)
- [ ] Status flow: DRAFT → PENDING → SCHEDULED → ACTIVE
"@
    },
    @{
        title = "[E3-05] Generowanie QR"
        labels = "epic:backend-core,priority:high"
        body = @"
## Opis
User generuje kod QR do realizacji

## Akceptacja
- [ ] POST /offers/{id}/qr → QR code + expiry
- [ ] Format: RDM-XXXXXX
- [ ] Ważność: konfigurowana (5-60 min)
- [ ] Sprawdzenie czy user może (limit dzienny)
"@
    },
    @{
        title = "[E3-06] Walidacja QR"
        labels = "epic:backend-core,priority:high"
        body = @"
## Opis
Pracownik waliduje QR kodem PIN

## Akceptacja
- [ ] GET /validate/{code} → info o ofercie
- [ ] POST /validate/{code} + PIN → realizacja
- [ ] Błędy: expired, already_used, wrong_pin
"@
    },
    @{
        title = "[E3-07] Limit dzienny"
        labels = "epic:backend-core,priority:high"
        body = @"
## Opis
1 oferta z lokalu na dzień per user

## Akceptacja
- [ ] Sprawdzenie przy generowaniu QR
- [ ] Reset o północy (kalendarzowo)
- [ ] Komunikat błędu
"@
    },
    @{
        title = "[E3-08] Moderacja treści"
        labels = "epic:backend-core,priority:medium"
        body = @"
## Opis
Słownik + Perspective API

## Akceptacja
- [ ] Własny słownik wulgaryzmów
- [ ] Integracja Perspective API
- [ ] Score < 0.3 → auto-approve
- [ ] Score 0.3-0.7 → pending
- [ ] Score > 0.7 → auto-reject
"@
    },
    @{
        title = "[E3-09] Ulubione lokale"
        labels = "epic:backend-core,priority:low"
        body = @"
## Opis
User może dodać lokal do ulubionych

## Akceptacja
- [ ] POST /favorites/{venueId}
- [ ] DELETE /favorites/{venueId}
- [ ] GET /favorites
"@
    },
    @{
        title = "[E3-10] Historia realizacji"
        labels = "epic:backend-core,priority:medium"
        body = @"
## Opis
Lista zrealizowanych rabatów usera

## Akceptacja
- [ ] GET /redemptions (moje)
- [ ] Sortowanie po dacie
- [ ] Paginacja
"@
    },

    # E4: Backend Panele
    @{
        title = "[E4-01] API właściciela - Dashboard"
        labels = "epic:backend-panels,priority:medium"
        body = @"
## Opis
Statystyki lokalu

## Akceptacja
- [ ] GET /owner/dashboard
- [ ] Liczba realizacji (dziś, tydzień, miesiąc)
- [ ] Średnia ocena
- [ ] Top oferty
"@
    },
    @{
        title = "[E4-02] API właściciela - Oferty"
        labels = "epic:backend-panels,priority:high"
        body = @"
## Opis
Zarządzanie ofertami

## Akceptacja
- [ ] CRUD ofert (swój lokal)
- [ ] Lista z filtrami (status, data)
- [ ] Statystyki per oferta
"@
    },
    @{
        title = "[E4-03] API właściciela - Managerowie"
        labels = "epic:backend-panels,priority:low"
        body = @"
## Opis
Dodawanie/usuwanie managerów

## Akceptacja
- [ ] GET /owner/managers
- [ ] POST /owner/managers (invite)
- [ ] DELETE /owner/managers/{id}
"@
    },
    @{
        title = "[E4-04] API właściciela - Ustawienia"
        labels = "epic:backend-panels,priority:medium"
        body = @"
## Opis
Edycja lokalu, zmiana PIN

## Akceptacja
- [ ] PUT /owner/venue (opis, godziny, etc.)
- [ ] PUT /owner/pin
- [ ] Zmiana nazwy/logo → pending review
"@
    },
    @{
        title = "[E4-05] API admina - Dashboard"
        labels = "epic:backend-panels,priority:medium"
        body = @"
## Opis
Statystyki globalne

## Akceptacja
- [ ] Liczba userów, lokali, ofert, realizacji
- [ ] Wykresy (ostatnie 7/30 dni)
- [ ] Pending moderations count
"@
    },
    @{
        title = "[E4-06] API admina - Zarządzanie"
        labels = "epic:backend-panels,priority:high"
        body = @"
## Opis
CRUD dla wszystkich encji

## Akceptacja
- [ ] Okolice: CRUD
- [ ] Lokale: CRUD + aktywacja/deaktywacja
- [ ] Użytkownicy: lista, blokowanie
- [ ] Kategorie: CRUD
"@
    },
    @{
        title = "[E4-07] API admina - Moderacja"
        labels = "epic:backend-panels,priority:medium"
        body = @"
## Opis
Zatwierdzanie/odrzucanie treści

## Akceptacja
- [ ] GET /admin/moderations (pending)
- [ ] POST /admin/moderations/{id}/approve
- [ ] POST /admin/moderations/{id}/reject
"@
    },
    @{
        title = "[E4-08] API admina - Zaproszenia"
        labels = "epic:backend-panels,priority:high"
        body = @"
## Opis
Zarządzanie zaproszeniami właścicieli

## Akceptacja
- [ ] GET /admin/invitations
- [ ] POST /admin/invitations (nowe)
- [ ] DELETE /admin/invitations/{id} (anuluj)
- [ ] POST /admin/invitations/{id}/resend
"@
    },

    # E5: Mobile
    @{
        title = "[E5-01] Splash + logowanie"
        labels = "epic:mobile,priority:high"
        body = @"
## Opis
Ekran startowy z opcjami logowania

## Akceptacja
- [ ] Logo + hasło
- [ ] Przyciski: Google, Apple, Email
- [ ] Link: "Przeglądaj bez konta"
"@
    },
    @{
        title = "[E5-02] Onboarding (wybór okolicy)"
        labels = "epic:mobile,priority:high"
        body = @"
## Opis
Wybór okolicy po pierwszym logowaniu

## Akceptacja
- [ ] Geo-search (lub ręczny wybór)
- [ ] Lista okolic
- [ ] Wybór ulicy (autocomplete)
"@
    },
    @{
        title = "[E5-03] Lista ofert (Home)"
        labels = "epic:mobile,priority:high"
        body = @"
## Opis
Główny ekran z ofertami

## Akceptacja
- [ ] Lista ofert w okolicy
- [ ] Filtr po kategorii
- [ ] Pull-to-refresh
- [ ] Skeleton loading
"@
    },
    @{
        title = "[E5-04] Szczegóły oferty"
        labels = "epic:mobile,priority:high"
        body = @"
## Opis
Pełne info o ofercie

## Akceptacja
- [ ] Zdjęcie, tytuł, opis
- [ ] Info o lokalu
- [ ] Przycisk "Pokaż kod QR"
- [ ] Dodaj do ulubionych
"@
    },
    @{
        title = "[E5-05] Ekran QR"
        labels = "epic:mobile,priority:high"
        body = @"
## Opis
Wyświetlanie kodu QR

## Akceptacja
- [ ] Duży kod QR
- [ ] Timer odliczający
- [ ] Info o rabacie
- [ ] Jasność ekranu max
"@
    },
    @{
        title = "[E5-06] Profil"
        labels = "epic:mobile,priority:medium"
        body = @"
## Opis
Dane użytkownika i ustawienia

## Akceptacja
- [ ] Avatar, imię, email
- [ ] Moje dzielnice
- [ ] Historia rabatów
- [ ] Ulubione
- [ ] Wyloguj
"@
    },
    @{
        title = "[E5-07] Historia"
        labels = "epic:mobile,priority:medium"
        body = @"
## Opis
Lista zrealizowanych rabatów

## Akceptacja
- [ ] Lista z datą, lokalem, ofertą
- [ ] Możliwość oceny (1-5 + komentarz)
"@
    },
    @{
        title = "[E5-08] Ulubione"
        labels = "epic:mobile,priority:low"
        body = @"
## Opis
Lista ulubionych lokali

## Akceptacja
- [ ] Lista lokali
- [ ] Usuń z ulubionych
- [ ] Przejdź do lokalu
"@
    },
    @{
        title = "[E5-09] Push notifications"
        labels = "epic:mobile,priority:medium"
        body = @"
## Opis
Obsługa powiadomień FCM

## Akceptacja
- [ ] Rejestracja tokenu FCM
- [ ] Odbieranie push
- [ ] Deep link do oferty
"@
    },
    @{
        title = "[E5-10] Wybór języka"
        labels = "epic:mobile,priority:low"
        body = @"
## Opis
PL/EN

## Akceptacja
- [ ] Dropdown w profilu
- [ ] Zapisanie preferencji
- [ ] i18n wszystkich tekstów
"@
    },

    # E6: Web
    @{
        title = "[E6-01] Landing page"
        labels = "epic:web,priority:high"
        body = @"
## Opis
Strona główna (marketing)

## Akceptacja
- [ ] Hero + CTA
- [ ] Jak to działa
- [ ] Dla biznesu
- [ ] FAQ
- [ ] Footer (regulamin, prywatność, kontakt)
"@
    },
    @{
        title = "[E6-02] Strony statyczne"
        labels = "epic:web,priority:medium"
        body = @"
## Opis
Regulamin, prywatność, FAQ, kontakt

## Akceptacja
- [ ] Treści z docs/legal/
- [ ] Styl Apple Navy
- [ ] Responsywne
"@
    },
    @{
        title = "[E6-03] Strona walidacji QR"
        labels = "epic:web,priority:high"
        body = @"
## Opis
Pracownik skanuje QR → otwiera tę stronę

## Akceptacja
- [ ] Info o ofercie
- [ ] Input na PIN
- [ ] Przycisk "Potwierdź"
- [ ] Komunikaty sukces/błąd
"@
    },
    @{
        title = "[E6-04] Panel właściciela - Dashboard"
        labels = "epic:web,priority:medium"
        body = @"
## Opis
Strona główna panelu

## Akceptacja
- [ ] Statystyki (karty)
- [ ] Wykres realizacji
- [ ] Ostatnie realizacje
"@
    },
    @{
        title = "[E6-05] Panel właściciela - Oferty"
        labels = "epic:web,priority:high"
        body = @"
## Opis
Zarządzanie ofertami

## Akceptacja
- [ ] Lista ofert (tabela)
- [ ] Filtry (status)
- [ ] Tworzenie/edycja (formularz)
- [ ] Usuwanie
"@
    },
    @{
        title = "[E6-06] Panel właściciela - Realizacje"
        labels = "epic:web,priority:medium"
        body = @"
## Opis
Historia realizacji

## Akceptacja
- [ ] Tabela z datą, ofertą, userem
- [ ] Filtry (data, oferta)
- [ ] Eksport CSV
"@
    },
    @{
        title = "[E6-07] Panel właściciela - Managerowie"
        labels = "epic:web,priority:low"
        body = @"
## Opis
Zarządzanie managerami

## Akceptacja
- [ ] Lista managerów
- [ ] Zaproszenie nowego
- [ ] Usunięcie
"@
    },
    @{
        title = "[E6-08] Panel właściciela - Ustawienia"
        labels = "epic:web,priority:medium"
        body = @"
## Opis
Ustawienia lokalu i konta

## Akceptacja
- [ ] Edycja lokalu (opis, godziny)
- [ ] Zmiana PIN
- [ ] Zmiana hasła
"@
    },
    @{
        title = "[E6-09] Panel admina - Dashboard"
        labels = "epic:web,priority:medium"
        body = @"
## Opis
Statystyki globalne

## Akceptacja
- [ ] Karty: userzy, lokale, oferty, realizacje
- [ ] Wykresy
- [ ] Alert: pending moderations
"@
    },
    @{
        title = "[E6-10] Panel admina - Okolice"
        labels = "epic:web,priority:medium"
        body = @"
## Opis
Zarządzanie okolicami

## Akceptacja
- [ ] Tabela
- [ ] CRUD (modal/formularz)
"@
    },
    @{
        title = "[E6-11] Panel admina - Lokale"
        labels = "epic:web,priority:high"
        body = @"
## Opis
Zarządzanie lokalami

## Akceptacja
- [ ] Tabela z filtrami
- [ ] Szczegóły lokalu
- [ ] Aktywacja/deaktywacja
"@
    },
    @{
        title = "[E6-12] Panel admina - Użytkownicy"
        labels = "epic:web,priority:medium"
        body = @"
## Opis
Lista użytkowników

## Akceptacja
- [ ] Tabela z wyszukiwaniem
- [ ] Szczegóły usera
- [ ] Blokowanie
"@
    },
    @{
        title = "[E6-13] Panel admina - Moderacja"
        labels = "epic:web,priority:high"
        body = @"
## Opis
Zatwierdzanie treści

## Akceptacja
- [ ] Lista pending
- [ ] Podgląd treści
- [ ] Approve/Reject
"@
    },
    @{
        title = "[E6-14] Panel admina - Zaproszenia"
        labels = "epic:web,priority:high"
        body = @"
## Opis
Zarządzanie zaproszeniami właścicieli

## Akceptacja
- [ ] Lista zaproszeń (status)
- [ ] Nowe zaproszenie
- [ ] Ponów/anuluj
"@
    },

    # E7: Integracje
    @{
        title = "[E7-01] Firebase FCM"
        labels = "epic:integrations,priority:medium"
        body = @"
## Opis
Push notifications

## Akceptacja
- [ ] Konfiguracja Firebase
- [ ] Wysyłanie push (backend)
- [ ] Odbieranie (mobile)
"@
    },
    @{
        title = "[E7-02] SendGrid"
        labels = "epic:integrations,priority:high"
        body = @"
## Opis
Emaile transakcyjne

## Akceptacja
- [ ] Konfiguracja SendGrid
- [ ] Szablony (magic link, zaproszenie, welcome)
- [ ] Wysyłanie z backendu
"@
    },
    @{
        title = "[E7-03] Sentry"
        labels = "epic:integrations,priority:medium"
        body = @"
## Opis
Error tracking

## Akceptacja
- [ ] Konfiguracja (backend, mobile, web)
- [ ] Błędy raportowane
- [ ] Source maps (frontend)
"@
    },
    @{
        title = "[E7-04] Perspective API"
        labels = "epic:integrations,priority:medium"
        body = @"
## Opis
Moderacja AI

## Akceptacja
- [ ] Konfiguracja klucza API
- [ ] Analiza tekstu ofert/komentarzy
- [ ] Zapis score w DB
"@
    },

    # E8: Deploy
    @{
        title = "[E8-01] Staging environment"
        labels = "epic:deploy,priority:high"
        body = @"
## Opis
Środowisko testowe

## Akceptacja
- [ ] Backend + DB działają
- [ ] Web dostępny
- [ ] Auto-deploy po merge
"@
    },
    @{
        title = "[E8-02] Production environment"
        labels = "epic:deploy,priority:high"
        body = @"
## Opis
Środowisko produkcyjne

## Akceptacja
- [ ] Backend + DB (osobna instancja)
- [ ] Web (CDN)
- [ ] SSL certyfikaty
- [ ] Domena skonfigurowana
"@
    },
    @{
        title = "[E8-03] App Store submission"
        labels = "epic:deploy,priority:high"
        body = @"
## Opis
Publikacja iOS

## Akceptacja
- [ ] EAS Build (production)
- [ ] App Store Connect skonfigurowany
- [ ] Screenshots, opisy
- [ ] Submitted to review
"@
    },
    @{
        title = "[E8-04] Google Play submission"
        labels = "epic:deploy,priority:high"
        body = @"
## Opis
Publikacja Android

## Akceptacja
- [ ] EAS Build (production)
- [ ] Google Play Console skonfigurowany
- [ ] Screenshots, opisy
- [ ] Submitted to review
"@
    }
)

# ============================================
# Create Issues
# ============================================
Write-Host "Creating issues..." -ForegroundColor Yellow

$created = 0
foreach ($issue in $issues) {
    Write-Host "  Creating: $($issue.title)" -ForegroundColor Gray

    gh issue create `
        --repo $Repo `
        --title $issue.title `
        --body $issue.body `
        --label $issue.labels

    if ($LASTEXITCODE -eq 0) {
        $created++
    }

    # Rate limiting - GitHub ma limity
    Start-Sleep -Milliseconds 500
}

Write-Host ""
Write-Host "Done! Created $created issues." -ForegroundColor Green
Write-Host "View at: https://github.com/$Repo/issues" -ForegroundColor Cyan
