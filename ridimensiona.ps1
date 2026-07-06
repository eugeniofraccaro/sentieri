# ==============================================================
# ridimensiona.ps1 — prepara le foto per il sito
# --------------------------------------------------------------
# Uso: metti le foto piene in  originali\<NomeGita>\  ed esegui
#
#     powershell -ExecutionPolicy Bypass -File .\ridimensiona.ps1
#
# Per ogni foto crea in  media\<NomeGita>\  una versione con lo
# stesso nome, lato lungo max 2560 px e qualità JPEG 82: perfetta
# per il web, ~1-2 MB invece di 20+. Le foto in originali\ non
# vengono mai toccate (e git le ignora: restano solo sul tuo PC).
# Le foto già aggiornate in media\ vengono saltate.
# ==============================================================
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$latoLungo = 2560
$qualita   = 82
$radice    = Split-Path -Parent $MyInvocation.MyCommand.Path
$cartellaOriginali = Join-Path $radice 'originali'
$cartellaMedia     = Join-Path $radice 'media'

if (-not (Test-Path $cartellaOriginali)) {
    Write-Host "Non trovo la cartella 'originali': creala e mettici le foto piene."
    exit 1
}

$codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
         Where-Object { $_.MimeType -eq 'image/jpeg' }
$parametri = New-Object System.Drawing.Imaging.EncoderParameters(1)
$parametri.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
    [System.Drawing.Imaging.Encoder]::Quality, [long]$qualita)

$fatte = 0; $saltate = 0
Get-ChildItem $cartellaOriginali -Recurse -Include '*.jpg','*.jpeg','*.JPG','*.JPEG' | ForEach-Object {
    $sorgente = $_
    $relativa = $sorgente.FullName.Substring($cartellaOriginali.Length).TrimStart('\')
    $destinazione = Join-Path $cartellaMedia $relativa

    if ((Test-Path $destinazione) -and
        (Get-Item $destinazione).LastWriteTime -ge $sorgente.LastWriteTime) {
        $saltate++
        return
    }

    New-Item -ItemType Directory -Force (Split-Path $destinazione -Parent) | Out-Null
    $img = [System.Drawing.Image]::FromFile($sorgente.FullName)
    try {
        # applica l'orientamento EXIF (foto scattate in verticale)
        $idOrientamento = 274
        if ($img.PropertyIdList -contains $idOrientamento) {
            switch ($img.GetPropertyItem($idOrientamento).Value[0]) {
                3 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate180FlipNone) }
                6 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate90FlipNone) }
                8 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate270FlipNone) }
            }
        }

        $scala = [math]::Min(1.0, [double]$latoLungo / [double][math]::Max($img.Width, $img.Height))
        $larghezza = [int]($img.Width * $scala)
        $altezza   = [int]($img.Height * $scala)

        $ridotta = New-Object System.Drawing.Bitmap($larghezza, $altezza)
        try {
            $g = [System.Drawing.Graphics]::FromImage($ridotta)
            $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
            $g.DrawImage($img, 0, 0, $larghezza, $altezza)
            $g.Dispose()
            $ridotta.Save($destinazione, $codec, $parametri)
        } finally { $ridotta.Dispose() }
    } finally { $img.Dispose() }

    $mb = [math]::Round((Get-Item $destinazione).Length / 1MB, 1)
    Write-Host "creata  $relativa  ($mb MB)"
    $fatte++
}
Write-Host "Fine: $fatte foto create/aggiornate, $saltate gia' a posto."
Write-Host "Ora: git add -A; git commit -m `"...`"; git push"
