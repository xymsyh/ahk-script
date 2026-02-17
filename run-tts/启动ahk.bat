@echo off
chcp 65001 >nul
setlocal

echo Starting AHK scripts and Epic Pen...

set AHK_EXE=C:\Program Files\AutoHotkey\AutoHotkey.exe

start "" "D:\Program Files (x86)\Epic Pen\epicpen.exe"

start "" "%AHK_EXE%" "D:\R2025\AHK\ahk-script\run-tts\run-tts-3.ahk"
start "" "%AHK_EXE%" "D:\R2025\AHK\ahk-script\run-tts\run-tts-4.ahk"
start "" "%AHK_EXE%" "D:\26年D盘核心\2026_Code\AHK\01 图存F17.ahk"
start "" "%AHK_EXE%" "D:\26年D盘核心\2026_Code\AHK\02 文本快输.ahk"

echo All scripts and programs started successfully!
pause
