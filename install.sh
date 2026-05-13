#!/data/data/com.termux/files/usr/bin/bash
# CYBERPULSE - Main Installation Script

# Source colors
source "$(dirname "$0")/colors.sh"

# Trap for clean exit
trap 'echo -e "\n${R}[${CROSS}] Installation interrupted!${N}"; exit 1' SIGINT SIGTERM

# ============================================
# BANNER
# ============================================
clear
cat "$(dirname "$0")/.banner.txt" 2>/dev/null || true
echo ""
echo -e "${R}╔══════════════════════════════════════════════════════════╗${N}"
echo -e "${R}║${N}  ${Y}${BOLT}${N} ${G}CYBERPULSE TOOLKIT INSTALLER v1.0${N} ${Y}${BOLT}${N}          ${R}║${N}"
echo -e "${R}║${N}  ${C}50 Tools for Recon • Scanner • Exploit • OSINT${N}  ${R}║${N}"
echo -e "${R}╚══════════════════════════════════════════════════════════╝${N}"
echo ""

# ============================================
# CHECK TERMUX
# ============================================
if [ -d "$PREFIX" ]; then
    INFO "Running on Termux (Android)"
    PKG_MGR="pkg"
else
    INFO "Running on Linux"
    PKG_MGR="apt"
fi

# ============================================
# UPDATE SYSTEM
# ============================================
header "UPDATING SYSTEM"
$PKG_MGR update -y && $PKG_MGR upgrade -y
success "System updated!"

# ============================================
# INSTALL BASE DEPENDENCIES
# ============================================
header "INSTALLING BASE DEPENDENCIES"

DEPS=(
    git curl wget python python2 make cmake
    clang gcc openssl-tool binutils
    ncurses-utils termux-exec
    proot proot-distro
    x11-repo root-repo
    golang rust nodejs
    perl ruby php
    tmux screen
    toilet figlet lolcat
    dnsutils coreutils findutils
    jq bc nmap hydra
    net-tools openssh
    tor proxychains-ng
    macchanger
    whois traceroute
    sqlmap
    nikto
)

total_deps=${#DEPS[@]}
count=0

for dep in "${DEPS[@]}"; do
    count=$((count + 1))
    echo -ne "\r${Y}[${count}/${total_deps}]${N} Installing ${G}${dep}${N}...    "
    $PKG_MGR install -y "$dep" 2>/dev/null >/dev/null
    if [ $? -eq 0 ]; then
        echo -ne "\r${G}[${CHECK}]${N} ${dep} installed!          \n"
    fi
done

success "Base dependencies installed!"

# ============================================
# PIP INSTALLATIONS
# ============================================
header "INSTALLING PYTHON PACKAGES"

pip install --upgrade pip 2>/dev/null >/dev/null
PYTHON_DEPS=(
    requests beautifulsoup4
    scapy colorama
    termcolor pyfiglet
    python-nmap shodan
    censys argparse
    asyncio aiohttp
    selenium cryptography
    paramiko pwn
    pwntools flask
    dnspython ipwhois
    phonenumbers folium
    mechanize httpx
    websocket-client
    impacket
)

for pkg in "${PYTHON_DEPS[@]}"; do
    pip install "$pkg" 2>/dev/null >/dev/null
done
success "Python packages installed!"

# ============================================
# GEM INSTALLATIONS
# ============================================
header "INSTALLING RUBY GEMS"
gem install colorize mechanize 2>/dev/null >/dev/null
success "Ruby gems installed!"

# ============================================
# NPM INSTALLATIONS  
# ============================================
header "INSTALLING NPM PACKAGES"
npm install -g pm2 2>/dev/null >/dev/null
success "NPM packages installed!"

# ============================================
# INSTALL TOOLS - RECON
# ============================================
header "INSTALLING RECON TOOLS"

TOOLS_DIR="$HOME/cyberpulse-tools"
mkdir -p "$TOOLS_DIR"/{recon,scanner,exploit,osint,net,extra}

cd "$TOOLS_DIR"

# 1. Nmap - sudah di base
success "Nmap installed!"

# 2. Subfinder
info "Installing Subfinder..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest 2>/dev/null && success "Subfinder installed!" || warning "Subfinder failed"
export PATH="$PATH:$HOME/go/bin"

# 3. Httpx
info "Installing Httpx..."
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest 2>/dev/null && success "Httpx installed!" || warning "Httpx failed"

# 4. Nuclei
info "Installing Nuclei..."
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest 2>/dev/null && success "Nuclei installed!" || warning "Nuclei failed"

# 5. Waybackurls
info "Installing Waybackurls..."
go install github.com/tomnomnom/waybackurls@latest 2>/dev/null && success "Waybackurls installed!" || warning "Waybackurls failed"

# 6. Gau
info "Installing Gau..."
go install github.com/lc/gau/v2/cmd/gau@latest 2>/dev/null && success "Gau installed!" || warning "Gau failed"

# 7. Amass
info "Installing Amass..."
go install -v github.com/OWASP/Amass/v3/...@master 2>/dev/null && success "Amass installed!" || warning "Amass failed"

# 8. Assetfinder
info "Installing Assetfinder..."
go install github.com/tomnomnom/assetfinder@latest 2>/dev/null && success "Assetfinder installed!" || warning "Assetfinder failed"

# 9. Findomain
info "Installing Findomain..."
wget -q https://github.com/Findomain/Findomain/releases/latest/download/findomain-linux.zip -O /tmp/findomain.zip 2>/dev/null
unzip -q /tmp/findomain.zip -d /tmp/ 2>/dev/null
chmod +x /tmp/findomain 2>/dev/null
cp /tmp/findomain $PREFIX/bin/ 2>/dev/null && success "Findomain installed!" || warning "Findomain failed"

# 10. Dnsx + Naabu
info "Installing Dnsx & Naabu..."
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest 2>/dev/null
go install -v github.com/projectdiscovery/naabu/v2/cmd/naabu@latest 2>/dev/null
success "Dnsx & Naabu installed!"

# ============================================
# INSTALL TOOLS - SCANNER
# ============================================
header "INSTALLING SCANNER TOOLS"

# 11. Masscan
info "Installing Masscan..."
cd "$TOOLS_DIR"
git clone https://github.com/robertdavidgraham/masscan 2>/dev/null
cd masscan && make -j4 2>/dev/null && cp bin/masscan $PREFIX/bin/ 2>/dev/null && success "Masscan installed!" || warning "Masscan failed"

# 12. RustScan
info "Installing RustScan..."
wget -q $(curl -s https://api.github.com/repos/RustScan/RustScan/releases/latest | grep browser_download_url | grep linux | cut -d '"' -f 4) -O /tmp/rustscan.deb 2>/dev/null
dpkg -i /tmp/rustscan.deb 2>/dev/null && success "RustScan installed!" || warning "RustScan failed"

# 13. GoSpider
info "Installing GoSpider..."
go install github.com/jaeles-project/gospider@latest 2>/dev/null && success "GoSpider installed!" || warning "GoSpider failed"

# 14. Hakrawler
info "Installing Hakrawler..."
go install github.com/hakluke/hakrawler@latest 2>/dev/null && success "Hakrawler installed!" || warning "Hakrawler failed"

# 15. Ffuf
info "Installing Ffuf..."
go install github.com/ffuf/ffuf@latest 2>/dev/null && success "Ffuf installed!" || warning "Ffuf failed"

# 16. Dirsearch
info "Installing Dirsearch..."
cd "$TOOLS_DIR"
git clone https://github.com/maurosoria/dirsearch 2>/dev/null
chmod +x dirsearch/dirsearch.py 2>/dev/null
ln -sf "$TOOLS_DIR/dirsearch/dirsearch.py" $PREFIX/bin/dirsearch 2>/dev/null
success "Dirsearch installed!"

# 17. Gobuster
info "Installing Gobuster..."
go install github.com/OJ/gobuster/v3@latest 2>/dev/null && success "Gobuster installed!" || warning "Gobuster failed"

# 18. Wfuzz
info "Installing Wfuzz..."
pip install wfuzz 2>/dev/null >/dev/null && success "Wfuzz installed!" || warning "Wfuzz failed"

# 19. Nikto - sudah di base
success "Nikto installed!"

# 20. WhatWeb
info "Installing WhatWeb..."
cd "$TOOLS_DIR"
git clone https://github.com/urbanadventurer/WhatWeb 2>/dev/null
chmod +x WhatWeb/whatweb 2>/dev/null
ln -sf "$TOOLS_DIR/WhatWeb/whatweb" $PREFIX/bin/whatweb 2>/dev/null
success "WhatWeb installed!"

# ============================================
# INSTALL TOOLS - EXPLOIT
# ============================================
header "INSTALLING EXPLOIT TOOLS"

# 21. SQLMap - sudah di base
success "SQLMap installed!"

# 22. Metasploit
info "Installing Metasploit..."
$PKG_MGR install -y unstable-repo 2>/dev/null
$PKG_MGR install -y metasploit 2>/dev/null && success "Metasploit installed!" || warning "Metasploit failed"

# 23. Commix
info "Installing Commix..."
cd "$TOOLS_DIR"
git clone https://github.com/commixproject/commix 2>/dev/null
chmod +x commix/commix.py 2>/dev/null
ln -sf "$TOOLS_DIR/commix/commix.py" $PREFIX/bin/commix 2>/dev/null
success "Commix installed!"

# 24. BeEF
info "Installing BeEF..."
cd "$TOOLS_DIR"
git clone https://github.com/beefproject/beef 2>/dev/null
cd beef && ./install 2>/dev/null && success "BeEF installed!" || warning "BeEF failed"

# 25. Hydra - sudah di base
success "Hydra installed!"

# 26. John the Ripper
info "Installing John..."
$PKG_MGR install -y john 2>/dev/null && success "John installed!" || warning "John failed"

# 27. Hashcat
info "Installing Hashcat..."
$PKG_MGR install -y hashcat 2>/dev/null && success "Hashcat installed!" || warning "Hashcat failed"

# 28. Searchsploit
info "Installing Searchsploit..."
cd "$TOOLS_DIR"
git clone https://github.com/offensive-security/exploitdb 2>/dev/null
ln -sf "$TOOLS_DIR/exploitdb/searchsploit" $PREFIX/bin/searchsploit 2>/dev/null
success "Searchsploit installed!"

# 29. RouterSploit
info "Installing RouterSploit..."
cd "$TOOLS_DIR"
git clone https://github.com/threat9/routersploit 2>/dev/null
cd routersploit && pip install -r requirements.txt 2>/dev/null >/dev/null
chmod +x rsf.py 2>/dev/null
ln -sf "$TOOLS_DIR/routersploit/rsf.py" $PREFIX/bin/routersploit 2>/dev/null
success "RouterSploit installed!"

# 30. XSStrike
info "Installing XSStrike..."
cd "$TOOLS_DIR"
git clone https://github.com/s0md3v/XSStrike 2>/dev/null
cd XSStrike && pip install -r requirements.txt 2>/dev/null >/dev/null
chmod +x xsstrike.py 2>/dev/null
ln -sf "$TOOLS_DIR/XSStrike/xsstrike.py" $PREFIX/bin/xsstrike 2>/dev/null
success "XSStrike installed!"

# ============================================
# INSTALL TOOLS - OSINT
# ============================================
header "INSTALLING OSINT TOOLS"

# 31. Sherlock
info "Installing Sherlock..."
cd "$TOOLS_DIR"
git clone https://github.com/sherlock-project/sherlock 2>/dev/null
cd sherlock && pip install -r requirements.txt 2>/dev/null >/dev/null
chmod +x sherlock.py 2>/dev/null
ln -sf "$TOOLS_DIR/sherlock/sherlock.py" $PREFIX/bin/sherlock 2>/dev/null
success "Sherlock installed!"

# 32. theHarvester
info "Installing theHarvester..."
cd "$TOOLS_DIR"
git clone https://github.com/laramies/theHarvester 2>/dev/null
cd theHarvester && pip install -r requirements/base.txt 2>/dev/null >/dev/null
chmod +x theHarvester.py 2>/dev/null
ln -sf "$TOOLS_DIR/theHarvester/theHarvester.py" $PREFIX/bin/theharvester 2>/dev/null
success "theHarvester installed!"

# 33. Holehe
info "Installing Holehe..."
pip install holehe 2>/dev/null >/dev/null && success "Holehe installed!" || warning "Holehe failed"

# 34. SocialScan
info "Installing SocialScan..."
pip install socialscan 2>/dev/null >/dev/null && success "SocialScan installed!" || warning "SocialScan failed"

# 35. Photon
info "Installing Photon..."
cd "$TOOLS_DIR"
git clone https://github.com/s0md3v/Photon 2>/dev/null
cd Photon && pip install -r requirements.txt 2>/dev/null >/dev/null
chmod +x photon.py 2>/dev/null
ln -sf "$TOOLS_DIR/Photon/photon.py" $PREFIX/bin/photon 2>/dev/null
success "Photon installed!"

# 36. Recon-ng
info "Installing Recon-ng..."
pip install recon-ng 2>/dev/null >/dev/null && success "Recon-ng installed!" || warning "Recon-ng failed"

# 37. Maigret
info "Installing Maigret..."
pip install maigret 2>/dev/null >/dev/null && success "Maigret installed!" || warning "Maigret failed"

# ============================================
# INSTALL TOOLS - NETWORK
# ============================================
header "INSTALLING NETWORK TOOLS"

# 38. Netcat
$PKG_MGR install -y netcat-openbsd 2>/dev/null
success "Netcat installed!"

# 39. Bettercap
info "Installing Bettercap..."
$PKG_MGR install -y bettercap 2>/dev/null && success "Bettercap installed!" || {
    cd "$TOOLS_DIR"
    go install github.com/bettercap/bettercap@latest 2>/dev/null && success "Bettercap installed!" || warning "Bettercap failed"
}

# 40. Aircrack-ng
info "Installing Aircrack-ng..."
$PKG_MGR install -y aircrack-ng 2>/dev/null && success "Aircrack-ng installed!" || warning "Aircrack-ng failed"

# 41. MDK4
info "Installing MDK4..."
$PKG_MGR install -y mdk4 2>/dev/null && success "MDK4 installed!" || warning "MDK4 failed"

# 42. Pixiewps
info "Installing Pixiewps..."
$PKG_MGR install -y pixiewps 2>/dev/null && success "Pixiewps installed!" || warning "Pixiewps failed"

# ============================================
# INSTALL TOOLS - EXTRA
# ============================================
header "INSTALLING EXTRA TOOLS"

# 43. Zphisher
info "Installing Zphisher..."
cd "$TOOLS_DIR"
git clone https://github.com/htr-tech/zphisher 2>/dev/null
chmod +x zphisher/zphisher.sh 2>/dev/null
ln -sf "$TOOLS_DIR/zphisher/zphisher.sh" $PREFIX/bin/zphisher 2>/dev/null
success "Zphisher installed!"

# 44. SayCheese
info "Installing SayCheese..."
cd "$TOOLS_DIR"
git clone https://github.com/hangetzzu/SayCheese 2>/dev/null
chmod +x SayCheese/saycheese.sh 2>/dev/null
success "SayCheese installed!"

# 45. CamPhish
info "Installing CamPhish..."
cd "$TOOLS_DIR"
git clone https://github.com/techchipnet/CamPhish 2>/dev/null
chmod +x CamPhish/camphish.sh 2>/dev/null
success "CamPhish installed!"

# 46. Ngrok
info "Installing Ngrok..."
cd "$TOOLS_DIR"
wget -q https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.tgz -O ngrok.tgz 2>/dev/null
tar -xzf ngrok.tgz 2>/dev/null
chmod +x ngrok 2>/dev/null
cp ngrok $PREFIX/bin/ 2>/dev/null
success "Ngrok installed!"

# 47. Tor - sudah di base
success "Tor installed!"

# 48. ProxyChains - sudah di base
success "ProxyChains installed!"

# 49. OpenVPN
info "Installing OpenVPN..."
$PKG_MGR install -y openvpn 2>/dev/null && success "OpenVPN installed!" || warning "OpenVPN failed"

# 50. IPGeo
info "Installing IPGeo Script..."
cat > "$PREFIX/bin/ipgeo" << 'IPGEOF'
#!/data/data/com.termux/files/usr/bin/bash
# IPGeo - IP Geolocation Tool
G='\033[1;32m'
R='\033[1;31m'
Y='\033[1;33m'
C='\033[1;36m'
N='\033[0m'

echo -e "${G}╔══════════════════════════════════════╗${N}"
echo -e "${G}║${N} ${Y}IP GEO LOCATION TOOL${N}              ${G}║${N}"
echo -e "${G}╚══════════════════════════════════════╝${N}"

if [ -z "$1" ]; then
    echo -e "${C}Usage: ipgeo <IP_ADDRESS>${N}"
    echo -e "${C}Example: ipgeo 8.8.8.8${N}"
    exit 1
fi

echo -e "${Y}[i] Looking up: $1${N}"
curl -s "http://ip-api.com/json/$1" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print('──────────────────────────────')
print(f' IP          : {data.get(\"query\", \"N/A\")}')
print(f' Status      : {data.get(\"status\", \"N/A\")}')
print(f' Country     : {data.get(\"country\", \"N/A\")}')
print(f' Region      : {data.get(\"regionName\", \"N/A\")}')
print(f' City        : {data.get(\"city\", \"N/A\")}')
print(f' ZIP         : {data.get(\"zip\", \"N/A\")}')
print(f' Lat/Lon     : {data.get(\"lat\", \"N/A\")}, {data.get(\"lon\", \"N/A\")}')
print(f' ISP         : {data.get(\"isp\", \"N/A\")}')
print(f' Org         : {data.get(\"org\", \"N/A\")}')
print(f' AS          : {data.get(\"as\", \"N/A\")}')
print('──────────────────────────────')
"
IPGEOF
chmod +x "$PREFIX/bin/ipgeo"
success "IPGeo installed!"

# ============================================
# CREATE LAUNCHER SCRIPT
# ============================================
header "CREATING CYBERPULSE LAUNCHER"

cat > "$PREFIX/bin/cyberpulse" << 'LAUNCHER'
#!/data/data/com.termux/files/usr/bin/bash
# CYBERPULSE - Main Launcher Script

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

TOOLS_DIR="$HOME/cyberpulse-tools"

show_help() {
    clear
    echo -e "${R}╔══════════════════════════════════════════════════════════╗${N}"
    echo -e "${R}║${N}  ${Y}${BD}CYBERPULSE - COMMAND REFERENCE${N}                    ${R}║${N}"
    echo -e "${R}╚══════════════════════════════════════════════════════════╝${N}"
    echo ""
    echo -e " ${G}cyberpulse${N} ${Y}<command>${N}"
    echo ""
    echo -e " ${C}Commands:${N}"
    echo -e "   ${Y}--help, -h${N}     ${DM}Show this help${N}"
    echo -e "   ${Y}--list, -l${N}     ${DM}List all tools${N}"
    echo -e "   ${Y}run <tool>${N}     ${DM}Run a specific tool${N}"
    echo -e "   ${Y}update${N}         ${DM}Update repository${N}"
    echo -e "   ${Y}banner${N}         ${DM}Show banner${N}"
    echo -e "   ${Y}info${N}           ${DM}System information${N}"
    echo ""
}

list_tools() {
    clear
    echo -e "${R}╔══════════════════════════════════════════════════════════╗${N}"
    echo -e "${R}║${N}              ${Y}${BD}50 CYBERPULSE TOOLS${N}                   ${R}║${N}"
    echo -e "${R}╚══════════════════════════════════════════════════════════╝${N}"
    echo ""
    
    echo -e "${R}${BD}[ RECON TOOLS ]${N}"
    echo -e " ${G}1.${N} nmap       ${DM}- Network discovery${N}"
    echo -e " ${G}2.${N} subfinder  ${DM}- Subdomain enumeration${N}"
    echo -e " ${G}3.${N} httpx      ${DM}- HTTP probe${N}"
    echo -e " ${G}4.${N} nuclei     ${DM}- Vulnerability scanner${N}"
    echo -e " ${G}5.${N} waybackurls${DM}- Wayback URLs${N}"
    echo -e " ${G}6.${N} gau        ${DM}- Get all URLs${N}"
    echo -e " ${G}7.${N} amass      ${DM}- Subdomain discovery${N}"
    echo -e " ${G}8.${N} assetfinder${DM}- Asset finder${N}"
   echo -e " ${G}9.${N} findomain  ${DM}- Subdomain enumeration${N}"
    echo -e " ${G}10.${N} dnsx/naabu${DM}- DNS & port scan${N}"
    echo ""
    
    echo -e "${Y}${BD}[ SCANNER TOOLS ]${N}"
    echo -e " ${G}11.${N} masscan   ${DM}- Mass port scanner${N}"
    echo -e " ${G}12.${N} rustscan  ${DM}- Fast port scanner${N}"
    echo -e " ${G}13.${N} gospider  ${DM}- Web crawler${N}"
    echo -e " ${G}14.${N} hakrawler ${DM}- Web crawler${N}"
    echo -e " ${G}15.${N} ffuf      ${DM}- Web fuzzer${N}"
    echo -e " ${G}16.${N} dirsearch ${DM}- Directory brute${N}"
    echo -e " ${G}17.${N} gobuster  ${DM}- Directory/DNS brute${N}"
    echo -e " ${G}18.${N} wfuzz     ${DM}- Web fuzzer${N}"
    echo -e " ${G}19.${N} nikto     ${DM}- Web server scanner${N}"
    echo -e " ${G}20.${N} whatweb   ${DM}- Tech detection${N}"
    echo ""
    
    echo -e "${R}${BD}[ EXPLOIT TOOLS ]${N}"
    echo -e " ${G}21.${N} sqlmap    ${DM}- SQL injection${N}"
    echo -e " ${G}22.${N} metasploit${DM}- Exploit framework${N}"
    echo -e " ${G}23.${N} commix    ${DM}- Command injection${N}"
    echo -e " ${G}24.${N} beef      ${DM}- Browser exploit${N}"
    echo -e " ${G}25.${N} hydra     ${DM}- Brute force${N}"
    echo -e " ${G}26.${N} john      ${DM}- Password cracker${N}"
    echo -e " ${G}27.${N} hashcat   ${DM}- GPU password cracker${N}"
    echo -e " ${G}28.${N} searchsploit${DM}- Exploit DB search${N}"
    echo -e " ${G}29.${N} routersploit${DM}- Router exploit${N}"
    echo -e " ${G}30.${N} xsstrike  ${DM}- XSS scanner${N}"
    echo ""
    
    echo -e "${C}${BD}[ OSINT TOOLS ]${N}"
    echo -e " ${G}31.${N} sherlock   ${DM}- Username search${N}"
    echo -e " ${G}32.${N} theharvester${DM}- Email/subdomain OSINT${N}"
    echo -e " ${G}33.${N} holehe     ${DM}- Email verification${N}"
    echo -e " ${G}34.${N} socialscan ${DM}- Social media scan${N}"
    echo -e " ${G}35.${N} photon     ${DM}- OSINT crawler${N}"
    echo -e " ${G}36.${N} recon-ng   ${DM}- OSINT framework${N}"
    echo -e " ${G}37.${N} maigret    ${DM}- Username search${N}"
    echo ""
    
    echo -e "${B}${BD}[ NETWORK TOOLS ]${N}"
    echo -e " ${G}38.${N} netcat     ${DM}- Networking tool${N}"
    echo -e " ${G}39.${N} bettercap  ${DM}- MITM framework${N}"
    echo -e " ${G}40.${N} aircrack-ng${DM}- WiFi security${N}"
    echo -e " ${G}41.${N} mdk4       ${DM}- WiFi stress test${N}"
    echo -e " ${G}42.${N} pixiewps   ${DM}- WPS brute force${N}"
    echo ""
    
    echo -e "${P}${BD}[ EXTRA TOOLS ]${N}"
    echo -e " ${G}43.${N} zphisher   ${DM}- Phishing tool${N}"
    echo -e " ${G}44.${N} saycheese  ${DM}- Webcam grabber${N}"
    echo -e " ${G}45.${N} camphish   ${DM}- Cam phishing${N}"
    echo -e " ${G}46.${N} ngrok      ${DM}- Expose localhost${N}"
    echo -e " ${G}47.${N} tor        ${DM}- Anonymous routing${N}"
    echo -e " ${G}48.${N} proxychains${DM}- Proxy chainer${N}"
    echo -e " ${G}49.${N} openvpn    ${DM}- VPN client${N}"
    echo -e " ${G}50.${N} ipgeo      ${DM}- IP geolocation${N}"
    echo ""
}

run_tool() {
    case "$1" in
        nmap|nmap)      shift; nmap "$@" ;;
        subfinder)      shift; subfinder "$@" ;;
        httpx)          shift; httpx "$@" ;;
        nuclei)         shift; nuclei "$@" ;;
        waybackurls)    shift; waybackurls "$@" ;;
        gau)            shift; gau "$@" ;;
        amass)          shift; amass "$@" ;;
        assetfinder)    shift; assetfinder "$@" ;;
        findomain)      shift; findomain "$@" ;;
        masscan)        shift; masscan "$@" ;;
        rustscan)       shift; rustscan "$@" ;;
        gospider)       shift; gospider "$@" ;;
        hakrawler)      shift; hakrawler "$@" ;;
        ffuf)           shift; ffuf "$@" ;;
        dirsearch)      shift; python "$TOOLS_DIR/dirsearch/dirsearch.py" "$@" ;;
        gobuster)       shift; gobuster "$@" ;;
        wfuzz)          shift; wfuzz "$@" ;;
        nikto)          shift; nikto "$@" ;;
        whatweb)        shift; perl "$TOOLS_DIR/WhatWeb/whatweb" "$@" ;;
        sqlmap)         shift; sqlmap "$@" ;;
        metasploit)     shift; msfconsole "$@" ;;
        commix)         shift; python "$TOOLS_DIR/commix/commix.py" "$@" ;;
        beef)           echo -e "${Y}Run: cd $TOOLS_DIR/beef && ./beef${N}" ;;
        hydra)          shift; hydra "$@" ;;
        john)           shift; john "$@" ;;
        hashcat)        shift; hashcat "$@" ;;
        searchsploit)   shift; searchsploit "$@" ;;
        routersploit)   shift; python "$TOOLS_DIR/routersploit/rsf.py" "$@" ;;
        xsstrike)       shift; python "$TOOLS_DIR/XSStrike/xsstrike.py" "$@" ;;
        sherlock)       shift; python "$TOOLS_DIR/sherlock/sherlock.py" "$@" ;;
        theharvester)   shift; python "$TOOLS_DIR/theHarvester/theHarvester.py" "$@" ;;
        holehe)         shift; holehe "$@" ;;
        socialscan)     shift; socialscan "$@" ;;
        photon)         shift; python "$TOOLS_DIR/Photon/photon.py" "$@" ;;
        recon-ng)       shift; recon-ng "$@" ;;
        maigret)        shift; maigret "$@" ;;
        netcat)         shift; nc "$@" ;;
        bettercap)      shift; bettercap "$@" ;;
        aircrack)       shift; aircrack-ng "$@" ;;
        mdk4)           shift; mdk4 "$@" ;;
        pixiewps)       shift; pixiewps "$@" ;;
        zphisher)       shift; bash "$TOOLS_DIR/zphisher/zphisher.sh" "$@" ;;
        saycheese)      shift; bash "$TOOLS_DIR/SayCheese/saycheese.sh" "$@" ;;
        camphish)       shift; bash "$TOOLS_DIR/CamPhish/camphish.sh" "$@" ;;
        ngrok)          shift; ngrok "$@" ;;
        tor)            shift; tor "$@" ;;
        proxychains)    shift; proxychains4 "$@" ;;
        openvpn)        shift; openvpn "$@" ;;
        ipgeo)          shift; ipgeo "$@" ;;
        *)              echo -e "${R}[!] Unknown tool: $1${N}"; echo -e "${Y}Use 'cyberpulse --list' to see all tools${N}" ;;
    esac
}

case "${1:-}" in
    --help|-h)      show_help ;;
    --list|-l)      list_tools ;;
    run)            shift; run_tool "$@" ;;
    update)         cd "$(dirname "$0")" 2>/dev/null; git pull 2>/dev/null || echo -e "${R}[!] Update failed${N}" ;;
    banner)         cat "$HOME/cyberpulse-tools/../.banner.txt" 2>/dev/null || echo -e "${R}[!] Banner not found${N}" ;;
    info)
        clear
        echo -e "${R}╔══════════════════════════════════════╗${N}"
        echo -e "${R}║${N} ${Y}CYBERPULSE SYSTEM INFO${N}              ${R}║${N}"
        echo -e "${R}╚══════════════════════════════════════╝${N}"
        echo -e " ${G}User:${N}     $(whoami)"
        echo -e " ${G}Device:${N}   $(getprop ro.product.model 2>/dev/null || uname -m)"
        echo -e " ${G}Kernel:${N}   $(uname -r)"
        echo -e " ${G}Uptime:${N}   $(uptime | awk '{print $3,$4}' | sed 's/,//')"
        echo -e " ${G}IP:${N}       $(curl -s ifconfig.me 2>/dev/null || echo 'Unknown')"
        echo -e " ${G}Storage:${N}  $(df -h $HOME | tail -1 | awk '{print $3 "/" $2}')"
        echo -e " ${G}Tools:${N}    50 installed"
        echo ""
        ;;
    *)              show_help ;;
esac
LAUNCHER

chmod +x "$PREFIX/bin/cyberpulse"
success "CyberPulse launcher created!"

# ============================================
# CREATE MENU SCRIPT (Tools Menu)
# ============================================
header "CREATING TOOLS MENU"

cat > "$TOOLS_DIR/../menu.sh" << 'MENUEOF'
#!/data/data/com.termux/files/usr/bin/bash
# CYBERPULSE - Interactive Tools Menu
source "$(dirname "$0")/colors.sh"

while true; do
    clear
    
    # Tampilkan banner
    echo -e "${R}██████████████████████████████████████████████████████${N}"
    echo -e "${R}█${N}  ${Y}CYBERPULSE${N} ${G}INTERACTIVE MENU${N}                    ${R}█${N}"
    echo -e "${R}█${N}  ${C}50 Tools • Recon • Scanner • Exploit • OSINT${N}  ${R}█${N}"
    echo -e "${R}██████████████████████████████████████████████████████${N}"
    echo ""
    
    echo -e " ${R}[${Y}1${R}]${N} ${G}RECON TOOLS${N}     ${DM}(nmap, subfinder, nuclei, ...)${N}"
    echo -e " ${R}[${Y}2${R}]${N} ${Y}SCANNER TOOLS${N}   ${DM}(masscan, ffuf, dirsearch, ...)${N}"
    echo -e " ${R}[${Y}3${R}]${N} ${R}EXPLOIT TOOLS${N}   ${DM}(sqlmap, metasploit, hydra, ...)${N}"
    echo -e " ${R}[${Y}4${R}]${N} ${C}OSINT TOOLS${N}     ${DM}(sherlock, theharvester, ...)${N}"
    echo -e " ${R}[${Y}5${R}]${N} ${B}NETWORK TOOLS${N}   ${DM}(bettercap, aircrack, ...)${N}"
    echo -e " ${R}[${Y}6${R}]${N} ${P}EXTRA TOOLS${N}     ${DM}(zphisher, ngrok, ipgeo, ...)${N}"
    echo -e " ${R}[${Y}7${R}]${N} ${W}SYSTEM INFO${N}"
    echo -e " ${R}[${Y}0${R}]${N} ${R}EXIT${N}"
    echo ""
    
    read -p "$(echo -e ${Y}"[?] Pilih menu: "${N})" menu
    
    case $menu in
        1)
            while true; do
                clear
                header "RECON TOOLS"
                echo -e " ${Y}[1]${N} ${G}nmap${N}         ${DM}- Network discovery & port scanning${N}"
                echo -e " ${Y}[2]${N} ${G}subfinder${N}    ${DM}- Subdomain enumeration${N}"
                echo -e " ${Y}[3]${N} ${G}httpx${N}        ${DM}- HTTP probe & check${N}"
                echo -e " ${Y}[4]${N} ${G}nuclei${N}       ${DM}- Vulnerability scanner${N}"
                echo -e " ${Y}[5]${N} ${G}waybackurls${N}  ${DM}- URL dari Wayback Machine${N}"
                echo -e " ${Y}[6]${N} ${G}gau${N}          ${DM}- Get all URLs${N}"
                echo -e " ${Y}[7]${N} ${G}amass${N}        ${DM}- Subdomain discovery (OWASP)${N}"
                echo -e " ${Y}[8]${N} ${G}assetfinder${N}  ${DM}- Asset discovery${N}"
                echo -e " ${Y}[9]${N} ${G}findomain${N}    ${DM}- Subdomain enumeration${N}"
                echo -e " ${Y}[10]${N} ${G}dnsx/naabu${N}   ${DM}- DNS & port scanner${N}"
                echo -e " ${Y}[0]${N} ${R}Kembali${N}"
                echo ""
                read -p "$(echo -e ${Y}"[?] Pilih tool (atau 0 untuk kembali): "${N})" tool
                [ "$tool" == "0" ] && break
                case $tool in
                    1) read -p "Target: " t; nmap -A "$t" ;;
                    2) read -p "Domain: " t; subfinder -d "$t" ;;
                    3) read -p "URL: " t; httpx -u "$t" ;;
                    4) read -p "Target: " t; nuclei -u "$t" ;;
                    5) read -p "Domain: " t; waybackurls "$t" ;;
                    6) read -p "Domain: " t; gau "$t" ;;
                    7) read -p "Domain: " t; amass enum -d "$t" ;;
                    8) read -p "Domain: " t; assetfinder "$t" ;;
                    9) read -p "Domain: " t; findomain -t "$t" ;;
                    10) read -p "Target: " t; naabu -host "$t" ;;
                    *) error "Pilihan tidak valid" ;;
                esac
                echo ""
                read -p "$(echo -e ${Y}"Press Enter to continue...")"
            done
            ;;
        2)
            while true; do
                clear
                header "SCANNER TOOLS"
                echo -e " ${Y}[11]${N} ${G}masscan${N}      ${DM}- Mass port scanner${N}"
                echo -e " ${Y}[12]${N} ${G}rustscan${N}     ${DM}- Fast port scanner${N}"
                echo -e " ${Y}[13]${N} ${G}gospider${N}     ${DM}- Web crawler${N}"
                echo -e " ${Y}[14]${N} ${G}hakrawler${N}    ${DM}- Web crawler${N}"
                echo -e " ${Y}[15]${N} ${G}ffuf${N}         ${DM}- Web fuzzer${N}"
                echo -e " ${Y}[16]${N} ${G}dirsearch${N}    ${DM}- Directory brute-force${N}"
                echo -e " ${Y}[17]${N} ${G}gobuster${N}     ${DM}- Directory & DNS brute${N}"
                echo -e " ${Y}[18]${N} ${G}wfuzz${N}        ${DM}- Web fuzzer${N}"
                echo -e " ${Y}[19]${N} ${G}nikto${N}        ${DM}- Web server scanner${N}"
                echo -e " ${Y}[20]${N} ${G}whatweb${N}      ${DM}- Web tech detector${N}"
                echo -e " ${Y}[0]${N} ${R}Kembali${N}"
                echo ""
                read -p "$(echo -e ${Y}"[?] Pilih tool (atau 0 untuk kembali): "${N})" tool
                [ "$tool" == "0" ] && break
                case $tool in
                    11) read -p "Target (contoh: 192.168.1.0/24): " t; masscan "$t" -p1-1000 --rate=1000 ;;
                    12) read -p "Target: " t; rustscan -a "$t" ;;
                    13) read -p "URL: " t; gospider -s "$t" ;;
                    14) read -p "URL: " t; hakrawler -url "$t" ;;
                    15) read -p "URL + Fuzz (contoh: http://example.com/FUZZ): " t; ffuf -u "$t" -w /usr/share/wordlists/dirb/common.txt ;;
                    16) read -p "URL: " t; python $HOME/cyberpulse-tools/dirsearch/dirsearch.py -u "$t" ;;
                    17) read -p "Target: " t; read -p "Mode (dir/dns): " m; gobuster "$m" -u "$t" -w /usr/share/wordlists/dirb/common.txt ;;
                    18) read -p "Target: " t; wfuzz -w /usr/share/wordlists/dirb/common.txt "$t" ;;
                    19) read -p "Target: " t; nikto -h "$t" ;;
                    20) read -p "Target: " t; whatweb "$t" ;;
                    *) error "Pilihan tidak valid" ;;
                esac
                echo ""
                read -p "$(echo -e ${Y}"Press Enter to continue...")"
            done
            ;;
        3)
            while true; do
                clear
                header "EXPLOIT TOOLS"
                echo -e " ${Y}[21]${N} ${G}sqlmap${N}       ${DM}- SQL Injection automation${N}"
                echo -e " ${Y}[22]${N} ${G}metasploit${N}   ${DM}- Exploit framework${N}"
                echo -e " ${Y}[23]${N} ${G}commix${N}       ${DM}- Command Injection${N}"
                echo -e " ${Y}[24]${N} ${G}beef${N}         ${DM}- Browser exploit framework${N}"
                echo -e " ${Y}[25]${N} ${G}hydra${N}        ${DM}- Brute-force login${N}"
                echo -e " ${Y}[26]${N} ${G}john${N}         ${DM}- Password cracker${N}"
                echo -e " ${Y}[27]${N} ${G}hashcat${N}      ${DM}- GPU password cracker${N}"
                echo -e " ${Y}[28]${N} ${G}searchsploit${N} ${DM}- Exploit DB search${N}"
                echo -e " ${Y}[29]${N} ${G}routersploit${N} ${DM}- Router exploit${N}"
                echo -e " ${Y}[30]${N} ${G}xsstrike${N}     ${DM}- XSS vulnerability scanner${N}"
                echo -e " ${Y}[0]${N} ${R}Kembali${N}"
                echo ""
                read -p "$(echo -e ${Y}"[?] Pilih tool (atau 0 untuk kembali): "${N})" tool
                [ "$tool" == "0" ] && break
                case $tool in
                    21) read -p "URL: " t; sqlmap -u "$t" --batch ;;
                    22) msfconsole ;;
                    23) read -p "URL: " t; python $HOME/cyberpulse-tools/commix/commix.py --url="$t" ;;
                    24) echo -e "${Y}cd $HOME/cyberpulse-tools/beef && ./beef${N}" ;;
                    25) read -p "Target: " t; read -p "Service (ssh/ftp): " s; hydra -L /usr/share/wordlists/metasploit/common_users.txt -P /usr/share/wordlists/metasploit/common_passwords.txt "$s"://"$t" ;;
                    26) read -p "File hash: " t; john "$t" ;;
                    27) read -p "File hash: " t; hashcat -m 0 "$t" /usr/share/wordlists/rockyou.txt ;;
                    28) read -p "Search keyword: " t; searchsploit "$t" ;;
                    29) python $HOME/cyberpulse-tools/routersploit/rsf.py ;;
                    30) read -p "URL: " t; python $HOME/cyberpulse-tools/XSStrike/xsstrike.py -u "$t" ;;
                    *) error "Pilihan tidak valid" ;;
                esac
                echo ""
                read -p "$(echo -e ${Y}"Press Enter to continue...")"
            done
            ;;
        4)
            while true; do
                clear
                header "OSINT TOOLS"
                echo -e " ${Y}[31]${N} ${G}sherlock${N}     ${DM}- Username search across networks${N}"
                echo -e " ${Y}[32]${N} ${G}theharvester${N} ${DM}- Email & subdomain OSINT${N}"
                echo -e " ${Y}[33]${N} ${G}holehe${N}       ${DM}- Email verification${N}"
                echo -e " ${Y}[34]${N} ${G}socialscan${N}   ${DM}- Social media scan${N}"
                echo -e " ${Y}[35]${N} ${G}photon${N}       ${DM}- OSINT crawler${N}"
                echo -e " ${Y}[36]${N} ${G}recon-ng${N}     ${DM}- OSINT framework${N}"
                echo -e " ${Y}[37]${N} ${G}maigret${N}      ${DM}- Advanced username search${N}"
                echo -e " ${Y}[0]${N} ${R}Kembali${N}"
                echo ""
                read -p "$(echo -e ${Y}"[?] Pilih tool (atau 0 untuk kembali): "${N})" tool
                [ "$tool" == "0" ] && break
                case $tool in
                    31) read -p "Username: " t; python $HOME/cyberpulse-tools/sherlock/sherlock.py "$t" ;;
                    32) read -p "Domain: " t; python $HOME/cyberpulse-tools/theHarvester/theHarvester.py -d "$t" -b all ;;
                    33) read -p "Email: " t; holehe "$t" ;;
                    34) read -p "Username/Email: " t; socialscan "$t" ;;
                    35) read -p "Domain: " t; python $HOME/cyberpulse-tools/Photon/photon.py -u "$t" ;;
                    36) recon-ng ;;
                    37) read -p "Username: " t; maigret "$t" ;;
                    *) error "Pilihan tidak valid" ;;
                esac
                echo ""
                read -p "$(echo -e ${Y}"Press Enter to continue...")"
            done
            ;;
        5)
            while true; do
                clear
                header "NETWORK TOOLS"
                echo -e " ${Y}[38]${N} ${G}netcat${N}       ${DM}- Networking swiss army knife${N}"
                echo -e " ${Y}[39]${N} ${G}bettercap${N}    ${DM}- MITM framework${N}"
                echo -e " ${Y}[40]${N} ${G}aircrack-ng${N}  ${DM}- WiFi security testing${N}"
                echo -e " ${Y}[41]${N} ${G}mdk4${N}         ${DM}- WiFi stress testing${N}"
                echo -e " ${Y}[42]${N} ${G}pixiewps${N}     ${DM}- WPS brute force${N}"
                echo -e " ${Y}[0]${N} ${R}Kembali${N}"
                echo ""
                read -p "$(echo -e ${Y}"[?] Pilih tool (atau 0 untuk kembali): "${N})" tool
                [ "$tool" == "0" ] && break
                case $tool in
                    38) read -p "Command (contoh: -lvnp 4444): " t; nc $t ;;
                    39) bettercap ;;
                    40) aircrack-ng ;;
                    41) mdk4 --help ;;
                    42) read -p "BSSID: " t; pixiewps --pke --pkr "$t" ;;
                    *) error "Pilihan tidak valid" ;;
                esac
                echo ""
                read -p "$(echo -e ${Y}"Press Enter to continue...")"
            done
            ;;
        6)
            while true; do
                clear
                header "EXTRA TOOLS"
                echo -e " ${Y}[43]${N} ${G}zphisher${N}     ${DM}- Phishing tool${N}"
                echo -e " ${Y}[44]${N} ${G}saycheese${N}    ${DM}- Webcam grabber${N}"
                echo -e " ${Y}[45]${N} ${G}camphish${N}     ${DM}- Camera phishing${N}"
                echo -e " ${Y}[46]${N} ${G}ngrok${N}        ${DM}- Expose localhost to internet${N}"
                echo -e " ${Y}[47]${N} ${G}tor${N}          ${DM}- Anonymous routing${N}"
                echo -e " ${Y}[48]${N} ${G}proxychains${N}  ${DM}- Proxy chainer${N}"
                echo -e " ${Y}[49]${N} ${G}openvpn${N}      ${DM}- VPN client${N}"
                echo -e " ${Y}[50]${N} ${G}ipgeo${N}        ${DM}- IP geolocation${N}"
                echo -e " ${Y}[0]${N} ${R}Kembali${N}"
                echo ""
                read -p "$(echo -e ${Y}"[?] Pilih tool (atau 0 untuk kembali): "${N})" tool
                [ "$tool" == "0" ] && break
                case $tool in
                    43) bash $HOME/cyberpulse-tools/zphisher/zphisher.sh ;;
                    44) echo -e "${Y}cd $HOME/cyberpulse-tools/SayCheese && bash saycheese.sh${N}" ;;
                    45) echo -e "${Y}cd $HOME/cyberpulse-tools/CamPhish && bash camphish.sh${N}" ;;
                    46) read -p "Port: " t; ngrok http "$t" ;;
                    47) tor ;;
                    48) read -p "Command with proxychains: " t; proxychains4 $t ;;
                    49) read -p "Config file: " t; openvpn "$t" ;;
                    50) read -p "IP Address: " t; ipgeo "$t" ;;
                    *) error "Pilihan tidak valid" ;;
                esac
                echo ""
                read -p "$(echo -e ${Y}"Press Enter to continue...")"
            done
            ;;
        7)
            clear
            header "SYSTEM INFORMATION"
            echo -e " ${G}User:${N}         $(whoami)"
            echo -e " ${G}Hostname:${N}     $(uname -n)"
            echo -e " ${G}Device:${N}       $(getprop ro.product.model 2>/dev/null || echo 'Android')"
            echo -e " ${G}Architecture:${N} $(uname -m)"
            echo -e " ${G}Kernel:${N}       $(uname -r)"
            echo -e " ${G}Uptime:${N}       $(uptime | awk '{print $3,$4}' | sed 's/,//')"
            echo -e " ${G}Storage:${N}      $(df -h $HOME | tail -1 | awk '{print $3 " / " $2}')"
            echo -e " ${G}Public IP:${N}    $(curl -s ifconfig.me 2>/dev/null || echo 'Unknown')"
            echo -e " ${G}Local IP:${N}     $(ifconfig 2>/dev/null | grep inet | head -1 | awk '{print $2}' || echo 'Unknown')"
            echo ""
            echo -e " ${Y}INSTALLED TOOLS:${N}"
            echo -e "  ${G}Recon:${N}      10 tools"
            echo -e "  ${G}Scanner:${N}    10 tools"
            echo -e "  ${G}Exploit:${N}    10 tools"
            echo -e "  ${G}OSINT:${N}       7 tools"
            echo -e "  ${G}Network:${N}     5 tools"
            echo -e "  ${G}Extra:${N}       8 tools"
            echo -e "  ${Y}Total:${N}      50 tools"
            echo ""
            read -p "$(echo -e ${Y}"Press Enter to continue...")"
            ;;
        0)
            echo -e "${R}Exiting CYBERPULSE...${N}"
            echo -e "${G}HACK THE PLANET! 🔥${N}"
            exit 0
            ;;
        *)
            error "Pilihan tidak valid!"
            sleep 1
            ;;
    esac
done
MENUEOF

chmod +x "$TOOLS_DIR/../menu.sh"
ln -sf "$TOOLS_DIR/../menu.sh" $PREFIX/bin/cybermenu 2>/dev/null
success "CyberMenu created! (type 'cybermenu' to launch)"

# ============================================
# INSTALL WORLDSLISTS (Common)
# ============================================
header "INSTALLING WORDLISTS"
mkdir -p "$PREFIX/share/wordlists"
if [ ! -f "$PREFIX/share/wordlists/common.txt" ]; then
    wget -q https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt -O "$PREFIX/share/wordlists/common.txt" 2>/dev/null
    wget -q https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/directory-list-2.3-medium.txt -O "$PREFIX/share/wordlists/directory.txt" 2>/dev/null
    wget -q https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-medium-directories.txt -O "$PREFIX/share/wordlists/raft.txt" 2>/dev/null
    success "Wordlists installed!"
else
    info "Wordlists already exist"
fi

# ============================================
# EXPORT PATH
# ============================================
header "CONFIGURING PATH"

if ! grep -q "cyberpulse-tools" "$HOME/.bashrc" 2>/dev/null; then
    cat >> "$HOME/.bashrc" << 'PATHEOF'

# CYBERPULSE Path
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/cyberpulse-tools:$PATH"
PATHEOF
    success "PATH configured!"
fi

# Source the bashrc
source "$HOME/.bashrc" 2>/dev/null

# ============================================
# FINAL CHECK
# ============================================
header "INSTALLATION COMPLETE"

echo ""
echo -e "${G}╔══════════════════════════════════════════════════════════╗${N}"
echo -e "${G}║${N}  ${Y}${BD}✓ CYBERPULSE ARSENAL v1.0 INSTALLED SUCCESSFULLY${N}  ${G}║${N}"
echo -e "${G}║${N}                                                        ${G}║${N}"
echo -e "${G}║${N}  ${R}${BD}50 TOOLS${N}  ${G}${BD}READY FOR ACTION${N}                    ${G}║${N}"
echo -e "${G}║${N}                                                        ${G}║${N}"
echo -e "${G}║${N}  ${C}Commands:${N}                                              ${G}║${N}"
echo -e "${G}║${N}  ${Y}cyberpulse --help${N}   ${DM}- Show help${N}                      ${G}║${N}"
echo -e "${G}║${N}  ${Y}cyberpulse --list${N}    ${DM}- List all tools${N}                  ${G}║${N}"
echo -e "${G}║${N}  ${Y}cyberpulse run nmap${N}  ${DM}- Run a tool${N}                      ${G}║${N}"
echo -e "${G}║${N}  ${Y}cybermenu${N}            ${DM}- Interactive menu${N}                 ${G}║${N}"
echo -e "${G}║${N}                                                        ${G}║${N}"
echo -e "${G}║${N}  ${C}Tools location: ${Y}~/cyberpulse-tools/${N}                       ${G}║${N}"
echo -e "${G}║${N}                                                        ${G}║${N}"
echo -e "${G}║${N}  ${R}${BD}⚠  USE ONLY ON AUTHORIZED SYSTEMS  ⚠${N}                 ${G}║${N}"
echo -e "${G}╚══════════════════════════════════════════════════════════╝${N}"
echo ""
echo -e "${Y}${BOLT}${N} ${G}Restart Termux or run:${N} ${C}source ~/.bashrc${N}"
echo ""  
