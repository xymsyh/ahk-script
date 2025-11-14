; ============================
; 最快速、严格匹配的图像检测脚本
; 热键：Ctrl + F23
; ============================

#NoEnv
SendMode Input
SetBatchLines, -1
ListLines Off
SetKeyDelay, -1
SetMouseDelay, -1
SetControlDelay, -1
SetWinDelay, -1
SetWinDelay, -1
SetTitleMatchMode, 2

imgPath := "D:\RX\QK变量\2025年11月13日.png"   ; 建议换成 .bmp 以进一步加速

^F23::
{
    ; 获取虚拟屏幕坐标（适配多显示器）
    SysGet, L, 76
    SysGet, T, 77
    SysGet, R, 78
    SysGet, B, 79

    ; 严格匹配 → *0
    ImageSearch, fx, fy, L, T, R, B, *0 %imgPath%

    if (ErrorLevel = 0)
        MsgBox, 64, 图像检测, 找到匹配图像！`n坐标：%fx%, %fy%
    else if (ErrorLevel = 1)
        MsgBox, 48, 图像检测, 未找到图像。
    else
        MsgBox, 16, 图像检测, 搜索出错（ErrorLevel=%ErrorLevel%）。
    return
}
