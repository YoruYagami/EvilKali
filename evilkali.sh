#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
NC='\033[0m'

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to create directories
create_dir() {
  dir_path=$1
  dir_name=$(basename $dir_path)

  if [ ! -d "$dir_path" ]; then
    echo "Creating '$dir_name' directory..."
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
  chmod +x $file_path
}

# Check if 'git' and 'unzip' are installed
if ! command_exists git || ! command_exists unzip; then
  echo "Error: 'git' and 'unzip' are required to run this script."
  exit 1
fi

# Create directories
create_dir "/opt/tools"
create_dir "/opt/tools/C2"
create_dir "/opt/tools/impacket"
create_dir "/opt/tools/windows"

# Downloading tools
echo -e "${GREEN}Downloading tools...${NC}"

# C2 Framework
download_git_tool "https://github.com/t3l3machus/Villain.git" "/opt/tools/C2/Villain"
download_git_tool "https://github.com/momika233/AM0N-Eye.git" "/opt/tools/C2/AM0N-Eye"

# Vulnerability Scanners
download_git_tool "https://github.com/lefayjey/linWinPwn.git" "/opt/tools/linWinPwn"

# Downloading and installing impacket tools
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

download_wget_tool "https://github.com/ropnop/go-windapsearch/releases/latest/download/windapsearch-linux-amd64" "/opt/tools/impacket/windapsearch"
download_wget_tool "https://github.com/ropnop/kerbrute/releases/latest/download/kerbrute_linux_amd64" "/opt/tools/impacket/kerbrute"
download_wget_tool "https://raw.githubusercontent.com/cddmp/enum4linux-ng/master/enum4linux-ng.py" "/opt/tools/impacket/enum4linux-ng.py"
download_wget_tool "https://raw.githubusercontent.com/Bdenneu/CVE-2022-33679/main/CVE-2022-33679.py" "/opt/tools/impacket/CVE-2022-33679.py"
download_wget_tool "https://raw.githubusercontent.com/layer8secure/SilentHound/main/silenthound.py" "/opt/tools/impacket/silenthound.py"
download_wget_tool "https://raw.githubusercontent.com/ShutdownRepo/targetedKerberoast/main/targetedKerberoast.py" "/opt/tools/impacket/targetedKerberoast.py"
download_wget_tool "https://github.com/login-securite/DonPAPI/archive/master.zip" "/opt/tools/DonPAPI.zip"

# Changing permissions for impacket tools
change_permissions "/opt/tools/impacket/windapsearch"
change_permissions "/opt/tools/impacket/kerbrute"
change_permissions "/opt/tools/impacket/enum4linux-ng.py"
change_permissions "/opt/tools/impacket/CVE-2022-33679.py"
change_permissions "/opt/tools/impacket/silenthound.py"
change_permissions "/opt/tools/impacket/targetedKerberoast.py"
unzip -o "/opt/tools/impacket/DonPAPI.zip" -d $scripts_dir
change_permissions "/opt/tools/impacket/DonPAPI-main/DonPAPI.py"

# Reconnaisance
download_wget_tool "https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Recon/PowerView.ps1" "/opt/tools/windows/PowerView.ps1"
download_wget_tool "https://github.com/BloodHoundAD/SharpHound/releases/download/v1.1.0/SharpHound-v1.1.0.zip" "/opt/tools/windows/SharpHound.zip"
download_wget_tool "https://raw.githubusercontent.com/lucky-luk3/ActiveDirectory/master/PowerView-Dev.ps1" "/opt/tools/windows/PowerView-Dev.ps1"
download_git_tool "https://github.com/samratashok/ADModule.git" "/opt/tools/windows/ADModule"

# Privilege Escalation
download_wget_tool "https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Privesc/PowerUp.ps1" "/opt/tools/windowws/PowerUp.ps1"

# Evasion
download_git_tool "https://github.com/OmerYa/Invisi-Shell.git" "/opt/tools/windows/Invisi-Shell"
download_git_tool "https://github.com/optiv/Freeze" "/opt/tools/windows/Freeze"

# Misc
pip3 install updog
download_wget_tool "https://github.com/gentilkiwi/kekeo/releases/download/2.2.0-20211214/kekeo.zip" "/opt/tools/windows/kekeo.zip"
download_wget_tool "https://github.com/gentilkiwi/mimikatz/releases/download/2.2.0-20220919/mimikatz_trunk.zip" "/opt/tools/windows/mimikatz.zip"
download_wget_tool "https://raw.githubusercontent.com/besimorhino/powercat/master/powercat.ps1" "/opt/tools/windows/powercat.ps1"

# Unzipping
unzip -q /opt/tools/windows/mimikatz.zip -d /opt/tools/windows/mimikatz
unzip -q /opt/tools/windows/SharpHound.zip -d /opt/tools/windows/SharpHound
unzip -q /opt/tools/windows/kekeo.zip -d /opt/tools/windows/kekeo

echo -e "${GREEN}All downloads completed.${NC}"
