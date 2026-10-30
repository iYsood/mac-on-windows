# Turns off the Windows hypervisor (Hyper-V) so VMware / VirtualBox can use
# Intel VT-x / AMD-V directly instead of the slow Hyper-V fallback (NEM).
# WSL2, Docker Desktop, Windows Sandbox and Hyper-V VMs stop working until
# you run enable-hyperv.ps1. A restart is required either way.

$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

& bcdedit /set hypervisorlaunchtype off
if ($LASTEXITCODE -ne 0) {
    Write-Host 'bcdedit failed.' -ForegroundColor Red
} else {
    Write-Host "`nHypervisor disabled. Restart Windows to apply." -ForegroundColor Yellow
    Write-Host 'Also make sure Intel VT-x / AMD SVM is enabled in BIOS.' -ForegroundColor Yellow
}
Read-Host "`nPress Enter to close"
