# APPLICATION GATEWAY USING CLI
    # This script recomments using current Azure CLI version

# PREREQUISITES
    # Use Azure Bash or PowerShell evironment.
    # If you're using a local installation, sign in to the Azure CLI by using the az login command.

# VARIABLES
    # SubcriptionID = "yourScriptionID"
    # TenantID = "yourTenantID"
    # resourceGroupName="yourResourceGroup"
    # appName="ApplicationGatewayName"
    # location="USWest2" 

# AUTHOR
    # Loan Pham
    
param(
    [Parameter(Mandatory=$true)]
    [string]
    $SubcriptionID,

    [Parameter(Mandatory=$true)]
    [string]
    $tenantID,

    [Parameter(Mandatory=$true)]
    [string]
    $ResourGroupName,

    [Parameter(Mandatory=$true)]
    [string]
    $Location,

    [Parameter(Mandatory=$true)]
    [string]
    $ApplicationGatewayName

)

# Sign in azure from powershell
Connect-AzAccount 

# Create Application Gateway
New-AzApplicationGateway -Name $ApplicationGatewayName -ResourceGroupName $ResourceGroupName  -Location  $Location

