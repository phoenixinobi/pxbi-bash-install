<# 
.SYNOPSIS 
   Installs Bash on Windows 10. 
.DESCRIPTION 
   This script will install Bash on Windows 10, including the necessary OS preparations.
.NOTES 
   Created by: phoenixinobi
   Modified: 03/29/2017 08:08:00 PM
#>
Begin {
    Write-Host "Checking Windows 10 Build Number..."
    $WindowsBuild = (Get-WmiObject -Class Win32_OperatingSystem).BuildNumber
    Write-Host "Windows 10 Build Number is" $WindowsBuild
    if ((Get-WmiObject -Class Win32_OperatingSystem).BuildNumber -lt 14393) {
        Write-Warning "This build of Windows 10 is unsupported. Please upgrade to Windows 10 Build Number 14393 or greater. Bash on Windows 10 was not installed. Exiting bash-install."
        exit 1
    }
}
Process {
    Write-Host "Processing..."
    Write-Host "Enabling Windows 10 Developer Mode..."
    try {
        $RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
        if (-not(Test-Path -Path $RegistryKeyPath)) {
            New-Item -Path $RegistryKeyPath -ItemType Directory -Force
        }
        Set-ItemProperty -Path $RegistryKeyPath -Name AllowDevelopmentWithoutDevLicense -Value 1
    }
    catch [System.Exception] {
        Write-Warning "Process failed to enable Windows 10 Developer Mode. Exiting bash-install."
        exit 1
    }
    Write-Host "Windows 10 Developer Mode is now enabled."
    Write-Host "Turning on Windows Subsystem for Linux Feature..."
    try {
        Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -All -LimitAccess -NoRestart -ErrorAction Stop
    }
    catch [System.Exception] {
        Write-Warning "Process failed to turn on Windows Subsystem for Linux Feature. Exiting bash-install."
        exit 1
    }
    Write-Host "Windows Subsystem for Linux Feature has been turned on."
    Restart-Computer -Wait
}
End {
    Write-Host "Exiting bash-install."
}
