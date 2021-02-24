<#
.DESCRIPTION
  This script will create a public IPv4 address.
  This script requires an existing azure subscription.
.PARAMETER SubscriptionId
    Required. A subscription ID
.PARAMETER TenantId
    Required. A tenant ID
.PARAMETER ResourceGroupName
    Required. Name of existing Resource group
.PARAMETER ServicePrincipalId
    Required. ID for the service principal
.PARAMETER ServicePrincipalPassword
    Required. Password for the service principal
.PARAMETER IpName
    Suggested. Desired name of the IP address
.PARAMETER IpVersion
    Suggested. The type of IP, such as IPv4 or IPv6
.PARAMETER IpMethod
    Suggested. The allocation method, static or dynamic
.PARAMETER ResourceLocation
    Suggested. The location of the resource, such as westus2, if the resource group does not exist.
.NOTES
  Version:        2.0
  Author:         Derek Hendrick
  Creation Date:  01/30/21
  Purpose: IP Address Automation
#>

#These are the different inputs for the command. Not all are required.
[CmdletBinding()]
param (
    [Parameter(Mandatory=$True)]
    [string]
    $SubscriptionId,

    [Parameter(Mandatory=$True)]
    [string]
    $TenantId,

    [Parameter(Mandatory=$True, HelpMessage='The name of the resource group this is being added to.')]
    [string]
    $ResourceGroupName,

    [Parameter(Mandatory=$True, HelpMessage='The service principal ID')]
    [string]
    $ServicePrincipalId,

    [Parameter(Mandatory=$True, HelpMessage='The service principal password')]
    [string]
    $ServicePrincipalPassword,

    [Parameter(Mandatory=$False, HelpMessage='The name of the IP address.')]
    [string]
    $IpName,

    [Parameter(Mandatory=$False, HelpMessage='IPv4 or IPv6.')]
    [string]
    $IpVersion,

    [Parameter(Mandatory=$False, HelpMessage='The allocation method, static or dynamic.')]
    [string]
    $IpMethod,

    [Parameter(Mandatory=$False, HelpMessage='The location of the resource.')]
    [string]
    $ResourceLocation
)

#Clears all prior sign ins
Clear-AzContext -Force 

#Signs in the user to Azure with service principal credential
Write-Host Signing in using service principal
$securePassword = ConvertTo-SecureString -String $ServicePrincipalPassword -AsPlainText -Force;
$Credential = New-Object -TypeName System.Management.Automation.PSCredential($ServicePrincipalId, $securePassword);
Connect-AzAccount -Credential $Credential -Tenant $TenantId -ServicePrincipal -SubscriptionId $SubscriptionId

# Get existing resource group
$Location = Get-AzResourceGroup -Name $ResourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue

#function to create a New Resource Group if needed
function CreateNewRG {
  [cmdletbinding()]
  param (
    [Parameter(Mandatory = $true, HelpMessage = 'Desired Location of Resource group')]
    [ValidateNotNullOrEmpty()]
    [string]
    $Location
  )
  New-AzResourceGroup -Name $ResourceGroupName -Location $ResourceLocation
}

#if errorVariable is notPresent VNet will not be created, and will prompt user 
#to create a new resource group
if ($notPresent) {
  Write-Output "Existing resource group not found, creating new"
  CreateNewRG
  # Get existing resource group
  $Location = Get-AzResourceGroup -Name $ResourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue
}

#location selected resource group
$RGLocation = $Location.location

#file path for -TemplateFile
$FilePath = "./template.json"

#Hashtable containing parameters for virtual network template
$IpParameters = @{
  serverLocation    = $RGLocation;
}

#These set the parameters as required if they are set.
if ($IpName){
  $IpParameters = @{
    ipName      = $ipName;
  }
}
if ($IpVersion){
  $IpParameters = @{
    ipVersion      = $ipVersion;
  }
}
if ($IpMethod){
  $IpParameters = @{
    ipMethod      = $ipMethod;
  }
}

#deploying IP address
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $FilePath -TemplateParameterObject $IpParameters

#Clearing the account after
Clear-AzContext -Force 