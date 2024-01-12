<h1 align="center">
  <br>
  <a href=""><img src="https://github.com/YoruYagami/EvilKali/assets/70035442/569bafd8-a412-43ed-a875-02dbdced5347" alt="" width="500" height="500"></a>
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
├─ Red Team Operations
│   ├─ C2 Framework
│   │   ├─ Villain
│   │   ├─ Covenant
│   │   ├─ Havoc Framework
│   │   ├─ AM0N-Eye
│   │   ├─ Sliver Framework
│   │   └─ pwncat-cs
│   ├─ Windows-Resources
│   │   ├─ rustup
│   │   ├─ pipx
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
│   │   ├─ ADModule
│   │   ├─ bloodhound
│   │   ├─ knowsmore
│   │   ├─ Invoke-Portscan.ps1
│   │   ├─ SharpHound
│   │   ├─ Invoke-ADEnum.ps1
│   │   ├─ adPEAS.ps1
│   │   ├─ nc.exe (copiato)
│   │   ├─ updog
│   │   ├─ jq
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
│   │   └─ LaZagne.exe
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
│   │   ├─ kxss
│   │   ├─ Gxss
│   │   ├─ anew 
│   │   ├─ gau 
│   │   ├─ qsreplace
│   │   ├─ SSTImap
│   │   ├─ SSRFmap
│   │   ├─ headerpwn
│   │   ├─ OpenRedireX
│   │   ├─ ryder
│   │   ├─ paramspider
│   │   ├─ smap
│   │   ├─ userefuzz
│   │   └─ dontgo403
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
    ├─ xct/kali-clean
    └─ Orange-Cyberdefense/arsenal

```
