# This script generates the publish list for the new installers to be created

param (
    [string]$pipelineWorkSpace,
    [string]$cyclesCommaSeparated,
    [string]$installerUpdateTxtUrl,
    [string]$installerUpdateMsiUrl,
    [string]$autoUpdaterInstallerProjectFilename,
    [string]$standAloneInstallerProjectFilename,
    [string]$updateTextFileName,
    [string]$updateSelfServeTextFileName,
    [string]$advancedInstallerBuildName,
    [string]$certificateFilename,
    [string]$advancedInstallerBuildParamsFilename,
    [string]$updatesProjectFolder,
    [string]$updatesProjectFilename,
    [string]$autoupdater_installer_params,
    [string]$autoupdater_selfserve_installer_params,
    [string]$standalone_installer_params,
    [string]$standalone_selfserve_installer_params
)

Write-Host "Pipeline workSpace: $pipelineWorkSpace"
Write-Host "Cycles comma separated: $cyclesCommaSeparated"
Write-Host "Installer update txt url: $installerUpdateTxtUrl"
Write-Host "Installer update msi url: $installerUpdateMsiUrl"
Write-Host "Auto updater installer project filename: $autoUpdaterInstallerProjectFilename"
Write-Host "Stand alone installer project filename: $standAloneInstallerProjectFilename"
Write-Host "Update text filename: $updateTextFileName"
Write-Host "Update self serve text filename: $updateSelfServeTextFileName"
Write-Host "Advanced installer build name: $advancedInstallerBuildName"
Write-Host "Certificate filename: $certificateFilename"
Write-Host "Advanced installer build params filename: $advancedInstallerBuildParamsFilename"
Write-Host "Updates project folder: $updatesProjectFolder"
Write-Host "Updates project filename: $updatesProjectFilename"
Write-Host "Autoupdater installer params: $autoupdater_installer_params"
Write-Host "Autoupdater selfserve installer params: $autoupdater_selfserve_installer_params"
Write-Host "Standalone installer params: $standalone_installer_params"
Write-Host "Standalone selfserve installer param: $standalone_selfserve_installer_param"

function GenerateInstallerParams {
    param (
        [string]$cycle,
        [string]$installer_params
    )

    Write-Host "Cycle: $cycle"
    Write-Host "Installer params: $installer_params"

    $this_installer_params = $installer_params

    $this_installer_params = $this_installer_params -replace '\\', '\\\\'

    # Convert string to PowerShell object
    $paramsObject = $this_installer_params | ConvertFrom-Json

    # Replace '{specify_installer_type}' with value of 'InstallerType' in InstallerOutputPath
    $paramsObject.InstallerOutputPath = $paramsObject.InstallerOutputPath -replace '\{specify_installer_type\}', $paramsObject.InstallerType

    if ($paramsObject.IsAutoUpdater) {
        $paramsObject.InstallerUpdateTxtUrl = $installerUpdateTxtUrl
        $paramsObject.InstallerUpdateMsiUrl = $installerUpdateMsiUrl
        $paramsObject.InstallerProjectPath = "{source}\\$autoUpdaterInstallerProjectFilename"
        $paramsObject.UpdatesProjectFolder = "{source}\\$updatesProjectFolder"
        $paramsObject.UpdatesProjectPath = "{source}\\$updatesProjectFilename"

        if ($paramsObject.IsSelfServe) {
            $paramsObject.UpdateTextFileName = $updateSelfServeTextFileName
        }
        else {
            $paramsObject.UpdateTextFileName = $updateTextFileName
        }
    }
    else {
        $paramsObject.InstallerProjectPath = "{source}\\$standAloneInstallerProjectFilename"
    }

    # Convert back to JSON string
    $this_installer_params = $paramsObject | ConvertTo-Json -Depth 100 -Compress

    $this_installer_params = $this_installer_params -replace '\\\\', '\'

    #Replace cycle
    $this_installer_params = $this_installer_params -replace '\{name_of_cycle\}', $cycle

    #Replace source location
    $pipelineWorkSpace = $pipelineWorkSpace -replace '\\', '\\\\'
    $pipelineWorkSpace = $pipelineWorkSpace -replace '\\\\', '\'
    $this_installer_params = $this_installer_params -replace '\{source\}', "$pipelineWorkSpace\\built-source"

    #Replace aip build filename
    $this_installer_params = $this_installer_params -replace '\{name_of_aip_build\}', $advancedInstallerBuildName

    #Replace certificate filename
    $this_installer_params = $this_installer_params -replace '\{name_of_certificate\}', $certificateFilename

    #Replace aip build params filename
    $this_installer_params = $this_installer_params -replace '\{name_of_params_file\}', $advancedInstallerBuildParamsFilename

    return $this_installer_params
}

# Convert the comma-separated string to an array
$cyclesArray = $cyclesCommaSeparated -split ','

$newInstallersCreateMatrix = @()

# Loop through the array
foreach ($cycle in $cyclesArray) {
    $autoupdater_params = GenerateInstallerParams -cycle $cycle -installer_params $autoupdater_installer_params
    $newInstallersCreateMatrix += "`"cycle_autoupdater_$cycle`": $autoupdater_params"

    $autoupdater_selfserve_params = GenerateInstallerParams -cycle $cycle -installer_params $autoupdater_selfserve_installer_params
    $newInstallersCreateMatrix += "`"cycle_autoupdater_selfserve_$cycle`": $autoupdater_selfserve_params"

    $standalone_params = GenerateInstallerParams -cycle $cycle -installer_params $standalone_installer_params
    $newInstallersCreateMatrix += "`"cycle_standalone_$cycle`": $standalone_params"

    $standalone_selfserve_params = GenerateInstallerParams -cycle $cycle -installer_params $standalone_selfserve_installer_params
    $newInstallersCreateMatrix += "`"cycle_standalone_selfserve_$cycle`": $standalone_selfserve_params"
}

# Convert array of modified matrices to JSON array
$jsonArray = $newInstallersCreateMatrix -join ","

# Enclose in brackets to make it a valid JSON array
$jsonArray = "{ $jsonArray }"

# Output the final JSON array
Write-Host "Publish params: $jsonArray"

Write-Host "##vso[task.setvariable variable=publishList;isOutput=true]$jsonArray"