#NoEnv
SendMode Input
SetBatchLines, -1
ListLines Off
SetKeyDelay, -1
SetMouseDelay, -1
SetControlDelay, -1
SetWinDelay, -1
SetTitleMatchMode, 2

imgPath := "D:\RX\QK变量\2025年11月13日.png"
outputFile := "D:\R2025\AHK\ahk-script\run-tts\run-tts-3信息.md"
soundFile := "D:\Users\Ran\Downloads\炫酷的界面点击音mixkit-cool-interface-click-tone-2568.wav"
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
    Send, ^+7
    Sleep, 10
    Send, ^+2
    Sleep, 10
    Send, ^+0

    Sleep, 300

    ; ==================================
    ; 3. 立即 粘贴图片 + 写入编号
    ; ==================================
    Send, ^v
    Sleep, 150
    num := GetTodayCounter()
    SendInput, %num%
    Send, {Enter}
    Sleep, 150

    ; ==================================
    ; 4. 然后再进行图像判断逻辑
    ; ==================================
    SysGet, L, 76
    SysGet, T, 77
    SysGet, R, 78
    SysGet, B, 79

    ImageSearch, fx, fy, L, T, R, B, *0 %imgPath%

    if (ErrorLevel = 0)
    {
        FileDelete, %outputFile%
        FileAppend, 找到图像坐标：X=%fx% , Y=%fy%`n, %outputFile%

        ; 成功发送 → 结尾提示音
        SoundPlay, %soundFile%
    }
    else if (ErrorLevel = 1)
    {
        MsgBox, 48, 图像检测, 未找到图像。
    }
    else
    {
        MsgBox, 16, 图像检测, 搜索出错（ErrorLevel=%ErrorLevel%）。
    }

    return
}
