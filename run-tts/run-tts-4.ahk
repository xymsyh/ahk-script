#NoEnv
SendMode Input
SetBatchLines, -1
ListLines Off
SetKeyDelay, -1
SetMouseDelay, -1
SetControlDelay, -1
SetWinDelay, -1
SetTitleMatchMode, 2

; ---------- 支持多张图片 ----------
imgPaths := ["D:\RX\QK变量\2025年11月13日.png"
           , "D:\RX\QK变量\2025年11月15日2.png"
           , "D:\RX\QK变量\2025年11月15日3.png"
           , "D:\RX\QK变量\2025年11月15日4.png"
           , "D:\RX\QK变量\2025年11月15日.png"]  ; 可继续添加
outputFile := "D:\R2025\AHK\ahk-script\run-tts\run-tts-3信息.md"
soundFile := "D:\Users\Ran\Downloads\mixkit-select-click-1109 (1).wav"
ErrorSoundFile := "D:\Users\Ran\Downloads\mixkit-click-error-1110.wav"
counterFile := "D:\R2025\AHK\ahk-script\run-tts\counter.txt"

; ==========================================
; 读取 / 更新 当天编号（每天从 1 开始）
; ==========================================
GetTodayCounter() {
    global counterFile
    today := A_YYYY A_MM A_DD

    if (FileExist(counterFile)) {
        FileRead, ct, %counterFile%
        StringSplit, arr, ct, |
        lastDate := arr1
        lastCount := arr2

        if (lastDate = today) {
            newCount := lastCount + 1
        } else {
            newCount := 1
        }
    } else {
        newCount := 1
    }

    FileDelete, %counterFile%
    FileAppend, %today%|%newCount%, %counterFile%

    return newCount
}

F16::
{
    SoundPlay, %soundFile%

    ; -------------------
    ; 1. 截图 → 剪贴板
    ; -------------------
    Send, {PrintScreen}
    Sleep, 10

    ; -------------------
    ; 2. 触发 Ctrl+Shift+Alt+W
    ; -------------------
    Send, ^+!w
    Sleep, 10

    ; 清空 epic pen
    Send, {F21}
    Sleep, 300
    Sleep, 300

    ; ==================================
    ; 3. 粘贴图片 + 写入编号
    ; ==================================
    Send, ^v
    num := GetTodayCounter()
    SendInput, %num%
    Sleep, 10

    ; ==================================
    ; 4. 图像判断逻辑（支持多图片）
    ; ==================================
    SysGet, L, 76
    SysGet, T, 77
    SysGet, R, 78
    SysGet, B, 79

    found := false
    Loop, % imgPaths.Length() {
        img := imgPaths[A_Index]
        ImageSearch, fx, fy, L, T, R, B, *0 %img%
        if (ErrorLevel = 0) {
            found := true
            break  ; 找到任意一张图片就停止
        }
    }

    if (found) {
        FileDelete, %outputFile%
        FileAppend, 找到图像坐标：X=%fx% , Y=%fy%`n, %outputFile%

        ; 成功发送 → 结尾提示音
        Sleep, 300
        Send, {Enter}
        Sleep, 100
        Send, ^+!w
        SoundPlay, %soundFile%
    } 
    else {
        ; ❗ 未找到任何图片 → 播放错误提示音
        SoundPlay, %ErrorSoundFile%
    }

    return
}
