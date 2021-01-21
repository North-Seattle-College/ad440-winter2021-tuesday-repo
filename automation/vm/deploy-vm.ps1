<#
.SYNOPSIS
  Creates a virtual machine with one line cmdlet.
.DESCRIPTION
  This script will deploy a virtual machine. 
  This script  requires an existing Azure subscription and Resource group.
.PARAMETER ResourceGroupName
    Required. Name of Resource group, if already exists will ask if add VM to it   
.PARAMETER Location
    Required. Name of location of Resource eg: westus2     
.PARAMETER VNetName
    Required. Name of desired Virtual Network Name Eg: [project]-[resource-type]-[environment]-[location]-[other-stuff]
.PARAMETER SubNetName
    Required. Name of desired SubNet
.PARAMETER VMname
    Required. Desired name for virtual machine
.PARAMETER SecurityGroupName
    Required. Desired name for security group
.PARAMETER PublicIpAddressName
    Required. Desired name for public Ip address
.NOTES
  Version:        1.0
  Author:         Joanna Gromadzka
  Creation Date:  01/17/21
  Purpose: VM creation Script

  This script requires to obtain administrator's name and strong password (newly made is ok)
#>
[cmdletbinding()]
Param(
    [Parameter(Mandatory=$True)]
    [string]
    $SubscriptionId,
    [Parameter(Mandatory=$True)]
    [string]
    $TenantId,
    [Parameter(Mandatory=$true)]
    [string]
    $ResourceGroupName,
    [Parameter(Mandatory=$true)]
    [string]
    $VMName,
    [Parameter(Mandatory=$true)]
    [string]
    $Location,
    [Parameter(Mandatory=$true)]
    [string]
    $VNetName,
    [Parameter(Mandatory=$true)]
    [string]
    $SubNetName,
    [Parameter(Mandatory=$true)]
    [string]
    $SecurityGroupName,
    [Parameter(Mandatory=$true)]
    [string]
    $PublicIpAddressName
   )
#Login into Azure
Connect-AzAccount 

#Display existing typed resource group
Get-AzResourceGroup -ResourceGroupName $ResourceGroupName

#creates new resource group if needed
#New-AzResourceGroup -Name $ResourceGroupName -Location $Location

#creates VM
New-AzVm -ResourceGroupName $ResourceGroupName -Name $VMName -Location $Location -VirtualNetworkName $VNetName -SubnetName $SubNetName -SecurityGroupName $SecurityGroupName -PublicIpAddressName $PublicIpAddressName -OpenPorts 80,3389