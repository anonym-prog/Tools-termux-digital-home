# 🔴🟡🟢 CYBERPULSE - Termux Arsenal v1.0

╔══════════════════════════════════════════════════════════╗
║   ██████╗██╗   ██╗██████╗ ███████╗██████╗ ██████╗     ║
║  ██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗██╔══██╗    ║
║  ██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝██████╔╝    ║
║  ██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗██╔═══╝     ║
║  ╚██████╗   ██║   ██████╔╝███████╗██║  ██║██║         ║
║   ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝         ║
║     ██████╗ ██╗   ██╗██████╗ ███████╗██████╗          ║
║    ██╔════╝ ██║   ██║██╔══██╗██╔════╝██╔══██╗         ║
║    ██║  ███╗██║   ██║██████╔╝█████╗  ██████╔╝         ║
║    ██║   ██║██║   ██║██╔══██╗██╔══╝  ██╔══██╗         ║
║    ╚██████╔╝╚██████╔╝██║  ██║███████╗██║  ██║         ║
║     ╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝         ║
║                                                         ║
║  🔴 MERAH 🟡 KUNING 🟢 HIJAU                          ║
║  ⚡ 50 TOOLS RECON • SCANNER • EXPLOIT • OSINT ⚡      ║
╚══════════════════════════════════════════════════════════╝

> **Authorized Pentesting Toolkit for Termux Android**
> **Author:** [Your GitHub Username]
> **Version:** 1.0 | **Platform:** Termux (Android) / Linux

---

## 🔥 FITUR

| Fitur | Deskripsi |
|-------|-----------|
| 🎯 **50 Tools** | Recon, Scanner, Exploit, OSINT, Network, Extra |
| 🎨 **Cyber Theme** | Warna Merah 🟡 Kuning 🟢 Hijau |
| 🖥️ **Banner Keren** | ASCII Art + System Info saat startup |
| ⚡ **1-Click Install** | Semua tools terinstall otomatis |
| 🔄 **Update** | Mudah di-update via git pull |
| 📱 **Termux Optimized** | Khusus untuk Android Termux |

---

## ⚡ INSTALASI

```bash
# 1. Update Termux
pkg update && pkg upgrade -y
pkg install git curl wget python -y

# 2. Clone Repository
git clone https://github.com/[username]/CYBERPULSE.git

# 3. Masuk ke folder
cd CYBERPULSE

# 4. Beri izin eksekusi
chmod +x *.sh tools/**/*.sh

# 5. Install semua tools
bash install.sh

# 6. (Opsional) Pasang Banner Cyber
bash banner.sh

# Melihat semua tools yang terinstall
cyberpulse --list
# atau
cyberpulse -l

# Menjalankan tools tertentu
cyberpulse run nmap
cyberpulse run sqlmap
cyberpulse run bettercap

# Update tools
cyberpulse update

# Menampilkan banner
cyberpulse banner

# Info sistem
cyberpulse info

┌──[root@cyberpulse]─[~/tools]
└──╼ $ █

Warna Scheme:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔴 #FF0000 - Merah (Exploit/Danger)
🟡 #FFFF00 - Kuning (Warning/Scanner)
🟢 #00FF00 - Hijau (Success/Recon)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
