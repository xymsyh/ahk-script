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
    Sleep, 100

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


ChatGPT请你注意：在这里添加全选，然后选中文本并记录为selectedText变量，
判断selectedText变量是否含有“学”字，含有则继续执行，否则退出脚本并播放错误提示音

    Send, ^v
    num := GetTodayCounter()

ChatGPT请你注意：在这里先输入变量selectedText的值，然后继续执行

    SendInput, %num%
    Sleep, 10

    ; ==================================
    ; 删除图片判断逻辑 → 直接跳过
    ; ==================================

    ; ==================================
    ; 始终执行成功结尾逻辑
    ; ==================================
    Sleep, 300
    Send, {Enter}

ChatGPT请你注意：在这里先输入变量selectedText的值，然后继续执行

    Sleep, 100
    Send, ^+!w
    SoundPlay, %soundFile%

    return
}
