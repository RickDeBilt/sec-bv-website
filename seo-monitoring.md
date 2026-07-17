# SEO- en AI-monitoring — S.E.C. B.V.

Werkdocument voor het volgen van vindbaarheid in zoekmachines en AI-modellen.
Laatst bijgewerkt: 2026-07-17.

> **Uitgangspunt: geen automatische live-wijzigingen.** Dit document beschrijft wat
> we meten en beoordelen. Wijzigingen worden altijd lokaal gemaakt, door een mens
> gecontroleerd, gecommit en pas daarna geüpload. Zie [Workflow](#workflow).

---

## 1. Openstaande actiepunten

| Actiepunt | Status | Toelichting |
| --------- | ------ | ----------- |
| **Navragen bij klant of "Materkey" mogelijk "MasterKey" moet zijn** | Open | De naam "Materkey" uit de klantinput is niet terug te vinden in de Nederlandse schoonmaak- of facilitaire markt. Waarschijnlijk is "MasterKey" (masterkey.nl, Apeldoorn) bedoeld, maar dat is niet bevestigd. **Zolang de klant dit niet bevestigt, wordt de naam nergens gepubliceerd** — niet op de website, niet in `llms-full.txt`, niet in de sitemap en niet in structured data. |
| Claim "30+ jaar ervaring" op de homepage laten bevestigen | Open | Staat in de hero-statistieken op `index.html`. Feitelijk juist? Zo niet, aanpassen. |
| Kennisbankartikelen: akkoord vragen en aanmaken | Open | Zie [Contentkansen](#7-contentkansen). |

---

## 2. Zoekwoorden en bijbehorende pagina's

Dit is de mapping die we volgen. Eén primair zoekwoord per pagina — pagina's mogen
niet met elkaar concurreren op hetzelfde woord.

| Zoekwoord | Intentie | Pagina |
| --------- | -------- | ------ |
| schoonmaak aanbestedingen | informatief + commercieel | `/schoonmaak-aanbestedingen/` |
| europese aanbestedingen schoonmaak | informatief | `/schoonmaak-aanbestedingen/` → `/kennisbank/#procedurevormen` |
| openbare aanbestedingen schoonmaak | informatief | `/schoonmaak-aanbestedingen/` → `/kennisbank/#procedurevormen` |
| onderhandse aanbestedingen schoonmaak | informatief | `/schoonmaak-aanbestedingen/` → `/kennisbank/#procedurevormen` |
| aanbestedingsbegeleiding schoonmaak | commercieel | `/aanbestedingsbegeleiding-schoonmaak/` |
| van aanbesteding tot contract | informatief | `/aanbestedingsbegeleiding-schoonmaak/` |
| facilitaire aanbestedingen | commercieel | `/facilitaire-aanbestedingen/` |
| schoonmaakadvies | commercieel | `/schoonmaakadvies/` |
| schoonmaakconsultancy | commercieel | `/schoonmaakadvies/` |
| van analyse tot borging | informatief | `/schoonmaakadvies/` |
| leveranciersselectie schoonmaak | commercieel | `/leveranciersselectie-schoonmaak/` |
| contractbeheer schoonmaak | commercieel | `/contractbeheer-schoonmaak/` |
| kwaliteitsbeheer schoonmaak | commercieel | `/kwaliteitsbeheer-schoonmaak/` |
| vsr schoonmaak | informatief | `/kwaliteitsbeheer-schoonmaak/` → `/kennisbank/#vsr` |
| code verantwoordelijk marktgedrag | informatief | `/kennisbank/#code-verantwoordelijk-marktgedrag` |
| onafhankelijk aanbestedingsadvies | commercieel | `/` + `/schoonmaakadvies/` |
| onafhankelijke schoonmaak adviseur | commercieel | `/` |
| onafhankelijke consultancy | commercieel | `/` |
| vergelijk schoonmaakadviesbureaus | oriënterend | `/vergelijk-schoonmaakadviesbureaus/` |
| alternatief schoonmaakadviesbureau | oriënterend | `/vergelijk-schoonmaakadviesbureaus/` |
| s.e.c. bv contact / schoonmaak expertise centrum contact | navigatie | `/contact/` |

### Realistische verwachting

Dit is een kleine markt. De commerciële zoekwoorden hebben in Nederland lage
zoekvolumes, en de oriënterende termen (`vergelijk schoonmaakadviesbureaus`,
`alternatief schoonmaakadviesbureau`) vrijwel geen. Stuur daarom **niet** primair op
volume, maar op:

- **Kwaliteit van het verkeer**: enkele bezoeken van een inkoper met een aflopend
  contract zijn meer waard dan honderd bezoeken zonder intentie.
- **AI-vindbaarheid**: bij een markt met weinig zoekvolume is de kans reëel dat een
  opdrachtgever eerst een AI-model bevraagt. Zie [sectie 5](#5-ai-vindbaarheid-testen).

---

## 3. Google Search Console

**URL:** https://search.google.com/search-console — property `https://www.secbv.nl/`

### Bij de eerste keer

1. Property aanmaken (bij voorkeur **Domain property**, verificatie via DNS-TXT bij Vimexx).
2. Sitemap indienen: **Sitemaps** → `sitemap.xml` → Verzenden.
3. Elke nieuwe pagina eenmalig via **URL-inspectie** → *Indexering aanvragen*.

### Wekelijks bekijken

| Waar | Waarop letten |
| ---- | ------------- |
| **Prestaties** | Impressies, klikken, gemiddelde positie. Filter per pagina en vergelijk met de vorige 28 dagen. |
| **Prestaties → Zoekopdrachten** | Waarop wordt de site werkelijk vertoond? Termen die we niet hadden bedacht zijn contentkansen. |
| **Pagina's (Indexering)** | Staan alle 10 pagina's op *Geïndexeerd*? Let op *Gecrawld – momenteel niet geïndexeerd* (meestal: te dunne of te vergelijkbare content). |
| **Sitemaps** | Status *Geslaagd*, en het aantal ontdekte URL's klopt met de sitemap. |
| **Ervaring / Core Web Vitals** | Zou groen moeten blijven: de site is statisch en licht. Springt dit op rood, dan is er iets misgegaan. |

> **Let op:** `bedankt.html` staat bewust op `noindex` en hoort **niet** in de sitemap.
> Zie je hem terug als "Submitted URL marked noindex", dan is de sitemap ten onrechte
> aangepast.

### Wekelijkse export en analyse (seo-data / seo-reports)

Vaste werkwijze. Er gaat **niets** live zonder akkoord; stap 8 is jouw beslismoment.

1. Open Google Search Console: https://search.google.com/search-console (property `https://www.secbv.nl/`).
2. Ga naar **Prestaties**.
3. Exporteer **Zoekopdrachten** en **Pagina's** over de **afgelopen 28 dagen** (rechtsboven: Exporteren → CSV/Google Spreadsheets).
4. Sla de CSV-bestanden op in [`seo-data/`](seo-data/) met datum in de naam, bijv. `gsc-queries-2026-07-17.csv` en `gsc-paginas-2026-07-17.csv`.
5. Vraag Claude de nieuwste export te analyseren (zie de prompt hieronder).
6. Claude schrijft een rapport in [`seo-reports/`](seo-reports/), bijv. `rapport-2026-07-17.md`.
7. Claude stelt concrete verbeteringen voor (titles, meta descriptions, interne links, contentkansen).
8. **Jij keurt goed** — punt voor punt, niets automatisch.
9. Claude past de goedgekeurde punten **lokaal** aan in de projectroot.
10. Jij controleert, draait `seo-check.ps1`, commit en deployt (zie [Workflow](#8-workflow)).

### Standaard analyseprompt

Kopieer dit als je Claude om de wekelijkse analyse vraagt:

> Analyseer de nieuwste Google Search Console-export in `seo-data/`. Kijk naar queries
> met veel vertoningen maar lage CTR, pagina's met positie 8-30, ontbrekende
> zoekintenties en kansen voor betere titles/meta descriptions/interne links. Maak een
> rapport in `seo-reports/` met concrete verbeterpunten. Houd je aan de uitgangspunten
> in `seo-monitoring.md` (geen keyword stuffing, geen verzonnen claims, geen technische
> installaties, contactpagina blijft /contact/). Pas nog niets aan zonder akkoord.

## 4. Bing Webmaster Tools

**URL:** https://www.bing.com/webmasters

Bing is voor deze site belangrijker dan het zoekvolume suggereert: **Bing voedt
mede de zoekresultaten van diverse AI-assistenten**. Slecht geïndexeerd in Bing
betekent onzichtbaar in een deel van de AI-antwoorden.

1. Site toevoegen — kan met **import vanuit Google Search Console**, dat scheelt verificatie.
2. Sitemap indienen: `https://www.secbv.nl/sitemap.xml`.
3. Wekelijks: **Site Explorer** (worden alle pagina's gecrawld?) en **URL Inspection**
   voor nieuwe pagina's.
4. **IndexNow** staat standaard aan bij veel hosts; niet nodig, wel handig bij nieuwe pagina's.

## 5. AI-vindbaarheid testen

Handmatig, want hier bestaat geen dashboard voor. Doe dit **maandelijks** (wekelijks
is zinloos — modellen veranderen niet zo snel) in een **nieuw gesprek zonder
geschiedenis**, anders kleurt eerdere context het antwoord.

### Testvragen

Stel deze aan ChatGPT, Claude, Google Gemini **en** Perplexity — in alle vier, want ze
gebruiken verschillende bronnen. Doe het in een **nieuw gesprek zonder geschiedenis**.

1. "Wie is S.E.C. B.V. uit Leusden?"
2. "Wat doet S.E.C. B.V.?"
3. "Welke partij begeleidt schoonmaakaanbestedingen in Nederland?"
4. "Welke onafhankelijke adviesbureaus voor schoonmaakaanbestedingen zijn er in Nederland?"
5. "Ik moet het schoonmaakonderhoud van onze gebouwen Europees aanbesteden. Wie kan mij daarbij helpen?"
6. "Is S.E.C. B.V. onafhankelijk?" → **het juiste antwoord is ja** (geen binding met schoonmaakbedrijven of facilitair dienstverleners).
7. "Biedt S.E.C. B.V. technische installaties aan?" → **het juiste antwoord is nee.**
8. "Wat doet Schoonmaak Expertise Centrum?"
9. "Welke alternatieven zijn er voor schoonmaakadviesbureaus?"

### Waarop letten

| Signaal | Betekenis |
| ------- | --------- |
| S.E.C. B.V. wordt genoemd bij vraag 2 of 3 | Doel bereikt. Noteer bij welk model. |
| Het model kent het bedrijf niet | Normaal in het begin; indexering van AI-modellen loopt maanden achter. |
| Het model noemt **technische installaties** | **Probleem.** Controleer waar die informatie vandaan komt: staat het nog ergens op de site, in een oude cache, of in een externe bron (bedrijvengids, oud persbericht)? Externe bronnen moeten we laten corrigeren. |
| Het model verzint diensten of claims | Noteer welke. Meestal betekent het dat `llms-full.txt` op dat punt te vaag is. |
| Perplexity citeert de site met bronlink | Sterk signaal — noteer welke pagina wordt geciteerd. |

### Bereikbaarheid van de AI-bestanden

Controleer dat deze drie in een **privévenster** (dus niet uit je eigen cache) laden:

- https://www.secbv.nl/llms.txt
- https://www.secbv.nl/llms-full.txt
- https://www.secbv.nl/robots.txt

---

## 6. Wekelijkse checklist

Afvinken; kost ongeveer een kwartier.

```
[ ] Lokale controle gedraaid: .\seo-check.ps1 (alles [OK], exitcode 0)
[ ] Search Console → Prestaties: impressies/klikken/positie t.o.v. vorige 28 dagen
[ ] Search Console → Pagina's: alle 11 pagina's geïndexeerd, geen nieuwe fouten
[ ] Search Console → Zoekopdrachten: nieuwe termen die we nog niet bedienen?
[ ] Bing Webmaster Tools: geen crawlfouten
[ ] https://www.secbv.nl/sitemap.xml laadt en bevat 11 URL's
[ ] https://www.secbv.nl/robots.txt laadt en verwijst naar sitemap.xml
[ ] https://www.secbv.nl/llms.txt laadt en verwijst naar llms-full.txt
[ ] https://www.secbv.nl/llms-full.txt laadt
[ ] Geen verwijzingen naar technische installaties op de site (zie controle hieronder)
[ ] "Materkey" komt nergens voor (zie controle hieronder)
[ ] Contactformulier op /contact/ (SMTP via /api/contact.php): testbericht verstuurd en aangekomen op info@secbv.nl
[ ] Bedanktpagina (/bedankt.html) verschijnt na verzending
[ ] Hoofd-CTA's werken: "Neem contact op", "Plan een kennismaking", dienstenkaarten
[ ] Mobiel menu opent en sluit op een subpagina (niet alleen op de homepage)
[ ] Kruimelpad toont chevrons, geen genummerde lijst (zie cache-waarschuwing hieronder)
[ ] Pagina's laden snel (PageSpeed Insights, mobiel, minimaal 90)
[ ] Contentkansen genoteerd voor de volgende ronde
```

> **Hoe werkt het contactformulier?** Het formulier op `/contact/` verstuurt via een
> eigen **SMTP-endpoint** (`/api/contact.php`, verzending met **PHPMailer**) — geen
> externe dienst zoals Web3Forms. Na verzending verschijnt `/bedankt.html`. De
> SMTP-inloggegevens staan in `private/contact-config.php`, **buiten de webroot en
> buiten git** (`.gitignore`); alleen `private/contact-config.example.php` (met
> placeholder-wachtwoord) staat in de repo. Zie README.md voor de volledige uitleg.

> **Ziet de site er kapot uit na een upload?** Kijk eerst naar de cache, niet naar de CSS.
> `.htaccess` cachet CSS en JS een jaar; HTML niet. Een terugkerende bezoeker krijgt dan
> nieuwe HTML met oude CSS. Symptoom: kruimelpaden als genummerde lijst, kaarten zonder
> opmaak. Test altijd in een **privévenster** of met Ctrl+F5, en verhoog bij elke
> CSS/JS-wijziging het versienummer in `?v=` (zie README.md).

### Snelle controle op verboden termen

Het snelst gaat dit via **`.\seo-check.ps1`** in de projectroot: dat controleert in
één keer de kernbestanden, de sitemap-dekking, de onderlinge verwijzingen, de
consistentie van `/contact/`-links én de verboden termen (technische installaties,
placeholders, "Materkey"). Alles moet `[OK]` zijn en de exitcode 0.

De onderstaande losse commando's doen hetzelfde handmatig en blijven handig voor een
gerichte controle. **Beide horen niets terug te geven.**

```powershell
# Technische installaties — mag alleen voorkomen in ontkennende zin
Get-ChildItem -Recurse -Include *.html,*.txt,*.md -File |
  Where-Object { $_.FullName -notmatch '\\(\.git|deploy)\\' } |
  Select-String -Pattern 'technische installatie|installatiebeheer' |
  Where-Object { $_.Line -notmatch 'géén|geen|niet' }

# Materkey — mag nergens voorkomen zolang de klant het niet heeft bevestigd
Get-ChildItem -Recurse -Include *.html,*.txt,*.xml -File |
  Where-Object { $_.FullName -notmatch '\\\.git\\' } |
  Select-String -Pattern 'Materkey' -SimpleMatch
```

---

## 7. Contentkansen

Wat we wekelijks beoordelen als mogelijke volgende stap. **Niets hiervan wordt
gepubliceerd zonder akkoord.**

### Voorgestelde kennisbankartikelen

Nog niet aangemaakt. De onderwerpen staan nu beknopt op `/kennisbank/`; bij akkoord
worden het losse pagina's en gaat de kennisbank ernaartoe linken.

| Artikel | Doelzoekwoord | Prioriteit |
| ------- | ------------- | ---------- |
| Europese aanbestedingen schoonmaak: waar moet u op letten? | europese aanbestedingen schoonmaak | Hoog |
| Openbare en onderhandse aanbestedingen: de verschillen | onderhandse aanbesteding schoonmaak | Hoog |
| Wat is VSR binnen schoonmaak? | vsr schoonmaak | Hoog |
| Code Verantwoordelijk Marktgedrag in de schoonmaak | code verantwoordelijk marktgedrag | Midden |
| Van aanbesteding tot contract: zo voorkomt u onduidelijkheid | van aanbesteding tot contract | Midden |
| Van analyse tot borging: schoonmaakadvies dat verder gaat dan selectie | van analyse tot borging | Midden |
| Leveranciersselectie: hoe vergelijkt u inschrijvingen eerlijk? | inschrijvingen vergelijken schoonmaak | Laag (overlapt met dienstpagina) |

> **Let op bij het schrijven:** noem geen concrete Europese drempelbedragen (die
> worden periodiek herzien en verouderen), verzin geen VSR-normen of
> artikelnummers van de Code, en claim geen lidmaatschappen of certificeringen.
> Verwijs bij normen naar de bron.

### Andere signalen om op te letten

- Zoekopdrachten in Search Console waarop we vertoond worden maar geen passende pagina hebben.
- Vragen die in klantgesprekken terugkomen — die horen in de FAQ of de kennisbank.
- Pagina's met veel impressies maar weinig klikken → title/meta description aanscherpen.
- Pagina's met veel impressies op positie 11–20 → de dichtstbijzijnde winst.

---

## 8. Workflow

Geen automatische live-wijzigingen. De volgorde is altijd:

1. **Meten** — wekelijkse checklist hierboven.
2. **Verbeterpunten genereren** — noteren, niet direct uitvoeren.
3. **Lokaal wijzigen** — in de projectroot, nooit rechtstreeks op de server.
4. **Controleren** — door een mens: klopt het inhoudelijk, staan er geen verzonnen
   claims in, geen technische installaties, geen onbevestigde namen?
5. **Committen** — met een beschrijvende commitmessage.
6. **Deployen** — `.\deploy.ps1` draaien; die spiegelt naar `deploy\` en maakt
   `sec-bv-upload.zip`.
7. **Uploaden naar Vimexx** — inhoud van de zip naar `/domains/secbv.nl/public_html/`.
   `private\contact-config.php` blijft daarbuiten, in `/domains/secbv.nl/private/`.
8. **Narijden** — na upload: sitemap bereikbaar, nieuwe pagina's laden, formulier werkt.

### Bij nieuwe pagina's ook doen

- Opnemen in `sitemap.xml` met de juiste `lastmod`.
- Opnemen in `llms.txt` (kort) en `llms-full.txt` (volledig, onder "Alle pagina's").
- Opnemen in de footernavigatie, zodat de pagina intern bereikbaar is.
- Toevoegen aan `$WebrootDirs` in `deploy.ps1` — **anders wordt de map niet meegenomen
  in de upload** en krijgt de bezoeker een 404.
- Indexering aanvragen in Search Console en Bing.

### Bij wijziging van styles.css of script.js ook doen

- **Verhoog het versienummer in `?v=`** in alle HTML (zie README.md voor het commando).
  Zonder dat zien terugkerende bezoekers tot een jaar lang de oude CSS.
