<#
.DESCRIPTION
  This script will network security group to the given resource group. 
  This script  requires an existing azure subscription and resource group.
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
    $SubscriptionId,     #Subscription ID to use

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
#Redirects the user to sign in to the Azure portal
Connect-AzAccount

#Sets the subscription ID correct so the resource group can be searched from the correct place
Set-AzContext -SubscriptionId $SubscriptionId

#attempts to retrieve the given resource group
$resourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue

#checks if the resource group provided is valid
if(!$resourceGroup) {
Write-Host “Resource group ‘$resourceGroupName’ does not exist. Creating a resource group with given name and location"
New-AzResourceGroup -Name $ResourceGroupName -Location $LocationForNetworkSecurityGroup }

#creates the network security group
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile $TemplateJsonFilePath 
