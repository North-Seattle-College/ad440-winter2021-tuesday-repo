<# param(
    [Parameter(Mandatory = $True)]
    [string]
    $SubscriptionId,

    [Parameter(Mandatory = $True)]
    [string]
    $TenantId,

    [Parameter(Mandatory = $True)]
    [string]
    $ServicePrincipalId,

    [Parameter(Mandatory = $True)]
    [string]
    $ServicePrincipalPassword
)

$securePassword = ConvertTo-SecureString -String $ServicePrincipalPassword -AsPlainText -Force;
$credentials = New-Object -TypeName System.Management.Automation.PSCredential($ServicePrincipalId, $securePassword);

#sign into azure account  #>
Connect-AzAccount #-Credential $credentials -ServicePrincipal -Tenant $TenantId -SubscriptionId $SubscriptionId;

 

$parameters = @{
    appName="nsc-fun-dev-usw2-tuesday";
    storageName="nsctrdevusw2tuefun";
    applicationInsight='nsc-appins-dev-usw2-Tuesday';
    hostingPlan='nsc-asp-dev-usw2-tuesday';
    appInsightsLocation="West US 2"
}

#Will change this to NSC raw link after merge
$templateUri = "https://raw.githubusercontent.com/selinapn/ad440-winter2021-tuesday-repo/automationspn-sprint3/automation/functions/azuredeploy.json"
$resourceGroupName = "nsc-rg-dev-usw2-tuesday"

New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateUri $templateUri -TemplateParameterObject $parameters