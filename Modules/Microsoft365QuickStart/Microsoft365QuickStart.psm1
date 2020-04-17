function Set-Microsoft365QuickStartTemplate
{
    [CmdletBinding()]
    param (
        # Global Admin Account
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Write-Verbose "Establish cloud service connections"
    # ------------------------------- #
    # Connect to services
    # ------------------------------- #
    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform PowerPlatforms
    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform ExchangeOnline
    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform MSOnline
    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform SharePointOnline
    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform AzureAD
    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform SkypeForBusiness
    Test-MSCloudLogin -O365Credential $GlobalAdminAccount `
        -Platform MicrosoftTeams

    Write-Verbose "Login ended"

    # ------------------------------- #
    # Exchange Actions to...
    # ------------------------------- #

    # ------------------------------- #
    # Disable Bookings
    # ------------------------------- #
    Write-Verbose "Disable Bookings"

    Set-OrganizationConfig -BookingsEnabled $false `
        -BookingsPaymentsEnabled $false `
        -BookingsSocialSharingRestricted $false `
        -Verbose

    # ------------------------------- #
    # Disable AppsForOfficeEnabled
    # ------------------------------- #
    Write-Verbose "Disable Apps for Office"

    Set-OrganizationConfig -AppsForOfficeEnabled $false `
        -Verbose

    # ------------------------------- #
    # Disable Calendar Sharing
    # ------------------------------- #
    Write-Verbose "Disable calendar sharing"

    $orgConfig = Get-OrganizationConfig
    if ($null -eq $orgConfig)
    {
        Write-Verbose -Message "Can't find the information about the Organization Configuration."
    }
    else
    {
        if ($orgConfig.IsDehydrated -eq $true)
        {
            Enable-OrganizationCustomization -Verbose
        }
    }

    Set-SharingPolicy -Identity "Default Sharing Policy" -Enabled $false -Verbose


    # ------------------------------- #
    # Disable Self Service for Apps
    # ------------------------------- #
    Write-Verbose "Disable self services for trials"

    Set-MsolCompanySettings -AllowAdHocSubscriptions $false `
        -AllowEmailVerifiedUsers $false `
        -UsersPermissionToCreateLOBAppsEnabled $false `
        -UsersPermissionToUserConsentToAppEnabled $false `
        -Verbose

    # ------------------------------- #
    # SharePoint B2B Preview
    # ------------------------------- #
    Write-Verbose "Enable SP AAD B2B Preview"

    Import-Module -Name AzureAD -RequiredVersion 2.0.2.4 -Verbose
    $currentpolicy = Get-AzureADPolicy | Where-Object { $_.Type -eq 'B2BManagementPolicy' -and $_.IsOrganizationDefault -eq $true } | Select-Object -First 1
    if ($null -eq $currentpolicy)
    {
        $policyValue = @("{`"B2BManagementPolicy`":{`"PreviewPolicy`":{`"Features`":[`"OneTimePasscode`"]}}}")
        New-AzureADPolicy -Definition $policyValue -DisplayName B2BManagementPolicy -Type B2BManagementPolicy -IsOrganizationDefault $true
    }
    else
    {
        $policy = $currentpolicy.Definition | ConvertFrom-Json
        $features = [PSCustomObject]@{'Features' = @('OneTimePasscode') }; $policy.B2BManagementPolicy | Add-Member 'PreviewPolicy' $features -Force; $policy.B2BManagementPolicy
        $updatedPolicy = $policy | ConvertTo-Json -Depth 3
        Set-AzureADPolicy -Definition $updatedPolicy -Id $currentpolicy.Id
    }

    Set-SPOTenant -EnableAzureADB2BIntegration $true -SyncAadB2BManagementPolicy $true -Verbose



    # ------------------------------- #
    # Disable Self-Service Purchases in PowerAutomate and PowerApps
    # ------------------------------- #
    Write-Verbose "Disable PowerAutomate und PowerApps self services"

    Connect-MSCommerceAlpha -O365Credentials $GlobalAdminAccount -Verbose
    $product = Get-MSCommerceAlphaProductPolicies -PolicyId AllowSelfServicePurchase | Where-Object -FilterScript { $_.ProductName -match "Power Automate" }
    Update-MSCommerceAlphaProductPolicy -PolicyId AllowSelfServicePurchase -ProductId $product.ProductID -Enabled $false -Verbose

    # ------------------------------- #
    # Office 365 DSC Rollout
    # ------------------------------- #


    $dscResources = Get-DscResource -Module Microsoft365DSC
    $dscResourceNames = $dscResources | ForEach-Object { $_.Name }

    $configurationDataPath = Join-Path $PSScriptRoot `
        -ChildPath 'TenantConfiguration\M365TenantConfig.ps1'
    $configurationContent = Get-Content $configurationDataPath

    $tokens = [System.Management.Automation.PSParser]::Tokenize($configurationContent, [ref]$null)

    $definitionTokens = $tokens | Where-Object -FilterScript { $_.Type -eq 'Keyword' -and $_.Content -in $dscResourceNames }

    $result = @{ }

    $Credsglobaladmin = $GlobalAdminAccount

    foreach ($definitionToken in $definitionTokens)
    {
        $startIndex = [Array]::IndexOf($tokens, $definitionToken)
        $openParenthesis = 0;
        $startToken = $null;
        $endtoken = $null
        for ($i = $startIndex; $i -le $tokens.Count; $i++)
        {
            if ($tokens[$i].Type -eq "GroupStart")
            {
                $openParenthesis += 1
                if ($tokens[$i].Content -eq "{")
                {
                    $startToken = $tokens[$i]
                }
            }

            if ($tokens[$i].Type -eq "GroupEnd")
            {
                $openParenthesis -= 1
                if ($tokens[$i].Content -eq "}" -and $openParenthesis -eq 0)
                {
                    $endToken = $tokens[$i]
                    break;
                }
            }
        }
        $startIndex = $startToken.StartLine
        $endIndex = $endToken.StartLine - 1
        $lines = ""

        for ($i = $startIndex; $i -lt $endIndex; $i++)
        {
            $lines += $configurationContent[$i]
        }

        $lines = "@{$($lines)}"

        $scriptBlock = [scriptblock]::Create($lines)
        [string[]] $allowedCommands = @(
            'Import-LocalizedData', 'ConvertFrom-StringData', 'Write-Host', 'Out-Host', 'Join-Path'
        )
        [string[]] $allowedVariables = @('PSScriptRoot', 'Credsglobaladmin', 'ConfigurationData')
        $scriptBlock.CheckRestrictedLanguage($allowedCommands, $allowedVariables, $true)
        $params = & $scriptBlock

        #$params = Invoke-Expression $lines

        if ($result.ContainsKey($definitionToken.Content))
        {
            if ($result[$definitionToken.Content].GetType().BaseType.ToString() -eq "System.Array")
            {
                $result[$definitionToken.Content] += $params
            }
            else
            {
                $temp = $result[$definitionToken.Content]
                $result[$definitionToken.Content] = @()
                $result[$definitionToken.Content] += $temp
                $result[$definitionToken.Content] += $params
            }
        }
        else
        {
            $result.Add($definitionToken.Content, $params) | Out-Null
        }
    }

    foreach ($resourceName in $result.Keys)
    {
        $currentResource = $result[$resourceName]

        $currentResourceModule = $dscResources | Where-Object -FilterScript {
            $_.Name -eq $resourceName
        }
        Import-Module $currentResourceModule.Path -Verbose

        if ($currentResource.GetType().BaseType.ToString() -eq "System.Array")
        {
            foreach ($configuration in $currentResource)
            {
                try
                {
                    if (-not(Test-TargetResource @configuration -Verbose))
                    {
                        Set-TargetResource @configuration -Verbose
                    }
                }
                catch
                {
                    Write-Verbose $_
                }
            }
        }
        else
        {
            try
            {
                if (-not(Test-TargetResource @currentResource -Verbose))
                {
                    Set-TargetResource @currentResource -Verbose
                }
            }
            catch
            {
                Write-Verbose $_
            }
        }

        Get-Module $currentResourceModule.ResourceType | Remove-Module
    }


    # ------------------------------- #
    # PowerApps and PowerAutomate     #
    # ------------------------------- #

    Write-Verbose "Setting PowerApps restrictions"

    $newPolicy = New-AdminDlpPolicy -DisplayName "Data within Microsoft 365"

    Set-AdminDlpPolicy -PolicyName $newPolicy.PolicyName -SetNonBusinessDataGroupState Block

    $connectorsToBusinessDataGroupJSON = @'
         [
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_sharepointonline",
                  "name":  "SharePoint",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_onedriveforbusiness",
                  "name":  "OneDrive for Business",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_dynamicscrmonline",
                  "name":  "Dynamics 365",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_approvals",
                  "name":  "Approvals",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_azuread",
                  "name":  "Azure AD",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_commondataserviceforapps",
                  "name":  "Common Data Service (current environment)",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_excelonlinebusiness",
                  "name":  "Excel Online (Business)",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_flowmanagement",
                  "name":  "Power Automate Management",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_flowpush",
                  "name":  "Notifications",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_kaizala",
                  "name":  "Microsoft Kaizala",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_microsoftflowforadmins",
                  "name":  "Power Automate for Admins",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_microsoftforms",
                  "name":  "Microsoft Forms",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_microsoftformspro",
                  "name":  "Microsoft Forms Pro",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_microsoftgraphsecurity",
                  "name":  "Microsoft Graph Security",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_office365",
                  "name":  "Office 365 Outlook",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_office365groups",
                  "name":  "Office 365 Groups",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_office365users",
                  "name":  "Office 365 Users",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_office365video",
                  "name":  "Office 365 Video",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_onenote",
                  "name":  "OneNote (Business)",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_powerappsforadmins",
                  "name":  "Power Apps for Admins",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_powerappsforappmakers",
                  "name":  "Power Apps for Makers",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_powerappsnotification",
                  "name":  "Power Apps Notification",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_powerbi",
                  "name":  "Power BI",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_powerplatformforadmins",
                  "name":  "Power Platform for Admins",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_projectonline",
                  "name":  "Project Online",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_planner",
                  "name":  "Planner",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_signrequest",
                  "name":  "SignRequest",
                  "type":  "Microsoft.PowerApps/apis"
              },
              {
                  "id":  "/providers/Microsoft.PowerApps/apis/shared_staffhub",
                  "name":  "Microsoft StaffHub",
                  "type":  "Microsoft.PowerApps/apis"
},
{
    "id":  "/providers/Microsoft.PowerApps/apis/shared_todo",
    "name":  "Microsoft To-Do (Business)",
    "type":  "Microsoft.PowerApps/apis"
},
{
    "id":  "/providers/Microsoft.PowerApps/apis/shared_wdatp",
    "name":  "Microsoft Defender ATP",
    "type":  "Microsoft.PowerApps/apis"
},
{
    "id":  "/providers/Microsoft.PowerApps/apis/shared_webcontents",
    "name":  "HTTP with Azure AD",
    "type":  "Microsoft.PowerApps/apis"
},
{
    "id":  "/providers/Microsoft.PowerApps/apis/shared_wordonlinebusiness",
    "name":  "Word Online (Business)",
    "type":  "Microsoft.PowerApps/apis"
}
]
'@
    $connectorsToBusinessDataGroup = ConvertFrom-Json $connectorsToBusinessDataGroupJSON

    foreach ($connector in $connectorsToBusinessDataGroup)
    {
        try
        {
            $connectorName = $connector.id.Replace("/providers/Microsoft.PowerApps/apis/", "")
            Add-ConnectorToBusinessDataGroup -PolicyName $newPolicy.PolicyName `
                -ConnectorName $connectorName
        }
        catch
        {
            Write-Verbose "Error processing PowerApps Connector: $connector.id"
        }
    }
}
