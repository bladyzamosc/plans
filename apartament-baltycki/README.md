# Apartament Bałtycki - Strona WWW

Strona wizytówkowa dla apartamentu w Jastrzębiej Górze.

## Struktura plików

```
apartament-baltycki/
├── index.html          # Główna strona
├── styles.css          # Style CSS
├── scripts.js          # JavaScript
├── images/
│   ├── main.jpg        # Zdjęcie główne (hero) - DO DODANIA
│   └── gallery/
│       ├── 1.jpg       # Salon ✓
│       ├── 2.jpg       # Salon ✓
│       ├── 3.jpg       # Kuchnia ✓
│       ├── 4.jpg       # Sypialnia małżeńska ✓
│       ├── 5.jpg       # Sypialnia twin ✓
│       ├── 6.jpg       # Łazienka z wanną ✓
│       ├── 7.jpg       # Łazienka z prysznicem ✓
│       ├── 8.jpg       # Balkon ✓
│       ├── 9.jpg       # Detale ✓
│       └── 10.jpg      # Widok ✓
└── README.md
```

## Do uzupełnienia

### 1. Zdjęcie główne
- [ ] `images/main.jpg` - zdjęcie hero (user dostarczy)

### 2. Współrzędne GPS (opcjonalnie)
- [ ] Dokładna lokalizacja apartamentu przy ul. Pomorskiej
- [ ] Aktualne: 54.8372, 18.3178 (przybliżone)

### 3. POI - do zweryfikowania
- [ ] Prawdziwe lokalizacje restauracji
- [ ] Współrzędne GPS dla każdego POI

## Hosting

### Opcja A: home.pl (FTP)
1. Wgraj pliki przez FTP do `/public_html/`
2. Host: `ftp.apartament-baltycki.pl`

### Opcja B: GitHub Pages
1. Utwórz repo na GitHub
2. Wgraj pliki
3. Settings → Pages → Deploy from branch (main)
4. Skonfiguruj DNS w home.pl:
   - A: 185.199.108.153
   - A: 185.199.109.153
   - CNAME www: YOUR-USERNAME.github.io

## Technologie

- HTML5, CSS3, JavaScript (vanilla)
- Leaflet (mapy)
- Lightbox2 (galeria)
- Lucide Icons
- Google Fonts (Playfair Display, Inter)

## Autor strony

bladyzamosc@gmail.com
