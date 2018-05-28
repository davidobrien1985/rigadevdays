#Requires -Modules Pester
<#
.SYNOPSIS
    Tests a specific ARM template
.EXAMPLE
    Invoke-Pester
.NOTES
    This file has been created as an example of using Pester to evaluate ARM templates
#>

$root = $(Split-Path $PSScriptRoot -Parent)
$template = $(Join-Path $root 'armdeploy-jenkins.json')
$parameterJson = $(Join-Path $root 'armdeployparameters-jenkins.json')
$location = 'westeurope'

Describe "Template: $template" {

  Context "Template Syntax" {
    It "Has a JSON template" {
      $template | Should Exist
    }

    It "Has a parameters file" {
      $parameterJson | Should Exist
    }

    It "Converts from JSON and has the expected properties" {
      $expectedProperties = '$schema',
      'contentVersion',
      'parameters',
      'variables',
      'resources',
      'outputs' | Sort-Object -Descending
      $templateProperties = (get-content $template | ConvertFrom-Json -ErrorAction SilentlyContinue) | Get-Member -MemberType NoteProperty | Sort-Object -Property NoteProperty | % Name | Sort-Object -Descending 
      $templateProperties | Should Be $expectedProperties
    }

    It "Creates the expected Azure resources" {
      $expectedResources = 'Microsoft.Storage/storageAccounts',
      'Microsoft.Compute/availabilitySets',
      'Microsoft.Compute/virtualMachineScaleSets',
      'Microsoft.Insights/autoscaleSettings',
      'Microsoft.Network/virtualNetworks',
      'Microsoft.Network/networkInterfaces',
      'Microsoft.Network/publicIPAddresses',
      'Microsoft.Network/loadBalancers' | Sort-Object -Descending
      $templateResources = (get-content $template | ConvertFrom-Json -ErrorAction SilentlyContinue).Resources.type | Sort-Object -Property NoteProperty | Sort-Object -Descending
      $templateResources | Should Be $expectedResources
    }
  }

  Context "Template Validation" {

    BeforeAll {
      $shortGUID = ([system.guid]::newguid().guid).Substring(0,3)
      $tempRg = "$shortGUID-Pester-RG"
      New-AzureRmResourceGroup -Name $tempRg -Location $location
    }

    It "Template $template and parameter file $parameterJson passes validation" {
      $ValidationResult = Test-AzureRmResourceGroupDeployment -ResourceGroupName $tempRg -Mode Complete -TemplateFile $template -TemplateParameterFile $parameterJson
      $ValidationResult | Should BeNullOrEmpty
    }

    AfterAll {
      Remove-AzureRmResourceGroup $tempRg -Force
    }
  }
}





