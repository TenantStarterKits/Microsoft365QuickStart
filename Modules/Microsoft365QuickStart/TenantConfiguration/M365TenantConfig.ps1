param (
    [parameter()]
    [System.Management.Automation.PSCredential]
    $GlobalAdminAccount
)

Configuration O365TenantConfig
{
    param (
        [parameter()]
        [System.Management.Automation.PSCredential]
        $GlobalAdminAccount
    )

    Import-DscResource -ModuleName Microsoft365DSC

    $OrganizationName = $Credsglobaladmin.UserName.Split('@')[1]

    Node localhost
    {
        AADGroupsNamingPolicy 3f052f7a-027b-4b1f-99bd-927c37bd8cf9
        {
            CustomBlockedWordsList        = @();
            Ensure                        = "Present";
            GlobalAdminAccount            = $Credsglobaladmin;
            IsSingleInstance              = "Yes";
            PrefixSuffixNamingRequirement = "";
        }

        AADGroupsSettings 5274fe50-4597-4532-bc4b-ff4d077d4fa5
        {
            AllowGuestsToAccessGroups     = $False;
            AllowGuestsToBeGroupOwner     = $False;
            AllowToAddGuests              = $False;
            EnableGroupCreation           = $True;
            Ensure                        = "Present";
            GlobalAdminAccount            = $Credsglobaladmin;
            GuestUsageGuidelinesUrl       = "";
            IsSingleInstance              = "Yes";
            UsageGuidelinesUrl            = "";
        }

        EXOOrganizationConfig d93917fc-6e1b-4919-8332-4eda96f3b191
        {
            ActivityBasedAuthenticationTimeoutEnabled                 = $True;
            ActivityBasedAuthenticationTimeoutInterval                = "06:00:00";
            ActivityBasedAuthenticationTimeoutWithSingleSignOnEnabled = $True;
            AppsForOfficeEnabled                                      = $False;
            AsyncSendEnabled                                          = $True;
            AuditDisabled                                             = $False;
            AutoExpandingArchive                                      = $False;
            BookingsEnabled                                           = $False;
            BookingsPaymentsEnabled                                   = $False;
            BookingsSocialSharingRestricted                           = $False;
            ByteEncoderTypeFor7BitCharsets                            = 0;
            ConnectorsActionableMessagesEnabled                       = $True;
            ConnectorsEnabled                                         = $True;
            ConnectorsEnabledForOutlook                               = $True;
            ConnectorsEnabledForSharepoint                            = $True;
            ConnectorsEnabledForTeams                                 = $True;
            ConnectorsEnabledForYammer                                = $True;
            DefaultAuthenticationPolicy                               = $null;
            DefaultGroupAccessType                                    = "Private";
            DefaultPublicFolderAgeLimit                               = $null;
            DefaultPublicFolderDeletedItemRetention                   = "30.00:00:00";
            DefaultPublicFolderIssueWarningQuota                      = "1.7 GB (1,825,361,920 bytes)";
            DefaultPublicFolderMaxItemSize                            = "Unlimited";
            DefaultPublicFolderMovedItemRetention                     = "7.00:00:00";
            DefaultPublicFolderProhibitPostQuota                      = "2 GB (2,147,483,648 bytes)";
            DirectReportsGroupAutoCreationEnabled                     = $False;
            DistributionGroupDefaultOU                                = $null;
            DistributionGroupNameBlockedWordsList                     = @();
            DistributionGroupNamingPolicy                             = "";
            ElcProcessingDisabled                                     = $False;
            EndUserDLUpgradeFlowsDisabled                             = $False;
            EwsAllowMacOutlook                                        = $null;
            EwsAllowOutlook                                           = $null;
            EwsEnabled                                                = $null;
            ExchangeNotificationEnabled                               = $True;
            ExchangeNotificationRecipients                            = @();
            FocusedInboxOn                                            = $null;
            GlobalAdminAccount                                        = $Credsglobaladmin;
            HierarchicalAddressBookRoot                               = $null;
            IPListBlocked                                             = @();
            IsSingleInstance                                          = "Yes";
            LeanPopoutEnabled                                         = $False;
            LinkPreviewEnabled                                        = $True;
            MailTipsAllTipsEnabled                                    = $True;
            MailTipsExternalRecipientsTipsEnabled                     = $False;
            MailTipsGroupMetricsEnabled                               = $True;
            MailTipsLargeAudienceThreshold                            = 25;
            MailTipsMailboxSourcedTipsEnabled                         = $True;
            OAuth2ClientProfileEnabled                                = $True;
            OutlookMobileGCCRestrictionsEnabled                       = $False;
            OutlookPayEnabled                                         = $True;
            PublicComputersDetectionEnabled                           = $False;
            PublicFoldersEnabled                                      = "Local";
            PublicFolderShowClientControl                             = $False;
            ReadTrackingEnabled                                       = $False;
            RemotePublicFolderMailboxes                               = @();
            SiteMailboxCreationURL                                    = $null;
            SmtpActionableMessagesEnabled                             = $True;
            VisibleMeetingUpdateProperties                            = "Location,AllProperties:15";
            WebPushNotificationsDisabled                              = $False;
            WebSuggestedRepliesDisabled                               = $False;
        }
        EXOOwaMailboxPolicy 0e562175-78f0-4855-a192-82d99c21f1cd
        {
            ActionForUnknownFileAndMIMETypes                     = "Allow";
            ActiveSyncIntegrationEnabled                         = $True;
            AdditionalStorageProvidersAvailable                  = $True;
            AllAddressListsEnabled                               = $True;
            AllowCopyContactsToDeviceAddressBook                 = $True;
            AllowedFileTypes                                     = @(".rpmsg",".xlsx",".xlsm",".xlsb",".vstx",".vstm",".vssx",".vssm",".vsdx",".vsdm",".tiff",".pptx",".pptm",".ppsx",".ppsm",".docx",".docm",".zip",".xls",".wmv",".wma",".wav",".vtx",".vsx",".vst",".vss",".vsd",".vdx",".txt",".tif",".rtf",".pub",".ppt",".png",".pdf",".one",".mp3",".jpg",".gif",".doc",".csv",".bmp",".avi");
            AllowedMimeTypes                                     = @("image/jpeg","image/png","image/gif","image/bmp");
            BlockedFileTypes                                     = @(".settingcontent-ms",".printerexport",".appcontent-ms",".appref-ms",".vsmacros",".website",".msh2xml",".msh1xml",".diagcab",".webpnp",".ps2xml",".ps1xml",".mshxml",".gadget",".theme",".psdm1",".mhtml",".cdxml",".xbap",".vhdx",".pyzw",".pssc",".psd1",".psc2",".psc1",".msh2",".msh1",".jnlp",".aspx",".appx",".xnk",".xll",".wsh",".wsf",".wsc",".wsb",".vsw",".vhd",".vbs",".vbp",".vbe",".url",".udl",".tmp",".shs",".shb",".sct",".scr",".scf",".reg",".pyz",".pyw",".pyo",".pyc",".pst",".ps2",".ps1",".prg",".prf",".plg",".pif",".pcd",".osd",".ops",".msu",".mst",".msp",".msi",".msh",".msc",".mht",".mdz",".mdw",".mdt",".mde",".mdb",".mda",".mcf",".maw",".mav",".mau",".mat",".mas",".mar",".maq",".mam",".mag",".maf",".mad",".lnk",".ksh",".jse",".jar",".its",".isp",".ins",".inf",".htc",".hta",".hpj",".hlp",".grp",".fxp",".exe",".der",".csh",".crt",".cpl",".com",".cnt",".cmd",".chm",".cer",".bat",".bas",".asx",".asp",".app",".apk",".adp",".ade",".ws",".vb",".py",".pl",".js");
            BlockedMimeTypes                                     = @("application/x-javascript","application/javascript","application/msaccess","x-internet-signup","text/javascript","application/prg","application/hta","text/scriplet");
            ClassicAttachmentsEnabled                            = $True;
            ConditionalAccessPolicy                              = "Off";
            DefaultTheme                                         = "";
            DirectFileAccessOnPrivateComputersEnabled            = $True;
            DirectFileAccessOnPublicComputersEnabled             = $True;
            DisableFacebook                                      = $true;
            DisplayPhotosEnabled                                 = $True;
            Ensure                                               = "Present";
            ExplicitLogonEnabled                                 = $True;
            ExternalImageProxyEnabled                            = $True;
            ExternalSPMySiteHostURL                              = $null;
            ForceSaveAttachmentFilteringEnabled                  = $False;
            ForceSaveFileTypes                                   = @(".svgz",".html",".xml",".swf",".svg",".spl",".htm",".dir",".dcr");
            ForceSaveMimeTypes                                   = @("Application/x-shockwave-flash","Application/octet-stream","Application/futuresplash","Application/x-director","application/xml","image/svg+xml","text/html","text/xml");
            ForceWacViewingFirstOnPrivateComputers               = $False;
            ForceWacViewingFirstOnPublicComputers                = $False;
            FreCardsEnabled                                      = $True;
            GlobalAddressListEnabled                             = $True;
            GlobalAdminAccount                                   = $Credsglobaladmin;
            GroupCreationEnabled                                 = $True;
            InstantMessagingEnabled                              = $True;
            InstantMessagingType                                 = "Ocs";
            InterestingCalendarsEnabled                          = $True;
            InternalSPMySiteHostURL                              = $null;
            IRMEnabled                                           = $True;
            IsDefault                                            = $True;
            JournalEnabled                                       = $True;
            LocalEventsEnabled                                   = $False;
            LogonAndErrorLanguage                                = 0;
            Name                                                 = "OwaMailboxPolicy-Default";
            NotesEnabled                                         = $True;
            NpsMailboxPolicy                                     = $null;
            OnSendAddinsEnabled                                  = $False;
            OrganizationEnabled                                  = $True;
            OutboundCharset                                      = "AutoDetect";
            OutlookBetaToggleEnabled                             = $True;
            OWALightEnabled                                      = $True;
            PersonalAccountCalendarsEnabled                      = $True;
            PhoneticSupportEnabled                               = $False;
            PlacesEnabled                                        = $True;
            PremiumClientEnabled                                 = $True;
            PrintWithoutDownloadEnabled                          = $True;
            PublicFoldersEnabled                                 = $True;
            RecoverDeletedItemsEnabled                           = $True;
            ReferenceAttachmentsEnabled                          = $True;
            RemindersAndNotificationsEnabled                     = $True;
            ReportJunkEmailEnabled                               = $True;
            RulesEnabled                                         = $True;
            SatisfactionEnabled                                  = $True;
            SaveAttachmentsToCloudEnabled                        = $True;
            SearchFoldersEnabled                                 = $True;
            SetPhotoEnabled                                      = $True;
            SetPhotoURL                                          = "";
            SignaturesEnabled                                    = $True;
            SkipCreateUnifiedGroupCustomSharepointClassification = $True;
            TeamSnapCalendarsEnabled                             = $True;
            TextMessagingEnabled                                 = $True;
            ThemeSelectionEnabled                                = $True;
            UMIntegrationEnabled                                 = $True;
            UseGB18030                                           = $False;
            UseISO885915                                         = $False;
            UserVoiceEnabled                                     = $True;
            WacEditingEnabled                                    = $True;
            WacExternalServicesEnabled                           = $True;
            WacOMEXEnabled                                       = $False;
            WacViewingOnPrivateComputersEnabled                  = $True;
            WacViewingOnPublicComputersEnabled                   = $True;
            WeatherEnabled                                       = $True;
            WebPartsFrameOptionsType                             = "SameOrigin";
        }
        EXOSharingPolicy 244c63db-56e6-4a8d-9ecf-ea7f2374e2d3
        {
            Default              = $True;
            Domains              = @("Anonymous:CalendarSharingFreeBusyReviewer","*:CalendarSharingFreeBusySimple");
            Enabled              = $False;
            Ensure               = "Present";
            GlobalAdminAccount   = $Credsglobaladmin;
            Name                 = "Default Sharing Policy";
        }
        O365AdminAuditLogConfig df36daec-9256-49df-9d6b-1cf13c2a22db
        {
            Ensure                          = "Present";
            GlobalAdminAccount              = $Credsglobaladmin;
            IsSingleInstance                = "Yes";
            UnifiedAuditLogIngestionEnabled = "Disabled";
        }
        SPOAccessControlSettings 8c66c133-2529-48c8-9ea9-8ee89024e326
        {
            CommentsOnSitePagesDisabled  = $False;
            DisallowInfectedFileDownload = $False;
            DisplayStartASiteOption      = $False;
            EmailAttestationReAuthDays   = 30;
            EmailAttestationRequired     = $False;
            ExternalServicesEnabled      = $True;
            GlobalAdminAccount           = $Credsglobaladmin;
            IPAddressAllowList           = "";
            IPAddressEnforcement         = $False;
            IPAddressWACTokenLifetime    = 15;
            IsSingleInstance             = "Yes";
            SocialBarOnSitePagesDisabled = $False;
            StartASiteFormUrl            = $null;
        }
        SPOSharingSettings 8a42460d-73ea-486a-8322-468a26ac4adb
        {
            BccExternalSharingInvitations              = $False;
            BccExternalSharingInvitationsList          = $null;
            DefaultLinkPermission                      = "Edit";
            DefaultSharingLinkType                     = "Internal";
            EnableGuestSignInAcceleration              = $False;
            FileAnonymousLinkType                      = "Edit";
            FolderAnonymousLinkType                    = "Edit";
            GlobalAdminAccount                         = $Credsglobaladmin;
            IsSingleInstance                           = "Yes";
            NotifyOwnersWhenItemsReshared              = $True;
            PreventExternalUsersFromResharing          = $False;
            ProvisionSharedWithEveryoneFolder          = $False;
            RequireAcceptingAccountMatchInvitedAccount = $False;
            SharingCapability                          = "Disabled";
            SharingDomainRestrictionMode               = "None";
            ShowAllUsersClaim                          = $False;
            ShowEveryoneClaim                          = $False;
            ShowEveryoneExceptExternalUsersClaim       = $True;
            ShowPeoplePickerSuggestionsForGuestUsers   = $False;
        }
        SPOTenantCDNPolicy 7567ca28-9fb1-4ee9-b330-60701f44c441
        {
            CDNType                              = "Public";
            ExcludeRestrictedSiteClassifications = @();
            GlobalAdminAccount                   = $Credsglobaladmin;
            IncludeFileExtensions                = @();
        }
        SPOTenantCDNPolicy f8a36fc3-c641-4272-8f6d-4267806c2be6
        {
            CDNType                              = "Private";
            ExcludeRestrictedSiteClassifications = @();
            GlobalAdminAccount                   = $Credsglobaladmin;
            IncludeFileExtensions                = @();
        }
        SPOTenantSettings b09d6505-722a-40e0-9485-870dba2cad32
        {
            ApplyAppEnforcedRestrictionsToAdHocRecipients = $True;
            FilePickerExternalImageSearchEnabled          = $True;
            GlobalAdminAccount                            = $Credsglobaladmin;
            HideDefaultThemes                             = $False;
            IsSingleInstance                              = "Yes";
            LegacyAuthProtocolsEnabled                    = $True;
            MaxCompatibilityLevel                         = "15";
            MinCompatibilityLevel                         = "15";
            NotificationsInSharePointEnabled              = $True;
            OfficeClientADALDisabled                      = $False;
            OwnerAnonymousNotification                    = $True;
            PublicCdnAllowedFileTypes                     = "CSS,EOT,GIF,ICO,JPEG,JPG,JS,MAP,PNG,SVG,TTF,WOFF";
            PublicCdnEnabled                              = $False;
            RequireAcceptingAccountMatchInvitedAccount    = $False;
            SearchResolveExactEmailOrUPN                  = $False;
            SignInAccelerationDomain                      = "";
            UseFindPeopleInPeoplePicker                   = $False;
            UsePersistentCookiesForExplorerView           = $False;
            UserVoiceForFeedbackEnabled                   = $False;
        }
        TeamsCallingPolicy 06fe9f72-a3dc-4760-b3ab-b2d43fb759bb
        {
            AllowCallForwardingToPhone = $True;
            AllowCallForwardingToUser  = $True;
            AllowCallGroups            = $True;
            AllowDelegation            = $True;
            AllowPrivateCalling        = $True;
            AllowVoicemail             = "UserOverride";
            BusyOnBusyEnabledType      = "Disabled";
            Ensure                     = "Present";
            GlobalAdminAccount         = $Credsglobaladmin;
            Identity                   = "Global";
            PreventTollBypass          = $False;
        }
        TeamsCallingPolicy 7df0ac59-21c2-4859-badc-c4d818589693
        {
            AllowCallForwardingToPhone = $True;
            AllowCallForwardingToUser  = $True;
            AllowCallGroups            = $True;
            AllowDelegation            = $True;
            AllowPrivateCalling        = $True;
            AllowVoicemail             = "UserOverride";
            BusyOnBusyEnabledType      = "Disabled";
            Ensure                     = "Present";
            GlobalAdminAccount         = $Credsglobaladmin;
            Identity                   = "Tag:AllowCalling";
            PreventTollBypass          = $False;
        }
        TeamsCallingPolicy 4e4cf261-4ca8-4081-b54f-4243b9b39528
        {
            AllowCallForwardingToPhone = $True;
            AllowCallForwardingToUser  = $True;
            AllowCallGroups            = $True;
            AllowDelegation            = $True;
            AllowPrivateCalling        = $True;
            AllowVoicemail             = "UserOverride";
            BusyOnBusyEnabledType      = "Disabled";
            Ensure                     = "Present";
            GlobalAdminAccount         = $Credsglobaladmin;
            Identity                   = "Tag:AllowCallingPreventTollBypass";
            PreventTollBypass          = $True;
        }
        TeamsCallingPolicy d8814221-29c7-498a-8645-99d721f7364f
        {
            AllowCallForwardingToPhone = $False;
            AllowCallForwardingToUser  = $True;
            AllowCallGroups            = $True;
            AllowDelegation            = $True;
            AllowPrivateCalling        = $True;
            AllowVoicemail             = "UserOverride";
            BusyOnBusyEnabledType      = "Disabled";
            Ensure                     = "Present";
            GlobalAdminAccount         = $Credsglobaladmin;
            Identity                   = "Tag:AllowCallingPreventForwardingtoPhone";
            PreventTollBypass          = $False;
        }
        TeamsCallingPolicy 4517ac31-73be-4104-ba46-d75ed03ccd16
        {
            AllowCallForwardingToPhone = $False;
            AllowCallForwardingToUser  = $False;
            AllowCallGroups            = $False;
            AllowDelegation            = $False;
            AllowPrivateCalling        = $False;
            AllowVoicemail             = "AlwaysDisabled";
            BusyOnBusyEnabledType      = "Disabled";
            Ensure                     = "Present";
            GlobalAdminAccount         = $Credsglobaladmin;
            Identity                   = "Tag:DisallowCalling";
            PreventTollBypass          = $False;
        }
        TeamsChannelsPolicy 06895c52-db5e-4c21-b407-5ddcc11d6bf7
        {
            AllowOrgWideTeamCreation    = $True;
            AllowPrivateChannelCreation = $True;
            AllowPrivateTeamDiscovery   = $True;
            Description                 = $null;
            Ensure                      = "Present";
            GlobalAdminAccount          = $Credsglobaladmin;
            Identity                    = "Global";
        }
        TeamsChannelsPolicy 87f8861d-4222-4ce8-bf96-3392ec5a9800
        {
            AllowOrgWideTeamCreation    = $True;
            AllowPrivateChannelCreation = $True;
            AllowPrivateTeamDiscovery   = $True;
            Description                 = $null;
            Ensure                      = "Present";
            GlobalAdminAccount          = $Credsglobaladmin;
            Identity                    = "Tag:Default";
        }
        TeamsClientConfiguration 19adf2c1-1f5c-4e48-aff5-2f05bdd18061
        {
            AllowBox                         = $False;
            AllowDropBox                     = $False;
            AllowEmailIntoChannel            = $True;
            AllowGoogleDrive                 = $False;
            AllowGuestUser                   = $False;
            AllowOrganizationTab             = $False;
            AllowResourceAccountSendMessage  = $True;
            AllowScopedPeopleSearchandAccess = $False;
            AllowShareFile                   = $False;
            AllowSkypeBusinessInterop        = $True;
            ContentPin                       = "RequiredOutsideScheduleMeeting";
            GlobalAdminAccount               = $Credsglobaladmin;
            Identity                         = "Global";
            ResourceAccountContentAccess     = "NoAccess";
        }
        TeamsEmergencyCallingPolicy afa87fd2-173e-4ef0-9420-b2d528a96f2d
        {
            Description               = $null;
            Ensure                    = "Present";
            GlobalAdminAccount        = $Credsglobaladmin;
            Identity                  = "Global";
            NotificationDialOutNumber = $null;
            NotificationGroup         = $null;
        }
        TeamsEmergencyCallRoutingPolicy 24b54bc5-e4a7-49c6-9494-db79945bdb99
        {
            AllowEnhancedEmergencyServices = $False;
            Description                    = $null;
            Ensure                         = "Present";
            GlobalAdminAccount             = $Credsglobaladmin;
            Identity                       = "Global";
        }
        TeamsGuestCallingConfiguration f3101634-501c-4732-9590-9fcc09f74eeb
        {
            AllowPrivateCalling  = $True;
            GlobalAdminAccount   = $Credsglobaladmin;
            Identity             = "Global";
        }
        TeamsGuestMeetingConfiguration 4fff7812-4a05-4b48-aa03-aba32052fc95
        {
            AllowIPVideo         = $True;
            AllowMeetNow         = $True;
            GlobalAdminAccount   = $Credsglobaladmin;
            Identity             = "Global";
            ScreenSharingMode    = "EntireScreen";
        }
        TeamsGuestMessagingConfiguration b056dfac-a245-41cb-8a53-2249d9f9f343
        {
            AllowGiphy             = $True;
            AllowImmersiveReader   = $True;
            AllowMemes             = $True;
            AllowStickers          = $True;
            AllowUserChat          = $True;
            AllowUserDeleteMessage = $True;
            AllowUserEditMessage   = $True;
            GiphyRatingType        = "Moderate";
            GlobalAdminAccount     = $Credsglobaladmin;
            Identity               = "Global";
        }
        TeamsMeetingBroadcastConfiguration 24ef80f0-3db3-4701-8dd3-590b7467fa5a
        {
            AllowSdnProviderForBroadcastMeeting = $False;
            GlobalAdminAccount                  = $Credsglobaladmin;
            Identity                            = "Global";
            SdnApiTemplateUrl                   = "";
            SdnApiToken                         = "";
            SdnLicenseId                        = "";
            SdnProviderName                     = "";
            SupportURL                          = "https://support.office.com/home/contact";
        }
        TeamsMeetingBroadcastPolicy 1a333fd7-dd61-409e-915d-ae8c2869e4a6
        {
            AllowBroadcastScheduling        = $False;
            AllowBroadcastTranscription     = $False;
            BroadcastAttendeeVisibilityMode = "EveryoneInCompany";
            BroadcastRecordingMode          = "AlwaysEnabled";
            Ensure                          = "Present";
            GlobalAdminAccount              = $Credsglobaladmin;
            Identity                        = "Global";
        }
        TeamsMeetingBroadcastPolicy 22195e97-3856-4055-a31b-d7c69ef12b10
        {
            AllowBroadcastScheduling        = $True;
            AllowBroadcastTranscription     = $False;
            BroadcastAttendeeVisibilityMode = "EveryoneInCompany";
            BroadcastRecordingMode          = "AlwaysEnabled";
            Ensure                          = "Present";
            GlobalAdminAccount              = $Credsglobaladmin;
            Identity                        = "Tag:Default";
        }
        TeamsMeetingConfiguration 2a217508-dcf5-451c-8844-036fa928cabb
        {
            ClientAppSharingPort        = 50040;
            ClientAppSharingPortRange   = 20;
            ClientAudioPort             = 50000;
            ClientAudioPortRange        = 20;
            ClientMediaPortRangeEnabled = $True;
            ClientVideoPort             = 50020;
            ClientVideoPortRange        = 20;
            CustomFooterText            = $null;
            DisableAnonymousJoin        = $False;
            EnableQoS                   = $False;
            GlobalAdminAccount          = $Credsglobaladmin;
            HelpURL                     = $null;
            Identity                    = "Global";
            LegalURL                    = $null;
            LogoURL                     = $null;
        }
        TeamsMeetingPolicy 53f29f91-eec3-4f2a-9917-3ad2e15b9414
        {
            AllowAnonymousUsersToStartMeeting          = $False;
            AllowChannelMeetingScheduling              = $True;
            AllowCloudRecording                        = $True;
            AllowExternalParticipantGiveRequestControl = $False;
            AllowIPVideo                               = $True;
            AllowMeetNow                               = $True;
            AllowOutlookAddIn                          = $True;
            AllowParticipantGiveRequestControl         = $True;
            AllowPowerPointSharing                     = $True;
            AllowPrivateMeetingScheduling              = $True;
            AllowSharedNotes                           = $True;
            AllowTranscription                         = $False;
            AllowWhiteboard                            = $False;
            AutoAdmittedUsers                          = "EveryoneInCompany";
            Description                                = $null;
            Ensure                                     = "Present";
            GlobalAdminAccount                         = $Credsglobaladmin;
            Identity                                   = "Global";
            MediaBitRateKb                             = 50000;
            ScreenSharingMode                          = "EntireScreen";
        }
        TeamsMeetingPolicy 82a8caf0-c2be-433f-b5c4-b197f8eed134
        {
            AllowAnonymousUsersToStartMeeting          = $False;
            AllowChannelMeetingScheduling              = $True;
            AllowCloudRecording                        = $True;
            AllowExternalParticipantGiveRequestControl = $False;
            AllowIPVideo                               = $True;
            AllowMeetNow                               = $True;
            AllowOutlookAddIn                          = $True;
            AllowParticipantGiveRequestControl         = $True;
            AllowPowerPointSharing                     = $True;
            AllowPrivateMeetingScheduling              = $True;
            AllowSharedNotes                           = $True;
            AllowTranscription                         = $False;
            AllowWhiteboard                            = $False;
            AutoAdmittedUsers                          = "EveryoneInCompany";
            Description                                = "Do not assign. This policy is same as global defaults and would be deprecated";
            Ensure                                     = "Present";
            GlobalAdminAccount                         = $Credsglobaladmin;
            Identity                                   = "Tag:AllOn";
            MediaBitRateKb                             = 50000;
            ScreenSharingMode                          = "EntireScreen";
        }
        TeamsMeetingPolicy 4b3de6f6-61cf-4844-80fe-20fe0416199b
        {
            AllowAnonymousUsersToStartMeeting          = $False;
            AllowChannelMeetingScheduling              = $True;
            AllowCloudRecording                        = $True;
            AllowExternalParticipantGiveRequestControl = $False;
            AllowIPVideo                               = $True;
            AllowMeetNow                               = $True;
            AllowOutlookAddIn                          = $True;
            AllowParticipantGiveRequestControl         = $True;
            AllowPowerPointSharing                     = $True;
            AllowPrivateMeetingScheduling              = $True;
            AllowSharedNotes                           = $True;
            AllowTranscription                         = $False;
            AllowWhiteboard                            = $False;
            AutoAdmittedUsers                          = "EveryoneInCompany";
            Description                                = "Do not assign. This policy is same as global defaults and would be deprecated";
            Ensure                                     = "Present";
            GlobalAdminAccount                         = $Credsglobaladmin;
            Identity                                   = "Tag:RestrictedAnonymousAccess";
            MediaBitRateKb                             = 50000;
            ScreenSharingMode                          = "EntireScreen";
        }
        TeamsMeetingPolicy b231d893-3ce2-4fae-828c-b4cdf167274c
        {
            AllowAnonymousUsersToStartMeeting          = $False;
            AllowChannelMeetingScheduling              = $False;
            AllowCloudRecording                        = $False;
            AllowExternalParticipantGiveRequestControl = $False;
            AllowIPVideo                               = $False;
            AllowMeetNow                               = $False;
            AllowOutlookAddIn                          = $False;
            AllowParticipantGiveRequestControl         = $False;
            AllowPowerPointSharing                     = $False;
            AllowPrivateMeetingScheduling              = $False;
            AllowSharedNotes                           = $False;
            AllowTranscription                         = $False;
            AllowWhiteboard                            = $False;
            AutoAdmittedUsers                          = "EveryoneInCompany";
            Description                                = $null;
            Ensure                                     = "Present";
            GlobalAdminAccount                         = $Credsglobaladmin;
            Identity                                   = "Tag:AllOff";
            MediaBitRateKb                             = 50000;
            ScreenSharingMode                          = "Disabled";
        }
        TeamsMeetingPolicy 5a79f886-4e92-494c-b9ba-ef6ecaaf35e4
        {
            AllowAnonymousUsersToStartMeeting          = $False;
            AllowChannelMeetingScheduling              = $True;
            AllowCloudRecording                        = $False;
            AllowExternalParticipantGiveRequestControl = $False;
            AllowIPVideo                               = $True;
            AllowMeetNow                               = $True;
            AllowOutlookAddIn                          = $True;
            AllowParticipantGiveRequestControl         = $True;
            AllowPowerPointSharing                     = $True;
            AllowPrivateMeetingScheduling              = $True;
            AllowSharedNotes                           = $True;
            AllowTranscription                         = $False;
            AllowWhiteboard                            = $False;
            AutoAdmittedUsers                          = "EveryoneInCompany";
            Description                                = "Do not assign. This policy is similar to global defaults and would be deprecated";
            Ensure                                     = "Present";
            GlobalAdminAccount                         = $Credsglobaladmin;
            Identity                                   = "Tag:RestrictedAnonymousNoRecording";
            MediaBitRateKb                             = 50000;
            ScreenSharingMode                          = "EntireScreen";
        }
        TeamsMeetingPolicy f840378d-a39b-4d51-ae63-1bcf6a2361e1
        {
            AllowAnonymousUsersToStartMeeting          = $False;
            AllowChannelMeetingScheduling              = $True;
            AllowCloudRecording                        = $True;
            AllowExternalParticipantGiveRequestControl = $False;
            AllowIPVideo                               = $True;
            AllowMeetNow                               = $True;
            AllowOutlookAddIn                          = $True;
            AllowParticipantGiveRequestControl         = $True;
            AllowPowerPointSharing                     = $True;
            AllowPrivateMeetingScheduling              = $True;
            AllowSharedNotes                           = $True;
            AllowTranscription                         = $False;
            AllowWhiteboard                            = $False;
            AutoAdmittedUsers                          = "EveryoneInCompany";
            Description                                = $null;
            Ensure                                     = "Present";
            GlobalAdminAccount                         = $Credsglobaladmin;
            Identity                                   = "Tag:Default";
            MediaBitRateKb                             = 50000;
            ScreenSharingMode                          = "EntireScreen";
        }
        TeamsMeetingPolicy 51494369-0e00-46f7-82ae-c58c38230b49
        {
            AllowAnonymousUsersToStartMeeting          = $False;
            AllowChannelMeetingScheduling              = $False;
            AllowCloudRecording                        = $False;
            AllowExternalParticipantGiveRequestControl = $False;
            AllowIPVideo                               = $True;
            AllowMeetNow                               = $True;
            AllowOutlookAddIn                          = $False;
            AllowParticipantGiveRequestControl         = $True;
            AllowPowerPointSharing                     = $True;
            AllowPrivateMeetingScheduling              = $False;
            AllowSharedNotes                           = $True;
            AllowTranscription                         = $False;
            AllowWhiteboard                            = $False;
            AutoAdmittedUsers                          = "EveryoneInCompany";
            Description                                = $null;
            Ensure                                     = "Present";
            GlobalAdminAccount                         = $Credsglobaladmin;
            Identity                                   = "Tag:Kiosk";
            MediaBitRateKb                             = 50000;
            ScreenSharingMode                          = "EntireScreen";
        }
        TeamsMessagingPolicy c60af168-efc4-4894-8a09-0eba815458ea
        {
            AllowGiphy                    = $True;
            AllowImmersiveReader          = $True;
            AllowMemes                    = $True;
            AllowOwnerDeleteMessage       = $False;
            AllowPriorityMessages         = $True;
            AllowRemoveUser               = $True;
            AllowStickers                 = $True;
            AllowUrlPreviews              = $True;
            AllowUserChat                 = $True;
            AllowUserDeleteMessage        = $True;
            AllowUserTranslation          = $False;
            AudioMessageEnabledType       = "ChatsAndChannels";
            ChannelsInChatListEnabledType = "DisabledUserOverride";
            Description                   = $null;
            Ensure                        = "Present";
            GiphyRatingType               = "Moderate";
            GlobalAdminAccount            = $Credsglobaladmin;
            Identity                      = "Global";
            ReadReceiptsEnabledType       = "UserPreference";
        }
        TeamsMessagingPolicy 2e92be7e-2642-4671-8065-2da39521627a
        {
            AllowGiphy                    = $True;
            AllowImmersiveReader          = $True;
            AllowMemes                    = $True;
            AllowOwnerDeleteMessage       = $False;
            AllowPriorityMessages         = $True;
            AllowRemoveUser               = $True;
            AllowStickers                 = $True;
            AllowUrlPreviews              = $True;
            AllowUserChat                 = $True;
            AllowUserDeleteMessage        = $True;
            AllowUserTranslation          = $False;
            AudioMessageEnabledType       = "ChatsAndChannels";
            ChannelsInChatListEnabledType = "DisabledUserOverride";
            Description                   = $null;
            Ensure                        = "Present";
            GiphyRatingType               = "Moderate";
            GlobalAdminAccount            = $Credsglobaladmin;
            Identity                      = "Default";
            ReadReceiptsEnabledType       = "UserPreference";
        }
        TeamsMessagingPolicy e510cb59-3bdd-4ba0-aac2-ca8ba28266a4
        {
            AllowGiphy                    = $False;
            AllowImmersiveReader          = $True;
            AllowMemes                    = $True;
            AllowOwnerDeleteMessage       = $True;
            AllowPriorityMessages         = $True;
            AllowRemoveUser               = $True;
            AllowStickers                 = $True;
            AllowUrlPreviews              = $True;
            AllowUserChat                 = $True;
            AllowUserDeleteMessage        = $True;
            AllowUserTranslation          = $False;
            AudioMessageEnabledType       = "ChatsAndChannels";
            ChannelsInChatListEnabledType = "DisabledUserOverride";
            Description                   = $null;
            Ensure                        = "Present";
            GiphyRatingType               = "Strict";
            GlobalAdminAccount            = $Credsglobaladmin;
            Identity                      = "EduFaculty";
            ReadReceiptsEnabledType       = "UserPreference";
        }
        TeamsMessagingPolicy 09e02e01-531a-41c6-9b0f-6a8d26bcd1f1
        {
            AllowGiphy                    = $False;
            AllowImmersiveReader          = $True;
            AllowMemes                    = $True;
            AllowOwnerDeleteMessage       = $False;
            AllowPriorityMessages         = $True;
            AllowRemoveUser               = $True;
            AllowStickers                 = $True;
            AllowUrlPreviews              = $True;
            AllowUserChat                 = $True;
            AllowUserDeleteMessage        = $True;
            AllowUserTranslation          = $False;
            AudioMessageEnabledType       = "ChatsAndChannels";
            ChannelsInChatListEnabledType = "DisabledUserOverride";
            Description                   = $null;
            Ensure                        = "Present";
            GiphyRatingType               = "Strict";
            GlobalAdminAccount            = $Credsglobaladmin;
            Identity                      = "EduStudent";
            ReadReceiptsEnabledType       = "UserPreference";
        }
        ODSettings OneDriveSettings
        {
            IsSingleInstance                          = "Yes";
            GlobalAdminAccount                        = $Credsglobaladmin;
            OneDriveStorageQuota                      = "1";
            ExcludedFileExtensions                    = @("pst");
            GrooveBlockOption                         = "OptOut";
            DisableReportProblemDialog                = $true;
            BlockMacSync                              = $true;
            OrphanedPersonalSitesRetentionPeriod      = "60";
            OneDriveForGuestsEnabled                  = $false;
            ODBAccessRequests                         = "On";
            ODBMembersCanShare                        = "On";
            NotifyOwnersWhenInvitationsAccepted       = $false;
            NotificationsInOneDriveForBusinessEnabled = $false;
            Ensure                                    = "Present";
        }
    }
}
O365TenantConfig -ConfigurationData .\ConfigurationData.psd1 -GlobalAdminAccount $GlobalAdminAccount
