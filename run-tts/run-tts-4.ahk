#NoEnv
SendMode Input
SetBatchLines, -1
ListLines Off
SetKeyDelay, -1
SetMouseDelay, -1
SetControlDelay, -1
SetWinDelay, 0
SetTitleMatchMode, 2

; ==========================
; 全局变量
; ==========================
global imgPaths := []
imgPaths.Push("D:\RX\QK变量\2025年11月13日.png")
imgPaths.Push("D:\RX\QK变量\2025年11月15日2.png")
imgPaths.Push("D:\RX\QK变量\2025年11月15日.png")

global outputFile := "D:\R2025\AHK\ahk-script\run-tts\run-tts-3信息.md"
global counterFile := "D:\R2025\AHK\ahk-script\run-tts\counter.txt"
global soundFile := "D:\Users\Ran\Downloads\mixkit-cool-interface-click-tone-2568.wav"

; ==========================
; 每天编号
; ==========================
GetTodayCounter() {
    global counterFile
    today := A_YYYY A_MM A_DD

    if (FileExist(counterFile)) {
        FileRead, ct, %counterFile%
        StringSplit, arr, ct, |
        lastDate := arr1
        lastCount := arr2
        newCount := (lastDate = today ? lastCount + 1 : 1)
    } else {
        newCount := 1
    }

    FileDelete, %counterFile%
    FileAppend, %today%|%newCount%, %counterFile%
    return newCount
}

; ==========================
; 不锁文件的播放
; ==========================
SafePlaySound(file) {
    if !FileExist(file)
        return

    DllCall("winmm.dll\mciSendString", "Str", "close all", "Str", "", "UInt", 0, "UInt")
    SoundPlay, %file%
}

; ==========================
; 主逻辑
; ==========================
F16::
{
    ; --- 截图 ---
    Send, {PrintScreen}
    Sleep, 10

    Send, ^+!w
    Sleep, 10

    Send, ^+7
    Sleep, 10
    Send, ^+2
    Sleep, 10
    Send, ^+0
    Sleep, 300

    ; --- 粘贴 ---
    Send, ^v
    Sleep, 150
    num := GetTodayCounter()
    SendInput, %num%
    Sleep, 10

    SysGet, L, 76
    SysGet, T, 77
    SysGet, R, 78
    SysGet, B, 79

    found := false
    lastErr := -1

    Loop, % imgPaths.Length() {
        img := imgPaths[A_Index]

        ImageSearch, fx, fy, L, T, R, B, *0 %img%
        thisErr := ErrorLevel
        lastErr := thisErr

        if (thisErr = 0) {
            found := true
            break
        }
    }

    if (found) {
        FileDelete, %outputFile%
        FileAppend, 找到图像坐标：X=%fx% , Y=%fy%`n, %outputFile%
        SafePlaySound(soundFile)
        Send, {Enter}

    } else if (lastErr = 1) {
        MsgBox, 48, 图像检测, 未找到任何图片。

    } else if (lastErr = 2) {
        MsgBox, 16, 图像检测, 图片文件错误或 GDI+ 错误。

    } else {
        MsgBox, 16, 图像检测, 未知错误（ErrorLevel=%lastErr%）。
    }

    return
}
