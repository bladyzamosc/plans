# Swoi — Dokumentacja projektu

Aplikacja lokalnych rabatów wspierająca sąsiedzki biznes.

## Spis treści

### Wizja i zakres
- **[WIZJA.md](WIZJA.md)** — idea projektu, decyzje techniczne, scope MVP vs Faza 2, role i uprawnienia

### Model danych
- **[MODEL-DANYCH.md](MODEL-DANYCH.md)** — encje, relacje, indeksy, reguły biznesowe (v2)

### API
- **[api/openapi.yaml](api/openapi.yaml)** — specyfikacja OpenAPI 3.0 (wszystkie endpointy)
- **[api/ACCESS-CONTROL.md](api/ACCESS-CONTROL.md)** — role, macierz uprawnień, rate limiting, JWT

### Flows i UX
- **[USER-FLOWS.md](USER-FLOWS.md)** — ścieżki użytkownika (klient, właściciel, admin)
- **[WIREFRAMES.md](WIREFRAMES.md)** — ASCII wireframes ekranów mobile

### Push notifications
- **[PUSH-NOTIFICATIONS.md](PUSH-NOTIFICATIONS.md)** — strategia, typy powiadomień, treści

---

## Mockupy HTML

### Mobile PWA
Folder: `mockups/`
- `index.html` — nawigacja główna
- `home.html` — strona główna
- `home-style-[1-10].html` — 10 wariantów stylów
- `login.html`, `register.html` — autoryzacja
- `district-*.html` — wybór dzielnicy
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
- `managers.html` — **NOWE:** zarządzanie managerami
- `settings.html` — ustawienia (zmiana nazwy/logo, PIN, wypowiedzenie)
- `owner-styles.css` — style panelu

### Panel admina (desktop)
Folder: `mockups/admin-web/`
- `index.html` — dashboard
- `districts.html` — zarządzanie dzielnicami
- `venues.html` — zarządzanie lokalami
- `categories.html` — kategorie
- `users.html` — użytkownicy
- `offers.html` — przegląd ofert
- `moderation.html` — **NOWE:** moderacja treści ofert
- `invitations.html` — **NOWE:** zaproszenia właścicieli
- `admin-styles.css` — style panelu

---

---

## Quick links

- **OpenAPI Editor:** Wklej `api/openapi.yaml` do [editor.swagger.io](https://editor.swagger.io)
- **Mockupy:** Otwórz `mockups/index.html` w przeglądarce
- **GitHub Pages:** Ustaw branch `main`, folder `/kazimierza/mockups`

---

## Do zrobienia

- [ ] Aktualizacja mockupów mobile (timer QR, oceny w historii, ulica przy rejestracji)
- [ ] Dodanie nawigacji do nowych stron admin-web w pozostałych plikach
- [ ] Przegląd prawniczy regulaminów i zgód
