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

# Ask the user if they want to enable tmux auto-start
echo ""
read -p "Do you prefer to have tmux automatically enabled when the terminal is launched? (y/n)" -n 1 -r
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
read -p "Do you want to update/upgrade the system first? (highly recommended) (y/n)" -n 1 -r
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
        echo -e "${BLUE}Skipping auto-start of tmux.${NC}"
    fi
else
    echo -e "The command to automatically start tmux is already present in ${BLUE}$CONFIG_FILE${NC}."
fi

# List of essentials packages to check
essentials=(python3 neovim wget git unzip php openssh-client golang-go)

# Function to check if a command is available
is_command() {
    command -v $1
}

# Check and install some essentials packages
for pkg in "${essentials[@]}"; do
    if is_command $pkg; then
        echo -e "${GREEN}$pkg already installed.${NC}"
    else
        echo "${RED}$pkg is not installed.${NC}${GREEN}installing for you...${NC}"
        sudo apt install $pkg -y  
    fi
done

# --[ Command and Control ]--
function download_villain() {
    sudo mkdir -p '/opt/evilkali/C2'
    if [ -d "/opt/evilkali/C2/Villain" ]; then
        echo -e "${RED}Villain is already installed.${NC}"
    else
        echo -e "${YELLOW}Downloading Villain...${NC}"
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
        echo -e "${YELLOW}Downloading Covenant...${NC}"
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
        echo -e "${YELLOW}Downloading AM0N_Eye...${NC}"
        sudo git clone 'https://github.com/S3N4T0R-0X0/AMON-Eye.git' '/opt/evilkali/C2/AM0N-Eye' 
        echo -e "${GREEN}AM0N_Eye downloaded successfully.${NC}"
    fi
    sleep 2
}

function download_Havoc() {
    sudo mkdir -p '/opt/evilkali/C2'
    if [ ! -d "/opt/evilkali/C2/Havoc" ]; then
        echo -e "${YELLOW}Downloading Havoc Framework...${NC}"
        sudo git clone 'https://github.com/HavocFramework/Havoc.git' '/opt/evilkali/C2/Havoc' 
        echo -e "${GREEN}Havoc Framework downloaded successfully.${NC}"
    else
        echo -e "${RED}Havoc Framework is already installed.${NC}"
    fi
    sleep 2
}

function install_sliver() {
    if command -v sliver; then
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
        sudo pip3 install pwncat-cs 
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
    echo -e "${RED}"
    cat << "EOF"
_________  ________   ___________                                                __    
\_   ___ \ \_____  \  \_   _____/___________    _____   ______  _  _____________|  | __
/    \  \/  /  ____/   |    __) \_  __ \__  \  /     \_/ __ \ \/ \/ /  _ \_  __ \  |/ /
\     \____/       \   |     \   |  | \// __ \|  Y Y  \  ___/\     (  <_> )  | \/    < 
 \______  /\_______ \  \___  /   |__|  (____  /__|_|  /\___  >\/\_/ \____/|__|  |__|_ \
        \/         \/      \/               \/      \/     \/                        \/

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
    sudo mkdir -p '/opt/evilkali/windows'
    if [ -f "/opt/evilkali/windows/PowerView.ps1" ]; then
        echo -e "${RED}PowerView has already been copied.${NC}"
    else
        sudo cp '/usr/share/windows-resources/powersploit/Recon/PowerView.ps1' '/opt/evilkali/windows/PowerView.ps1'
        sudo wget -q 'https://raw.githubusercontent.com/lucky-luk3/ActiveDirectory/master/PowerView-Dev.ps1' -O '/opt/tools/windows/PowerView-Dev.ps1' 
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
        echo -e "${YELLOW}Installing bloodhound...${NC}"
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
        echo -e "${YELLOW}Downloading SharpHound...${NC}"
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
    echo -e "${RED}"
    cat << "EOF"
__________                                         .__                                    
\______   \ ____   ____  ____   ____   ____ _____  |__| ___________    ____   ____  ____  
 |       _// __ \_/ ___\/  _ \ /    \ /    \\__  \ |  |/  ___/\__  \  /    \_/ ___\/ __ \ 
 |    |   \  ___/\  \__(  <_> )   |  \   |  \/ __ \|  |\___ \  / __ \|   |  \  \__\  ___/ 
 |____|_  /\___  >\___  >____/|___|  /___|  (____  /__/____  >(____  /___|  /\___  >___  >
        \/     \/     \/           \/     \/     \/        \/      \/     \/     \/    \/ 
EOF
    echo ""
    echo -e "${BLUE}1. Download/Install All Tools${NC}"
    echo -e "${BLUE}2. Get PowerView${NC}"
    echo -e "${BLUE}3. Download SharpHound${NC}"
    echo -e "${BLUE}4. Download ADModule${NC}"
    echo -e "${BLUE}5. Install BloodHound${NC}"
    echo -e "${BLUE}6. Get Invoke_Portscan.ps1${NC}"
    echo -e "${BLUE}7. Back${NC}"
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
        echo -e "${YELLOW}Downloading linwinpwn...${NC}"
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
    echo -e "${RED}"
    cat << "EOF"
____   ____    .__             _________                                         
\   \ /   /_ __|  |   ____    /   _____/ ____ _____    ____   ____   ___________ 
 \   Y   /  |  \  |  /    \   \_____  \_/ ___\\__  \  /    \ /    \_/ __ \_  __ \
  \     /|  |  /  |_|   |  \  /        \  \___ / __ \|   |  \   |  \  ___/|  | \/
   \___/ |____/|____/___|  / /_______  /\___  >____  /___|  /___|  /\___  >__|   
                         \/          \/     \/     \/     \/     \/     \/       
EOF
    echo ""
    echo -e "${BLUE}1. Download/Install All Tools${NC}"
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
    if command -v evilginx2; then
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
        echo -e "${YELLOW}Downloading gophish...${NC}"
        sudo git clone 'https://github.com/gophish/gophish.git' '/opt/evilkali/phishing/gophish'
        echo -e "${GREEN}gophish downloaded successfully.${NC}"
    fi

    if [ -f "/opt/evilkali/phishing/gophish/gophish" ]; then
        echo -e "${RED}gophish is already built.${NC}"
    else
        cd '/opt/evilkali/phishing/gophish'
        echo -e "${YELLOW}Building gophish...${NC}"
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
        echo -e "${YELLOW}Downloading PyPhisher...${NC}"
        sudo git clone 'https://github.com/KasRoudra/PyPhisher.git' '/opt/evilkali/phishing/PyPhisher'>/dev/null 2>&1
        echo -e "${GREEN}PyPhisher downloaded successfully.${NC}"
    fi
    
    if [ -f "/opt/evilkali/phishing/PyPhisher/files/requirements.txt" ]; then
        echo -e "${RED}Requirements of PyPhisher are already installed.${NC}"
    else
        echo -e "${YELLOW}Installing PyPhisher requirements...${NC}"
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
    echo -e "${RED}"
    cat << "EOF"

__________.__    .__       .__    .__                 ___________           .__          
\______   \  |__ |__| _____|  |__ |__| ____    ____   \__    ___/___   ____ |  |   ______
 |     ___/  |  \|  |/  ___/  |  \|  |/    \  / ___\    |    | /  _ \ /  _ \|  |  /  ___/
 |    |   |   Y  \  |\___ \|   Y  \  |   |  \/ /_/  >   |    |(  <_> |  <_> )  |__\___ \ 
 |____|   |___|  /__/____  >___|  /__|___|  /\___  /    |____| \____/ \____/|____/____  >
               \/        \/     \/        \//_____/                                   \/ 

EOF
    echo -e ""
    echo -e "${BLUE}1. Download/Install All Tools${NC}"
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
    sudo mkdir -p '/opt/evilkali/windows'
    if [ -d "/opt/evilkali/windows/hfs-windows" ]; then
        echo -e "${RED}HFS is already downloaded.${NC}"

        if [ -d "/opt/evilkali/windows/hfs-windows/plugins/" ]; then
            echo -e "${GREEN}HFS plugins folder removed successfully.${NC}"
        else
            echo -e "${RED}HFS plugins folder does not exist or has already been removed.${NC}"
        fi
    else
        echo -e "${YELLOW}Downloading HFS...${NC}"
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
    if command -v updog; then
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
    echo -e "${RED}"
    cat << "EOF"
___________.__.__           ___________                       _____             
\_   _____/|__|  |   ____   \__    ___/___________    _______/ ____\___________ 
 |    __)  |  |  | _/ __ \    |    |  \_  __ \__  \  /  ___/\   __\/ __ \_  __ \
 |     \   |  |  |_\  ___/    |    |   |  | \// __ \_\___ \  |  | \  ___/|  | \/
 \___  /   |__|____/\___  >   |____|   |__|  (____  /____  > |__|  \___  >__|   
     \/                 \/                        \/     \/            \/       
EOF
    echo -e "${GREEN}--[ File Trasfer Tools ]--${NC}"
    echo -e "${BLUE}1. Download/Install All Tools${NC}"
    echo -e "${BLUE}2. Download HFS${NC}"
    echo -e "${BLUE}3. Get nc.exe${NC}"
    echo -e "${BLUE}4. Install Updog${NC}"
    echo -e "${BLUE}5. Back${NC}"
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
        echo -e "${YELLOW}Downloading Freeze...${NC}"
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
        echo -e "${YELLOW}Downloading Invisi-Shell...${NC}"
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
    echo -e "${RED}"
    cat << "EOF"
___________                    .__               
\_   _____/__  _______    _____|__| ____   ____  
 |    __)_\  \/ /\__  \  /  ___/  |/  _ \ /    \ 
 |        \\   /  / __ \_\___ \|  (  <_> )   |  \
/_______  / \_/  (____  /____  >__|\____/|___|  /
        \/            \/     \/               \/ 

EOF
    echo ""
    echo -e "${BLUE}1. Download/Install All Tools${NC}"
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
    sudo mkdir -p '/opt/evilkali/windows/'
    if [ -f "/opt/evilkali/windows/PowerUp.ps1" ]; then
        echo -e "${YELLOW}PowerUp.ps1 is already copied.${NC}"
    else
        echo -e "${YELLOW}copying PowerUp.ps1...${NC}"
        sudo cp '/usr/share/windows-resources/powersploit/Privesc/PowerUp.ps1' '/opt/evilkali/windows/PowerUp.ps1'
        echo -e "${GREEN}PowerUp has been copied successfully.${NC}"
    fi
}

function download_PowerUpSQL() {
    sudo mkdir -p '/opt/evilkali/windows/'
    if [ -f "/opt/evilkali/windows/PowerUpSQL.ps1" ] && [ -f "/opt/evilkali/windows/PowerUpSQL.psd1" ] && [ -f "/opt/evilkali/windows/PowerUpSQL.psm1" ]; then
        echo -e "${RED}PowerUpSQL is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading PowerUpSQL...${NC}"
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
        echo -e "${YELLOW}copying Get_System.ps1...${NC}"
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
 __      __.__            .___                    __________        .__        ___________              
/  \    /  \__| ____    __| _/______  _  ________ \______   \_______|__|__  __ \_   _____/ ______ ____  
\   \/\/   /  |/    \  / __ |/  _ \ \/ \/ /  ___/  |     ___/\_  __ \  \  \/ /  |    __)_ /  ___// ___\ 
 \        /|  |   |  \/ /_/ (  <_> )     /\___ \   |    |     |  | \/  |\   /   |        \\___ \\  \___ 
  \__/\  / |__|___|  /\____ |\____/ \/\_//____  >  |____|     |__|  |__| \_/   /_______  /____  >\___  >
       \/          \/      \/                 \/                                       \/     \/     \/ 

EOF
    echo ""
    echo -e "${BLUE}1. Download/Install All Tools${NC}"
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

# --[ GhostPack Compiled Binaries ]--
function download_Ghostpack() {
    sudo mkdir -p '/opt/evilkali/windows/'
    if [ -d "/opt/evilkali/windows/Ghostpack-CompiledBinaries" ]; then
        echo -e "${RED}Ghostpack Compiled Binaries is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading Compiled GhostPack Binaries${NC}"
        sudo git clone 'https://github.com/r3motecontrol/Ghostpack-CompiledBinaries.git' '/opt/evilkali/Ghostpack/'
        sudo cp -r '/opt/evilkali/Ghostpack/*' '/opt/evilkali/windows/'
        sudo rm -r '/opt/evilkali/Ghostpack'
        sudo rm -rf '/opt/evilkali/windows/README.md'
        echo -e "${GREEN}Ghostpack downloaded successfully.${NC}"
    fi
}

function main_menu() {
    clear
    echo -e "${RED}"
    cat << "EOF"
___________     .__.__   ____  __.      .__  .__ 
\_   _____/__  _|__|  | |    |/ _|____  |  | |__|
 |    __)_\  \/ /  |  | |      < \__  \ |  | |  |
 |        \\   /|  |  |_|    |  \ / __ \|  |_|  |
/_______  / \_/ |__|____/____|__ (____  /____/__|
        \/                      \/    \/         
                                By YoruYagami
EOF
    echo ""
    echo -e "${BLUE}1. Download/Install All Tools${NC}"
    echo -e "${BLUE}2. Command and Control Frameworks${NC}"
    echo -e "${BLUE}3. Reconnaissance${NC}"
    echo -e "${BLUE}4. Phishing${NC}"
    echo -e "${BLUE}5. Vulnerability Scanners${NC}"
    echo -e "${BLUE}6. File Trasferer tools${NC}"
    echo -e "${BLUE}7. Ghostpack Compiled Binaries${NC}"
    echo -e "${BLUE}8. Evasion Tools${NC}"
    echo -e "${BLUE}9. Windows Privilege Escaltion Tools${NC}"
    echo ""
    echo -e "${BLUE}99. Quit${NC}"
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) download_install_all_c2_tools; install_all_recon_tools; install_all_vulnerability_scanners; install_all_file_trasfer_tools; download_install_all_phishing_tools; download_Ghostpack; install_all_Evasion_tools main_menu;;
        2) command_and_control;;
        3) reconnaissance;;
        4) phishing;;
        5) vulnerability_scanners;;
        6) File_Trasfer_Tools;;
        7) download_Ghostpack;;
        8) Evasion_Tools;;
        9) Windows_Privilege_Escalation_Tools;;
        99) exit;;
        *) echo "Invalid option"; main_menu;;
    esac
}

main_menu
