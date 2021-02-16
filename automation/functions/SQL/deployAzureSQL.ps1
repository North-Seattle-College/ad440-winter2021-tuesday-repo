param(
        # Login parameters
        [string] [Parameter(Mandatory = $true)] $tenantId,          
        [string] [Parameter(Mandatory = $true)] $applicationId,
        [string] [Parameter(Mandatory = $true)] $secret,
        [string] [Parameter(Mandatory = $true)] $subscriptionId,
        # Azure SQL server parameters
        [string] [Parameter(Mandatory = $true)] $location,
        [string] [Parameter(Mandatory = $true)] $resourceGroupName,
        [string] [Parameter(Mandatory = $true)] $serverName,
        [string] [Parameter(Mandatory = $true)] $administratorLogin,
        [SecureString] [Parameter(Mandatory = $true)] $administratorLoginPassword,
        # Azure SQL db parameters
        [string] [Parameter(Mandatory = $false)] $sqlDBName,    
        # Tag parameters
        [string] [Parameter(Mandatory = $true)] $owner,
        [string] [Parameter(Mandatory = $true)] $ownersEmail              
)
[securestring] $administratorLoginPassword = ConvertTo-SecureString $administratorLoginPassword -AsPlainText -Force

Import-Module ..\Login
Login $tenantId $applicationId $secret $subscriptionId

$pathToAzSqlTemplate = "./deployAzure.json"

# Check for or create a resource group
$resourceGroupExists = (Get-AzResourceGroup -Name $resourceGroupName `
                -ErrorVariable notPresent -ErrorAction SilentlyContinue).ResourceGroupName `
        -eq $resourceGroupName 
if (!$resourceGroupExists) {
        New-AzResourceGroup -Name $resourceGroupName -Location "$location" -TemplateUri "$pathToAzSqlTemplate" -Force
        Write-Host "Creating new resource group $resourceGroupName"
}
else {
        Write-Host "Use existing resource group $resourceGroupName"
}

# Deploy template
Write-host "Creating primary server and db"
New-AzResourceGroupDeployment 
-ResourceGroupName $resourceGroupName `
        -serverName $serverName `
        -sqlDBName $sqlDBName `
        -location $location