<h1 align="center">
  <br>
  <a href=""><img src="https://github.com/YoruYagami/EvilKali/assets/70035442/3d755c49-17fd-42a0-9d9c-8302556c8fbc" alt="" width="500" height="500"></a>
  <br>
  <img src="https://img.shields.io/badge/Maintained%3F-Yes-23a82c">
  <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/YoruYagami/Evilkali">
  <img src="https://img.shields.io/badge/Developed%20for-kali%20linux-blueviolet">
</h1>

# EvilKali
EvilKali is a Bash script that automates the download and installation of various penetration testing tools. 
The purpose of the script is to create an environment with all the necessary tools for Red Teaming and Application Security.

## Usage
```
./evilkali.sh

___________     .__.__   ____  __.      .__  .__ 
\_   _____/__  _|__|  | |    |/ _|____  |  | |__|
 |    __)_\  \/ /  |  | |      < \__  \ |  | |  |
 |        \\   /|  |  |_|    |  \ / __ \|  |_|  |
/_______  / \_/ |__|____/____|__ (____  /____/__|
        \/                      \/    \/         
                                By YoruYagami

Menu options marked with * do not have submenus (direct installation)

 Select an option from the menu:


Key      Menu Option:
---      -------------------------
 1    -  Red Team Operations
 2    -  Application Security
 3    -  Reporting
 4    -  Miscellaneous

 0  -  Quit

Choose an option:
```

## Installation
```bash
  git clone https://github.com/YoruYagami/Evilkali.git
  cd Evilkali
  chmod +x ./evilkali.sh
  ./evilkali.sh
```

## Tools List:
```
├─ Active Directory
│   ├─ C2 Framework
│   │   ├─ Powershell-Empire + Starkiller
│   │   ├─ Havoc Framework
│   │   ├─ AM0N-Eye
│   │   ├─ Sliver Framework
│   │   └─ pwncat-cs
│   ├─ Windows Active Directory Arsenal (direct install)
│   │   ├─ pipx
│   │   ├─ nmap-formatter
│   │   ├─ AD-Miner
│   │   ├─ sprayhound
│   │   ├─ ldapdomaindump
│   │   ├─ NetExec
│   │   ├─ impacket
│   │   ├─ adidnsdump
│   │   ├─ certi
│   │   ├─ Certipy
│   │   ├─ bloodhound.py
│   │   ├─ ldeep
│   │   ├─ pre2k
│   │   ├─ certsync
│   │   ├─ hekatomb
│   │   ├─ MANSPIDER
│   │   ├─ Coercer
│   │   ├─ bloodyAD
│   │   ├─ DonPAPI
│   │   ├─ rdwatool
│   │   ├─ krbjack
│   │   ├─ windapsearch
│   │   ├─ kerbrute
│   │   ├─ enum4linux-ng.py
│   │   ├─ CVE-2022-33679.py
│   │   ├─ silenthound.py
│   │   ├─ targetedKerberoast.py
│   │   ├─ FindUncommonShares.py
│   │   ├─ ExtractBitlockerKeys.py
│   │   ├─ ldapconsole.py
│   │   ├─ pyLDAPmonitor.py
│   │   ├─ LDAPWordlistHarvester.py
│   │   ├─ aced.zip
│   │   ├─ sccmhunter.zip
│   │   ├─ ldapper.py
│   │   ├─ utilities.py
│   │   ├─ queries.py
│   │   ├─ ldap_connector.py
│   │   ├─ WinPwn.exe
│   │   ├─ WinPwn.ps1
│   │   ├─ linWinPwn
│   │   ├─ PowerView.ps1
│   │   ├─ InvokeSessionHunter.ps1
│   │   ├─ ADModule
│   │   ├─ bloodhound
│   │   ├─ Invoke-Portscan.ps1
│   │   ├─ SharpHound
│   │   ├─ Invoke-ADEnum.ps1
│   │   ├─ adPEAS.ps1
│   │   ├─ adPEAS-Light.ps1
│   │   ├─ nc.exe (copiato)
│   │   ├─ updog
│   │   ├─ HFS.exe
│   │   ├─ Certify.exe
│   │   ├─ Koh.exe
│   │   ├─ LockLess.exe
│   │   ├─ RestrictedAdmin.exe
│   │   ├─ Rubeus.exe
│   │   ├─ SafetyKatz.exe
│   │   ├─ Seatbelt.exe
│   │   ├─ SharpChrome.exe
│   │   ├─ SharpDPAPI.exe
│   │   ├─ SharpDump.exe
│   │   ├─ SharpRoast.exe
│   │   ├─ SharpUp.exe
│   │   ├─ SharpWMI.exe
│   │   ├─ LaZagne.exe
│   │   ├─ PsMapExec.ps1
│   │   └─ lsassy
│   ├─ Phishing
│   │   ├─ evilginx2
│   │   ├─ gophish
│   │   └─ PyPhisher
│   ├─ Windows Privilege Escalation Tools
│   │   ├─ PowerUp
│   │   ├─ PowerUpSQL
│   │   ├─ Get-System
│   │   ├─ PrivescCheck
│   │   └─ winPEAS (All Versions)
│   └─ Linux Privilege Escalation Tools
│       ├─ LinEnum
│       ├─ linPEAS
│       ├─ AutoSUID
│       ├─ GTFONow
│       ├─ lse (Linux Smart Enumeration)
│       └─ pspy32/64
├─ Application Security
│   ├─ Web Application / Bug Bounty Tools
│   │   ├─ PDTM (Install all Project Discovery Tools)
│   │   ├─ Axiom
│   │   ├─ httprobe
│   │   ├─ amass
│   │   ├─ gobuster
│   │   ├─ subfinder
│   │   ├─ assetfinder
│   │   ├─ ffuf
│   │   ├─ gf
│   │   ├─ meg
│   │   ├─ waybackurls
│   │   ├─ subzy
│   │   ├─ asnmap
│   │   ├─ jsleak
│   │   ├─ mapcidr
│   │   ├─ dnsx
│   │   ├─ gospider
│   │   ├─ wpscan
│   │   ├─ CRLFuzz
│   │   ├─ corscanner
│   │   ├─ uncover
│   │   ├─ dalfox
│   │   ├─ GoLinkFinder
│   │   ├─ hakrawler
│   │   ├─ csprecon
│   │   ├─ gotator
│   │   ├─ osmedeus
│   │   ├─ shuffledns
│   │   ├─ socialhunter
│   │   ├─ getJS
│   │   ├─ parshu
│   │   ├─ anew 
│   │   ├─ gau 
│   │   ├─ qsreplace
│   │   ├─ SSTImap
│   │   ├─ SSRFmap
│   │   ├─ EyeWitness
│   │   ├─ headerpwn
│   │   ├─ OpenRedireX
│   │   ├─ paramspider
│   │   ├─ smap
│   │   ├─ userefuzz
│   │   └─ nomore403
│   ├─ API Penetration Testing Tools
│   │   ├─ mitmproxy2swagger
│   │   ├─ postman
│   │   ├─ jwt tool
│   │   └─ kiterunner
│   └─ Mobile App Penetration Testing Tools
│       ├─ aapt
│       ├─ apktool
│       ├─ adb
│       ├─ apksigner
│       ├─ zipalign
│       ├─ wkhtmltopdf
│       ├─ default-jdk
│       ├─ jadx
│       ├─ apkleaks
│       └─ Mobile-Security-Framework-MobSF
├─ Reporting
│   ├─ pwndoc
│   ├─ ghostwriter
│   └─ Sysreport
└─ Miscellaneous
    ├─ Pimpmykali
    ├─ Visual Studio Code
    ├─ SploitScan
    └─ Orange-Cyberdefense/arsenal

```
