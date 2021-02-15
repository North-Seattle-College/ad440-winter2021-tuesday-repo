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

    # [Parameter(Mandatory=$True)]
    # [string]
    # $templateFile,  #Path of the template.json file,
    
    [Parameter(Mandatory=$True)]
    [string]
    $servicePrincipalId,

    [Parameter(Mandatory=$True)]
    [string]
    $servicePrincipalPassword,


    [Parameter(Mandatory=$True)]
    [string]
    $subscriptionId,

    [Parameter(Mandatory=$True)]
    [string]
    $tenantId

)
$templateUri = "https://raw.githubusercontent.com/North-Seattle-College/ad440-winter2021-tuesday-repo/development/automation/function-automation/template.json"
$securePassword = ConvertTo-SecureString -String $servicePrincipalPassword -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential($servicePrincipalId, $securePassword) 

#Connect to the account using the information 
Connect-AzAccount -Credential $credentials -ServicePrincipal -Tenant $tenantId -SubscriptionId $subscriptionId

#retrieve the given resource group
Get-AzResourceGroup -Name $resourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent)
{
    New-AzResourceGroup -Name $resourceGroupName -Location $location 
}

#creates the azure function group
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri  $templateUri 
