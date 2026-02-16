@echo off
echo Starting AHK scripts and Epic Pen...

:: Launch Epic Pen
start "" "D:\Program Files (x86)\Epic Pen\epicpen.exe"

:: Launch first AHK script
start "" "D:\R2025\AHK\ahk-script\run-tts\run-tts-3.ahk"

:: Launch second AHK script
start "" "D:\R2025\AHK\ahk-script\run-tts\run-tts-4.ahk"

:: Launch additional AHK scripts
start "" "D:\26年D盘核心\2026_Code\AHK\01 图存F17.ahk"
start "" "D:\26年D盘核心\2026_Code\AHK\02 文本快输.ahk"

echo All scripts and programs started successfully!
pause
