# This script stores the data to a file

param (
    [string]$dataToStore,
    [string]$saveFilePath
)

Write-Host "Data to store: $dataToStore"
Write-Host "Save file path: $saveFilePath"

# Save the variable value to the text file
$dataToStore | Out-File -FilePath $saveFilePath