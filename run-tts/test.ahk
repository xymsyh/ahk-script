#NoEnv
SendMode Input
SetBatchLines, -1
ListLines Off
SetKeyDelay, -1
SetMouseDelay, -1
SetControlDelay, -1
SetWinDelay, -1
SetTitleMatchMode, 2

imgPath := "D:\RX\QK变量\2025年11月13日.png"   ; 建议使用同名 .bmp 以提升速度

^F23::
{
    ; ======================
    ; 1. 截图全屏 → 写入剪贴板
    ; ======================
    Send, {PrintScreen}     ; PrintScreen 会把全屏截图放入剪贴板
    Sleep, 50               ; 略微等待剪贴板完成写入（非常快）

    ; ======================
    ; 2. Ctrl+Shift+Alt+W
    ; ======================
    Send, ^+!w
    Sleep, 150              ; 等待 150ms

    ; ======================
    ; 3. 图像搜索（严格匹配、最快速）
    ; ======================

    ; 获取虚拟屏（适配多显示器）
    SysGet, L, 76
    SysGet, T, 77
    SysGet, R, 78
    SysGet, B, 79

    ; 严格匹配（无容差）
    ImageSearch, fx, fy, L, T, R, B, *0 %imgPath%

    ; 未找到 → 停止流程
    if (ErrorLevel != 0)
    {
        MsgBox, 48, 图像检测, 未找到图像，流程中止。
        return
    }

    ; ======================
    ; 4. 找到图像 → 粘贴 + 回车
    ; ======================
    Send, ^v
    Sleep, 100
    Send, {Enter}

    return
}
