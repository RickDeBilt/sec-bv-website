<#
.SYNOPSIS
    Bouwt de deploy-map en het uploadpakket voor S.E.C. B.V.

.DESCRIPTION
    Spiegelt de webroot-bestanden vanuit de projectroot naar .\deploy en maakt
    daarvan sec-bv-upload.zip. Werkt met een expliciete whitelist: alles wat niet
    in $WebrootItems staat, komt NIET in de webroot terecht.

    Dit is bewust een whitelist en geen "kopieer alles behalve...". De map private\
    bevat de SMTP-inloggegevens en hoort buiten de webroot te blijven; bij een
    blacklist zou een nieuw bestand er per ongeluk in kunnen glippen.

.EXAMPLE
    .\deploy.ps1
    .\deploy.ps1 -SkipZip
#>

#
# LET OP: houd dit bestand ASCII-only (geen em-dashes, geen accenten).
# Windows PowerShell 5.1 leest een .ps1 zonder BOM als Windows-1252. Een UTF-8
# em-dash valt dan uiteen in bytes waarvan de laatste een typografisch
# aanhalingsteken is; PowerShell accepteert dat als string-delimiter en het hele
# script erna wordt onparseerbaar.
#

[CmdletBinding()]
param(
    [switch]$SkipZip
)

$ErrorActionPreference = 'Stop'

$Root      = $PSScriptRoot
$DeployDir = Join-Path $Root 'deploy'
$ZipPath   = Join-Path $Root 'sec-bv-upload.zip'

# --- Wat hoort er in de webroot? -------------------------------------------
# Losse bestanden
$WebrootFiles = @(
    'index.html',
    'bedankt.html',
    'styles.css',
    'script.js',
    'robots.txt',
    'sitemap.xml',
    'llms.txt',
    'llms-full.txt',
    '.htaccess'
)

# Mappen (inclusief de SEO-landingspagina's)
$WebrootDirs = @(
    'assets',
    'api',
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

# Nooit meenemen, ook niet als ze binnen een map hierboven zouden staan.
$ForbiddenNames = @('contact-config.php')

Write-Host "S.E.C. B.V. - deploy" -ForegroundColor Cyan
Write-Host "Projectroot: $Root"

# --- 1. Controleer of alles bestaat ----------------------------------------
$missing = @()
foreach ($f in $WebrootFiles) {
    if (-not (Test-Path (Join-Path $Root $f))) { $missing += $f }
}
foreach ($d in $WebrootDirs) {
    if (-not (Test-Path (Join-Path $Root $d))) { $missing += "$d\" }
}
if ($missing.Count -gt 0) {
    Write-Host ''
    Write-Host 'Ontbrekende bestanden of mappen:' -ForegroundColor Red
    $missing | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    throw 'Deploy afgebroken: niet alles is aanwezig.'
}

# --- 2. Deploy-map leegmaken -----------------------------------------------
if (Test-Path $DeployDir) {
    Write-Host 'Deploy-map opschonen...'
    Get-ChildItem -Path $DeployDir -Force | Remove-Item -Recurse -Force -Confirm:$false
} else {
    New-Item -ItemType Directory -Path $DeployDir | Out-Null
}

# --- 3. Kopieren ------------------------------------------------------------
Write-Host 'Bestanden kopieren...'
foreach ($f in $WebrootFiles) {
    Copy-Item -Path (Join-Path $Root $f) -Destination $DeployDir -Force
}
foreach ($d in $WebrootDirs) {
    Copy-Item -Path (Join-Path $Root $d) -Destination $DeployDir -Recurse -Force
}

# --- 4. Veiligheidscontrole -------------------------------------------------
# private\ mag er nooit in zitten, en het configbestand met wachtwoorden ook niet.
if (Test-Path (Join-Path $DeployDir 'private')) {
    throw 'AFGEBROKEN: private\ staat in de deploy-map. Dit hoort buiten de webroot.'
}
foreach ($name in $ForbiddenNames) {
    $hits = Get-ChildItem -Path $DeployDir -Recurse -Force -Filter $name -ErrorAction SilentlyContinue
    if ($hits) {
        $hits | ForEach-Object { Write-Host "  gevonden: $($_.FullName)" -ForegroundColor Red }
        throw "AFGEBROKEN: '$name' hoort niet in de webroot."
    }
}

$fileCount = (Get-ChildItem -Path $DeployDir -Recurse -File -Force | Measure-Object).Count
Write-Host "Deploy-map klaar: $fileCount bestanden." -ForegroundColor Green

# --- 5. Zippen --------------------------------------------------------------
if ($SkipZip) {
    Write-Host 'Zip overgeslagen (-SkipZip).'
} else {
    Write-Host 'Uploadpakket maken...'
    if (Test-Path $ZipPath) { Remove-Item $ZipPath -Force -Confirm:$false }

    # De zip wordt handmatig opgebouwd. Dat is geen omslachtigheid maar noodzaak:
    #
    #   - Compress-Archive met een wildcard-pad (deploy\*) slaat verborgen bestanden
    #     over, waardoor .htaccess stilzwijgend buiten de zip valt.
    #   - Zowel Compress-Archive als ZipFile::CreateFromDirectory schrijven op
    #     Windows PowerShell 5.1 (.NET Framework) BACKSLASHES als padscheiding in de
    #     zip-entries. De ZIP-specificatie eist forward slashes. Een Linux-uitpakker
    #     (zoals die van DirectAdmin bij Vimexx) maakt van "api\contact.php" dan een
    #     bestand met backslashes in de naam in plaats van de map api\. Resultaat:
    #     geen api-map, geen pagina-mappen, een kapotte site.
    #
    # CreateEntryFromFile met een zelf genormaliseerde entry-naam doet het wel goed.
    # Twee assemblies: ZipArchive/ZipArchiveMode zitten in System.IO.Compression,
    # ZipFile/ZipFileExtensions in System.IO.Compression.FileSystem.
    Add-Type -AssemblyName System.IO.Compression
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $level  = [System.IO.Compression.CompressionLevel]::Optimal
    $prefix = $DeployDir.TrimEnd('\') + '\'

    $stream  = [System.IO.File]::Open($ZipPath, [System.IO.FileMode]::Create)
    $archive = New-Object System.IO.Compression.ZipArchive($stream, [System.IO.Compression.ZipArchiveMode]::Create)
    try {
        foreach ($file in (Get-ChildItem -Path $DeployDir -Recurse -File -Force)) {
            $entryName = $file.FullName.Substring($prefix.Length).Replace('\', '/')
            [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
                $archive, $file.FullName, $entryName, $level) | Out-Null
        }
    }
    finally {
        $archive.Dispose()
        $stream.Dispose()
    }

    # Controleer dat er geen backslash-entries in de zip staan.
    $archive = [System.IO.Compression.ZipFile]::OpenRead($ZipPath)
    $badEntries = @($archive.Entries | Where-Object { $_.FullName -like '*\*' } | ForEach-Object { $_.FullName })
    $entryCount = $archive.Entries.Count
    $archive.Dispose()
    if ($badEntries.Count -gt 0) {
        $badEntries | ForEach-Object { Write-Host "  fout pad: $_" -ForegroundColor Red }
        throw 'AFGEBROKEN: de zip bevat backslash-paden en pakt op de server verkeerd uit.'
    }

    $sizeKb = [math]::Round((Get-Item $ZipPath).Length / 1KB)
    Write-Host "Klaar: sec-bv-upload.zip ($entryCount entries, $sizeKb KB)" -ForegroundColor Green
}

Write-Host ''
Write-Host 'Volgende stap: upload de INHOUD van de zip naar /domains/secbv.nl/public_html/'
Write-Host 'Let op: private\contact-config.php staat los en hoort in /domains/secbv.nl/private/'
