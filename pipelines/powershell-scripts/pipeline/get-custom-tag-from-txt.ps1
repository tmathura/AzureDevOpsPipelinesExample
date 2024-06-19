# This script reads the content of a file and sets it as a variable in the pipeline - currentCustomTag.

param (
    [string]$filePath
)

Write-Host "File path: $filePath"

$fileContent = Get-Content -Path $filePath -Raw

Write-Output $fileContent

Write-Host "##vso[task.setvariable variable=currentCustomTag;]$fileContent"