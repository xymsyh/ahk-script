; 确保脚本使用UTF-8编码保存（带BOM）




F15::
    Send, #1   ; "#" 代表 Win 键，#1 即 Win+1
return


; 当按下Ctrl+F15组合键时触发
^F15::
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
        Sleep, 10  ; 可选，保证快捷键先后顺序，单位：毫秒
        Send, ^+2  ; Ctrl+Shift+2
        Sleep, 10  ; 可选，保证快捷键先后顺序，单位：毫秒
        Send, ^+0  ; Ctrl+Shift+0
    }
return



/* 全部注释↓ 当恢复时全体取消一行缩进
    ; =========================
    ; Ctrl + F14 热键
    ; =========================
    ^F14::
    {
        pythonPath := "python"  ; 替换为实际Python路径
        scriptPath := "D:\R2025\AHK\ms-tts\main.py"
        paramFilePath := "D:\R2025\AHK\ahk-script\run-tts\接受qk参数-简短.md"
        GoSub, RunTTS
    }
    return


    ; =========================
    ; Ctrl + F16 热键
    ; =========================
    ^F16::
    {
        pythonPath := "python"
        scriptPath := "D:\R2025\AHK\ms-tts\main.py"
        paramFilePath := "D:\R2025\AHK\ahk-script\run-tts\接受qk参数.md"
        GoSub, RunTTS
    }
    return


    ; =========================
    ; 通用子程序：RunTTS
    ; =========================
    RunTTS:
        ; 读取文件内容作为参数
        FileRead, parameters, %paramFilePath%
        if (ErrorLevel) {
            MsgBox, 16, 错误, 无法读取参数文件:`n%paramFilePath%
            return
        }

        ; 移除换行符、空格、下划线
        parameters := StrReplace(parameters, "`r`n", " ")
        parameters := StrReplace(parameters, "`n", " ")
        parameters := Trim(parameters)
        parameters := StrReplace(parameters, "_", " ")

        ; 判断是否包含汉字
        hasChinese := false
        Loop, Parse, parameters
        {
            if (Asc(A_LoopField) >= 0x4E00 && Asc(A_LoopField) <= 0x9FFF) {
                hasChinese := true
                break
            }
        }

        ; 语音选择
        if (hasChinese)
            voiceParam := "--voice ""zh-CN-XiaoxiaoNeural"""
        else
            voiceParam := "--voice ""en-CA-ClaraNeural"""

        ; 构造命令
        command := "cmd /c ""chcp 65001 >nul && " pythonPath " " scriptPath " " voiceParam " " """" parameters """" """"

        ; 执行命令（隐藏窗口）
        Run, %command%,, Hide
    return

*/