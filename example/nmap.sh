#!/data/data/com.termux/files/usr/bin/bash
source "$(dirname "$0")/../colors.sh"

tool_banner "NMAP" "Recon"
echo -e "${C}Powerful network discovery and security scanning tool${N}"
echo ""

echo -e " ${Y}[1]${N} ${G}Quick Scan${N}        ${DM}- nmap -A target${N}"
echo -e " ${Y}[2]${N} ${G}Port Scan${N}         ${DM}- nmap -p- target${N}"
echo -e " ${Y}[3]${N} ${G}Service Detection${N}  ${DM}- nmap -sV target${N}"
echo -e " ${Y}[4]${N} ${G}OS Detection${N}       ${DM}- nmap -O target${N}"
echo -e " ${Y}[5]${N} ${G}Custom Command${N}"
echo -e " ${Y}[0]${N} ${R}Back${N}"
echo ""

read -p "$(echo -e ${Y}"[?] Pilih mode: "${N})" mode
read -p "$(echo -e ${Y}"[?] Target IP/Domain: "${N})" target

case $mode in
    1) nmap -A "$target" ;;
    2) nmap -p- "$target" ;;
    3) nmap -sV "$target" ;;
    4) nmap -O "$target" ;;
    5) read -p "$(echo -e ${Y}"[?] Command: "${N})" cmd; nmap $cmd "$target" ;;
    *) exit ;;
esac
