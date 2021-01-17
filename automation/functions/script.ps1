#sign into azure account 
Connect-AzAccount

#create unique name for HTTP Trigger function

$resourceGroupName = Read-Host -Prompt "Name your resource group"
$location = Read-Host -Prompt "Enter location"
$templateUri = "https://github.com/selinapn/ad440-winter2021-tuesday-repo/blob/automationspn/automation/functions/azuredeploy.json"

#Create new resource group and deploy template
New-AzResourceGroup -Name $resourceGroupName -Location "$location"
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri $templateUri


<# publish function to azure
$functionappname = Read-Host -Prompt "Name your function APP"
func azure functionapp publish $functionappname #>