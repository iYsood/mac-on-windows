# Undoes setup-macos-vm.ps1: turns the Windows hypervisor back on
# (needed for WSL2, Docker, Hyper-V, Windows Sandbox).

$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

& bcdedit /set hypervisorlaunchtype auto
Write-Host "`nHypervisor re-enabled. Restart Windows to apply." -ForegroundColor Yellow
Read-Host "`nPress Enter to close"
