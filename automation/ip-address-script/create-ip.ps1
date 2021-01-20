<#
.DESCRIPTION
  This script will create a public IPv4 address.
  This script  requires an existing azure subscription and resource group.
.PARAMETER SubscriptionId
    The ID of the subscription, found in the vault
.PARAMETER TenantId
    The ID of the tenant, found in Azure Active Directory
.PARAMETER ResourceGroupName
    Required. Name of existing Resource group
.PARAMETER Location
    Required. Location of the IP to be created
.PARAMETER IpName
    Required. Desired name of the IP address
.NOTES
  Version:        1.0
  Author:         Derek Hendrick
  Creation Date:  01/18/21
  Purpose: IP Address Automation
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$True)]
    [string]
    $SubscriptionId,

    [Parameter(Mandatory=$True)]
    [string]
    $TenantId,

    [Parameter(Mandatory=$True)]
    [string]
    $ResourceGroupName,

    [Parameter(Mandatory=$True)]
    [string]
    $IpName,

    [Parameter(Mandatory=$True)]
    [string]
    $Location
)

#To login to azure from powershell use the following
Connect-AzAccount 

#deploying IP address
New-AzPublicIpAddress -Name $IpName -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod Dynamic -IpAddressVersion IPv4

#For the most part, few things need to be dynamically set by the user for this, so far.