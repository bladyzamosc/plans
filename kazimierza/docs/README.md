# Swoi — Aplikacja Lokalnych Rabatów

## Cel projektu

Aplikacja zrzeszająca lokalne biznesy (niesieciowe) — mieszkańcy otrzymują powiadomienia o rabatach w swojej okolicy. Start na Odolanach, potem ekspansja na kolejne okolice.

**Hasło:** „Łączymy się lokalnie!"

**Why:** Wspieranie lokalnego biznesu, budowanie społeczności wokół okolicy.

> **Okolica** = dzielnica, poddzielnica (np. Odolany na Woli), małe miasto, kilka wsi. Uniwersalna jednostka geograficzna w aplikacji.

---

## Spis treści

1. [Nazwa aplikacji](#nazwa-aplikacji)
2. [Decyzje techniczne](#decyzje-techniczne)
3. [Role i uprawnienia](#role-i-uprawnienia)
4. [Reguły biznesowe](#reguły-biznesowe)
5. [Flow-y użytkownika](#flow-y-użytkownika)
6. [Push notifications](#push-notifications)
7. [Scope MVP vs Faza 2](#scope-mvp-vs-faza-2)
8. [Dokumentacja techniczna](#dokumentacja-techniczna)
9. [Mockupy](#mockupy)

---

## Nazwa aplikacji

**Problem:** "Kazimierza" to nazwa ulicy (Jana Kazimierza) — nie skaluje się przy ekspansji na inne okolice.

**Kierunek:** Nazwa powinna kojarzyć się z budowaniem lokalnej społeczności i wspieraniem lokalnego rynku, nie z rabatami/promocjami.

### Propozycje domen (do wyboru)

| Domena | Klimat | Rekomendacja |
|--------|--------|--------------|
| **tuswoi.pl** | "Tu swoi" — lokalni ludzie tutaj | ⭐⭐⭐ TOP |
| **laczmysie.pl** | Idealne do hasła "Łączymy się lokalnie!" | ⭐⭐⭐ TOP |
| **razemlokalni.pl** | Wspólnota, razem | ⭐⭐ |
| **uswoi.pl** | "U swoich" | ⭐⭐ |
| **naszacy.pl** | Slangowe "nasi", młode | ⭐ |
| **zaulka.pl** | "Z ulicy", lokalne | ⭐ |
| **tuswoich.pl** | Wariant tuswoi | ⭐ |

*Weryfikacja DNS: 2026-07-17. Domeny prawdopodobnie wolne — do potwierdzenia na home.pl przed zakupem.*

**Status:** Do wyboru. Roboczo używamy "Swoi" w mockupach.

---

## Decyzje techniczne

| Obszar | Decyzja |
|--------|---------|
| Mobile (klient) | React Native (iOS + Android) |
| Web | React — jedna aplikacja |
| Backend | JHipster (--skip-client) + Spring Boot + PostgreSQL |

### Architektura — Monorepo

```
swoi/
├── apps/
│   ├── mobile/          # Expo (iOS, Android, Web klienta)
│   ├── web/             # React (landing, admin, owner)
│   └── backend/         # JHipster Spring Boot (--skip-client)
├── packages/
│   ├── shared/          # Typy TypeScript, utils
│   └── api-client/      # Wygenerowany klient z OpenAPI
├── docs/                # Dokumentacja
└── package.json         # pnpm workspaces
```

### Aplikacje

| App | Technologia | Zawartość |
|-----|-------------|-----------|
| **mobile** | Expo (React Native Web) | Flow klienta: onboarding, oferty, QR, profil — iOS, Android + Web |
| **web** | React | Landing page, QR do apki, FAQ, regulamin + panele admin/owner |
| **backend** | JHipster + Spring Boot | API REST, PostgreSQL, JWT auth |

### Struktura Web (React)

| Sekcja | Dostęp | Zawartość |
|--------|--------|-----------|
| Landing page | Publiczny | Strona główna, o aplikacji, QR do pobrania apki |
| Strony statyczne | Publiczny | FAQ, regulamin, polityka prywatności, kontakt |
| Panel właściciela | OWNER/MANAGER | Dashboard, oferty, realizacje, managerowie, ustawienia |
| Panel admina | ADMIN | Dashboard, okolice, lokale, użytkownicy, moderacja |
| Auth | Google, Apple + Magic link (fallback) + hasło (dla owner/manager) |
| Sesja | JWT access (15 min) + refresh token (30 dni) |
| Walidacja rabatu | QR deep link + PIN lokalu + timer |
| Pracownicy lokalu | Wspólny PIN (bez osobnych kont) |
| Moderacja treści | Własny słownik + Perspective API (Google) |
| Języki | Polski, angielski (i18n) |

---

## Role i uprawnienia

### Role systemowe
- `CLIENT` — zwykły użytkownik aplikacji
- `ADMIN` — administrator systemu

### Role w lokalu
Właściciel/manager to CLIENT który dodatkowo ma przypisanie do lokalu:
- `OWNER` — właściciel (pełne uprawnienia)
- `MANAGER` — manager (tylko oferty)

| Uprawnienie | OWNER | MANAGER |
|-------------|-------|---------|
| Tworzenie/edycja ofert | tak | tak |
| Pauzowanie ofert | tak | tak |
| Podgląd statystyk | tak | tak |
| Zmiana nazwy/logo | tak (wymaga akceptacji) | nie |
| Zmiana PIN | tak | nie |
| Zapraszanie managerów | tak | nie |
| Usuwanie managerów | tak | nie |
| Wypowiedzenie umowy | tak | nie |

---

## Reguły biznesowe

### Okolice
- User może subskrybować wiele okolic (N:M)
- Wyszukiwanie okolic przez geolokalizację
- Okolica = umowna jednostka (dzielnica, poddzielnica, małe miasto, wieś)

### Rejestracja klienta
1. OAuth (Google/Apple) lub Magic link
2. Wybór okolicy (obowiązkowy)
3. Wybór ulicy (obowiązkowy) — autocomplete z bazy ulic
4. Zgoda na regulamin (obowiązkowa)
5. Zgoda na personalizację ofert (opcjonalna)

### Zakładanie konta właściciela
1. Admin tworzy lokal w panelu i wprowadza email właściciela
2. System wysyła email z linkiem i jednorazowym hasłem
3. Właściciel klika link i uzupełnia dane:
   - Imię i nazwisko, telefon
   - NIP, nazwa firmy, adres siedziby
   - Zgody (regulamin, RODO, marketing opcjonalnie)
4. Ustawia hasło → konto aktywne

### Typy rabatów

**MVP:**
- PERCENTAGE — np. -20%
- FIXED_AMOUNT — np. -15 zł
- FREE_ITEM — np. gratis kawa

**Faza 2:**
- FIRST_N — pierwsze 10 osób (z rezerwacją)
- BUY_X_GET_Y — kup 2, trzeci gratis
- BUNDLE — zestaw w cenie
- SECOND_HALF_PRICE — drugi produkt -50%

### QR Flow (walidacja)
1. User klika "Pokaż kod" → generuje QR
2. Timer odlicza czas ważności (domyślnie 15 min, konfigurowalny: 5/10/15/30/60 min lub do końca oferty)
3. QR zawiera deep link: `https://app.swoi.pl/validate/RDM-A7X2K9`
4. Pracownik skanuje aparatem → otwiera się strona z info o rabacie
5. Pracownik wpisuje PIN lokalu → klik "Potwierdź" → zrealizowano
6. Komunikat o personalizacji wyświetlany klientowi

### Oceny ofert
1. Ocena opcjonalna (1-5 gwiazdek + komentarz) — z poziomu historii realizacji
2. Komentarze moderowane (własny słownik + Perspective API)
3. Średnia ocen widoczna tylko dla właściciela w dashboardzie (nie publicznie)
4. Bez automatycznego push z prośbą o ocenę

### Moderacja treści

**Oferty:**
1. Każda nowa oferta przechodzi przez moderację
2. Własny słownik — lista zakazanych słów
3. Perspective API (Google) — darmowe API do wykrywania toksyczności
4. Progi decyzyjne:
   - score < 0.3 → auto-approve, publikacja za 3 dni
   - score 0.3-0.7 → wymaga akceptacji admina
   - score > 0.7 → auto-reject

**Zmiana nazwy/logo:**
- Wymaga akceptacji admina
- Wniosek widoczny w panelu admina

### Status lokalu

| Status | Opis |
|--------|------|
| ACTIVE | Aktywny, oferty działają |
| INACTIVE | Nieaktywny (admin wyłączył) |
| TERMINATING | Wypowiedzenie, 30 dni okresu |
| TERMINATED | Po wypowiedzeniu, niewidoczny |
| DELETED | Usunięty przez admina |

### Wypowiedzenie umowy
1. OWNER składa wypowiedzenie
2. 30 dni okresu wypowiedzenia
3. W tym czasie: oferty działają, ale nowych nie można tworzyć
4. Po 30 dniach: lokal niewidoczny, dane archiwizowane

### Kategorie lokali
RESTAURANT, CAFE, BAR, BAKERY, GROCERY, PHARMACY, HAIRDRESSER, BARBER, NAILS, GROOMER, VET, LAUNDRY, KEBAB, PIZZA, INDIAN, CHINESE, OTHER

---

## Flow-y użytkownika

### Klient

**Rejestracja / Logowanie:**
```
[Ekran startowy]
    ├── [Zaloguj przez Google] → OAuth → [Wybierz okolicę] → [Wybierz ulicę] → [Home]
    ├── [Zaloguj przez Apple] → OAuth → [Wybierz okolicę] → [Wybierz ulicę] → [Home]
    └── [Magic link] → Wpisz email → "Wysłano link" → Klik w mailu → [Wybierz okolicę] → [Home]
```

**Przeglądanie ofert:**
```
[Home]
    ├── Lista ofert w okolicy (karty)
    │   ├── Filtr: kategoria
    │   ├── Filtr: typ rabatu
    │   └── Sortowanie: najnowsze / kończące się
    └── [Klik na ofertę] → [Szczegóły oferty]
            ├── Info o lokalu, opis rabatu, ważność
            ├── [Dodaj do ulubionych]
            └── [Pokaż kod] → (wymaga logowania)
```

**Realizacja rabatu:**
```
[Szczegóły oferty] → [Pokaż kod]
    ├── Sprawdź: czy już realizował dziś? → TAK → "Limit 1/dzień"
    └── NIE → [Ekran QR]
            ├── QR code + kod tekstowy
            ├── Timer: ważny X minut
            └── Status: PENDING

[Pracownik skanuje QR] → [Strona walidacji]
    ├── Info o rabacie i kliencie
    ├── [Wpisz PIN lokalu]
    └── [Potwierdź] → PIN OK → "Zrealizowano!"
```

**Historia i ulubione:**
```
[Menu / Profil]
    ├── [Historia rabatów] → Lista zrealizowanych (+ opcja oceny)
    ├── [Ulubione lokale] → Lista lokali
    └── [Moje okolice] → Lista subskrybowanych, dodaj/usuń
```

### Właściciel lokalu

**Panel właściciela:**
```
[Panel właściciela]
    ├── Statystyki (aktywne oferty, realizacje, średnia ocen)
    ├── [Moje oferty] → lista ofert
    ├── [Nowa oferta] → formularz (+ timer QR, info o moderacji)
    ├── [Managerowie] → lista, zapraszanie, usuwanie
    └── [Ustawienia]
            ├── Edycja opisu, logo (wymaga akceptacji)
            ├── Zmiana PIN
            └── Wypowiedzenie umowy
```

**Tworzenie oferty:**
```
[Nowa oferta]
    ├── Tytuł, opis
    ├── Typ rabatu: Procent / Kwota / Gratis
    ├── Wartość
    ├── Ważność QR: 5/10/15/30/60 min lub do końca oferty
    ├── Data od-do
    └── [Zapisz jako szkic] / [Publikuj]
        → Info: "Oferta zostanie opublikowana za 3 dni lub po akceptacji admina"
```

### Admin

**Panel admina:**
```
[Admin Panel]
    ├── Dashboard (statystyki globalne)
    ├── [Okolice] → zarządzanie
    ├── [Lokale] → zarządzanie
    ├── [Kategorie] → zarządzanie
    ├── [Użytkownicy] → zarządzanie
    ├── [Oferty] → przegląd
    ├── [Moderacja] → oferty do weryfikacji, zmiany nazwy/logo
    └── [Zaproszenia] → zaproszenia właścicieli
```

---

## Push notifications

### Zasady
1. Nie spamuj — max 1 push dziennie (MVP)
2. Wartość dla usera — tylko jeśli są nowe oferty
3. Personalizacja — tylko subskrybowane okolice
4. Kontrola — user może wyłączyć per okolica

### MVP - Typy powiadomień

**1. Digest dzienny (nowe oferty)**
- Kiedy: Codziennie o 10:00
- Warunek: Są nowe oferty w subskrybowanych okolicach
- Treść: "3 nowe oferty w Twojej okolicy! Beer & Burger Kufloteka, Kawiarnia Cicha i więcej..."

| Nowych ofert | Tytuł |
|--------------|-------|
| 1 | Nowa oferta w okolicy! |
| 2-3 | {n} nowe oferty w okolicy! |
| 4+ | {n} nowych ofert czeka! |

**2. Powitanie (onboarding)**
- Kiedy: 24h po rejestracji (jeśli nie otworzył aplikacji)
- Treść: "Wspieraj lokalnych! Sprawdź oferty od sąsiadów w Twojej okolicy"

**3. Reaktywacja (win-back)**
- Kiedy: 7 dni bez aktywności
- Treść: "{n} ofert czeka w {okolica}"
- Limit: Max 1 reaktywacja na 30 dni

### Faza 2 - Dodatkowe typy
- Oferta się kończy (24h przed końcem, jeśli user wygenerował QR ale nie zrealizował)
- Ulubiony lokal ma nową ofertę (natychmiast)
- Oferta "gorąca" FIRST_N (natychmiast)

### Ustawienia użytkownika

| Ustawienie | Default |
|------------|---------|
| pushEnabled | true |
| digestTime | 10:00 |
| notificationsEnabled per okolica | true |

### Ton - rekomendacja
**Przyjacielski bez emoji** — pasuje do idei "sąsiedzkiej" aplikacji, nie jest nachalne.

---

## Scope MVP vs Faza 2

### MVP
- Rejestracja Google/Apple/Magic link + okolica + ulica
- Subskrypcja okolicy (geo-search)
- Przeglądanie ofert (niezalogowany może przeglądać, nie może realizować)
- Rabaty: PERCENTAGE, FIXED_AMOUNT, FREE_ITEM
- QR kod + PIN walidacja + timer (domyślnie 15 min)
- Oceny ofert (1-5 gwiazdek + komentarz)
- Panel właściciela (oferty, managerowie, statystyki, wypowiedzenie)
- Panel managera (oferty, statystyki)
- Panel admina (moderacja, zaproszenia, zarządzanie)
- Moderacja treści: słownik + Perspective API
- Oferta publikowana za 3 dni lub po akceptacji admina
- Zmiana nazwy/logo wymaga akceptacji admina
- Push: nowe oferty (digest 1x dziennie)
- Historia zrealizowanych rabatów
- Ulubione lokale
- Limit: 1 oferta dziennie za darmo (kalendarzowo)
- Kategorie zarządzane przez admina
- Zgoda na personalizację przy walidacji QR

### Faza 2
- FIRST_N (pierwsze X osób) + rezerwacja + timeout
- Push: przypomnienia o wygasaniu
- Właściciel sam tworzy lokal (+ akceptacja admina)
- Płatne subskrypcje dla lokali
- Wiele okolic
- Więcej ofert dziennie (płatne)
- Publiczna średnia ocen lokali

---

## Dokumentacja techniczna

| Plik | Opis |
|------|------|
| [MODEL-DANYCH.md](MODEL-DANYCH.md) | Encje, pola, relacje, indeksy |
| [api/openapi.yaml](api/openapi.yaml) | Specyfikacja OpenAPI 3.0 (wszystkie endpointy) |
| [api/ACCESS-CONTROL.md](api/ACCESS-CONTROL.md) | Role, macierz uprawnień, rate limiting, JWT |
| [legal/REGULAMIN-UZYTKOWNICY.md](legal/REGULAMIN-UZYTKOWNICY.md) | Draft regulaminu dla użytkowników |
| [legal/REGULAMIN-WLASCICIELE.md](legal/REGULAMIN-WLASCICIELE.md) | Draft regulaminu dla właścicieli lokali |
| [legal/POLITYKA-PRYWATNOSCI.md](legal/POLITYKA-PRYWATNOSCI.md) | Draft polityki prywatności (RODO) |

**Quick links:**
- OpenAPI Editor: Wklej `api/openapi.yaml` do [editor.swagger.io](https://editor.swagger.io)

---

## Mockupy

### Mobile PWA
Folder: `mockups/`
- `index.html` — nawigacja główna
- `home.html` — strona główna
- `home-style-[1-10].html` — 10 wariantów stylów
- `login.html`, `register.html` — autoryzacja
- `district-*.html` — wybór okolicy
- `offers.html`, `offer-details.html` — oferty
- `venue.html` — profil lokalu
- `qr-code.html`, `validate.html`, `success.html` — flow walidacji QR
- `history.html`, `favorites.html` — historia i ulubione
- `profile.html`, `settings.html` — profil użytkownika

### Panel właściciela (desktop)
Folder: `mockups/owner-web/`
- `index.html` — dashboard ze statystykami i średnią ocen
- `offers.html` — lista ofert
- `new-offer.html` — tworzenie oferty (z QR timer, info o moderacji)
- `redemptions.html` — historia realizacji
- `managers.html` — zarządzanie managerami
- `settings.html` — ustawienia (zmiana nazwy/logo, PIN, wypowiedzenie)

### Panel admina (desktop)
Folder: `mockups/admin-web/`
- `index.html` — dashboard
- `districts.html` — zarządzanie okolicami
- `venues.html` — zarządzanie lokalami
- `categories.html` — kategorie
- `users.html` — użytkownicy
- `offers.html` — przegląd ofert
- `moderation.html` — moderacja treści ofert
- `invitations.html` — zaproszenia właścicieli

**Otwieranie:** Otwórz `mockups/index.html` w przeglądarce

---

## Regulaminy i zgody (do prawnika)

### Dla klientów
- Regulamin platformy
- Polityka prywatności
- Zgoda na personalizację ofert (opcjonalna)
- Komunikat przy walidacji QR: "Realizując ofertę wyrażasz zgodę na otrzymywanie spersonalizowanych ofert"

### Dla właścicieli
- Regulamin platformy dla właścicieli
- Umowa o współpracy
- Zgoda na przetwarzanie danych (RODO)
- Zgoda na marketing (opcjonalna)

---

## Do zrobienia

- [x] Aktualizacja mockupów mobile (timer QR, oceny w historii, ulica przy rejestracji)
- [ ] Przegląd prawniczy regulaminów i zgód (drafty gotowe w `docs/legal/`)
