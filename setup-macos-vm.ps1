# Prepares this PC to run the "MacOS" VirtualBox VM at full speed.
#  1. Turns off the Windows hypervisor (Hyper-V) so VirtualBox can use VT-x
#     directly instead of the slow NEM fallback.
#  2. Tunes the VM: more CPUs/RAM, 1920x1080 EFI resolution.
# Undo with revert-macos-vm.ps1.

param([string]$VmName = 'MacOS')

$ErrorActionPreference = 'Stop'

# Relaunch elevated if needed
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -VmName `"$VmName`""
    exit
}

function Step($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }

# --- Locate VBoxManage ---
$installDir = (Get-ItemProperty 'HKLM:\SOFTWARE\Oracle\VirtualBox' -ErrorAction SilentlyContinue).InstallDir
if (-not $installDir) { $installDir = 'C:\Program Files\Oracle\VirtualBox\' }
$vbm = Join-Path $installDir 'VBoxManage.exe'
if (-not (Test-Path $vbm)) { throw "VBoxManage.exe not found at $vbm" }

# --- 1. Hypervisor off ---
Step 'Turning off the Windows hypervisor (hypervisorlaunchtype off)'
& bcdedit /set hypervisorlaunchtype off
if ($LASTEXITCODE -ne 0) { throw 'bcdedit failed' }

# --- 2. VM settings ---
Step "Tuning VM '$VmName'"
$state = (& $vbm showvminfo $VmName --machinereadable | Select-String '^VMState=').ToString().Split('=')[1].Trim('"')
if ($state -ne 'poweroff' -and $state -ne 'aborted') {
    $answer = Read-Host "VM is '$state'. Power it off now? Unsaved work inside macOS will be lost (y/n)"
    if ($answer -ne 'y') { throw 'Close the VM first, then run this script again.' }
    & $vbm controlvm $VmName poweroff
    Start-Sleep -Seconds 3
}

& $vbm modifyvm $VmName --cpus 8 --memory 16384 --vram 128 --nested-paging on --large-pages on
if ($LASTEXITCODE -ne 0) { throw 'VBoxManage modifyvm failed' }
& $vbm setextradata $VmName 'VBoxInternal2/EfiGraphicsResolution' '1920x1080'
if ($LASTEXITCODE -ne 0) { throw 'VBoxManage failed' }

Step 'Done. Current VM settings:'
& $vbm showvminfo $VmName --machinereadable | Select-String '^(cpus|memory|vram|nestedpaging|largepages)='

Write-Host "`nIMPORTANT: Restart Windows now, then check BIOS has Intel VT-x enabled." -ForegroundColor Yellow
Write-Host 'After restart, VBox.log should NOT contain "fall back to NEM".' -ForegroundColor Yellow
Read-Host "`nPress Enter to close"
