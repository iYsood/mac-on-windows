@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0configure-virtualbox-vm.ps1" %*
pause
