# Swoi — Zmiany v2 — Status zatwierdzania

Data rozpoczęcia: 2026-07-16

## ZATWIERDZONE

### 1. Timer QR kodu ✅
- QR ważny przez 15 min (domyślnie) lub konfigurowalny per oferta
- Opcje: 5, 10, 15, 30, 60 min, lub NULL (do końca oferty)
- Timer wyświetlany przy QR kodzie
- Po wygaśnięciu można wygenerować nowy

### 2. Zgoda na personalizację przy walidacji ✅
- Przy walidacji QR kodu komunikat o zgodzie na personalizowane oferty
- Klient może wycofać zgodę w ustawieniach
- User.personalized_offers_consent w modelu

### 3. Oceny zrealizowanych ofert ✅ (z modyfikacjami)
- ❌ BEZ push z prośbą o ocenę
- ✅ Ocena 1-5 gwiazdek (opcjonalna, z poziomu historii realizacji)
- ✅ Komentarz opcjonalny
- ✅ Moderacja komentarzy: **Własny słownik + Perspective API (Google)**
- ✅ Średnia ocen widoczna **tylko dla właściciela** w dashboardzie (nie publicznie)

**Notatka AI:** Na przyszłość rozważyć Azure Content Safety (enterprise, RODO, ~$1/1000 req) lub OpenAI Moderation (darmowe, US). Na MVP wystarczy słownik + Perspective.

### 4. Zakładanie konta właściciela przez admina ✅ (do doprecyzowania)
- Admin wprowadza email właściciela
- System tworzy konto + wysyła email z jednorazowym hasłem
- Link do zaakceptowania regulaminów i zgód
- **DO DOPRECYZOWANIA:** Lista wymaganych danych od właściciela przy rejestracji

---

## DO ZATWIERDZENIA (kontynuacja)

### 5. Zmiana nazwy/logo wymaga akceptacji admina
- Właściciel może edytować nazwę/logo
- Zmiana idzie do kolejki do zatwierdzenia przez admina
- Nowa encja: VenueChangeRequest

### 6. Moderacja treści ofert (anty-wulgaryzmy)
- AI Content Safety analizuje tytuł i opis oferty
- Progi decyzyjne (auto-approve, wymaga admina, auto-reject)
- Słownik zakazanych słów
- Nowa encja: ContentModeration

### 7. Oferta nie wchodzi ad hoc — minimum 3 dni lub akceptacja admina
- DRAFT → PENDING_REVIEW → SCHEDULED (za 3 dni) → ACTIVE
- Admin może przyspieszyć publikację

### 8. Wybór ulicy przy rejestracji klienta
- Oprócz dzielnicy wymagany wybór ulicy
- Autocomplete z bazy ulic dzielnicy

### 9. Status lokalu: wypowiedzenie umowy, usunięty
- Venue.status: ACTIVE, INACTIVE, TERMINATING, TERMINATED, DELETED
- 30 dni okresu wypowiedzenia

### 10. Opcja wypowiedzenia umowy w panelu właściciela
- "Strefa niebezpieczna" → "Wypowiedz umowę"
- Potwierdzenie + powód wypowiedzenia

### 11. Wielu użytkowników na lokal + rola MANAGER
- OWNER: wszystko (zmiana nazwy/logo, PIN, wypowiedzenie, oferty, zapraszanie)
- MANAGER: tylko oferty (tworzenie, edycja, pauzowanie)
- Nowa encja: VenueUser

---

## DO DOPRECYZOWANIA JUTRO

### Dane wymagane od właściciela przy rejestracji (pkt 4)
Propozycje:
- [ ] Imię i nazwisko
- [ ] Numer telefonu
- [ ] NIP firmy
- [ ] Nazwa firmy
- [ ] Adres siedziby firmy
- [ ] Zgoda na regulamin platformy
- [ ] Zgoda na przetwarzanie danych
- [ ] Zgoda na komunikację marketingową (opcjonalna)
- [ ] ...inne?

### Regulaminy i zgody (do prawnika)
- Regulamin platformy dla właścicieli
- Polityka prywatności
- Umowa o współpracy
- Zgoda na personalizację ofert (dla klientów)
- Klauzula przy walidacji QR
