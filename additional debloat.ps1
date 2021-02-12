If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
#"No Administrative rights, it will display a popup window asking user for Admin rights"

$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $arguments

break
}
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.549981C3F5F10_1.1911.21713.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.BingWeather_4.12.3003.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.DesktopAppInstaller_2020.1111.2238.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.GetHelp_10.1706.13331.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.Getstarted_9.13.33161.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.HEIFImageExtension_1.0.32532.0_x64__8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.Microsoft3DViewer_6.1908.2042.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.MicrosoftEdge.Stable_88.0.705.63_neutral__8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.MicrosoftOfficeHub_18.1903.1152.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.MicrosoftSolitaireCollection_4.4.8204.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.MicrosoftStickyNotes_3.6.73.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.MixedReality.Portal_2000.19081.1301.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.Office.OneNote_16001.13530.20492.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.People_2020.901.1724.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.ScreenSketch_2020.814.2355.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.SkypeApp_15.68.96.0_neutral_~_kzf8qxf38zg5c
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.StorePurchaseApp_11811.1001.1813.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.VCLibs.140.00_14.0.27323.0_x64__8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.VP9VideoExtensions_1.0.32521.0_x64__8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.Wallet_2.4.18324.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.WebMediaExtensions_1.0.20875.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.WebpImageExtension_1.0.22753.0_x64__8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.Windows.Photos_2020.20110.11001.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.WindowsAlarms_2021.2009.5.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.WindowsCalculator_2020.1906.55.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.WindowsCamera_2020.902.20.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName microsoft.windowscommunicationsapps_16005.13426.20566.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.WindowsFeedbackHub_2021.105.2306.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.WindowsMaps_2021.2012.10.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.WindowsSoundRecorder_2019.716.2313.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.WindowsStore_11910.1002.513.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.Xbox.TCUI_1.24.10001.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.XboxApp_48.49.31001.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.XboxGameOverlay_1.46.11001.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.XboxGamingOverlay_5.420.11102.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.XboxIdentityProvider_12.67.21001.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.XboxSpeechToTextOverlay_1.21.13002.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.YourPhone_2019.430.2026.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.ZuneMusic_2019.20122.11121.0_neutral_~_8wekyb3d8bbwe
Remove-ProvisionedAppxPackage -Online -PackageName Microsoft.ZuneVideo_2019.20112.10111.0_neutral_~_8wekyb3d8bbwe