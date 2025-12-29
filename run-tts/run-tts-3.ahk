; 确保脚本使用UTF-8编码保存（带BOM）


; 初始化计数器
F21_Count := 0

F21::
    ; 检查 EpicPen 进程是否存在
    Process, Exist, EpicPen.exe
    if (ErrorLevel = 0)  ; 如果不存在
    {
        Send, #h  ; Win+H
    }
    else  ; EpicPen 正在运行，执行原来的逻辑
    {
        F21_Count++  ; 每次按下增加计数
        if (Mod(F21_Count, 2) = 1)  ; 奇数次按下
        {
            Send, ^+3  ; Ctrl+Shift+3  chatgpt请你在这里添加判断，如果"D:\R2025\AHK\ahk-script\run-tts\run-tts-3.荧光"的内容为0则保持原始逻辑不变，如果为1则替换为使用快捷键Ctrl+Shift+4
        }
        else  ; 偶数次按下
        {
            Send, ^+7  ; Ctrl+Shift+7
            Sleep, 10  ; 确保快捷键顺序
            Send, ^+2  ; Ctrl+Shift+2
            Sleep, 10
            Send, ^+0  ; Ctrl+Shift+0
        }
    }
return
