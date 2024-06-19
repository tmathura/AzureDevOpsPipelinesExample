# This script reads the version number from a C# file and sets it as a variable in the Azure DevOps pipeline.

$thisVersionNumber = 0.0.0

# Path to MainConstants.cs
$filePath = '.\Calculator.Core\MainConstants.cs'

# Read the content of the file
$fileContent = Get-Content -Path $filePath -Raw

# Use regex to extract the value of the 'Version' constant
$versionPattern = 'public const string Version = "(.+?)";'
$versionMatch = [regex]::Match($fileContent, $versionPattern)

# Check if a match was found
if ($versionMatch.Success) {
    $versionValue = $versionMatch.Groups[1].Value
    Write-Host "Version value: $versionValue"
}
else {
    Write-Host "Version constant not found in the file."
}

$thisVersionNumber = $versionValue
Write-Host "Current version number: $thisVersionNumber"

Write-Host "##vso[task.setvariable variable=currentVersionNumber;]$thisVersionNumber"