# The purpose of this test is to verify that PSSA is working.

Describe "PSSA Check" {
  It "PSSA should write output" {
    # Source the function
    . $PSScriptRoot/../../utils/workflow/Invoke-PSSA.ps1
    # Invoke PSSA, redirecting the outputs to $Output
    $Output = Invoke-PSSA -DebuggingMode $false -RepoPath $RepoRootPath 6>&1
    $Module = Get-Module -ListAvailable -Name 'PSScriptAnalyzer'
    $Module | Should -Not -BeNullOrEmpty
    $Output | Should -Not -BeNullOrEmpty
    # Note: This is a little bit fragile.  It only work as long as one of these two
    # summary statements is the final output written.
    $Output | Select-Object -Last 1 | Should -BeIn @("Problems were found in the PowerShell scripts.", "No problems were found in the PowerShell scripts.")
  }
}