#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
CYAN="\e[0;36m"
YELLOW="\033[0;33m"
NC='\033[0m'

clear

# Check if the script get executed with sudo
if [ $(id -u) -ne 0 ]; then
    echo "${RED}This script must be run as root. Please run with sudo.${NC}"
    exit 1
fi

# Function to check if a command is available
command_exists() {
  command -v '$1'
}

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
read -p "Do you want to update/upgrade the system first? (highly recommended) (y/n)" -n 1 -r
echo ''
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo apt update -y && sudo apt -y full-upgrade -y && sudo apt -y dist-upgrade -y && sudo apt autoremove -y && sudo apt clean -y
fi

# List of essentials packages to check
essentials=(python3 git gobuster docker-compose docker.io neovim wget git unzip php openssh-client golang-go sed curl openssl uuid-runtime)

# Function to check if a command is available
is_command() {
    command -v $1
}

# Check and install some essentials packages
for pkg in "${essentials[@]}"; do
    if is_command $pkg &> /dev/null; then
        echo -e "$pkg already installed."
    else
        echo "$pkg is not installed.installing for you"
        sudo apt install $pkg -y  
    fi
done

# --[ Command and Control ]--
function download_villain() {
    sudo mkdir -p '/opt/evilkali/C2'
    if [ -d "/opt/evilkali/C2/Villain" ]; then
        echo -e "${RED}Villain is already installed.${NC}"
    else
        echo -e "${YELLOW}Downloading Villain${NC}"
        sudo git clone 'https://github.com/t3l3machus/Villain.git' '/opt/evilkali/C2/Villain' 
        echo -e "${GREEN}Villain downloaded successfully.${NC}"
    fi
    sleep 2
}

function download_covenant() {
    sudo mkdir -p '/opt/evilkali/C2'
    if [ -d "/opt/evilkali/C2/Covenant" ]; then
        echo -e "${RED}Covenant is already installed.${NC}"
    else
        echo -e "${YELLOW}Downloading Covenant${NC}"
        sudo git clone --recurse-submodules https://github.com/cobbr/Covenant '/opt/evilkali/C2/Covenant' 
        echo -e "${GREEN}Covenant downloaded successfully.${NC}"
    fi
    sleep 2
}

function download_AM0N_Eye() {
    sudo mkdir -p '/opt/evilkali/C2'
    if [ -d "/opt/evilkali/C2/AM0N-Eye" ]; then
        echo -e "${RED}AM0N-Eye is already installed.${NC}"
    else
        echo -e "${YELLOW}Downloading AM0N_Eye${NC}"
        sudo git clone 'https://github.com/S3N4T0R-0X0/AMON-Eye.git' '/opt/evilkali/C2/AM0N-Eye' 
        echo -e "${GREEN}AM0N_Eye downloaded successfully.${NC}"
    fi
    sleep 2
}

function download_Havoc() {
    sudo mkdir -p '/opt/evilkali/C2'
    if [ -d "/opt/evilkali/C2/Havoc" ]; then
        echo -e "${RED}Havoc Framework is already installed.${NC}"
    else
        echo -e "${YELLOW}Downloading Havoc Framework${NC}"
        sudo git clone 'https://github.com/HavocFramework/Havoc.git' '/opt/evilkali/C2/Havoc' 
        echo -e "${GREEN}Havoc Framework downloaded successfully.${NC}"
    fi
    sleep 2
}

function install_sliver() {
    if command -v sliver &> /dev/null; then
        echo -e "${RED}Sliver is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing Sliver Framework.${NC}"
        sudo curl https://sliver.sh/install | sudo bash 
        echo -e "${GREEN}Sliver installed successfully.${NC}"
    fi
    sleep 2
}

function install_pwncat() {
    if ! pip3 list 2>/dev/null | grep -q pwncat-cs; then
        echo -e "${YELLOW}Installing pwncat-cs.${NC}"
        pip3 install pwncat-cs 
        echo -e "${GREEN}pwncat-cs installed successfully.${NC}"
    else
        echo -e "${RED}pwncat-cs is already installed.${NC}"
    fi
    sleep 2
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
    echo -e "${GREEN}"
    cat << "EOF"
_________  ________   ___________                                                __    
\_   ___ \ \_____  \  \_   _____/___________    _____   ______  _  _____________|  | __
/    \  \/  /  ____/   |    __) \_  __ \__  \  /     \_/ __ \ \/ \/ /  _ \_  __ \  |/ /
\     \____/       \   |     \   |  | \// __ \|  Y Y  \  ___/\     (  <_> )  | \/    < 
 \______  /\_______ \  \___  /   |__|  (____  /__|_|  /\___  >\/\_/ \____/|__|  |__|_ \
        \/         \/      \/               \/      \/     \/                        \/

EOF
        echo -e "${GREEN}\n Select an option from menu:${NC}"
    echo -e "${GREEN}\nKey     Menu Option:"${NC}
    echo -e "---     -------------------------"
    echo -e "${GREEN} 1   -  Download/Install All Tools${NC}"
    echo -e "${GREEN} 2   -  Download Villain${NC}"
    echo -e "${GREEN} 3   -  Download Covenant${NC}"
    echo -e "${GREEN} 4   -  Download AM0N_Eye${NC}"
    echo -e "${GREEN} 5   -  Download Havoc${NC}"
    echo -e "${GREEN} 6   -  Install Sliver${NC}"
    echo -e "${GREEN} 7   -  Install pwncat-cs${NC}"
    echo -e "${GREEN} 8   -  Back${NC}"
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
    sudo mkdir -p '/opt/evilkali/windows'
    if [ -f "/opt/evilkali/windows/PowerView.ps1" ]; then
        echo -e "${RED}PowerView has already been copied.${NC}"
    else
        sudo cp '/usr/share/windows-resources/powersploit/Recon/PowerView.ps1' '/opt/evilkali/windows/PowerView.ps1'
        sudo wget -q 'https://raw.githubusercontent.com/lucky-luk3/ActiveDirectory/master/PowerView-Dev.ps1' -O '/opt/evilkali/windows/PowerView-Dev.ps1' 
        echo -e "${GREEN}PowerView has been copied successfully.${NC}"
    fi
    sleep 2
}

function download_ADModule() {
    sudo mkdir -p '/opt/evilkali/windows'
    if [ -d "/opt/evilkali/windows/ADModule" ]; then
        echo -e "${RED}ADModule is already downloaded.${NC}"
    else
        sudo git clone 'https://github.com/samratashok/ADModule.git' '/opt/evilkali/windows/ADModule' 
        echo -e "${GREEN}ADModule downloaded successfully.${NC}"
    fi
    sleep 2
}

function install_bloodhound() {
    if dpkg -s bloodhound; then
        echo -e "${RED}bloodhound is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing bloodhound${NC}"
        sudo apt install bloodhound -y 
        echo -e "${GREEN}bloodhound installed successfully.${NC}"
    fi
    sleep 2
}

function get_Invoke_Portscan.ps1() {
    sudo mkdir -p '/opt/evilkali/windows'
    if [ -f "/opt/evilkali/windows/Invoke-Portscan.ps1" ]; then
        echo -e "${RED}Invoke_PortScan has already been copied.${NC}"
    else
        sudo cp '/usr/share/windows-resources/powersploit/Recon/Invoke-Portscan.ps1' '/opt/evilkali/windows/Invoke-Portscan.ps1'
        echo -e "${GREEN}Invoke_PortScan has been copied successfully.${NC}"
    fi
    sleep 2
}

function download_SharpHound() {
    sudo mkdir -p '/opt/evilkali/windows'
    if [ -d "/opt/evilkali/windows/SharpHound" ]; then
        echo -e "${RED}SharpHound is already downloaded and unzipped.${NC}"
    else
        echo -e "${YELLOW}Downloading SharpHound${NC}"
        sudo wget -q 'https://github.com/BloodHoundAD/SharpHound/releases/download/v1.1.0/SharpHound-v1.1.0.zip' -O '/opt/evilkali/windows/SharpHound.zip' 
        echo -e "${GREEN}SharpHound downloaded successfully.${NC}"
        sudo unzip -q '/opt/evilkali/windows/SharpHound.zip' -d '/opt/evilkali/windows/SharpHound'
        sudo rm -rf '/opt/evilkali/windows/SharpHound.zip'
        echo -e "${GREEN}SharpHound unzipped successfully.${NC}"
    fi
    sleep 2
}


function install_all_recon_tools() {
    get_powerview
    download_ADModule
    install_bloodhound
    get_Invoke_Portscan.ps1
    download_SharpHound
}

function reconnaissance() {
    clear
    echo -e "${GREEN}"
    cat << "EOF"
__________                                         .__                                    
\______   \ ____   ____  ____   ____   ____ _____  |__| ___________    ____   ____  ____  
 |       _// __ \_/ ___\/  _ \ /    \ /    \\__  \ |  |/  ___/\__  \  /    \_/ ___\/ __ \ 
 |    |   \  ___/\  \__(  <_> )   |  \   |  \/ __ \|  |\___ \  / __ \|   |  \  \__\  ___/ 
 |____|_  /\___  >\___  >____/|___|  /___|  (____  /__/____  >(____  /___|  /\___  >___  >
        \/     \/     \/           \/     \/     \/        \/      \/     \/     \/    \/ 
EOF
    echo -e "${GREEN}\n Select an option from menu:${NC}"
    echo -e "${GREEN}\nKey     Menu Option:"${NC}
    echo -e "---     -------------------------"
    echo -e "${GREEN} 1   -  Download/Install All Tools${NC}"
    echo -e "${GREEN} 2   -  Get PowerView${NC}"
    echo -e "${GREEN} 3   -  Download SharpHound${NC}"
    echo -e "${GREEN} 4   -  Download ADModule${NC}"
    echo -e "${GREEN} 5   -  Install BloodHound${NC}"
    echo -e "${GREEN} 6   -  Get Invoke_Portscan.ps1${NC}"
    echo -e "${GREEN} 7   -  Back${NC}"
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) install_all_recon_tools; reconnaissance;;
        2) get_powerview; reconnaissance;;
        3) download_SharpHound; reconnaissance;;
        4) download_ADModule; reconnaissance;;
        5) install_bloodhound; reconnaissance;;
        6) get_Invoke_Portscan.ps1; reconnaissance;;
        7) main_menu;;
        *) echo "Invalid option"; reconnaissance;;
    esac
}

# --[ Vulnerabilities Scanners ]--
function download_linwinpwn() {
    if [ -d "/opt/evilkali/linWinPwn" ]; then
        echo -e "${RED}linwinpwn is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading linwinpwn${NC}"
        sudo git clone 'https://github.com/lefayjey/linWinPwn.git' '/opt/evilkali/linWinPwn' 
        echo -e "${GREEN}linwinpwn downloaded successfully.${NC}"
    fi
    sleep 2
}

function install_all_vulnerability_scanners() {
    download_linwinpwn
}

function vulnerability_scanners() {
    clear
    echo -e "${GREEN}"
    cat << "EOF"
____   ____    .__             _________                                         
\   \ /   /_ __|  |   ____    /   _____/ ____ _____    ____   ____   ___________ 
 \   Y   /  |  \  |  /    \   \_____  \_/ ___\\__  \  /    \ /    \_/ __ \_  __ \
  \     /|  |  /  |_|   |  \  /        \  \___ / __ \|   |  \   |  \  ___/|  | \/
   \___/ |____/|____/___|  / /_______  /\___  >____  /___|  /___|  /\___  >__|   
                         \/          \/     \/     \/     \/     \/     \/       
EOF
    echo -e "${GREEN}\n Select an option from menu:${NC}"
    echo -e "${GREEN}\nKey     Menu Option:"${NC}
    echo -e "---     -------------------------"
    echo -e "${GREEN} 1   -  Download/Install All Tools${NC}"
    echo -e "${GREEN} 2   -  Download linwinpwn${NC}"
    echo -e "${GREEN} 3   -  Back${NC}"
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
    if command -v evilginx2 &> /dev/null; then
        echo -e "${RED}evilginx2 is already installed.${NC}"
    else
        echo -e "${YELLOW}installing evilginx2${NC}"
        sudo apt install evilginx2 -y
        echo -e "${GREEN}evilginx2 installed successfully.${NC}"
    fi
    sleep 2
}

function download_gophish() {
    sudo mkdir -p '/opt/evilkali/phishing/'
    if [ -d "/opt/evilkali/phishing/gophish" ]; then
        echo -e "${RED}gophish is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading gophish${NC}"
        sudo git clone 'https://github.com/gophish/gophish.git' '/opt/evilkali/phishing/gophish'
        echo -e "${GREEN}gophish downloaded successfully.${NC}"
    fi

    if [ -f "/opt/evilkali/phishing/gophish/gophish" ]; then
        echo -e "${RED}gophish is already built.${NC}"
    else
        cd '/opt/evilkali/phishing/gophish'
        echo -e "${YELLOW}Building gophish${NC}"
        sudo go build
        echo -e "${GREEN}gophish built successfully.${NC}"
    fi
    sleep 2
}

function download_PyPhisher() {
    sudo mkdir -p '/opt/evilkali/phishing/'
    if [ -d "/opt/evilkali/phishing/PyPhisher" ]; then
        echo -e "${RED}PyPhisher is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading PyPhisher${NC}"
        sudo git clone 'https://github.com/KasRoudra/PyPhisher.git' '/opt/evilkali/phishing/PyPhisher'
        echo -e "${GREEN}PyPhisher downloaded successfully.${NC}"
    fi
    
    if [ -f "/opt/evilkali/phishing/PyPhisher/files/requirements.txt" ]; then
        echo -e "${RED}Requirements of PyPhisher are already installed.${NC}"
    else
        echo -e "${YELLOW}Installing PyPhisher requirements${NC}"
        cd  '/opt/evilkali/phishing/PyPhisher/files/'
        sudo pip3 install -r requirements.txt
        echo -e "${GREEN}Requirements of PyPhisher installed successfully.${NC}"
    fi
    sleep 2
}

function download_install_all_phishing_tools() {
    install_evilginx2
    download_gophish
    download_PyPhisher
}

function phishing() {
    clear
    echo -e "${GREEN}"
    cat << "EOF"

__________.__    .__       .__    .__                 ___________           .__          
\______   \  |__ |__| _____|  |__ |__| ____    ____   \__    ___/___   ____ |  |   ______
 |     ___/  |  \|  |/  ___/  |  \|  |/    \  / ___\    |    | /  _ \ /  _ \|  |  /  ___/
 |    |   |   Y  \  |\___ \|   Y  \  |   |  \/ /_/  >   |    |(  <_> |  <_> )  |__\___ \ 
 |____|   |___|  /__/____  >___|  /__|___|  /\___  /    |____| \____/ \____/|____/____  >
               \/        \/     \/        \//_____/                                   \/ 

EOF
    echo -e "${GREEN}\n Select an option from menu:${NC}"
    echo -e "${GREEN}\nKey     Menu Option:"${NC}
    echo -e "---     -------------------------"
    echo -e "${GREEN} 1   -  Download/Install All Tools${NC}"
    echo -e "${GREEN} 2   -  Install evilginx2${NC}"
    echo -e "${GREEN} 3   -  Download gophish${NC}"
    echo -e "${GREEN} 4   -  Download PyPhisher${NC}"
    echo -e "${GREEN} 5   -  Back${NC}"
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
    sudo mkdir -p '/opt/evilkali/windows'
    if [ -d "/opt/evilkali/windows/hfs-windows" ]; then
        echo -e "${RED}HFS is already downloaded.${NC}"

        if [ -d "/opt/evilkali/windows/hfs-windows/plugins/" ]; then
            echo -e "${GREEN}HFS plugins folder removed successfully.${NC}"
        else
            echo -e "${RED}HFS plugins folder does not exist or has already been removed.${NC}"
        fi
    else
        echo -e "${YELLOW}Downloading HFS${NC}"
        sudo wget -q 'https://github.com/rejetto/hfs/releases/download/v0.44.0/hfs-windows.zip' -O '/opt/evilkali/windows/hfs-windows.zip' 
        echo -e "${GREEN}HFS downloaded successfully.${NC}"
        echo -e "${YELLOW}Unzipping HFS${NC}"
        sudo rm -rf 
        sudo unzip '/opt/evilkali/windows/hfs-windows.zip' -d '/opt/evilkali/windows/hfs-windows' 
        sudo cp '/opt/evilkali/windows/hfs-windows/hfs.exe' '/opt/evilkali/windows/'
        sudo rm -rf '/opt/evilkali/windows/hfs-windows'
        sudo rm -rf '/opt/evilkali/windows/hfs-windows.zip'
        echo -e "${GREEN}HFS unzipped successfully.${NC}"

        if [ -d "/opt/evilkali/windows/hfs-windows/plugins/" ]; then
            sudo rm -rf '/opt/evilkali/windows/hfs-windows/plugins/'
            echo -e "${GREEN}HFS plugins folder removed successfully.${NC}"
        fi
    fi
    sleep 2
}

function get_netcat_binary() {
    sudo mkdir -p '/opt/evilkali/windows/'
    if [ -f "/opt/evilkali/windows/nc.exe" ]; then
        echo -e "${RED}nc.exe is already copied.${NC}"
    else
        echo -e "${YELLOW}copying nc.exe${NC}"
        sudo cp '/usr/share/windows-binaries/nc.exe' '/opt/evilkali/windows/nc.exe'
    fi
    sleep 2
}

function install_updog() {
    if command -v updog &> /dev/null; then
        echo -e "${RED}updog is already installed.${NC}"
    else
        echo -e "${YELLOW}installing updog${NC}"
        sudo pip3 install updog
        echo -e "${GREEN}updog installed successfully.${NC}"
    fi
    sleep 2
}

function install_all_file_trasfer_tools() {
    download_hfs
    get_netcat_binary
    install_updog
}

function File_Trasfer_Tools() {
    clear
    echo -e "${GREEN}"
    cat << "EOF"
___________.__.__           ___________                       _____             
\_   _____/|__|  |   ____   \__    ___/___________    _______/ ____\___________ 
 |    __)  |  |  | _/ __ \    |    |  \_  __ \__  \  /  ___/\   __\/ __ \_  __ \
 |     \   |  |  |_\  ___/    |    |   |  | \// __ \_\___ \  |  | \  ___/|  | \/
 \___  /   |__|____/\___  >   |____|   |__|  (____  /____  > |__|  \___  >__|   
     \/                 \/                        \/     \/            \/       
EOF
    echo -e "${GREEN}\n Select an option from menu:${NC}"
    echo -e "${GREEN}\nKey     Menu Option:"${NC}
    echo -e "---     -------------------------"
    echo -e "${GREEN} 1   -  Download/Install All Tools${NC}"
    echo -e "${GREEN} 2   -  Download HFS${NC}"
    echo -e "${GREEN} 3   -  Get nc.exe${NC}"
    echo -e "${GREEN} 4   -  Install Updog${NC}"
    echo -e "${GREEN} 5   -  Back${NC}"
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) install_all_file_trasfer_tools; File_Trasfer_Tools;;
        2) download_hfs; File_Trasfer_Tools;;
        3) get_netcat_binary;;
        4) install_updog;;
        5) main_menu;;
        *) echo "Invalid option"; File_Trasfer_Tools;;
    esac
}

# --[ Evasion Tools ]--
function download_Freeze() {
    sudo mkdir -p '/opt/evilkali/windows/'
    if [ -d "/opt/evilkali/windows/Freeze" ]; then
        echo -e "${RED}Freeze is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading Freeze${NC}"
        sudo git clone 'https://github.com/optiv/Freeze' '/opt/evilkali/windows/Freeze' 
        echo -e "${GREEN}Freeze downloaded successfully.${NC}"
    fi

    cd '/opt/evilkali/windows/Freeze'
    if [ ! -f "./Freeze" ]; then
        sudo go build Freeze.go 
        echo -e "${GREEN}Freeze built successfully.${NC}"
    else
        echo -e "${YELLOW}Freeze is already built.${NC}"
    fi
}

function download_Invisi_Shell() {
    sudo mkdir -p '/opt/evilkali/windows/'
    if [ -d "/opt/evilkali/windows/Invisi-Shell" ]; then
        echo -e "${RED}Invisi-Shell is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading Invisi-Shell${NC}"
        sudo git clone 'https://github.com/OmerYa/Invisi-Shell.git' '/opt/evilkali/windows/Invisi-Shell' 
        echo -e "${GREEN}Invisi-Shell downloaded successfully.${NC}"
    fi
}

function install_all_Evasion_tools() {
    download_Freeze
    download_Invisi_Shell
}

function Evasion_Tools() {
    clear
    echo -e "${GREEN}"
    cat << "EOF"
___________                    .__               
\_   _____/__  _______    _____|__| ____   ____  
 |    __)_\  \/ /\__  \  /  ___/  |/  _ \ /    \ 
 |        \\   /  / __ \_\___ \|  (  <_> )   |  \
/_______  / \_/  (____  /____  >__|\____/|___|  /
        \/            \/     \/               \/ 

EOF
    echo -e "${GREEN}\n Select an option from menu:${NC}"
    echo -e "${GREEN}\nKey     Menu Option:"${NC}
    echo -e "---     -------------------------"
    echo -e "${GREEN} 1   -  Download/Install All Tools${NC}"
    echo -e "${GREEN} 2   -  Download Freeze${NC}"
    echo -e "${GREEN} 3   -  Download Invisi_Shell${NC}"
    echo -e "${GREEN} 4   -  Back${NC}"
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
    sudo mkdir -p '/opt/evilkali/windows/'
    if [ -f "/opt/evilkali/windows/PowerUp.ps1" ]; then
        echo -e "${YELLOW}PowerUp.ps1 is already copied.${NC}"
    else
        echo -e "${YELLOW}copying PowerUp.ps1${NC}"
        sudo cp '/usr/share/windows-resources/powersploit/Privesc/PowerUp.ps1' '/opt/evilkali/windows/PowerUp.ps1'
        echo -e "${GREEN}PowerUp has been copied successfully.${NC}"
    fi
}

function download_PowerUpSQL() {
    sudo mkdir -p '/opt/evilkali/windows/'
    if [ -f "/opt/evilkali/windows/PowerUpSQL.ps1" ] && [ -f "/opt/evilkali/windows/PowerUpSQL.psd1" ] && [ -f "/opt/evilkali/windows/PowerUpSQL.psm1" ]; then
        echo -e "${RED}PowerUpSQL is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading PowerUpSQL${NC}"
        sudo wget -q 'https://raw.githubusercontent.com/NetSPI/PowerUpSQL/master/PowerUpSQL.ps1' -O '/opt/evilkali/windows/PowerUpSQL.ps1' 
        sudo wget -q 'https://raw.githubusercontent.com/NetSPI/PowerUpSQL/master/PowerUpSQL.psd1' -O '/opt/evilkali/windows/PowerUpSQL.psd1' 
        sudo wget -q 'https://raw.githubusercontent.com/NetSPI/PowerUpSQL/master/PowerUpSQL.psm1' -O '/opt/evilkali/windows/PowerUpSQL.psm1' 
        echo -e "${GREEN}PowerUpSQL downloaded successfully.${NC}"
    fi
}

function get_system() {
    sudo mkdir -p '/opt/evilkali/windows/'
    if [ -f "/opt/evilkali/windows/Get-System.ps1" ]; then
        echo -e "${RED}Get-System.ps1 is already copied.${NC}"
    else
        echo -e "${YELLOW}copying Get_System.ps1${NC}"
        cp '/usr/share/windows-resources/powersploit/Privesc/Get-System.ps1' '/opt/evilkali/windows/Get-System.ps1'
        echo -e "${GREEN}Get-System.ps1 has been copied successfully.${NC}"
    fi
}

function download_PrivescCheck() {
    sudo mkdir -p '/opt/evilkali/windows/'
    if [ -f "/opt/evilkali/windows/PrivescCheck.ps1" ]; then
        echo -e "${RED}PrivEscCheck.ps1 is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading PrivescCheck.ps1${NC}"
        sudo wget -q 'https://raw.githubusercontent.com/itm4n/PrivescCheck/master/PrivescCheck.ps1' -O '/opt/evilkali/windows/PrivescCheck.ps1' 
        echo -e "${GREEN}PrivEscCheck.ps1 downloaded successfully.${NC}"
    fi
}

function download_WinPEAS() {
    sudo mkdir -p '/opt/evilkali/windows/'
    if [ -f "/opt/evilkali/windows/winPEASany_ofs.exe" ]; then
        echo -e "${RED}WinPEASany_ofs.exe is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading WinPEAS${NC}"
        sudo wget -q 'https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASany_ofs.exe' -O '/opt/evilkali/windows/winPEASany_ofs.exe' 
        echo -e "${GREEN}WinPEASany_ofs.exe downloaded successfully.${NC}"
    fi
}

function download_install_all_Windows_Privilege_Escalation_tools() {
    get_PowerUp.ps1
    download_PowerUpSQL
    get_system
    download_PrivescCheck
    download_WinPEAS
}

function Windows_Privilege_Escalation_Tools() {
    clear
    echo -e "${GREEN}"
    cat << "EOF"
 __      __.__            .___                    __________        .__        ___________              
/  \    /  \__| ____    __| _/______  _  ________ \______   \_______|__|__  __ \_   _____/ ______ ____  
\   \/\/   /  |/    \  / __ |/  _ \ \/ \/ /  ___/  |     ___/\_  __ \  \  \/ /  |    __)_ /  ___// ___\ 
 \        /|  |   |  \/ /_/ (  <_> )     /\___ \   |    |     |  | \/  |\   /   |        \\___ \\  \___ 
  \__/\  / |__|___|  /\____ |\____/ \/\_//____  >  |____|     |__|  |__| \_/   /_______  /____  >\___  >
       \/          \/      \/                 \/                                       \/     \/     \/ 

EOF
    echo -e "${GREEN}\n Select an option from menu:${NC}"
    echo -e "${GREEN}\nKey     Menu Option:"${NC}
    echo -e "---     -------------------------"
    echo -e "${GREEN} 1   -  Download/Install All Tools${NC}"
    echo -e "${GREEN} 2   -  Get PowerUp.ps1${NC}"
    echo -e "${GREEN} 3   -  Download PowerUpSQL${NC}"
    echo -e "${GREEN} 4   -  Get GetSystem.ps1${NC}"
    echo -e "${GREEN} 5   -  Download PrivescCheck.ps1${NC}"
    echo -e "${GREEN} 6   -  Download WinPEASany_ofs.exe${NC}"
    echo -e "${GREEN} 7   -  Back${NC}"
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) download_install_all_Windows_Privilege_Escalation_tools; Windows_Privilege_Escalation_Tools;;
        2) get_PowerUp.ps1; Windows_Privilege_Escalation_Tools;;
        3) download_PowerUpSQL; Windows_Privilege_Escalation_Tools;;
        4) get_system; Windows_Privilege_Escalation_Tools;;
        5) download_PrivescCheck; Windows_Privilege_Escalation_Tools;;
        6) download_WinPEAS; Windows_Privilege_Escalation_Tools;;
        7) main_menu;;
        *) echo "Invalid option"; Windows_Privilege_Escalation_Tools;;
    esac
}

# --[ GhostPack Compiled Binaries ]--
function download_Ghostpack() {
    sudo mkdir -p '/opt/evilkali/windows/'
    if [ -d "/opt/evilkali/windows/Ghostpack-CompiledBinaries" ]; then
        echo -e "${RED}Ghostpack Compiled Binaries is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading Compiled GhostPack Binaries${NC}"
        sudo git clone 'https://github.com/r3motecontrol/Ghostpack-CompiledBinaries.git' '/opt/evilkali/Ghostpack/'
        sudo cp -r /opt/evilkali/Ghostpack/* /opt/evilkali/windows/
        sudo rm -r '/opt/evilkali/Ghostpack'
        sudo rm -rf '/opt/evilkali/windows/README.md'
        echo -e "${GREEN}Ghostpack downloaded successfully.${NC}"
    fi
    sleep 2
}

# --[ Linux Privilege Escalation ]--
function download_LinEnum() {
    sudo mkdir -p '/opt/evilkali/linux/'
    if [ -f "/opt/evilkali/linux/LinEnum.sh" ]; then
        echo -e "${RED}LinEnum.sh is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading LinEnum.sh${NC}"
        sudo wget -q 'https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh' -O '/opt/evilkali/linux/LinEnum.sh' 
        echo -e "${GREEN}LinEnum.sh downloaded successfully.${NC}"
    fi
    sleep 2
}

function download_LinPeas() {
    sudo mkdir -p '/opt/evilkali/linux/'
    if [ -f "/opt/evilkali/linux/linpeas.sh" ]; then
        echo -e "${RED}linpeas.sh is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading linpeas.sh${NC}"
        sudo wget -q 'https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh' -O '/opt/evilkali/linux/linpeas.sh' 
        echo -e "${GREEN}linpeas.sh downloaded successfully.${NC}"
    fi
    sleep 2
}

function download_linuxsmartenumeration() {
    sudo mkdir -p '/opt/evilkali/linux/'
    if [ -f "/opt/evilkali/linux/lse.sh" ]; then
        echo -e "${RED}lse.sh is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading lse.sh${NC}"
        sudo wget -q 'https://raw.githubusercontent.com/diego-treitos/linux-smart-enumeration/master/lse.sh' -O '/opt/evilkali/linux/lse.sh' 
        echo -e "${GREEN}lse.sh downloaded successfully.${NC}"
    fi
    sleep 2
}

function download_install_all_Linux_Privilege_Escalation_tools() {
    download_LinEnum
    download_LinPeas
    download_linuxsmartenumeration
}

function Linux_Privilege_Escalation_Tools() {
    clear
    echo -e "${GREEN}"
    cat << "EOF"
.____    .__                      __________        .__        ___________              
|    |   |__| ____  __ _____  ___ \______   \_______|__|__  __ \_   _____/ ______ ____  
|    |   |  |/    \|  |  \  \/  /  |     ___/\_  __ \  \  \/ /  |    __)_ /  ___// ___\ 
|    |___|  |   |  \  |  />    <   |    |     |  | \/  |\   /   |        \\___ \\  \___ 
|_______ \__|___|  /____//__/\_ \  |____|     |__|  |__| \_/   /_______  /____  >\___  >
        \/       \/            \/                                      \/     \/     \/ 
EOF
    echo -e "${GREEN}\n Select an option from menu:${NC}"
    echo -e "${GREEN}\nKey     Menu Option:"${NC}
    echo -e "---     -------------------------"
    echo -e "${GREEN} 1   -  Download/Install All Tools${NC}"
    echo -e "${GREEN} 2   -  Download LinEnum${NC}"
    echo -e "${GREEN} 3   -  Download linPEAS${NC}"
    echo -e "${GREEN} 4   -  Download LinuxSmartEnumeration${NC}"
    echo -e "${GREEN} 5   -  Back${NC}"
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) download_install_all_Linux_Privilege_Escalation_tools; Linux_Privilege_Escalation_Tools;;
        2) download_LinEnum; Linux_Privilege_Escalation_Tools;;
        3) download_LinPeas; Linux_Privilege_Escalation_Tools;;
        4) download_linuxsmartenumeration; Linux_Privilege_Escalation_Tools;;
        5) main_menu;;
        *) echo "Invalid option"; Linux_Privilege_Escalation_Tools;;
    esac
}

# --[ API Pentesting tools ]--
function install_mitmproxy2swagger() {
    if command -v mitmproxy2swagger &> /dev/null; then
        echo -e "${RED}mitmproxy2swagger is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing mitmproxy2swagger${NC}"
        pip3 install mitmproxy2swagger
        echo -e "${GREEN}mitmproxy2swagger installed successfully.${NC}"
    fi
    sleep 2
}

function install_postman() {
    sudo mkdir -p '/opt/evilkali/api'
    if [ -d "/opt/evilkali/api/Postman" ]; then
        echo -e "${RED}Postman is already installed.${NC}"
    else
        echo -e "${YELLOW}Downloading and installing latest Postman${NC}"
        sudo wget https://dl.pstmn.io/download/latest/linux64 -O postman-linux-x64.tar.gz
        sudo tar -zxvf postman-linux-x64.tar.gz -C /opt/evilkali/api
        sudo rm -rf postman-linux-x64.tar.gz
        create_symlink /opt/evilkali/api/Postman/Postman /usr/bin/postman
        echo -e "${GREEN}Postman installed successfully.${NC}"
    fi
    sleep 2
}

function install_jwt_tool() {
    sudo mkdir -p '/opt/evilkali/api'
    if [ -d "/opt/evilkali/api/jwt_tool" ]; then
        echo -e "${RED}jwt_tool is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing jwt_tool${NC}"
        sudo git clone https://github.com/ticarpi/jwt_tool.git /opt/evilkali/api/jwt_tool
        sudo pip3 install -r /opt/evilkali/api/jwt_tool/requirements.txt
        sudo chmod +x /opt/evilkali/api/jwt_tool/jwt_tool.py
        create_symlink /opt/evilkali/api/jwt_tool/jwt_tool.py /usr/bin/jwt_tool
        echo -e "${GREEN}jwt_tool installed successfully.${NC}"
    fi
    sleep 2
}

function install_kiterunner() {
    sudo mkdir -p '/opt/evilkali/api'
    if [ -d "/opt/evilkali/api/kiterunner" ]; then
        echo -e "${RED}kiterunner is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing kiterunner${NC}"
        sudo git clone https://github.com/assetnote/kiterunner.git /opt/evilkali/api/kiterunner
        sudo make -C /opt/evilkali/api/kiterunner build
        create_symlink /opt/evilkali/api/kiterunner/dist/kr /usr/bin/kr
        echo -e "${GREEN}kiterunner installed successfully.${NC}"
    fi
    sleep 2
}

function install_arjun() {
    sudo mkdir -p '/opt/evilkali/api'
    if [ -d "/opt/evilkali/api/Arjun" ]; then
        echo -e "${RED}Arjun is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing Arjun${NC}"
        sudo git clone https://github.com/s0md3v/Arjun.git /opt/evilkali/api/Arjun
        cd /opt/evilkali/api/Arjun && sudo python3 setup.py install
        echo -e "${GREEN}Arjun installed successfully.${NC}"
    fi
    sleep 2
}

function download_install_all_API_tools() {
    install_mitmproxy2swagger
    install_postman
    install_jwt_tool
    install_kiterunner
    install_arjun
}

function API_Tools() {
    clear
    echo -e "${GREEN}"
    cat << "EOF"
   _____ __________.___  __________               __                   __  .__                
  /  _  \\______   \   | \______   \ ____   _____/  |_  ____   _______/  |_|__| ____    ____  
 /  /_\  \|     ___/   |  |     ___// __ \ /    \   __\/ __ \ /  ___/\   __\  |/    \  / ___\ 
/    |    \    |   |   |  |    |   \  ___/|   |  \  | \  ___/ \___ \  |  | |  |   |  \/ /_/  >
\____|__  /____|   |___|  |____|    \___  >___|  /__|  \___  >____  > |__| |__|___|  /\___  / 
        \/                              \/     \/          \/     \/               \//_____/  
EOF
    echo -e "${GREEN}\n Select an option from menu:${NC}"
    echo -e "${GREEN}\nKey     Menu Option:"${NC}
    echo -e "---     -------------------------"
    echo -e "${GREEN} 1   -  Download/Install All Tools${NC}"
    echo -e "${GREEN} 2   -  Install mitmproxy2swagger${NC}"
    echo -e "${GREEN} 3   -  Install postman ${NC}"
    echo -e "${GREEN} 4   -  install jwt tool${NC}"
    echo -e "${GREEN} 5   -  Install kiterunner${NC}"
    echo -e "${GREEN} 6   -  Install arjun${NC}"
    echo -e "${GREEN} 7   -  Back${NC}"
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) download_install_all_API_tools; API_Tools;;
        2) install_mitmproxy2swagger; API_Tools;;
        3) install_postman; API_Tools;;
        4) install_jwt_tool; API_Tools;;
        5) install_kiterunner; API_Tools;;
        6) install_arjun; API_Tools;;
        7) main_menu;;
        *) echo "Invalid option"; API_Tools;;
    esac
}

# --[ Mobile Application Penetration Testing Tools ]--

function install_aapt() {
    if command -v aapt &> /dev/null; then
        echo -e "${RED}aapt is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing aapt${NC}"
        sudo apt install aapt -y
        echo -e "${GREEN}aapt installed successfully.${NC}"
    fi
    sleep 2
}

function install_apktool() {
    if command -v apktool &> /dev/null; then
        echo -e "${RED}apktool is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing apktool${NC}"
        sudo apt install apktool -y
        echo -e "${GREEN}apktool installed successfully.${NC}"
    fi
    sleep 2
}

function install_adb() {
    if command -v adb &> /dev/null; then
        echo -e "${RED}adb is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing adb${NC}"
        sudo apt install adb -y
        echo -e "${GREEN}adb installed successfully.${NC}"
    fi
    sleep 2
}

function install_apksigner() {
    if command -v apksigner &> /dev/null; then
        echo -e "${RED}apksigner is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing apksigner${NC}"
        sudo apt install apksigner -y
        echo -e "${GREEN}apksigner installed successfully.${NC}"
    fi
    sleep 2
}

function install_zipalign() {
    if command -v zipalign &> /dev/null; then
        echo -e "${RED}zipalign is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing zipalign${NC}"
        sudo apt install zipalign -y
        echo -e "${GREEN}zipalign installed successfully.${NC}"
    fi
    sleep 2
}

function install_wkhtmltopdf() {
    if command -v wkhtmltopdf &> /dev/null; then
        echo -e "${RED}wkhtmltopdf is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing wkhtmltopdf${NC}"
        sudo apt install wkhtmltopdf -y
        echo -e "${GREEN}wkhtmltopdf installed successfully.${NC}"
    fi
    sleep 2
}

function install_default-jdk() {
    if command -v default-jdk &> /dev/null; then
        echo -e "${RED}default-jdk is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing default-jdk${NC}"
        sudo apt install default-jdk -y
        echo -e "${GREEN}default-jdk installed successfully.${NC}"
    fi
    sleep 2
}

function install_jadx() {
    if command -v jadx &> /dev/null; then
        echo -e "${RED}jadx is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing jadx${NC}"
        sudo apt install jadx -y
        echo -e "${GREEN}jadx installed successfully.${NC}"
    fi
    sleep 2
}
    
function install_MobSF() {
    sudo mkdir -p '/opt/evilkali/mobile_app'

    # Check if MobSF is already installed
    if [ -d "/opt/evilkali/mobile_app/MobSF" ]; then
        echo -e "${RED}Mobile-Security-Framework-MobSF is already installed via GitHub.${NC}"
    elif sudo docker images | grep -q 'opensecurity/mobile-security-framework-mobsf'; then
        echo -e "${RED}Mobile-Security-Framework-MobSF Docker image is already present.${NC}"

        # Ask for creating run script if not already there
        if [ ! -f "/opt/evilkali/mobile_app/run_mobsf.sh" ]; then
            echo ""
            echo -e "${YELLOW}Would you like to have the following script to run MobSF Docker container?:${NC}"
            echo -e "${GREEN}
#!/bin/bash
read -p \"Would you like to start MobSF? [Y/n] \" response
if [[ \"\$response\" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest
else
    echo \"MobSF will not be started. Run this script again if you change your mind.\"
fi
${NC}"
            read -p "I will save it under this path "/opt/evilkali/mobile_app" choose [Y/n] " response
            if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
            then
                echo -e "${YELLOW}Creating script to run MobSF Docker container${NC}"
                cat << EOF > /opt/evilkali/mobile_app/run_mobsf.sh
#!/bin/bash
read -p "Would you like to start MobSF? [Y/n] " response
if [[ "\$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest
else
    echo "MobSF will not be started. Run this script again if you change your mind."
fi
EOF
                sudo chmod +x /opt/evilkali/mobile_app/run_mobsf.sh
                echo -e "${GREEN}Script created successfully. Run /opt/evilkali/mobile_app/run_mobsf.sh to start MobSF.${NC}"
            fi
        fi

    else
        echo -e "For the tool ${BLUE}MobSF${NC} would you like to clone from ${BLUE}GitHub${NC} or pull from ${BLUE}Docker${NC}?"
        echo ""
        echo -e "1) Clone from ${BLUE}GitHub${NC}"
        echo -e "2) Pull from ${BLUE}Docker${NC}"
        echo ""
        read -p "Please select an option: " choice

        case $choice in
            1)
                echo -e "${YELLOW}Downloading and installing Mobile-Security-Framework-MobSF${NC}"
                sudo git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF '/opt/evilkali/mobile_app/MobSF'
                sudo chmod +x /opt/evilkali/mobile_app/MobSF/*.sh
                cd /opt/evilkali/mobile_app/MobSF/
                ./setup.sh
                echo -e "${GREEN}Mobile-Security-Framework-MobSF installed successfully.${NC}"
                ;;
            2)
                echo -e "${YELLOW}Pulling Mobile-Security-Framework-MobSF from Docker${NC}"
                sudo docker pull opensecurity/mobile-security-framework-mobsf:latest
                echo -e "${GREEN}Mobile-Security-Framework-MobSF Docker image pulled successfully.${NC}"
                ;;
            *)
                echo -e "${RED}Invalid option selected.${NC}"
                ;;
        esac
    fi

    sleep 2
}

function download_install_all_Mobile_App_tools() {
    install_aapt
    install_apktool
    install_adb
    install_apksigner
    install_zipalign
    install_wkhtmltopdf
    install_default-jdk
    install_jadx
    install_MobSF
}

function Mobile_App_Tools() {
    clear
    echo -e "${GREEN}"
    cat << "EOF"
   _____        ___.   .__.__              _____                  ___________           .__          
  /     \   ____\_ |__ |__|  |   ____     /  _  \ ______ ______   \__    ___/___   ____ |  |   ______
 /  \ /  \ /  _ \| __ \|  |  | _/ __ \   /  /_\  \\____ \\____ \    |    | /  _ \ /  _ \|  |  /  ___/
/    Y    (  <_> ) \_\ \  |  |_\  ___/  /    |    \  |_> >  |_> >   |    |(  <_> |  <_> )  |__\___ \ 
\____|__  /\____/|___  /__|____/\___  > \____|__  /   __/|   __/    |____| \____/ \____/|____/____  >
        \/           \/             \/          \/|__|   |__|                                     \/ 
EOF
    echo -e "${GREEN}\n Select an option from menu:${NC}"
    echo -e "${GREEN}\nKey     Menu Option:"${NC}
    echo -e "---     -------------------------"
    echo -e "${GREEN} 1   -  Download/Install All Tools${NC}"
    echo -e "${GREEN} 2   -  Install aapt${NC}"
    echo -e "${GREEN} 3   -  Install apktool ${NC}"
    echo -e "${GREEN} 4   -  install adb${NC}"
    echo -e "${GREEN} 5   -  Install apksigner${NC}"
    echo -e "${GREEN} 6   -  Install zipalign${NC}"
    echo -e "${GREEN} 7   -  Install wkhtmltopdf${NC}"
    echo -e "${GREEN} 8   -  Install default-jdk${NC}"
    echo -e "${GREEN} 9   -  Install jadx${NC}"
    echo -e "${GREEN} 10  -  Install MobFS${NC}"
    echo -e "${GREEN} 11  -  Back${NC}"
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) download_install_all_Mobile_App_tools; Mobile_App_Tools;;
        2) install_aapt; Mobile_App_Tools;;
        3) install_apktool; Mobile_App_Tools;;
        4) install_adb; Mobile_App_Tools;;
        5) install_apksigner; Mobile_App_Tools;;
        6) install_zipalign; Mobile_App_Tools;;
        7) install_wkhtmltopdf; Mobile_App_Tools;;
        8) install_default-jdk; Mobile_App_Tools;;
        9) install_jadx; Mobile_App_Tools;;
        10) install_MobSF; Mobile_App_Tools;;
        11) main_menu;;
        *) echo "Invalid option"; Mobile_App_Tools;;
    esac
}

# --[ Reporting tools ]--
function download_pwndoc() {
    sudo mkdir -p '/opt/evilkali/reporting/'
    if [ -d "/opt/evilkali/reporting/pwndoc" ]; then
        echo -e "${RED}pwndoc is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading pwndoc${NC}"
        sudo git clone 'https://github.com/pwndoc/pwndoc.git' '/opt/evilkali/reporting/pwndoc' 
        echo -e "${GREEN}pwndoc downloaded successfully.${NC}"
    fi
    sleep 2
}

function download_ghostwriter() {
    sudo mkdir -p '/opt/evilkali/reporting/'
    if [ -d "/opt/evilkali/reporting/ghostwriter" ]; then
        echo -e "${RED}ghostwriter is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading ghostwriter${NC}"
        sudo git clone 'https://github.com/GhostManager/Ghostwriter.git' '/opt/evilkali/reporting/ghostwriter' 
        echo -e "${GREEN}ghostwriter downloaded successfully.${NC}"
    fi
    sleep 2
}

function install_OSCP-Reporting() {
    sudo mkdir -p '/opt/evilkali/reporting/'
    if [ -d "/opt/evilkali/reporting/OSCP-Reporting" ]; then
        echo -e "${RED}OSCP-Reporting is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Installing OSCP-Reporting${NC}"
        sudo curl -s https://docs.sysreptor.com/install.sh | bash
        sudo rm -rf /opt/sysreptor.tar.gz
        echo -e "${GREEN}OSCP-Reporting installed successfully.${NC}"
    fi
    sleep 2
}

function download_install_all_Reporting_tools() {
    download_pwndoc
    download_ghostwriter
    install_OSCP-Reporting
}

function Reporting_Tools() {
    clear
    echo -e "${GREEN}"
    cat << "EOF"
__________                             __  .__                
\______   \ ____ ______   ____________/  |_|__| ____    ____  
 |       _// __ \\____ \ /  _ \_  __ \   __\  |/    \  / ___\ 
 |    |   \  ___/|  |_> >  <_> )  | \/|  | |  |   |  \/ /_/  >
 |____|_  /\___  >   __/ \____/|__|   |__| |__|___|  /\___  / 
        \/     \/|__|                              \//_____/  
EOF
    echo -e "${GREEN}\n Select an option from menu:${NC}"
    echo -e "${GREEN}\nKey     Menu Option:"${NC}
    echo -e "---     -------------------------"
    echo -e "${GREEN} 1   -  Download/Install All Tools${NC}"
    echo -e "${GREEN} 2   -  Download pwndoc${NC}"
    echo -e "${GREEN} 3   -  Download ghostwriter${NC}"
    echo -e "${GREEN} 4   -  Install OSCP-Reporting${NC}"
    echo -e "${GREEN} 5   -  Back${NC}"
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) download_install_all_Reporting_tools; Reporting_Tools;;
        2) download_pwndoc; Reporting_Tools;;
        3) download_ghostwriter; Reporting_Tools;;
        4) install_OSCP-Reporting; Reporting_Tools;;
        5) main_menu;;
        *) echo "Invalid option"; Reporting_Tools;;
    esac
}

# --[ Function to install from 3 through 11 tools ]
function install_from_3_through_10() {
    install_all_recon_tools
    install_all_vulnerability_scanners
    install_all_file_trasfer_tools
    download_install_all_phishing_tools
    download_Ghostpack
    install_all_Evasion_tools
    download_install_all_Windows_Privilege_Escalation_tools
    download_install_all_Linux_Privilege_Escalation_tools
}

function main_menu() {
    clear
    echo -e "${GREEN}"
    cat << "EOF"
___________     .__.__   ____  __.      .__  .__ 
\_   _____/__  _|__|  | |    |/ _|____  |  | |__|
 |    __)_\  \/ /  |  | |      < \__  \ |  | |  |
 |        \\   /|  |  |_|    |  \ / __ \|  |_|  |
/_______  / \_/ |__|____/____|__ (____  /____/__|
        \/                      \/    \/         
                                By YoruYagami
EOF
    echo -e "${GREEN}\n Select an option from menu:${NC}"
    echo -e "${GREEN}\nKey     Menu Option:"${NC}
    echo -e "---     -------------------------"
    echo -e "${GREEN} 1   -  Download/Install All Tools${NC}"
    echo -e "${GREEN} 2   -  Command and Control Frameworks${NC}"
    echo -e "${GREEN} 3   -  Reconnaissance${NC}"
    echo -e "${GREEN} 4   -  Phishing${NC}"
    echo -e "${GREEN} 5   -  Vulnerability Scanners${NC}"
    echo -e "${GREEN} 6   -  File Trasferer tools${NC}"
    echo -e "${GREEN} 7   -  Ghostpack Compiled Binaries${NC}"
    echo -e "${GREEN} 8   -  Evasion Tools${NC}"
    echo -e "${GREEN} 9   -  Windows Privilege Escaltion Tools${NC}"
    echo -e "${GREEN} 10  -  Linux Privilege Escaltion Tools${NC}"
    echo -e "${GREEN} 11  -  API Penenetration Testing Tools${NC}"
    echo -e "${GREEN} 12  -  Mobile Application Penetration Testing Tools${NC}"
    echo -e "${GREEN} 13  -  Reporting${NC}"
    echo ""
    echo -e "${GREEN} A   -  Download/Install all tools from 3 through 10${NC}"
    echo ""
    echo -e "${GREEN} 99  -  Quit${NC}"
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) download_install_all_c2_tools; install_all_recon_tools; install_all_vulnerability_scanners; install_all_file_trasfer_tools; download_install_all_phishing_tools; download_Ghostpack; install_all_Evasion_tools; download_install_all_Windows_Privilege_Escalation_tools; download_install_all_Linux_Privilege_Escalation_tools; download_install_all_API_tools; download_install_all_Mobile_App_tools; download_install_all_Reporting_tools; main_menu;;
        2) command_and_control;;
        3) reconnaissance;;
        4) phishing;;
        5) vulnerability_scanners;;
        6) File_Trasfer_Tools;;
        7) download_Ghostpack; main_menu;;
        8) Evasion_Tools;;
        9) Windows_Privilege_Escalation_Tools;;
        10) Linux_Privilege_Escalation_Tools;;
        11) API_Tools;;
        12) Mobile_App_Tools;;
        13) Reporting_Tools;;
        99) exit;;
        A) install_from_3_through_10; main_menu;;
        *) echo "Invalid option"; main_menu;;
    esac
}

main_menu