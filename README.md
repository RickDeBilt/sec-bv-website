# S.E.C. B.V. — Website

Snelle, moderne one-page website voor **S.E.C. B.V. — Schoonmaak Expertise Centrum**.

S.E.C. B.V. begeleidt en adviseert organisaties onafhankelijk bij aanbestedingen van
facilitaire diensten: schoonmaakonderhoud van gebouwen, technische installaties,
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
11. Contactblok (met visueel formulier + mailto)
12. Footer

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

## Contactformulier

Het formulier is nu een **visueel, niet-verzendend** formulier met een `mailto:`-fallback.
Er is bewust geen backend of externe formservice gebruikt. Voor echte verzending kan later
een form-endpoint of serverless functie worden gekoppeld.

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
