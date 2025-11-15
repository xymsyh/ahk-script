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

    ; 写回文件：格式 YYYYMMDD|编号
    FileDelete, %counterFile%
    FileAppend, %today%|%newCount%, %counterFile%

    return newCount
}

F16::
{
    ; 播放提示音（开头）
    SoundPlay, %soundFile%

    ; -------------------
    ; 1. 截图全屏到剪贴板
    ; -------------------
    Send, {PrintScreen}
    Sleep, 10

    ; -------------------
    ; 2. 发送 Ctrl+Shift+Alt+W
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

    ; -------------------
    ; 3. 获取屏幕坐标
    ; -------------------
    SysGet, L, 76
    SysGet, T, 77
    SysGet, R, 78
    SysGet, B, 79

    ; -------------------
    ; 4. 图像搜索
    ; -------------------
    ImageSearch, fx, fy, L, T, R, B, *0 %imgPath%

    if (ErrorLevel = 0)
    {
        ; 找到图像 → 写入坐标
        FileDelete, %outputFile%
        FileAppend, 找到图像坐标：X=%fx% , Y=%fy%`n, %outputFile%

        ; 粘贴并回车
        Send, ^v
        Sleep, 200
        Send, {Enter}

        ; =============================
        ; 写入每日编号
        ; =============================
        num := GetTodayCounter()
        SendInput, 编号：%num%
        Send, {Enter}

        ; -------------------
        ; 成功发送 → 再播放提示音
        ; -------------------
        SoundPlay, %soundFile%
    }
    else if (ErrorLevel = 1)
    {
        MsgBox, 48, 图像检测, 未找到图像，流程中止。
    }
    else
    {
        MsgBox, 16, 图像检测, 搜索出错（ErrorLevel=%ErrorLevel%）。
    }

    return
}
