## Create azure storage account with containers/blob names
## Container #1: $web – used for React app
## Container #2: serverless-artillery – used to store serverless artillery results
## Container #3: artillery – used to store artillery results

## Tags for each resource:
## NCSYear: 2021
## NSCCohort: Tuesday
## Owner: [whoever creates the resource]
## OwnerEmail: [seattlecolleges.edu email]


# param (
#     [Parameter(Mandatory = $True)]
#     [string]
#     $resourceGroupName,

#     [Parameter(Mandatory = $True)]
#     [string]
#     $location,

#     [Parameter(Mandatory = $True)]
#     [string]
#     $tags

# )
$ctx = $storageAccName.Context
$location = "westus2"
$templateUri = "./templatestorage.json"
$subs = "9f4dcf43-aa06-457b-b975-f0216baef20d"
$tenant = Read-Host -Prompt "Enter Tenant Id"
$resourceGroupName = "nsc-rg-dev-usw2-tuesday"
$storageAccName = "nscstrdevusw2tuecommon"
$tags = @{"NSCYear"="2001"; "NSCCohort"="Tuesday";"Owner"="Paul Briones";"OwnerEmail"="paul.briones@seattlecolleges.edu"}

Connect-AzAccount -Subscription $subs -Tenant $tenant

## Connect to your resource group

$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue

if (!$resourceGroup) {
    New-AzResourceGroup -Name $resourceGroupName -Location "$location"
    New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri $templateUri
}

else {
    Write-Host "Using existing resource group '$resourceGroupName'";
}

## Create storage Account

Function CreateAzStorageAcc{   
    ## Check if storage account exists  
    if(Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccName -ErrorAction SilentlyContinue)  
    {  
         Write-Host -ForegroundColor Magenta $storageAccName "- storage account already exists."     
    }  
    else  
    {  
         Write-Host -ForegroundColor Magenta $storageAccName "- storage account does not exist."  
         Write-Host -ForegroundColor Green "Creating the storage account - " $storageAccName   
         ## Create a new Azure Storage Account  
         New-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccName -Location $location -SkuName Standard_LRS -Tag $tags
    }  
}   
  
CreateAzStorageAcc  
 
## Create container
# Get-AzStorageAccount -ResourceGroupName $resourceGroupName -AccountName $storageAccName
"web serverless-artillery artillery".split() | New-AzureStorageContainer -Permission Container -Context $ctx

## Disconnect from Azure Account  
Disconnect-AzAccount 

##New-AzResourceGroupDeployment -Name 'new-storage' -ResourceGroupName $rg -TemplateUri $templateUri

