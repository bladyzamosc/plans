# Swoi — Zmiany v2 — Status zatwierdzania

Data rozpoczęcia: 2026-07-16
Data zatwierdzenia: 2026-07-17

## WSZYSTKO ZATWIERDZONE ✅

### 1. Timer QR kodu ✅
- QR ważny przez 15 min (domyślnie) lub konfigurowalny per oferta
- Opcje: 5, 10, 15, 30, 60 min, lub NULL (do końca oferty)
- Timer wyświetlany przy QR kodzie
- Po wygaśnięciu można wygenerować nowy

### 2. Zgoda na personalizację przy walidacji ✅
- Przy walidacji QR kodu komunikat o zgodzie na personalizowane oferty
- Klient może wycofać zgodę w ustawieniach
- User.personalized_offers_consent w modelu

### 3. Oceny zrealizowanych ofert ✅
- ❌ BEZ push z prośbą o ocenę
- ✅ Ocena 1-5 gwiazdek (opcjonalna, z poziomu historii realizacji)
- ✅ Komentarz opcjonalny
- ✅ Moderacja komentarzy: **Własny słownik + Perspective API (Google)**
- ✅ Średnia ocen widoczna **tylko dla właściciela** w dashboardzie (nie publicznie)

**Notatka AI:** Na przyszłość rozważyć Azure Content Safety (enterprise, RODO, ~$1/1000 req) lub OpenAI Moderation (darmowe, US). Na MVP wystarczy słownik + Perspective.

### 4. Zakładanie konta właściciela przez admina ✅
- Admin wprowadza email właściciela
- System tworzy konto + wysyła email z jednorazowym hasłem
- Link do zaakceptowania regulaminów i zgód

**Dane wymagane od właściciela:**
- Imię i nazwisko (osoba kontaktowa) — wymagane
- Numer telefonu — wymagane
- NIP firmy — wymagane
- Nazwa firmy — wymagane
- Adres siedziby firmy — wymagane
- Zgoda na regulamin platformy — wymagane
- Zgoda na przetwarzanie danych (RODO) — wymagane
- Zgoda na marketing — opcjonalne

### 5. Zmiana nazwy/logo wymaga akceptacji admina ✅
- Właściciel edytuje nazwę/logo → zmiana idzie do kolejki
- Admin zatwierdza lub odrzuca (z powodem)
- Do czasu zatwierdzenia wyświetlana stara nazwa/logo

### 6. Moderacja treści ofert ✅
- Tytuł i opis oferty sprawdzane przez: **Własny słownik + Perspective API**
- Progi:
  - score < 0.3 → auto-approve
  - score 0.3-0.7 → wymaga admina
  - score > 0.7 → auto-reject
- Dodatkowo lista zakazanych słów (wulgaryzmy, konkurencja, etc.)

### 7. Oferta nie wchodzi ad hoc ✅
- Flow: DRAFT → PENDING_REVIEW → SCHEDULED (za 3 dni) → ACTIVE
- Admin może przyspieszyć (od razu ACTIVE)
- Cron job aktywuje oferty o scheduled_publish_at

### 8. Wybór ulicy przy rejestracji klienta ✅
- Oprócz dzielnicy wymagany wybór ulicy
- Autocomplete z bazy ulic dzielnicy (GUS/TERYT lub własna lista)

### 9. Status lokalu: wypowiedzenie, usunięty ✅
- Venue.status: ACTIVE, INACTIVE, TERMINATING, TERMINATED, DELETED
- TERMINATING = złożono wypowiedzenie, 30 dni okresu (oferty działają, nowych nie można)
- TERMINATED = po 30 dniach, lokal niewidoczny, dane zarchiwizowane

### 10. Opcja wypowiedzenia umowy w panelu właściciela ✅
- W "Strefie niebezpiecznej" przycisk "Wypowiedz umowę"
- Modal z potwierdzeniem + pole na powód (opcjonalne)
- Email z potwierdzeniem wypowiedzenia

### 11. Wielu użytkowników na lokal + rola MANAGER ✅

| Uprawnienie | OWNER | MANAGER |
|-------------|-------|---------|
| Tworzenie/edycja ofert | ✅ | ✅ |
| Pauzowanie ofert | ✅ | ✅ |
| Podgląd statystyk | ✅ | ✅ |
| Zmiana nazwy/logo | ✅ | ❌ |
| Zmiana PIN | ✅ | ❌ |
| Zapraszanie managerów | ✅ | ❌ |
| Usuwanie managerów | ✅ | ❌ |
| Wypowiedzenie umowy | ✅ | ❌ |

- Owner zaprasza managera przez email
- Manager otrzymuje link do utworzenia konta / dołączenia
- **Tylko OWNER może usunąć managera** (brak opcji samodzielnej rezygnacji)

---

## DO ZROBIENIA

- [ ] Zaktualizować MODEL-DANYCH.md (już częściowo zrobione)
- [ ] Zaktualizować API (openapi.yaml)
- [ ] Zaktualizować ACCESS-CONTROL.md
- [ ] Zaktualizować mockupy mobile (timer QR, oceny, ulica)
- [ ] Zaktualizować mockupy owner-web (wypowiedzenie, managerowie, średnia ocen)
- [ ] Zaktualizować mockupy admin-web (akceptacja nazw/logo, moderacja ofert, tworzenie właścicieli)

---

## Regulaminy i zgody (do prawnika)
- Regulamin platformy dla właścicieli
- Polityka prywatności
- Umowa o współpracy
- Zgoda na personalizację ofert (dla klientów)
- Klauzula przy walidacji QR
