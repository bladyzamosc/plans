# Push Notifications - Strategia

## Zasady ogólne

1. **Nie spamuj** — max 1 push dziennie (MVP)
2. **Wartość dla usera** — tylko jeśli są nowe oferty
3. **Personalizacja** — tylko subskrybowane dzielnice
4. **Kontrola** — user może wyłączyć per dzielnica

---

## MVP - Typy powiadomień

### 1. Digest dzienny (nowe oferty)

**Kiedy:** Codziennie o 10:00 (lub konfigurowalnie)

**Warunek:** Są nowe oferty w subskrybowanych dzielnicach (od ostatniego digestu)

**Treść:**

```
Tytuł: 3 nowe oferty w Twojej okolicy!
Body: Burger u Kazika -30%, Kawiarnia Cicha i więcej...
Action: Otwiera Home z filtrem "nowe"
```

Warianty:

| Nowych ofert | Tytuł | Body |
|--------------|-------|------|
| 1 | Nowa oferta w okolicy! | {venue}: {tytuł oferty} |
| 2-3 | {n} nowe oferty w okolicy! | {venue1}, {venue2}... |
| 4+ | {n} nowych ofert czeka! | Sprawdź co nowego u sąsiadów |

**Logika:**
```
Cron 10:00:
  dla każdego usera z notifications_enabled:
    oferty = nowe oferty w subskrybowanych dzielnicach (od wczoraj 10:00)
    jeśli oferty.length > 0:
      wyślij push
```

---

### 2. Powitanie (onboarding)

**Kiedy:** 24h po rejestracji (jeśli nie otworzył aplikacji)

**Treść:**

```
Tytuł: Wspieraj lokalnych!
Body: Sprawdź oferty od sąsiadów w Twojej okolicy
Action: Otwiera Home
```

**Warunek:** User nie był aktywny od rejestracji

---

### 3. Reaktywacja (win-back)

**Kiedy:** 7 dni bez aktywności

**Warunek:** Są aktywne oferty w subskrybowanych dzielnicach

**Treść:**

```
Tytuł: Tęsknimy! 
Body: {n} ofert czeka w {dzielnica}
Action: Otwiera Home
```

**Limit:** Max 1 reaktywacja na 30 dni

---

## Faza 2 - Dodatkowe typy

### 4. Oferta się kończy (reminder)

**Kiedy:** 24h przed końcem oferty

**Warunek:** User wygenerował QR ale nie zrealizował

**Treść:**

```
Tytuł: Ostatni dzień oferty!
Body: {venue}: {tytuł} kończy się jutro
Action: Otwiera szczegóły oferty
```

---

### 5. Ulubiony lokal ma nową ofertę

**Kiedy:** Natychmiast po publikacji oferty

**Warunek:** Lokal jest w ulubionych usera

**Treść:**

```
Tytuł: {venue} ma nową ofertę!
Body: {tytuł oferty}
Action: Otwiera szczegóły oferty
```

---

### 6. Oferta "gorąca" (FIRST_N)

**Kiedy:** Natychmiast po publikacji

**Warunek:** Typ FIRST_N (pierwsze X osób), user subskrybuje dzielnicę

**Treść:**

```
Tytuł: Tylko dla pierwszych {n} osób!
Body: {venue}: {tytuł}
Action: Otwiera szczegóły oferty
```

---

## Ustawienia użytkownika

### Poziom globalny

| Ustawienie | Default | Opis |
|------------|---------|------|
| `pushEnabled` | true | Master switch |
| `digestTime` | 10:00 | Godzina digestu |

### Poziom dzielnicy

| Ustawienie | Default | Opis |
|------------|---------|------|
| `notificationsEnabled` | true | Push dla tej dzielnicy |

### Poziom lokalu (Faza 2)

| Ustawienie | Default | Opis |
|------------|---------|------|
| `notifyOnNewOffer` | true | Push gdy ulubiony lokal ma ofertę |

---

## Implementacja techniczna

### Stack

| Platforma | Serwis |
|-----------|--------|
| Web (PWA) | Firebase Cloud Messaging (FCM) |
| iOS | APNs (przez FCM) |
| Android | FCM |

### Tabela `push_tokens`

```sql
PushToken
├── id: UUID
├── user_id: UUID FK
├── token: VARCHAR(500)
├── platform: ENUM('WEB', 'IOS', 'ANDROID')
├── created_at: TIMESTAMP
├── last_used_at: TIMESTAMP
└── active: BOOLEAN DEFAULT true
```

### Tabela `push_logs` (audyt)

```sql
PushLog
├── id: UUID
├── user_id: UUID FK
├── type: ENUM('DIGEST', 'WELCOME', 'WINBACK', 'REMINDER', 'FAVORITE', 'FIRST_N')
├── title: VARCHAR(100)
├── body: VARCHAR(200)
├── sent_at: TIMESTAMP
├── delivered: BOOLEAN
├── opened: BOOLEAN
├── opened_at: TIMESTAMP
└── error: TEXT
```

### Cron jobs

| Job | Schedule | Opis |
|-----|----------|------|
| `send-daily-digest` | 10:00 | Digest nowych ofert |
| `send-welcome` | */15 min | Check nowych userów (24h) |
| `send-winback` | 09:00 | Check nieaktywnych (7 dni) |
| `send-expiring-reminders` | 09:00 | Przypomnienia o wygasających (Faza 2) |
| `cleanup-tokens` | 03:00 | Usuń nieaktywne tokeny (90 dni) |

---

## Metryki

### KPIs

| Metryka | Cel MVP |
|---------|---------|
| Delivery rate | > 95% |
| Open rate (digest) | > 15% |
| CTR (click-through) | > 8% |
| Opt-out rate | < 5% |

### Tracking

Każdy push zawiera:
- `notification_id` — do trackowania otwarć
- Deep link z UTM — do analityki

---

## A/B testy (Faza 2)

### Testy do przeprowadzenia

1. **Godzina digestu:** 10:00 vs 12:00 vs 18:00
2. **Ton:** Formalny vs przyjacielski vs emoji
3. **Personalizacja:** Imię vs bez imienia
4. **Częstotliwość:** Codziennie vs co 2 dni

---

## Przykładowe treści

### Digest - warianty tonów

**Formalny:**
```
Tytuł: Nowe oferty w Twojej okolicy
Body: Dostępnych jest 5 nowych rabatów
```

**Przyjacielski:**
```
Tytuł: Hej! 5 nowych ofert czeka
Body: Sprawdź co sąsiedzi dla Ciebie przygotowali
```

**Z emoji (jeśli user preferuje):**
```
Tytuł: 🎉 5 nowych ofert!
Body: Burger u Kazika, Kawiarnia Cicha i więcej...
```

### Rekomendacja MVP

**Przyjacielski bez emoji** — pasuje do idei "sąsiedzkiej" aplikacji, nie jest nachalne.
