#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
NC='\033[0m'

# Check if the script get executed with sudo
if [ $(id -u) -ne 0 ]; then
    echo 'This script must be run as root. Please run with sudo.'
    exit 1
fi

# Function to check if a command is available
command_exists() {
  command -v '$1' >/dev/null 2>&1
}

# Function to create directories
create_dir() {
  dir_path=$1
  dir_name=$(basename $dir_path)

  if [ ! -d '$dir_path' ]; then
    echo 'Creating '$dir_name' directory...'
    sudo mkdir -p $dir_path
    sudo chown $USER:$USER $dir_path
  fi
}

# Function to download tools with git
download_git_tool() {
  repo_url=$1
  dest_dir=$2
  sudo git clone $repo_url $dest_dir
}

# Function to download tools with wget
download_wget_tool() {
  url=$1
  dest_path=$2
  sudo wget -q $url -O $dest_path
}

# Function to change permissions for a file
change_permissions() {
  file_path=$1
  sudo chmod +x $file_path
}

# Function to make copy of a file
copy() {
    system_path=$1
    dest_path=$2
    cp $system_path $dest_path
}

# Create directories
create_dir '/opt/tools'
create_dir '/opt/tools/C2'
create_dir '/opt/tools/phishing'
create_dir '/opt/tools/impacket'
create_dir '/opt/tools/exploits'
create_dir '/opt/tools/windows'
create_dir '/opt/tools/reporting'

# Prompt user to upgrade system first
read -p 'Do you want to upgrade the system first? (y/n)' -n 1 -r
echo ''
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo apt update -y && sudo apt upgrade -y
fi

# Downloading tools
echo -e '${GREEN}Downloading tools...${NC}'

# Requirements
sudo apt install python3 git unzip php openssh-client golang-go -y

# Command and Control
download_git_tool 'https://github.com/t3l3machus/Villain.git' '/opt/tools/C2/Villain'
download_git_tool '--recurse-submodules https://github.com/cobbr/Covenant' '/opt/tools/C2/Covenant'
download_git_tool 'https://github.com/momika233/AM0N-Eye.git' '/opt/tools/C2/AM0N-Eye'
sudo pip3 install pwncat-cs

# Reconnaisance
copy '/usr/share/windows-resources/powersploit/Recon/PowerView.ps1 /opt/tools/windows/PowerView.ps1'
copy '/usr/share/windows-resources/powersploit/Recon/Invoke-Portscan.ps1 /opt/tools/windows/Invoke-Portscan.ps1'
download_wget_tool 'https://github.com/BloodHoundAD/SharpHound/releases/download/v1.1.0/SharpHound-v1.1.0.zip' '/opt/tools/windows/SharpHound.zip'
download_wget_tool 'https://raw.githubusercontent.com/lucky-luk3/ActiveDirectory/master/PowerView-Dev.ps1' '/opt/tools/windows/PowerView-Dev.ps1'
download_git_tool 'https://github.com/samratashok/ADModule.git' '/opt/tools/windows/ADModule'
sudo apt install bloodhound -y

# Vulnerability Scanners
download_git_tool 'https://github.com/lefayjey/linWinPwn.git' '/opt/tools/linWinPwn'

# Impacket
pipx ensurepath
pipx install git+https://github.com/dirkjanm/ldapdomaindump.git --force
pipx install git+https://github.com/Porchetta-Industries/CrackMapExec.git --force
pipx install git+https://github.com/ThePorgs/impacket.git --force
pipx install git+https://github.com/dirkjanm/adidnsdump.git --force
pipx install git+https://github.com/zer1t0/certi.git --force
pipx install git+https://github.com/ly4k/Certipy.git --force
pipx install git+https://github.com/fox-it/BloodHound.py.git --force
pipx install git+https://github.com/franc-pentest/ldeep.git --force
pipx install git+https://github.com/garrettfoster13/pre2k.git --force
pipx install git+https://github.com/zblurx/certsync.git --force
pipx install hekatomb --force

download_wget_tool 'https://github.com/ropnop/go-windapsearch/releases/latest/download/windapsearch-linux-amd64' '/opt/tools/impacket/windapsearch'
download_wget_tool 'https://github.com/ropnop/kerbrute/releases/latest/download/kerbrute_linux_amd64' '/opt/tools/impacket/kerbrute'
download_wget_tool 'https://raw.githubusercontent.com/cddmp/enum4linux-ng/master/enum4linux-ng.py' '/opt/tools/impacket/enum4linux-ng.py'
download_wget_tool 'https://raw.githubusercontent.com/Bdenneu/CVE-2022-33679/main/CVE-2022-33679.py' '/opt/tools/impacket/CVE-2022-33679.py'
download_wget_tool 'https://raw.githubusercontent.com/layer8secure/SilentHound/main/silenthound.py' '/opt/tools/impacket/silenthound.py'
download_wget_tool 'https://raw.githubusercontent.com/ShutdownRepo/targetedKerberoast/main/targetedKerberoast.py' '/opt/tools/impacket/targetedKerberoast.py'
download_wget_tool 'https://github.com/login-securite/DonPAPI/archive/master.zip' '/opt/tools/impacket/DonPAPI.zip'

# Changing permissions for impacket tools
change_permissions '/opt/tools/impacket/windapsearch'
change_permissions '/opt/tools/impacket/kerbrute'
change_permissions '/opt/tools/impacket/enum4linux-ng.py'
change_permissions '/opt/tools/impacket/CVE-2022-33679.py'
change_permissions '/opt/tools/impacket/silenthound.py'
change_permissions '/opt/tools/impacket/targetedKerberoast.py'
change_permissions '/opt/tools/impacket/DonPAPI-main/DonPAPI.py'
sudo unzip -o '/opt/tools/impacket/DonPAPI.zip' -d /opt/tools/impacket/DonPAPI

# Pishing
sudo apt install evilginx2 -y
download_git_tool 'https://github.com/gophish/gophish.git' '/opt/tools/phishing/gophish'
download_git_tool 'https://github.com/KasRoudra/PyPhisher.git' '/opt/tools/phishing/PyPhisher'
sudo pip3 install -r /opt/tools/phishing/PyPhisher/files/requirements.txt

# File Trasfer
dowload_wget_tool 'https://github.com/rejetto/hfs/releases/download/v0.44.0/hfs-windows.zip' '/opt/tools/windows/hfs-windows.zip'

# Exploits
download_git_tool 'https://github.com/risksense/zerologon.git' '/opt/tools/exploits/zerologon'
download_git_tool 'https://github.com/topotam/PetitPotam.git' '/opt/tools/exploits/PetitPotam'

# Evasion
download_git_tool 'https://github.com/OmerYa/Invisi-Shell.git' '/opt/tools/windows/Invisi-Shell'
download_git_tool 'https://github.com/optiv/Freeze' '/opt/tools/windows/Freeze'

# Privilege Escalation
copy '/usr/share/windows-resources/powersploit/Privesc/PowerUp.ps1' '/opt/tools/windows/PowerUp.ps1'
copy '/usr/share/windows-resources/powersploit/Privesc/Get-System.ps1' '/opt/tools/windows/Get-System.ps1'
download_wget_tool 'https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASany_ofs.exe' '/opt/tools/windows/winPEASany_ofs.exe'
download_wget_tool 'https://raw.githubusercontent.com/NetSPI/PowerUpSQL/master/PowerUpSQL.ps1' '/opt/tools/windows/PowerUpSQL.ps1'
download_wget_tool 'https://raw.githubusercontent.com/NetSPI/PowerUpSQL/master/PowerUpSQL.psd1' '/opt/tools/windows/PowerUpSQL.psd1'
download_wget_tool 'https://raw.githubusercontent.com/NetSPI/PowerUpSQL/master/PowerUpSQL.psm1' '/opt/tools/windows/PowerUpSQL.psm1'
download_wget_tool 'https://raw.githubusercontent.com/itm4n/PrivescCheck/master/PrivescCheck.ps1' '/opt/tools/windows/PrivescCheck.ps1'

# Reporting
download_git_tool 'https://github.com/pwndoc/pwndoc.git' '/opt/tools/reporting/pwndoc'

# Misc
sudo pip3 install updog
copy '/usr/share/windows-resources/mimikatz/x64/mimikatz.exe' '/opt/tools/windows/mimikatz64.exe'
copy '/usr/share/windows-resources/mimikatz/Win32/mimikatz.exe' '/opt/tools/windows/mimikatz32.exe'
copy '/usr/share/windows-binaries/nc.exe' '/opt/tools/windows/nc.exe'
copy '/usr/share/windows-binaries/wget.exe' '/opt/tools/windows/wget.exe'
copy '/usr/share/windows-resources/powersploit/Exfiltration/Invoke-Mimikatz.ps1' '/opt/tools/windows/Invoke-Mimikatz.ps1'
download_wget_tool 'https://github.com/r3motecontrol/Ghostpack-CompiledBinaries.git' '/opt/tools/windows/'
download_wget_tool 'https://github.com/RythmStick/AMSITrigger/releases/download/v3/AmsiTrigger_x64.exe' '/opt/tools/windows/AmsiTrigger_x64.exe'
download_wget_tool 'https://github.com/RythmStick/AMSITrigger/releases/download/v3/AmsiTrigger_x86.exe' '/opt/tools/windows/AmsiTrigger_x86.exe'
download_wget_tool 'https://raw.githubusercontent.com/samratashok/nishang/master/Shells/Invoke-PowerShellTcp.ps1' '/opt/tools/windows/Invoke-PowerShellTcp.ps1'
download_wget_tool 'https://raw.githubusercontent.com/samratashok/nishang/master/Backdoors/Set-RemotePSRemoting.ps1' '/opt/tools/windows/Set-RemotePSRemoting.ps1'
download_wget_tool 'https://raw.githubusercontent.com/besimorhino/powercat/master/powercat.ps1' '/opt/tools/windows/powercat.ps1'
download_wget_tool 'https://raw.githubusercontent.com/YoruYagami/RepoUpdater/main/repoupdater.sh' '/usr/local/bin/repoupdater'
download_wget_tool 'https://github.com/gentilkiwi/kekeo/releases/download/2.2.0-20211214/kekeo.zip' '/opt/tools/windows/kekeo.zip'

# Unzipping
unzip -q /opt/tools/windows/mimikatz.zip -d /opt/tools/windows/mimikatz
unzip -q /opt/tools/windows/SharpHound.zip -d /opt/tools/windows/SharpHound
unzip -q /opt/tools/windows/kekeo.zip -d /opt/tools/windows/kekeo
unzip -q /opt/tools/windows/hfs-windows.zip -d /opt/tools/windows/hfs-windows

# Removing unnecessary files
sudo rm -rf /opt/tools/windows/hfs-windows/plugins/

echo -e '${GREEN}All downloads completed.${NC}'
