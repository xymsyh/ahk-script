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
; Config
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
    Sleep, 10

    ; ---------- 触发工具 ----------
    Send, ^+!w
    WinWaitActive, , , 2

    ; ---------- 清空 Epic Pen ----------
    Send, {F21}
    Sleep, 1000

    ; ---------- 备份剪贴板图片 ----------
    ClipBackup := ClipboardAll

    ; ---------- 获取选中文本（驱动式） ----------
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
    Sleep, 100

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

    Sleep, 300
    Send, {Enter}

    ; ---------- 第二次粘贴 ----------
    Clipboard := selectedText
    ClipWait, 0.3
    if ErrorLevel {
        SoundPlay, % Config.SoundError
        return
    }
    Send, ^v

    Sleep, 100
    SoundPlay, % Config.SoundOK
    return
}
