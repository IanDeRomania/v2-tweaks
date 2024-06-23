    $packagePrefixes = 'Clipchamp.Clipchamp_', 'Microsoft.SecHealthUI_', 'Microsoft.Windows.PeopleExperienceHost_', 'Microsoft.Windows.PinningConfirmationDialog_', 'Windows.CBSPreview_', 'Microsoft.BingNews_', 'Microsoft.BingWeather_', 'Microsoft.GamingApp_', 'Microsoft.GetHelp_', 'Microsoft.Getstarted_', 'Microsoft.MicrosoftOfficeHub_', 'Microsoft.MicrosoftSolitaireCollection_', 'Microsoft.People_', 'Microsoft.PowerAutomateDesktop_', 'Microsoft.Todos_', 'Microsoft.WindowsAlarms_', 'microsoft.windowscommunicationsapps_', 'Microsoft.WindowsFeedbackHub_', 'Microsoft.WindowsMaps_', 'Microsoft.WindowsSoundRecorder_', 'Microsoft.Xbox.TCUI_', 'Microsoft.XboxGamingOverlay_', 'Microsoft.XboxGameOverlay_', 'Microsoft.XboxSpeechToTextOverlay_', 'Microsoft.YourPhone_',  'MicrosoftCorporationII.MicrosoftFamily_', 'MicrosoftCorporationII.QuickAssist_', 'MicrosoftTeams_', 'Microsoft.549981C3F5F10_'


    foreach ($Bloat in $packagePrefixes) {
        Get-AppxPackage -Name $Bloat| Remove-AppxPackage
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online
        Write-Output "Trying to remove $Bloat."
    }