<#
.SYNOPSIS
  Creates a virtual machine and network interfase with one line cmdlet.
.DESCRIPTION
  This script will deploy a virtual machine and network interface. 
  This script  requires an existing Azure subscription and Resource group.
.PARAMETER SubscriptionId
    Required. A subscription ID
.PARAMETER TenantId
    Required. A tenant ID
.PARAMETER ResourceGroupName
    Required. Name of Resource group, if already exists will ask if add VM to it   
.PARAMETER Location
    Required. Name of location of Resource eg: westus2     
.PARAMETER VirtualNetworkName
    Required. Existing name of desired Virtual Network Name 
.PARAMETER SubNetName
    Required. Existing Name of SubNet
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

    [Parameter(Mandatory=$True)]
    [string]
    $ServicePrincipalId,

    [Parameter(Mandatory=$True)]
    [string]
    $ServicePrincipalPassword,

    [Parameter(Mandatory=$True)]
    [string]
    $AdminUserNameVM,

    [Parameter(Mandatory=$True)]
    [string]
    $AdminStrongPasswordVM,

    [Parameter(Mandatory=$True)]
    [string]
    $ResourceGroupName,
    
    [Parameter(Mandatory=$True)]
    [string]
    $Location,

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

    [Parameter(Mandatory=$True)]
    [string]
    $PublicIpName
    
)

#Clears all prior sign ins
Clear-AzContext -Force 

#Signs in the user to Azure with service principal credential
$securePassword = ConvertTo-SecureString -String $ServicePrincipalPassword -AsPlainText -Force;
#$securePassword = $ServicePrincipalPassword
$Credential = New-Object -TypeName System.Management.Automation.PSCredential($ServicePrincipalId, $securePassword);
Connect-AzAccount -Credential $Credential -Tenant $TenantId -ServicePrincipal

#Sets the subscription ID correct so the resource group can be searched from the correct place
Set-AzContext -SubscriptionId $SubscriptionId


#attempts to retrieve the given resource group
$resourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue

# #checks if the resource group provided is valid
# if(!$resourceGroup) {
#     Write-Host “Resource group ‘$resourceGroupName’ does not exist. Creating a resource group with given name and location"
#     New-AzResourceGroup -Name $ResourceGroupName -Location $location }
 

# #checks if the VirtualNetworkName provided is valid
# if(!$VirtualNetworkName) {
#     Write-Host “Given Virtual Network Name ‘$VirtualNetworkName’ does not exist. Creating a Virtual Network Name with given name and location"
#     ../vnet/deploy-vnet.ps1
# }
# #checks if the Public Ip Name provided is valid
# if(!$PublicIpName) {
#     Write-Host “Given Public Ip Name ‘$PublicIpName’ does not exist. Creating a Public Ip Name with given name and location"
#     ../ip-address-script/create-ip.ps1
# }
# #checks if the Storage Name provided is valid
# if(!$StorageName) {
#     Write-Host “Given Storage Name ‘$StorageName’ does not exist. Creating a Storage Name with given name and location"
#     ../functions/create_azure_storageacct.ps1
# }


    
    

$vmparameters = @{
    publicIpName = ($PublicIpName).ToLower();  
    VmName = ($VirtualMachineName).ToLower();
    networkInterfaceName = ($NetworkInterfaceName).ToLower();
    virtualNetworkName = ($VirtualNetworkName).ToLower(); 
    subnetName = ($SubNetName).ToLower();
    resourceGroupName = ($ResourceGroupName).ToLower();
    subscriptionId = ($SubscriptionId).ToLower();
    adminUsernameVM = $AdminUserNameVM;
    adminPasswordVM = $AdminStrongPasswordVM;  
    
}

$templatePath = "./template.json"
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $templatePath -Location $location -TemplateParameterObject $vmparameters
#   }