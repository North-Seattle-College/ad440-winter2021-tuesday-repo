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
    $Location,            #Resource group location

    [Parameter(Mandatory=$True)]
    [string]
    $NetworkSecurityGroupName  #Network Secutiry Name to create
)
#Redirects the user to sign in to the Azure portal
Connect-AzAccount

#Sets the subscription ID correct so the resource group can be searched from the correct place
Set-AzContext -SubscriptionId $SubscriptionId

#creates the network security group
New-AzNetworkSecurityGroup -Name $NetworkSecurityGroupName -ResourceGroupName $ResourceGroupName  -Location  $Location
