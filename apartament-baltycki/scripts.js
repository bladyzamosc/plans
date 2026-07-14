/* ========================================
   APARTAMENT BALTYCKI - SCRIPTS
   ======================================== */

document.addEventListener('DOMContentLoaded', function() {
    lucide.createIcons();

    initMobileMenu();
    initMainMap();
    initSmoothScroll();
    initScrollHeader();
    initLangSwitcher();
    initHeroSlideshow();
    initLightbox();
});

/* ========================================
   HERO SLIDESHOW
   ======================================== */
function initHeroSlideshow() {
    const slides = document.querySelectorAll('.hero-slide');
    if (slides.length === 0) return;

    let current = 0;
    const interval = 5000; // 5 sekund na zdjęcie

    setInterval(() => {
        slides[current].classList.remove('active');
        current = (current + 1) % slides.length;
        slides[current].classList.add('active');
    }, interval);
}

/* ========================================
   SCROLL HEADER EFFECT
   ======================================== */
function initScrollHeader() {
    const header = document.querySelector('.header');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            header.classList.add('scrolled');
        } else {
            header.classList.remove('scrolled');
        }
    });
}

/* ========================================
   MOBILE MENU
   ======================================== */
function initMobileMenu() {
    const menuBtn = document.getElementById('mobileMenuBtn');
    const closeBtn = document.getElementById('mobileMenuClose');
    const menu = document.getElementById('mobileMenu');
    const links = menu.querySelectorAll('a');

    function open() {
        menu.classList.add('open');
        document.body.style.overflow = 'hidden';
    }

    function close() {
        menu.classList.remove('open');
        document.body.style.overflow = '';
    }

    menuBtn.addEventListener('click', open);
    closeBtn.addEventListener('click', close);
    links.forEach(link => link.addEventListener('click', close));

    document.addEventListener('keydown', e => {
        if (e.key === 'Escape') close();
    });
}

/* ========================================
   MAIN MAP
   ======================================== */
function initMainMap() {
    const mapContainer = document.getElementById('mainMap');
    if (!mapContainer) return;

    // Współrzędne apartamentu
    const apartmentLat = 54.82651;
    const apartmentLng = 18.32803;

    const map = L.map('mainMap').setView([apartmentLat, apartmentLng], 14);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; OpenStreetMap'
    }).addTo(map);

    // Apartment marker
    const apartmentIcon = L.divIcon({
        className: 'custom-marker',
        html: `<div style="
            width: 44px;
            height: 44px;
            background: linear-gradient(135deg, #0891B2, #22D3EE);
            border-radius: 50% 50% 50% 0;
            transform: rotate(-45deg);
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 3px 15px rgba(8,145,178,0.5);
            border: 3px solid white;
        ">
            <span style="transform: rotate(45deg); font-size: 18px;">🏠</span>
        </div>`,
        iconSize: [44, 54],
        iconAnchor: [22, 54]
    });

    L.marker([apartmentLat, apartmentLng], { icon: apartmentIcon })
        .addTo(map)
        .bindPopup(`
            <strong style="font-size: 14px;">Apartament Bałtycki</strong><br>
            <span style="color: #64748B;">Podgrzybkowa 17c/2, Tupadły</span>
        `)
        .openPopup();

    // POI data
    const pois = [
        { lat: 54.831818784913175, lng: 18.3248080288225, name: 'Lisi Jar', desc: 'Zejście na plażę', emoji: '🌲', color: '#10B981' },
        { lat: 54.83096252238719, lng: 18.333372030426492, name: 'Latarnia morska', desc: '600m', emoji: '🗼', color: '#F59E0B' },
        { lat: 54.83165302098748, lng: 18.336849089822245, name: 'Przylądek Rozewie', desc: 'Punkt widokowy', emoji: '🏔️', color: '#10B981' },
        { lat: 54.831955873644375, lng: 18.320127328370237, name: 'SPA Primavera', desc: 'Wellness & SPA', emoji: '💆', color: '#EC4899' },
        { lat: 54.83061605499631, lng: 18.30768489983855, name: 'Pizza Portofino', desc: '⭐ 4.8', emoji: '🍕', color: '#EF4444' },
        { lat: 54.831565389799835, lng: 18.30650181932112, name: 'Kebson Kebab Felipe', desc: '⭐ 4.7', emoji: '🥙', color: '#F97316' },
        { lat: 54.83347794825832, lng: 18.29850543861065, name: 'Kredens', desc: '⭐ 4.6', emoji: '🍽️', color: '#8B5CF6' },
        { lat: 54.83347794825832, lng: 18.29850543861065, name: 'Papaj', desc: '⭐ 4.5 • Pizza', emoji: '🍕', color: '#F97316' },
        { lat: 54.833261671336714, lng: 18.303011549737032, name: 'U Rybaka', desc: '⭐ 4.6', emoji: '🐟', color: '#3B82F6' },
        { lat: 54.83351994531128, lng: 18.30610734046284, name: 'Dom Whisky', desc: '⭐ 4.9 • 1000+ whisky', emoji: '🥃', color: '#92400E' },
        { lat: 54.82888729518458, lng: 18.326419512174176, name: 'Nóż Widelec Łyżka', desc: '⭐ 4.7', emoji: '🍴', color: '#6366F1' },
        { lat: 54.8298853331511, lng: 18.332161484408825, name: 'Gryza', desc: '⭐ 4.8 • Burgery & Grill', emoji: '🍔', color: '#DC2626' },
    ];

    pois.forEach(poi => {
        const poiIcon = L.divIcon({
            className: 'poi-marker',
            html: `<div style="
                width: 32px;
                height: 32px;
                background: ${poi.color};
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 2px 8px rgba(0,0,0,0.2);
                font-size: 16px;
                border: 2px solid white;
            ">${poi.emoji}</div>`,
            iconSize: [32, 32],
            iconAnchor: [16, 16]
        });

        L.marker([poi.lat, poi.lng], { icon: poiIcon })
            .addTo(map)
            .bindPopup(`<strong>${poi.name}</strong><br><span style="color:#64748B">${poi.desc}</span>`);
    });
}


/* ========================================
   LANGUAGE SWITCHER
   ======================================== */
function initLangSwitcher() {
    const switcher = document.querySelector('.lang-switcher');
    const toggle = document.getElementById('langToggle');

    if (!toggle) return;

    const flagUrls = {
        pl: 'https://flagcdn.com/w40/pl.png',
        en: 'https://flagcdn.com/w40/gb.png',
        de: 'https://flagcdn.com/w40/de.png',
        cs: 'https://flagcdn.com/w40/cz.png',
        sk: 'https://flagcdn.com/w40/sk.png',
        uk: 'https://flagcdn.com/w40/ua.png'
    };
    const codes = { pl: 'PL', en: 'EN', de: 'DE', cs: 'CZ', sk: 'SK', uk: 'UA' };

    toggle.addEventListener('click', (e) => {
        e.stopPropagation();
        switcher.classList.toggle('open');
    });

    document.addEventListener('click', () => {
        switcher.classList.remove('open');
    });

    document.querySelectorAll('.lang-option').forEach(option => {
        option.addEventListener('click', (e) => {
            e.preventDefault();
            const lang = option.dataset.lang;

            document.querySelectorAll('.lang-option').forEach(o => o.classList.remove('active'));
            document.querySelectorAll(`[data-lang="${lang}"]`).forEach(o => o.classList.add('active'));

            toggle.querySelector('.lang-flag').src = flagUrls[lang];
            toggle.querySelector('.lang-code').textContent = codes[lang];

            switcher.classList.remove('open');

            applyTranslations(lang);
            localStorage.setItem('lang', lang);
        });
    });

    // Load saved language
    const savedLang = localStorage.getItem('lang') || 'pl';
    if (savedLang !== 'pl') {
        document.querySelectorAll(`[data-lang="${savedLang}"]`).forEach(o => o.classList.add('active'));
        document.querySelectorAll('[data-lang="pl"]').forEach(o => o.classList.remove('active'));
        toggle.querySelector('.lang-flag').src = flagUrls[savedLang];
        toggle.querySelector('.lang-code').textContent = codes[savedLang];
        applyTranslations(savedLang);
    }
}

function applyTranslations(lang) {
    if (typeof translations === 'undefined' || !translations[lang]) return;

    const t = translations[lang];

    // Navigation
    document.querySelectorAll('[data-i18n]').forEach(el => {
        const key = el.dataset.i18n;
        const keys = key.split('.');
        let value = t;
        for (const k of keys) {
            if (value && value[k]) value = value[k];
            else { value = null; break; }
        }
        if (value) el.textContent = value;
    });

    // Update HTML lang attribute
    document.documentElement.lang = lang === 'uk' ? 'uk' : lang === 'cs' ? 'cs' : lang === 'sk' ? 'sk' : lang === 'de' ? 'de' : 'pl';
}

/* ========================================
   SMOOTH SCROLL
   ======================================== */
function initSmoothScroll() {
    document.querySelectorAll('a[href^="#"]').forEach(link => {
        link.addEventListener('click', e => {
            const href = link.getAttribute('href');
            if (href === '#') return;

            const target = document.querySelector(href);
            if (target) {
                e.preventDefault();
                const headerHeight = document.querySelector('.header').offsetHeight;
                const top = target.offsetTop - headerHeight;
                window.scrollTo({ top, behavior: 'smooth' });
            }
        });
    });
}

/* ========================================
   LIGHTBOX GALLERY
   ======================================== */
function initLightbox() {
    const lightbox = document.getElementById('lightbox');
    const lightboxImg = document.getElementById('lightboxImage');
    const lightboxCounter = document.getElementById('lightboxCounter');
    const closeBtn = document.getElementById('lightboxClose');
    const prevBtn = document.getElementById('lightboxPrev');
    const nextBtn = document.getElementById('lightboxNext');

    if (!lightbox) return;

    const galleryItems = document.querySelectorAll('.gallery-item');
    const images = [];
    let currentIndex = 0;

    galleryItems.forEach((item, index) => {
        const img = item.querySelector('img');
        if (img) {
            images.push(img.src);
            item.addEventListener('click', () => openLightbox(index));
        }
    });

    function openLightbox(index) {
        currentIndex = index;
        updateLightbox();
        lightbox.classList.add('active');
        document.body.style.overflow = 'hidden';
        lucide.createIcons();
    }

    function closeLightbox() {
        lightbox.classList.remove('active');
        document.body.style.overflow = '';
    }

    function updateLightbox() {
        lightboxImg.src = images[currentIndex];
        lightboxCounter.textContent = `${currentIndex + 1} / ${images.length}`;
    }

    function showPrev() {
        currentIndex = (currentIndex - 1 + images.length) % images.length;
        updateLightbox();
    }

    function showNext() {
        currentIndex = (currentIndex + 1) % images.length;
        updateLightbox();
    }

    closeBtn.addEventListener('click', closeLightbox);
    prevBtn.addEventListener('click', showPrev);
    nextBtn.addEventListener('click', showNext);

    lightbox.addEventListener('click', (e) => {
        if (e.target === lightbox) closeLightbox();
    });

    document.addEventListener('keydown', (e) => {
        if (!lightbox.classList.contains('active')) return;
        if (e.key === 'Escape') closeLightbox();
        if (e.key === 'ArrowLeft') showPrev();
        if (e.key === 'ArrowRight') showNext();
    });
}
