# # prompt for resource group name 
# $resourceGroupName = Read-Host -Prompt "Enter a resource group name that is used for generating resource names"
# # prompt for location
# $location = Read-Host -Prompt "Enter the location (like 'eastus' or 'northeurope')"
# $templateUri = "https://raw.githubusercontent.com/vq37vhr/ad440-winter2021-tuesday-repo/automation-psl/automation/functions/template.json"

# # create resource group based on user input
# New-AzResourceGroup -Name $resourceGroupName -Location "$location"
# New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri $templateUri


param(

    [Parameter(Mandatory = $True)]
    [string]
    $resourceGroupName, #Enter resource group name

    [Parameter(Mandatory = $True)]
    [string]
    $appName,

    [Parameter(Mandatory = $True)]
    [string]
    $storageName, #Enter storage name

    [Parameter(Mandatory = $True)]
    [string]
    $location, #Enter resource group location('westus2', 'westus')

    [Parameter(Mandatory = $True)]
    [string]
    $templateFile  #Path of the template.json file

)

#Redirects the user to sign in to the Azure portal 
Connect-AzAccount  

#retrieve the given resource group
Get-AzResourceGroup -Name $resourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent) {
    New-AzResourceGroup -Name $resourceGroupName -Location $location 
}

#creates the azure function group
New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile $templateFile