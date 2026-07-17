# SEO-statuscheck S.E.C. B.V. — 2026-07-17

**Scope:** lokale projectroot + live-URL's op https://www.secbv.nl/. Er is bij deze
check niets aan de site gewijzigd.

## Checklist-resultaat

| # | Controle | Lokaal | Live | Oordeel |
|---|----------|--------|------|---------|
| 1 | Alle SEO-pagina's bestaan (11) | 9 mappen + home + contact | alle 11 -> HTTP 200 | OK |
| 2 | sitemap.xml bestaat + alle indexeerbare pagina's | 11 URL's, `bedankt.html` correct uitgesloten (noindex) | 200 (2048 b) | OK |
| 3 | robots.txt -> sitemap.xml | verwijst correct | 200 (418 b) | OK |
| 4 | llms.txt + llms-full.txt bereikbaar | llms.txt -> llms-full.txt | beide 200 (3538 / 7691 b) | OK |
| 5 | Interne links werken | consistent | alle nav/footer-doelen + `/assets/logo` -> 200 | OK (zie noot) |
| 6 | Contactlinks -> /contact/ | ja | ja | OK |
| 7 | Web3Forms in contactformulier | niet aanwezig | niet aanwezig | Afwijking (zie sectie 4) |
| 8 | Geen (bevestigende) technische installaties | alleen ontkennend | idem | OK |
| 9 | Breadcrumbs niet als genummerde lijst | `<ol>` + CSS-chevrons | `?v=3` laadt (200) | OK |
| 10 | deploy.ps1 neemt alle bestanden mee | 24 entries, 12 mappen + 9 losse | n.v.t. | OK |

> **Noot bij #5:** alle 11 pagina's + het logo zijn op HTTP 200 geverifieerd. Losse
> anker-links binnen de kennisbank (`#vsr`, `#procedurevormen`,
> `#code-verantwoordelijk-marktgedrag`) zijn niet individueel getest; die vallen binnen
> bestaande pagina's die live staan.

**Uitkomst:** lokaal 36/36 checks `[OK]` (seo-check.ps1, exitcode 0), live 16/16 URL's
op HTTP 200. Eén afwijking t.o.v. de oude aanname (Web3Forms), verder alles groen.

## Live-status en sync

Live en lokaal zijn in sync: de byte-groottes van `sitemap.xml`, `robots.txt`,
`llms.txt`, `llms-full.txt` en `styles.css` komen exact overeen met de lokale bestanden.

- 11 pagina's + `bedankt.html` + de 4 SEO-bestanden: alle HTTP 200.
- `styles.css?v=3` / `script.js?v=3`: cache-busting actief; breadcrumb rendert live als
  chevrons (`<ol>` met `list-style:none` en `::after "›"`).
- Contactformulier verstuurt via **SMTP** (`/api/contact.php` -> PHPMailer), niet Web3Forms.

## 1. Wat is ingericht?

- `seo-check.ps1` — lokaal, alleen-lezen controlescript (8 groepen, 36 checks).
- `seo-monitoring.md` — zoekwoord/pagina-mapping, GSC/Bing-werkwijze, 10-stappen
  wekelijkse exportflow, standaard analyseprompt, AI-testvragen, wekelijkse checklist.
- `seo-data/` en `seo-reports/` — mappen voor GSC-exports resp. analyse-rapporten.
- `deploy.ps1` — whitelist-gebaseerd uploadpakket (24 webrootbestanden); `private/`,
  workflow-bestanden en `deploy/` blijven er bewust buiten.
- AI-vindbaarheid: `llms.txt` (compact) en `llms-full.txt` (feitelijk).

## 2. Wat staat live?

Alles staat live en is in sync (zie boven). Contactformulier draait op SMTP via
`/api/contact.php` (PHPMailer); bedanktpagina is `/bedankt.html`.

## 3. Wat moet nog gebeuren in Google Search Console?

Niet vanaf hier te controleren (geen accounttoegang). Na te lopen:

1. Property geverifieerd? Bij voorkeur Domain-property `secbv.nl` via DNS-TXT bij Vimexx.
2. Sitemap ingediend? Status *Geslaagd*, 11 URL's ontdekt.
3. Indexering aangevraagd voor elke pagina via URL-inspectie (eenmalig per pagina).
4. Dekking gecheckt: staan alle 11 op *Geindexeerd*? Let op *Gecrawld - niet geindexeerd*.
5. Bing Webmaster Tools idem (voedt AI-antwoorden) — importeer vanuit GSC.
6. Daarna de wekelijkse export starten: Prestaties -> 28 dagen -> CSV in `seo-data/`.

## 4. Wat eerst oplossen vóór verdere SEO-monitoring?

**Eén punt, en het is een beslissing — geen bug.**

De oude aanname was "contactformulier via Web3Forms". Het formulier is echter bewust
omgezet naar een eigen SMTP-endpoint (`/api/contact.php`, PHPMailer) in commits
`3c9269f` en `53a361b`. Het werkt live (HTTP 200). Er is dus geen kapotte Web3Forms om
te repareren; de documentatie is bijgewerkt naar de huidige situatie.

Geen technische blokkers. Twee openstaande inhoudelijke actiepunten (los van techniek):

- "Materkey" vs "MasterKey" — nog te bevestigen door de klant (staat nergens live).
- Claim "30+ jaar ervaring" op de homepage — feitelijk juist? Laten bevestigen.
