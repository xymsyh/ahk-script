import os
import sys
import time
import platform

def sleep_computer():
    """根据不同操作系统执行休眠命令"""
    os_name = platform.system()
    
    try:
        if os_name == "Windows":
            # Windows系统休眠命令（-h 表示休眠，区别于待机）
            os.system("shutdown /h")
        elif os_name == "Darwin":
            # macOS系统休眠命令
            os.system("pmset sleepnow")
        elif os_name == "Linux":
            # Linux系统休眠命令（不同发行版通用）
            os.system("systemctl suspend")
        else:
            print(f"暂不支持{os_name}系统的休眠操作")
            return False
        return True
    except Exception as e:
        print(f"执行休眠命令时出错：{e}")
        return False

def main():
    # 设定延迟时间：30分钟（转换为秒）
    delay_seconds = 30 * 60
    
    print("="*50)
    print(f"脚本已启动，将在 {delay_seconds//60} 分钟后休眠电脑")
    print("如需取消，请关闭此窗口或按 Ctrl+C 终止脚本")
    print("="*50)
    
    try:
        # 倒计时显示（可选，增强交互体验）
        for remaining in range(delay_seconds, 0, -1):
            mins, secs = divmod(remaining, 60)
            timer = f"{mins:02d}:{secs:02d}"
            print(f"剩余时间：{timer}", end="\r")
            time.sleep(1)
        
        # 执行休眠
        print("\n开始执行休眠操作...")
        success = sleep_computer()
        if success:
            print("休眠命令已发送，电脑即将进入休眠状态")
        else:
            print("休眠操作执行失败")
            
    except KeyboardInterrupt:
        # 捕获Ctrl+C，优雅退出
        print("\n\n用户手动取消，脚本终止，电脑不会休眠")
        sys.exit(0)
    except Exception as e:
        print(f"\n脚本运行出错：{e}")
        sys.exit(1)

if __name__ == "__main__":
    main()