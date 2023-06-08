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

# Detect user's default shell
DEFAULT_SHELL=$(basename "$SHELL")

# Select the configuration file based on the default shell
if [ "$DEFAULT_SHELL" = "bash" ]; then
    CONFIG_FILE="$HOME/.bashrc"
elif [ "$DEFAULT_SHELL" = "zsh" ]; then
    CONFIG_FILE="$HOME/.zshrc"
else
    echo -e "${RED}Unsupported shell. This script only supports Bash and Zsh.${NC}"
    exit 1
fi

# Prompt user to upgrade system first
echo ""
read -p "Do you want to update/upgrade the system first? (highly recommended) (y/n)" -n 1 -r
echo ''
if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
    if command -v apt-get; then
        sudo apt-get update -y && sudo apt-get -y full-upgrade -y && sudo apt-get -y dist-upgrade -y && sudo apt-get autoremove -y && sudo apt-get clean -y && sudo apt-get install build-essential -y
    elif command -v pacman; then
        sudo pacman -Syu --noconfirm && sudo pacman -Sc --noconfirm && sudo pacman -Rns $(pacman -Qdtq) --noconfirm && sudo pacman -S --needed base-devel -y
    else
        echo -e "${RED}Package manager not found. Please update the system manually.${NC}"
    fi
fi

clear

# Check if tmux is already set to start automatically
if ! grep -q 'if \[ "\$TMUX" = "" \]; then tmux; fi' "/home/$SUDO_USER/.zshrc"; then
    # If it's not, ask the user if they want to automatically start tmux
    echo "Do you want to start tmux automatically when you open the terminal? (y/n)"
    read response

    # Check the user's response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        echo >> "/home/$SUDO_USER/.zshrc"  # Add an empty line
        echo 'if [ "$TMUX" = "" ]; then tmux; fi' >> "/home/$SUDO_USER/.zshrc"
        if [ $? -eq 0 ]; then
            echo "Tmux will now start automatically when you open the terminal."
        else
            echo "An error occurred while trying to modify ~/.zshrc."
        fi
    else
        echo "Tmux will not start automatically when you open the terminal."
    fi
else
    echo "Tmux is already set to start automatically when you open the terminal."
fi

# Map of essentials packages to check to their corresponding commands
declare -A essentials=(
    ["python3"]="python3"
    ["git"]="git"
    ["gobuster"]="gobuster"
    ["docker-compose"]="docker-compose"
    ["docker.io"]="docker"
    ["neovim"]="nvim"
    ["wget"]="wget"
    ["unzip"]="unzip"
    ["php"]="php"
    ["openssh-client"]="ssh"
    ["golang-go"]="go"
    ["sed"]="sed"
    ["curl"]="curl"
    ["openssl"]="openssl"
    ["uuid-runtime"]="uuidgen"
)

create_symlink() {
    source_path=$1
    dest_path=$2
    sudo ln -sf $source_path $dest_path
}

# Function to ask user confirmation
ask_user() {
    echo ""
    echo "The following packages are not installed:${missing[@]}"
    while true; do
        read -p "Do you want me to install all these packages? (y/n) " yn
        case $yn in
            [Yy]* ) 
                for pkg in "${missing[@]}"; do
                    if command -v apt-get; then
                        sudo apt-get install $pkg -y
                    elif command -v pacman; then
                        sudo pacman -S $pkg --noconfirm
                    fi
                done
                break;;
            [Nn]* ) return;;
            * ) echo "Respond yes (y) or no (n).";;
        esac
    done
}

# Initialize an empty array for missing packages
missing=()

# Check essentials packages
for pkg in "${!essentials[@]}"; do
    if command -v ${essentials[$pkg]} &> /dev/null; then
        echo -e "${GREEN}$pkg already installed.${NC}"
    else
        missing+=($pkg)
    fi
done

# If there are missing packages, ask the user
if [ ${#missing[@]} -gt 0 ]; then
    ask_user
fi


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
        sudo git clone 'https://github.com/momika233/AM0N-Eye.git' '/opt/evilkali/C2/AM0N-Eye' 
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
    echo -e ""
    cat << "EOF"
_________  ________   ___________                                                __    
\_   ___ \ \_____  \  \_   _____/___________    _____   ______  _  _____________|  | __
/    \  \/  /  ____/   |    __) \_  __ \__  \  /     \_/ __ \ \/ \/ /  _ \_  __ \  |/ /
\     \____/       \   |     \   |  | \// __ \|  Y Y  \  ___/\     (  <_> )  | \/    < 
 \______  /\_______ \  \___  /   |__|  (____  /__|_|  /\___  >\/\_/ \____/|__|  |__|_ \
        \/         \/      \/               \/      \/     \/                        \/

EOF
        echo -e "\n Select an option from menu:"
    echo -e "\nKey     Menu Option:"
    echo -e "---     -------------------------"
    echo -e " 1   -  Download/Install All Tools"
    echo -e " 2   -  Download Villain"
    echo -e " 3   -  Download Covenant"
    echo -e " 4   -  Download AM0N_Eye"
    echo -e " 5   -  Download Havoc"
    echo -e " 6   -  Install Sliver"
    echo -e " 7   -  Install pwncat-cs"
    echo -e " 8   -  Back"
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
    if dpkg -s bloodhound &> /dev/null; then
        echo -e "${RED}bloodhound is already installed.${NC}"
    else
        if command -v pacman &> /dev/null; then
            echo -e "${YELLOW}Installing bloodhound${NC}"
            sudo pacman -Sy bloodhound --noconfirm
            echo -e "${GREEN}bloodhound installed successfully.${NC}"
        elif command -v apt-get &> /dev/null; then
            echo -e "${YELLOW}Installing bloodhound${NC}"
            sudo apt-get install bloodhound -y
            echo -e "${GREEN}bloodhound installed successfully.${NC}"
        else
            echo -e "${RED}Unable to install bloodhound. Please install it manually.${NC}"
        fi
    fi
    sleep 2
}

function get_Invoke_Portscan_ps1() {
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
    echo -e ""
    cat << "EOF"
__________                                         .__                                    
\______   \ ____   ____  ____   ____   ____ _____  |__| ___________    ____   ____  ____  
 |       _// __ \_/ ___\/  _ \ /    \ /    \\__  \ |  |/  ___/\__  \  /    \_/ ___\/ __ \ 
 |    |   \  ___/\  \__(  <_> )   |  \   |  \/ __ \|  |\___ \  / __ \|   |  \  \__\  ___/ 
 |____|_  /\___  >\___  >____/|___|  /___|  (____  /__/____  >(____  /___|  /\___  >___  >
        \/     \/     \/           \/     \/     \/        \/      \/     \/     \/    \/ 
EOF
    echo -e "\n Select an option from menu:"
    echo -e "\nKey     Menu Option:"
    echo -e "---     -------------------------"
    echo -e " 1   -  Download/Install All Tools"
    echo -e " 2   -  Get PowerView"
    echo -e " 3   -  Download SharpHound"
    echo -e " 4   -  Download ADModule"
    echo -e " 5   -  Install BloodHound"
    echo -e " 6   -  Get Invoke_Portscan.ps1"
    echo -e " 7   -  Back"
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
    echo -e ""
    cat << "EOF"
____   ____    .__             _________                                         
\   \ /   /_ __|  |   ____    /   _____/ ____ _____    ____   ____   ___________ 
 \   Y   /  |  \  |  /    \   \_____  \_/ ___\\__  \  /    \ /    \_/ __ \_  __ \
  \     /|  |  /  |_|   |  \  /        \  \___ / __ \|   |  \   |  \  ___/|  | \/
   \___/ |____/|____/___|  / /_______  /\___  >____  /___|  /___|  /\___  >__|   
                         \/          \/     \/     \/     \/     \/     \/       
EOF
    echo -e "\n Select an option from menu:"
    echo -e "\nKey     Menu Option:"
    echo -e "---     -------------------------"
    echo -e " 1   -  Download/Install All Tools"
    echo -e " 2   -  Download linwinpwn"
    echo -e " 3   -  Back"
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
        if command -v pacman &> /dev/null; then
            echo -e "${YELLOW}Installing evilginx2${NC}"
            sudo pacman -Sy evilginx2 --noconfirm
            echo -e "${GREEN}evilginx2 installed successfully.${NC}"
        elif command -v apt-get &> /dev/null; then
            echo -e "${YELLOW}Installing evilginx2${NC}"
            sudo apt-get install evilginx2 -y
            echo -e "${GREEN}evilginx2 installed successfully.${NC}"
        else
            echo -e "${RED}Unable to install evilginx2. Please install it manually.${NC}"
        fi
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
    echo -e ""
    cat << "EOF"

__________.__    .__       .__    .__                 ___________           .__          
\______   \  |__ |__| _____|  |__ |__| ____    ____   \__    ___/___   ____ |  |   ______
 |     ___/  |  \|  |/  ___/  |  \|  |/    \  / ___\    |    | /  _ \ /  _ \|  |  /  ___/
 |    |   |   Y  \  |\___ \|   Y  \  |   |  \/ /_/  >   |    |(  <_> |  <_> )  |__\___ \ 
 |____|   |___|  /__/____  >___|  /__|___|  /\___  /    |____| \____/ \____/|____/____  >
               \/        \/     \/        \//_____/                                   \/ 

EOF
    echo -e "\n Select an option from menu:"
    echo -e "\nKey     Menu Option:"
    echo -e "---     -------------------------"
    echo -e " 1   -  Download/Install All Tools"
    echo -e " 2   -  Install evilginx2"
    echo -e " 3   -  Download gophish"
    echo -e " 4   -  Download PyPhisher"
    echo -e " 5   -  Back"
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
    echo -e ""
    cat << "EOF"
___________.__.__           ___________                       _____             
\_   _____/|__|  |   ____   \__    ___/___________    _______/ ____\___________ 
 |    __)  |  |  | _/ __ \    |    |  \_  __ \__  \  /  ___/\   __\/ __ \_  __ \
 |     \   |  |  |_\  ___/    |    |   |  | \// __ \_\___ \  |  | \  ___/|  | \/
 \___  /   |__|____/\___  >   |____|   |__|  (____  /____  > |__|  \___  >__|   
     \/                 \/                        \/     \/            \/       
EOF
    echo -e "\n Select an option from menu:"
    echo -e "\nKey     Menu Option:"
    echo -e "---     -------------------------"
    echo -e " 1   -  Download/Install All Tools"
    echo -e " 2   -  Download HFS"
    echo -e " 3   -  Get nc.exe"
    echo -e " 4   -  Install Updog"
    echo -e " 5   -  Back"
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
    echo -e ""
    cat << "EOF"
___________                    .__               
\_   _____/__  _______    _____|__| ____   ____  
 |    __)_\  \/ /\__  \  /  ___/  |/  _ \ /    \ 
 |        \\   /  / __ \_\___ \|  (  <_> )   |  \
/_______  / \_/  (____  /____  >__|\____/|___|  /
        \/            \/     \/               \/ 

EOF
    echo -e "\n Select an option from menu:"
    echo -e "\nKey     Menu Option:"
    echo -e "---     -------------------------"
    echo -e " 1   -  Download/Install All Tools"
    echo -e " 2   -  Download Freeze"
    echo -e " 3   -  Download Invisi_Shell"
    echo -e " 4   -  Back"
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
function get_PowerUp_ps1() {
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
    get_PowerUp_ps1
    download_PowerUpSQL
    get_system
    download_PrivescCheck
    download_WinPEAS
}

function Windows_Privilege_Escalation_Tools() {
    clear
    echo -e ""
    cat << "EOF"
 __      __.__            .___                    __________        .__        ___________              
/  \    /  \__| ____    __| _/______  _  ________ \______   \_______|__|__  __ \_   _____/ ______ ____  
\   \/\/   /  |/    \  / __ |/  _ \ \/ \/ /  ___/  |     ___/\_  __ \  \  \/ /  |    __)_ /  ___// ___\ 
 \        /|  |   |  \/ /_/ (  <_> )     /\___ \   |    |     |  | \/  |\   /   |        \\___ \\  \___ 
  \__/\  / |__|___|  /\____ |\____/ \/\_//____  >  |____|     |__|  |__| \_/   /_______  /____  >\___  >
       \/          \/      \/                 \/                                       \/     \/     \/ 

EOF
    echo -e "\n Select an option from menu:"
    echo -e "\nKey     Menu Option:"
    echo -e "---     -------------------------"
    echo -e " 1   -  Download/Install All Tools"
    echo -e " 2   -  Get PowerUp.ps1"
    echo -e " 3   -  Download PowerUpSQL"
    echo -e " 4   -  Get GetSystem.ps1"
    echo -e " 5   -  Download PrivescCheck.ps1"
    echo -e " 6   -  Download WinPEASany_ofs.exe"
    echo -e " 7   -  Back"
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) download_install_all_Windows_Privilege_Escalation_tools; Windows_Privilege_Escalation_Tools;;
        2) get_PowerUp_ps1; Windows_Privilege_Escalation_Tools;;
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
    echo -e ""
    cat << "EOF"
.____    .__                      __________        .__        ___________              
|    |   |__| ____  __ _____  ___ \______   \_______|__|__  __ \_   _____/ ______ ____  
|    |   |  |/    \|  |  \  \/  /  |     ___/\_  __ \  \  \/ /  |    __)_ /  ___// ___\ 
|    |___|  |   |  \  |  />    <   |    |     |  | \/  |\   /   |        \\___ \\  \___ 
|_______ \__|___|  /____//__/\_ \  |____|     |__|  |__| \_/   /_______  /____  >\___  >
        \/       \/            \/                                      \/     \/     \/ 
EOF
    echo -e "\n Select an option from menu:"
    echo -e "\nKey     Menu Option:"
    echo -e "---     -------------------------"
    echo -e " 1   -  Download/Install All Tools"
    echo -e " 2   -  Download LinEnum"
    echo -e " 3   -  Download linPEAS"
    echo -e " 4   -  Download LinuxSmartEnumeration"
    echo -e " 5   -  Back"
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

# --[ Install and Run kh4sh3i/smartrecon, then remove it ]--
function Bug_Bounty_Tools() {
    	if ! command -v httprobe &> /dev/null; then
        	echo -e "${RED}Installing httprobe now${NC}"
        	go install github.com/tomnomnom/httprobe@latest
        	sudo cp $HOME/go/bin/httprobe /usr/local/bin
        	echo -e "${GREEN}httprobe has been installed${NC}"
    	else
        	echo -e "${GREEN}httprobe is already installed${NC}"
    	fi

	if ! command -v amass &> /dev/null; then
		echo -e "${RED}Installing amass now${NC}"
		go install -v github.com/OWASP/Amass/v3/...@master &> /dev/null
		sudo cp $HOME/go/bin/amass /usr/local/bin
		echo -e "${GREEN}amass has been installed${NC}"
	else
		echo -e "${GREEN}amass is already installed${NC}"
	fi
	
	if ! command -v gobuster &> /dev/null; then
		echo -e "${RED}Installing gobuster now${NC}"
		go install github.com/OJ/gobuster/v3@latest &> /dev/null
		sudo cp $HOME/go/bin/gobuster /usr/local/bin
		echo -e "${GREEN}GoBuster has been installed${NC}"
	else
		echo -e "${GREEN}Gobuster is already installed${NC}"
	fi
		
	if ! command -v subfinder &> /dev/null; then
		echo -e "${RED}Installing subfinder now${NC}"
		go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest &> /dev/null
		sudo cp $HOME/go/bin/subfinder /usr/local/bin
		echo -e "${GREEN}subfinder installation is done${NC}"
	else
		echo -e "${GREEN}subfinder is already installed${NC}"
	fi
	
	if ! command -v assetfinder &> /dev/null; then
		echo -e "${RED}Installing assetfinder now${NC}"
		go install github.com/tomnomnom/assetfinder@latest &> /dev/null
		echo -e "${GREEN}assetfinder has been installed${NC}"
	else
		echo -e "${GREEN}assetfinder is installed${NC}"
	fi
	
	if ! command -v ffuf &> /dev/null; then
		echo -e "${RED}Installing ffuf now${NC}"
		go install github.com/ffuf/ffuf@latest
		cp $HOME/go/bin/ffuf /usr/local/bin
		echo -e "${GREEN}ffuf has been installed${NC}"
	else
		echo -e "${GREEN}ffuf is already installed${NC}"
	fi
	
	if ! command -v gf &> /dev/null; then
		echo -e "${RED}Installing gf now${NC}"
		go install github.com/tomnomnom/gf@latest &> /dev/null
		cp $HOME/go/bin/gf /usr/local/bin
		echo -e "${GREEN}gf has been installed${NC}"
	else
		echo -e "${GREEN}gf is already installed${NC}"
	fi
	
	if ! command -v meg &> /dev/null; then
		echo -e "${RED}Installing meg now${NC}"
		go install github.com/tomnomnom/meg@latest &> /dev/null
		cp $HOME/go/bin/meg /usr/local/bin
		echo -e "${GREEN}meg has been installed${NC}"
	else
		echo -e "${GREEN}meg is already installed${NC}"
	fi
	
	if ! command -v waybackurls &> /dev/null; then
		echo -e "${RED}Installing waybackurls now${NC}"
		go install github.com/tomnomnom/waybackurls@latest &> /dev/null
		cp $HOME/go/bin/waybackurls /usr/local/bin
		echo -e "${GREEN}waybackurls has been installed${NC}"
	else
		echo -e "${GREEN}waybackurls is already installed${NC}"
	fi
	
	if ! command -v subzy &> /dev/null; then
		go install -v github.com/LukaSikic/subzy@latest &> /dev/null
		sudo cp $HOME/go/bin/subzy /usr/local/bin
		echo -e "${GREEN}subzy has been installed${NC}"
	else
		echo -e "${GREEN}subzy is already installed${NC}"
	fi
	
	if ! command -v asnmap -h &> /dev/null; then
		echo -e "${RED}Installing asnmap now${NC}"
		go install github.com/projectdiscovery/asnmap/cmd/asnmap@latest &> /dev/null
		echo -e "${GREEN}asnmap has been installed${NC}"
	else
		echo -e "${GREEN}asnmap is already installed${NC}"
	fi
	
	if ! command -v jsleak -h &> /dev/null; then
		echo -e "${RED}Installing jsleak now${NC}"
		go install github.com/channyein1337/jsleak@latest &> /dev/null
		echo -e "${GREEN}jsleak has been installed${NC}"
	else
		echo -e "${GREEN}jsleak is already installed${NC}"
	fi
	
	if ! command -v mapcidr -h &> /dev/null; then
		echo -e "${RED}Installing mapcidr now${NC}"
		go install -v github.com/projectdiscovery/mapcidr/cmd/mapcidr@latest &> /dev/null
		echo -e "${GREEN}mapcidr has been installed${NC}"
	else
		echo -e "${GREEN}mapcidr is already installed${NC}"
	fi
	
	if ! command -v dnsx &> /dev/null; then
		echo -e "${RED}Installing dnsx now${NC}"
		go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest &> /dev/null
		sudo cp $HOME/go/bin/dnsx /usr/local/bin
		echo -e "${GREEN}dnsx has been installed${NC}"
	else
		echo -e "${GREEN}dnsx is already installed${NC}"
	fi
	
	if ! command -v gospider &> /dev/null; then
		echo -e "${RED}Installing gospider now${NC}"
		go install github.com/jaeles-project/gospider@latest &> /dev/null
		sudo cp $HOME/go/bin/gospider /usr/local/bin
		echo -e "${GREEN}gospider has been installed${NC}"
	else
		echo -e "${GREEN}gospider is already installed${NC}"
	fi

    	if ! command -v wpscan &> /dev/null; then
        	echo -e "${RED}Installing wpscan now${NC}"
        	gem install wpscan &> /dev/null
        	if command -v wpscan -h; then
            	echo -e "${GREEN}wpscan has been installed${NC}"
        	fi
    	else
        	echo -e "${GREEN}wpscan is already installed${NC}"
    	fi

    	if ! command -v CRLFuzz &> /dev/null; then
        	echo -e "${RED}Installing CRLFuzz now${NC}"
        	go install github.com/dwisiswant0/crlfuzz/cmd/crlfuzz@latest &> /dev/null
        	sudo cp $HOME/go/bin/crlfuzz /usr/local/bin
        	echo -e "${GREEN}CRLFuzz has been installed${NC}"
    	else
        	echo -e "${GREEN}CRLFuzz is already installed${NC}"
    	fi

    	if ! command -v uncover &> /dev/null; then
        	echo -e "${RED}Installing uncover now${NC}"
        	go install -v github.com/projectdiscovery/uncover/cmd/uncover@latest &> /dev/null
        	sudo cp $HOME/go/bin/uncover /usr/local/bin
        	echo -e "${GREEN}uncover has been installed${NC}"
    	else
        	echo -e "${GREEN}uncover is already installed${NC}"
    	fi

    	if ! command -v dalfox &> /dev/null; then
        	echo -e "${RED}Installing Dalfox now${NC}"
        	go install github.com/hahwul/dalfox/v2@latest &> /dev/null
        	cp $HOME/go/bin/dalfox /usr/local/bin
        	echo -e "${GREEN}dalfox has been installed${NC}"
    	else
        	echo -e "${GREEN}dalfox is already installed${NC}"
    	fi

    	if ! command -v GoLinkFinder &> /dev/null; then
        	echo -e "${RED}Installing GoLinkFinder now${NC}"
        	go install github.com/0xsha/GoLinkFinder@latest &> /dev/null
        	cp $HOME/go/bin/GoLinkFinder /usr/local/bin
        	echo -e "${GREEN}GoLinkFinder has been installed${NC}"
    	else
        	echo -e "${GREEN}GoLinkFinder is already installed${NC}"
    	fi

    	if ! command -v hakrawler &> /dev/null; then
        	echo -e "${RED}Installing hakrawler now${NC}"
        	go install github.com/hakluke/hakrawler@latest &> /dev/null
        	cp $HOME/go/bin/hakrawler /usr/local/bin
        	echo -e "${GREEN}Hakrawler has been installed${NC}"
    	else
        	echo -e "${GREEN}hakrawler is already installed${NC}"
    	fi

    	if ! command -v csprecon &> /dev/null; then
        	echo -e "${RED}Installing csprecon now${NC}"
        	go install github.com/edoardottt/csprecon/cmd/csprecon@latest &> /dev/null
        	echo -e "${GREEN}csprecon has been installed${NC}"
    	else
        	echo -e "${GREEN}csprecon is already installed${NC}"
    	fi

    	if ! command -v gotator &> /dev/null; then
        	echo -e "${RED}Installing gotator now${NC}"
        	go env -w GO111MODULE="auto"
        	go install github.com/Josue87/gotator@latest &> /dev/null
        	echo -e "${GREEN}gotator has been installed${NC}"
    	else
        	echo -e "${GREEN}gotator is already installed${NC}"
    	fi

    	if ! command -v osmedeus &> /dev/null; then
        	echo -e "${RED}Installing osmedeus now${NC}"
        	go install -v github.com/j3ssie/osmedeus@latest &> /dev/null
        	echo -e "${GREEN}osmedeus has been installed${NC}"
    	else
        	echo -e "${GREEN}osmedeus is already installed${NC}"
    	fi

    	if ! command -v shuffledns &> /dev/null; then
        	echo -e "${RED}Installing shuffledns now${NC}"
        	go install -v github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest &> /dev/null
        	echo -e "${GREEN}shuffledns has been installed${NC}"
    	else
        	echo -e "${GREEN}shuffledns is already installed${NC}"
    	fi

    	if ! command -v socialhunter -h &> /dev/null; then
        	echo -e "${RED}Installing socialhunter now${NC}"
        	go install github.com/utkusen/socialhunter@latest &> /dev/null
        	echo -e "${GREEN}socialhunter has been installed${NC}"
	    else
        	echo -e "${GREEN}socialhunter is already installed${NC}"
    	fi

    	if ! command -v getJS &> /dev/null; then
        	echo -e "${RED}Installing getJS now${NC}"
        	go install github.com/003random/getJS@latest &> /dev/null
        	echo -e "${GREEN}getJS has been installed${NC}"
    	else
        	echo -e "${GREEN}getJS is already installed${NC}"
    	fi
    
    	if command -v apkleaks &> /dev/null; then
        	echo -e "${RED}apkleaks is already installed.${NC}"
    	else
        	echo -e "${YELLOW}Installing apkleaks${NC}"
        	sudo pip3 install apkleaks
        	echo -e "${GREEN}apkleaks installed successfully.${NC}"
    	fi
    
    	if command -v parshu &> /dev/null; then
        	echo -e "${RED}parshu is already installed.${NC}"
    	else
        	echo -e "${YELLOW}Installing parshu${NC}"
        	sudo pip3 install parshu
        	echo -e "${GREEN}parshu installed successfully.${NC}"
    	fi
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
    echo -e ""
    cat << "EOF"
   _____ __________.___  __________               __                   __  .__                
  /  _  \\______   \   | \______   \ ____   _____/  |_  ____   _______/  |_|__| ____    ____  
 /  /_\  \|     ___/   |  |     ___// __ \ /    \   __\/ __ \ /  ___/\   __\  |/    \  / ___\ 
/    |    \    |   |   |  |    |   \  ___/|   |  \  | \  ___/ \___ \  |  | |  |   |  \/ /_/  >
\____|__  /____|   |___|  |____|    \___  >___|  /__|  \___  >____  > |__| |__|___|  /\___  / 
        \/                              \/     \/          \/     \/               \//_____/  
EOF
    echo -e "\n Select an option from menu:"
    echo -e "\nKey     Menu Option:"
    echo -e "---     -------------------------"
    echo -e " 1   -  Download/Install All Tools"
    echo -e " 2   -  Install mitmproxy2swagger"
    echo -e " 3   -  Install postman "
    echo -e " 4   -  install jwt tool"
    echo -e " 5   -  Install kiterunner"
    echo -e " 6   -  Install arjun"
    echo -e " 7   -  Back"
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
        if command -v pacman &> /dev/null; then
            echo -e "${YELLOW}Installing aapt${NC}"
            sudo pacman -Sy aapt --noconfirm
            echo -e "${GREEN}aapt installed successfully.${NC}"
        elif command -v apt-get &> /dev/null; then
            echo -e "${YELLOW}Installing aapt${NC}"
            sudo apt-get install aapt -y
            echo -e "${GREEN}aapt installed successfully.${NC}"
        else
            echo -e "${RED}Unable to install aapt. Please install it manually.${NC}"
        fi
    fi
    sleep 2
}

function install_apktool() {
    if command -v apktool &> /dev/null; then
        echo -e "${RED}apktool is already installed.${NC}"
    else
        if command -v pacman &> /dev/null; then
            echo -e "${YELLOW}Installing apktool${NC}"
            sudo pacman -Sy apktool --noconfirm
            echo -e "${GREEN}apktool installed successfully.${NC}"
        elif command -v apt-get &> /dev/null; then
            echo -e "${YELLOW}Installing apktool${NC}"
            sudo apt-get install apktool -y
            echo -e "${GREEN}apktool installed successfully.${NC}"
        else
            echo -e "${RED}Unable to install apktool. Please install it manually.${NC}"
        fi
    fi
    sleep 2
}

function install_adb() {
    if command -v adb &> /dev/null; then
        echo -e "${RED}adb is already installed.${NC}"
    else
        if command -v pacman &> /dev/null; then
            echo -e "${YELLOW}Installing adb${NC}"
            sudo pacman -Sy android-tools --noconfirm
            echo -e "${GREEN}adb installed successfully.${NC}"
        elif command -v apt-get &> /dev/null; then
            echo -e "${YELLOW}Installing adb${NC}"
            sudo apt-get install adb -y
            echo -e "${GREEN}adb installed successfully.${NC}"
        else
            echo -e "${RED}Unable to install adb. Please install it manually.${NC}"
        fi
    fi
    sleep 2
}

function install_apksigner() {
    if command -v apksigner &> /dev/null; then
        echo -e "${RED}apksigner is already installed.${NC}"
    else
        if command -v pacman &> /dev/null; then
            echo -e "${YELLOW}Installing apksigner${NC}"
            sudo pacman -Sy apksigner --noconfirm
            echo -e "${GREEN}apksigner installed successfully.${NC}"
        elif command -v apt-get &> /dev/null; then
            echo -e "${YELLOW}Installing apksigner${NC}"
            sudo apt-get install apksigner -y
            echo -e "${GREEN}apksigner installed successfully.${NC}"
        else
            echo -e "${RED}Unable to install apksigner. Please install it manually.${NC}"
        fi
    fi
    sleep 2
}

function install_zipalign() {
    if command -v zipalign &> /dev/null; then
        echo -e "${RED}zipalign is already installed.${NC}"
    else
        if command -v pacman &> /dev/null; then
            echo -e "${YELLOW}Installing zipalign${NC}"
            sudo pacman -Sy zipalign --noconfirm
            echo -e "${GREEN}zipalign installed successfully.${NC}"
        elif command -v apt-get &> /dev/null; then
            echo -e "${YELLOW}Installing zipalign${NC}"
            sudo apt-get install zipalign -y
            echo -e "${GREEN}zipalign installed successfully.${NC}"
        else
            echo -e "${RED}Unable to install zipalign. Please install it manually.${NC}"
        fi
    fi
    sleep 2
}

function install_wkhtmltopdf() {
    if command -v wkhtmltopdf &> /dev/null; then
        echo -e "${RED}wkhtmltopdf is already installed.${NC}"
    else
        if command -v pacman &> /dev/null; then
            echo -e "${YELLOW}Installing wkhtmltopdf${NC}"
            sudo pacman -Sy wkhtmltopdf --noconfirm
            echo -e "${GREEN}wkhtmltopdf installed successfully.${NC}"
        elif command -v apt-get &> /dev/null; then
            echo -e "${YELLOW}Installing wkhtmltopdf${NC}"
            sudo apt-get install wkhtmltopdf -y
            echo -e "${GREEN}wkhtmltopdf installed successfully.${NC}"
        else
            echo -e "${RED}Unable to install wkhtmltopdf. Please install it manually.${NC}"
        fi
    fi
    sleep 2
}

function install_default_jdk() {
    if command -v default-jdk &> /dev/null; then
        echo -e "${RED}default-jdk is already installed.${NC}"
    else
        if command -v pacman &> /dev/null; then
            echo -e "${YELLOW}Installing default-jdk${NC}"
            sudo pacman -Sy jdk-openjdk --noconfirm
            echo -e "${GREEN}default-jdk installed successfully.${NC}"
        elif command -v apt-get &> /dev/null; then
            echo -e "${YELLOW}Installing default-jdk${NC}"
            sudo apt-get install default-jdk -y
            echo -e "${GREEN}default-jdk installed successfully.${NC}"
        else
            echo -e "${RED}Unable to install default-jdk. Please install it manually.${NC}"
        fi
    fi
    sleep 2
}

function install_jadx() {
    if command -v jadx &> /dev/null; then
        echo -e "${RED}jadx is already installed.${NC}"
    else
        if command -v pacman &> /dev/null; then
            echo -e "${YELLOW}Installing jadx${NC}"
            sudo pacman -Sy jadx --noconfirm
            echo -e "${GREEN}jadx installed successfully.${NC}"
        elif command -v apt-get &> /dev/null; then
            echo -e "${YELLOW}Installing jadx${NC}"
            sudo apt-get install jadx -y
            echo -e "${GREEN}jadx installed successfully.${NC}"
        else
            echo -e "${RED}Unable to install jadx. Please install it manually.${NC}"
        fi
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
    install_default_jdk
    install_jadx
    install_MobSF
}

function Mobile_App_Tools() {
    clear
    echo -e ""
    cat << "EOF"
   _____        ___.   .__.__              _____                  ___________           .__          
  /     \   ____\_ |__ |__|  |   ____     /  _  \ ______ ______   \__    ___/___   ____ |  |   ______
 /  \ /  \ /  _ \| __ \|  |  | _/ __ \   /  /_\  \\____ \\____ \    |    | /  _ \ /  _ \|  |  /  ___/
/    Y    (  <_> ) \_\ \  |  |_\  ___/  /    |    \  |_> >  |_> >   |    |(  <_> |  <_> )  |__\___ \ 
\____|__  /\____/|___  /__|____/\___  > \____|__  /   __/|   __/    |____| \____/ \____/|____/____  >
        \/           \/             \/          \/|__|   |__|                                     \/ 
EOF
    echo -e "\n Select an option from menu:"
    echo -e "\nKey     Menu Option:"
    echo -e "---     -------------------------"
    echo -e " 1   -  Download/Install All Tools"
    echo -e " 2   -  Install aapt"
    echo -e " 3   -  Install apktool "
    echo -e " 4   -  install adb"
    echo -e " 5   -  Install apksigner"
    echo -e " 6   -  Install zipalign"
    echo -e " 7   -  Install wkhtmltopdf"
    echo -e " 8   -  Install default-jdk"
    echo -e " 9   -  Install jadx"
    echo -e " 10  -  Install MobFS"
    echo -e " 11  -  Back"
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
        8) install_default_jdk; Mobile_App_Tools;;
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

function install_OSCP_Reporting() {
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
    install_OSCP_Reporting
}

function Reporting_Tools() {
    clear
    echo -e ""
    cat << "EOF"
__________                             __  .__                
\______   \ ____ ______   ____________/  |_|__| ____    ____  
 |       _// __ \\____ \ /  _ \_  __ \   __\  |/    \  / ___\ 
 |    |   \  ___/|  |_> >  <_> )  | \/|  | |  |   |  \/ /_/  >
 |____|_  /\___  >   __/ \____/|__|   |__| |__|___|  /\___  / 
        \/     \/|__|                              \//_____/  
EOF
    echo -e "\n Select an option from menu:"
    echo -e "\nKey     Menu Option:"
    echo -e "---     -------------------------"
    echo -e " 1   -  Download/Install All Tools"
    echo -e " 2   -  Download pwndoc"
    echo -e " 3   -  Download ghostwriter"
    echo -e " 4   -  Install OSCP-Reporting"
    echo -e " 5   -  Back"
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) download_install_all_Reporting_tools; Reporting_Tools;;
        2) download_pwndoc; Reporting_Tools;;
        3) download_ghostwriter; Reporting_Tools;;
        4) install_OSCP_Reporting; Reporting_Tools;;
        5) main_menu;;
        *) echo "Invalid option"; Reporting_Tools;;
    esac
}

# --[ RedTeam Function to install from 2 through 9 tools ]
function install_from_2_through_9() {
    install_all_recon_tools
    install_all_vulnerability_scanners
    install_all_file_trasfer_tools
    download_install_all_phishing_tools
    download_Ghostpack
    install_all_Evasion_tools
    download_install_all_Windows_Privilege_Escalation_tools
    download_install_all_Linux_Privilege_Escalation_tools
}

# --[ Appsec - Function to install from 10 through 12 tools ]
function install_from_10_through_12() {
    Bug_Bounty_Tools
    download_install_all_API_tools
    download_install_all_Mobile_App_tools
    install_ProjectDiscovery_Toolkit
}

# Function to install all Project Discovery Tools
function install_ProjectDiscovery_Toolkit() {
    if ! command -v pdtm &> /dev/null; then
        echo -e "${RED}Installing ProjectDiscovery's Open Source Tool Manager.${NC}"
        go install -v github.com/projectdiscovery/pdtm/cmd/pdtm@latest
        sudo cp $HOME/go/bin/pdtm /usr/local/bin
        pdtm -install-all
        pdtm -update-all
    else
        echo -e "${GREEN}ProjectDiscovery's Open Source Tool Manager is already installed.${NC}"
        sleep 2
        echo -e "${GREEN}Updating all the tools${NC}"
        pdtm -update-all
    fi
}


function main_menu() {
    clear
    echo -e ""
    cat << "EOF"
___________     .__.__   ____  __.      .__  .__ 
\_   _____/__  _|__|  | |    |/ _|____  |  | |__|
 |    __)_\  \/ /  |  | |      < \__  \ |  | |  |
 |        \\   /|  |  |_|    |  \ / __ \|  |_|  |
/_______  / \_/ |__|____/____|__ (____  /____/__|
        \/                      \/    \/         
                                By YoruYagami
EOF
    echo -e ""
    echo -e "Menu options marked with * do not have submenus (direct installation)"
    echo -e "\n Select an option from menu:"
    echo ""
    echo -e "\nKey      Menu Option:"
    echo -e "---      -------------------------"
    echo -e " 1    -  Command and Control Frameworks"
    echo -e " 2    -  Reconnaissance"
    echo -e " 3    -  Phishing"
    echo -e " 4    -  Vulnerability Scanners"
    echo -e " 5    -  File Trasferer tools"
    echo -e " 6*   -  Ghostpack Compiled Binaries"
    echo -e " 7    -  Evasion Tools"
    echo -e " 8    -  Windows Privilege Escaltion Tools"
    echo -e " 9    -  Linux Privilege Escaltion Tools"
    echo -e " 10*  -  Web Application / Bug Bounty Tools"
    echo -e " 11   -  API Penenetration Testing Tools"
    echo -e " 12   -  Mobile Application Penetration Testing Tools"
    echo -e " 13   -  Reporting"
    echo ""
    echo -e " A*   -  ${GREEN}Everything${NC}         Install all tools provided by the script"
    echo -e " B*   -  ${RED}RedTeam${NC}            Install all tools from  2 -> 9"
    echo -e " C*   -  ${YELLOW}AppSec${NC}             Install all tools from 10 -> 12"
    echo -e " D*   -  ${BLUE}Project Discovery${NC}  Install/Update all Project Discovery Tools"
    echo ""
    echo -e "${BLUE} 99  -  Quit"${NC}
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) command_and_control;;
        2) reconnaissance;;
        3) phishing;;
        4) vulnerability_scanners;;
        5) File_Trasfer_Tools;;
        6) download_Ghostpack; main_menu;;
        7) Evasion_Tools;;
        8) Windows_Privilege_Escalation_Tools;;
        9) Linux_Privilege_Escalation_Tools;;
        10) Bug_Bounty_Tools; main_menu;;
        11) API_Tools;;
        12) Mobile_App_Tools;;
        13) Reporting_Tools;;
        99) exit;;
        A) download_install_all_c2_tools; install_all_recon_tools; install_all_vulnerability_scanners; install_all_file_trasfer_tools; download_install_all_phishing_tools; download_Ghostpack; install_all_Evasion_tools; download_install_all_Windows_Privilege_Escalation_tools; download_install_all_Linux_Privilege_Escalation_tools; Bug_Bounty_Tools; download_install_all_API_tools; install_ProjectDiscovery_Toolkit; download_install_all_Mobile_App_tools; download_install_all_Reporting_tools; main_menu;;
        B) install_from_2_through_9; main_menu;;
        C) install_from_10_through_12; main_menu;;
        D) install_ProjectDiscovery_Toolkit; main_menu;;
        *) echo "Invalid option"; main_menu;;
    esac
}

main_menu
