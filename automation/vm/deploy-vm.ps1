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
    $ServicePrincipalPassword,

    [Parameter(Mandatory=$True)]
    [string]
    $RGName,
    
    [Parameter(Mandatory=$True)]
    [string]
    $Location,

    [Parameter(Mandatory=$True)]
    [string]
    $TempFilePath,

    [Parameter(Mandatory=$True)]
    [string]
    $ParamFilePath,

    [Parameter(Mandatory=$True)]
    [string]
    $VMName,

    [Parameter(Mandatory=$True)]
    [string]
    $vnet,

    [Parameter(Mandatory=$True)]
    [string]
    $subnet,

    [Parameter(Mandatory=$True)]
    [string]
    $sgname,

    [Parameter(Mandatory=$True)]
    [string]
    $ipaddress
    
)

#To login to azure from powershell use the following
Connect-AzAccount 
#to Connect to Azure using a service principal account
    
  #  $Credential = Get-Credential
  #  Connect-AzAccount -Credential $Credential -Tenant 'xxxx-xxxx-xxxx-xxxx' -ServicePrincipal
    
  

#first thing to create a resource group
#New-AzResourceGroup -ResourceGroupName $RGName -Location $Location

#deploying VM(created all resources)
New-AzVM -ResourceGroupName $RGName -Name $VMName -Location $Location -VirtualNetworkName $vnet -SubnetName $subnet -SecurityGroupName $sgname -PublicIpAddressName $ipaddress 