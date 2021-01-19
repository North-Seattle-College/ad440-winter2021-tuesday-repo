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

 "you entered $SubscriptionId" 
 "you entered $RGName"   
 "you entered $SubNetName"   
 "you entered $SubVNetPrefix"   
 "you entered $VNetName"   

#Login into Azure
Connect-AzAccount | Out-Null

#Selecting subscription
Select-AzureSubscription -SubscriptionId $SubscriptionId -ErrorAction Stop

#Selecting resource
Get-AzResourceGroup -ResourceGroupName $RGName

# Create a virtual network
$virtualNetwork = New-AzVirtualNetwork `
  -ResourceGroupName $RGName 
  -Location $Location
  -Name $VNetName 
  -AddressPrefix $VNetPrefix

# Create a subnet configuration
$subnetConfig = New-AzVirtualNetworkSubnetConfig `
  -Name $SubNetName 
  -VirtualNetwork $virtualNetwork
  -AddressPrefix $SubVNetPrefix

$virtualNetwork.Subnets.Add($subnetConfig)  

#Associates the subnet to the virtual network
  $virtualNetwork | Set-AzVirtualNetwork