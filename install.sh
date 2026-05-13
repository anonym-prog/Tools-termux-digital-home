---

### 2️⃣ **`colors.sh`**

```bash
#!/data/data/com.termux/files/usr/bin/bash
# CYBERPULSE - Color Configuration
# Theme: Red 🟡 Yellow 🟢 Green
`source color.sh`

# Warna dasar
R='\033[1;31m'   # Merah - untuk exploit/danger
G='\033[1;32m'   # Hijau - untuk success/recon
Y='\033[1;33m'   # Kuning - untuk warning/scanner
B='\033[1;34m'   # Biru
P='\033[1;35m'   # Purple
C='\033[1;36m'   # Cyan
W='\033[1;37m'   # Putih
N='\033[0m'      # Reset

# Background
BG_R='\033[41m'   # Background Merah
BG_G='\033[42m'   # Background Hijau  
BG_Y='\033[43m'   # Background Kuning
BG_B='\033[44m'   # Background Biru
BG_P='\033[45m'   # Background Ungu
BG_C='\033[46m'   # Background Cyan

# Style
BD='\033[1m'      # Bold
DM='\033[2m'      # Dim
UL='\033[4m'      # Underline
BL='\033[5m'      # Blink
RV='\033[7m'      # Reverse

# Icon dengan warna
CHECK="${G}✓${N}"
CROSS="${R}✗${N}"
WARN="${Y}⚠${N}"
ARROW="${C}→${N}"
SKULL="${R}☠${N}"
BOLT="${Y}⚡${N}"
SHIELD="${G}🛡${N}"
EYE="${C}👁${N}"
FIRE="${R}🔥${N}"
LOCK="${Y}🔒${N}"
UNLOCK="${G}🔓${N}"
GLOBE="${C}🌐${N}"
TARGET="${R}🎯${N}"
GEAR="${G}⚙${N}"
STAR="${Y}★${N}"

# === FUNGSI FORMAT ===

# Cetak dengan border
border() {
    echo -e "${R}╔══════════════════════════════════════════════════════════╗${N}"
    echo -e "${R}║${N} $1"
    echo -e "${R}╚══════════════════════════════════════════════════════════╝${N}"
}

# Cetak sukses
success() {
    echo -e "${G}[${CHECK}] ${1}${N}"
}

# Cetak error/gagal
error() {
    echo -e "${R}[${CROSS}] ${1}${N}"
}

# Cetak warning
warning() {
    echo -e "${Y}[${WARN}] ${1}${N}"
}

# Cetak info
info() {
    echo -e "${C}[${ARROW}] ${1}${N}"
}

# Cetak header section
header() {
    echo ""
    echo -e "${Y}╔══════════════════════════════════════════════════════════╗${N}"
    echo -e "${Y}║${N} ${R}${BD}◆${N} ${G}${BD}$1${N} ${R}${BD}◆${N}"
    echo -e "${Y}╚══════════════════════════════════════════════════════════╝${N}"
    echo ""
}

# Cetak dengan typing effect
typing() {
    text="$1"
    color="$2"
    for ((i=0; i<${#text}; i++)); do
        echo -ne "${color}${text:$i:1}${N}"
        sleep 0.03
    done
    echo ""
}

# Progress bar
progress() {
    local duration=$1
    local width=50
    local percent=0
    
    for ((i=0; i<=width; i++)); do
        percent=$((i * 100 / width))
        echo -ne "\r${G}[${N}"
        for ((j=0; j<i; j++)); do echo -ne "${G}█${N}"; done
        for ((j=i; j<width; j++)); do echo -ne "${R}░${N}"; done
        echo -ne "${G}]${N} ${Y}${percent}%${N}"
        sleep "$(echo "scale=3; $duration/$width" | bc)"
    done
    echo ""
}

# Loading spinner
spinner() {
    local pid=$1
    local text="$2"
    local spinstr='|/-\'
    while kill -0 $pid 2>/dev/null; do
        for ((i=0; i<${#spinstr}; i++)); do
            echo -ne "\r${Y}[${spinstr:$i:1}]${N} ${text} ... "
            sleep 0.1
        done
    done
    echo -e "\r${G}[${CHECK}]${N} ${text} ${G}Done!${N}"
}

# Print menu item
menu_item() {
    local num=$1
    local name=$2
    local desc=$3
    echo -e "  ${R}[${Y}${num}${R}]${N} ${G}${name}${N} ${DM}-${N} ${C}${desc}${N}"
}

# Tool header
tool_banner() {
    local name=$1
    local category=$2
    echo ""
    echo -e "${R}╔══════════════════════════════════════════════════════════╗${N}"
    echo -e "${R}║${N} ${Y}${BOLT}${N} ${G}${name}${N}"
    echo -e "${R}║${N} ${C}Category:${N} ${Y}${category}${N}"
    echo -e "${R}╚══════════════════════════════════════════════════════════╝${N}"
    echo ""
}

# Export semua variabel
export R G Y B P C W N
export BG_R BG_G BG_Y BG_B BG_P BG_C
export BD DM UL BL RV
export CHECK CROSS WARN ARROW SKULL BOLT SHIELD EYE FIRE LOCK UNLOCK GLOBE TARGET GEAR STAR
