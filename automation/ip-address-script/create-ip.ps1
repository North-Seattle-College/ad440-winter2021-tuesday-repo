
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
    $IpName,

    [Parameter(Mandatory=$True)]
    [string]
    $Location
)

#To login to azure from powershell use the following
Connect-AzAccount 
#to Connect to Azure using a service principal account
    
  #  $Credential = Get-Credential
  #  Connect-AzAccount -Credential $Credential -Tenant 'xxxx-xxxx-xxxx-xxxx' -ServicePrincipal

#deploying IP address
New-AzPublicIpAddress -Name $IpName -ResourceGroupName nsc-rg-dev-usw2-team3 -Location $Location -AllocationMethod Dynamic -IpAddressVersion IPv4

#For the most part, few things need to be dynamically set by the user for this, so far.