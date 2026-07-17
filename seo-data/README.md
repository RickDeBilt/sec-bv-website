# seo-data/

Ruwe exports uit Google Search Console en Bing Webmaster Tools.

## Wat hier hoort

- CSV-exports uit **Search Console → Prestaties** (queries en pagina's, laatste 28 dagen).
- Eventuele exports uit **Bing Webmaster Tools**.

## Naamgeving

Gebruik een datum en de bron, zodat rapporten reproduceerbaar blijven:

```
gsc-queries-2026-07-17.csv
gsc-paginas-2026-07-17.csv
bing-queries-2026-07-17.csv
```

## Werkwijze

De volledige wekelijkse werkwijze staat in [`../seo-monitoring.md`](../seo-monitoring.md),
sectie "Google Search Console → Wekelijkse export en analyse". Kort: exporteer hier,
laat Claude analyseren, het rapport verschijnt in [`../seo-reports/`](../seo-reports/).

> Deze map staat wel in git, de exports zelf zijn klein en tekstueel. Zet er geen
> persoonsgegevens of vertrouwelijke klantdata in.
