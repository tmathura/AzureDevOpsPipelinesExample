# This script is used to extract the custom tag from the source branch.

param (
    [string]$sourceBranch,
    [string]$versionNumber
)

Write-Host "Source branch: $sourceBranch"
Write-Host "Version number: $versionNumber"

$currentCustomTag = ""
$copyUpdateTxtFile = "true"

if ($sourceBranch -like 'refs/tags/*') {
    # Extract the tag part by replacing the beginning with an empty string
    $tag = $sourceBranch -replace '^refs/tags/', ''

    Write-Host "Tag: $tag"

    if (-not ($tag -match "^v$versionNumber")) {
        Write-Host "##vso[task.LogIssue type=error;]The tag does not match the version number. Expected: $versionNumber. Actual: $tag."
        exit 1
    }

    $versionNumberPrefix = "v$versionNumber-"

    Write-Host "Version number prefix: $versionNumberPrefix"

    if ($tag -match "^$versionNumberPrefix") {
        # Replace $versionNumberPrefix with an empty string and store in a new variable called custom tag
        $customTag = $tag -replace $versionNumberPrefix, ''
        
        Write-Host "Custom tag: $currentCustomTag"

        $currentCustomTag = "-$customTag"
        $copyUpdateTxtFile = "false"
    }
}
else {
    Write-Host "Not using a tag to trigger build"
}

Write-Host "Current custom tag: $currentCustomTag"
Write-Host "Copy update.txt file: $copyUpdateTxtFile"

Write-Host "##vso[task.setvariable variable=CustomTag;]$currentCustomTag"
Write-Host "##vso[task.setvariable variable=CopyUpdateTxtFile;]$copyUpdateTxtFile"