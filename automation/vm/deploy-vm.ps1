<#
.SYNOPSIS
  Creates a virtual machine and network interfase with one line cmdlet.
.DESCRIPTION
  This script will deploy a virtual machine and network interfase. 
  This script  requires an existing Azure subscription and Resource group.
.PARAMETER ResourceGroupName
    Required. Name of Resource group, if already exists will ask if add VM to it   
.PARAMETER Location
    Required. Name of location of Resource eg: westus2     
.PARAMETER VirtualNetworkName
    Required. Existing name of desired Virtual Network Name Eg: [project]-[resource-type]-[environment]-[location]-[other-stuff]
.PARAMETER SubNetName
    Required. Existing Name of desired SubNet
.PARAMETER VirtualMachineName
    Required. Desired name for virtual machine
.PARAMETER NetworkInterfaceName
    Required. Desired name for network interface
.PARAMETER PublicIpName
    Required. Existing public Ip address
.NOTES
  Version:        2.0
  Author:         Joanna Gromadzka
  Creation Date:  01/31/21
  Purpose: VM creation Script

#>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$True)]
    [string]
    $SubscriptionId,

    [Parameter(Mandatory=$True)]
    [string]
    $TenantId,

    [Parameter(Mandatory=$False)]
    [string]
    $ServicePrincipalId,

    [Parameter(Mandatory=$False)]
    [SecureString]
    $ServicePrincipalPassword,

    [Parameter(Mandatory=$True)]
    [string]
    $ResourceGroupName,
    
    [Parameter(Mandatory=$True)]
    [string]
    $Location,

    [Parameter(Mandatory=$False)]
    [string]
    $TemplatePath,

    [Parameter(Mandatory=$False)]
    [string]
    $ParamFilePath,

    [Parameter(Mandatory=$True)]
    [string]
    $VirtualMachineName,

    [Parameter(Mandatory=$True)]
    [string]
    $NetworkInterfaceName,  

    [Parameter(Mandatory=$True)]
    [string]
    $VirtualNetworkName,

    [Parameter(Mandatory=$True)]
    [string]
    $SubNetName,

    [Parameter(Mandatory=$False)]
    [string]
    $SecurityGroupName,

    [Parameter(Mandatory=$True)]
    [string]
    $PublicIpName,

    [Parameter(Mandatory=$False)]
    [string]
    $PublicIpAddress,

    [Parameter(Mandatory=$True)]
    [string]
    $StorageName
    
    
)

#To login to azure from powershell use the following
Connect-AzAccount | Out-Null




$vmparameters = @{
    publicIpName = ($PublicIpName).ToLower();  
    VMName = ($VirtualMachineName).ToLower();
    networkInterfaceName = ($NetworkInterfaceName).ToLower();
    virtualNetworkName = ($VirtualNetworkName).ToLower(); 
    subnetName = ($SubNetName).ToLower();
    # storageName = 
}
$today = Get-Date -Format "MM-dd-yyyy"
$templatePath = "./template.json"
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $templatePath -Location $location -TemplateParameterObject $vmparameters