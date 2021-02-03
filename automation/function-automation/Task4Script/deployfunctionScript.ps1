Connect-AzAccount

$resourceGroupName = Read-Host -Prompt "Enter a resource group name to create a new resource group"
$location = Read-Host -Prompt "Enter the location (like 'eastus' or 'westus2')"
$templateUri = "https://raw.githubusercontent.com/RayWu222/ad440-winter2021-tuesday-repo/Task4/automation/function-automation/Task4Script/azuredeploy.json"

New-AzResourceGroup -Name $resourceGroupName -Location "$location"
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri $templateUri

Read-Host -Prompt "Press [ENTER] to continue ..."