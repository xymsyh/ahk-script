# ① 取原始金额，作为中间变量
temp_amount = glv.get('可提现金额', '0')

try:
    # ② 字符串归一化：去换行、去空白、去金额符号
    normalized = (
        str(temp_amount)
        .replace('\n', '')
        .replace('\r', '')
        .replace(' ', '')
        .replace('¥', '')
        .replace(',', '')
        .strip()
    )

    # ③ 转为数字并取绝对值
    numeric_amount = abs(float(normalized))

    # ④ 输出为“纯数字格式”
    glv['可提现金额'] = str(numeric_amount)

except:
    # 兜底：异常时置 0
    glv['可提现金额'] = '0'
