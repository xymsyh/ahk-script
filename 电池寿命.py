import subprocess
import re
import json

def run_powershell(cmd):
    try:
        result = subprocess.check_output(
            ["powershell", "-NoProfile", "-Command", cmd],
            universal_newlines=True
        )
        return result.strip()
    except Exception:
        return ""

def get_battery_data():
    # 使用 PowerShell 访问 root\wmi 下的电池信息（所有 Windows 笔记本都支持）
    ps_cmd = r"""
    $b1 = Get-WmiObject -Namespace root\wmi -Class BatteryStaticData
    $b2 = Get-WmiObject -Namespace root\wmi -Class BatteryFullChargedCapacity
    $b3 = Get-WmiObject -Namespace root\wmi -Class BatteryStatus

    $obj = [PSCustomObject]@{
        DesignedCapacity = $b1.DesignedCapacity
        FullChargeCapacity = $b2.FullChargedCapacity
        RemainingCapacity = $b3.RemainingCapacity
    }

    $obj | ConvertTo-Json
    """

    raw = run_powershell(ps_cmd)
    if not raw:
        return None

    try:
        data = json.loads(raw)
        return data
    except:
        return None

def main():
    data = get_battery_data()

    if not data:
        print("❌ 无法获取电池信息，请确认 Windows 电池驱动正常。")
        return

    design = data.get("DesignedCapacity", 0)
    full   = data.get("FullChargeCapacity", 0)

    if not design or not full:
        print("❌ 电池数据缺失：", data)
        return

    health = full / design * 100

    print("===== Windows Battery Health =====")
    print(f"设计容量 (DesignedCapacity):     {design} mWh")
    print(f"当前最大容量 (FullChargeCapacity): {full} mWh")
    print(f"电池健康度: {health:.2f}%")
    print("=================================")


if __name__ == "__main__":
    main()
