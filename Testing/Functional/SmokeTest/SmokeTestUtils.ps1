function New-ServicePrincipalCertificate{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Object[]]$EncodedCertificate,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [SecureString]$CertificatePassword
    )

    Set-Content -Path .\ScubaExecutionCert.txt -Value $EncodedCertificate
    certutil -decode .\ScubaExecutionCert.txt .\ScubaExecutionCert.pfx
    $Certificate = Import-PfxCertificate -FilePath .\ScubaExecutionCert.pfx -CertStoreLocation Cert:\CurrentUser\My -Password $CertificatePassword
    $Thumbprint = ([System.Security.Cryptography.X509Certificates.X509Certificate2]$Certificate).Thumbprint
    Remove-Item -Path .\ScubaExecutionCert.txt
    Remove-Item -Path .\ScubaExecutionCert.pfx
    return $Thumbprint
}

function Remove-MyCertificates{
    Get-ChildItem Cert:\CurrentUser\My | ForEach-Object {
        Remove-Item -Path $_.PSPath -Recurse -Force
    }
}

function Install-SmokeTestExternalDependencies{
    #Workaround till update to version 2.0+
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', 'PNPPOWERSHELL_UPDATECHECK',
        Justification = 'Variable defined outside this scope')]
    $PNPPOWERSHELL_UPDATECHECK = 'Off'
    Install-Module -Name "PnP.PowerShell" -RequiredVersion 1.12 -Force
    ./SetUp.ps1 -SkipUpdate

    #Import Selenium and update drivers
    Install-Module Selenium
    Testing/Functional/SmokeTest/UpdateSelenium.ps1
}