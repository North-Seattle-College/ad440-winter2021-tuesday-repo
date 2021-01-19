#this script creates a network secutiry group to an existing resource group
param(
    [Parameter(Mandatory=$True)]
    [string]
    $SubscriptionId,     #Subscription ID to use

    [Parameter(Mandatory=$True)]
    [string]
    $TenantId,           #Tenant ID to use

    [Parameter(Mandatory=$True)]
    [string]
    $ServicePrincipalId,

    [Parameter(Mandatory=$True)]
    [string]
    $ServicePrincipalPassword,

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

New-AzNetworkSecurityGroup -Name $NetworkSecurityGroupName -ResourceGroupName $ResourceGroupName  -Location  $Location
