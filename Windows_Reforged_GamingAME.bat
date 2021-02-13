:: Windows 10 AME BATCH Script
:: v2004.2020.11.3

@echo off
pushd "%~dp0"

echo.
echo  :: Checking For Administrator Elevation...
echo.
timeout /t 1 /nobreak > NUL
openfiles > NUL 2>&1
if %errorlevel%==0 (
        echo Elevation found! Proceeding...
) else (
        echo  :: You are NOT running as Administrator
        echo.
        echo     Right-click and select ^'Run as Administrator^' and try again.
        echo     Press any key to exit...
        pause > NUL
        exit
)

goto menu

:menu
cls
echo.
echo  :: WINDOWS 10 AME SETUP SCRIPT Version 2020.11.3
echo. 
echo     This script gives you a list-style overview to execute many commands
echo. 
echo  :: NOTE: For Windows 10 Build 2004 Only
echo. 
echo     1. Run Pre-Amelioration
echo     2. Run Post-Amelioration
echo     3. User Permissions
echo     4. Restart System
echo. 
echo  :: Type a 'number' and press ENTER
echo  :: Type 'exit' to quit
echo.

set /P menu=
	if %menu%==1 GOTO preame
	if %menu%==2 GOTO programs
	if %menu%==3 GOTO user		
	if %menu%==4 GOTO reboot
	if %menu%==exit GOTO EOF
else (
	cls
	echo.
	echo  :: Incorrect Input Entered
	echo.
	echo     Please type a 'number' or 'exit'
	echo     Press any key to retrn to the menu...
	echo.
	pause > NUL
	goto menu
)
		
:preame
cls
:: DotNet 3.5 Installation from install media
cls
echo.
echo  :: Installing .NET 3.5 for Windows 10
echo.
echo     Windows 10 normally opts to download this runtime via Windows Update.
echo     However, it can be installed with the original installation media.
echo     .NET 3.5 is necessary for certain programs and games to function.
echo.
echo  :: Please mount the Windows 10 installation media and specify a drive letter.
echo.
echo  :: Type a 'drive letter' e.g. D: and press ENTER
echo  :: Type 'exit' to return to the menu
echo.
set /P drive=
if %drive%==exit GOTO menu
	dism /online /enable-feature /featurename:NetFX3 /All /Source:%drive%\sources\sxs /LimitAccess

cls
echo.
echo  :: Disabling Windows Update
timeout /t 2 /nobreak > NUL
net stop wuauserv
sc config wuauserv start= disabled

cls
echo.
echo  :: Disabling Data Logging Services
timeout /t 2 /nobreak > NUL
taskkill /f /im explorer.exe

:: Disabling Tracking Services and Data Collection
cls
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f > NUL 2>&1

:: Disable and Delete Tasks
cls
schtasks /change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /DISABLE > NUL 2>&1
schtasks /change /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /DISABLE > NUL 2>&1
schtasks /change /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /DISABLE > NUL 2>&1
schtasks /change /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /DISABLE > NUL 2>&1
schtasks /change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /DISABLE > NUL 2>&1
schtasks /delete /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /f > NUL 2>&1
schtasks /delete /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater" /f > NUL 2>&1
schtasks /delete /TN "\Microsoft\Windows\Application Experience\StartupAppTask" /f > NUL 2>&1
schtasks /delete /TN "\Microsoft\Windows\Clip\License Validation" /f > NUL 2>&1
schtasks /delete /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /f > NUL 2>&1
schtasks /delete /TN "\Microsoft\Windows\HelloFace\FODCleanupTask" /f > NUL 2>&1
schtasks /delete /TN "\Microsoft\Windows\Maps\MapsToastTask" /f > NUL 2>&1
schtasks /delete /TN "\Microsoft\Windows\Maps\MapsUpdateTask" /f > NUL 2>&1
schtasks /delete /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan" /f > NUL 2>&1
schtasks /delete /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan Static Task" /f > NUL 2>&1
schtasks /delete /TN "\Microsoft\Windows\UpdateOrchestrator\UpdateModelTask" /f > NUL 2>&1
schtasks /delete /TN "\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker" /f > NUL 2>&1
schtasks /delete /TN "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /f > NUL 2>&1
schtasks /delete /TN "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /f > NUL 2>&1
schtasks /delete /TN "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /f > NUL 2>&1
schtasks /delete /TN "\Microsoft\Windows\Windows Defender\Windows Defender Verification" /f > NUL 2>&1
schtasks /delete /TN "\Microsoft\Windows\WindowsUpdate\Scheduled Start" /f > NUL 2>&1

:: Registry Edits
cls
echo "" > C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger" /v "Start" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DownloadMode /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v DisableSettingSync /t REG_DWORD /d 2 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v DisableSettingSyncUserOverride /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\EnhancedStorageDevices" /v TCGSecurityActivationDisabled /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\codeidentifiers" /v authenticodeenabled /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v DontSendAdditionalData /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v value /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v value /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v EnableWebContentEvaluation /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKCU\Control Panel\International\User Profile" /v HttpAcceptLanguageOptOut /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v UseActionCenterExperience /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v HideSCAHealth /t REG_DWORD /d 0x1 /f > NUL 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f > NUL 2>&1

:: Enables All Folders in Explorer Navigation Panel
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "NavPaneShowAllFolders" /t REG_DWORD /d 1 /f > NUL 2>&1

:: Remove the Open with Paint 3D from the explorer context menu
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.bmp\Shell\3D Edit" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.jpeg\Shell\3D Edit" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.jpe\Shell\3D Edit" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.jpg\Shell\3D Edit" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.jpg\Shell\3D Edit" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.png\Shell\3D Edit" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.gif\Shell\3D Edit" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.tif\Shell\3D Edit" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.tiff\Shell\3D Edit" /f > NUL 2>&1

:: Turns off Windows blocking installation of files downloaded from the internet
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v SaveZoneInformation /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v SaveZoneInformation /t REG_DWORD /d 1 /f > NUL 2>&1

:: Disables SmartScreen
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v SmartScreenEnabled /t REG_SZ /d "Off" /f > NUL 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v ContentEvaluation /t REG_DWORD /d 0 /f > NUL 2>&1

:: Remove Metadata Tracking
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /f > NUL 2>&1

:: New Control Panel cleanup
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v SettingsPageVisibility /t REG_SZ /d "showonly:display;nightlight;sound;notifications;quiethours;powersleep;batterysaver;tabletmode;multitasking;clipboard;remote-desktop;about;bluetooth;connecteddevices;printers;mousetouchpad;devices-touchpad;typing;pen;autoplay;usb;network-status;network-cellular;network-wifi;network-wificalling;network-wifisettings;network-ethernet;network-dialup;netowrk-vpn;network-airplanemode;network-mobilehotspot;datausage;network-proxy;personalization-background;personalization-start;fonts;colors;lockscreen;themes;taskbar;defaultapps;videoplayback;startupapps;dateandtime;regionformatting;gaming;gamemode;easeofaccess-display;easeofaccess-colorfilter;easeofaccess-audio;easeofaccess-easeofaccess-narrator;easeofaccess-magnifier;easeofaccess-highcontrast;easeofaccess-closedcaptioning;easeofaccess-speechrecognition;easeofaccess-eyecontrol;easeofaccess-keyboard;easeofaccess-mouse" /f > NUL 2>&1

:: Decrease shutdown time
reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeOut /t REG_SZ /d 2000 /f > NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 2000 /f > NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v HungAppTimeout /t REG_SZ /d 2000 /f > NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v AutoEndTasks /t REG_SZ /d 1 /f > NUL 2>&1

:: Disabling And Stopping Services
cls
sc config diagtrack start= disabled
sc config RetailDemo start= disabled
sc config diagnosticshub.standardcollector.service start= disabled
sc config DiagTrack start= disabled
sc config dmwappushservice start= disabled
sc config HomeGroupListener start= disabled
sc config HomeGroupProvider start= disabled
sc config lfsvc start= disabled
sc config MapsBroker start= disabled
sc config NetTcpPortSharing start= disabled
sc config RemoteAccess start= disabled
sc config RemoteRegistry start= disabled
sc config SharedAccess start= disabled
sc config StorSvc start= disabled
sc config TrkWks start= disabled
sc config WbioSrvc start= disabled
sc config WMPNetworkSvc start= disabled
sc config wscsvc start= disabled
sc config XblAuthManager start= disabled
sc config XblGameSave start= disabled
sc config XboxNetApiSvc start= disabled
net stop wlidsvc
sc config wlidsvc start= disabled

:: Disable SMBv1. Effectively mitigates EternalBlue, popularly known as WannaCry.
PowerShell -Command "Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force"
sc config lanmanworkstation depend= bowser/mrxsmb20/nsi
sc config mrxsmb10 start= disabled

:: Cleaning up the This PC Icon Selection
cls
echo.
echo  :: Removing all Folders from MyPC
timeout /t 2 /nobreak
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" /f > NUL 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f > NUL 2>&1

:: Disabling Storage Sense
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense" /f > NUL 2>&1

:: Disabling Cortana and Removing Search Icon from Taskbar
cls
echo.
echo  :: Disabling Cortana
timeout /t 2 /nobreak
taskkill /f /im SearchUI.exe

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowIndexingEncryptedStoresOrItems" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AlwaysUseAutoLangDetection" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaInAmbientMode" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "HistoryViewEnabled" /t REG_DWORD 0 /f  > NUL 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "HasAboveLockTips" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v "SafeSearchMode" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWebOverMeteredConnections" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKCU\Software\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v "VoiceActivationDefaultOn" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v "VoiceActivationEnableAboveLockscreen" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v "ModelDownloadAllowed" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v "DisableVoice" /t REG_DWORD /d 1 /f > NUL 2>&1
:: Batch magic to search for the current user SID and disable the web search in the stock start menu, this is the equivalent of enabling some group policy that does the same thing, will need to keep in mind if new users are to be added as they will also need this registry entry.
:: This bit here sends the output of a command to a variable
for /f "tokens=* USEBACKQ" %%i in (`wmic useraccount where "name="%username%"" get sid ^| findstr "S-"`) do set currentusername=%%i
:: Trim 3 empty spaces off the end of the returned string
set currentusername=%currentusername:~0,-3%
reg add "HKEY_USERS\%currentusername%\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d 1 /f > NUL 2>&1
:: Firewall rules to prevent the startmenu from talking
reg add "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Search SearchApp.exe" /t REG_SZ /d "v2.30|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|App=C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\SearchApp.exe|Name=Block Search SearchUI.exe|Desc=Block Cortana Outbound UDP/TCP Traffic|"/f > NUL 2>&1
::reg add "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "Block Search Package" /t REG_SZ /d "v2.30|Action=Block|Active=TRUE|Dir=Out|RA42=IntErnet|RA62=IntErnet|Name=Block Search Package|Desc=Block Search Outbound UDP/TCP Traffic|AppPkgId=S-1-15-2-536077884-713174666-1066051701-3219990555-339840825-1966734348-1611281757|Platform=2:6:2|Platform2=GTEQ|"/f > NUL 2>&1


:: Disable Timeline
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d 0 /f > NUL 2>&1

:: Fixing Windows Explorer
cls
echo.
echo  :: Setup Windows Explorer View
timeout /t 2 /nobreak
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 1 /f > NUL 2>&1
reg delete "HKEY_CLASSES_ROOT\CABFolder\CLSID" /f > NUL 2>&1
reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.cab\CLSID" /f > NUL 2>&1
reg delete "HKEY_CLASSES_ROOT\CompressedFolder\CLSID" /f > NUL 2>&1
reg delete "HKEY_CLASSES_ROOT\SystemFileAssociations\.zip\CLSID" /f > NUL 2>&1

:: Clear PageFile at shutdown and ActiveProbing
::reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v EnableActiveProbing /t REG_DWORD /d 0 /f > NUL 2>&1

:: Set Time to UTC
reg add "HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /t REG_DWORD /d 1 /f > NUL 2>&1

::Disable Users On Login Screen
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v dontdisplaylastusername /t REG_DWORD /d 1 /f > NUL 2>&1

::Disable The Lock Screen
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v NoLockScreen /t REG_DWORD /d 1 /f > NUL 2>&1

:: Removing AppXPackages, the ModernUI Apps, including Cortana
cls
echo.
echo  :: Removing AppXPackages
echo.
:: Unprovision built in apps, the list in this command is a whitelist (prevents blackscreen when logging in as a new user for the first time)
Powershell -Command "& { Get-AppxProvisionedPackage -Online | Where-Object { -Not (Select-String -SimpleMatch -Quiet -InputObject $_.PackageName -Pattern (@('Microsoft.Windows.StartMenuExperienceHost*', 'Microsoft.Windows.ShellExperienceHost*', '*windows.immersivecontrolpanel*', '*Windows.Search*' ,'*Microsoft.549981C3F5F10*', '*Microsoft.VCLibs*', '*Microsoft.NET*', '*Microsoft.DesktopAppInstaller*', '*Microsoft.UI*', '*Microsoft.Windows.CapturePicker*', '*Windows.PrintDialog*', '*Windows.CBSPreview*', '*NcsiUwpApp*', '*Microsoft.Windows.XGpuEjectDialog*', '*Microsoft.Win32WebViewHost*', '*Microsoft.Windows.Apprep.ChxApp*', '*1527c705-839a-4832-9118-54d4Bd6a0c89*', '*c5e2524a-ea46-4f67-841f-6a9465d9d515*', '*E2A4F912-2574-4A75-9BB0-0D023378592B*', '*F46D4000-FD22-4DB4-AC8E-4E1DDDE828FE*', '*Microsoft.AccountsControl*', '*Microsoft.Windows.ParentalControls*', '*Microsoft.LockApp*', '*Microsoft.CredDialogHost*', '*Microsoft.WebpImageExtension*', '*Microsoft.WebMediaExtensions_1.0.20875.0_x64__8wekyb3d8bbwe*', '*Microsoft.VP9VideoExtensions*', '*Microsoft.ScreenSketch*', '*Microsoft.HEIFImageExtension*')) | Sort-Object | Get-Unique) } | Remove-AppxProvisionedPackage -Online }"
:: Remove Cortana from all users
PowerShell -Command "Get-AppxPackage -allusers *Microsoft.549981C3F5F10* | Remove-AppxPackage"
:: Wildcard removal for the rest of the apps
PowerShell -Command "Get-AppxPackage *3DViewer* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *AssignedAccessLockApp* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *PinningConfirmationDialog* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *SecureAssessmentBrowser* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Windows.SecHealth* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *FeedbackHub* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *MixedReality* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.Caclulator* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.WindowsAlarms* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.GetHelp* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Getstarted* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.OneConnect* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *WindowsAlarms* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *WindowsCamera* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *bing* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Sticky* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Store* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *MicrosoftOfficeHub* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *ECApp* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *MSPaint* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *wallet* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *OneNote* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *people* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *LockApp* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *MicrosoftEdgeDevToolsClient* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *WindowsPhone* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *YourPhone* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *photos* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *SkypeApp* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *solit* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *WindowsSoundRecorder* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *xbox* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *zune* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *WindowsCalculator* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *WindowsMaps* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Sway* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *CommsPhone* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *ConnectivityStore* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.Messaging* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *ContentDeliveryManager* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Microsoft.WindowsStore* | Remove-AppxPackage"

:: Disabling One Drive
cls
echo.
echo  :: Uninstalling OneDrive
timeout /t 2 /nobreak > NUL

set x64="%SYSTEMROOT%\SysWOW64\OneDriveSetup.exe"
 
taskkill /f /im OneDrive.exe > NUL 2>&1
ping 127.0.0.1 -n 5 > NUL 2>&1
 
if exist %x64% (
%x64% /uninstall
) else (
echo "OneDriveSetup.exe installer not found, skipping."
)
ping 127.0.0.1 -n 8 > NUL 2>&1

rd "%USERPROFILE%\OneDrive" /Q /S > NUL 2>&1
rd "C:\OneDriveTemp" /Q /S > NUL 2>&1
rd "%LOCALAPPDATA%\Microsoft\OneDrive" /Q /S > NUL 2>&1
rd "%PROGRAMDATA%\Microsoft OneDrive" /Q /S > NUL 2>&1

echo.
echo Removing OneDrive from the Explorer Side Panel.
reg delete "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f > NUL 2>&1
reg delete "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f > NUL 2>&1

:: Editing Hosts File, works sometimes, unreliable
cls
echo.

:: Enable Legacy F8 Bootmenu
bcdedit /set {default} bootmenupolicy legacy

:: Disable Hibernation to make NTFS accessable outside of Windows
powercfg /h off
:: Set Performance Plan to High Performance and display to never turn off
powercfg /S 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg /change monitor-timeout-ac 0

goto reboot

:programs
cls
echo.
echo  :: Checking For Internet Connection...
echo.
timeout /t 2 /nobreak > NUL
ping -n 1 archlinux.org -w 20000 >nul
if %errorlevel% == 0 (
echo Internet Connection Found! Proceeding...
) else (
	echo  :: You are NOT connected to the Internet
	echo.
        echo     Please enable your Networking adapter and connect to try again.
        echo     Press any key to retry...
        pause > NUL
        goto programs
)

cls
echo.
echo  :: Installing Packages...
echo.
timeout /t 1 /nobreak > NUL
		
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

:: Add/Remove packages here. Use chocolatey to 'search' for packages matching a term to get the proper name or head over to https://chocolatey.org/packages
:: Recommended optional packages include: libreoffice steam adobeair ffmpeg mpv youtube-dl directx cygwin babun transmission-qt audacity cdrtfe obs syncthing keepass epicgameslauncher googlechrome qbittorrent steam origin goggalaxy uplay obs-studio gimp shotcut

@powershell -NoProfile -ExecutionPolicy Bypass -Command "choco install -y --force --allow-empty-checksums firefox open-shell vlc 7zip jpegview vcredist-all directx onlyoffice steam"

:: Configure Open-Shell
:testos
cls
echo.
echo :: Configuring Open-Shell
echo.
echo Due to restrictions with batch scripting it is required that you to 
echo manually open the Open-Shell start menu for the first time.
echo.
echo Instructions:
echo   1. Click Start
echo   2. Click OK to close the Open-Shell Settings window
echo   3. Open the Start Menu once more and then return to the CMD window
echo.
echo Press any key to continue:
echo.
pause > NUL

set SHRTCT="%HOMEDRIVE%\Users\%username%\AppData\Roaming\OpenShell\Pinned\startscreen.lnk"
if exist %SHRTCT% (
	del %HOMEDRIVE%\Users\%username%\AppData\Roaming\OpenShell\Pinned\startscreen.lnk /f > NUL 2>&1
	goto configureopenshell
) else (
	goto testos
)

:configureopenshell
for /f "tokens=* USEBACKQ" %%i in (`wmic useraccount where "name="%username%"" get sid ^| findstr "S-"`) do set currentusername=%%i
set currentusername=%currentusername:~0,-3%
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell" /t REG_SZ /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\OpenShell" /t REG_SZ /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\OpenShell\Settings" /t REG_SZ /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\StartMenu" /t REG_SZ /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\StartMenu\Settings" /t REG_SZ /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\ClassicExplorer" /t REG_SZ /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\ClassicExplorer\Settings" /t REG_SZ /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\ClassicExplorer" /v "ShowedToolbar" /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\ClassicExplorer" /v "NewLine" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\ClassicExplorer\Settings" /v "ShowStatusBar" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\StartMenu" /v "ShowedStyle2" /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\StartMenu" /v "CSettingsDlg" /t REG_BINARY /d c80100001a0100000000000000000000360d00000100000000000000 /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\StartMenu" /v "OldItems" /t REG_BINARY /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\StartMenu" /v "ItemRanks" /t REG_BINARY /d 0 /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\StartMenu\MRU" /v "0" /t REG_SZ /d "C:\Windows\regedit.exe" /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\StartMenu\Settings" /v "Version" /t REG_DWORD /d 04040098 /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\StartMenu\Settings" /v "AllProgramsMetro" /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\StartMenu\Settings" /v "RecentMetroApps" /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\StartMenu\Settings" /v "StartScreenShortcut" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\StartMenu\Settings" /v "SearchInternet" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\StartMenu\Settings" /v "GlassOverride" /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\StartMenu\Settings" /v "GlassColor" /t REG_DWORD /d 0 /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\StartMenu\Settings" /v "SkinW7" /t REG_SZ /d "Midnight" /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\StartMenu\Settings" /v "SkinVariationW7 /t REG_SZ /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\StartMenu\Settings" /v "SkinOptionsW7" /t REG_MULTI_SZ /d "USER_IMAGE=1"\0"SMALL_ICONS=0"\0"LARGE_FONT=0"\0"DISABLE_MASK=0"\0"OPAQUE=0"\0"TRANSPARENT_LESS=0"\0"TRANSPARENT_MORE=1"\0"WHITE_SUBMENUS2=0" /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\StartMenu\Settings" /v "SkipMetro" /t REG_DWORD /d 1 /f > NUL 2>&1
reg add "HKEY_USERS\%currentusername%\SOFTWARE\OpenShell\StartMenu\Settings" /v "MenuItems7" /t REG_MULTI_SZ /d "Item1.Command=user_files"\0"Item1.Settings=NOEXPAND"\0"Item2.Command=user_documents"\0"Item2.Settings=NOEXPAND"\0"Item3.Command=user_pictures"\0"Item3.Settings=NOEXPAND"\0"Item4.Command=user_music"\0"Item4.Settings=NOEXPAND"\0"Item5.Command=user_videos"\0"Item5.Settings=NOEXPAND"\0"Item6.Command=downloads"\0"Item6.Settings=NOEXPAND"\0"Item7.Command=homegroup"\0"Item7.Settings=ITEM_DISABLED"\0"Item8.Command=separator"\0"Item9.Command=games"\0"Item9.Settings=TRACK_RECENT|NOEXPAND|ITEM_DISABLED"\0"Item10.Command=favorites"\0"Item10.Settings=ITEM_DISABLED"\0"Item11.Command=recent_documents"\0"Item12.Command=computer"\0"Item12.Settings=NOEXPAND"\0"Item13.Command=network"\0"Item13.Settings=ITEM_DISABLED"\0"Item14.Command=network_connections"\0"Item14.Settings=ITEM_DISABLED"\0"Item15.Command=separator"\0"Item16.Command=control_panel"\0"Item16.Settings=TRACK_RECENT"\0"Item17.Command=pc_settings"\0"Item17.Settings=TRACK_RECENT"\0"Item18.Command=admin"\0"Item18.Settings=TRACK_RECENT|ITEM_DISABLED"\0"Item19.Command=devices"\0"Item19.Settings=ITEM_DISABLED"\0"Item20.Command=defaults"\0"Item20.Settings=ITEM_DISABLED"\0"Item21.Command=help"\0"Item21.Settings=ITEM_DISABLED"\0"Item22.Command=run"\0"Item23.Command=apps"\0"Item23.Settings=ITEM_DISABLED"\0"Item24.Command=windows_security"\0"Item24.Settings=ITEM_DISABLED"\0" /f > NUL 2>&1

SETLOCAL ENABLEDELAYEDEXPANSION
SET LinkName=Firefox
SET Esc_LinkDest=%%HOMEDRIVE%%\Users\%username%\AppData\Roaming\OpenShell\Pinned\!LinkName!.lnk
SET Esc_LinkTarget=%%HOMEDRIVE%%\Program Files\Mozilla Firefox\Firefox.exe
SET cSctVBS=CreateShortcut.vbs
(
  echo Set oWS = WScript.CreateObject^("WScript.Shell"^) 
  echo sLinkFile = oWS.ExpandEnvironmentStrings^("!Esc_LinkDest!"^)
  echo Set oLink = oWS.CreateShortcut^(sLinkFile^) 
  echo oLink.TargetPath = oWS.ExpandEnvironmentStrings^("!Esc_LinkTarget!"^)
  echo oLink.Save
)1>!cSctVBS!
cscript //nologo .\!cSctVBS!
DEL !cSctVBS! /f /q

SETLOCAL ENABLEDELAYEDEXPANSION
SET LinkName=Mozilla Thunderbird
SET Esc_LinkDest=%%HOMEDRIVE%%\Users\user\AppData\Roaming\OpenShell\Pinned\!LinkName!.lnk
SET Esc_LinkTarget=%%HOMEDRIVE%%\Program Files\Mozilla Thunderbird\Thunderbird.exe
SET cSctVBS=CreateShortcut.vbs
(
  echo Set oWS = WScript.CreateObject^("WScript.Shell"^) 
  echo sLinkFile = oWS.ExpandEnvironmentStrings^("!Esc_LinkDest!"^)
  echo Set oLink = oWS.CreateShortcut^(sLinkFile^) 
  echo oLink.TargetPath = oWS.ExpandEnvironmentStrings^("!Esc_LinkTarget!"^)
  echo oLink.Save
)1>!cSctVBS!
cscript //nologo .\!cSctVBS!
DEL !cSctVBS! /f /q

del silent_installers.7z > NUL 2>&1
del OldNewExplorerCfg.exe > NUL 2>&1
del OldCalculatorforWindows10Cfg.exe > NUL 2>&1
del hardentoolsCfg.exe > NUL 2>&1
:: Download and configure OldNewExplorer
cls
echo.
echo  :: Installing Third Party Programs
echo.
echo Downloading...
wget -O silent_installers.7z https://wiki.ameliorated.info/lib/exe/fetch.php?media=silent_installers.7z > NUL 2>&1
cls
echo.
echo  :: Installing Third Party Programs
echo.
echo Extracting...
7z x silent_installers.7z > NUL 2>&1
cls
echo.
echo  :: Installing OldNewExplorer
echo.
echo Installing, please wait...
start OldNewExplorerCfg.exe > NUL 2>&1
timeout /t 15 /nobreak
taskkill /f /im explorer.exe > NUL 2>&1
taskkill /f /im OldNewExplorerCfg.exe > NUL 2>&1
start OldNewExplorerCfg.exe > NUL 2>&1
timeout /t 15 /nobreak
taskkill /f /im OldNewExplorerCfg.exe > NUL 2>&1
del OldNewExplorerCfg.exe > NUL 2>&1
cls
echo.
echo  :: Installing Old Calculator for Windows 10
echo.
start OldCalculatorforWindows10Cfg.exe > NUL 2>&1
timeout /t 10 /nobreak
del OldCalculatorforWindows10Cfg.exe > NUL 2>&1
cls
echo.
echo  :: Installing hardentools
echo.
start hardentoolsCfg.exe > NUL 2>&1
timeout /t 60 /nobreak
del hardentoolsCfg.exe > NUL 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSuperHidden /t REG_DWORD /d 0 /f > NUL 2>&1

goto reboot

:: Pls install mpv, it's better than vlc
:: reg add "HKEY_CLASSES_ROOT\Directory\shell\Open with MPV" /v icon /t REG_SZ /d "C:\\ProgramData\\chocolatey\\lib\\mpv.install\\tools\\mpv-document.ico" /f
:: reg add "HKCR\Directory\shell\Open with MPV\command" /v @ /t REG_SZ /d "mpv \"%1\"" /f

:: Open User preferences to configure administrator/user permissions
:user
cls
echo.
echo  :: Manual User Permission Adjustment...
echo.
timeout /t 2 /nobreak > NUL

net user administrator /active:yes
netplwiz

goto menu

:reboot
echo.
echo  :: WINDOWS 10 AME SETUP SCRIPT Version 2020.11.3
echo.
cls
echo A reboot is required to complete setup.
echo.
echo Press any key to reboot
pause > NUL
shutdown -r -t 1 -f
