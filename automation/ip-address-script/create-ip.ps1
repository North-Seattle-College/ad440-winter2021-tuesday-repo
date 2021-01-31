<#
.DESCRIPTION
  This script will create a public IPv4 address.
  This script  requires an existing azure subscription and resource group.
.PARAMETER ResourceGroupName
    Required. Name of existing Resource group
.PARAMETER Location
    Required. Location of the IP to be created
.PARAMETER IpName
    Required. Desired name of the IP address
.NOTES
  Version:        2.0
  Author:         Derek Hendrick
  Creation Date:  01/30/21
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

    [Parameter(Mandatory=$True, HelpMessage='The name of the resource group this is being added to.')]
    [string]
    $ResourceGroupName,

    [Parameter(Mandatory=$True, HelpMessage='The name of the IP address.')]
    [string]
    $IpName,

    [Parameter(Mandatory=$True, HelpMessage='The location the IP address will be in.')]
    [string]
    $Location
)


#$Credential = Get-Credential
#Connect-AzAccount -Tenant $TenantId -Subscription $SubscriptionId -ServicePrincipal $ServicePrincipal -Credential $Credential

$Credential = Get-Credential
Connect-AzAccount -Credential $Credential -Tenant $TenantId -ServicePrincipal

#Connect-AzAccount -Tenant $TenantId -Subscription $SubscriptionId -Credential $Credential
#To login to azure from powershell use the following
#Connect-AzAccount | Out-Null

# Get existing resource group
#$Location = Get-AzResourceGroup -Name $ResourceGroupName

#location selected resource group
#$RGLocation= $Location.location

#file path for -TemplateFile
$FilePath = "./template.json"

#deploying IP address
New-AzPublicIpAddress -Name $IpName -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod Dynamic -IpAddressVersion IPv4

#For the most part, few things need to be dynamically set by the user for this, so far.