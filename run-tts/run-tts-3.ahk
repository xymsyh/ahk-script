; 确保脚本使用UTF-8编码保存（带BOM）
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
