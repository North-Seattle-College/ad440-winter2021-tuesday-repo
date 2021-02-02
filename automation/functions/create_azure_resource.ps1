# ## Create azure resource using powershell

$rg = 'NSC-AD440-RG-Tuesday'

New-AzResourceGroup -Name $rg -Location westus2 -Force

New-AzResourceGroupDeployment -Name 'new-storage' -ResourceGroupName $rg -TemplateFile 'C:\Users\pabri\OneDrive\Desktop\AD440\ad440-winter2021-tuesday-repo\automation\functions\template.json'




