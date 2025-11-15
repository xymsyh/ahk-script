@echo off
echo Starting AHK scripts and Epic Pen...

:: Launch Epic Pen
start "" "D:\Program Files (x86)\Epic Pen\epicpen.exe"

:: Launch first AHK script
start "" "D:\R2025\AHK\ahk-script\run-tts\run-tts-3.ahk"

:: Launch second AHK script
start "" "D:\R2025\AHK\ahk-script\run-tts\run-tts-4.ahk"

echo All scripts and programs started successfully!
pause