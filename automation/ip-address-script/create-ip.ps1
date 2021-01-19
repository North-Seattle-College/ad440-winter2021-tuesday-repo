#This script will create an IP address using parameters given by the user
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

#PAREMETERS
#SubscriptionId - The ID of the subscription, found in the vault
#TenantId - The ID of the tenant, found in Azure Active Directory
#IpName - The name of the IP address resource. Example: nsc-fun-dev-usw2-derekh
#Location - The server zone the IP address will be hosted. Example: westus2

#deploying IP address
New-AzPublicIpAddress -Name $IpName -ResourceGroupName nsc-rg-dev-usw2-team3 -Location $Location -AllocationMethod Dynamic -IpAddressVersion IPv4

#For the most part, few things need to be dynamically set by the user for this, so far.