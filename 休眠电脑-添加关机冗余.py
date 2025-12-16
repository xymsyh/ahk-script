import os
import sys
import time
import platform

def sleep_computer():
    """根据不同操作系统执行休眠命令"""
    os_name = platform.system()
    
    try:
        if os_name == "Windows":
            # Windows休眠命令（需启用休眠功能）
            os.system("shutdown /h")
        elif os_name == "Darwin":
            # macOS休眠命令
            os.system("pmset sleepnow")
        elif os_name == "Linux":
            # Linux休眠命令（通用版）
            os.system("systemctl suspend")
        else:
            print(f"暂不支持{os_name}系统的休眠操作")
            return False
        # 休眠命令发送后短暂等待，确认是否触发（部分系统无即时反馈）
        time.sleep(2)
        return True
    except Exception as e:
        print(f"休眠命令执行出错：{e}")
        return False

def shutdown_computer():
    """根据不同操作系统执行强制关机命令（立即执行）"""
    os_name = platform.system()
    
    print("\n⚠️  休眠操作失败，将执行强制关机！")
    try:
        if os_name == "Windows":
            # Windows立即关机（/s=关机，/t 0=延时0秒）
            os.system("shutdown /s /t 0")
        elif os_name == "Darwin":
            # macOS立即关机
            os.system("shutdown -h now")
        elif os_name == "Linux":
            # Linux立即关机（兼容多数发行版）
            os.system("shutdown -h now")
        else:
            print(f"暂不支持{os_name}系统的关机操作")
            return False
        return True
    except Exception as e:
        print(f"关机命令执行出错：{e}")
        return False

def main():
    # 设定延迟时间：30分钟（转换为秒）
    delay_seconds = 30 * 60
    
    print("="*60)
    print(f"脚本已启动，将在 {delay_seconds//60} 分钟后尝试休眠电脑")
    print("⚠️  若休眠失败，将自动执行强制关机操作！")
    print("如需取消，请关闭此窗口或按 Ctrl+C 终止脚本")
    print("="*60)
    
    try:
        # 倒计时显示（实时刷新剩余时间）
        for remaining in range(delay_seconds, 0, -1):
            mins, secs = divmod(remaining, 60)
            timer = f"剩余时间：{mins:02d}:{secs:02d}"
            print(timer, end="\r")
            time.sleep(1)
        
        # 第一步：执行休眠操作
        print("\n\n开始执行休眠操作...")
        sleep_success = sleep_computer()
        
        if sleep_success:
            print("✅ 休眠命令已发送，电脑即将进入休眠状态")
        else:
            # 第二步：休眠失败，执行关机冗余逻辑
            print("❌ 休眠操作失败，触发冗余机制：执行关机命令")
            shutdown_success = shutdown_computer()
            if shutdown_success:
                print("✅ 关机命令已发送，电脑即将强制关机")
            else:
                print("❌ 关机操作也执行失败，请手动操作")
            
    except KeyboardInterrupt:
        # 捕获Ctrl+C，优雅退出（不执行任何操作）
        print("\n\n🛑 用户手动取消，脚本终止，电脑不会休眠/关机")
        sys.exit(0)
    except Exception as e:
        # 捕获其他未知异常
        print(f"\n❌ 脚本运行出错：{e}")
        sys.exit(1)

if __name__ == "__main__":
    main()