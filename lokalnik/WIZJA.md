# Lokalnik.pl — Wizja Produktu

## Idea

Portal łączący **Zarządców mieszkań wakacyjnych** z **lokalnymi punktami usługowymi** (kawiarnie, restauracje, sklepy, apteki). Goście wynajmowanych mieszkań otrzymują ekskluzywne zniżki u partnerów — win-win-win:

- **Zarządca:** wyróżnia swoją ofertę, daje gościom dodatkową wartość
- **Partner:** zyskuje klientów z gwarantowanym ruchem (turyści = wydający pieniądze)
- **Gość:** oszczędza 30-50 zł podczas pobytu

## Aktorzy

| Aktor | Opis | Konto |
|-------|------|-------|
| **Zarządca** | Właściciel/manager 1-50 mieszkań wakacyjnych | Tak, panel |
| **Partner** | Punkt usługowy (restauracja, kawiarnia, sklep) | Tak, panel |
| **Gość** | Turysta wynajmujący mieszkanie | Nie* (tylko kod) |
| **Admin** | Operator platformy | Tak, panel |

*Gość nie zakłada konta — dostaje kod od Zarządcy i używa go u Partnera.

## Flow główny

```
SETUP (jednorazowo):
1. Admin pozyskuje Partnerów w lokalizacji → PODPISUJE UMOWĘ
2. Partner definiuje zniżkę (np. -20% na pizzę, -15 zł na zakupy)
3. Zarządca rejestruje się → dodaje mieszkania → wybiera lokalizację
4. Zarządca pobiera PDF z QR kodami → drukuje → wiesza w mieszkaniu

POBYT (każdy gość):

Sposób A — Wydruk w mieszkaniu (główny):
5a. Gość widzi pleksę/kartkę w mieszkaniu (lista partnerów + QR + numer rezerwacji)
6a. Gość skanuje QR → strona startowa lokalnik.pl
7a. Gość wpisuje NUMER REZERWACJI z kartki → lista zniżek

Sposób B — Email po zameldowaniu (opcjonalny):
5b. Zarządca melduje gościa → system wysyła email z linkiem (token w URL)
6b. Gość klika link → od razu lista zniżek (bez wpisywania)

Dalej (oba sposoby):
8. Gość wybiera partnera → generuje kod zniżkowy (ważny 1h)
9. Gość idzie do Partnera → pokazuje ekran z QR kodem
10. Kelner skanuje QR aparatem → otwiera stronę walidacji
11. Kelner wpisuje PIN lokalu → potwierdza → zniżka zrealizowana
```

## Umowa z Partnerem

**KLUCZOWE:** Partner MUSI mieć podpisaną umowę z platformą, która zobowiązuje go do respektowania kodów wygenerowanych przez system.

### Co zawiera umowa:
- Zobowiązanie do udzielania zniżek wg ustalonej oferty
- Czas trwania współpracy (np. sezon, rok)
- Warunki wypowiedzenia
- Zasady walidacji kodów (PIN)
- Zakaz dyskryminacji gości z kodami
- Zgoda na prezentowanie logo w materiałach

### Proces onboardingu Partnera:
1. Admin kontaktuje się z lokalnym przedsiębiorcą
2. Prezentacja modelu — Partner zyskuje klientów z apartamentów
3. Negocjacja zniżki (Partner sam proponuje co może zaoferować)
4. Podpisanie umowy (email/PDF lub fizycznie)
5. Admin tworzy konto Partnera w systemie
6. Partner ustawia PIN i definiuje zniżki w panelu
7. Partner pojawia się w materiałach dla Zarządców

## Model biznesowy

### MVP (walidacja)
- Zarządca: **darmowy** (budujemy bazę)
- Partner: **darmowy** lub symboliczna opłata (50-100 zł/mies)
- Przychód: brak (walidacja modelu)

### Faza 2 (monetyzacja)
- Zarządca: subskrypcja 49-149 zł/mies (zależnie od liczby mieszkań)
- Partner: prowizja od zrealizowanych zniżek LUB abonament
- Premium: wyróżnienie w materiałach, priorytet na pleksie

## Lokalizacje (MVP)

Start z **2-3 miejscowościami turystycznymi**:
- Jastrzębia Góra / Władysławowo (morze)
- Zakopane / Kościelisko (góry)
- Kazimierz Dolny (weekendowy)

## Różnice vs Kazimierza

| Aspekt | Kazimierza | Lokalnik |
|--------|------------|----------|
| Użytkownik końcowy | Mieszkaniec dzielnicy | Turysta/gość |
| Źródło ruchu | Geolokalizacja + subskrypcja | Zarządca mieszkania |
| Konto gościa | Wymagane | Nie wymagane |
| Materiały fizyczne | Brak | Pleksa, PDF, QR |
| B2B element | Słaby | Silny (Zarządca) |
| Sezonowość | Niska | Wysoka (wakacje) |

## Decyzje podjęte

| # | Pytanie | Decyzja |
|---|---------|---------|
| 1 | Czy Gość zakłada konto? | **NIE** — kod jednorazowy bez logowania |
| 2 | Jak Partner waliduje kod? | **PIN lokalu** — jak w Kazimierza |
| 3 | Jak Zarządca dostaje materiały? | **Generuje PDF/QR w panelu** — sam drukuje |
| 4 | Kto ustala Partnerów? | **Platforma (Admin)** — Zarządca dostaje gotowy pakiet |
| 5 | Limit kodów? | **1 kod na zniżkę na dzień** na mieszkanie |
| 6 | Ważność kodu? | **1 godzina** — generuj przed wejściem do lokalu |

### Uzasadnienia

**Gość bez konta:** Turysta jest 5-7 dni, nie chce kolejnej appki. Zero frikcji.

**PIN lokalu:** Sprawdzone w Kazimierza, kelner/kasjer nie instaluje nic.

**PDF do druku:** Instant, zero logistyki. Pleksa premium w Fazie 2.

**Platforma ustala Partnerów:** Admin pozyskuje lokale, negocjuje umowy, buduje sieć. Zarządca nie ma tu pracy — dostaje gotowy pakiet dla swojej lokalizacji.

**1 kod/dzień:** Zapobiega nadużyciom (kelner generujący 50 kodów).

**1h ważności:** Gość generuje kod stojąc przed lokalem, nie "na zapas". Krótki czas = trudniej oszukać.

## Scope MVP

### Musi być
- [ ] Rejestracja Zarządcy (email + hasło)
- [ ] Panel Zarządcy: dodawanie mieszkań, lokalizacja
- [ ] Panel Partnera: definicja zniżki, PIN walidacji
- [ ] Panel Admina: zarządzanie lokalizacjami, Zarządcami, Partnerami
- [ ] Strona gościa: lista zniżek dla lokalizacji
- [ ] Generowanie kodu zniżkowego (bez logowania)
- [ ] Walidacja kodu przez Partnera (PIN)
- [ ] Generator materiałów: PDF ze zniżkami + QR

### Może być (nice to have)
- [ ] Konto gościa (historia zniżek)
- [ ] Statystyki dla Zarządcy (ile kodów wygenerowano)
- [ ] Statystyki dla Partnera (ile zrealizowano)
- [ ] Wysyłka pleksy (integracja z drukarnią)
- [ ] Powiadomienia push dla gościa

### Nie będzie (Faza 2+)
- [ ] Płatności online
- [ ] Rezerwacje mieszkań przez portal
- [ ] Integracja z Booking/Airbnb
- [ ] Program lojalnościowy

## Stack technologiczny

| Warstwa | Technologia | Uwagi |
|---------|-------------|-------|
| Backend | Spring Boot 3 + Java 21 | Spójne z Kazimierza |
| DB | PostgreSQL | |
| Frontend Zarządca/Partner | Angular lub React | TBD |
| Frontend Gość | PWA (lekka strona) | Bez instalacji |
| Auth | JWT + refresh token | |
| Hosting | Azure (AZ-204 prep) | |

## Metryki sukcesu (MVP)

| Metryka | Cel (3 miesiące) |
|---------|------------------|
| Zarządcy | 20 |
| Mieszkania | 100 |
| Partnerzy | 30 |
| Kody wygenerowane | 500 |
| Kody zrealizowane | 150 (30% conversion) |

## Ryzyka

| Ryzyko | Prawdopodobieństwo | Mitygacja |
|--------|-------------------|-----------|
| Partnerzy nie chcą dawać zniżek | Średnie | Pokazać ROI, darmowy start |
| Zarządcy nie widzą wartości | Średnie | Case studies, materiały premium |
| Goście nie używają kodów | Wysokie | UX, widoczna pleksa, dobra zniżka |
| Sezonowość zabija retencję | Wysokie | Różne typy lokalizacji (morze+góry+miasto) |

## Timeline (orientacyjny)

| Faza | Czas | Deliverable |
|------|------|-------------|
| 1. Planowanie | 2 tyg | Wizja, model danych, mockupy |
| 2. MVP Backend | 4 tyg | API, auth, core logic |
| 3. MVP Frontend | 4 tyg | Panele, strona gościa |
| 4. Pilot | 4 tyg | 1 lokalizacja, 5 Zarządców, 10 Partnerów |
| 5. Iteracja | 2 tyg | Feedback, poprawki |
| 6. Launch | - | 2-3 lokalizacje |

---

## Powiązane dokumenty

- MODEL-DANYCH.md — encje, relacje, indeksy
- FAZY.md — szczegółowy breakdown faz
- mockups/ — wireframes i prototypy
