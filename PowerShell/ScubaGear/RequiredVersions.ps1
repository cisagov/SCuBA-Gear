[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'ModuleList')]
$ModuleList = @(
    @{
        ModuleName = 'MicrosoftTeams'
        ModuleVersion = [version] '4.9.3'
        MaximumVersion = [version] '5.99.99999'
    },
    @{
        ModuleName = 'ExchangeOnlineManagement' # includes Defender
        ModuleVersion = [version] '3.1.0'
        MaximumVersion = [version] '3.99.99999'
    },
    @{
        ModuleName = 'Microsoft.Online.SharePoint.PowerShell' # includes OneDrive
        ModuleVersion = [version] '16.0.0'
        MaximumVersion = [version] '16.99.99999'
    },
    @{
        ModuleName = 'PnP.PowerShell' # alternate for SharePoint PowerShell
        ModuleVersion = [version] '1.12.0'
        MaximumVersion = [version] '1.99.99999'
    },
    @{
        ModuleName = 'Microsoft.PowerApps.Administration.PowerShell'
        ModuleVersion = [version] '2.0.0'
        MaximumVersion = [version] '2.99.99999'
    },
    @{
        ModuleName = 'Microsoft.PowerApps.PowerShell'
        ModuleVersion = [version] '1.0.0'
        MaximumVersion = [version] '1.99.99999'
    },
    @{
        ModuleName = 'Microsoft.Graph.Beta.Applications' #TODO: Verify is needed
        ModuleVersion = [version] '2.0.0'
        MaximumVersion = [version] '2.99.99999'
    },
    @{
        ModuleName = 'Microsoft.Graph.Authentication' # No beta endpoint
        ModuleVersion = [version] '2.0.0'
        MaximumVersion = [version] '2.99.99999'
    },
    @{
        ModuleName = 'Microsoft.Graph.Beta.DeviceManagement' #TODO: Verify is needed
        ModuleVersion = [version] '2.0.0'
        MaximumVersion = [version] '2.99.99999'
    },
    @{
        ModuleName = 'Microsoft.Graph.Beta.DeviceManagement.Administration' #TODO: Verify is needed
        ModuleVersion = [version] '2.0.0'
        MaximumVersion = [version] '2.99.99999'
    },
    @{
        ModuleName = 'Microsoft.Graph.Beta.DeviceManagement.Enrollment' #TODO: Verify is needed
        ModuleVersion = [version] '2.0.0'
        MaximumVersion = [version] '2.99.99999'
    },
    @{
        ModuleName = 'Microsoft.Graph.Beta.Devices.CorporateManagement' #TODO: Verify is needed
        ModuleVersion = [version] '2.0.0'
        MaximumVersion = [version] '2.99.99999'
    },
    @{
        ModuleName = 'Microsoft.Graph.Beta.Groups'
        ModuleVersion = [version] '2.0.0'
        MaximumVersion = [version] '2.99.99999'
    },
    @{
        ModuleName = 'Microsoft.Graph.Beta.Identity.DirectoryManagement'
        ModuleVersion = [version] '2.0.0'
        MaximumVersion = [version] '2.99.99999'
    },
    @{
        ModuleName = 'Microsoft.Graph.Beta.Identity.Governance' #TODO: Verify is needed
        ModuleVersion = [version] '2.0.0'
        MaximumVersion = [version] '2.99.99999'
    },
    @{
        ModuleName = 'Microsoft.Graph.Beta.Identity.SignIns'
        ModuleVersion = [version] '2.0.0'
        MaximumVersion = [version] '2.99.99999'
    },
    @{
        ModuleName = 'Microsoft.Graph.Beta.Planner' #TODO: Verify is needed
        ModuleVersion = [version] '2.0.0'
        MaximumVersion = [version] '2.99.99999'
    },
    @{
        ModuleName = 'Microsoft.Graph.Beta.Security'
        ModuleVersion = [version] '2.0.0'
        MaximumVersion = [version] '2.99.99999'
    },
    @{
        ModuleName = 'Microsoft.Graph.Beta.Teams' #TODO: Verify is needed
        ModuleVersion = [version] '2.0.0'
        MaximumVersion = [version] '2.99.99999'
    },
    @{
        ModuleName = 'Microsoft.Graph.Beta.Users'
        ModuleVersion = [version] '2.0.0'
        MaximumVersion = [version] '2.99.99999'
    },
    @{
        ModuleName = 'powershell-yaml'
        ModuleVersion = [version] '0.4.2'
        MaximumVersion = [version] '0.99.99999'
    }
)