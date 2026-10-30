# Applies the settings macOS needs to boot in VirtualBox (Monterey / Ventura).
# The VM must already exist (Type: Mac OS X, Version: Mac OS X 64-bit, EFI on)
# and be powered off.
#
#   .\configure-virtualbox-vm.ps1 -VmName "macOS Ventura"
#   .\configure-virtualbox-vm.ps1 -VmName "macOS Ventura" -Cpus 8 -MemoryMB 16384

param(
    [Parameter(Mandatory)] [string]$VmName,
    [int]$Cpus = 4,
    [int]$MemoryMB = 8192
)

$ErrorActionPreference = 'Stop'

$installDir = (Get-ItemProperty 'HKLM:\SOFTWARE\Oracle\VirtualBox' -ErrorAction SilentlyContinue).InstallDir
if (-not $installDir) { $installDir = 'C:\Program Files\Oracle\VirtualBox\' }
$vbm = Join-Path $installDir 'VBoxManage.exe'
if (-not (Test-Path $vbm)) { throw "VBoxManage.exe not found at $vbm" }

function Vbm {
    & $vbm @args
    if ($LASTEXITCODE -ne 0) { throw "VBoxManage $($args -join ' ') failed" }
}

$state = ((& $vbm showvminfo $VmName --machinereadable) | Select-String '^VMState=').ToString().Split('=')[1].Trim('"')
if ($state -ne 'poweroff' -and $state -ne 'aborted') { throw "VM '$VmName' is '$state'. Power it off first." }

Vbm modifyvm $VmName --cpus $Cpus --memory $MemoryMB --vram 128 --firmware efi --chipset ich9 `
    --nested-paging on --large-pages on --mouse usbtablet --keyboard usb --usb-xhci on

# Present the CPU and SMBIOS of a supported Intel iMac (iMac19,1)
Vbm modifyvm $VmName --cpuid-set 00000001 000106e5 00100800 0098e3fd bfebfbff
Vbm setextradata $VmName 'VBoxInternal/Devices/efi/0/Config/DmiSystemProduct' 'iMac19,1'
Vbm setextradata $VmName 'VBoxInternal/Devices/efi/0/Config/DmiSystemVersion' '1.0'
Vbm setextradata $VmName 'VBoxInternal/Devices/efi/0/Config/DmiBoardProduct' 'Mac-AA95B1DDAB278B95'
Vbm setextradata $VmName 'VBoxInternal/Devices/smc/0/Config/DeviceKey' 'ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc'
Vbm setextradata $VmName 'VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC' '0'
Vbm setextradata $VmName 'VBoxInternal/TM/TSCMode' 'RealTSCOffset'
Vbm setextradata $VmName 'VBoxInternal2/EfiGraphicsResolution' '1920x1080'

Write-Host "`nVM '$VmName' configured." -ForegroundColor Green
