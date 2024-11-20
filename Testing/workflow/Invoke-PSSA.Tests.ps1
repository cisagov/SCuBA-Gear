# The purpose of this test is to verify that PSSA is working.

BeforeDiscovery {
  Mock Write-Host {}
  # Source the function
  . $PSScriptRoot/../../utils/workflow/Invoke-PSSA.ps1
  # Invoke PSSA
  $RepoRootPath = Join-Path -Path $PSScriptRoot -ChildPath '..\..' -Resolve
  Invoke-PSSA -DebuggingMode $false -RepoPath $RepoRootPath
}

Describe "PSSA Check" {
  It "PSSA should be installed" {
    $module = Get-Module -ListAvailable -Name 'PSScriptAnalyzer'
    $module | Should -Not -BeNullOrEmpty
  }
  It "PSSA should write output" {
    # # Source the function
    # . $PSScriptRoot/../../utils/workflow/Invoke-PSSA.ps1
    # # Invoke PSSA
    # $RepoRootPath = Join-Path -Path $PSScriptRoot -ChildPath '..\..' -Resolve
    # Invoke-PSSA -DebuggingMode $false -RepoPath $RepoRootPath
    Assert-MockCalled Write-Host -Scope Context -ParameterFilter { $Object -contains "PowerShell scripts" }
  }
}