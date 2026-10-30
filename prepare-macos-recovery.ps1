# Downloads the official macOS recovery image from Apple's servers and
# converts it to a VMware disk (recovery.vmdk) you attach to a new VM.
#
#   Tahoe (default):  .\prepare-macos-recovery.ps1
#   Sequoia:          .\prepare-macos-recovery.ps1 -Version Sequoia
#
# Sources: macrecovery.py from acidanthera/OpenCorePkg (GitHub), recovery
# image from Apple, qemu-img from the QEMU package in winget.

param(
    [ValidateSet('Tahoe', 'Sequoia')]
    [string]$Version = 'Tahoe',
    [string]$OutDir = 'D:\macOS-VM'
)

$ErrorActionPreference = 'Stop'
function Step($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }

# Board IDs from OpenCorePkg Utilities/macrecovery/recovery_urls.txt
$recoveryArgs = @{
    Tahoe   = @('-b', 'Mac-CFF7D910A743CAAF', '-m', '00000000000000000', '-os', 'latest')
    Sequoia = @('-b', 'Mac-7BA5B2D9E42DDD94', '-m', '00000000000000000')
}

$toolsDir    = Join-Path $OutDir 'tools'
$recoveryDir = Join-Path $OutDir "recovery-$Version"
$vmdk        = Join-Path $OutDir "$Version-recovery.vmdk"
New-Item -ItemType Directory -Force $toolsDir, $recoveryDir | Out-Null

# --- Python ---
$python = (Get-Command python.exe -ErrorAction SilentlyContinue).Source
if (-not $python -or $python -like '*WindowsApps*') { throw 'Python not found. Install it from python.org first.' }

# --- 1. macrecovery.py ---
$macrecovery = Join-Path $toolsDir 'macrecovery.py'
$repoBase = 'https://raw.githubusercontent.com/acidanthera/OpenCorePkg/master/Utilities/macrecovery'
foreach ($file in 'macrecovery.py', 'boards.json') {
    $target = Join-Path $toolsDir $file
    if (-not (Test-Path $target)) {
        Step "Downloading $file from acidanthera/OpenCorePkg"
        Invoke-WebRequest "$repoBase/$file" -OutFile $target -UseBasicParsing
    }
}

# --- 2. Recovery image from Apple ---
$dmg = Join-Path $recoveryDir 'BaseSystem.dmg'
if (-not (Test-Path $dmg)) {
    Step "Downloading macOS $Version recovery from Apple (~1 GB)"
    & $python -I $macrecovery @($recoveryArgs[$Version]) -n BaseSystem -o $recoveryDir download
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path $dmg)) { throw 'Recovery download failed' }
}

# --- 3. qemu-img ---
$qemuImg = 'C:\Program Files\qemu\qemu-img.exe'
if (-not (Test-Path $qemuImg)) {
    Step 'Installing QEMU (for qemu-img) via winget'
    winget install --id SoftwareFreedomConservancy.QEMU -e --accept-source-agreements --accept-package-agreements
    if (-not (Test-Path $qemuImg)) { throw "qemu-img not found at $qemuImg after install" }
}

# --- 4. Convert to VMDK ---
Step "Converting to $vmdk"
if (Test-Path $vmdk) { Remove-Item $vmdk }
& $qemuImg convert -O vmdk -o compat6 $dmg $vmdk
if ($LASTEXITCODE -ne 0) { throw 'qemu-img convert failed' }

Step 'Done'
Get-Item $vmdk | Select-Object FullName, @{n='SizeMB'; e={[math]::Round($_.Length / 1MB)}} | Format-List
Write-Host "Attach this file to the VM as an existing SATA hard disk (see tahoe-vmware-guide.md)." -ForegroundColor Yellow
