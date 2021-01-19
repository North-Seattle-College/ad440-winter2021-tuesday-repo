# prompt for resource group name 
$resourceGroupName = Read-Host -Prompt "Enter a resource group name that is used for generating resource names"
# prompt for location
$location = Read-Host -Prompt "Enter the location (like 'eastus' or 'northeurope')"
$templateUri = "https://raw.githubusercontent.com/vq37vhr/ad440-winter2021-tuesday-repo/automation-psl/automation/functions/template.json"

# create resource group based on user input
New-AzResourceGroup -Name $resourceGroupName -Location "$location"
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri $templateUri