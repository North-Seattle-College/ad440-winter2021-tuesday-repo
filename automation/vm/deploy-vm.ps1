[CmdletBinding()]
param (
    [Parameter(Mandatory=$True)]
    [string]
    $SubscriptionId,

    [Parameter(Mandatory=$True)]
    [string]
    $TenantId,

    [Parameter(Mandatory=$False)]
    [string]
    $ServicePrincipalId,

    [Parameter(Mandatory=$False)]
    [SecureString]
    $ServicePrincipalPassword
)

#To login to azure from powershell use the following
Connect-AzAccount 
#to Connect to Azure using a service principal account
    
  #  $Credential = Get-Credential
  #  Connect-AzAccount -Credential $Credential -Tenant 'xxxx-xxxx-xxxx-xxxx' -ServicePrincipal
    
  

#first thing to create a resource group
#New-AzResourceGroup -Name $resourceGroup -Location $location   is asking to provide not null argument for resource group
#New-AzResourceGroup -Name virtualMachineRG -Location westus2
New-AzResourceGroup -Name nsc-rg-dev-usw2-team3 -Location westus2

#deploying VM
New-AzResourceGroupDeployment  -ResourceGroupName nsc-rg-dev-usw2-team3 -TemplateFile ./automation/vm/template.json -TemplateParameterFile ./automation/vm/parameters.json -Name nsc-aut-dev-usw2-vm-jg
#following is using param from template
#New-AzResourceGroupDeployment  -virtualMachineRG $resourceGroup -TemplateFile ./template.json -TemplateParameterFile ./parameters.json -virtualMachineName $VM 