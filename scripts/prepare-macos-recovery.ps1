# Downloads the official macOS recovery image from Apple's servers and
# converts it to a virtual disk you attach to a new VM.
#
#   .\prepare-macos-recovery.ps1                                  # Tahoe, VMware (.vmdk)
#   .\prepare-macos-recovery.ps1 -Version Sequoia
#   .\prepare-macos-recovery.ps1 -Version Ventura -Format vdi     # VirtualBox
#   .\prepare-macos-recovery.ps1 -OutDir D:\macOS-VM
#
# Sources: macrecovery.py from acidanthera/OpenCorePkg (GitHub), recovery
# image from Apple, qemu-img from the QEMU package in winget.

param(
    [ValidateSet('Tahoe', 'Sequoia', 'Sonoma', 'Ventura', 'Monterey')]
    [string]$Version = 'Tahoe',
    [ValidateSet('vmdk', 'vdi')]
    [string]$Format = 'vmdk',
    [string]$OutDir = (Join-Path $HOME 'macOS-VM')
)

$ErrorActionPreference = 'Stop'
function Step($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }

# Board IDs from OpenCorePkg Utilities/macrecovery/recovery_urls.txt
$recoveryArgs = @{
    Tahoe    = @('-b', 'Mac-CFF7D910A743CAAF', '-m', '00000000000000000', '-os', 'latest')
    Sequoia  = @('-b', 'Mac-7BA5B2D9E42DDD94', '-m', '00000000000000000')
    Sonoma   = @('-b', 'Mac-827FAC58A8FDFA22', '-m', '00000000000000000')
    Ventura  = @('-b', 'Mac-B4831CEBD52A0C4C', '-m', '00000000000000000')
    Monterey = @('-b', 'Mac-E43C1C25D4880AD6', '-m', '00000000000000000')
}

$toolsDir    = Join-Path $OutDir 'tools'
$recoveryDir = Join-Path $OutDir "recovery-$Version"
$disk        = Join-Path $OutDir "$Version-recovery.$Format"
New-Item -ItemType Directory -Force $toolsDir, $recoveryDir | Out-Null

# --- Python ---
$python = (Get-Command python.exe -ErrorAction SilentlyContinue).Source
if (-not $python -or $python -like '*WindowsApps*') { throw 'Python 3 not found. Install it from python.org first.' }

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

# --- 4. Convert ---
Step "Converting to $disk"
if (Test-Path $disk) { Remove-Item $disk }
if ($Format -eq 'vmdk') {
    & $qemuImg convert -O vmdk -o compat6 $dmg $disk
} else {
    & $qemuImg convert -O vdi $dmg $disk
}
if ($LASTEXITCODE -ne 0) { throw 'qemu-img convert failed' }

Step 'Done'
Get-Item $disk | Select-Object FullName, @{n='SizeMB'; e={[math]::Round($_.Length / 1MB)}} | Format-List
Write-Host 'Attach this file to the VM as an existing SATA hard disk (see docs/).' -ForegroundColor Yellow
