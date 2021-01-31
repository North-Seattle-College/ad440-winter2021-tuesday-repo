<#
.SYNOPSIS
  Creates a virtual network with one line cmdlet.
.DESCRIPTION
  This script will deploy a virtual network. 
  This script  requires an existing Azure subscription and Resource group.
.PARAMETER TenantId
    Required. Tenant ID ( you will also need username/password found in key vault)
  .PARAMETER ResourceGroupName
    Required. Name of existing Resource      
.PARAMETER VirtualNetworkName
    Required. Name of desired Virtual Network Name 
    Eg: [project]-[resource-type]-[environment]-[location]-[$VirutalNetworkName]
.PARAMETER SubNetName
    Required. Name of desired SubNet
.NOTES
  Version:        2
  Author:         Jennifer Villacis
  Creation Date:  01/27/21
  Purpose: Virtual Network Automation Script
#>

[cmdletbinding()]
Param(
    [Parameter(Mandatory=$true,HelpMessage='Enter your TenantId')]
    [string]
    $TenantId,
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
$Credential = Get-Credential
Connect-AzAccount -Credential $Credential -Tenant $TenantId -ServicePrincipal

# Get existing resource group
$Location= Get-AzResourceGroup -Name $ResourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue

#if errorVariable is notPresent VNet will not be created
if ($notPresent)
{
    Write-Output "Existing resource group not found"
}
else
{

#location selected resource group
$RGLocation= $Location.location

#file path for -TemplateFile
$FilePath = "./template.json"

#Hashtable containing parameters for virtual network template
$VirtualNetworkParameters= @{
    vnetName = ("nsc-vnet-dev-{0}-{1}-test" -f $RGLocation,$VirtualNetworkName).ToLower();
    subnet1Name = ($SubNetworkName).ToLower();
    location = $RGLocation;
} 

# Creates Virutal Network 
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $FilePath -TemplateParameterObject $VirtualNetworkParameters

}

