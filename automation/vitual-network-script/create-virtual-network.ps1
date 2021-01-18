[cmdletbinding()]
 Param(
    [Parameter(Mandatory=$true)]
    $SubscriptionId,
    [Parameter(Mandatory=$true)]
    $rgName,
    [Parameter(Mandatory=$true)]
    $VNetName,
    $SubNetName,
    $VNetPrefix,
    $SubVNetPrefix
   )

#Login into Azure
Login-AzAccount | Out-Null

#Selecting subscription
Select-AzureSubscription -SubscriptionId $SubscriptionId -ErrorAction Stop


#Selecting resource
Get-AzResourceGroup -ResourceGroupName $rgName

$Location = (Get-AzureRmResourceGroup -Name $rgName).location

# Create a virtual network
$virtualNetwork = New-AzVirtualNetwork `
  -ResourceGroupName $RG `
  -Location $Location `
  -Name $VNetName `
  -AddressPrefix $VNetPrefix

# Create a subnet configuration
$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
  -Name $SubNetName `
  -AddressPrefix 10.0.0.0/24 `
  -VirtualNetwork $virtualNetwork

#Associates the subnet to the virtual network
  $virtualNetwork | Set-AzVirtualNetwork