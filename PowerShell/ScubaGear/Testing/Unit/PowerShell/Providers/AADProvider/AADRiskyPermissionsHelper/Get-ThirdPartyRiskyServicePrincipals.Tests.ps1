$ModulesPath = "../../../../../../Modules"
$AADRiskyPermissionsHelper = "$($ModulesPath)/Providers/ProviderHelpers/AADRiskyPermissionsHelper.psm1"
Import-Module $AADRiskyPermissionsHelper

InModuleScope AADRiskyPermissionsHelper {
    Describe "Get-ThirdPartyRiskyServicePrincipals" {
        BeforeAll {
            # Import mock data
            . ../RiskyPermissionsSnippets/MockData.ps1

            function Get-MgBetaApplication { $MockApplications }
            function Get-MgBetaApplicationFederatedIdentityCredential { $MockFederatedCredentials }

            function Get-MgBetaServicePrincipal { $MockServicePrincipals }
            function Get-MgBetaServicePrincipalAppRoleAssignment { $MockServicePrincipalAppRoleAssignments }

            Mock Get-MgBetaApplication { $MockApplications }
            Mock Get-MgBetaApplicationFederatedIdentityCredential { $MockFederatedCredentials }

            Mock Get-MgBetaServicePrincipal { $MockServicePrincipals }
            Mock Get-MgBetaServicePrincipalAppRoleAssignment { $MockServicePrincipalAppRoleAssignments }

            $RiskyApps = Get-ApplicationsWithRiskyPermissions
            $RiskySPs = Get-ServicePrincipalsWithRiskyPermissions
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'ThirdPartySPs')]
            $ThirdPartySPs = Get-ThirdPartyRiskyServicePrincipals -RiskyApps $RiskyApps -RiskySPs $RiskySPs
        }

        It "returns a list of third-party risky service principals with valid properties" {
            $ThirdPartySPs | Should -HaveCount 3

            $ThirdPartySPs[0].DisplayName | Should -Match "Test SP 3"
            $ThirdPartySPs[0].ObjectId | Should -Match "00000000-0000-0000-0000-000000000030"
            $ThirdPartySPs[0].AppId | Should -Match "40000000-0000-0000-0000-000000000000"
            $ThirdPartySPs[0].KeyCredentials | Should -BeNullOrEmpty
            $ThirdPartySPs[0].PasswordCredentials | Should -BeNullOrEmpty
            $ThirdPartySPs[0].FederatedCredentials | Should -BeNullOrEmpty
            $ThirdPartySPs[0].RiskyPermissions | Should -HaveCount 8

            $ThirdPartySPs[1].DisplayName | Should -Match "Test SP 4"
            $ThirdPartySPs[1].ObjectId | Should -Match "00000000-0000-0000-0000-000000000040"
            $ThirdPartySPs[1].AppId | Should -Match "50000000-0000-0000-0000-000000000000"
            $ThirdPartySPs[1].KeyCredentials | Should -BeNullOrEmpty
            $ThirdPartySPs[1].PasswordCredentials | Should -HaveCount 2
            $ThirdPartySPs[1].FederatedCredentials | Should -BeNullOrEmpty
            $ThirdPartySPs[1].RiskyPermissions | Should -HaveCount 8

            $ThirdPartySPs[2].DisplayName | Should -Match "Test SP 5"
            $ThirdPartySPs[2].ObjectId | Should -Match "00000000-0000-0000-0000-000000000050"
            $ThirdPartySPs[2].AppId | Should -Match "60000000-0000-0000-0000-000000000000"
            $ThirdPartySPs[2].KeyCredentials | Should -HaveCount 1
            $ThirdPartySPs[2].PasswordCredentials | Should -BeNullOrEmpty
            $ThirdPartySPs[2].FederatedCredentials | Should -BeNullOrEmpty
            $ThirdPartySPs[2].RiskyPermissions | Should -HaveCount 8
        }
    }
}

AfterAll {
    Remove-Module AADRiskyPermissionsHelper -Force -ErrorAction 'SilentlyContinue'
}