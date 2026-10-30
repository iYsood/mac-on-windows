@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0prepare-macos-recovery.ps1" %*
pause
