# Microsoft 365 Quick Start Template

This starter kit provides basic and very restrictive settings for a new Microsoft 365 tenant.

## QuickStart How-To

1. Download this repository as .zip file and extract it to a place of your choice.
2. Install the required Microsoft365DSC module
3. Import the Microsoft365QuickStart module
4. Create a credential object
5. Call the Set-Microsoft365QuickStart cmdlet

Please make sure to have logged into <https://admin.powerapps.com/environments> prior to using this module.

The following steps need to be perfomed to start the configuration:

```powershell
Install-Module -Name Microsoft365DSC -RequiredVersion 1.0.4.39
Import-Module <Path to Microsoft365QuickStart.psd1>

$credentials = Get-Credential # This will promot for your global admin credentials

Set-Microsoft365QuickStartTemplate -GolbalAdminAccount $credentials -Verbose
```

## Settings overview

### Automatically applied settings

These settings are applied automatically
Microsoft 365 Area | Settings
-----|-----
Apps for Office | disabled
Azure B2B Preview for SharePoint and OneDrive | enabled
Calendar sharing | disabled
Connecotrs in PowerApps and PowerAutomate | limited to Microsoft 365 connectors
Microsoft Bookings | disabled
Office 365 Groups | disabled guests
OneDrive | Storage limit to 1 GB
Self Service Trials | disabled
Self Service Purchases in PowerApps and PowerAutomate | disabled
SharePoint Sharing | limited to organization
SharePoint UserVoice | disabled
Teams | disabled guest access

### Custom Settings within Microsoft 365 Admin Center

These settings should be set manually within the Microsoft 365 Admin Center

Microsoft 365 Admin Center Area | Url | Settings
-----|-----|-----
MyAnalytics | <https://admin.microsoft.com/Adminportal/Home#/Settings/Services/:/Settings/L1/MyAnalytics> | All settings should be disabled
‎Office‎ software download settings | <https://admin.microsoft.com/Adminportal/Home#/Settings/Services/:/Settings/L1/SoftwareDownload> | All settings should be disabled
SharePoint Site Creation and Timezone | <https://***REMOVED***-admin.sharepoint.com/_layouts/15/online/AdminHome.aspx#/settings> | Set the most appropriate timezone
Sway | <https://admin.microsoft.com/Adminportal/Home#/Settings/Services/:/Settings/L1/Sway> | All settings should be disabled
User owned apps and services | <https://admin.microsoft.com/Adminportal/Home#/Settings/Services/:/Settings/L1/Store> | All settings should be disabled
Whiteboard | <https://admin.microsoft.com/Adminportal/Home#/Settings/Services/:/Settings/L1/Whiteboard> | All settings should be disabled

### Custom Settings within Azure Active Directory

These settings should be set manually within Azure Active Directory

Azure Active Directory Area | Url | Settings
-----|-----|-----
Organizazionl Relationships | <https://portal.azure.com/#blade/Microsoft_AAD_IAM/CompanyRelationshipsMenuBlade/Settings> | These settings should be set to 'No': `Admins and users in the guest inviter role can invite`; `Members can invite`, `Guests can invite`
