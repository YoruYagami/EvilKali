<h1 align="center">
  <br>
  <a href=""><img src="https://github.com/YoruYagami/EvilKali/assets/70035442/569bafd8-a412-43ed-a875-02dbdced5347" alt="" width="500" height="500"></a>
  <br>
  <img src="https://img.shields.io/badge/Maintained%3F-Yes-23a82c">
  <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/YoruYagami/Evilkali">
  <img src="https://img.shields.io/badge/Developed%20for-kali%20linux/BlackArch-blueviolet">
</h1>

⚠️ EvilKali is currently in its early release stage. Numerous additional tools will be incorporated in the future, along with enhancements to the user interface and the introduction of compatibility for arch-based environments.

# EvilKali
EvilKali is a Bash script that automates the download and installation of various penetration testing tools. 
The purpose of the script is to create an environment with all the necessary tools for Red Teaming and Application Security.

## Usage
```
sudo ./evilkali.sh
___________     .__.__   ____  __.      .__  .__ 
\_   _____/__  _|__|  | |    |/ _|____  |  | |__|
 |    __)_\  \/ /  |  | |      < \__  \ |  | |  |
 |        \\   /|  |  |_|    |  \ / __ \|  |_|  |
/_______  / \_/ |__|____/____|__ (____  /____/__|
        \/                      \/    \/         
                                By YoruYagami

Menu options marked with * do not have submenus (direct installation)

 Select an option from menu:


Key      Menu Option:
---      -------------------------
 1    -  Command and Control Frameworks
 2    -  Reconnaissance
 3    -  Phishing
 4    -  Vulnerability Scanners
 5    -  File Trasferer tools
 6*   -  Ghostpack Compiled Binaries
 7    -  Evasion Tools
 8    -  Windows Privilege Escaltion Tools
 9    -  Linux Privilege Escaltion Tools
 10*  -  Web Application / Bug Bounty Tools
 11   -  API Penenetration Testing Tools
 12   -  Mobile Application Penetration Testing Tools
 13   -  Reporting

 A*   -  Everything         Install all tools provided by the script
 B*   -  RedTeam            Install all tools from  2 -> 9
 C*   -  AppSec             Install all tools from 10 -> 12
 D*   -  Project Discovery  Install/Update all Project Discovery Tools

 99  -  Quit

Choose an option:
```

## Installation
```bash
  git clone https://github.com/YoruYagami/Evilkali.git
  cd Evilkali
  chmod +x ./evilkali.sh
  sudo ./evilkali.sh
```

Following the list of tools that can be installed:

- C2 Framework
  - Villain
  - Covenant
  - AM0N-Eye
  - Havoc Framework
  - Sliver Framework
  - pwncat-cs
- Reconnaisance
  - PowerView
  - PowerView-Dev
  - ADModule
  - bloodhound
  - Invoke-Portscan
  - SharpHound
- Vulnerability scanners
  - linwinpwn
- Phishing
  - evilginx2
  - gophish
  - PyPhisher
- File Transfer
  - HFS
  - netcat (nc.exe)
  - updog
- Evasion
  - freeze
  - Shellter
  - invisi_shell
- Windows Privilege Escalation Tools
  - PowerUp
  - PowerUpSQL
  - Get-System
  - PrivescCheck
  - winPEASany_ofs
- Ghostpack-CompiledBinaries
  - Certify.exe
  - Koh.exe
  - LockLess.exe
  - RestrictedAdmin.exe
  - Rubeus.exe
  - SafetyKatz.exe
  - Seatbelt.exe
  - SharpChrome.exe
  - SharpDPAPI.exe
  - SharpDump.exe
  - SharpRoast.exe
  - SharpUp.exe
  - SharpWMI.exe
- Linux Privilege Escalation Tools
  - LinEnum
  - linPEAS
  - lse (Linux Smart Enumeration)
- Web Application / Bug Bounty Tools
  - httprobe
  - amass
  - gobuster
  - subfinder
  - assetfinder
  - ffuf
  - gf
  - meg
  - waybackurls
  - subzy
  - asnmap
  - jsleak
  - mapcidr
  - dnsx
  - gospider
  - wpscan
  - CRLFuzz
  - uncover
  - dalfox
  - GoLinkFinder
  - hakrawler
  - csprecon
  - gotator
  - osmedeus
  - shuffledns
  - socialhunter
  - getJS
  - parshu
  - kxss
  - anew 
  - gau 
  - qsreplace
  - smap
  - NucleiFuzzer
  - SSTImap
  - paramspider
  - XSStrike
- API Penetration Testing Tools
  - mitmproxy2swagger
  - postman
  - jwt tool
  - kiterunner
  - arjun
- Mobile App Penetration Testing Tools
  - aapt
  - apktool
  - adb
  - apksigner
  - zipalign
  - wkhtmltopdf
  - default-jdk
  - jadx
  - apkleaks
  - Mobile-Security-Framework-MobSF
- Reporting
  - pwndoc
  - ghostwriter
  - OSCP-Reporting
