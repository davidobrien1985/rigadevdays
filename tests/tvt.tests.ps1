#Requires -Modules Pester
<#
.SYNOPSIS
    Tests a specific ARM template
.EXAMPLE
    Invoke-Pester
.NOTES
    This file has been created as an example of using Pester to validate the deployed environment
#>

$endpointUrl = "globo-jenkins$($env:Release_EnvironmentName).australiasoutheast.cloudapp.azure.com"

Describe "Test Deployed ARM template" {

  Context "Test Front End Loadbalancer URL" {
    It "Resolves the DNS name" {
      $res = Test-NetConnection $endpointUrl
      $res.NameResolutionSucceeded | Should Be 'True'
    }
    It "succeeds the TCP port test" {
      $res = Test-NetConnection $endpointUrl -Port 80
      $res.TcpTestSucceeded | Should Be 'True'
    }
  }
}