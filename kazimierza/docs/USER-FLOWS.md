# User Flows

## Role

| Rola | Opis |
|------|------|
| **Gość** | Niezalogowany, może przeglądać oferty |
| **Klient** | Zalogowany user, realizuje rabaty |
| **Właściciel** | Owner lokalu, tworzy oferty |
| **Admin** | Zarządza wszystkim |

---

## 1. Klient

### 1.1 Rejestracja / Logowanie

```
[Ekran startowy]
    │
    ├──→ [Zaloguj przez Google] ──→ OAuth ──→ [Wybierz dzielnicę] ──→ [Home]
    │
    ├──→ [Zaloguj przez Apple] ──→ OAuth ──→ [Wybierz dzielnicę] ──→ [Home]
    │
    └──→ [Magic link]
            │
            ├── Wpisz email
            ├── "Wysłano link"
            └── Klik w mailu ──→ [Wybierz dzielnicę] ──→ [Home]
```

**Uwagi:**
- Pierwszy login = rejestracja (auto-create user)
- Wybór dzielnicy: geolokalizacja lub wyszukiwarka
- Można pominąć (skip) i wybrać później

---

### 1.2 Przeglądanie ofert (Gość lub Klient)

```
[Home]
    │
    ├── Lista ofert w dzielnicy (karty)
    │       │
    │       ├── Filtr: kategoria
    │       ├── Filtr: typ rabatu
    │       └── Sortowanie: najnowsze / kończące się
    │
    └──→ [Klik na ofertę] ──→ [Szczegóły oferty]
                                    │
                                    ├── Info o lokalu
                                    ├── Opis rabatu
                                    ├── Ważność (od-do)
                                    │
                                    ├── [Dodaj do ulubionych] (serce)
                                    │
                                    └── [Pokaż kod] ──→ (wymaga logowania)
```

**Uwagi:**
- Gość widzi wszystko, ale "Pokaż kod" wymaga logowania
- Karty: logo lokalu, nazwa, typ rabatu, data końca

---

### 1.3 Realizacja rabatu (QR Flow)

```
[Szczegóły oferty]
    │
    └──→ [Pokaż kod]
            │
            ├── Sprawdź: czy już realizował dziś? ──→ TAK ──→ "Limit 1/dzień"
            │
            └── NIE
                 │
                 └──→ [Ekran QR]
                         │
                         ├── QR code (duży, jasny)
                         ├── Kod tekstowy: RDM-A7X2K9
                         ├── "Pokaż pracownikowi"
                         ├── Timer: ważny do końca oferty
                         │
                         └── Status: PENDING

--- Pracownik lokalu ---

[Skanuje QR aparatem]
    │
    └──→ Otwiera deep link: app.xxx.pl/validate/RDM-A7X2K9
            │
            └──→ [Strona walidacji]
                    │
                    ├── Info o rabacie
                    ├── Info o kliencie (imię)
                    ├── [Wpisz PIN lokalu] ____
                    │
                    └──→ [Potwierdź realizację]
                            │
                            ├── PIN OK ──→ "Zrealizowano!" ──→ Status: REDEEMED
                            │
                            └── PIN błędny ──→ "Nieprawidłowy PIN"
```

**Uwagi:**
- QR generowany on-demand (nie wcześniej)
- Limit 1 oferta/dzień = per user, per offer
- Pracownik nie potrzebuje konta — tylko PIN lokalu

---

### 1.4 Historia i ulubione

```
[Menu / Profil]
    │
    ├──→ [Historia rabatów]
    │       │
    │       └── Lista zrealizowanych (data, lokal, rabat)
    │
    ├──→ [Ulubione lokale]
    │       │
    │       └── Lista lokali ──→ klik ──→ [Profil lokalu]
    │
    └──→ [Moje dzielnice]
            │
            ├── Lista subskrybowanych
            ├── [Dodaj dzielnicę]
            └── [Usuń] (swipe)
```

---

## 2. Właściciel lokalu

### 2.1 Dostęp do panelu

```
[MVP: Admin dodaje lokal i przypisuje właściciela]
    │
    └──→ Owner loguje się normalnie (Google/Apple/Email)
            │
            └──→ System rozpoznaje owner_id ──→ [Panel właściciela]
```

**Faza 2:** Właściciel sam rejestruje lokal → admin akceptuje.

---

### 2.2 Panel właściciela — Home

```
[Panel właściciela]
    │
    ├── Statystyki
    │       ├── Aktywne oferty: 3
    │       ├── Realizacje dziś: 12
    │       └── Realizacje tydzień: 47
    │
    ├── [Moje oferty] ──→ lista ofert
    │
    ├── [Nowa oferta] ──→ formularz
    │
    └── [Ustawienia lokalu]
            ├── Edycja opisu
            ├── Logo
            └── Zmiana PIN
```

---

### 2.3 Tworzenie oferty

```
[Nowa oferta]
    │
    ├── Tytuł: _______________
    ├── Opis: ________________
    │
    ├── Typ rabatu:
    │       ○ Procent (-X%)
    │       ○ Kwota (-X zł)
    │       ○ Gratis (darmowy produkt)
    │
    ├── Wartość: ____ (lub nazwa produktu dla GRATIS)
    │
    ├── Data od: [____]
    ├── Data do: [____]
    │
    └── [Zapisz jako szkic] / [Publikuj]
            │
            └──→ Status: DRAFT lub ACTIVE
```

**Uwagi:**
- Właściciel może edytować DRAFT
- ACTIVE można tylko PAUSED lub czekać na EXPIRED
- Limit MVP: 1 aktywna oferta dziennie (kalendarzowo)

---

### 2.4 Zarządzanie ofertami

```
[Moje oferty]
    │
    ├── Filtry: Aktywne / Szkice / Zakończone
    │
    └── Lista ofert
            │
            └──→ [Klik] ──→ [Szczegóły oferty]
                    │
                    ├── Statystyki: X realizacji
                    ├── [Wstrzymaj] (ACTIVE → PAUSED)
                    ├── [Wznów] (PAUSED → ACTIVE)
                    ├── [Edytuj] (tylko DRAFT)
                    └── [Usuń] (tylko DRAFT)
```

---

## 3. Admin

### 3.1 Dashboard

```
[Admin Panel]
    │
    ├── Statystyki globalne
    │       ├── Użytkownicy: 234
    │       ├── Lokale: 18
    │       ├── Aktywne oferty: 25
    │       └── Realizacje dziś: 89
    │
    ├── [Dzielnice]
    ├── [Lokale]
    ├── [Kategorie]
    └── [Użytkownicy]
```

---

### 3.2 Zarządzanie dzielnicami

```
[Dzielnice]
    │
    ├── Lista dzielnic (nazwa, lokale, status)
    │
    ├── [Nowa dzielnica]
    │       ├── Nazwa: ___
    │       ├── Slug: ___
    │       ├── Centrum: [mapa / lat,lng]
    │       ├── Promień: ___ km
    │       └── [Zapisz]
    │
    └── [Edytuj] / [Deaktywuj]
```

---

### 3.3 Zarządzanie lokalami

```
[Lokale]
    │
    ├── Lista (nazwa, dzielnica, właściciel, status)
    │
    ├── [Nowy lokal]
    │       ├── Nazwa: ___
    │       ├── Dzielnica: [dropdown]
    │       ├── Kategoria: [dropdown]
    │       ├── Adres: ___
    │       ├── Właściciel: [wybierz usera]
    │       ├── PIN: [generuj/wpisz]
    │       └── [Zapisz]
    │
    └── [Edytuj] / [Deaktywuj]
```

---

### 3.4 Zarządzanie kategoriami

```
[Kategorie]
    │
    ├── Lista (nazwa, ikona, kolejność)
    │
    ├── [Nowa kategoria]
    │       ├── Nazwa: ___
    │       ├── Slug: ___
    │       ├── Ikona: [wybierz]
    │       └── Kolejność: ___
    │
    └── [Edytuj] / [Usuń] (tylko jeśli brak lokali)
```

---

## 4. Powiadomienia Push (MVP)

### 4.1 Digest dzienny

```
[Cron: 10:00]
    │
    └── Dla każdego usera z notifications_enabled:
            │
            ├── Zbierz nowe oferty z subskrybowanych dzielnic (od wczoraj)
            │
            └── Wyślij push:
                    "3 nowe oferty w Twojej okolicy!"
                    └──→ Klik ──→ [Home z filtrem: nowe]
```

---

## Do zaprojektowania (następne kroki)

- [ ] Wireframes dla kluczowych ekranów
- [ ] Ekran walidacji QR (widok pracownika)
- [ ] Empty states (brak ofert, brak dzielnic)
- [ ] Error states (brak sieci, błędny PIN)
- [ ] Onboarding (pierwszy raz w aplikacji)
