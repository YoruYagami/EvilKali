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

# Ask the user if they want to enable tmux auto-start
read -p "Do you want to enable tmux auto-start? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ENABLE_TMUX=true
else
    ENABLE_TMUX=false
fi

# Detect user's default shell
DEFAULT_SHELL=$(basename "$SHELL")

# Select the configuration file based on the default shell
if [ "$DEFAULT_SHELL" == "bash" ]; then
    CONFIG_FILE="$HOME/.bashrc"
elif [ "$DEFAULT_SHELL" == "zsh" ]; then
    CONFIG_FILE="$HOME/.zshrc"
else
    echo -e "${RED}Unsupported shell. This script only supports Bash and Zsh.${NC}"
    exit 1
fi

# Check if the tmux command is already present in the configuration file
if ! grep -q "if \[ \"\$TMUX\" = \"\" \]; then tmux; fi" "$CONFIG_FILE"; then
    # Add the command to automatically start tmux when launching the terminal
    if [ "$ENABLE_TMUX" = true ]; then
        echo -e "\n# Automatically start tmux when launching the terminal\nif [ \"\$TMUX\" = \"\" ]; then tmux; fi" >> "$CONFIG_FILE"
        echo -e "Command added to ${BLUE}$CONFIG_FILE${NC} to automatically start tmux."
    else
        echo -e "Skipping auto-start of tmux."
    fi
else
    echo -e "The command to automatically start tmux is already present in ${BLUE}$CONFIG_FILE${NC}."
fi

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

# Create directories
create_dir '/opt/tools'
create_dir '/opt/tools/C2'
create_dir '/opt/tools/phishing'
create_dir '/opt/tools/impacket'
create_dir '/opt/tools/exploits'
create_dir '/opt/tools/windows'
create_dir '/opt/tools/reporting'

# Prompt user to upgrade system first
read -p "Do you want to update/upgrade the system first? (y/n)" -n 1 -r
echo ''
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo apt update -y && sudo apt -y full-upgrade -y && sudo apt -y dist-upgrade -y && sudo apt autoremove -y && sudo apt clean -y
fi

# Downloading tools
echo -e "${GREEN}Downloading tools...${NC}"

# Requirements
sudo apt install python3 git unzip php openssh-client golang-go -y

# Command and Control
sudo git clone 'https://github.com/t3l3machus/Villain.git' '/opt/tools/C2/Villain'
sudo git clone '--recurse-submodules https://github.com/cobbr/Covenant' '/opt/tools/C2/Covenant'
sudo git clone 'https://github.com/momika233/AM0N-Eye.git' '/opt/tools/C2/AM0N-Eye'
sudo git clone 'https://github.com/HavocFramework/Havoc.git' '/opt/tools/C2/Havoc'
curl https://sliver.sh/install|sudo bash
sudo pip3 install pwncat-cs

# Reconnaisance
cp '/usr/share/windows-resources/powersploit/Recon/PowerView.ps1 /opt/tools/windows/PowerView.ps1'
cp '/usr/share/windows-resources/powersploit/Recon/Invoke-Portscan.ps1 /opt/tools/windows/Invoke-Portscan.ps1'
sudo wget -q 'https://github.com/BloodHoundAD/SharpHound/releases/download/v1.1.0/SharpHound-v1.1.0.zip' -O '/opt/tools/windows/SharpHound.zip'
sudo wget -q 'https://raw.githubusercontent.com/lucky-luk3/ActiveDirectory/master/PowerView-Dev.ps1' -O '/opt/tools/windows/PowerView-Dev.ps1'
sudo git clone 'https://github.com/samratashok/ADModule.git' '/opt/tools/windows/ADModule'
sudo apt install bloodhound -y

# Vulnerability Scanners
sudo git clone 'https://github.com/lefayjey/linWinPwn.git' '/opt/tools/linWinPwn'

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

sudo wget -q 'https://github.com/ropnop/go-windapsearch/releases/latest/download/windapsearch-linux-amd64' -O '/opt/tools/impacket/windapsearch'
sudo wget -q 'https://github.com/ropnop/kerbrute/releases/latest/download/kerbrute_linux_amd64' -O '/opt/tools/impacket/kerbrute'
sudo wget -q 'https://raw.githubusercontent.com/cddmp/enum4linux-ng/master/enum4linux-ng.py' -O '/opt/tools/impacket/enum4linux-ng.py'
sudo wget -q 'https://raw.githubusercontent.com/Bdenneu/CVE-2022-33679/main/CVE-2022-33679.py' -O '/opt/tools/impacket/CVE-2022-33679.py'
sudo wget -q 'https://raw.githubusercontent.com/layer8secure/SilentHound/main/silenthound.py' -O '/opt/tools/impacket/silenthound.py'
sudo wget -q 'https://raw.githubusercontent.com/ShutdownRepo/targetedKerberoast/main/targetedKerberoast.py' -O '/opt/tools/impacket/targetedKerberoast.py'
sudo wget -q 'https://github.com/login-securite/DonPAPI/archive/master.zip' -O '/opt/tools/impacket/DonPAPI.zip'

# Changing permissions
sudo chmod +x '/opt/tools/impacket/windapsearch'
sudo chmod +x '/opt/tools/impacket/kerbrute'
sudo chmod +x '/opt/tools/impacket/enum4linux-ng.py'
sudo chmod +x '/opt/tools/impacket/CVE-2022-33679.py'
sudo chmod +x '/opt/tools/impacket/silenthound.py'
sudo chmod +x '/opt/tools/impacket/targetedKerberoast.py'
sudo chmod +x '/opt/tools/impacket/DonPAPI-main/DonPAPI.py'

# Pishing
sudo apt install evilginx2 -y
sudo git clone 'https://github.com/gophish/gophish.git' '/opt/tools/phishing/gophish'
sudo git clone 'https://github.com/KasRoudra/PyPhisher.git' '/opt/tools/phishing/PyPhisher'
sudo pip3 install -r /opt/tools/phishing/PyPhisher/files/requirements.txt

# File Trasfer
sudo wget -q 'https://github.com/rejetto/hfs/releases/download/v0.44.0/hfs-windows.zip' -O '/opt/tools/windows/hfs-windows.zip'

# Exploits
sudo git clone 'https://github.com/risksense/zerologon.git' '/opt/tools/exploits/zerologon'
sudo git clone 'https://github.com/topotam/PetitPotam.git' '/opt/tools/exploits/PetitPotam'

# Evasion
sudo git clone 'https://github.com/OmerYa/Invisi-Shell.git' '/opt/tools/windows/Invisi-Shell'
sudo git clone 'https://github.com/optiv/Freeze' '/opt/tools/windows/Freeze'

# Privilege Escalation
cp '/usr/share/windows-resources/powersploit/Privesc/PowerUp.ps1' '/opt/tools/windows/PowerUp.ps1'
cp '/usr/share/windows-resources/powersploit/Privesc/Get-System.ps1' '/opt/tools/windows/Get-System.ps1'
sudo wget -q 'https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASany_ofs.exe' -O '/opt/tools/windows/winPEASany_ofs.exe'
sudo wget -q 'https://raw.githubusercontent.com/NetSPI/PowerUpSQL/master/PowerUpSQL.ps1' -O '/opt/tools/windows/PowerUpSQL.ps1'
sudo wget -q 'https://raw.githubusercontent.com/NetSPI/PowerUpSQL/master/PowerUpSQL.psd1' -O '/opt/tools/windows/PowerUpSQL.psd1'
sudo wget -q 'https://raw.githubusercontent.com/NetSPI/PowerUpSQL/master/PowerUpSQL.psm1' -O '/opt/tools/windows/PowerUpSQL.psm1'
sudo wget -q 'https://raw.githubusercontent.com/itm4n/PrivescCheck/master/PrivescCheck.ps1' -O '/opt/tools/windows/PrivescCheck.ps1'

# Reporting
sudo git clone 'https://github.com/pwndoc/pwndoc.git' '/opt/tools/reporting/pwndoc'
sudo git clone 'https://github.com/Syslifters/OSCP-Reporting' '/opt/tools/reporting/OSCP-Reporting'

# Misc
sudo pip3 install updog
sudo apt install neovim -y
cp '/usr/share/windows-resources/mimikatz/x64/mimikatz.exe' '/opt/tools/windows/mimikatz64.exe'
cp '/usr/share/windows-resources/mimikatz/Win32/mimikatz.exe' '/opt/tools/windows/mimikatz32.exe'
cp '/usr/share/windows-binaries/nc.exe' '/opt/tools/windows/nc.exe'
cp '/usr/share/windows-binaries/wget.exe' '/opt/tools/windows/wget.exe'
cp '/usr/share/windows-resources/powersploit/Exfiltration/Invoke-Mimikatz.ps1' '/opt/tools/windows/Invoke-Mimikatz.ps1'
sudo git clone 'https://github.com/r3motecontrol/Ghostpack-CompiledBinaries.git' '/opt/tools/windows/GhostPack'
sudo wget -q 'https://raw.githubusercontent.com/YoruYagami/RepoUpdater/main/repoupdater.sh' -O '/usr/local/bin/repoupdater'
sudo wget -q 'https://github.com/RythmStick/AMSITrigger/releases/download/v3/AmsiTrigger_x64.exe' -O '/opt/tools/windows/AmsiTrigger_x64.exe'
sudo wget -q 'https://github.com/RythmStick/AMSITrigger/releases/download/v3/AmsiTrigger_x86.exe' -O '/opt/tools/windows/AmsiTrigger_x86.exe'
sudo wget -q 'https://raw.githubusercontent.com/samratashok/nishang/master/Shells/Invoke-PowerShellTcp.ps1' -O '/opt/tools/windows/Invoke-PowerShellTcp.ps1'
sudo wget -q 'https://raw.githubusercontent.com/samratashok/nishang/master/Backdoors/Set-RemotePSRemoting.ps1' -O '/opt/tools/windows/Set-RemotePSRemoting.ps1'
sudo wget -q 'https://raw.githubusercontent.com/besimorhino/powercat/master/powercat.ps1' -O '/opt/tools/windows/powercat.ps1'
sudo wget -q 'https://github.com/gentilkiwi/kekeo/releases/download/2.2.0-20211214/kekeo.zip' -O '/opt/tools/windows/kekeo.zip'
sudo chmod +x '/usr/local/bin/repoupdater'

# Unzipping
sudo unzip -q '/opt/tools/windows/SharpHound.zip' -d '/opt/tools/windows/SharpHound'
sudo unzip -q '/opt/tools/windows/kekeo.zip' -d '/opt/tools/windows/kekeo'
sudo unzip -q '/opt/tools/windows/hfs-windows.zip' -d '/opt/tools/windows/hfs-windows'
sudo unzip -o '/opt/tools/impacket/DonPAPI.zip' -d '/opt/tools/impacket/DonPAPI'

# Removing unnecessary files
sudo rm -rf '/opt/tools/windows/hfs-windows/plugins/'
sudo rm -rf '/opt/tools/windows/SharpHound.zip'
sudo rm -rf '/opt/tools/windows/kekeo.zip'
sudo rm -rf '/opt/tools/windows/hfs-windows.zip'

echo -e "${GREEN}All downloads completed.${NC}"
