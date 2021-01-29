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
    [Parameter(Mandatory=$true)]
    [string]
    $RGName
   )

#Login into Azure
Connect-AzAccount | Out-Null

# parameters
$virtualNetworkParameters= @{
    vnetName = "testhardcodedvalues";
    vnetAddressPrefix = "172.18.0.0/16";
    subnet1Prefix = "172.18.0.0/24";
    subnet1Name ="public";
    location = "westus2";
} 

New-AzResourceGroupDeployment -ResourceGroupName $RGName -TemplateFile "./template.json" -TemplateParameterObject $virtualNetworkParameters