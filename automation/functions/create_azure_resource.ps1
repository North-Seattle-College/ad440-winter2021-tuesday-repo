# ## Create azure resource using powershell

$rg = Read-Host -Prompt "Enter Name to create new Resource Group"
$templateUri = "https://raw.githubusercontent.com/North-Seattle-College/ad440-winter2021-tuesday-repo/development/automation/functions/template.json"

New-AzResourceGroup -Name $rg -Location westus2 -Force

New-AzResourceGroupDeployment -Name 'new-storage' -ResourceGroupName $rg -TemplateUri $templateUri




