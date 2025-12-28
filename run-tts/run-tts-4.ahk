FileEncoding, UTF-8

#NoEnv
SendMode Input
SetBatchLines, -1
ListLines Off
SetKeyDelay, -1
SetMouseDelay, -1
SetControlDelay, -1
SetWinDelay, -1
SetTitleMatchMode, 2

; =========================
; 注意本代码使用 AHK v1（AutoHotkeyU64）写法，本行注释不可删除与更改！
; =========================

; =========================================================
; 延时配置（所有 Sleep 均集中在此，单位：毫秒）
; 修改这里即可全局调整节奏
; =========================================================

; 截图（PrintScreen）后，等待系统将截图写入剪贴板
Sleep_After_PrintScreen := 10

; 清空 Epic Pen 后，等待其完成内部清除与焦点稳定
Sleep_After_Clear_EpicPen := 500

; 粘贴图片（Ctrl+V）后，等待图片渲染完成
Sleep_After_Paste_Image := 100

; 第一次文本粘贴完成后，等待 UI 稳定再发送 Enter
Sleep_Before_Enter := 300

; 第二次文本粘贴完成后，最终收尾前的缓冲等待
Sleep_Before_Final_Sound := 100

; 监听鼠标是否移动的轮询间隔
Sleep_Mouse_Watch_Interval    := 50


; =========================
; Config（路径与资源配置）
; =========================
Config := {}
Config.SoundOK     := "D:\Users\Ran\Downloads\mixkit-select-click-1109 (1).wav"
Config.SoundError  := "D:\Users\Ran\Downloads\mixkit-click-error-1110.wav"
Config.CounterFile := "D:\R2025\AHK\ahk-script\run-tts\counter.txt"
Config.ExtraFile   := "D:\R2025\QK\无限配显.txt"


; ==========================================
; 读取 / 更新 当天编号
; ==========================================
GetTodayCounter() {
    global Config
    today := A_YYYY A_MM A_DD

    if FileExist(Config.CounterFile) {
        FileRead, ct, % Config.CounterFile
        StringSplit, arr, ct, |
        lastDate  := arr1
        lastCount := arr2
        newCount  := (lastDate = today) ? lastCount + 1 : 1
    } else {
        newCount := 1
    }

    FileDelete, % Config.CounterFile
    FileAppend, %today%|%newCount%, % Config.CounterFile
    return newCount
}


; =========================
; 主热键
; =========================
F16::
{
    SoundPlay, % Config.SoundOK

    ; ---------- 截图 ----------
    Send, {PrintScreen}
    Sleep, %Sleep_After_PrintScreen%

    ; ---------- 打开微信输入窗口 ----------
    Send, ^+!w
    WinWaitActive, , , 1

    ; ---------- 清空 Epic Pen ----------
    Send, {F21}
    Sleep, %Sleep_After_Clear_EpicPen%

    ; ---------- 备份剪贴板图片 ----------
    ClipBackup := ClipboardAll

    ; ---------- 获取选中文本 ----------
    Clipboard := ""
    Send, ^a
    Send, ^c
    ClipWait, 0.5
    if ErrorLevel {
        Clipboard := ClipBackup
        VarSetCapacity(ClipBackup, 0)
        SoundPlay, % Config.SoundError
        return
    }
    selectedText := Clipboard

    ; ---------- 恢复图片 ----------
    Clipboard := ClipBackup
    VarSetCapacity(ClipBackup, 0)

    ; ---------- 校验 ----------
    if !InStr(selectedText, "学") {
        SoundPlay, % Config.SoundError
        return
    }

    ; ---------- 粘贴图片 ----------
    Send, ^v
    Sleep, %Sleep_After_Paste_Image%

    num := GetTodayCounter()

    ; ---------- 拼接文本 ----------
    extraText := ""
    if FileExist(Config.ExtraFile) {
        FileRead, extraText, % Config.ExtraFile
        extraText := Trim(extraText, "`r`n`t ")
    }

    finalText := selectedText . num . "：" . extraText

    Clipboard := finalText
    ClipWait, 0.3
    if ErrorLevel {
        SoundPlay, % Config.SoundError
        return
    }
    Send, ^v

    ; ---------- 回车确认 ----------
    Sleep, %Sleep_Before_Enter%
    Send, {Enter}

    ; ---------- 第二次粘贴 ----------
    Clipboard := selectedText
    ClipWait, 0.3
    if ErrorLevel {
        SoundPlay, % Config.SoundError
        return
    }
    Send, ^v

    ; ---------- 成功提示 ----------
    Sleep, %Sleep_Before_Final_Sound%
    SoundPlay, % Config.SoundOK


    ; =================================================
    ; 成功后：等待鼠标移动 → 自动关闭微信窗口
    ; =================================================
    MouseGetPos, startX, startY
    Loop {
        Sleep, %Sleep_Mouse_Watch_Interval%
        MouseGetPos, curX, curY
        if (curX != startX || curY != startY) {
            Send, ^+!w
            break
        }
    }

    return
}
