; 确保脚本使用UTF-8编码保存（带BOM）

; =========================
; 配置文件
; =========================
CountFile := "D:\R2025\AHK\ahk-script\run-tts\run-tts-3.计数"
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
        ; ---------- 读取计数文件 ----------
        if FileExist(CountFile)
        {
            FileRead, F21_Count, %CountFile%
            F21_Count := Trim(F21_Count)
            if (F21_Count != "0" && F21_Count != "1")
                F21_Count := "0"  ; 防止文件内容异常
        }
        else
        {
            F21_Count := "0"  ; 文件不存在时初始化
        }

        ; ---------- 交替 0/1 ----------
        if (F21_Count = "0")
        {
            F21_Count := "1"  ; 下次变成 1
            ; ---------- 奇数次操作 ----------
            GlowFlag := "0"
            if FileExist(GlowFlagFile)
            {
                FileRead, GlowFlag, %GlowFlagFile%
                GlowFlag := Trim(GlowFlag)
            }

            if (GlowFlag = "1")
                Send, ^+4  ; 荧光模式
            else
                Send, ^+3  ; 原始逻辑
        }
        else
        {
            F21_Count := "0"  ; 下次变成 0
            ; ---------- 偶数次操作 ----------
            Send, ^+7
            Sleep, 10
            Send, ^+2
            Sleep, 10
            Send, ^+0
        }

        ; ---------- 写回计数文件 ----------
        FileDelete, %CountFile%  ; 先删除旧文件
        FileAppend, %F21_Count%, %CountFile%
    }
return
