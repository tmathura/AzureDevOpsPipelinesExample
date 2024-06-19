# This script creates a folder for the installer output.

param (
    [string]$installerOutputPath
)

Write-Host "Installer output path: $installerOutputPath"

New-Item -Path $installerOutputPath -ItemType Directory