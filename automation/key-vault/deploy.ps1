param(
        [string] $TemplateFile = './template.json'
      )

# Short check if KeyVault already exists
$KeyVaultExists = (Get-AzKeyVault -ResourceGroupName $ResourceGroupName -Name $KeyVaultName)

# Create new KeyVault if one doesn't already exist:
if (!$KeyVaultExists) {
    Write-Host "Creating new Key Vault..."
    New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateFile
} else {
    Write-Host "Key Vault with name " $KeyVaultName "already exists."
}
