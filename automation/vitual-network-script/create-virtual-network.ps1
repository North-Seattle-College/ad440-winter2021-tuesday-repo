{
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
  "this is address pre-fix for vnet $VNetPrefix"
  -AddressPrefix $VNetPrefix

# Create a subnet configuration
$subnetConfig = New-AzVirtualNetworkSubnetConfig `
  -Name $SubNetName 
  -VirtualNetwork $virtualNetwork
  -AddressPrefix $SubVNetPrefix

$virtualNetwork.Subnets.Add($subnetConfig)  

#Associates the subnet to the virtual network
  $virtualNetwork | Set-AzVirtualNetwork

}