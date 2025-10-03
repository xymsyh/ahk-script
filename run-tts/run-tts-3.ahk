; 确保脚本使用UTF-8编码保存（带BOM）


; 初始化计数器
F21_Count := 0

F21::
    F21_Count++  ; 每次按下增加计数
    if (Mod(F21_Count, 2) = 1)  ; 奇数次按下
    {
        Send, ^+3  ; Ctrl+Shift+3
    }
    else  ; 偶数次按下
    {
        Send, ^+7  ; Ctrl+Shift+7
        Sleep, 100  ; 可选，保证快捷键先后顺序，单位：毫秒
        Send, ^+2  ; Ctrl+Shift+2
    }
return


; 当按下F14键时触发
F14::
    ; 定义要执行的Python命令
    pythonPath := "python"  ; 替换为实际Python路径
    scriptPath := "D:\R2025\AHK\ms-tts\main.py"
    
    ; 要读取的参数文件路径
    paramFilePath := "D:\R2025\AHK\ahk-script\run-tts\接受qk参数.md"
    
    ; 读取文件内容作为参数
    FileRead, parameters, %paramFilePath%
    
    ; 移除可能的换行符和多余空格
    parameters := StrReplace(parameters, "`r`n", " ")
    parameters := StrReplace(parameters, "`n", " ")
    parameters := Trim(parameters)
    
    ; 判断内容是否包含汉字
    hasChinese := false
    Loop, Parse, parameters
    {
        ; 检查字符是否为汉字（Unicode范围：4E00-9FFF）
        if (Asc(A_LoopField) >= 0x4E00 && Asc(A_LoopField) <= 0x9FFF)
        {
            hasChinese := true
            break
        }
    }
    
    ; 根据是否有汉字选择不同的语音参数
    if (hasChinese)
        voiceParam := "--voice ""zh-CN-XiaoxiaoNeural"""
    else
        voiceParam := "--voice ""en-CA-ClaraNeural"""  ; en-CA-ClaraNeural是Microsoft Clara的标准参数
    
    ; 组合完整命令，使用CMD的UTF-8模式执行
    command := "cmd /c ""chcp 65001 >nul && " pythonPath " " scriptPath " " voiceParam " " """" parameters """" """"
    
    ; 运行命令
    Run, %command%,, Hide
    
    ; 可选：显示调试信息
    ; ToolTip, 执行命令: %command%`n使用语音: % (hasChinese ? "中文" : "英文")
    ; SetTimer, ToolTip, -3000
    
    return


    ; 确保脚本以UTF-8带BOM格式保存
; 当按下Ctrl+F14组合键时触发
^F14::
    ; 定义Python路径和要执行的停止脚本路径
    pythonPath := "python"  ; 如果python不在环境变量中，请使用完整路径如"C:\Python39\python.exe"
    stopScriptPath := "D:\R2025\AHK\ms-tts\main-stop.py"
    
    ; 组合命令，使用UTF-8编码执行
    command := "cmd /c ""chcp 65001 >nul && " pythonPath " " stopScriptPath """"
    
    ; 运行命令，隐藏控制台窗口
    Run, %command%,, Hide
    
    ; 可选：显示执行提示
    ; ToolTip, 已执行停止脚本
    ; SetTimer, ToolTip, -1500
    
    return
