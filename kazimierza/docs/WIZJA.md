# Swoi — Aplikacja Lokalnych Rabatów

## Nazwa aplikacji — DO DECYZJI

**Problem:** "Kazimierza" to nazwa ulicy (Jana Kazimierza) — nie skaluje się przy ekspansji na inne dzielnice.

**Kierunek:** Nazwa powinna kojarzyć się z budowaniem lokalnej społeczności i wspieraniem lokalnego rynku, nie z rabatami/promocjami.

### Propozycje

| Nazwa | Domena | Klimat |
|-------|--------|--------|
| **Swoi** | swoi.app | "Kupuj u swoich", silna identyfikacja |
| **NaszaUlica** | naszaulica.pl | Wspólnota miejsca, pasuje do modelu ekspansji ulica→dzielnica |
| **OdSąsiada** | odsasiada.pl | Ciepłe, relacja człowiek-człowiek |
| **Sąsiedzkie** | sasiedzkie.pl | Relacje, nie transakcje |
| **TuKupuję** | tukupuje.pl | Deklaracja wsparcia lokalnych |
| **Kupuj Blisko** | kupujblisko.pl | Jasny przekaz wsparcia |
| **Lokalnie** | lokalnie.app | Proste, uniwersalne |
| **Okolica** | okolica.app | Społecznościowy vibe |
| **Blisko** | blisko.app | Krótkie, ciepłe |

### Top 3 (do rozważenia)

1. **Swoi** — krótkie, mocne, "kupuj u swoich" to znany przekaz
2. **NaszaUlica** — idealnie pasuje do startu z jednej ulicy i ekspansji
3. **OdSąsiada** — ciepłe, podkreśla relację człowiek-człowiek

**Status:** ⏳ Oczekuje na decyzję

---

## Idea

Aplikacja zrzeszająca lokalne biznesy (niesieciowe) w promieniu 2-3km — mieszkańcy otrzymują powiadomienia o rabatach w okolicy. Start na ulicy Jana Kazimierza, potem ekspansja na kolejne dzielnice/ulice.

**Why:** Wspieranie lokalnego biznesu, budowanie społeczności wokół ulicy/dzielnicy.

## Decyzje techniczne

| Obszar | Decyzja |
|--------|---------|
| Mobile | PWA (MVP) → React Native (później) |
| Backend | Spring Boot + PostgreSQL |
| Auth | Google, Apple + Magic link (fallback) + hasło (dla owner/manager) |
| Sesja | JWT access (15 min) + refresh token (30 dni) |
| Walidacja rabatu | QR deep link + PIN lokalu + timer |
| Pracownicy lokalu | Wspólny PIN (bez osobnych kont) |
| Moderacja treści | Własny słownik + Perspective API (Google) |

## Role i uprawnienia

### Role użytkowników
- `CLIENT` — zwykły użytkownik aplikacji
- `VENUE_USER` — użytkownik przypisany do lokalu
- `ADMIN` — administrator systemu

### Role w lokalu
- `OWNER` — właściciel (pełne uprawnienia)
- `MANAGER` — manager (tylko oferty)

| Uprawnienie | OWNER | MANAGER |
|-------------|-------|---------|
| Tworzenie/edycja ofert | ✅ | ✅ |
| Pauzowanie ofert | ✅ | ✅ |
| Podgląd statystyk | ✅ | ✅ |
| Zmiana nazwy/logo | ✅ (wymaga akceptacji) | ❌ |
| Zmiana PIN | ✅ | ❌ |
| Zapraszanie managerów | ✅ | ❌ |
| Usuwanie managerów | ✅ | ❌ |
| Wypowiedzenie umowy | ✅ | ❌ |

## Dzielnice (District)

- User może subskrybować wiele dzielnic (N:M)
- Wyszukiwanie dzielnic przez geolokalizację
- Dzielnica = umowna (ulica, mała miejscowość, osiedle)
- Przy ekspansji: rebranding na uniwersalną markę (np. "Lokalnie", "Okolica")

## Rejestracja klienta

1. OAuth (Google/Apple) lub Magic link
2. Wybór dzielnicy (obowiązkowy)
3. **Wybór ulicy (obowiązkowy)** — autocomplete z bazy ulic
4. Zgoda na regulamin (obowiązkowa)
5. Zgoda na personalizację ofert (opcjonalna)

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

## QR Flow (walidacja)

1. User w appce klika "Pokaż kod" → generuje QR
2. **Timer odlicza czas ważności** (domyślnie 15 min, konfigurowalny)
3. QR zawiera deep link: `https://app.swoi.pl/validate/RDM-A7X2K9`
4. Pracownik skanuje aparatem telefonu
5. Otwiera się strona z info o rabacie + pozostały czas
6. Pracownik wpisuje PIN lokalu
7. Klik "Potwierdź" → zrealizowano
8. **Komunikat o personalizacji** wyświetlany klientowi

### Ważność QR
- Domyślnie: 15 minut
- Konfigurowalny per oferta: 5, 10, 15, 30, 60 min lub do końca oferty
- Po wygaśnięciu: można wygenerować nowy

## Oceny ofert

1. Ocena opcjonalna (1-5 gwiazdek + komentarz) — z poziomu historii realizacji
2. Komentarze moderowane (własny słownik + Perspective API)
3. **Średnia ocen widoczna tylko dla właściciela** w dashboardzie (nie publicznie)
4. Bez automatycznego push z prośbą o ocenę

## Moderacja treści

### Oferty
1. Każda nowa oferta przechodzi przez moderację
2. **Własny słownik** — lista zakazanych słów (wulgaryzmy, konkurencja, obraźliwe)
3. **Perspective API (Google)** — darmowe API do wykrywania toksyczności
4. Progi decyzyjne:
   - score < 0.3 → auto-approve, publikacja za 3 dni
   - score 0.3-0.7 → wymaga akceptacji admina
   - score > 0.7 → auto-reject

### Zmiana nazwy/logo
- Wymaga akceptacji admina
- Wniosek widoczny w panelu admina

## Status lokalu

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

## Zakładanie konta właściciela

1. Admin tworzy lokal w panelu
2. Admin wprowadza email właściciela
3. System wysyła email z linkiem i jednorazowym hasłem
4. Właściciel klika link i uzupełnia dane:
   - Imię i nazwisko
   - Numer telefonu
   - NIP firmy
   - Nazwa firmy
   - Adres siedziby firmy
   - Zgoda na regulamin
   - Zgoda na przetwarzanie danych (RODO)
   - Zgoda na marketing (opcjonalna)
5. Ustawia hasło
6. Konto aktywne

## Scope MVP vs Faza 2

### MVP
- Rejestracja Google/Apple/Magic link + dzielnica + ulica
- Subskrypcja dzielnicy (geo-search)
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
- Wiele dzielnic
- Więcej ofert dziennie (płatne)
- Publiczna średnia ocen lokali

## Kategorie lokali (admin zarządza)

RESTAURANT, CAFE, BAR, BAKERY, GROCERY, PHARMACY, HAIRDRESSER, BARBER, NAILS, GROOMER, VET, LAUNDRY, KEBAB, PIZZA, INDIAN, CHINESE, OTHER

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

## Co zaprojektowano

- [x] User flows (ścieżki użytkownika)
- [x] Ekrany PWA (wireframes)
- [x] Panel właściciela (desktop)
- [x] Panel admina (desktop)
- [x] API endpoints (OpenAPI)
- [x] Kontrola dostępu (role, uprawnienia)
- [x] Push notifications (strategia)
- [x] Model danych v2

## Do zrobienia

- [ ] Aktualizacja mockupów mobile (timer QR, oceny, ulica)
- [ ] Aktualizacja mockupów owner-web (wypowiedzenie, managerowie, średnia ocen)
- [ ] Aktualizacja mockupów admin-web (moderacja, zaproszenia właścicieli)
