#!/data/data/com.termux/files/usr/bin/bash
source "$(dirname "$0")/../colors.sh"

tool_banner "IP GEO" "OSINT"

read -p "$(echo -e ${Y}"[?] Masukkan IP Address: "${N})" ip

echo ""
echo -e "${C}Looking up IP: ${Y}$ip${N}"
echo ""

curl -s "http://ip-api.com/json/$ip" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print('\033[1;32m' + '═'*40 + '\033[0m')
for key, val in data.items():
    color = '\033[1;33m' if key in ['status', 'query'] else '\033[1;36m'
    print(f'{color}{key.upper():15}\033[0m : \033[1;37m{val}\033[0m')
print('\033[1;32m' + '═'*40 + '\033[0m')
"
