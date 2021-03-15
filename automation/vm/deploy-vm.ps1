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
Write-Host Signing in using service principal
$securePassword = ConvertTo-SecureString -String $ServicePrincipalPassword -AsPlainText -Force;
$Credential = New-Object -TypeName System.Management.Automation.PSCredential($ServicePrincipalId, $securePassword);
Connect-AzAccount -Credential $Credential -Tenant $TenantId -ServicePrincipal -SubscriptionId $SubscriptionId



Get-AzResourceGroup -Name $ResourceGroupName -ErrorVariable notPresentRG -ErrorAction SilentlyContinue
#checks if provided resources are existing if not create a new group or other resources by running scripts from the same directory
if($notPresentRG){
    Write-Host 'Resource group "$ResourceGroupName" does not exist. Creating a resource group with given name and location'
    New-AzResourceGroup -ResourceGroupName "$ResourceGroupName" -Location $location
    Write-Host $ResourceGroupName

    #create  vnet
    Write-Host 'Creating a "$VirtualNetworkName" in new group with given name and location'
    & "../vnet/deploy-vnet.ps1"
    #Import-PowerShellDataFile -Path "../vnet/deploy-vnet.ps1" 
    Write-Host $VirtualNetworkName
    
    #create public Ip 
    Write-Host 'Creating a "$PublicIpName" in new group with given name and location'
    & "../ip-address-script/create-ip.ps1" 
    Write-Host $PublicIpName

    #create network interface
    Write-Host 'Creating a "$NetworkInterfaceName" in new group with given name and location'
    & "./deploy-vm.ps1" 
    Write-Host $NetworkInterfaceName
} elseif (!$VirtualNetworkName) {
    #checks if the VirtualNetworkName provided is valid
    Write-Host 'Given Virtual Network Name ‘$VirtualNetworkName’ does not exist. Creating a Virtual Network Name with given name and location'
    & "../vnet/deploy-vnet.ps1"
    Write-Host $VirtualNetworkName
} elseif (!$PublicIpName) {
    Write-Host 'Given Public Ip Name ‘$PublicIpName’ does not exist. Creating a Public Ip Name with given name and location'
    $PublicIpName = $IpName
    & "../ip-address-script/create-ip.ps1" 
    Write-Host $PublicIpName
} elseif(!$NetworkInterfaceName) {
    #checks if the NetworkInterface Name provided is valid
    Write-Host 'Given Public Ip Name ‘$NetworkInterfaceName’ does not exist. Creating a Public Ip Name with given name and location'
    & "./deploy-vm.ps1" 
    Write-Host $NetworkInterfaceName
} else {  
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
    Write-Host 'Creating VM ...'
    New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $templatePath -Location $location -TemplateParameterObject $vmparameters
}