<#
.SYNOPSIS
    Lokale SEO- en AI-vindbaarheid controle voor S.E.C. B.V.

.DESCRIPTION
    Controleert de projectroot (niet de server) op de vaste voorwaarden voor
    vindbaarheid: bestaan de kernbestanden, verwijzen robots.txt en llms.txt naar
    de juiste vervolgbestanden, staan alle indexeerbare pagina's in de sitemap,
    zijn interne /contact/-links consistent, en staan er geen verboden termen of
    placeholders in de teksten.

    Dit script LEEST alleen. Het wijzigt niets, commit niets en deployt niets.
    Draai het voor elke commit/deploy en tijdens de wekelijkse SEO-check.

.EXAMPLE
    .\seo-check.ps1
#>

#
# LET OP: houd dit bestand ASCII-only (geen em-dashes, geen accenten).
# Zie de uitleg in deploy.ps1: Windows PowerShell 5.1 leest een .ps1 zonder BOM
# als Windows-1252 en loopt vast op UTF-8 leestekens.
#

[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$Root = $PSScriptRoot

# --- Rapportage-hulp --------------------------------------------------------
$script:Pass = 0
$script:Fail = 0
$script:Warn = 0

function Test-Item {
    param(
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][bool]$Ok,
        [string]$Detail = ''
    )
    if ($Ok) {
        $script:Pass++
        Write-Host ("  [OK]   {0}" -f $Name) -ForegroundColor Green
    } else {
        $script:Fail++
        Write-Host ("  [FOUT] {0}" -f $Name) -ForegroundColor Red
        if ($Detail) { Write-Host ("         {0}" -f $Detail) -ForegroundColor DarkGray }
    }
}

function Warn-Item {
    param(
        [Parameter(Mandatory)][string]$Name,
        [string]$Detail = ''
    )
    $script:Warn++
    Write-Host ("  [LET OP] {0}" -f $Name) -ForegroundColor Yellow
    if ($Detail) { Write-Host ("         {0}" -f $Detail) -ForegroundColor DarkGray }
}

function Section {
    param([Parameter(Mandatory)][string]$Title)
    Write-Host ''
    Write-Host $Title -ForegroundColor Cyan
}

# é als code point, zodat dit bestand ASCII-only blijft (zie kop).
$script:EAcute = [char]0x00E9

# Staat er vlak voor deze positie een ontkenning? Kijkt in een venster terug,
# zodat een zin die over twee regels is afgebroken ("... verzorgt geen\n
# installatiebeheer ...") ook als ontkennend wordt herkend. Accenten worden
# genormaliseerd zodat "geen" en "geen-met-accent" allebei matchen.
function Test-Negated {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)][int]$Index,
        [int]$Window = 90
    )
    $start = [Math]::Max(0, $Index - $Window)
    $ctx = $Text.Substring($start, $Index - $start)
    $ctxNorm = $ctx.Replace($script:EAcute, 'e')
    return ($ctxNorm -match '(?i)\bgeen\b|\bniet\b|\bzonder\b')
}

# --- Vaste verwachtingen ----------------------------------------------------
# Indexeerbare pagina-mappen (komen overeen met de sitemap en met deploy.ps1).
# 'assets' en 'api' zijn geen SEO-pagina's en horen hier bewust niet.
$SeoPageDirs = @(
    'schoonmaak-aanbestedingen',
    'aanbestedingsbegeleiding-schoonmaak',
    'facilitaire-aanbestedingen',
    'schoonmaakadvies',
    'leveranciersselectie-schoonmaak',
    'contractbeheer-schoonmaak',
    'kwaliteitsbeheer-schoonmaak',
    'kennisbank',
    'vergelijk-schoonmaakadviesbureaus'
)

# Losse kernbestanden die moeten bestaan.
$CoreFiles = @(
    'sitemap.xml',
    'robots.txt',
    'llms.txt',
    'llms-full.txt',
    'contact\index.html',
    'bedankt.html',
    'deploy.ps1'
)

# De loc-waarden die in de sitemap moeten staan (root + contact + SEO-pagina's).
$ExpectedLocs = @('https://www.secbv.nl/', 'https://www.secbv.nl/contact/')
foreach ($d in $SeoPageDirs) { $ExpectedLocs += "https://www.secbv.nl/$d/" }

Write-Host ''
Write-Host 'S.E.C. B.V. - SEO- en AI-vindbaarheid controle' -ForegroundColor Cyan
Write-Host ("Projectroot: {0}" -f $Root)

# ===========================================================================
Section '1. Kernbestanden aanwezig'
foreach ($f in $CoreFiles) {
    Test-Item -Name $f -Ok (Test-Path (Join-Path $Root $f))
}

# ===========================================================================
Section '2. SEO-pagina''s aanwezig (map met index.html)'
foreach ($d in $SeoPageDirs) {
    $idx = Join-Path $Root (Join-Path $d 'index.html')
    Test-Item -Name ("{0}\index.html" -f $d) -Ok (Test-Path $idx)
}

# ===========================================================================
Section '3. Onderlinge verwijzingen'

$robotsPath = Join-Path $Root 'robots.txt'
if (Test-Path $robotsPath) {
    $robots = Get-Content $robotsPath -Raw
    Test-Item -Name 'robots.txt verwijst naar sitemap.xml' `
        -Ok ($robots -match 'Sitemap:\s*https?://\S*sitemap\.xml') `
        -Detail 'Verwacht een regel: Sitemap: https://www.secbv.nl/sitemap.xml'
} else {
    Test-Item -Name 'robots.txt verwijst naar sitemap.xml' -Ok $false -Detail 'robots.txt ontbreekt'
}

$llmsPath = Join-Path $Root 'llms.txt'
if (Test-Path $llmsPath) {
    $llms = Get-Content $llmsPath -Raw
    Test-Item -Name 'llms.txt verwijst naar llms-full.txt' `
        -Ok ($llms -match 'llms-full\.txt') `
        -Detail 'Verwacht een verwijzing naar https://www.secbv.nl/llms-full.txt'
} else {
    Test-Item -Name 'llms.txt verwijst naar llms-full.txt' -Ok $false -Detail 'llms.txt ontbreekt'
}

# ===========================================================================
Section '4. Sitemap dekt alle indexeerbare pagina''s'

$sitemapPath = Join-Path $Root 'sitemap.xml'
if (Test-Path $sitemapPath) {
    $sitemap = Get-Content $sitemapPath -Raw
    foreach ($loc in $ExpectedLocs) {
        $needle = "<loc>$loc</loc>"
        Test-Item -Name ("sitemap bevat {0}" -f $loc) `
            -Ok ($sitemap.Contains($needle)) `
            -Detail ("Verwacht exact: {0}" -f $needle)
    }
    # bedankt.html hoort NIET in de sitemap (staat op noindex).
    Test-Item -Name 'sitemap bevat bedankt.html NIET (noindex)' `
        -Ok (-not ($sitemap -match 'bedankt\.html')) `
        -Detail 'bedankt.html staat op noindex en hoort niet in de sitemap.'
} else {
    Test-Item -Name 'sitemap.xml leesbaar' -Ok $false -Detail 'sitemap.xml ontbreekt'
}

# ===========================================================================
# Vanaf hier scannen we tekstbestanden in de root, maar NOOIT deploy\ of .git\
# (dat zou dubbele treffers geven).
function Get-SiteFiles {
    param([string[]]$Include)
    Get-ChildItem -Path $Root -Recurse -File -Include $Include -Force |
        Where-Object { $_.FullName -notmatch '\\(\.git|deploy)\\' }
}

# Alleen bestanden die daadwerkelijk live gaan (webroot). Interne werkdocumenten
# zoals seo-monitoring.md, README.md en de READMEs in seo-data/ en seo-reports/
# bespreken termen als "technische installaties" en "Materkey" bewust en worden
# NIET gedeployd; die horen hier dus niet bij (*.md wordt overgeslagen).
$htmlFiles = @(Get-SiteFiles -Include '*.html')
$liveTextFiles = @(Get-SiteFiles -Include '*.html', '*.txt', '*.xml')

# ===========================================================================
Section '5. Interne /contact/-links consistent'

$badContact = @()
foreach ($file in $htmlFiles) {
    $hits = Select-String -Path $file.FullName -Pattern 'href\s*=\s*["'']([^"'']*contact[^"'']*)["'']' -AllMatches
    foreach ($h in $hits) {
        foreach ($m in $h.Matches) {
            $href = $m.Groups[1].Value
            # Toegestaan: /contact/ , mailto:, #anker naar contact op de pagina zelf,
            # en /api/contact.php (het formulier-endpoint).
            if ($href -match '^(mailto:|#)') { continue }
            if ($href -match '^/api/contact\.php$') { continue }
            # Toegestaan: /contact/ , /contact/#anker , en de canonieke absolute
            # variant https://www.secbv.nl/contact/ (met of zonder anker).
            if ($href -match '^(https://www\.secbv\.nl)?/contact/(#[\w-]+)?$') { continue }
            $rel = $file.FullName.Substring($Root.Length).TrimStart('\')
            $badContact += ("{0}: {1}" -f $rel, $href)
        }
    }
}
if ($badContact.Count -eq 0) {
    Test-Item -Name 'Alle contact-links wijzen naar /contact/ (of mailto/anker)' -Ok $true
} else {
    Test-Item -Name 'Alle contact-links wijzen naar /contact/ (of mailto/anker)' -Ok $false `
        -Detail 'Afwijkende links gevonden:'
    $badContact | Sort-Object -Unique | ForEach-Object {
        Write-Host ("         - {0}" -f $_) -ForegroundColor DarkGray
    }
}

# ===========================================================================
Section '6. Geen verwijzingen naar technische installaties'
# Mag alleen voorkomen in ontkennende zin. We lezen het bestand als geheel, zodat
# een over twee regels afgebroken ontkenning ook meetelt (zie Test-Negated).
$installHits = @()
$rxInstall = [regex]'(?i)technische installatie|installatiebeheer'
foreach ($file in $liveTextFiles) {
    # Expliciet UTF-8: anders leest PowerShell 5.1 een bestand zonder BOM als
    # Windows-1252 en valt "geen-met-accent" uiteen, waardoor de ontkenning niet
    # meer herkend wordt.
    $raw = Get-Content $file.FullName -Raw -Encoding UTF8
    foreach ($m in $rxInstall.Matches($raw)) {
        if (-not (Test-Negated -Text $raw -Index $m.Index)) {
            $rel = $file.FullName.Substring($Root.Length).TrimStart('\')
            $from = [Math]::Max(0, $m.Index - 30)
            $snip = $raw.Substring($from, [Math]::Min(80, $raw.Length - $from)) -replace '\s+', ' '
            $installHits += ("{0}: ...{1}..." -f $rel, $snip.Trim())
        }
    }
}
if ($installHits.Count -eq 0) {
    Test-Item -Name 'Geen bevestigende verwijzing naar technische installaties' -Ok $true
} else {
    Test-Item -Name 'Geen bevestigende verwijzing naar technische installaties' -Ok $false `
        -Detail 'Controleer deze regels (mogen alleen ontkennend voorkomen):'
    $installHits | ForEach-Object { Write-Host ("         - {0}" -f $_) -ForegroundColor DarkGray }
}

# ===========================================================================
Section '7. Geen placeholders of onbevestigde namen'
$placeholderPattern = 'VUL_HIER|TODO|FIXME|Lorem ipsum|XXXXX'
$phHits = @()
foreach ($file in $liveTextFiles) {
    $matches = Select-String -Path $file.FullName -Pattern $placeholderPattern
    foreach ($m in $matches) {
        $rel = $file.FullName.Substring($Root.Length).TrimStart('\')
        $phHits += ("{0}:{1}: {2}" -f $rel, $m.LineNumber, $m.Line.Trim())
    }
}
if ($phHits.Count -eq 0) {
    Test-Item -Name 'Geen placeholders (VUL_HIER, TODO, FIXME, Lorem ipsum)' -Ok $true
} else {
    Test-Item -Name 'Geen placeholders (VUL_HIER, TODO, FIXME, Lorem ipsum)' -Ok $false `
        -Detail 'Placeholders gevonden:'
    $phHits | ForEach-Object { Write-Host ("         - {0}" -f $_) -ForegroundColor DarkGray }
}

# "Materkey" mag nergens live staan zolang de klant het niet heeft bevestigd.
$materHits = @()
foreach ($file in $liveTextFiles) {
    $matches = Select-String -Path $file.FullName -Pattern 'Materkey' -SimpleMatch
    foreach ($m in $matches) {
        $rel = $file.FullName.Substring($Root.Length).TrimStart('\')
        $materHits += ("{0}:{1}" -f $rel, $m.LineNumber)
    }
}
if ($materHits.Count -eq 0) {
    Test-Item -Name '"Materkey" komt nergens voor (onbevestigde naam)' -Ok $true
} else {
    Test-Item -Name '"Materkey" komt nergens voor (onbevestigde naam)' -Ok $false `
        -Detail ('Gevonden in: ' + ($materHits -join ', '))
}

# ===========================================================================
Section '8. Deploy-hygiene'
$gitignorePath = Join-Path $Root '.gitignore'
if (Test-Path $gitignorePath) {
    $gitignore = Get-Content $gitignorePath
    $hasDeploy = ($gitignore | Where-Object { $_.Trim() -match '^deploy/?$' }).Count -gt 0
    $hasZip = ($gitignore | Where-Object { $_.Trim() -match '(\*\.zip|sec-bv-upload\.zip)' }).Count -gt 0
    Test-Item -Name 'deploy/ staat in .gitignore' -Ok $hasDeploy
    Test-Item -Name 'sec-bv-upload.zip / *.zip staat in .gitignore' -Ok $hasZip
} else {
    Test-Item -Name '.gitignore aanwezig' -Ok $false
}

# ===========================================================================
Write-Host ''
Write-Host '===========================================================' -ForegroundColor Cyan
$summary = ("Resultaat: {0} geslaagd, {1} gefaald, {2} aandachtspunten." -f $script:Pass, $script:Fail, $script:Warn)
if ($script:Fail -eq 0) {
    Write-Host $summary -ForegroundColor Green
    Write-Host 'Lokale SEO-controle geslaagd. Veilig om te committen en te deployen.' -ForegroundColor Green
    Write-Host '(Live pas testen na upload; dit script controleert alleen de projectroot.)' -ForegroundColor DarkGray
    exit 0
} else {
    Write-Host $summary -ForegroundColor Red
    Write-Host 'Los de [FOUT]-regels op voordat je commit of deployt.' -ForegroundColor Red
    exit 1
}
