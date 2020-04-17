################################
# Start: Internal use functions
################################

function Get-AccessTokenFromSessionData()
{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [System.Management.Automation.SessionState]
    $SessionState
  )

  $token = Get-MSCommerceAlphaConnectionInfo -SessionState $SessionState

  $token
}

function Get-MSCommerceAlphaConnectionInfo
{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [System.Management.Automation.SessionState]
    $SessionState
  )

  if ($null -eq $sessionState.PSVariable)
  {
    throw "unable to access SessionState. PSVariable, Please call Connect-MSCommerceAlpha before calling any other Powershell CmdLet for the MSCommerceAlpha Module"
  }

  $token = $sessionState.PSVariable.GetValue("token");

  if ($null -eq $token)
  {
    throw "You must call the Connect-MSCommerceAlpha cmdlet before calling any other cmdlets"
  }

  return $token
}

function HandleError()
{
  param(
    [Parameter(Mandatory = $true)]
    $ErrorContext,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $CustomErrorMessage
  )

  $errorMessage = $ErrorContext.Exception.Message
  $errorDetails = $ErrorContext.ErrorDetails.Message

  if ($_.Exception.Response.StatusCode -eq 401)
  {
    Write-Error "Your credentials have expired. Please, call Connect-MSCommerceAlpha again to regain access to MSCommerceAlpha Module."

    return
  }

  Write-Error "$CustomErrorMessage, ErrorMessage - $errorMessage ErrorDetails - $errorDetails"
}

################################
# End: Internal use functions
################################


################################
# Start: Exported functions
################################

<#
    .SYNOPSIS
    Method to connect to MSCommerceAlpha with the credentials specified
#>
function Connect-MSCommerceAlpha()
{
  [CmdletBinding()]
  param(
    [string]
    $ClientId = "3d5cffa9-04da-4657-8cab-c7f074657cad",

    [Uri]
    $RedirectUri = [uri] "http://localhost/m365/commerce",

    [string]
    $Resource = "aeb86249-8ea3-49e2-900b-54cc8e308f85", #LicenseManager App Id,

    [PSCredential]
    $O365Credentials
  )

  $authorityUrl = "https://login.windows.net/common"


  if ($PSBoundParameters.ContainsKey("O365Credentials"))
  {
    Import-Module 'Microsoft.PowerApps.Administration.PowerShell' -Force
    $authContext = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext("https://login.windows.net/common");
    $credential = [Microsoft.IdentityModel.Clients.ActiveDirectory.UserCredential]::new($O365Credentials.Username, $O365Credentials.Password)
    $token = $authContext.AcquireToken($Resource, $ClientId, $credential)
  }
  else
  {
    $authCtx = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext" $authorityUrl

    $platformParams = New-Object "Microsoft.IdentityModel.Clients.ActiveDirectory.PlatformParameters" ([Microsoft.IdentityModel.Clients.ActiveDirectory.PromptBehavior]::Auto)

    $token = $authCtx.AcquireTokenAsync($Resource, $ClientId, $RedirectUri, $platformParams).Result

  }
  if ($null -eq $token)
  {
    Write-Error "Unable to establish connection"

    return
  }

  $sessionState = $PSCmdlet.SessionState

  $sessionState.PSVariable.Set("token", $token)

  Write-Output "Connection established successfully"
}

<#
    .SYNOPSIS
    Method to retrieve configurable policies
#>
function Get-MSCommerceAlphaPolicies()
{
  [CmdletBinding()]
  param()

  $token = Get-AccessTokenFromSessionData -SessionState $PSCmdlet.SessionState
  $correlationId = New-Guid
  $baseUri = "https://licensing.m365.microsoft.com"

  $restPath = "$baseUri/v1.0/policies"

  try
  {
    $response = Invoke-RestMethod `
      -Method GET `
      -Uri $restPath `
      -Headers @{
      "x-ms-correlation-id" = $correlationId
      "Authorization"       = "Bearer $($token.AccessToken)"
    }

    foreach ($policy in $response.items)
    {
      New-Object PSObject -Property @{
        PolicyId     = $policy.id
        Description  = $policy.description
        DefaultValue = $policy.defaultValue
      }
    }
  }
  catch
  {
    HandleError -ErrorContext $_ -CustomErrorMessage "Failed to retrieve policies"
  }
}

<#
    .SYNOPSIS
    Method to retrieve a description of the specified policy
#>
function Get-MSCommerceAlphaPolicy()
{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $PolicyId
  )

  $token = Get-AccessTokenFromSessionData -SessionState $PSCmdlet.SessionState
  $correlationId = New-Guid
  $baseUri = "https://licensing.m365.microsoft.com"

  $restPath = "$baseUri/v1.0/policies/$PolicyId"

  try
  {
    $response = Invoke-RestMethod `
      -Method GET `
      -Uri $restPath `
      -Headers @{
      "x-ms-correlation-id" = $correlationId
      "Authorization"       = "Bearer $($token.AccessToken)"
    }

    New-Object PSObject -Property @{
      PolicyId     = $response.id
      Description  = $response.description
      DefaultValue = $response.defaultValue
    }
  }
  catch
  {
    HandleError -ErrorContext $_ -CustomErrorMessage "Failed to retrieve policy with PolicyId '$PolicyId'"
  }
}

<#
    .SYNOPSIS
    Method to retrieve applicable products for the specified policy and their current settings
#>
function Get-MSCommerceAlphaProductPolicies()
{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $PolicyId
  )

  $token = Get-AccessTokenFromSessionData -SessionState $PSCmdlet.SessionState
  $correlationId = New-Guid
  $baseUri = "https://licensing.m365.microsoft.com"

  $restPath = "$baseUri/v1.0/policies/$PolicyId/products"

  try
  {
    $response = Invoke-RestMethod `
      -Method GET `
      -Uri $restPath `
      -Headers @{
      "x-ms-correlation-id" = $correlationId
      "Authorization"       = "Bearer $($token.AccessToken)"
    }

    foreach ($product in $response.items)
    {
      New-Object PSObject -Property @{
        PolicyId    = $product.policyId
        ProductName = $product.productName
        ProductId   = $product.productId
        PolicyValue = $product.policyValue
      }
    }
  }
  catch
  {
    HandleError -ErrorContext $_ -CustomErrorMessage "Failed to retrieve product policy with PolicyId '$PolicyId'"
  }
}

<#
    .SYNOPSIS
    Method to retrieve the current setting for the policy for the specified product
#>
function Get-MSCommerceAlphaProductPolicy()
{
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $PolicyId,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $ProductId
  )

  $token = Get-AccessTokenFromSessionData -SessionState $PSCmdlet.SessionState
  $correlationId = New-Guid
  $baseUri = "https://licensing.m365.microsoft.com"

  $restPath = "$baseUri/v1.0/policies/$PolicyId/products/$ProductId"

  try
  {
    $response = Invoke-RestMethod `
      -Method GET `
      -Uri $restPath `
      -Headers @{
      "x-ms-correlation-id" = $correlationId
      "Authorization"       = "Bearer $($token.AccessToken)"
    }

    New-Object PSObject -Property @{
      PolicyId    = $response.policyId
      ProductName = $response.productName
      ProductId   = $response.productId
      PolicyValue = $response.policyValue
    }
  }
  catch
  {
    HandleError -ErrorContext $_ -CustomErrorMessage "Failed to retrieve product policy with PolicyId '$PolicyId' ProductId '$ProductId'"
  }
}

<#
    .SYNOPSIS
    Method to modify the current setting for the policy for the specified product
#>
function Update-MSCommerceAlphaProductPolicy()
{
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
  param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $PolicyId,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $ProductId,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] $Enabled
  )

  if ("True" -ne $Enabled -and "False" -ne $Enabled)
  {
    Write-Error "Value of `$Enabled must be one of the following: `$True, `$true, `$False, `$false"
    return
  }

  $token = Get-AccessTokenFromSessionData -SessionState $PSCmdlet.SessionState
  $correlationId = New-Guid
  $baseUri = "https://licensing.m365.microsoft.com"

  $restPath = "$baseUri/v1.0/policies/$PolicyId/products/$ProductId"
  $enabledStr = if ("True" -eq $Enabled -or "true" -eq $Enabled)
  { "Enabled"
  }
  else
  { "Disabled"
  }
  $body = @{
    policyValue = $enabledStr
  }

  if ($False -eq $PSCmdlet.ShouldProcess("ShouldProcess?"))
  {
    Write-Output "Updating product policy aborted"

    return
  }

  try
  {
    $response = Invoke-RestMethod `
      -Method PUT `
      -Uri $restPath `
      -Body ($body | ConvertTo-Json)`
      -ContentType 'application/json' `
      -Headers @{
      "x-ms-correlation-id" = $correlationId
      "Authorization"       = "Bearer $($token.AccessToken)"
    }

    Write-Output "Update policy product success"
    New-Object PSObject -Property @{
      PolicyId    = $response.policyId
      ProductName = $response.productName
      ProductId   = $response.productId
      PolicyValue = $response.policyValue
    }
  }
  catch
  {
    HandleError -ErrorContext $_ -CustomErrorMessage "Failed to update product policy"
  }
}

################################
# End: Exported functions
################################

Write-Output "MSCommerceAlpha module loaded"
