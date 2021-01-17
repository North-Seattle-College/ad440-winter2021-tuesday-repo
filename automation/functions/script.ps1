#sign into azure account 
Connect-AzAccount


$resourceGroupName = Read-Host -Prompt "Name your resource group"
$location = Read-Host -Prompt "Enter location"
$templateUri = "https://raw.githubusercontent.com/selinapn/ad440-winter2021-tuesday-repo/automationspn/automation/functions/azuredeploy.json"

#Create new resource group and deploy template
New-AzResourceGroup -Name $resourceGroupName -Location "$location"
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri $templateUri