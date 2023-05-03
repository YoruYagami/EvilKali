# EvilKali

This is a Bash script that automates the download and installation of various penetration testing tools. 
The purpose of the script is to create an environment with all the necessary tools for red teaming. The script Place all the tools under the following directories: 

 - /opt/tools
 - /opt/tools/C2
 - /opt/tools/impacket
 - /opt/tools/phishing
 - /opt/tools/exploits
 - /opt/tools/windows
 - /opt/tools/reporting

Below is the list of tools that will be downloaded and installed

### Command and Control
 - Villain
 - Covenant
 - AM0N-Eye
 - pwncat-cs
 
 ### Reconnaisance
 - PowerView.ps1
 - Invoke-Portscan.ps1
 - SharpHound
 - PowerView-Dev.ps1
 - ADModule
 
### Vulnerability Scanners
 - linWinPwn

### Impacket
 - ldapdomaindump
 - CrackMapExec
 - impacket
 - adidnsdump
 - certi
 - Certipy
 - BloodHound.py
 - ldeep
 - pre2k
 - certsync
 - hekatomb
 - windapsearch
 - kerbrute
 - enum4linux-ng.py
 - CVE-2022-33679.py
 - silenthound.py
 - targetedKerberoast.py
 - DonPAPI
 
### Pishing
 - evilginx2
 - gophish
 - PyPhisher

### File Trasfer
 - HFS (HTTP File Server)

### Exploits
 - zerologon
 - PetitPotam

### Evasion
 - Invisi-Shell
 - Freeze

### Privilege Escalation
 - PowerUp.ps1
 - Get-System.ps1
 - winPEASany_ofs.exe
 - PowerUpSQL
 - PrivescCheck.ps1
 
 ### Misc
 - Ghostpack CompiledBinaries
 - updog
 - mimikatz64.exe
 - mimikatz32.exe
 - nc.exe
 - wget.exe
 - Invoke-Mimikatz.ps1
 - AmsiTrigger_x64.exe
 - AmsiTrigger_x86.exe
 - Invoke-PowerShellTcp.ps1
 - Set-RemotePSRemoting.ps1
 - powercat.ps1
 - repoupdater
 - kekeo

### Reporting
 - pwndoc

## Run Locally

Execute directly on kali

```bash
curl -s https://raw.githubusercontent.com/YoruYagami/EvilKali/main/evilkali.sh | bash
```

Clone the project

```bash
  git clone https://github.com/YoruYagami/EvilKali.git
```

Go to the project directory

```bash
  cd EvilKali
```

Install dependencies

```bash
  chmod +x ./evilkali.sh
```

execute 

```bash
./evilkali.sh
```

## Roadmap

- ability to exclude tools before starting with the bulk download and installation

- Final notification with list of successful/failed downloads

