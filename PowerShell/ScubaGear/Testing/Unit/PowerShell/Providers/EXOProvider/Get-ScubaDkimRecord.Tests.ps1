$ProviderPath = "../../../../../Modules/Providers"
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath "$($ProviderPath)/ExportEXOProvider.psm1") `
    -Function Get-ScubaDkimRecords -Force

InModuleScope 'ExportEXOProvider' {
    Describe -Tag 'ExportEXOProvider' -Name "Get-ScubaDkimRecord" {
        BeforeAll {
            Mock -CommandName Write-Warning {}
        }
        Context "When high-confidence answers are available" {
            BeforeAll {
                Mock -CommandName Invoke-RobustDnsTxt {
                    @{
                        "Answers" = @("v=DKIM1...");
                        "HighConfidence" = $true;
                        "LogEntries" = @("some text")
                    }
                }
            }
            It "Resolves 1 domain name" {
                $Response = Get-ScubaDkimRecord -Domains @(@{"DomainName" = "example.com"})
                Should -Invoke -CommandName Invoke-RobustDnsTxt -Exactly -Times 1
                Should -Invoke -CommandName Write-Warning -Exactly -Times 0
                $Response.rdata -Contains "v=DKIM1..." | Should -Be $true
            }
            It "Resolves multiple domain name" {
                $Response = Get-ScubaDkimRecord -Domains @(@{"DomainName" = "example.com"},
                @{"DomainName" = "example.com"})
                Should -Invoke -CommandName Invoke-RobustDnsTxt -Exactly -Times 2
                Should -Invoke -CommandName Write-Warning -Exactly -Times 0
                $Response.rdata -Contains "v=DKIM1..." | Should -Be $true
            }
        }
        Context "When high-confidence answers are not available" {
            BeforeAll {
                Mock -CommandName Invoke-RobustDnsTxt {
                    @{
                        "Answers" = @("v=DKIM1...");
                        "HighConfidence" = $false;
                        "LogEntries" = @("some text")
                    }
                }
            }
            It "Prints a warning" {
                $Response = Get-ScubaDkimRecord -Domains @(@{"DomainName" = "example.com"})
                Should -Invoke -CommandName Invoke-RobustDnsTxt -Exactly -Times 1
                Should -Invoke -CommandName Write-Warning -Exactly -Times 1
                $Response.rdata -Contains "v=DKIM1..." | Should -Be $true
            }
        }
        Context "When not all selectors work" {
            It "Tries multiple selectors" {
                Mock -CommandName Invoke-RobustDnsTxt {
                    if ($Qname.Contains("selector1")) {
                        @{
                            "Answers" = @();
                            "HighConfidence" = $true;
                            "LogEntries" = @("Query returned NXDomain")
                        }
                    }
                    else {
                        @{
                            "Answers" = @("v=DKIM1...");
                            "HighConfidence" = $true;
                            "LogEntries" = @("some text")
                        }
                    }
                }
                $Response = Get-ScubaDkimRecord -Domains @(@{"DomainName" = "example.com"})
                Should -Invoke -CommandName Invoke-RobustDnsTxt -Exactly -Times 2
                Should -Invoke -CommandName Write-Warning -Exactly -Times 0
                $Response.rdata -Contains "v=DKIM1..." | Should -Be $true
            }
            It "Embeds the domain name into the selector" {
                Mock -CommandName Invoke-RobustDnsTxt {
                    if ($Qname -eq "selector1-example-com._domainkey.example.com") {
                        @{
                            "Answers" = @("v=DKIM1...");
                            "HighConfidence" = $true;
                            "LogEntries" = @("some text")
                        }
                    }
                    else {
                        @{
                            "Answers" = @();
                            "HighConfidence" = $true;
                            "LogEntries" = @("Query returned NXDomain")
                        }
                    }
                }
                $Response = Get-ScubaDkimRecord -Domains @(@{"DomainName" = "example.com"})
                Should -Invoke -CommandName Invoke-RobustDnsTxt -Exactly -Times 3
                Should -Invoke -CommandName Write-Warning -Exactly -Times 0
                $Response.rdata -Contains "v=DKIM1..." | Should -Be $true
            }
        }
    }
}
AfterAll {
    Remove-Module ExportEXOProvider -Force -ErrorAction SilentlyContinue
}