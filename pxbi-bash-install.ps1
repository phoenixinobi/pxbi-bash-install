<# 
.SYNOPSIS 
   Installs Bash on Windows 10. 
.DESCRIPTION 
   This script will install Bash on Windows 10, including the necessary OS preparations.
.NOTES 
   Created by: phoenixinobi
#>
Begin {
    Write-Host "Checking Windows 10 Build Number..."
    $WindowsBuild = (Get-WmiObject -Class Win32_OperatingSystem).BuildNumber
    Write-Host "Windows 10 Build Number is" $WindowsBuild
    if ((Get-WmiObject -Class Win32_OperatingSystem).BuildNumber -lt 14393) {
        Write-Warning "This build of Windows 10 is unsupported. Please upgrade to Windows 10 Build Number 14393 or greater. Bash on Windows 10 was not installed. Exiting pxbi-bash-install."
        exit 1
    }
}
Process {
    Write-Host "Processing..."
    Write-Host "Enabling Windows 10 Developer Mode..."
    try {
        $RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
        if (-not(Test-Path -Path $RegistryKeyPath)) {
            New-Item -Path $RegistryKeyPath -ItemType "Directory" -Force
        }
        Set-ItemProperty -Path $RegistryKeyPath -Name "AllowDevelopmentWithoutDevLicense" -Value 1
    }
    catch [System.Exception] {
        Write-Warning "Process failed to enable Windows 10 Developer Mode. Exiting pxbi-bash-install."
        exit 1
    }
    Write-Host "Windows 10 Developer Mode is now enabled."
    Write-Host "Turning on Windows Subsystem for Linux Feature..."
    try {
        Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -All -LimitAccess -NoRestart -ErrorAction Stop
    }
    catch [System.Exception] {
        Write-Warning "Process failed to turn on Windows Subsystem for Linux Feature. Exiting pxbi-bash-install."
        exit 1
    }
    Write-Host "Windows Subsystem for Linux Feature has been turned on."
}
End {
    Write-Host "Setting-up continue step..."
    $RegistryAutoRunKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"
    $PowerShellExe = Join-Path $env:windir "system32\WindowsPowerShell\v1.0\powershell.exe"
    $ScriptFile = Join-Path $PSScriptRoot "pxbi-bash-install-2.ps1"

    Set-ItemProperty -Path $RegistryAutoRunKeyPath -Name "!Windows10BashSetup" -Value "$PowerShellExe $ScriptFile"
    Write-Host "Continue step has been set-up."
    Write-Host "Windows 10 needs to reboot to continue with the set-up."
    Start-Sleep (1); Write-Host "Rebooting in 5..."
    Start-Sleep (1); Write-Host "Rebooting in 4..."
    Start-Sleep (1); Write-Host "Rebooting in 3..."
    Start-Sleep (1); Write-Host "Rebooting in 2..."
    Start-Sleep (1); Write-Host "Rebooting in 1..."
    Start-Sleep (1); Restart-Computer
}