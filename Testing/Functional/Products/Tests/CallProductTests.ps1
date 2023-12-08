# James Garriss
# Dec 2023
# The purpose of this script is to run the functional tests for all the products.
# NOTE: At the moment it only does this for one product, Sharepoint.  Others
#       will be added.

# Setup directories
$thisDir = Get-Location
$testScriptDir = Join-Path -Path $thisDir -ChildPath ..

# TODO: Eventually this hardcoded file should be replaced by reading all the .pson
#       files in the TestData folder.  Instead of just a hashtable of params, it
#       will be an array of hashtables.
$params = Import-PowerShellDataFile .\TestData\sharepoint-commercial-data.pson

# Create an array of test containers
$testContainers = @()
$testContainers += New-PesterContainer -Path $testScriptDir -Data $params

# Invoke Pester for each test container
Invoke-Pester -Container $testContainers -Output Detailed