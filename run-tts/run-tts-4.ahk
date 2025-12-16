#NoEnv
SendMode Input
SetBatchLines, -1
ListLines Off
SetKeyDelay, -1
SetMouseDelay, -1
SetControlDelay, -1
SetWinDelay, -1
SetTitleMatchMode, 2

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
    ; 1. 截图 → 剪贴板（图片进入剪贴板）
    ; -------------------
    Send, {PrintScreen}
    Sleep, 10

    ; -------------------
    ; 2. 触发 Ctrl+Shift+Alt+W
    ; -------------------
    Send, ^+!w
    Sleep, 1000 ; 经测试该值低了可能失焦

    ; 清空 epic pen
    Send, {F21}
    Sleep, 1000 ; 经测试该值低了可能失焦

    ; ==================================
    ; ★ 保护剪贴板中的图片（关键）
    ; ==================================
    ClipBackup := ClipboardAll  ; 完整备份图片

    ; ==================================
    ; ★ 获取当前选中文本（不破坏图片剪贴板）
    ; ==================================
    Send, ^a
    Sleep, 60
    Send, ^c
    Sleep, 120
    ClipWait, 0.5

    selectedText := Clipboard  ; 保存选中的文本

    ; 恢复剪贴板中的图片（不影响 selectedText 变量）
    Clipboard := ClipBackup
    VarSetCapacity(ClipBackup, 0)  ; 释放内存

    ; 若未包含“学” → 播放错误音并退出
    if !InStr(selectedText, "学") {
        SoundPlay, %ErrorSoundFile%
        return
    }

    ; ==================================
    ; 3. 粘贴图片 + 写入编号
    ; ==================================
    Send, ^v   ; 这里仍然是原来的图片
    Sleep, 100
    num := GetTodayCounter()













    ; ==================================
    ; 3.x 拼接完整文本 → 使用粘贴写入
    ; ==================================

    finalText := selectedText . num


    ; 将拼接后的文本放入剪贴板
    Clipboard := finalText
    ClipWait, 0.5

    ; 使用粘贴而不是 SendInput
    Send, ^v
    Sleep, 50





















    ; ==================================
    ; 始终执行成功结尾逻辑
    ; ==================================
    Sleep, 300
    Send, {Enter}

    ; ==================================
    ; 3.x 拼接完整文本 → 使用粘贴写入
    ; ==================================

    finalText := selectedText 


    ; 将拼接后的文本放入剪贴板
    Clipboard := finalText
    ClipWait, 0.5

    ; 使用粘贴而不是 SendInput
    Send, ^v
    Sleep, 50


    Sleep, 100
    ; Send, ^+!w
    SoundPlay, %soundFile%

    return
}
