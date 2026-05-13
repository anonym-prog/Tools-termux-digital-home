#!/data/data/com.termux/files/usr/bin/bash
# CYBERPULSE - Banner Installer for Termux
source colors.sh

clear

cat .banner.txt

echo ""
echo -e "${Y}╔══════════════════════════════════════════════════════════╗${N}"
echo -e "${Y}║${N}  ${R}🔥${N} ${G}CYBERPULSE BANNER INSTALLER${N} ${R}🔥${N}                  ${Y}║${N}"
echo -e "${Y}╚══════════════════════════════════════════════════════════╝${N}"
echo ""

# Cek Termux
if [ -d "$PREFIX" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
    BANNER_FILE="$PREFIX/etc/motd"
else
    SHELL_CONFIG="$HOME/.bashrc"
    BANNER_FILE="/etc/motd"
fi

install_banner() {
    echo ""
    echo -e "${C}[${ARROW}] Installing Cyber Banner ...${N}"
    
    # Backup existing
    [ -f "$SHELL_CONFIG" ] && cp "$SHELL_CONFIG" "$SHELL_CONFIG.bak"
    
    # Colors
    cat > "$PREFIX/etc/bash.bashrc" << 'EOF'
# CYBERPULSE Theme - Colors
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
B='\033[1;34m'
P='\033[1;35m'
C='\033[1;36m'
W='\033[1;37m'
N='\033[0m'
BD='\033[1m'
DM='\033[2m'
EOF

    # Add banner to bashrc
    cat >> "$SHELL_CONFIG" << 'EOF'

# ===== CYBERPULSE BANNER =====
clear
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
C='\033[1;36m'
W='\033[1;37m'
N='\033[0m'
BD='\033[1m'

echo -e "${R}██████████████████████████████████████████████████████${N}"
echo -e "${R}█${N}  ${G}██████╗██╗   ██╗██████╗ ███████╗██████╗ ██████╗ ${R}█${N}"
echo -e "${R}█${N} ${G}██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██╔══██╗${R}█${N}"
echo -e "${R}█${N} ${G}██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝██████╔╝${R}█${N}"
echo -e "${R}█${N} ${G}██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗██╔═══╝ ${R}█${N}"
echo -e "${R}█${N} ${G}╚██████╗   ██║   ██████╔╝███████╗██║  ██║██║     ${R}█${N}"
echo -e "${R}█${N}  ${G}╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝     ${R}█${N}"
echo -e "${R}█${N}                                                   ${R}█${N}"
echo -e "${R}█${N}  ${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}  ${R}█${N}"
echo -e "${R}█${N}  ${Y}🔥${N} ${W}50 TOOLS${N} • ${G}RECON${N} • ${Y}SCANNER${N} • ${R}EXPLOIT${N} • ${C}OSINT${N} ${Y}🔥${N}  ${R}█${N}"
echo -e "${R}█${N}  ${Y}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}  ${R}█${N}"
echo -e "${R}█${N}                                                   ${R}█${N}"
echo -e "${R}█${N}  ${Y}⚡${N} ${G}Authorized Pentesting Toolkit${N} ${Y}⚡${N}          ${R}█${N}"
echo -e "${R}██████████████████████████████████████████████████████${N}"
echo ""

# Cyber prompt
PS1='${R}[${N}${Y}root${N}${R}]${N}${G}@${N}${C}cyberpulse${N}${R}]${N}${Y}[${N}${W}${PWD}${N}${Y}]${N}\n${R}└──${N}${G}╼${N} ${R}$ ${N}'

# System info
echo -e "${C}${BD}SYSTEM INFO${N}"
echo -e "${Y}━━━━━━━━━━━━━━━━━━━━━━━${N}"
echo -e " ${G}User${N}     : ${W}$(whoami)${N}"
echo -e " ${G}Device${N}   : ${W}$(getprop ro.product.model 2>/dev/null || echo "Android")${N}"
echo -e " ${G}Kernel${N}   : ${W}$(uname -r)${N}"
echo -e " ${G}Uptime${N}   : ${W}$(uptime | awk '{print $3,$4}' | sed 's/,//')${N}"
echo -e " ${G}Date${N}     : ${W}$(date '+%d-%m-%Y %H:%M:%S')${N}"
echo -e "${Y}━━━━━━━━━━━━━━━━━━━━━━━${N}"
echo ""
EOF

    # Also setup for new sessions
    if [ -f "$PREFIX/etc/bash.bashrc" ]; then
        cp "$PREFIX/etc/bash.bashrc" "$PREFIX/etc/bash.bashrc.bak"
    fi
    
    echo -e "${G}[${CHECK}] Banner installed successfully!${N}"
    echo -e "${C}[${ARROW}] Restart Termux to see changes${N}"
    echo ""
}

remove_banner() {
    echo ""
    echo -e "${Y}[${WARN}] Removing Cyber Banner ...${N}"
    [ -f "$SHELL_CONFIG.bak" ] && cp "$SHELL_CONFIG.bak" "$SHELL_CONFIG"
    echo -e "${G}[${CHECK}] Banner removed!${N}"
    echo ""
}

# Menu
echo -e " ${Y}[1]${N} ${G}Install Banner${N}"
echo -e " ${Y}[2]${N} ${R}Remove Banner${N}"
echo -e " ${Y}[0]${N} ${C}Exit${N}"
echo ""
read -p "$(echo -e ${Y}"[?] Choose: "${N})" choice

case $choice in
    1) install_banner ;;
    2) remove_banner ;;
    0) echo -e "${G}Exiting...${N}"; exit ;;
    *) echo -e "${R}Invalid choice!${N}" ;;
esac
