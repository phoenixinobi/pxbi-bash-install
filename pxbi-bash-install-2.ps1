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
        Write-Warning "This build of Windows 10 is unsupported. Please upgrade to Windows 10 Build Number 14393 or greater. Bash on Windows 10 was not installed. Exiting bash-install."
        exit 1
    }
}
Process {
    Write-Host "Processing..."
    Write-Host "Installing Bash on Windows 10..."
    try {
        $command = 'cmd.exe /C "lxrun /install /y"'
        Invoke-Expression -Command:$command
    }
    catch [System.Exception] {
        Write-Warning "Process failed to install Bash on Windows 10. Exiting bash-install."
        exit 1
    }
    Write-Host "Bash on Windows 10 is now installed."
}
End {
    Write-Host "Exiting bash-install."
}
