# Update the core constants in the specified file

param (
    [string]$findString,
    [string]$replaceString,
    [string]$filePath,
    [string]$doReplace,
    [string]$propertyName
)

Write-Host "String to find: $findString"
Write-Host "String to replace with: $replaceString"
Write-Host "File path: $filePath"
Write-Host "Do replace: $doReplace"
Write-Host "Property name: $propertyName"

$findString = $findString -replace "'", '"'
$replaceString = $replaceString -replace "'", '"'

if ($doReplace -eq 'true') {
    # Read the content of the file
    $fileContent = Get-Content -Path $filePath -Raw

    # Update the BuildNumber value
    $updatedFileContent = $fileContent -replace $findString, $replaceString

    # Write the updated content back to the file
    $updatedFileContent | Set-Content -Path $filePath

    Write-Host "$propertyName was replaced"
}
else {
    Write-Host "$propertyName was not replaced"
}