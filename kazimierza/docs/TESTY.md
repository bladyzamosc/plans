# Strategia testowania Tuswoi

## Testy manualne (beta testing)

### Faza 1: Zamknięta beta (1-2 tyg)

| Element | Co |
|---------|-----|
| Dzielnica | 1 (np. Odolany) |
| Lokal | 1 (znajomy właściciel) |
| Testerzy | 10-20 znajomych, różne telefony (iOS/Android) |
| Cel | Stabilizacja, wyłapanie bugów |

**Co testujemy:**
- Rejestracja (Google/Apple/Magic link)
- Przeglądanie ofert
- Generowanie QR
- Walidacja PIN przez pracownika
- Push notifications
- Panel właściciela

### Faza 2: Rozszerzenie (2-4 tyg)

| Element | Co |
|---------|-----|
| Lokale | 3-5 |
| Właściciele | Prawdziwi (nie tylko znajomi) |
| Testerzy | 50-100 osób |
| Cel | Feedback od właścicieli, edge cases |

### Faza 3: Soft launch
- Publiczna dostępność w 1 dzielnicy
- Monitoring Sentry
- Zbieranie feedbacku

---

## Testy automatyczne

To co miałem na myśli mówiąc "strategia testów" - testy pisane przez programistę, uruchamiane automatycznie przy każdym uopdate kodu.

### Unit testy (szybkie, izolowane)

Testują pojedyncze funkcje/klasy bez bazy danych i zewnętrznych serwisów.

```java
// Przykład: walidacja kodu QR
@Test
void shouldRejectExpiredQrCode() {
    var qr = new QrCode("RDM-A7X2K9", LocalDateTime.now().minusMinutes(20));
    
    assertThrows(QrExpiredException.class, () -> 
        redemptionService.validate(qr, "1234")
    );
}

// Przykład: limit dzienny
@Test
void shouldEnforceDailyLimit() {
    var user = new User("jan@example.com");
    var offer = new Offer("Pizza -20%", venueId);
    
    redemptionService.redeem(user, offer); // pierwszy OK
    
    assertThrows(DailyLimitExceededException.class, () ->
        redemptionService.redeem(user, offer) // drugi - błąd
    );
}
```

**Gdzie stosować:**
- Walidacja QR (expiry, format)
- Limity (dzienny, per oferta)
- Obliczenia rabatów
- Moderacja (słownik wulgaryzmów)

### Integration testy (wolniejsze, z bazą)

Testują całe flow z prawdziwą bazą danych (testową).

```java
@SpringBootTest
@Testcontainers
class RedemptionFlowTest {

    @Test
    void fullRedemptionFlow() {
        // 1. User generuje QR
        var qr = redemptionController.generateQr(offerId, userId);
        assertThat(qr.getCode()).startsWith("RDM-");
        
        // 2. Pracownik waliduje
        var result = validationController.validate(qr.getCode(), "1234");
        assertThat(result.getStatus()).isEqualTo("REDEEMED");
        
        // 3. Sprawdź w bazie
        var redemption = redemptionRepository.findByCode(qr.getCode());
        assertThat(redemption.getRedeemedAt()).isNotNull();
    }
}
```

**Gdzie stosować:**
- Pełny flow realizacji rabatu
- Rejestracja użytkownika
- Tworzenie oferty przez właściciela

### E2E testy (najwolniejsze, pełny system)

Testują aplikację jak prawdziwy użytkownik - klikając w UI.

```typescript
// Playwright / Cypress
test('user can redeem offer', async ({ page }) => {
  await page.goto('/login');
  await page.click('text=Zaloguj przez Google');
  // ... mock OAuth
  
  await page.goto('/offers');
  await page.click('text=Pizza -20%');
  await page.click('text=Pokaż kod QR');
  
  await expect(page.locator('.qr-code')).toBeVisible();
});
```

**Gdzie stosować (minimum):**
- Happy path: rejestracja → przeglądanie → realizacja
- Panel właściciela: tworzenie oferty

---

## Rekomendacja MVP

| Typ testu | Ilość | Priorytet |
|-----------|-------|-----------|
| **Unit** | ~20-30 | Krytyczne funkcje |
| **Integration** | ~10 | Główne flow |
| **E2E** | ~3-5 | Happy paths |
| **Manualne (beta)** | Ciągłe | Główna walidacja |

**Filozofia:** Na MVP lepiej mieć 20 dobrych unit testów niż 100 słabych. Resztę wyłapią beta testerzy.

### Co testować automatycznie (must have)
- Walidacja QR (expiry, format, już użyty)
- Limit dzienny (1 oferta/dzień)
- Autoryzacja (kto może co)
- Moderacja (słownik blokuje wulgaryzmy)

### Co testować manualnie (beta)
- UX/UI
- Performance na różnych telefonach
- Edge cases których nie przewidzieliśmy
- Integracje (OAuth, push, email)

---

*Ostatnia aktualizacja: 2026-07-18*
