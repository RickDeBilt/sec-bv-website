# S.E.C. B.V. — Website

Snelle, moderne one-page website voor **S.E.C. B.V. — Schoonmaak Expertise Centrum**.

S.E.C. B.V. begeleidt en adviseert organisaties onafhankelijk bij facilitaire
aanbestedingen, met een sterke focus op schoonmaakonderhoud van gebouwen:
contractbeheer, kwaliteitsmetingen en leveranciersselectie.

## Doel

- Snelle, statische HTML/CSS-website (geen frameworks, geen build-stap)
- Moderne, zakelijke en premium uitstraling
- SEO-vriendelijke, semantische structuur
- Sterke basis voor een latere WordPress/Elementor-versie

## Bestanden

| Bestand           | Omschrijving                                              |
| ----------------- | -------------------------------------------------------- |
| `index.html`      | Volledige one-page website (semantische HTML)            |
| `bedankt.html`    | Bedanktpagina na verzending van het contactformulier     |
| `styles.css`      | Design system + styling (CSS-variabelen, mobile-first)   |
| `script.js`       | Kleine vanilla JS: mobiel menu, scroll-reveal, jaartal   |
| `assets/`         | Media, waaronder `logo-sec.png`                          |
| `README.md`       | Dit document                                             |

## Secties (one-page)

1. Header met logo, navigatie en CTA
2. Hero met headline, subtekst en CTA's
3. Introductie / Over S.E.C. B.V.
4. Dienstenoverzicht
5. Aanbestedingsbegeleiding
6. Waarom kiezen voor S.E.C.
7. Werkwijze (4 stappen)
8. Sectoren / opdrachtgevers
9. Veelgestelde vragen (FAQ, native `<details>`-accordeon)
10. CTA-sectie
11. Contactblok (werkend Web3Forms-formulier + mailto/tel)
12. Footer

Losse pagina: `bedankt.html` — bevestigingspagina waar bezoekers na verzending landen.

## Lokaal bekijken

Open `index.html` direct in de browser, of start een lokale server voor de juiste
verwerking van relatieve paden:

```bash
# Met Python
python -m http.server 8000
# → http://localhost:8000
```

## Aanpassen

### Contactgegevens

De contactgegevens staan op twee plekken in `index.html`: in de **contactsectie**
(`#contact`) en in de **footer**. Pas beide aan bij een wijziging.

- E-mail: `info@secbv.nl` (klikbaar via `mailto:`)
- Telefoon: `06-50748992` en `06-38323667` (klikbaar via `tel:`)
- Adres: De Tuinderij 19, 3833 SC Leusden
- KvK: 42080375

> Let op: de `tel:`-links gebruiken het internationale formaat (`+316...`),
> terwijl de weergegeven tekst het Nederlandse formaat (`06-...`) toont.

### Huisstijl / kleuren

Alle kleuren, spacing, radius en typografie staan als CSS-variabelen bovenaan
`styles.css` onder `:root`. Belangrijkste tokens:

- `--color-primary: #0D7377` (primaire teal)
- `--color-ink: #333335` (donkere tekst)
- `--color-offwhite`, `--color-tint` (rustige achtergronden)

### Lettertype

De site gebruikt een systeem-fontstack met `Hanken Grotesk`/`Hanken Book` als eerste
keuze (indien lokaal beschikbaar), zodat de site snel blijft zonder externe fonts.
Wil je Hanken gegarandeerd tonen, host het font dan zelf en voeg een `@font-face` toe.

## Contactformulier (Web3Forms)

Het contactformulier verstuurt via **[Web3Forms](https://web3forms.com)** — een gratis
form-endpoint zonder eigen backend. Na verzending wordt de bezoeker doorgestuurd naar
`bedankt.html`.

### Access key

In `index.html` staat in het `<form>`-blok de actieve Web3Forms access key
(geregistreerd op `info@secbv.nl`):

```html
<input type="hidden" name="access_key" value="2ac7510c-e861-4d85-8af3-0e89098880f0" />
```

Wil je een andere key gebruiken (bv. bij een ander mailadres):

1. Ga naar <https://web3forms.com> en vraag een gratis access key aan.
2. Kopieer de access key uit de bevestigingsmail.
3. Vervang de waarde van `value="..."` in het `access_key`-veld in `index.html`
   (en in `deploy/index.html` als je die map ook publiceert).

> De key moet geregistreerd zijn op het ontvangende mailadres, anders komen
> inzendingen **niet** aan.

### Overige velden

- `redirect` → `https://www.secbv.nl/bedankt.html` (bedanktpagina na verzending).
- `botcheck` → verborgen honeypot tegen spam; **niet** verwijderen.
- `subject` / `from_name` → onderwerp en afzendernaam van de notificatiemail.

Direct mailen of bellen kan altijd: `info@secbv.nl`, `06-50748992` / `06-38323667`.

## Techniek & prestaties

- Semantische HTML5 met correcte heading-hiërarchie
- Mobile-first, responsive CSS (Grid/Flexbox)
- `meta title`, `meta description`, Open Graph- en Twitter-tags
- JSON-LD structured data (`ProfessionalService`)
- Toegankelijk: skip-link, focus-states, aria-labels, respecteert `prefers-reduced-motion`
- Geen externe frameworks of zware libraries

## Uitbreiden naar meerdere pagina's

De one-page structuur is opgezet met duidelijke secties en anchors. Losse pagina's
(Over ons, Diensten, Werkwijze, Contact) zijn later eenvoudig af te splitsen door de
betreffende sectie naar een eigen HTML-bestand te verplaatsen en de navigatie te koppelen.
