$OrchestratorPath = '../../../../Modules/Orchestrator.psm1'
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath $OrchestratorPath) -Function 'Invoke-RunRego' -Force

InModuleScope Orchestrator {
    Describe -Tag 'Orchestrator' -Name 'Invoke-RunRego' {
        BeforeAll {
            function Invoke-Rego {}
            Mock -ModuleName Orchestrator Invoke-Rego
            function Get-FileEncoding {}
            Mock -ModuleName Orchestrator Get-FileEncoding

            Mock -CommandName Write-Progress {}
            Mock -CommandName Join-Path { "." }
            Mock -CommandName Set-Content {}
            Mock -CommandName ConvertTo-Json {}
            Mock -CommandName ConvertTo-Csv {}
        }
        Context 'When running the rego on a provider json' {
            BeforeAll {
                [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'ConfigParams')]
                $ConfigParams = @{
                    OPAPath             = "./"
                    OutProviderFileName = "ProviderSettingsExport";
                    OutRegoFileName     = "TestResults"
                    M365Environment     = "commercial";
                }
                [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'RunRegoParameters')]
                $RunRegoParameters = @{
                    ParentPath    = "./"
                    OutFolderPath = "./"
                    ScubaConfig   = @{}
                }
            }
            It 'With -ProductNames "aad", should not throw' {
                $ConfigParams += @{
                    ProductNames = @("aad")
                }
                $RunRegoParameters['ScubaConfig'] = (New-Object -Type PSObject -Property $ConfigParams)
                { Invoke-RunRego @RunRegoParameters } | Should -Not -Throw
            }
            It 'With -ProductNames "defender", should not throw' {
                $ConfigParams += @{
                    ProductNames = @("defender")
                }
                $RunRegoParameters['ScubaConfig'] = (New-Object -Type PSObject -Property $ConfigParams)
                { Invoke-RunRego @RunRegoParameters } | Should -Not -Throw
            }
            It 'With -ProductNames "exo", should not throw' {
                $ConfigParams += @{
                    ProductNames = @("exo")
                }
                $RunRegoParameters['ScubaConfig'] = (New-Object -Type PSObject -Property $ConfigParams)
                { Invoke-RunRego @RunRegoParameters } | Should -Not -Throw
            }
            It 'With -ProductNames "powerplatform", should not throw' {
                $ConfigParams += @{
                    ProductNames = @("powerplatform")
                }
                $RunRegoParameters['ScubaConfig'] = (New-Object -Type PSObject -Property $ConfigParams)
                { Invoke-RunRego @RunRegoParameters } | Should -Not -Throw
            }
            It 'With -ProductNames "sharepoint", should not throw' {
                $ConfigParams += @{
                    ProductNames = @("sharepoint")
                }
                $RunRegoParameters['ScubaConfig'] = (New-Object -Type PSObject -Property $ConfigParams)
                { Invoke-RunRego @RunRegoParameters } | Should -Not -Throw
            }
            It 'With -ProductNames "teams", should not throw' {
                $ConfigParams += @{
                    ProductNames = @("teams")
                }
                $RunRegoParameters['ScubaConfig'] = (New-Object -Type PSObject -Property $ConfigParams)
                { Invoke-RunRego @RunRegoParameters } | Should -Not -Throw
            }
            It 'With all products, should not throw' {
                $ConfigParams += @{
                    ProductNames = @("aad", "defender", "exo", "powerplatform", "sharepoint", "teams")
                }
                $RunRegoParameters['ScubaConfig'] = (New-Object -Type PSObject -Property $ConfigParams)
                { Invoke-RunRego @RunRegoParameters } | Should -Not -Throw
            }
        }
    }
}

AfterAll {
    Remove-Module Orchestrator -ErrorAction SilentlyContinue
}
