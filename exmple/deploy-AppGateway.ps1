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
    [Parameter(Madatory=$true)]
    [string]
    $SubcriptionID,

    [Parameter(Madatory=$true)]
    [string]
    $tenantID,

    [Parameter(Madatory=$true)]
    [string]
    $ResourGroupName,

    [Parameter(Madatory=$true)]
    [string]
    $Location,

    [Parameter(Madatory=$true)]
    [string]
    $ApplicationGatewayName,

)

# Sign in azure from powershell
Connect-AzAccount 

# Create Application Gateway
New-AzApplicationGateway -Name $ApplicationGatewayName -ResourceGroupName $ResourceGroupName  -Location  $Location

