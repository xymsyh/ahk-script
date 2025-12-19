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
; 路径配置
; =========================
outputFile      := "D:\R2025\AHK\ahk-script\run-tts\run-tts-3信息.md"
soundFile       := "D:\Users\Ran\Downloads\mixkit-select-click-1109 (1).wav"
ErrorSoundFile  := "D:\Users\Ran\Downloads\mixkit-click-error-1110.wav"
counterFile     := "D:\R2025\AHK\ahk-script\run-tts\counter.txt"
extraFile       := "D:\R2025\QK\无限配显.txt"

; ==========================================
; 读取 / 更新 当天编号（每天从 1 开始）
; ==========================================
GetTodayCounter() {
    global counterFile
    today := A_YYYY A_MM A_DD

    if FileExist(counterFile) {
        FileRead, ct, %counterFile%
        StringSplit, arr, ct, |
        lastDate  := arr1
        lastCount := arr2
        newCount  := (lastDate = today) ? lastCount + 1 : 1
    } else {
        newCount := 1
    }

    FileDelete, %counterFile%
    FileAppend, %today%|%newCount%, %counterFile%
    return newCount
}

; =========================
; 主热键
; =========================
F16::
{
    ; ---------- 提示音 ----------
    SoundPlay, %soundFile%

    ; ---------- 1. 截图 ----------
    Send, {PrintScreen}
    Sleep, 10

    ; ---------- 2. 触发工具 ----------
    Send, ^+!w
    Sleep, 1000

    Send, {F21}        ; 清空 Epic Pen
    Sleep, 1000

    ; ==================================
    ; 保护剪贴板图片
    ; ==================================
    ClipBackup := ClipboardAll

    ; ---------- 获取选中文本 ----------
    Send, ^a
    Sleep, 60
    Send, ^c
    Sleep, 120
    ClipWait, 0.5

    selectedText := Clipboard

    ; ---------- 恢复图片 ----------
    Clipboard := ClipBackup
    VarSetCapacity(ClipBackup, 0)

    ; ---------- 校验 ----------
    if !InStr(selectedText, "学") {
        SoundPlay, %ErrorSoundFile%
        return
    }

    ; ==================================
    ; 3. 粘贴图片 + 编号
    ; ==================================
    Send, ^v
    Sleep, 100

    num := GetTodayCounter()

    ; ==================================
    ; 3.x 拼接文本（第一次）
    ; ==================================
    extraText := ""
    if FileExist(extraFile) {
        FileRead, extraText, %extraFile%
        extraText := Trim(extraText, "`r`n`t ")
    }

    finalText := selectedText . num . "：" . extraText
    Clipboard := finalText
    ClipWait, 0.5
    Send, ^v
    Sleep, 50

    ; ---------- 统一收尾 ----------
    Sleep, 300
    Send, {Enter}

    ; ==================================
    ; 3.x 拼接文本（第二次，仅选中文本）
    ; ==================================
    Clipboard := selectedText
    ClipWait, 0.5
    Send, ^v
    Sleep, 50

    Sleep, 100
    SoundPlay, %soundFile%
    return
}
