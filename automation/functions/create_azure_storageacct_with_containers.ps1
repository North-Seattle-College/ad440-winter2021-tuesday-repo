## Create azure storage account with containers/blob names
## Container #1: $web – used for React app
## Container #2: serverless-artillery – used to store serverless artillery results
## Container #3: artillery – used to store artillery results

param (
    [Parameter(Mandatory = $True)]
    [string]
    $resourceGroupName,

    [Parameter(Mandatory = $True)]
    [string]
    $location
)

$templateUri = "https://raw.githubusercontent.com/North-Seattle-College/ad440-winter2021-tuesday-repo/development/automation/functions/template.json"
$subs = "9f4dcf43-aa06-457b-b975-f0216baef20d"
$tenant = Read-Host -Prompt "Enter Tenant Id"

Connect-AzAccount -Subscription $subs -Tenant $tenant

$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue

if (!$resourceGroup) {
    New-AzResourceGroup -Name $resourceGroupName -Location "$location"
    New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri $templateUri
}

else {
    Write-Host "Using existing resource group '$resourceGroupName'";
}



##New-AzResourceGroupDeployment -Name 'new-storage' -ResourceGroupName $rg -TemplateUri $templateUri

