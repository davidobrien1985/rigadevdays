[cmdletbinding()]
param (
  [string]
  $testScript,
  [switch]$offline
)
# This script executes verification tests against the ARM template.

# region Install Pester
if (-not $offline) {
  Write-Host "Installing Pester..."
  Install-PackageProvider -Name NuGet -Force -Scope CurrentUser
  Install-Module -Name Pester -Force -Scope CurrentUser -SkipPublisherCheck
}
#endregion

#region call Pester script
Write-Host "Execute Pester tests..."
if ($offline) {
  $result = Invoke-Pester -Script $(Join-Path $PSScriptRoot $testScript) -PassThru -Verbose -Debug -EnableExit -OutputFile $(Join-Path ${PWD}.Path "TestResults.xml") -OutputFormat NUnitXml  
}
else {
  $result = Invoke-Pester -Script $(Join-Path $PSScriptRoot $testScript) -PassThru -Verbose -Debug -EnableExit -OutputFile $(Join-Path "$env:SYSTEM_DEFAULTWORKINGDIRECTORY" "TestResults.xml") -OutputFormat NUnitXml
}
if ($result.failedCount -ne 0) { 
    Write-Error "Pester returned errors"
}
#endregion