param(
    # Login parameters
    [string] [Parameter(Mandatory=$true)] $tenantId,          
    [string] [Parameter(Mandatory=$true)] $applicationId,
    [string] [Parameter(Mandatory=$true)] $secret,
    [string] [Parameter(Mandatory=$true)] $subscriptionId,
    # Azure SQL server parameters
    [string] [Parameter(Mandatory=$true)] $location,
    [string] [Parameter(Mandatory=$true)] $resourceGroupName,
    [string] [Parameter(Mandatory=$true)] $serverName,
    [string] [Parameter(Mandatory=$true)] $administratorLogin,
    [string] [Parameter(Mandatory=$true)] $administratorLoginPassword,
    # Azure SQL db parameters
    [string] [Parameter(Mandatory=$false)] $sqlDBName,    
    # Tag parameters
    [string] [Parameter(Mandatory=$true)] $createdBy,
    [string] [Parameter(Mandatory=$true)] $creatorsEmail              
)
[securestring] $administratorLoginPassword = ConvertTo-SecureString $administratorLoginPassword -AsPlainText -Force

# Log in and set the SubscriptionId in which to create these objects
Import-Module ..\Login
Login $tenantId $applicationId $secret $subscriptionId

$pathToAzSqlTemplate = "./template.json"

# Check for or create a resource group
$resourceGroupExists = (Get-AzResourceGroup -Name $resourceGroupName `
-ErrorVariable notPresent -ErrorAction SilentlyContinue).ResourceGroupName `
-eq $resourceGroupName 

if (!$resourceGroupExists) {
        New-AzResourceGroup -Name $resourceGroupName -Location "$location" -Force
        Write-Host "Created resource group $resourceGroupName"
} else {
        Write-Host "Resource group $resourceGroupName already exists."
}

# Deploy template
Write-horceGroupDeployment -ResourceGroupName $resourceGroupName `
-TemplateFile $pathToAzSqlTemplate -administratorLogin $administratorLogin `
-administrst "Creating primary server and db..."
New-AzResouatorLoginPassword $administratorLoginPassword -serverName $serverName `
-sqlDBName $sqlDBName -location $location -createdBy $createdBy -creatorsEmail $creatorsEmail


# Clear deployment 
# Remove-AzResourceGroup -ResourceGroupName $resourceGroupName