param(
    [Parameter(Mandatory = $true)]
    [string]$FeatureSource
)

Add-Type -AssemblyName System.Drawing

$outputDir = Join-Path $PSScriptRoot '..\assets\store'
$outputDir = [System.IO.Path]::GetFullPath($outputDir)
New-Item -ItemType Directory -Path $outputDir -Force | Out-Null

$icon = [System.Drawing.Bitmap]::new(512, 512, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$graphics = [System.Drawing.Graphics]::FromImage($icon)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.Clear([System.Drawing.Color]::FromArgb(33, 150, 243))
$whitePen = [System.Drawing.Pen]::new([System.Drawing.Color]::White, 26)
$whitePen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$whitePen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$graphics.DrawEllipse($whitePen, 113, 113, 286, 286)
$graphics.DrawEllipse($whitePen, 173, 173, 166, 166)
$graphics.DrawLine($whitePen, 113, 331, 72, 372)
$graphics.DrawLine($whitePen, 399, 181, 440, 140)
$icon.Save((Join-Path $outputDir 'play-icon.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$whitePen.Dispose()
$graphics.Dispose()
$icon.Dispose()

$source = [System.Drawing.Image]::FromFile([System.IO.Path]::GetFullPath($FeatureSource))
$feature = [System.Drawing.Bitmap]::new(1024, 500, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$featureGraphics = [System.Drawing.Graphics]::FromImage($feature)
$featureGraphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$featureGraphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$featureGraphics.DrawImage($source, 0, 0, 1024, 500)
$feature.Save((Join-Path $outputDir 'feature-graphic.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$featureGraphics.Dispose()
$feature.Dispose()
$source.Dispose()
