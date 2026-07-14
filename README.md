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
| `script.js`       | Kleine vanilla JS: mobiel menu, scroll-reveal, jaartal, formulier |
| `assets/`         | Media, waaronder `logo-sec.png`                          |
| `api/contact.php` | PHP-endpoint dat het formulier via SMTP verstuurt        |
| `api/lib/PHPMailer/` | Meegeleverde PHPMailer-library (geen Composer nodig)  |
| `private/`        | SMTP-config **buiten de webroot** (`contact-config.php`) |
| `.htaccess`       | Cache/gzip + beveiliging van het configbestand           |
| `llms.txt`        | Compacte AI-samenvatting (Markdown) voor AI-modellen     |
| `llms-full.txt`   | Uitgebreide, feitelijke AI-tekstversie van de website    |
| `sitemap.xml`     | XML-sitemap met de belangrijkste URL's                   |
| `robots.txt`      | Crawl-richtlijnen + verwijzing naar de sitemap           |
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
11. Contactblok (werkend SMTP-formulier via PHPMailer + mailto/tel)
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

## Contactformulier (SMTP via PHPMailer)

Het formulier verstuurt via **geauthenticeerde SMTP** (SMTPS, poort 465) met een
meegeleverde **PHPMailer** — geen externe dienst, geen Composer. De PHP-backend staat
in `api/contact.php`; de inloggegevens staan in een configbestand **buiten de webroot**.

- Berichten komen binnen bij **`info@secbv.nl`**, met een **BCC** naar
  **`info@rickswebsites.nl`**.
- Afzender/authenticatie: **`website@secbv.nl`** (apart mailaccount, i.v.m. SPF/DKIM).
- Na verzending gaat de bezoeker naar `bedankt.html`. Zonder JavaScript werkt het
  formulier ook (POST → redirect); mét JavaScript gebeurt het via `fetch` met nette
  in-page statusmeldingen.
- Anti-spam: verborgen honeypot (`website`), minimale invultijd (3 s) en rate limiting
  per IP.

### Eenmalig instellen op de host (Vimexx / DirectAdmin)

1. **Maak het mailaccount `website@secbv.nl`** aan in DirectAdmin en kies een sterk
   wachtwoord.
2. **Upload de webroot** (inhoud van `deploy/`, of de root-bestanden) naar
   `/domains/secbv.nl/public_html/` — inclusief de map `api/`.
3. **Plaats de config buiten de webroot:** kopieer `private/contact-config.php` naar
   `/domains/secbv.nl/private/contact-config.php` en vul bij `smtp_password` het
   wachtwoord van `website@secbv.nl` in.

   > `private/contact-config.php` staat in `.gitignore` en hoort **nooit** in de webroot
   > of in git. `contact-config.example.php` is het veilige voorbeeld dat wél in git mag.

4. Test het formulier op de live site. Komt er niets binnen? Controleer het serverlog
   (regels met `[contact]`) en of poort 465 openstaat.

Instellingen (host, poort, afzender, ontvanger, BCC) staan bovenaan
`private/contact-config.php`. Zie `private/contact-config.example.php` voor alle velden.

Direct mailen of bellen kan altijd: `info@secbv.nl`, `06-50748992` / `06-38323667`.

## Techniek & prestaties

- Semantische HTML5 met correcte heading-hiërarchie
- Mobile-first, responsive CSS (Grid/Flexbox)
- `meta title`, `meta description`, Open Graph- en Twitter-tags
- JSON-LD structured data (`ProfessionalService`)
- Toegankelijk: skip-link, focus-states, aria-labels, respecteert `prefers-reduced-motion`
- Geen externe frameworks of zware libraries

## AI & SEO (llms.txt, sitemap, robots)

Om de site goed begrijpelijk te maken voor **AI-modellen** en **zoekmachines**
staan er vier bestanden in de root van de website:

| Bestand           | Doel                                                                                     |
| ----------------- | ---------------------------------------------------------------------------------------- |
| `llms.txt`        | Compacte, gestructureerde Markdown-samenvatting van S.E.C. B.V. (volgt de llms.txt-conventie). |
| `llms-full.txt`   | Uitgebreidere, feitelijke tekstversie: wie/wat, diensten, doelgroepen, werkwijze, contact. |
| `sitemap.xml`     | XML-sitemap met de belangrijkste URL's, inclusief `lastmod`.                              |
| `robots.txt`      | Staat normale crawling toe en verwijst naar `sitemap.xml` (met een comment naar `llms.txt`). |

Belangrijk bij het onderhouden:

- Alle vier de bestanden horen in de **root** van de website
  (`https://www.secbv.nl/llms.txt`, `.../sitemap.xml`, enz.).
- `llms.txt` en `llms-full.txt` bevatten **alleen feitelijke** informatie — geen
  overdreven marketingtaal en geen persoonsnamen bij telefoonnummers.
- S.E.C. B.V. voert **geen technische installaties** uit; houd deze bestanden vrij
  van verwijzingen daarnaar.
- Werk `lastmod` in `sitemap.xml` bij wanneer de inhoud wijzigt (formaat `JJJJ-MM-DD`).
- Wijzig je iets, werk dan ook de kopie in `deploy/` bij (zie hieronder).

## Uitbreiden naar meerdere pagina's

De one-page structuur is opgezet met duidelijke secties en anchors. Losse pagina's
(Over ons, Diensten, Werkwijze, Contact) zijn later eenvoudig af te splitsen door de
betreffende sectie naar een eigen HTML-bestand te verplaatsen en de navigatie te koppelen.
