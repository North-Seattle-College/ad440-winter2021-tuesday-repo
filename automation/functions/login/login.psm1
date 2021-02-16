function Login {
  param(
    [string] [Parameter(Mandatory = $true)] $TenantId,
    [string] [Parameter(Mandatory = $true)] $SPApplicationId,
    [string] [Parameter(Mandatory = $true)] $SPSecret,
    [string] [Parameter(Mandatory = $true)] $SubscriptionId
  )

  # If the Subscription Id is NOT null, the user is logged in
  $loggedIn = ((Get-AzContext).Tenant.Id -eq $TenantId)

  if ($loggedIn) {
    Write-Host("Already logged in")

    # Check we're on the correct Subscription
    $correctSub = (Get-AzContext).Subscription.Id -eq $SubscriptionId
    if ($correctSub) {
      Write-Host("Correct subscription")
    }
    else {
      Write-Host("Wrong subscription. Logging out...")
      Disconnect-AzAccount
      $loggedIn = False
    }

  } 
  if (!$loggedIn) {
    # Log In
    Write-Host("Logging in...")
    [securestring]$secureSecret = ConvertTo-SecureString $SPSecret -AsPlainText -Force      
    [pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($SPApplicationId, $secureSecret)
    Connect-AzAccount -ServicePrincipal -Credential $credObject -Tenant $TenantId      
    Write-Host "Logged into the account $ApplicationId"

    # Set Subscription
    Set-AzContext -Subscription $SubscriptionId
    Write-Host "Set to subscription $SubscriptionId"
  } 
}
Export-ModuleMember -Function 'Login'