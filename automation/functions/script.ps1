param(
    [Parameter(Mandatory = $True)]
    [string]
    $resourceGroupName,

    [Parameter(Mandatory = $True)]
    [string]
    $location
)

#sign into azure account 
Connect-AzAccount

#Will change this to NSC raw link after merge
$templateUri = "https://raw.githubusercontent.com/selinapn/ad440-winter2021-tuesday-repo/automationspn-s2/automation/functions/azuredeploy.json"

#Create or check for existing resource group
$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
    New-AzResourceGroup -Name $resourceGroupName -Location "$location"
    New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri $templateUri
}
else{
    Write-Host "Using existing resource group '$resourceGroupName'";
}