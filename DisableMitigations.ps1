if (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" -Name "MitigationAuditOptions" -ErrorAction Ignore) {
	$mitigation_mask = & reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v MitigationAuditOptions
	$mitigation_mask = $mitigation_mask | Select-String -Pattern "MitigationAuditOptions\s+REG_BINARY\s+(\d+)" | ForEach-Object { $_.Matches.Groups[1].Value }
	$mitigation_mask = $mitigation_mask -replace '[\d]', '2'
	Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions" /t REG_BINARY /d "$mitigation_mask" /f > $null 2>&1
	Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_BINARY /d "$mitigation_mask" /f > $null 2>&1
} else {
	Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions" /t REG_BINARY /d "222222222222222222222222222222222222222222222222" /f > $null 2>&1
	Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationOptions" /t REG_BINARY /d "222222222222222222222222222222222222222222222222" /f > $null 2>&1
}
Reg Add "HKLM\System\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f > $null 2>&1
Reg Add "HKLM\System\CurrentControlSet\Control\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d "0" /f  > $null 2>&1
Reg Add "HKLM\Software\Policies\Microsoft\Internet Explorer\Main" /v "DEPOff" /t REG_DWORD /d "1" /f > $null 2>&1
Reg Add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "NoDataExecutionPrevention" /t REG_DWORD /d "1" /f > $null 2>&1
Reg Add "HKLM\Software\Policies\Microsoft\Windows\System" /v "DisableHHDEP" /t REG_DWORD /d "1" /f > $null 2>&1
Reg Add "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "DisableTsx" /t REG_DWORD /d "1" /f > $null 2>&1
Reg Add "HKLM\Software\Microsoft\PolicyManager\default\DmaGuard\DeviceEnumerationPolicy" /v "value" /t REG_DWORD /d "2" /f > $null 2>&1
Reg Add "HKLM\Software\Policies\Microsoft\FVE" /v "DisableExternalDMAUnderLock" /t REG_DWORD /d "0" /f > $null 2>&1
Reg Add "HKLM\System\CurrentControlSet\Control\DeviceGuard" /v "HVCIMATRequired" /t REG_DWORD /d "0" /f > $null 2>&1
Reg Add "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f > $null 2>&1
Reg Add "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f > $null 2>&1
Reg Add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f > $null 2>&1
Reg Add "HKLM\System\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f > $null 2>&1
Reg Add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f > $null 2>&1
Reg Add "HKLM\SOFTWARE\Microsoft\WindowsMitigation" /v "UserPreference" /t REG_DWORD /d "2" /f > $null 2>&1
Reg Add "HKLM\SYSTEM\CurrentControlSet\Control\SCMConfig" /v "EnableSvchostMitigationPolicy" /t REG_BINARY /d "0000000000000000" /f > $null 2>&1
Rename-Item -Path "$env:WinDir\System32\mcupdate_GenuineIntel.dll" -NewName "mcupdate_GenuineIntel.old" -Force -ErrorAction SilentlyContinue
BCDEdit /set nx optin > $null 2>&1

# Disable CFG for the system
Set-ProcessMitigation -System -Disable CFG > $null 2>&1

# Fix Valorant with mitigations disabled - enable CFG
$enableCFGApps = "valorant", "valorant-win64-shipping", "vgtray", "vgc"
foreach ($app in $enableCFGApps) {
    Set-ProcessMitigation -Name "$app.exe" -Enable CFG > $null 2>&1
}

Set-NetTCPSetting -SettingName "*" -MemoryPressureProtection Disabled -ErrorAction SilentlyContinue
$processors = Get-WmiObject -Class Win32_Processor
$CPU = $processors.Name
# Check GPU 0
if ($CPU -like "*AMD*") {
	# CPU is AMD
 	Reg Add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "1" /f > $null 2>&1
	Reg Add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "2" /f > $null 2>&1
} else {
	# CPU is Intel
 	Reg Add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettings" /t REG_DWORD /d "0" /f > $null 2>&1
	Reg Add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f > $null 2>&1
}


