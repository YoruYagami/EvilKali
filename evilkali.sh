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
echo ""
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

# Prompt user to upgrade system first
echo ""
read -p "Do you want to update/upgrade the system first? (y/n)" -n 1 -r
echo ''
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo apt update -y && sudo apt -y full-upgrade -y && sudo apt -y dist-upgrade -y && sudo apt autoremove -y && sudo apt clean -y
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

# Requirements/Essentials
sudo apt install neovim python3 wget git unzip php openssh-client golang-go -y
sudo pip3 install updog

# --[ Command and Control ]--
function download_villain() {
    sudo mkdir -p '/opt/tools/C2'
    sudo git clone 'https://github.com/t3l3machus/Villain.git' '/opt/tools/C2/Villain'
    echo -e "${GREEN}Villain downloaded successfully.${NC}"
}

function download_covenant() {
    sudo mkdir -p '/opt/tools/C2'
    sudo git clone --recurse-submodules https://github.com/cobbr/Covenant '/opt/tools/C2/Covenant'
    echo -e "${GREEN}Covenant downloaded successfully.${NC}"
}

function download_AM0N_Eye() {
    sudo mkdir -p '/opt/tools/C2'
    sudo git clone 'https://github.com/momika233/AM0N-Eye.git' '/opt/tools/C2/AM0N-Eye'
        echo -e "${GREEN}AM0N_Eye downloaded successfully.${NC}"
}

function download_Havoc() {
    sudo mkdir -p '/opt/tools/C2'
    sudo git clone 'https://github.com/HavocFramework/Havoc.git' '/opt/tools/C2/Havoc'
    echo -e "${GREEN}Havoc Framework downloaded successfully.${NC}"
}

function install_sliver() {
    curl https://sliver.sh/install|sudo bash
    echo -e "${GREEN}Sliver installed successfully.${NC}"
}

function install_pwncat() {
    sudo pip3 install pwncat-cs
    echo -e "${GREEN}pwncat-cs installed successfully.${NC}"
}

function download_install_all_c2_tools() {
    download_villain
    download_covenant
    download_AM0N_Eye
    download_Havoc
    install_sliver
    install_pwncat
}

function command_and_control() {
    clear
    echo -e "${RED}"
    cat << "EOF"
╔═╗┌─┐┌┬┐┌┬┐┌─┐┌┐┌┌┬┐  ┌─┐┌┐┌┌┬┐  ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┬    ╔═╗┬─┐┌─┐┌┬┐┌─┐┬ ┬┌─┐┬─┐┬┌─┌─┐
║  │ │││││││├─┤│││ ││  ├─┤│││ ││  ║  │ ││││ │ ├┬┘│ ││    ╠╣ ├┬┘├─┤│││├┤ ││││ │├┬┘├┴┐└─┐
╚═╝└─┘┴ ┴┴ ┴┴ ┴┘└┘─┴┘  ┴ ┴┘└┘─┴┘  ╚═╝└─┘┘└┘ ┴ ┴└─└─┘┴─┘  ╚  ┴└─┴ ┴┴ ┴└─┘└┴┘└─┘┴└─┴ ┴└─┘
EOF
    echo ""
    echo -e "${BLUE}1. Download/Install All Tools${NC}"
    echo -e "${BLUE}2. Download Villain${NC}"
    echo -e "${BLUE}3. Download Covenant${NC}"
    echo -e "${BLUE}4. Download AM0N_Eye${NC}"
    echo -e "${BLUE}5. Download Havoc${NC}"
    echo -e "${BLUE}6. Install Sliver${NC}"
    echo -e "${BLUE}7. Install pwncat-cs${NC}"
    echo -e "${BLUE}8. Back${NC}"
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) download_install_all_c2_tools; command_and_control;;
        2) download_villain; command_and_control;;
        3) download_covenant; command_and_control;;
        4) download_AM0N_Eye; command_and_control;;
        5) download_Havoc; command_and_control;;
        6) install_Sliver; command_and_control;;
        7) install_pwncat; command_and_control;;
        8) main_menu;;
        *) echo "Invalid option"; command_and_control;;
    esac
}

# --[ Reconnaissance ]--
function get_powerview() {
    sudo mkdir -p '/opt/tools/windows'
    sudo cp '/usr/share/windows-resources/powersploit/Recon/PowerView.ps1' '/opt/tools/windows/PowerView.ps1'
    echo -e "${GREEN}PowerView has been copied successfully.${NC}"
}

function download_PowerView_Dev.ps1() {
    sudo mkdir -p '/opt/tools/windows'
    sudo wget -q 'https://raw.githubusercontent.com/lucky-luk3/ActiveDirectory/master/PowerView-Dev.ps1' -O '/opt/tools/windows/PowerView-Dev.ps1'
    echo -e "${GREEN}PowerView-Dev.ps1 downloaded successfully.${NC}"
}

function download_ADModule() {
    sudo mkdir -p '/opt/tools/windows'
    sudo git clone 'https://github.com/samratashok/ADModule.git' '/opt/tools/windows/ADModule'
    echo -e "${GREEN}ADModule downloaded successfully.${NC}"
}

function install_bloodhound() {
    sudo apt install bloodhound -y
    echo -e "${GREEN}bloodhound installed successfully.${NC}"
}

function get_Invoke_Portscan.ps1() {
    sudo mkdir -p '/opt/tools/windows'
    sudo cp '/usr/share/windows-resources/powersploit/Recon/Invoke-Portscan.ps1' '/opt/tools/windows/Invoke-Portscan.ps1'
    echo -e "${GREEN}Invoke_PortScan has been copied successfully.${NC}"
}

function download_SharpHound() {
    sudo mkdir -p '/opt/tools/windows'
    sudo wget -q 'https://github.com/BloodHoundAD/SharpHound/releases/download/v1.1.0/SharpHound-v1.1.0.zip' -O '/opt/tools/windows/SharpHound.zip'
    echo -e "${GREEN}SharpHound downloaded successfully.${NC}"
    sudo unzip -q '/opt/tools/windows/SharpHound.zip' -d '/opt/tools/windows/SharpHound'
    sudo rm -rf '/opt/tools/windows/SharpHound.zip'
    echo -e "${GREEN}SharpHound unzipped successfully.${NC}"
}

function install_all_recon_tools() {
    get_powerview
    download_PowerView_Dev.ps1
    download_ADModule
    install_bloodhound
    get_Invoke_Portscan.ps1
    download_SharpHound
}

function reconnaissance() {
    clear
    echo -e "${RED}"
    cat << "EOF"
┬─┐┌─┐┌─┐┌─┐┌┐┌┌┐┌┌─┐┬┌─┐┌─┐┌─┐┌┐┌┌─┐┌─┐
├┬┘├┤ │  │ │││││││├─┤│└─┐└─┐├─┤││││  ├┤ 
┴└─└─┘└─┘└─┘┘└┘┘└┘┴ ┴┴└─┘└─┘┴ ┴┘└┘└─┘└─┘
EOF
    echo ""
    echo -e "${BLUE}1. Install All Tools${NC}"
    echo -e "${BLUE}2. Get PowerView${NC}"
    echo -e "${BLUE}3. Download SharpHound${NC}"
    echo -e "${BLUE}4. Download ADModules${NC}"
    echo -e "${BLUE}5. Install BloodHound${NC}"
    echo -e "${BLUE}6. Download SharpenHound${NC}"
    echo -e "${BLUE}7. Get Invoke_Portscan.ps1${NC}"
    echo -e "${BLUE}8. Back${NC}"
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) install_all_recon_tools; reconnaissance;;
        2) get_powerview; reconnaissance;;
        3) download_sharphound; reconnaissance;;
        4) download_ADModule; reconnaissance;;
        5) install_bloodhound; reconnaissance;;
        6) download_SharpHound; reconnaissance;;
        7) get_Invoke_Portscan.ps1; reconnaissance;;
        8) main_menu;;
        *) echo "Invalid option"; reconnaissance;;
    esac
}

# --[ Vulnerabilities Scanners ]--
function download_linwinpwn() {
    sudo git clone 'https://github.com/lefayjey/linWinPwn.git' '/opt/tools/linWinPwn'
    echo -e "${GREEN}linwinpwn downloaded successfully.${NC}"
}

function install_all_vulnerability_scanners() {
    download_linwinpwn
}

function vulnerability_scanners() {
    clear
    echo -e "${RED}"
    cat << "EOF"
╦  ╦┬ ┬┬  ┌┐┌┌─┐┬─┐┌─┐┌┐ ┬┬  ┬┌┬┐┬┌─┐┌─┐  ╔═╗┌─┐┌─┐┌┐┌┌┐┌┌─┐┬─┐┌─┐
╚╗╔╝│ ││  │││├┤ ├┬┘├─┤├┴┐││  │ │ │├┤ └─┐  ╚═╗│  ├─┤││││││├┤ ├┬┘└─┐
 ╚╝ └─┘┴─┘┘└┘└─┘┴└─┴ ┴└─┘┴┴─┘┴ ┴ ┴└─┘└─┘  ╚═╝└─┘┴ ┴┘└┘┘└┘└─┘┴└─└─┘
EOF
    echo ""
    echo -e "${BLUE}1. Install All Tools${NC}"
    echo -e "${BLUE}2. Download linwinpwn${NC}"
    echo -e "${BLUE}3. Back${NC}"
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) install_all_vulnerability_scanners; vulnerability_scanners;;
        2) download_linwinpwn; vulnerability_scanners;;
        3) main_menu;;
        *) echo "Invalid option"; vulnerability_scanners;;
    esac
}

# --[ Phishing ]--
function install_evilginx2() {
    sudo apt install evilginx2 -y
    echo -e "${GREEN}evilginx2 installed successfully.${NC}"
}

function download_gophish() {
    sudo mkdir -p '/opt/tools/phishing/'
    sudo git clone 'https://github.com/gophish/gophish.git' '/opt/tools/phishing/gophish'
    echo -e "${GREEN}gophish downloaded successfully.${NC}"
    cd '/opt/tools/phishing/gophish'
    sudo go build
    echo -e "${GREEN}gophish builded successfully.${NC}"
}

function download_PyPhisher() {
    sudo mkdir -p '/opt/tools/phishing/'
    sudo git clone 'https://github.com/KasRoudra/PyPhisher.git' '/opt/tools/phishing/PyPhisher'
    echo -e "${GREEN}PyPhisher downloaded successfully.${NC}"
    cd  /opt/tools/phishing/PyPhisher/files/
    sudo pip3 install -r requirements.txt
    echo -e "${GREEN}requirements of PyPhisher installed successfully.${NC}"
}

function download_install_all_phishing_tools() {
    install_evilginx2
    download_gophish
    download_PyPhisher
}

function phishing() {
    clear
    echo -e "${RED}"
    cat << "EOF"
╔═╗┬ ┬┬┌─┐┬ ┬┬┌┐┌┌─┐  ╔╦╗┌─┐┌─┐┬  ┌─┐
╠═╝├─┤│└─┐├─┤│││││ ┬   ║ │ ││ ││  └─┐
╩  ┴ ┴┴└─┘┴ ┴┴┘└┘└─┘   ╩ └─┘└─┘┴─┘└─┘
EOF
    echo -e ""
    echo -e "${BLUE}1. Install All Tools${NC}"
    echo -e "${BLUE}2. Install evilginx2${NC}"
    echo -e "${BLUE}3. Download gophish${NC}"
    echo -e "${BLUE}4. Download PyPhisher${NC}"
    echo -e "${BLUE}5. Back${NC}"
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) download_install_all_phishing_tools; phishing;;
        2) install_evilginx2; phishing;;
        3) download_gophish; phishing;;
        4) download_PyPhisher; phishing;;
        5) main_menu;;
        *) echo "Invalid option"; phishing;;
    esac
}

# --[ File Trasfer ]--
function download_hfs() {
    sudo mkdir -p '/opt/tools/windows'
    sudo wget -q 'https://github.com/rejetto/hfs/releases/download/v0.44.0/hfs-windows.zip' -O '/opt/tools/windows/hfs-windows.zip'
    sudo rm -rf '/opt/tools/windows/hfs-windows.zip'
    echo -e "${GREEN}HFS downloaded and unzipped successfully.${NC}"
    sudo rm -rf '/opt/tools/windows/hfs-windows/plugins/'
    echo -e "${GREEN}HFS plugins folder removed successfully.${NC}"
}

function install_all_file_trasfer_tools() {
    download_hfs
}

function File_Trasfer_Tools() {
    clear
    echo -e "${RED}"
    cat << "EOF"
╔═╗┬┬  ┌─┐  ╔╦╗┬─┐┌─┐┌─┐┌─┐┌─┐┬─┐
╠╣ ││  ├┤    ║ ├┬┘├─┤└─┐├┤ ├┤ ├┬┘
╚  ┴┴─┘└─┘   ╩ ┴└─┴ ┴└─┘└  └─┘┴└─
EOF
    echo -e "${GREEN}--[ File Trasfer Tools ]--${NC}"
    echo -e "${BLUE}1. Install All Tools${NC}"
    echo -e "${BLUE}2. Download HFS${NC}"
    echo -e "${BLUE}3. Back${NC}"
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) install_all_file_trasfer_tools; File_Trasfer_Tools;;
        2) download_hfs; File_Trasfer_Tools;;
        3) main_menu;;
        *) echo "Invalid option"; File_Trasfer_Tools;;
    esac
}

# --[ AV/EDR Evasion Tools ]--
function download_Freeze() {
    sudo mkdir -p '/opt/tools/windows/'
    sudo git clone 'https://github.com/optiv/Freeze' '/opt/tools/windows/Freeze'
    echo -e "${GREEN}Freeze downloaded successfully.${NC}"
    cd '/opt/tools/windows/Freeze'
    sudo go build Freeze.go
    echo -e "${GREEN}Freeze builded successfully.${NC}"
}

function download_Invisi_Shell() {
    sudo mkdir -p '/opt/tools/windows/'
    sudo git clone 'https://github.com/OmerYa/Invisi-Shell.git' '/opt/tools/windows/Invisi-Shell'
    echo -e "${GREEN}Invisi-Shell downloaded successfully.${NC}"
}

function install_all_Evasion_tools() {
    download_Freeze
    download_Invisi_Shell
}

function Evasion_Tools() {
    clear
    echo -e "${RED}"
    cat << "EOF"
╔═╗╦  ╦  ╔═╗┬  ┬┌─┐┌─┐┬┌─┐┌┐┌  ╔╦╗┌─┐┌─┐┬  ┌─┐
╠═╣╚╗╔╝  ║╣ └┐┌┘├─┤└─┐││ ││││   ║ │ ││ ││  └─┐
╩ ╩ ╚╝   ╚═╝ └┘ ┴ ┴└─┘┴└─┘┘└┘   ╩ └─┘└─┘┴─┘└─┘
EOF
    echo ""
    echo -e "${BLUE}1. Install All Tools${NC}"
    echo -e "${BLUE}2. Download Freeze${NC}"
    echo -e "${BLUE}3. Download Invisi_Shell${NC}"
    echo -e "${BLUE}4. Back${NC}"
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) install_all_Evasion_tools; Evasion_Tools;;
        2) download_Freeze; Evasion_Tools;;
        3) download_Invisi_Shell; Evasion_Tools;;
        4) main_menu;;
        *) echo "Invalid option"; Evasion_Tools;;
    esac
}

# --[ Windows Privilege Escalation ]--
function get_PowerUp.ps1() {
    sudo mkdir -p '/opt/tools/windows/'
    sudo cp '/usr/share/windows-resources/powersploit/Privesc/PowerUp.ps1' '/opt/tools/windows/PowerUp.ps1'
    echo -e "${GREEN}PowerUp has been copied successfully.${NC}"
}

function download_PowerUpSQL() {
    sudo mkdir -p '/opt/tools/windows/'
    sudo wget -q 'https://raw.githubusercontent.com/NetSPI/PowerUpSQL/master/PowerUpSQL.ps1' -O '/opt/tools/windows/PowerUpSQL.ps1'
    sudo wget -q 'https://raw.githubusercontent.com/NetSPI/PowerUpSQL/master/PowerUpSQL.psd1' -O '/opt/tools/windows/PowerUpSQL.psd1'
    sudo wget -q 'https://raw.githubusercontent.com/NetSPI/PowerUpSQL/master/PowerUpSQL.psm1' -O '/opt/tools/windows/PowerUpSQL.psm1'
    echo -e "${GREEN}PowerUpSQL downloaded successfully.${NC}"
}

function get_system() {
    sudo mkdir -p '/opt/tools/windows/'
    cp '/usr/share/windows-resources/powersploit/Privesc/Get-System.ps1' '/opt/tools/windows/Get-System.ps1'
    echo -e "${GREEN}Get-System.ps1 has been copied successfully.${NC}"
}

function download_PrivescCheck() {
    sudo mkdir -p '/opt/tools/windows/'
    sudo wget -q 'https://raw.githubusercontent.com/itm4n/PrivescCheck/master/PrivescCheck.ps1' -O '/opt/tools/windows/PrivescCheck.ps1'
    echo -e "${GREEN}PrivEscCheck.ps1 downloaded successfully.${NC}"
}

function download_WinPEAS() {
    sudo mkdir -p '/opt/tools/windows/'
    sudo wget -q 'https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASany_ofs.exe' -O '/opt/tools/windows/winPEASany_ofs.exe'
    echo -e "${GREEN}WinPEASany_ofs.exe downloaded successfully.${NC}"
}

function download_install_all_Privilege_Escalation_tools() {
    get_PowerUp.ps1
    download_PowerUpSQL
    get_system
    download_PrivescCheck
    download_WinPEAS
}

function Windows_Privilege_Escalation_Tools() {
    clear
    echo -e "${RED}"
    cat << "EOF"
╦ ╦┬┌┐┌┌┬┐┌─┐┬ ┬┌─┐  ╔═╗┬─┐┬┬  ┬┬┬  ┌─┐┌─┐┌─┐  ╔═╗┌─┐┌─┐┌─┐┬  ┌─┐┌┬┐┬┌─┐┌┐┌  ╔╦╗┌─┐┌─┐┬  ┌─┐
║║║││││ │││ ││││└─┐  ╠═╝├┬┘│└┐┌┘││  ├┤ │ ┬├┤   ║╣ └─┐│  ├─┤│  ├─┤ │ ││ ││││   ║ │ ││ ││  └─┐
╚╩╝┴┘└┘─┴┘└─┘└┴┘└─┘  ╩  ┴└─┴ └┘ ┴┴─┘└─┘└─┘└─┘  ╚═╝└─┘└─┘┴ ┴┴─┘┴ ┴ ┴ ┴└─┘┘└┘   ╩ └─┘└─┘┴─┘└─┘
EOF
    echo ""
    echo -e "${BLUE}1. Install All Tools${NC}"
    echo -e "${BLUE}2. Get PowerUp.ps1${NC}"
    echo -e "${BLUE}3. Download PowerUpSQL${NC}"
    echo -e "${BLUE}4. Get GetSystem.ps1${NC}"
    echo -e "${BLUE}5. Download PrivescCheck.ps1${NC}"
    echo -e "${BLUE}6. Download WinPEASany_ofs.exe${NC}"
    echo -e "${BLUE}7. Back${NC}"
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) download_install_all_Privilege_Escalation_tools;;
        2) get_PowerUp.ps1; Windows_Privilege_Escalation_Tools;;
        3) download_PowerUpSQL; Windows_Privilege_Escalation_Tools;;
        4) get_system; Windows_Privilege_Escalation_Tools;;
        5) download_PrivescCheck; Windows_Privilege_Escalation_Tools;;
        6) download_WinPEAS; Windows_Privilege_Escalation_Tools;;
        7) main_menu;;
        *) echo "Invalid option"; Windows_Privilege_Escalation_Tools;;
    esac
}

function main_menu() {
    clear
    echo -e "${RED}"
    cat << "EOF"
    ╔═╗┬  ┬┬┬  ╦╔═┌─┐┬  ┬
    ║╣ └┐┌┘││  ╠╩╗├─┤│  │
    ╚═╝ └┘ ┴┴─┘╩ ╩┴ ┴┴─┘┴
                    By YoruYagami
EOF
    echo ""
    echo -e "${BLUE}1. Install All Tools${NC}"
    echo -e "${BLUE}2. Command and Control${NC}"
    echo -e "${BLUE}3. Reconnaissance${NC}"
    echo -e "${BLUE}4. Phishing${NC}"
    echo -e "${BLUE}5. Vulnerability Scanners${NC}"
    echo -e "${BLUE}6. AV/EDR Evasion Tools${NC}"
    echo -e "${BLUE}7. Windows Privilege Escaltion Tools${NC}"
    echo -e "${BLUE}8. Quit${NC}"
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) download_install_all_c2_tools; install_all_recon_tools; install_all_vulnerability_scanners; download_install_all_phishing_tools; install_all_Evasion_tools main_menu;;
        2) command_and_control;;
        3) reconnaissance;;
        4) phishing;;
        5) vulnerability_scanners;;
        6) Evasion_Tools;;
        7) Windows_Privilege_Escalation_Tools;;
        8) exit;;
        *) echo "Invalid option"; main_menu;;
    esac
}

main_menu
