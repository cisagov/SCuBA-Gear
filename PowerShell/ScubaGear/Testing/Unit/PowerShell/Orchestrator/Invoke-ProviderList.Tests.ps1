$OrchestratorPath = '../../../../Modules/Orchestrator.psm1'
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath $OrchestratorPath) -Function 'Invoke-ProviderList' -Force

InModuleScope Orchestrator {
Describe -Tag 'Orchestrator' -Name 'Invoke-ProviderList' {
    BeforeAll {
        function Export-AADProvider {}
        Mock -ModuleName Orchestrator Export-AADProvider {}
        function Export-EXOProvider {}
        Mock -ModuleName Orchestrator Export-EXOProvider {}
        function Export-DefenderProvider {}
        Mock -ModuleName Orchestrator Export-DefenderProvider {}
        function Export-PowerPlatformProvider {}
        Mock -ModuleName Orchestrator Export-PowerPlatformProvider {}
        function Export-SharePointProvider {}
        Mock -ModuleName Orchestrator Export-SharePointProvider {}
        function Export-TeamsProvider {}
        Mock -ModuleName Orchestrator Export-TeamsProvider {}
        function Get-FileEncoding {}
        Mock -ModuleName Orchestrator Get-FileEncoding {}

        Mock -CommandName Write-Progress {}
        Mock -CommandName Join-Path {"."}
        Mock -CommandName Set-Content {}
        Mock -CommandName Get-TimeZone {}
    }
    Context 'When running the providers on commercial tenants' {
        BeforeAll {
            
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'ConfigParams')]
            $ConfigParams = @{
                OutProviderFileName = "ProviderSettingsExport";
                M365Environment = "commercial";
            }
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'ProviderParameters')]
            $ProviderParameters = @{
                OutFolderPath = "./output";
                TenantDetails = '{"DisplayName": "displayName"}';
                ModuleVersion = '1.0';
                BoundParameters = @{};
                ScubaConfig = @{}
            }
        }
        It 'With -ProductNames "aad", should not throw' {
            $ConfigParams += @{
                ProductNames = @("aad")
            }
            $ProviderParameters['ScubaConfig'] = (New-Object -Type PSObject -Property $ConfigParams)

            {Invoke-ProviderList @ProviderParameters} | Should -Not -Throw
        }
        It 'With -ProductNames "defender", should not throw' {
            $ConfigParams += @{
                ProductNames = @("defender")
            }
            $ProviderParameters['ScubaConfig'] = (New-Object -Type PSObject -Property $ConfigParams)

            {Invoke-ProviderList @ProviderParameters} | Should -Not -Throw
        }
        It 'With -ProductNames "exo", should not throw' {
            $ConfigParams += @{
                ProductNames = @("exo")
            }
            $ProviderParameters['ScubaConfig'] = (New-Object -Type PSObject -Property $ConfigParams)

            {Invoke-ProviderList @ProviderParameters} | Should -Not -Throw
        }
        It 'With -ProductNames "powerplatform", should not throw' {
            $ConfigParams += @{
                ProductNames = @("powerplatform")
            }
            $ProviderParameters['ScubaConfig'] = (New-Object -Type PSObject -Property $ConfigParams)

            {Invoke-ProviderList @ProviderParameters} | Should -Not -Throw
        }
        It 'With -ProductNames "sharepoint", should not throw' {
            $ConfigParams += @{
                ProductNames = @("sharepoint")
            }
            $ProviderParameters['ScubaConfig'] = (New-Object -Type PSObject -Property $ConfigParams)

            {Invoke-ProviderList @ProviderParameters} | Should -Not -Throw
        }
        It 'With -ProductNames "teams", should not throw' {
            $ConfigParams += @{
                ProductNames = @("teams")
            }
            $ProviderParameters['ScubaConfig'] = (New-Object -Type PSObject -Property $ConfigParams)

            {Invoke-ProviderList @ProviderParameters} | Should -Not -Throw
        }
        It 'With all products, should not throw' {
            $ConfigParams += @{
                ProductNames = @("aad", "defender", "exo", "powerplatform", "sharepoint", "teams")
            }
            $ProviderParameters['ScubaConfig'] = (New-Object -Type PSObject -Property $ConfigParams)
            
            {Invoke-ProviderList @ProviderParameters} | Should -Not -Throw
        }
    }
    }
}

AfterAll {
    Remove-Module Orchestrator -ErrorAction SilentlyContinue
}