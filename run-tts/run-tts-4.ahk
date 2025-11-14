#NoEnv
SendMode Input
SetBatchLines, -1
ListLines Off
SetKeyDelay, -1
SetMouseDelay, -1
SetControlDelay, -1
SetWinDelay, -1
SetTitleMatchMode, 2

imgPath := "D:\RX\QK变量\2025年11月13日.png"   
outputFile := "D:\R2025\AHK\ahk-script\run-tts\run-tts-3信息.md"

^F23::
{
    ; -------------------
    ; 1. 截图全屏到剪贴板
    ; -------------------
    Send, {PrintScreen}     
    Sleep, 10  

    ; -------------------
    ; 2. 发送 Ctrl+Shift+Alt+W
    ; -------------------
    Send, ^+!w
    Sleep, 10  

    Send, ^+7  ; Ctrl+Shift+7  ↓↓↓↓↓本部分逻辑为清空epic pen
    Sleep, 10  ; 确保快捷键顺序
    Send, ^+2  ; Ctrl+Shift+2
    Sleep, 10
    Send, ^+0  ; Ctrl+Shift+0  ↑↑↑↑↑本部分逻辑为清空epic pen


    Sleep, 250              

    ; -------------------
    ; 3. 获取屏幕坐标
    ; -------------------
    SysGet, L, 76
    SysGet, T, 77
    SysGet, R, 78
    SysGet, B, 79

    ; -------------------
    ; 4. 严格匹配图像搜索
    ; -------------------
    ImageSearch, fx, fy, L, T, R, B, *0 %imgPath%

    if (ErrorLevel = 0)
    {
        ; 找到图像 → 写入坐标到文件（覆盖原内容）
        FileDelete, %outputFile%  ; 删除原文件
        FileAppend, 找到图像坐标：X=%fx% , Y=%fy%`n, %outputFile%

        ; 粘贴并回车
        Send, ^v
        Sleep, 200
        Send, {Enter}
    }
    else if (ErrorLevel = 1)
    {
        ; 未找到 → 弹窗提示
        MsgBox, 48, 图像检测, 未找到图像，流程中止。
    }
    else
    {
        ; 出错
        MsgBox, 16, 图像检测, 搜索出错（ErrorLevel=%ErrorLevel%）。
    }

    return
}
