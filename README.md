# 🏠 Digital Home Pentest

**10 Tools Penetration Testing untuk Termux (Android)**

Repository ini berisi 10 tools penetration testing yang kompatibel dengan **Termux** di Android. Cocok untuk belajar ethical hacking, vulnerability assessment, dan security testing.

---

## 📦 Daftar 10 Tools

| No | Tools | Fungsi |
|:--:|-------|--------|
| 1 | **Nmap** | Network scanning & port enumeration |
| 2 | **Metasploit** | Exploitation framework |
| 3 | **SQLMap** | SQL injection automation |
| 4 | **IP Geolocation** | IP address tracking & geolocation |
| 5 | **Wireshark (Termshark)** | Packet analysis & network sniffing |
| 6 | **Hydra** | Brute-force password cracking |
| 7 | **Nikto** | Web server vulnerability scanner |
| 8 | **John the Ripper** | Password hash cracking |
| 9 | **Aircrack-ng** | Wireless network security testing |
| 10 | **Netcat** | Networking swiss army knife |

---

## 🚀 Cara Install Semua Tools

Buka Termux dan jalankan:

```bash
pkg update && pkg upgrade -y
pkg install git curl wget -y

# Install tools via pkg
pkg install nmap hydra john aircrack-ng netcat -y
pkg install unstable-repo && pkg install metasploit
pkg install python python2 && pip install sqlmap
pkg install perl && git clone https://github.com/sullo/nikto
git clone https://github.com/maldevel/IPGeoLocation
pkg install termshark
