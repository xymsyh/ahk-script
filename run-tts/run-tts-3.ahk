; 确保脚本使用UTF-8编码保存（带BOM）

; =========================
; 初始化计数器
; =========================
F21_Count := 0

; =========================
; 配置：荧光模式开关文件
; =========================
GlowFlagFile := "D:\R2025\AHK\ahk-script\run-tts\run-tts-3.荧光"

F21::
    ; 检查 EpicPen 进程是否存在
    Process, Exist, EpicPen.exe
    if (ErrorLevel = 0)  ; EpicPen 不存在
    {
        Send, #h  ; Win + H
    }
    else  ; EpicPen 正在运行
    {
        F21_Count++  ; 每次按下增加计数

        ; =========================
        ; 奇数次按下
        ; =========================
        if (Mod(F21_Count, 2) = 1)
        {
            ; ---------- 读取荧光开关文件 ----------
            GlowFlag := "0"  ; 默认值，防止文件不存在或异常

            if FileExist(GlowFlagFile)
            {
                FileRead, GlowFlag, %GlowFlagFile%
                GlowFlag := Trim(GlowFlag)  ; 去除空格/换行
            }

            ; ---------- 根据文件内容决定快捷键 ----------
            if (GlowFlag = "1")
            {
                Send, ^+4  ; Ctrl + Shift + 4（荧光模式）
            }
            else
            {
                Send, ^+3  ; Ctrl + Shift + 3（原始逻辑）
            }
        }
        ; =========================
        ; 偶数次按下（保持原逻辑）
        ; =========================
        else
        {
            Send, ^+7  ; Ctrl + Shift + 7
            Sleep, 10
            Send, ^+2  ; Ctrl + Shift + 2
            Sleep, 10
            Send, ^+0  ; Ctrl + Shift + 0
        }
    }
return
