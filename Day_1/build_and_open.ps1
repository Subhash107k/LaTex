param(
    [string]$TexFile = "Frist_day.tex"
)

$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
Set-Location $scriptDir

if (-not (Test-Path $TexFile)) {
    Write-Error "TeX file '$TexFile' not found in $scriptDir"
    exit 1
}

$baseName = [System.IO.Path]::GetFileNameWithoutExtension($TexFile)
$pdfFile = "$baseName.pdf"

Write-Host "Building $TexFile (pass 1)..."
pdflatex -interaction=nonstopmode $TexFile
if ($LASTEXITCODE -ne 0) {
    Write-Error "pdflatex failed on pass 1 with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

Write-Host "Building $TexFile (pass 2)..."
pdflatex -interaction=nonstopmode $TexFile
if ($LASTEXITCODE -ne 0) {
    Write-Error "pdflatex failed on pass 2 with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

if (Test-Path $pdfFile) {
    Write-Host "Opening $pdfFile..."
    Start-Process -FilePath $pdfFile
} else {
    Write-Error "PDF file '$pdfFile' was not generated."
    exit 1
}
