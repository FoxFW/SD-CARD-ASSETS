# Rebuild the FoxFW SD-card release zips from the (de-duplicated) folders. Run natively on Windows.
# Two independent assets:
#   FoxFW_SD_CARD_ASSETS_core.zip        = every category folder EXCEPT wav_player (and _dl_extra)
#   FoxFW_SD_CARD_ASSETS_wav_player.zip  = the wav_player audio
# core changes most releases; wav_player rarely does - so you can rebuild just one.
#
# Launch either way - both show the menu unless you pass a switch:
#   - right-click rebuild_release_zips.ps1 > Run with PowerShell
#   - terminal, no menu:  .\rebuild_release_zips.ps1 -Core   (or -Music / -Wav, or nothing = both)
param([string]$Root = $PSScriptRoot,[switch]$Core,[switch]$Music,[switch]$Wav)
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
$ErrorActionPreference = "Stop"
$Root = (Resolve-Path -LiteralPath $Root).Path
if ($Wav) { $Music = $true }

# If no selection was passed on the command line, show the menu.
$usedMenu = (-not $Core -and -not $Music)
if ($usedMenu) {
    while ($true) {
        Clear-Host
        Write-Host "=================================================="
        Write-Host "   Rebuild FoxFW SD-card release zips"
        Write-Host "=================================================="
        Write-Host ""
        Write-Host "   [1]  Build BOTH            ( core.zip + wav_player.zip )"
        Write-Host "   [2]  core.zip only         ( usually the only one that changes )"
        Write-Host "   [3]  wav_player.zip only   ( rarely changes )"
        Write-Host "   [Q]  Quit"
        Write-Host ""
        $sel = Read-Host "Type 1, 2, 3 (or Q) and press Enter"
        if     ($sel -eq '1') { $Core = $true; $Music = $true; break }
        elseif ($sel -eq '2') { $Core = $true;                 break }
        elseif ($sel -eq '3') { $Music = $true;                break }
        elseif ($sel -match '^[Qq]$') { return }
        else { Write-Host ""; Write-Host "  '$sel' is not valid - type 1, 2, 3 or Q."; Start-Sleep -Seconds 1 }
    }
}

$LIMIT = 2GB; $TARGET = 1.9GB
$prefix  = "FoxFW_SD_CARD_ASSETS_"
$coreZip = "${prefix}core.zip"
$wavZip  = "${prefix}wav_player.zip"
$exclude = @('wav_player','_dl_extra')   # _dl_extra = unsorted new downloads, not shipped

function New-Zip {
    param([string]$ZipPath,[System.IO.FileInfo[]]$Files,[string]$Base)
    if (Test-Path $ZipPath) { Remove-Item $ZipPath -Force }
    $zip = [System.IO.Compression.ZipFile]::Open($ZipPath,[System.IO.Compression.ZipArchiveMode]::Create)
    try {
        $baseLen = $Base.TrimEnd('\').Length + 1
        foreach ($f in $Files) {
            $entry = $f.FullName.Substring($baseLen).Replace('\','/')
            [void][System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
                $zip,$f.FullName,$entry,[System.IO.Compression.CompressionLevel]::Optimal)
        }
    } finally { $zip.Dispose() }
}
function Report {
    param([string]$name)
    $sz = (Get-Item (Join-Path $Root $name)).Length
    if ($sz -gt $LIMIT) { $f = "  *** OVER 2GB - DO NOT UPLOAD ***" }
    elseif ($sz -gt $TARGET) { $f = "  (OK, near 2GB limit)" } else { $f = "  OK" }
    "{0,-44} {1,8:N0} MB{2}" -f $name, ($sz/1MB), $f
}

Write-Host ""
Write-Host "Root: $Root"
$built = @()
if ($Core) {
    Write-Host "Building $coreZip (everything except wav_player)..."
    $dirs  = Get-ChildItem -LiteralPath $Root -Directory | Where-Object { $_.Name -notin $exclude -and $_.Name -ne '.git' }
    $files = $dirs | ForEach-Object { Get-ChildItem -LiteralPath $_.FullName -Recurse -File }
    New-Zip (Join-Path $Root $coreZip) $files $Root
    $built += $coreZip
}
if ($Music) {
    Write-Host "Building $wavZip (wav_player audio)..."
    $files = Get-ChildItem -LiteralPath (Join-Path $Root 'wav_player') -Recurse -File
    New-Zip (Join-Path $Root $wavZip) $files $Root
    $built += $wavZip
}
Write-Host ""
Write-Host "Built:"
foreach ($n in $built) { Write-Host (Report $n) }
Write-Host ""
Write-Host "Upload the built zip(s) to the Releases page; extract all into the SD-card root to recombine."
if ($usedMenu) { Write-Host ""; [void](Read-Host "Done. Press Enter to close") }
