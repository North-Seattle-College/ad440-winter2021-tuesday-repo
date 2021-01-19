<#
.SYNOPSIS
  Creates a virtual network with one line cmdlet.
.DESCRIPTION
  This script will deploy a virtual network. 
  This script  requires an existing Azure subscription and Resource group.
.PARAMETER SubscriptionId
    Required. Subscription ID of Azure Account
.PARAMETER RGName
    Required. Name of existing Resource 
.PARAMETER VNetName
    Required. Name of desired Virtual Network Name Eg: [project]-[resource-type]-[environment]-[location]-[other-stuff]
.PARAMETER VNetPrefix
    Required. Desired address space for Virtual Network
.PARAMETER SubNetName
    Required. Name of desired SubNet
.PARAMETER SubVNetPrefix
    Required. Desired address space for SubNet
.NOTES
  Version:        1.0
  Author:         Jennifer Villacis
  Creation Date:  01/15/21
  Purpose: VNet creation Script
#>

[cmdletbinding()]
Param(
    [Parameter(Mandatory=$true)]
    [string]
    $SubscriptionId,
    [Parameter(Mandatory=$true)]
    [string]
    $RGName,
    [Parameter(Mandatory=$true)]
    [string]
    $Location,
    [Parameter(Mandatory=$true)]
    [string]
    $VNetName,
    [Parameter(Mandatory=$true)]
    [string]
    $VNetPrefix,
    [Parameter(Mandatory=$true)]
    [string]
    $SubNetName,
    [Parameter(Mandatory=$true)]
    [string]
    $SubVNetPrefix
   )

#Login into Azure
Connect-AzAccount | Out-Null

#Selecting subscription
Select-AzureSubscription -SubscriptionId $SubscriptionId -ErrorAction Stop

#Display and Select resource
Get-AzResourceGroup -ResourceGroupName $RGName

# Create a subnet configuration
$subnet1 = New-AzVirtualNetworkSubnetConfig -Name $SubNetName -AddressPrefix $SubVNetPrefix

# Create a virtual network
New-AzVirtualNetwork -Name $VNetName -ResourceGroupName $RGName -Location $Location -AddressPrefix $VNetPrefix -Subnet $subnet1