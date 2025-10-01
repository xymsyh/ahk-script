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
