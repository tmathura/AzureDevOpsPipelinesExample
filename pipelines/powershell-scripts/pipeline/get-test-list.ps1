# This script is used to get the list of test projects in the source folder

param (
    [string]$sourceFolder
)

Write-Host "Source folder: $sourceFolder"

# Recursively search for files matching *tests.csproj in the root folder
$testProjectsFiles = Get-ChildItem -Path $sourceFolder -Filter '*tests.csproj' -Recurse

# Separate the projects containing "integration" from others
$integrationProjects = [ordered]@{}
$otherProjects = [ordered]@{}

# Loop through each file found
foreach ($file in $testProjectsFiles) {
    # Get the directory name (project name)
    $projectName = $file.Directory.Name
    # Check if the file name contains "integration"
    if ($file.Name -like '*integration*') {
        $integrationProjects[$projectName] = @{ 'TestProjectName' = $file.BaseName }
    }
    else {
        $otherProjects[$projectName] = @{ 'TestProjectName' = $file.BaseName }
    }
}

# Combine integration projects first, then other projects
$combinedProjects = $integrationProjects + $otherProjects

# Convert the combined projects to JSON with compression to make it one line
$json = $combinedProjects | ConvertTo-Json -Depth 100 -Compress

# Set the variable for later use
Write-Host "Test params: $json"
Write-Host "##vso[task.setvariable variable=testList;isOutput=true]$json"