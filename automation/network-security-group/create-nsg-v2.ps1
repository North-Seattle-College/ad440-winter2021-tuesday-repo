<#
.DESCRIPTION
  This script will network security group to the given resource group. 
  This script  requires an existing azure subscription and resource group.
.PARAMETER SubscriptionId
    Required. Subscription Id of Azure
.PARAMETER TenantId
    Required. Tenant Id of Azure
.PARAMETER ResourceGroupName
    Required. Name of existing Resource group
.PARAMETER Location
    Required. Location of the NSG to be created
.PARAMETER NetworkSecurityGroupName
    Required. Desired name of the network security group
.PARAMETER TemplateJsonFileAbsolutePath
    Required. Path of the template.json file
.NOTES
  Version:        1.0
  Author:         Juno Munkhkhurel
  Creation Date:  01/18/21
  Purpose: Network security group automation script
#>
[cmdletbinding()]
param(
    [Parameter(Mandatory=$True)]
    [string]
    $SubscriptionId,     #Subscription ID to use from Azure

    [Parameter(Mandatory=$True)]
    [string]
    $TenantId,     #Tenant ID to use from Azure

    [Parameter(Mandatory=$True)]
    [string]
    $ResourceGroupName,   #Resource group name to add the network secutiry group into

    [Parameter(Mandatory=$True)]
    [string]
    $LocationForNetworkSecurityGroup,     #Resource group location

    [Parameter(Mandatory=$True)]
    [string]
    $TemplateJsonFilePath  #Path of the template.json file, either absolute or relative

)

#clears azure contaxt to ensure proper authentication
Clear-AzContext -Force 

#Signs in the user to Azure with credentials
$Credential = Get-Credential
Connect-AzAccount -Credential $Credential -Tenant $TenantId -ServicePrincipal

#Sets the subscription ID correct so the resource group can be searched from the correct place
Set-AzContext -SubscriptionId $SubscriptionId

#attempts to retrieve the given resource group
$resourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue

#checks if the resource group provided is valid
if(!$resourceGroup) {
Write-Host “Resource group ‘$resourceGroupName’ does not exist. Creating a resource group with given name and location"
New-AzResourceGroup -Name $ResourceGroupName -Location $LocationForNetworkSecurityGroup }

$testPath = Test-Path -Path $TemplateJsonFilePath

#checks the file path and asks again until the path is correct
while (!$testPath) {
Write-Host “File path ‘$TemplateJsonFilePath’ is not correct. Please try again"
$TemplateJsonFilePath = Read-Host "Please enter a valid template.json path: "
$testPath = Test-Path -Path $TemplateJsonFilePath
}

#creates the network security group
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateJsonFilePath

#clears azure contaxt to ensure proper authentication
Clear-AzContext -Force 



