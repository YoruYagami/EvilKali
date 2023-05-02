# EvilKali

This is a Bash script that automates the download and installation of various penetration testing tools. The script checks for the availability of 'git' and 'unzip' commands and creates directories under /opt/tools.

Below is the list of tools that will be downloaded and installed

### C2 Framework
- AM0N-Eye
- Villain

### Vulnerability Scanners
- linWinPwn

### Impacket
- ldapdomaindump
- CrackMapExec
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

### Reconnaissance
- PowerView.ps1
- PowerView-Dev.ps1
- SharpHound

### Privilege Escalation
- PowerUp.ps1

### Evasion
- Invisi-Shell

### Misc
- kekeo
- mimikatz
- powercat
## Run Locally

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

