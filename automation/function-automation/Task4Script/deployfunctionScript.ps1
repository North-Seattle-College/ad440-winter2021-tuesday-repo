param(


    [Parameter(Mandatory=$True)]
    [string]
    $resourceGroupName,   #Enter resource group name

    [Parameter(Mandatory=$True)]
    [string]
    $appName,

    [Parameter(Mandatory=$True)]
    [string]
    $storageName,   #Enter storage name

    [Parameter(Mandatory=$True)]
    [string]
    $location,     #Enter resource group location('westus2', 'westus')

    [Parameter(Mandatory=$True)]
    [string]
    $templateFile  #Path of the template.json file



)
# $securePassword = ConvertTo-SecureString -String $servicePrincipalPassword -AsPlainText -Force;
# $credentials = New-Object -TypeName System.Management.Automation.PSCredential($servicePrincipalId, $securePassword);

#Redirects the user to sign in to the Azure portal -Credential $credentials -ServicePrincipal -Tenant $tenantId -SubscriptionId $subscriptionId;
Connect-AzAccount  

#retrieve the given resource group
#$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName 
Get-AzResourceGroup -Name $resourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent)
{
    New-AzResourceGroup -Name $resourceGroupName -Location $location 
}

#creates the azure function group
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFile -Location $location