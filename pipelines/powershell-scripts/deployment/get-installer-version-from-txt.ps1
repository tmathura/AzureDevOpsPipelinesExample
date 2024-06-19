# This script reads the content of a text file and sets the content as a variable in the pipeline - Installer_Version_Number.

param (
    [string]$filePath
)

Write-Host "File path: $filePath"

$fileContent = Get-Content -Path $filePath -Raw

Write-Output $fileContent

Write-Host "##vso[task.setvariable variable=Installer_Version_Number;]$fileContent"