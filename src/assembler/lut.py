LUT = {
        'add': '0000',
        'lsl': '0001',
        'lsr': '0010',
        'and': '0011',
        'lor': '0100',
        'xor': '0101',
        'slt': '0110',
        'mov': '0111',
        'ldb': '1000',
        'str': '1001',
        'ldh': '1010',
        'ldl': '1011',
        'jmp': '1100',
        'hlt': '1111'
}

REG = set(['add', 'lsl', 'lsr', 'and', 'lor', 'xor', 'slt', 'jmp'])
IMM = set(['mov', 'ldb', 'str'])
UNI = set(['ldh', 'ldl'])
