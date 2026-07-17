# S.E.C. B.V. — Website

Snelle, moderne statische website voor **S.E.C. B.V. — Schoonmaak Expertise Centrum**.

S.E.C. B.V. begeleidt en adviseert organisaties onafhankelijk bij schoonmaak- en
facilitaire aanbestedingen, met een sterke focus op schoonmaakonderhoud van gebouwen:
contractbeheer, kwaliteitsbeheer en leveranciersselectie.

> **S.E.C. B.V. voert géén technische installaties uit** en doet géén installatiebeheer
> of onderhoud daarvan. Houd de site, `llms.txt` en `llms-full.txt` vrij van
> verwijzingen daarnaar. Zie `seo-monitoring.md` voor de controlecommando's.

## Openstaande actiepunten

- **Navragen bij klant of "Materkey" mogelijk "MasterKey" moet zijn.** De naam
  "Materkey" uit de klantinput bestaat niet aantoonbaar in de Nederlandse markt;
  vermoedelijk is MasterKey (masterkey.nl, Apeldoorn) bedoeld. **Zolang de klant dit
  niet bevestigt, wordt de naam nergens gepubliceerd.**
- **Claim "30+ jaar ervaring"** op de homepage laten bevestigen door de klant.
- **Kennisbankartikelen**: voorstel ligt klaar in `seo-monitoring.md`, wacht op akkoord.

## Doel

- Snelle, statische HTML/CSS-website (geen frameworks, geen build-stap)
- Moderne, zakelijke en premium uitstraling
- SEO-vriendelijke, semantische structuur
- Sterke basis voor een latere WordPress/Elementor-versie

## Bestanden

| Bestand           | Omschrijving                                              |
| ----------------- | -------------------------------------------------------- |
| `index.html`      | Homepage (positionering + doorverwijzing naar de dienstpagina's) |
| `bedankt.html`    | Bedanktpagina na verzending van het contactformulier (`noindex`) |
| `styles.css`      | Design system + styling (CSS-variabelen, mobile-first)   |
| `script.js`       | Kleine vanilla JS: mobiel menu, scroll-reveal, jaartal, formulier |
| `assets/`         | Media, waaronder `logo-sec.png`                          |
| `api/contact.php` | PHP-endpoint dat het formulier via SMTP verstuurt        |
| `api/lib/PHPMailer/` | Meegeleverde PHPMailer-library (geen Composer nodig)  |
| `private/`        | SMTP-config **buiten de webroot** (`contact-config.php`) |
| `.htaccess`       | Cache/gzip + beveiliging van het configbestand           |
| `llms.txt`        | Compacte AI-samenvatting (Markdown) voor AI-modellen     |
| `llms-full.txt`   | Uitgebreide, feitelijke AI-tekstversie van de website    |
| `sitemap.xml`     | XML-sitemap met alle indexeerbare pagina's               |
| `robots.txt`      | Crawl-richtlijnen + verwijzing naar de sitemap           |
| `deploy.ps1`      | Bouwt `deploy/` en `sec-bv-upload.zip` (whitelist)       |
| `seo-monitoring.md` | Zoekwoorden, wekelijkse checklist, AI-tests, workflow  |
| `README.md`       | Dit document                                             |

## Paginastructuur

De site was oorspronkelijk one-page en is uitgebreid met SEO-landingspagina's. Elke
pagina is een eigen `index.html` in een eigen map, zodat de URL op een `/` eindigt.

| URL | Map | Doel |
| --- | --- | ---- |
| `/` | `index.html` | Positioneren en doorlinken. Rankt bewust niet op alles. |
| `/schoonmaak-aanbestedingen/` | idem | Hub: procedurevormen (Europees/openbaar/onderhands) |
| `/aanbestedingsbegeleiding-schoonmaak/` | idem | De dienst: wat wij doen tijdens het traject |
| `/facilitaire-aanbestedingen/` | idem | Breder dan schoonmaak; percelen en integrale contracten |
| `/schoonmaakadvies/` | idem | Schoonmaakconsultancy, van analyse tot borging |
| `/leveranciersselectie-schoonmaak/` | idem | Inschrijvingen eerlijk vergelijken |
| `/contractbeheer-schoonmaak/` | idem | Grip na de gunning |
| `/kwaliteitsbeheer-schoonmaak/` | idem | Meten en bijsturen (VSR) |
| `/kennisbank/` | idem | Achtergrond: procedures, VSR, Code Verantwoordelijk Marktgedrag |
| `/vergelijk-schoonmaakadviesbureaus/` | idem | Marktoverzicht en keuzecriteria |
| `/contact/` | idem | Contactgegevens + het contactformulier |

Losse pagina: `bedankt.html` — bevestigingspagina na verzending. Staat op `noindex`
en hoort daarom **niet** in `sitemap.xml`.

### Secties op de homepage

Header · Hero · Over S.E.C. B.V. (`#over`) · Diensten (`#diensten`, 7 kaarten die
doorlinken) · Aanbestedingsbegeleiding (`#aanbesteding`) · Waarom S.E.C. (`#waarom`) ·
Werkwijze (`#werkwijze`) · Sectoren (`#sectoren`) · FAQ (`#faq`) · CTA · Contact
(`#contact`) · Footer.

Subpagina's linken naar deze ankers met een absoluut pad (`/#contact`), niet met `#contact`.

### Een pagina toevoegen

1. Nieuwe map met `index.html`, gebaseerd op een bestaande pagina (header, footer,
   breadcrumb en JSON-LD zijn identiek van opzet).
2. Opnemen in de **footernavigatie op álle pagina's** — de footer is de plek waar de
   volledige linkstructuur staat; de hoofdnavigatie blijft bewust beperkt tot zes items.
3. Toevoegen aan `sitemap.xml`, `llms.txt` en `llms-full.txt`.
4. **Toevoegen aan `$WebrootDirs` in `deploy.ps1`** — anders wordt de map niet
   geüpload en krijgt de bezoeker een 404.

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

### Cache-busting: bij élke wijziging aan styles.css of script.js

`.htaccess` cachet CSS en JS **een jaar** (`ExpiresByType text/css "access plus 1 year"`),
terwijl HTML niet gecacht wordt. Wijzig je de CSS zonder de versie te verhogen, dan
krijgt een terugkerende bezoeker **nieuwe HTML met oude CSS** — en dat sloopt de layout.
Dat is geen theorie: het gebeurde direct na het toevoegen van de SEO-pagina's, waarbij
kruimelpaden als genummerde lijst verschenen omdat de nieuwe `.breadcrumb`-regels
ontbraken in de gecachte CSS.

Alle pagina's verwijzen daarom naar `/styles.css?v=N` en `/script.js?v=N`. **De huidige
versie is `v=3`.** Verhoog dat nummer bij elke wijziging aan een van beide bestanden:

```powershell
# Pas $from/$to aan; $from is de versie die er nu staat.
$from = 3; $to = 4
Get-ChildItem -Recurse -Include *.html -File |
  Where-Object { $_.FullName -notmatch '\\deploy\\' } |
  ForEach-Object {
    (Get-Content $_.FullName -Raw) -replace "\?v=$from`"", "?v=$to`"" |
      Set-Content $_.FullName -NoNewline -Encoding UTF8
  }
```

Controleer daarna dat er geen `?v=` van de oude versie is blijven staan, en werk de
versie hierboven in dit document bij.

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
- `meta title`, `meta description`, Open Graph- en Twitter-tags per pagina
- JSON-LD structured data: `ProfessionalService` + `WebSite` + `FAQPage` op de homepage,
  `WebPage` + `BreadcrumbList` op elke subpagina. Alleen feitelijk — geen reviews of
  ratings, en geen relaties met andere organisaties
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

## Deployen

`deploy/` is een **kopie van de webroot** en wordt gegenereerd — bewerk daar niets
met de hand. Draai vanuit de projectroot:

```powershell
.\deploy.ps1            # spiegelt naar deploy\ en maakt sec-bv-upload.zip
.\deploy.ps1 -SkipZip   # alleen de deploy-map bijwerken
```

Het script werkt met een **whitelist** (`$WebrootFiles` en `$WebrootDirs`): alles wat
daar niet in staat, komt niet in de webroot. Dat is bewust — `private\` bevat de
SMTP-inloggegevens en mag er nooit in belanden. Het script breekt af als dat toch
gebeurt, en als een bestand of map uit de whitelist ontbreekt.

Upload daarna de **inhoud** van `sec-bv-upload.zip` naar
`/domains/secbv.nl/public_html/`. `private\contact-config.php` blijft daarbuiten,
in `/domains/secbv.nl/private/`.

## SEO-onderhoud

Zie **`seo-monitoring.md`** voor de zoekwoordmapping, de wekelijkse checklist,
de handmatige AI-tests en de workflow. Kern: **geen automatische live-wijzigingen** —
lokaal wijzigen, een mens laat het na, committen, deployen.
