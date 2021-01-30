<#
.SYNOPSIS
  Creates a virtual network with one line cmdlet.
.DESCRIPTION
  This script will deploy a virtual network. 
  This script  requires an existing Azure subscription and Resource group.
.PARAMETER RGName
    Required. Name of existing Resource  
.PARAMETER Location
    Required. Name of location of Resource eg: westus2     
.PARAMETER VNetName
    Required. Name of desired Virtual Network Name Eg: [project]-[resource-type]-[environment]-[location]-[other-stuff]
.PARAMETER VNetPrefix
    Required. Desired address space for Virtual Network eg: eg: 10.0.0.0/16
.PARAMETER SubNetName
    Required. Name of desired SubNet
.PARAMETER SubVNetPrefix
    Required. Desired address space for SubNet eg: 10.0.0.0/24
.NOTES
  Version:        2
  Author:         Jennifer Villacis
  Creation Date:  01/27/21
  Purpose: Virtual Network Automation Script
#>

[cmdletbinding()]
Param(
    [Parameter(Mandatory=$true,HelpMessage='The name of your existing Resource group name')]
    [string]
    $ResourceGroupName,
    [Parameter(Mandatory=$true,HelpMessage='The name of your new virtual network')]
    [string]
    $VirtualNetworkName,
    [Parameter(Mandatory=$true,HelpMessage='The name of the subnet virtual network eg: deault or public')]
    [string]
    $SubNetworkName
   )

#Login into Azure
Connect-AzAccount | Out-Null

# Get existing resource group
$Location = Get-AzResourceGroup -Name $ResourceGroupName

#location selected resource group
$RGLocation= $Location.location

#file path for -TemplateFile
$FilePath = "./template.json"

#Hashtable containing parameters for virtual network template
$VirtualNetworkParameters= @{
    vnetName = ($VirtualNetworkName).ToLower();
    vnetAddressPrefix = "172.18.0.0/16";
    subnet1Prefix = "172.18.0.0/24";
    subnet1Name = ($SubNetworkName).ToLower();
    location = $RGLocation;
} 

# Creates Virutal Network 
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $FilePath -TemplateParameterObject $VirtualNetworkParameters