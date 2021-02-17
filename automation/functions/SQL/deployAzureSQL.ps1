[cmdletbinding()]
param(
        #Subscription id, required to connect
        [Parameter(Mandatory = $True)]
        [string]
        $SubscriptionId, 

        #Tenant id, required to connect
        [Parameter(Mandatory = $True)]
        [string]
        $TenantId,  

        #Service Principal Application id, required to connect
        [Parameter(Mandatory = $True)]
        [string]
        $ServicePrincipalAppId,  

        #Service Principal Secret, required to connect
        [Parameter(Mandatory = $True)]
        [string]
        $ServicePrincipalSecret, 

        #Server name, doesn't need nsc, dev, or rg
        [Parameter(Mandatory = $True)]
        [string]
        $ResourceGroupName, 

        #Server name, doesn't need nsc, dev, or ss
        [Parameter(Mandatory = $True)]
        [string]
        $ServerName, 

        #Database Name, doesn't require nsc, dev, or db.
        [Parameter(Mandatory = $True)]
        [string]
        $DatabaseName, 

        #Required to create Database
        [Parameter(Mandatory = $True)]
        [string]
        $AdministratorLoginId, 

        #Needed for database security, has to be secured or will error out
        [Parameter(Mandatory = $True)]
        [secureString]
        $AdministratorLoginPassword, 

        #needed if resource group has to be created 
        [Parameter(Mandatory = $True)]
        [string]
        $Location
)

#Sign in
$securePassword = ConvertTo-SecureString -String $ServicePrincipalSecret -AsPlainText -Force;
$credentials = New-Object -TypeName System.Management.Automation.PSCredential($ServicePrincipalAppId, $securePassword)

Connect-AzAccount -Credential $credentials -ServicePrincipal -Tenant $TenantId -SubscriptionId $SubscriptionId

#convert $Location to lowercase
$location = $Location.ToLower()

# Parameters for the template
$parameters = @{
        serverName                 = $serverName;
        sqlDBName                  = $databaseName;
        administratorLogin         = $AdministratorLoginId;
        administratorLoginPassword = $AdministratorLoginPassword;
}

# Get proof the resource group exists.
Get-AzResourceGroup -Name $resourceGroupName -ErrorVariable nonexistent -ErrorAction SilentlyContinue

if ($nonexistent) {
        # ResourceGroup doesn't exist 

        #Create resource Group
        New-AzResourceGroup -Name $resourceGroupName -Location "$location"

        #New-AzResourceGroupDeployment
        New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile 'deployAzure.json' -TemplateParameterObject $parameters
}
else {
        # ResourceGroup exists 
        Write-Host "Resource group exists. Now creating SQL and DB." 
        New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -TemplateFile 'deployAzure.json' -TemplateParameterObject $parameters
}
