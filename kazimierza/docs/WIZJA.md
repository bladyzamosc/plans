# Kazimierza — Aplikacja Lokalnych Rabatów

## Idea

Aplikacja zrzeszająca lokalne biznesy (niesieciowe) w promieniu 2-3km — mieszkańcy otrzymują powiadomienia o rabatach w okolicy. Start na ulicy Jana Kazimierza, potem ekspansja na kolejne dzielnice/ulice.

**Why:** Wspieranie lokalnego biznesu, budowanie społeczności wokół ulicy/dzielnicy.

## Decyzje techniczne

| Obszar | Decyzja |
|--------|---------|
| Mobile | PWA (MVP) → React Native (później) |
| Backend | Spring Boot + PostgreSQL |
| Auth | Google, Apple + Magic link (fallback) |
| Sesja | JWT access + refresh token |
| Walidacja rabatu | QR deep link + PIN lokalu |
| Pracownicy lokalu | Wspólny PIN (bez osobnych kont) |

## Dzielnice (District)

- User może subskrybować wiele dzielnic (N:M)
- Wyszukiwanie dzielnic przez geolokalizację
- Dzielnica = umowna (ulica, mała miejscowość, osiedle)
- Przy ekspansji: rebranding na uniwersalną markę (np. "Lokalnie", "Okolica")

## Typy rabatów

### MVP
- **PERCENTAGE** — np. -20%
- **FIXED_AMOUNT** — np. -15 zł
- **FREE_ITEM** — np. gratis kawa

### Faza 2
- **FIRST_N** — pierwsze 10 osób (z rezerwacją)
- **BUY_X_GET_Y** — kup 2, trzeci gratis
- **BUNDLE** — zestaw w cenie
- **SECOND_HALF_PRICE** — drugi produkt -50%

## Scope MVP vs Faza 2

### MVP
- Rejestracja Google/Apple/Magic link
- Subskrypcja dzielnicy (geo-search)
- Przeglądanie ofert (niezalogowany może przeglądać, nie może realizować)
- Rabaty: PERCENTAGE, FIXED_AMOUNT, FREE_ITEM
- QR kod + PIN walidacja
- Panel właściciela (tworzenie ofert)
- Panel admina (zarządzanie)
- Push: nowe oferty (digest 1x dziennie)
- Historia zrealizowanych rabatów
- Ulubione lokale
- Limit: 1 oferta dziennie za darmo (kalendarzowo)
- QR ważny do końca oferty
- Kategorie zarządzane przez admina

### Faza 2
- FIRST_N (pierwsze X osób) + rezerwacja + timeout
- Push: przypomnienia o wygasaniu
- Właściciel sam tworzy lokal (+ akceptacja admina)
- Płatne subskrypcje dla lokali
- Wiele dzielnic
- Więcej ofert dziennie (płatne)

## Kategorie lokali (admin zarządza)

RESTAURANT, CAFE, BAR, BAKERY, GROCERY, PHARMACY, HAIRDRESSER, BARBER, NAILS, GROOMER, VET, LAUNDRY, KEBAB, PIZZA, INDIAN, CHINESE, OTHER

## QR Flow (walidacja)

1. User w appce klika "Pokaż kod" → generuje QR
2. QR zawiera deep link: `https://app.kazimierza.pl/validate/RDM-A7X2K9`
3. Pracownik skanuje aparatem telefonu
4. Otwiera się strona z info o rabacie
5. Pracownik wpisuje PIN lokalu
6. Klik "Potwierdź" → zrealizowano

## Co do zaprojektowania

- [ ] User flows (ścieżki użytkownika)
- [ ] Ekrany PWA (wireframes)
- [ ] Panel właściciela
- [ ] Panel admina
- [ ] API endpoints
- [ ] Push notifications (strategia, treści)
