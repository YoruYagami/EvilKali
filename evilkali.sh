#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
CYAN="\e[0;36m"
YELLOW="\033[0;33m"
PURPLE='\033[0;35m'
NC='\033[0m'

clear

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
if ! grep -q 'if \[ "\$TMUX" = "" \]; then tmux; fi' ~/$SUDO_USER/.zshrc; then
    # If it's not, ask the user if they want to automatically start tmux
    echo "Do you want to start tmux automatically when you open the terminal? (y/n)"
    read response

    # Check the user's response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        echo >> ~/$SUDO_USER/.zshrc  # Add an empty line
        echo 'if [ "$TMUX" = "" ]; then tmux; fi' >> ~/$SUDO_USER/.zshrc
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
    ["jq"]="jq"
    ["python3"]="python3"
    ["docker-compose"]="docker-compose"
    ["docker.io"]="docker"
    ["neovim"]="nvim"
    ["golang-go"]="go"
    ["uuid-runtime"]="uuidgen"
)

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
    mkdir -p $HOME/tools/C2
    if [ -d $HOME/tools/C2/Villain ]; then
        echo -e "${RED}Villain is already installed.${NC}"
    else
        echo -e "${YELLOW}Downloading Villain${NC}"
        git clone 'https://github.com/t3l3machus/Villain.git' $HOME/tools/C2/Villain 
    fi
    sleep 2
}

function download_covenant() {
    mkdir -p $HOME/tools/C2
    if [ -d $HOME/tools/C2/Covenant ]; then
        echo -e "${RED}Covenant is already installed.${NC}"
    else
        echo -e "${YELLOW}Downloading Covenant${NC}"
        git clone --recurse-submodules https://github.com/cobbr/Covenant $HOME/tools/C2/Covenant 
        echo -e "${GREEN}Covenant downloaded successfully.${NC}"
    fi
    sleep 2
}

function download_Havoc() {
    # Install required packages
    sudo apt update
    sudo apt install -y git build-essential apt-utils cmake libfontconfig1 libglu1-mesa-dev libgtest-dev libspdlog-dev libboost-all-dev libncurses5-dev libgdbm-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev mesa-common-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5websockets5 libqt5websockets5-dev qtdeclarative5-dev golang-go qtbase5-dev libqt5websockets5-dev python3-dev libboost-all-dev mingw-w64 nasm python3-dev python3.10-dev libpython3.10 libpython3.10-dev python3.10

    mkdir -p $HOME/tools/C2
    if [ -d $HOME/tools/C2/Havoc ]; then
        echo -e "${RED}Havoc Framework is already installed.${NC}"
    else
        echo -e "${YELLOW}Downloading Havoc Framework${NC}"
        git clone 'https://github.com/HavocFramework/Havoc.git' $HOME/tools/C2/Havoc 
        echo -e "${GREEN}Havoc Framework downloaded successfully.${NC}"
    fi

    # Ask the user if they want to build the teamserver and client
    read -p "Do you want to build the teamserver and client? (y/n) " yn
    case $yn in
        [Yy]* ) 
            # Build the Teamserver
            cd $HOME/tools/C2/Havoc/teamserver
            sudo go mod download golang.org/x/sys
            sudo go mod download github.com/ugorji/go
            cd $HOME/tools/C2/Havoc
            sudo make ts-build

            # Build the client
            sudo make client-build
            ;;
        [Nn]* ) ;;
        * ) echo "Invalid input. Skipping building the teamserver and client.";;
    esac

    sleep 2
}

function download_AM0N-Eye() {
    mkdir -p $HOME/tools/C2
    if [ -d $HOME/tools/C2/AM0N-Eye ]; then
        echo -e "${RED}AM0N-Eye Framework is already installed.${NC}"
    else
        echo -e "${YELLOW}Downloading AM0N-Eye${NC}"
        git clone 'https://github.com/YoruYagami/AM0N-Eye.git' $HOME/tools/C2/AM0N-Eye 
        echo -e "${GREEN}AM0N-Eye downloaded successfully.${NC}"
    fi
    sleep 2
}

function install_sliver() {
    if command -v sliver &> /dev/null; then
        echo -e "${RED}Sliver is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing Sliver Framework.${NC}"
        curl https://sliver.sh/install | sudo bash 
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
    download_Havoc
    download_AM0N-Eye
    install_sliver
    install_pwncat
}

function command_and_control() {
    clear
    echo
    cat << "EOF"
_________  ________   ___________                                                __    
\_   ___ \ \_____  \  \_   _____/___________    _____   ______  _  _____________|  | __
/    \  \/  /  ____/   |    __) \_  __ \__  \  /     \_/ __ \ \/ \/ /  _ \_  __ \  |/ /
\     \____/       \   |     \   |  | \// __ \|  Y Y  \  ___/\     (  <_> )  | \/    < 
 \______  /\_______ \  \___  /   |__|  (____  /__|_|  /\___  >\/\_/ \____/|__|  |__|_ \
        \/         \/      \/               \/      \/     \/                        \/

EOF
echo
        echo -e "\n Select an option from menu:"
    echo -e "\nKey     Menu Option:"
    echo -e "---     -------------------------"
    echo -e " 1   -  Download Villain"
    echo -e " 2   -  Download Covenant"
    echo -e " 3   -  Download Havoc"
    echo -e " 4   -  Download AM0N-Eye"
    echo -e " 5   -  Install Sliver"
    echo -e " 6   -  Install pwncat-cs"
    echo ""
    echo -e " A   -  Download/Install All Tools"
    echo ""
    echo -e "${BLUE} 0    -  Back to Red Team Menu"${NC}
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) download_villain; command_and_control;;
        2) download_covenant; command_and_control;;
        3) download_Havoc; command_and_control;;
        4) download_AM0N-Eye; command_and_control;;
        5) install_Sliver; command_and_control;;
        6) install_pwncat; command_and_control;;
        A) download_install_all_c2_tools; command_and_control;;
        0) red_team_menu;;
        *) echo "Invalid option"; command_and_control;;
    esac
}

# --[ Windows Resource ]--
function download_Install_windows-resource() {
    # Creating Windows Directory
    mkdir -p $HOME/tools/windows

    if ! command -v rustc &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    else
        echo -e "${RED}Rust is already installed.${NC}"
    fi

    pip3 install --user pipx PyYAML alive-progress xlsxwriter sectools typer --upgrade &> /dev/null

    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo "Adding $HOME/.local/bin to PATH"
        pipx ensurepath
    else
        echo "$HOME/.local/bin is already in PATH"
    fi

    if ! command -v ldapdomaindump &> /dev/null; then
        echo -e "${YELLOW}Installing ldapdomaindump${NC}"
        pipx install git+https://github.com/dirkjanm/ldapdomaindump.git --force &> /dev/null
        echo -e "${GREEN}ldapdomaindump installed successfully.${NC}"
    else
        echo -e "${RED}ldapdomaindump is already installed.${NC}"
    fi

    if ! command -v nxc &> /dev/null; then
        echo -e "${YELLOW}Installing NetExec${NC}"
        pipx install git+https://github.com/Pennyw0rth/NetExec.git --force &> /dev/null
        echo -e "${GREEN}NetExec installed successfully.${NC}"
    else
        echo -e "${RED}NetExec is already installed.${NC}"
    fi

    if ! command -v impacket &> /dev/null; then
        echo -e "${YELLOW}Installing impacket${NC}"
        pipx install git+https://github.com/fortra/impacket.git --force &> /dev/null
        echo -e "${GREEN}impacket installed successfully.${NC}"
    else
        echo -e "${RED}impacket is already installed.${NC}"
    fi

    if ! command -v adidnsdump &> /dev/null; then
        echo -e "${YELLOW}Installing adidnsdump${NC}"
        pipx install git+https://github.com/dirkjanm/adidnsdump.git --force &> /dev/null
        echo -e "${GREEN}adidnsdump installed successfully.${NC}"
    else
        echo -e "${RED}adidnsdump is already installed.${NC}"
    fi

    if ! command -v certi.py &> /dev/null; then
        echo -e "${YELLOW}Installing certi${NC}"
        pipx install git+https://github.com/zer1t0/certi.git --force &> /dev/null
        echo -e "${GREEN}certi installed successfully.${NC}"
    else
        echo -e "${RED}certi is already installed.${NC}"
    fi

    if ! command -v certipy &> /dev/null; then
        echo -e "${YELLOW}Installing Certipy${NC}"
        pipx install git+https://github.com/ly4k/Certipy.git --force &> /dev/null
        echo -e "${GREEN}Certipy installed successfully.${NC}"
    else
        echo -e "${RED}Certipy is already installed.${NC}"
    fi

    if ! command -v bloodhound-python &> /dev/null; then
        echo -e "${YELLOW}Installing bloodhound.py${NC}"
        pipx install git+https://github.com/dirkjanm/bloodhound.py --force &> /dev/null
    else
        echo -e "${RED}bloodhound.py is already installed.${NC}"
    fi

    if ! command -v ldeep &> /dev/null; then
        echo -e "${YELLOW}Installing ldeep${NC}"
        pipx install git+https://github.com/franc-pentest/ldeep.git --force &> /dev/null
        echo -e "${GREEN}ldeep installed successfully.${NC}"
    else
        echo -e "${RED}ldeep is already installed.${NC}"
    fi

    if ! command -v pre2k &> /dev/null; then
        echo -e "${YELLOW}Installing pre2k${NC}"
        pipx install git+https://github.com/garrettfoster13/pre2k.git --force &> /dev/null
        echo -e "${GREEN}pre2k installed successfully.${NC}"
    else
        echo -e "${RED}pre2k is already installed.${NC}"
    fi

    if ! command -v certsync &> /dev/null; then
        echo -e "${YELLOW}Installing certsync${NC}"
        pipx install git+https://github.com/zblurx/certsync.git --force &> /dev/null
        echo -e "${GREEN}certsync installed successfully.${NC}"
    else
        echo -e "${RED}certsync is already installed.${NC}"
    fi

    if ! command -v hekatomb &> /dev/null; then
        echo -e "${YELLOW}Installing hekatomb${NC}"
        pipx install hekatomb --force &> /dev/null
        echo -e "${GREEN}hekatomb installed successfully.${NC}"
    else
        echo -e "${RED}hekatomb is already installed.${NC}"
    fi

    if ! command -v manspider &> /dev/null; then
        echo -e "${YELLOW}Installing MANSPIDER${NC}"
        pipx install git+https://github.com/blacklanternsecurity/MANSPIDER --force &> /dev/null
        echo -e "${GREEN}MANSPIDER installed successfully.${NC}"
    else
        echo -e "${RED}MANSPIDER is already installed.${NC}"
    fi

    if ! command -v coercer &> /dev/null; then
        echo -e "${YELLOW}Installing Coercer${NC}"
        pipx install git+https://github.com/p0dalirius/Coercer --force &> /dev/null
        echo -e "${GREEN}Coercer installed successfully.${NC}"
    else
        echo -e "${RED}Coercer is already installed.${NC}"
    fi

    if ! command -v bloodyAD &> /dev/null; then
        echo -e "${YELLOW}Installing bloodyAD${NC}"
        pipx install git+https://github.com/CravateRouge/bloodyAD --force &> /dev/null
        echo -e "${GREEN}bloodyAD installed successfully.${NC}"
    else
        echo -e "${RED}bloodyAD is already installed.${NC}"
    fi

    if ! command -v DonPAPI &> /dev/null; then
        echo -e "${YELLOW}Installing DonPAPI${NC}"
        pipx install git+https://github.com/login-securite/DonPAPI --force &> /dev/null
        echo -e "${GREEN}DonPAPI installed successfully.${NC}"
    else
        echo -e "${RED}DonPAPI is already installed.${NC}"
    fi

    if ! command -v rdwatool &> /dev/null; then
        echo -e "${YELLOW}Installing rdwatool${NC}"
        pipx install git+https://github.com/p0dalirius/RDWAtool --force &> /dev/null
        echo -e "${GREEN}rdwatool installed successfully.${NC}"
    else
        echo -e "${RED}rdwatool is already installed.${NC}"
    fi

    if ! command -v krbjack &> /dev/null; then
        echo -e "${YELLOW}Installing krbjack${NC}"
        pipx install git+https://github.com/almandin/krbjack --force &> /dev/null
        echo -e "${GREEN}krbjack installed successfully.${NC}"
    else
        echo -e "${RED}krbjack is already installed.${NC}"
    fi

    #Creating impacket script folder
    mkdir -p $HOME/tools/windows/impacket-scripts/

    if [ -f $HOME/tools/windows/impacket-scripts/windapsearch ]; then
        echo -e "${RED}windapsearch is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading windapsearch${NC}"
        wget -q "https://github.com/ropnop/go-windapsearch/releases/latest/download/windapsearch-linux-amd64" -O $HOME/tools/windows/impacket-scripts/windapsearch &> /dev/null
        echo -e "${GREEN}windapsearch downloaded successfully.${NC}"
        sleep 2
    fi

    if [ -f $HOME/tools/windows/impacket-scripts//kerbrute ]; then
        echo -e "${RED}kerbrute is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading kerbrute${NC}"
        wget -q "https://github.com/ropnop/kerbrute/releases/latest/download/kerbrute_linux_amd64" -O $HOME/tools/windows/impacket-scripts/kerbrute &> /dev/null
        echo -e "${GREEN}kerbrute downloaded successfully.${NC}"
        sleep 2
    fi

    if [ -f $HOME/tools/windows/impacket-scripts/enum4linux-ng.py ]; then
        echo -e "${RED}enum4linux-ng.py is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading enum4linux-ng.py${NC}"
        wget -q "https://raw.githubusercontent.com/cddmp/enum4linux-ng/master/enum4linux-ng.py" -O $HOME/tools/windows/impacket-scripts/enum4linux-ng.py &> /dev/null
        echo -e "${GREEN}enum4linux-ng.py downloaded successfully.${NC}"
        sleep 2
    fi

    if [ -f $HOME/tools/windows/impacket-scripts/CVE-2022-33679.py ]; then
        echo -e "${RED}CVE-2022-33679.py is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading CVE-2022-33679.py${NC}"
        wget -q "https://raw.githubusercontent.com/Bdenneu/CVE-2022-33679/main/CVE-2022-33679.py" -O $HOME/tools/windows/impacket-scripts/CVE-2022-33679.py &> /dev/null
        echo -e "${GREEN}CVE-2022-33679.py downloaded successfully.${NC}"
        sleep 2
    fi

    if [ -f $HOME/tools/windows/impacket-scripts/silenthound.py ]; then
        echo -e "${RED}silenthound.py is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading silenthound.py${NC}"
        wget -q "https://raw.githubusercontent.com/layer8secure/SilentHound/main/silenthound.py" -O $HOME/tools/windows/impacket-scripts/silenthound.py &> /dev/null
        echo -e "${GREEN}silenthound.py downloaded successfully.${NC}"
        sleep 2
    fi

    if [ -f $HOME/tools/windows/impacket-scripts/targetedKerberoast.py ]; then
        echo -e "${RED}targetedKerberoast.py is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading targetedKerberoast.py${NC}"
        wget -q "https://raw.githubusercontent.com/ShutdownRepo/targetedKerberoast/main/targetedKerberoast.py" -O $HOME/tools/windows/impacket-scripts/targetedKerberoast.py &> /dev/null
        echo -e "${GREEN}targetedKerberoast.py downloaded successfully.${NC}"
        sleep 2
    fi

    if [ -f $HOME/tools/windows/impacket-scripts/targetedKerberoast.py ]; then
        echo -e "${RED}targetedKerberoast.py is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading targetedKerberoast.py${NC}"
        wget -q "https://raw.githubusercontent.com/ShutdownRepo/targetedKerberoast/main/targetedKerberoast.py" -O $HOME/tools/windows/impacket-scripts/targetedKerberoast.py &> /dev/null
        echo -e "${GREEN}targetedKerberoast.py downloaded successfully.${NC}"
        sleep 2
    fi

    if [ -f $HOME/tools/windows/impacket-scripts/FindUncommonShares.py ]; then
        echo -e "${RED}FindUncommonShares.py is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading FindUncommonShares.py${NC}"
        wget -q "https://raw.githubusercontent.com/p0dalirius/FindUncommonShares/main/FindUncommonShares.py" -O $HOME/tools/windows/impacket-scripts/FindUncommonShares.py &> /dev/null
        echo -e "${GREEN}FindUncommonShares.py downloaded successfully.${NC}"
        sleep 2
    fi

    
    if [ -f $HOME/tools/windows/impacket-scripts/ExtractBitlockerKeys.py ]; then
        echo -e "${RED}ExtractBitlockerKeys.py is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading ExtractBitlockerKeys.py${NC}"
        wget -q "https://raw.githubusercontent.com/p0dalirius/ExtractBitlockerKeys/main/ExtractBitlockerKeys.py" -O $HOME/tools/windows/impacket-scripts/ExtractBitlockerKeys.py &> /dev/null
        echo -e "${GREEN}ExtractBitlockerKeys.py downloaded successfully.${NC}"
        sleep 2
    fi

    if [ -f $HOME/tools/windows/impacket-scripts/ldapconsole.py ]; then
        echo -e "${RED}ldapconsole.py is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading ldapconsole.py${NC}"
        wget -q "https://raw.githubusercontent.com/p0dalirius/ldapconsole/master/ldapconsole.py" -O $HOME/tools/windows/impacket-scripts/ldapconsole.py &> /dev/null
        echo -e "${GREEN}ldapconsole.py downloaded successfully.${NC}"
        sleep 2
    fi

    if [ -f $HOME/tools/windows/impacket-scripts/pyLDAPmonitor.py ]; then
        echo -e "${RED}pyLDAPmonitor.py is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading pyLDAPmonitor.py${NC}"
        wget -q "https://raw.githubusercontent.com/p0dalirius/LDAPmonitor/master/python/pyLDAPmonitor.py" -O $HOME/tools/windows/impacket-scripts/pyLDAPmonitor.py &> /dev/null
        echo -e "${GREEN}pyLDAPmonitor.py downloaded successfully.${NC}"
        sleep 2
    fi

    if [ -f $HOME/tools/windows/impacket-scripts/LDAPWordlistHarvester.py ]; then
        echo -e "${RED}LDAPWordlistHarvester.py is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading LDAPWordlistHarvester.py${NC}"
        wget -q "https://raw.githubusercontent.com/p0dalirius/LDAPWordlistHarvester/main/LDAPWordlistHarvester.py" -O $HOME/tools/windows/impacket-scripts/LDAPWordlistHarvester.py &> /dev/null
        echo -e "${GREEN}LDAPWordlistHarvester.py downloaded successfully.${NC}"
        sleep 2
    fi

    if [ -f $HOME/tools/windows/impacket-scripts/aced.zip ]; then
        echo -e "${RED}aced.zip is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading aced.zip${NC}"
        wget -q "https://github.com/garrettfoster13/aced/archive/refs/heads/main.zip" -O $HOME/tools/windows/impacket-scripts/aced.zip &> /dev/null
        echo -e "${GREEN}aced.zip downloaded successfully.${NC}"
        sleep 2
    fi

    if [ -d $HOME/tools/windows/impacket-scripts/aced-main ]; then
        echo -e "${RED}aced-main directory already exists.${NC}"
    else
        echo -e "${YELLOW}Extracting aced.zip${NC}"
        unzip $HOME/tools/windows/impacket-scripts/aced.zip -d $HOME/tools/windows/impacket-scripts/ &> /dev/null
        echo -e "${GREEN}aced.zip extracted successfully.${NC}"
        sleep 2
    fi

    if [ -f $HOME/tools/windows/impacket-scripts/sccmhunter.zip ]; then
        echo -e "${RED}sccmhunter.zip is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading sccmhunter.zip${NC}"
        wget -q "https://github.com/garrettfoster13/sccmhunter/archive/refs/heads/main.zip" -O $HOME/tools/windows/impacket-scripts/sccmhunter.zip &> /dev/null
        echo -e "${GREEN}sccmhunter.zip downloaded successfully.${NC}"
        sleep 2
    fi

    if [ -d $HOME/tools/windows/impacket-scripts/sccmhunter-main ]; then
        echo -e "${RED}sccmhunter-main directory already exists.${NC}"
    else
        echo -e "${YELLOW}Extracting sccmhunter.zip${NC}"
        unzip $HOME/tools/windows/impacket-scripts/sccmhunter.zip -d $HOME/tools/windows/impacket-scripts/ &> /dev/null
        echo -e "${GREEN}sccmhunter.zip extracted successfully.${NC}"
        sleep 2
    fi

    if [ -f $HOME/tools/windows/impacket-scripts/ldapper.py ]; then
        echo -e "${RED}ldapper.py is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading ldapper.py${NC}"
        wget -q "https://raw.githubusercontent.com/shellster/LDAPPER/master/ldapper.py" -O $HOME/tools/windows/impacket-scripts/ldapper.py &> /dev/null
        echo -e "${GREEN}ldapper.py downloaded successfully.${NC}"
        sleep 2
    fi

    if [ -f $HOME/tools/windows/impacket-scripts/utilities.py ]; then
        echo -e "${RED}utilities.py is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading utilities.py${NC}"
        wget -q "https://raw.githubusercontent.com/shellster/LDAPPER/master/utilities.py" -O $HOME/tools/windows/impacket-scripts/utilities.py &> /dev/null
        echo -e "${GREEN}utilities.py downloaded successfully.${NC}"
        sleep 2
    fi

    if [ -f $HOME/tools/windows/impacket-scripts/queries.py ]; then
        echo -e "${RED}queries.py is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading queries.py${NC}"
        wget -q "https://raw.githubusercontent.com/shellster/LDAPPER/master/queries.py" -O $HOME/tools/windows/impacket-scripts/queries.py &> /dev/null
        echo -e "${GREEN}queries.py downloaded successfully.${NC}"
        sleep 2
    fi

    if [ -f $HOME/tools/windows/impacket-scripts/ldap_connector.py ]; then
        echo -e "${RED}ldap_connector.py is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading ldap_connector.py${NC}"
        wget -q "https://raw.githubusercontent.com/shellster/LDAPPER/master/ldap_connector.py" -O $HOME/tools/windows/impacket-scripts/ldap_connector.py &> /dev/null
        echo -e "${GREEN}ldap_connector.py downloaded successfully.${NC}"
        sleep 2
    fi

    chmod +x $HOME/tools/windows/impacket-scripts/aced-main/aced.py
    chmod +x $HOME/tools/windows/impacket-scripts/sccmhunter-main/sccmhunter.py
    chmod +x $HOME/tools/windows/impacket-scripts/windapsearch
    chmod +x $HOME/tools/windows/impacket-scripts/kerbrute
    chmod +x $HOME/tools/windows/impacket-scripts/enum4linux-ng.py
    chmod +x $HOME/tools/windows/impacket-scripts/CVE-2022-33679.py
    chmod +x $HOME/tools/windows/impacket-scripts/silenthound.py
    chmod +x $HOME/tools/windows/impacket-scripts/targetedKerberoast.py
    chmod +x $HOME/tools/windows/impacket-scripts/FindUncommonShares.py
    chmod +x $HOME/tools/windows/impacket-scripts/ExtractBitlockerKeys.py
    chmod +x $HOME/tools/windows/impacket-scripts/ldapconsole.py
    chmod +x $HOME/tools/windows/impacket-scripts/pyLDAPmonitor.py
    chmod +x $HOME/tools/windows/impacket-scripts/LDAPWordlistHarvester.py
    chmod +x $HOME/tools/windows/impacket-scripts/ldapper.py
    chmod +x $HOME/tools/windows/impacket-scripts/ldap_connector.py
    chmod +x $HOME/tools/windows/impacket-scripts/queries.py
    chmod +x $HOME/tools/windows/impacket-scripts/utilities.py

    # Get latest release data from GitHub
    echo -e "${YELLOW}Retrieving WinPwn latest release information${NC}"
    json=$(curl -s https://api.github.com/repos/S3cur3Th1sSh1t/WinPwn/releases/latest)

    # Extract download URLs for WinPwn.exe and WinPwn.ps1
    winpwn_exe_url=$(echo "$json" | jq -r '.assets[] | select(.name | contains("WinPwn.exe")) | .browser_download_url')
    winpwn_ps1_url=$(echo "$json" | jq -r '.assets[] | select(.name | contains("WinPwn.ps1")) | .browser_download_url')

    # Define download directory
    download_dir=$HOME/tools/windows

    # Download WinPwn.exe
    if [ ! -f "$download_dir/WinPwn.exe" ]; then
        if [ ! -z "$winpwn_exe_url" ]; then
            echo -e "${YELLOW}Downloading WinPwn.exe${NC}"
            curl -L "$winpwn_exe_url" -o "$download_dir/WinPwn.exe" &> /dev/null
            sleep 2
        else
            echo -e "${RED}WinPwn.exe URL not found in the latest release.${NC}"
        fi
    else
        echo -e "${RED}WinPwn.exe is already downloaded.${NC}"
    fi

    # Download WinPwn.ps1
    if [ ! -f "$download_dir/WinPwn.ps1" ]; then
        if [ ! -z "$winpwn_ps1_url" ]; then
            echo -e "${YELLOW}Downloading WinPwn.ps1${NC}"
            curl -L "$winpwn_ps1_url" -o "$download_dir/WinPwn.ps1" &> /dev/null
            sleep 2
        else
            echo -e "${RED}WinPwn.ps1 URL not found in the latest release.${NC}"
        fi
    else
        echo -e "${RED}WinPwn.ps1 is already downloaded.${NC}"
    fi

    echo -e "${GREEN}WinPwn files processing completed.${NC}"
    sleep 2

    # Download linwinpwn
    if [ -d $HOME/tools/linWinPwn ]; then
        echo -e "${RED}linwinpwn is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading linwinpwn${NC}"
        git clone 'https://github.com/lefayjey/linWinPwn.git' $HOME/tools/linWinPwn &> /dev/null
        echo -e "${GREEN}linwinpwn downloaded successfully.${NC}"
        sleep 2 
    fi

    # Download PowerView
    if [ -f $HOME/tools/windows/PowerView.ps1 ]; then
        echo -e "${RED}PowerView has already been downloaded.${NC}"
    else
        wget -q -O $HOME/tools/windows/PowerView.ps1 'https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Recon/PowerView.ps1'
        wget -q -O $HOME/tools/windows/PowerView-Dev.ps1 'https://raw.githubusercontent.com/lucky-luk3/ActiveDirectory/master/PowerView-Dev.ps1'
        echo -e "${GREEN}PowerView has been downloaded successfully.${NC}"
        sleep 2 
    fi

    # Download ADModule
    if [ -d $HOME/tools/windows/ADModule ]; then
        echo -e "${RED}ADModule is already downloaded.${NC}"
    else
        git clone 'https://github.com/samratashok/ADModule.git' $HOME/tools/windows/ADModule &> /dev/null
        echo -e "${GREEN}ADModule downloaded successfully.${NC}"
        sleep 2

    # Install Bloodhound
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

    # Installing knwosmore
    if command -v knowsmore &> /dev/null; then
        echo -e "${RED}knowsmore is already installed.${NC}"
    else
        echo -e "${YELLOW}installing knowsmore${NC}"
        pip3 install knowsmore &> /dev/null
        echo -e "${GREEN}knowsmore installed successfully.${NC}"
        sleep 2
    fi

    if [ -f $HOME/tools/windows/Invoke-Portscan.ps1 ]; then
        echo -e "${RED}Invoke_PortScan has already been copied.${NC}"
    else
        wget -q -O $HOME/tools/windows/Invoke-Portscan.ps1 'https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Recon/Invoke-Portscan.ps1'
        echo -e "${GREEN}Invoke_PortScan has been downloaded successfully.${NC}"
        sleep 2
    fi

    fi

    # Installing SharpHounds
    if [ -d $HOME/tools/windows/SharpHound ]; then
        echo -e "${RED}SharpHound is already downloaded and unzipped.${NC}"
    else
        echo -e "${YELLOW}Checking latest release of SharpHound${NC}"
        json=$(curl -s https://api.github.com/repos/BloodHoundAD/SharpHound/releases/latest)
        download_url=$(echo "$json" | jq -r '.assets[] | select((.name | startswith("SharpHound")) and (.name | contains("debug") | not)) | .browser_download_url')
        echo -e "${YELLOW}Downloading latest release... please wait...${NC}"
        curl -L -o $HOME/tools/windows/SharpHound.zip "$download_url" &> /dev/null
        echo -e "${GREEN}SharpHound downloaded successfully.${NC}"
        unzip -q $HOME/tools/windows/SharpHound.zip -d $HOME/tools/windows/SharpHound &> /dev/null
        rm -rf $HOME/tools/windows/SharpHound.zip
        echo -e "${GREEN}SharpHound unzipped successfully.${NC}"
        sleep 2
    fi

    # Downloading ADEnum
    if [ -f $HOME/tools/windows/Invoke-ADEnum.ps1 ]; then
        echo -e "${RED}ADEnum is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading ADEnum${NC}"
        wget -q -O $HOME/tools/windows/Invoke-ADEnum.ps1 'https://raw.githubusercontent.com/Leo4j/Invoke-ADEnum/main/Invoke-ADEnum.ps1'
        echo -e "${GREEN}ADEnum downloaded successfully.${NC}"
        sleep 2

    # Downloading adPEAS
    if [ -f $HOME/tools/windows/adPEAS.ps1 ]; then
        echo -e "${RED}adPEAS is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading adPEAS${NC}"
        wget -q -O $HOME/tools/windows/adPEAS.ps1 'https://raw.githubusercontent.com/61106960/adPEAS/main/adPEAS.ps1'
        echo -e "${GREEN}adPEAS downloaded successfully.${NC}"
        sleep 2
    fi

    # Downloading netcat (binary)
    if [ -f $HOME/tools/windows/nc.exe ]; then
        echo -e "${RED}nc.exe is already copied.${NC}"
    else
        echo -e "${YELLOW}copying nc.exe${NC}"
        cp /usr/share/windows-binaries/nc.exe $HOME/tools/windows/nc.exe
        sleep 2
    fi

    # installing updog
    if command -v updog &> /dev/null; then
        echo -e "${RED}updog is already installed.${NC}"
    else
        echo -e "${YELLOW}installing updog${NC}"
        pip3 install updog &> /dev/null
        echo -e "${GREEN}updog installed successfully.${NC}"
        sleep 2
    fi

    # Download HFS (binary)
    if [ -f $HOME/tools/windows/hfs.exe ]; then
        echo -e "${RED}HFS is already downloaded.${NC}"

        if [ -d $HOME/tools/windows/hfs-windows/plugins/ ]; then
            echo -e "${GREEN}HFS plugins folder removed successfully.${NC}"
        else
            echo -e "${RED}HFS plugins folder does not exist or has already been removed.${NC}"
        fi
    else
        echo -e "${YELLOW}Downloading HFS${NC}"
        json=$(curl -s https://api.github.com/repos/rejetto/hfs/releases/latest)
        download_url=$(echo "$json" | jq -r '.assets[] | select(.name | contains("hfs-windows.zip")) | .browser_download_url')
        curl -L -o $HOME/tools/windows/hfs-windows.zip "$download_url"
        echo -e "${GREEN}HFS downloaded successfully.${NC}"
        echo -e "${YELLOW}Unzipping HFS${NC}"
        unzip -q $HOME/tools/windows/hfs-windows.zip -d $HOME/tools/windows/
        rm -rf $HOME/tools/windows/hfs-windows
        rm -rf $HOME/tools/windows/hfs-windows.zip
        rm -rf $HOME/tools/windows/plugins
        echo -e "${GREEN}HFS unzipped successfully.${NC}"

        if [ -d $HOME/tools/windows/hfs-windows/plugins/ ]; then
            rm -rf $HOME/tools/windows/hfs-windows/plugins/
            echo -e "${GREEN}HFS plugins folder removed successfully.${NC}"
        fi
    fi
    
    sleep 2

    #Downloading Ghostpack Compiled Binaries
    if [ -d $HOME/tools/windows/Ghostpack-CompiledBinaries ]; then
        echo -e "${RED}Ghostpack Compiled Binaries is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading Compiled GhostPack Binaries${NC}"
        git clone https://github.com/r3motecontrol/Ghostpack-CompiledBinaries.git $HOME/tools/Ghostpack/ &> /dev/null
        cp -r $HOME/tools/Ghostpack/* $HOME/tools/windows/
        rm -rf $HOME/tools/Ghostpack
        rm -rf $HOME/tools/windows/README.md
        echo -e "${GREEN}Ghostpack downloaded successfully.${NC}"
        sleep 2
    fi

    # Downloading LaZagne binary
    if [ -f "$HOME/tools/windows/LaZagne.exe" ]; then
        echo -e "${GREEN}LaZagne.exe already exists in $HOME/tools/windows/.${NC}"
        return
    fi

    # Get latest release data from GitHub for LaZagne
    echo -e "${YELLOW}Retrieving LaZagne latest release information${NC}"
    json=$(curl -s https://api.github.com/repos/AlessandroZ/LaZagne/releases/latest)

    # Extract download URL for LaZagne.exe
    lazagne_exe_url=$(echo "$json" | jq -r '.assets[] | select(.name | endswith("LaZagne.exe")) | .browser_download_url')

    # Download LaZagne.exe
    if [ ! -z "$lazagne_exe_url" ]; then
        echo -e "${YELLOW}Downloading LaZagne.exe${NC}"
        curl -L "$lazagne_exe_url" -o $HOME/tools/windows/LaZagne.exe &> /dev/null
    else
        echo -e "${RED}LaZagne.exe URL not found in the latest release.${NC}"
    sleep 2
    fi
    
fi
}

function red_team_menu() {
    clear
    echo -e ""
    cat << "EOF"
__________           .___ ___________                     ________               
\______   \ ____   __| _/ \__    ___/___ _____    _____   \_____  \ ______  ______
 |       _// __ \ / __ |    |    |_/ __ \\__  \  /     \   /   |   \\____ \/  ___/
 |    |   \  ___// /_/ |    |    |\  ___/ / __ \|  Y Y  \ /    |    \  |_> >___ \ 
 |____|_  /\___  >____ |    |____| \___  >____  /__|_|  / \_______  /   __/____  >
        \/     \/     \/               \/     \/      \/          \/|__|       \/ 
EOF
echo
    echo -e "Key      Menu Option:"
    echo -e "---      -------------------------"
    echo -e " 1    -  C2 Frameworks"
    echo -e " 2    -  Download/Install Windows Red Teaming Arsenal"
    echo -e " 3    -  Phishing"
    echo -e " 4    -  Windows Privilege Escalation Tools"
    echo -e " 5    -  Linux Privilege Escalation Tools"
    echo ""
    echo -e "${BLUE} 0    -  Back to Main Menu"${NC}
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        0) main_menu;;
        1) command_and_control;;
        2) download_Install_windows-resource;red_team_menu;;
        3) phishing;;
        4) Windows_Privilege_Escalation_Tools;;
        5) Linux_Privilege_Escalation_Tools;;
        *) echo "Invalid option"; red_team_menu;;
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
    mkdir -p $HOME/tools/phishing/
    if [ -d $HOME/tools/phishing/gophish ]; then
        echo -e "${RED}gophish is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading gophish${NC}"
        git clone 'https://github.com/gophish/gophish.git' $HOME/tools/phishing/gophish
        echo -e "${GREEN}gophish downloaded successfully.${NC}"
    fi

    if [ -f $HOME/tools/phishing/gophish/gophish ]; then
        echo -e "${RED}gophish is already built.${NC}"
    else
        cd $HOME/tools/phishing/gophish
        echo -e "${YELLOW}Building gophish${NC}"
        sudo go build
        echo -e "${GREEN}gophish built successfully.${NC}"
    fi
    sleep 2
}

function download_PyPhisher() {
    mkdir -p $HOME/tools/phishing/
    if [ -d $HOME/tools/phishing/PyPhisher ]; then
        echo -e "${RED}PyPhisher is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading PyPhisher${NC}"
        git clone 'https://github.com/KasRoudra/PyPhisher.git' $HOME/tools/phishing/PyPhisher
        echo -e "${GREEN}PyPhisher downloaded successfully.${NC}"
    fi
    
    if [ -f $HOME/tools/phishing/PyPhisher/files/requirements.txt ]; then
        echo -e "${RED}Requirements of PyPhisher are already installed.${NC}"
    else
        echo -e "${YELLOW}Installing PyPhisher requirements${NC}"
        cd $HOME/tools/phishing/PyPhisher/files/
        pip3 install -r requirements.txt
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
echo
    echo -e "\n Select an option from menu:"
    echo -e "\nKey     Menu Option:"
    echo -e "---     -------------------------"
    echo -e " 1   -  Install evilginx2"
    echo -e " 2   -  Download gophish"
    echo -e " 3   -  Download PyPhisher"
    echo ""
    echo -e " A   -  Download/Install All Tools"
    echo ""
    echo -e "${BLUE} 0    -  Back to Red Team Menu"${NC}
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) install_evilginx2; phishing;;
        2) download_gophish; phishing;;
        3) download_PyPhisher; phishing;;
        A) download_install_all_phishing_tools; phishing;;
        0) red_team_menu;;
        *) echo "Invalid option"; phishing;;
    esac
}

# --[ Windows Privilege Escalation ]--
function get_PowerUp_ps1() {
    mkdir -p $HOME/tools/windows/
    if [ -f $HOME/tools/windows/PowerUp.ps1 ]; then
        echo -e "${YELLOW}PowerUp.ps1 is already copied.${NC}"
    else
        echo -e "${YELLOW}copying PowerUp.ps1${NC}"
        cp /usr/share/windows-resources/powersploit/Privesc/PowerUp.ps1 $HOME/tools/windows/PowerUp.ps1
        echo -e "${GREEN}PowerUp has been copied successfully.${NC}"
    fi
    sleep 2
}

function download_PowerUpSQL() {
    mkdir -p $HOME/tools/windows/ 
    if [ -f $HOME/tools/windows/PowerUpSQL ]; then
        echo -e "${RED}PowerUpSQL is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading PowerUpSQL${NC}"
        git clone https://github.com/NetSPI/PowerUpSQL.git $HOME/tools/windows/PowerUpSQL
        echo -e "${GREEN}PowerUpSQL downloaded successfully.${NC}"
    fi
    sleep 2
}

function get_system() {
    mkdir -p $HOME/tools/windows/
    if [ -f $HOME/tools/windows/Get-System.ps1 ]; then
        echo -e "${RED}Get-System.ps1 is already copied.${NC}"
    else
        echo -e "${YELLOW}copying Get_System.ps1${NC}"
        cp /usr/share/windows-resources/powersploit/Privesc/Get-System.ps1 $HOME/tools/windows/Get-System.ps1
        echo -e "${GREEN}Get-System.ps1 has been copied successfully.${NC}"
    fi
    sleep 2
}

function download_PrivescCheck() {
    mkdir -p $HOME/tools/windows/
    if [ -f $HOME/tools/windows/PrivescCheck.ps1 ]; then
        echo -e "${RED}PrivEscCheck.ps1 is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading PrivescCheck.ps1${NC}"
        wget -q -O $HOME/tools/windows/PrivescCheck.ps1 https://raw.githubusercontent.com/itm4n/PrivescCheck/master/PrivescCheck.ps1
        echo -e "${GREEN}PrivEscCheck.ps1 downloaded successfully.${NC}"
    fi
    sleep 2
}

function download_WinPEAS() {
    mkdir -p $HOME/tools/windows/
    declare -a winPEAS_Versions=("winPEAS.bat" "winPEASany.exe" "winPEASany_ofs.exe" "winPEASx64.exe" "winPEASx64_ofs.exe" "winPEASx86.exe" "winPEASx86_ofs.exe" "winPEAS.ps1")

    for i in "${winPEAS_Versions[@]}";
    do
        if [ -f $HOME/tools/windows/$i ]; then
            echo -e "${RED}$i is already downloaded.${NC}"
        else
            echo -e "${YELLOW}Downloading $i${NC}"
            if [ "$i" == "winPEAS.ps1" ]; then
                wget -q -O $HOME/tools/windows/winPEAS.ps1 https://raw.githubusercontent.com/carlospolop/PEASS-ng/master/winPEAS/winPEASps1/winPEAS.ps1
            else
                wget -q -O $HOME/tools/windows/$i "https://github.com/carlospolop/PEASS-ng/releases/latest/download/$i"
            fi
            echo -e "${GREEN}$i downloaded successfully.${NC}"
        fi
    done
    sleep 2
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
echo
    echo -e "\n Select an option from menu:"
    echo -e "\nKey     Menu Option:"
    echo -e "---     -------------------------"
    echo -e " 1   -  Get PowerUp.ps1"
    echo -e " 2   -  Download PowerUpSQL"
    echo -e " 3   -  Get GetSystem.ps1"
    echo -e " 4   -  Download PrivescCheck.ps1"
    echo -e " 5   -  Download All Version of WinPEAS"
    echo ""
    echo -e " A   -  Download/Install All Tools"
    echo ""
    echo -e "${BLUE} 0    -  Back to Red Team Menu"${NC}
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) get_PowerUp_ps1; Windows_Privilege_Escalation_Tools;;
        2) download_PowerUpSQL; Windows_Privilege_Escalation_Tools;;
        3) get_system; Windows_Privilege_Escalation_Tools;;
        4) download_PrivescCheck; Windows_Privilege_Escalation_Tools;;
        5) download_WinPEAS; Windows_Privilege_Escalation_Tools;;
        A) download_install_all_Windows_Privilege_Escalation_tools; Windows_Privilege_Escalation_Tools;;
        0) red_team_menu;;
        *) echo "Invalid option"; Windows_Privilege_Escalation_Tools;;
    esac
}

# --[ Linux Privilege Escalation ]--
function download_LinEnum() {
    mkdir -p $HOME/tools/linux/
    if [ -f $HOME/tools/linux/LinEnum.sh ]; then
        echo -e "${RED}LinEnum.sh is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading LinEnum.sh${NC}"
        wget -q -O $HOME/tools/linux/LinEnum.sh https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh
        echo -e "${GREEN}LinEnum.sh downloaded successfully.${NC}"
    fi
    sleep 2
}

function download_LinPeas() {
    mkdir -p $HOME/tools/linux/
    if [ -f $HOME/tools/linux/linpeas.sh ]; then
        echo -e "${RED}linpeas.sh is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading linpeas.sh${NC}"
        wget -q -O $HOME/tools/linux/linpeas.sh https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh
        echo -e "${GREEN}linpeas.sh downloaded successfully.${NC}"
    fi
    sleep 2
}

function download_autoSUID() {
    mkdir -p $HOME/tools/linux/
    if [ -f $HOME/tools/linux/AutoSUID.sh ]; then
        echo -e "${RED}AutoSUID is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading AutoSUID${NC}"
        wget -q -O $HOME/tools/linux/AutoSUID.sh https://raw.githubusercontent.com/IvanGlinkin/AutoSUID/main/AutoSUID.sh
        echo -e "${GREEN}AutoSUID.sh downloaded successfully.${NC}"
    fi
    sleep 2
}

function download_GTFONow() {
    mkdir -p $HOME/tools/linux/
    if [ -f $HOME/tools/linux/gtfonow.py ]; then
        echo -e "${RED}GTFONow is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading GTFONow${NC}"
        local file_url=$(curl -s https://api.github.com/repos/Frissi0n/GTFONow/releases/latest | jq -r '.assets[] | select(.name == "gtfonow.py") | .browser_download_url')
        wget -q -O $HOME/tools/linux/gtfonow.py "$file_url"
        echo -e "${GREEN}GTFONow downloaded successfully.${NC}"
    fi
    sleep 2
}


function download_linuxsmartenumeration() {
    mkdir -p $HOME/tools/linux/
    if [ -f $HOME/tools/linux/lse.sh ]; then
        echo -e "${RED}lse.sh is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading lse.sh${NC}"
        wget -q -O $HOME/tools/linux/lse.sh https://raw.githubusercontent.com/diego-treitos/linux-smart-enumeration/master/lse.sh
        echo -e "${GREEN}lse.sh downloaded successfully.${NC}"
    fi
    sleep 2
}

function download_pspy() {
    mkdir -p $HOME/tools/linux/
    declare -a pspy_Versions=("pspy32" "pspy64")

    for version in "${pspy_Versions[@]}";
    do
        if [ -f $HOME/tools/linux/$version ]; then
            echo -e "${RED}$version is already downloaded.${NC}"
        else
            echo -e "${YELLOW}Downloading $version${NC}"
            wget -q -O $HOME/tools/linux/$version "https://github.com/DominicBreuker/pspy/releases/latest/download/$version"
            echo -e "${GREEN}$version downloaded successfully.${NC}"
        fi
    done
    sleep 2
}

function download_install_all_Linux_Privilege_Escalation_tools() {
    download_LinEnum
    download_LinPeas
    download_linuxsmartenumeration
    download_autoSUID
    download_GTFONow
    download_pspy
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
echo
    echo -e "\n Select an option from menu:"
    echo -e "\nKey     Menu Option:"
    echo -e "---     -------------------------"
    echo -e " 1   -  Download LinEnum"
    echo -e " 2   -  Download linPEAS"
    echo -e " 3   -  Download LinuxSmartEnumeration"
    echo -e " 4   -  Download AutoSUID"
    echo -e " 5   -  Download GTFONow"
    echo -e " 6   -  Download pspy32/pspy64"
    echo ""
    echo -e " A   -  Download/Install All Tools"
    echo ""
    echo -e "${BLUE} 0    -  Back to Red Team Menu"${NC}
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) download_LinEnum; Linux_Privilege_Escalation_Tools;;
        2) download_LinPeas; Linux_Privilege_Escalation_Tools;;
        3) download_linuxsmartenumeration; Linux_Privilege_Escalation_Tools;;
        4) download_autoSUID; Linux_Privilege_Escalation_Tools;;
        5) download_GTFONow; Linux_Privilege_Escalation_Tools;;
        6) download_pspy; Linux_Privilege_Escalation_Tools;;
        A) download_install_all_Linux_Privilege_Escalation_tools; Linux_Privilege_Escalation_Tools;;
        0) red_team_menu;;
        *) echo "Invalid option"; Linux_Privilege_Escalation_Tools;;
    esac
}

# --[ Web Application - Bug Bounty Tools ]--
function Bug_Bounty_Tools() {
    if ! command -v pdtm &> /dev/null; then
        echo -e "${RED}Installing ProjectDiscovery's Open Source Tool Manager.${NC}"
        go install -v github.com/projectdiscovery/pdtm/cmd/pdtm@latest
        mv $HOME/go/bin/pdtm /usr/local/bin
        pdtm -ia
        pdtm -ua
    else
        echo -e "${GREEN}ProjectDiscovery's Open Source Tool Manager is already installed.${NC}"
        sleep 2
        echo -e "${GREEN}Updating all the tools${NC}"
        pdtm -ia
        pdtm -ua
    fi

    if ! command -v axiom-scan &> /dev/null; then
        echo -e "${RED}Installing Axiom now${NC}"
        
        PS3='Please enter your choice: '
        options=("Install via Docker" "Install via Bash Script" "Cancel")
        select opt in "${options[@]}"
        do
            case $opt in
                "Install via Docker")
                    echo -e "${YELLOW}Installing Axiom via Docker...${NC}"
                    docker exec -it $(docker run -d -it --platform linux/amd64 ubuntu:20.04) sh -c "apt update && apt install git -y && git clone https://github.com/pry0cc/axiom $HOME/.axiom/ && cd && .axiom/interact/axiom-configure"
                    break
                    ;;
                "Install via Bash Script")
                    echo -e "${YELLOW}Installing Axiom via Bash Script...${NC}"
                    bash <(curl -s https://raw.githubusercontent.com/pry0cc/axiom/master/interact/axiom-configure)
                    break
                    ;;
                "Cancel")
                    echo "Installation cancelled."
                    break
                    ;;
                *) echo "Invalid option $REPLY";;
            esac
        done

        echo -e "${GREEN}Axiom has been installed${NC}"
    else
        echo -e "${YELLOW}Axiom is already installed${NC}"
    fi

    if ! command -v httprobe &> /dev/null; then
        echo -e "${RED}Installing httprobe now${NC}"
        go install github.com/tomnomnom/httprobe@latest &> /dev/null
        mv $HOME/go/bin/httprobe /usr/local/bin
        echo -e "${GREEN}httprobe has been installed${NC}"
    else
        echo -e "${GREEN}httprobe is already installed${NC}"
    fi

    if ! command -v amass &> /dev/null; then
        echo -e "${RED}Installing amass now${NC}"
        sudo apt install amass -y &> /dev/null
        echo -e "${GREEN}amass has been installed${NC}"
    else
        echo -e "${GREEN}amass is already installed${NC}"
    fi

    if ! command -v gobuster &> /dev/null; then
        echo -e "${RED}Installing gobuster now${NC}"
        sudo apt install gobuster -y &> /dev/null
        echo -e "${GREEN}GoBuster has been installed${NC}"
    else
        echo -e "${GREEN}Gobuster is already installed${NC}"
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
        go install github.com/ffuf/ffuf@latest &> /dev/null
        echo -e "${GREEN}ffuf has been installed${NC}"
    else
        echo -e "${GREEN}ffuf is already installed${NC}"
    fi

    if ! command -v gf &> /dev/null; then
        echo -e "${RED}Installing gf now${NC}"
        go install github.com/tomnomnom/gf@latest &> /dev/null
        echo -e "${GREEN}gf has been installed${NC}"
    else
        echo -e "${GREEN}gf is already installed${NC}"
    fi

    if ! command -v meg &> /dev/null; then
        echo -e "${RED}Installing meg now${NC}"
        go install github.com/tomnomnom/meg@latest &> /dev/null
        echo -e "${GREEN}meg has been installed${NC}"
    else
        echo -e "${GREEN}meg is already installed${NC}"
    fi

    if ! command -v waybackurls &> /dev/null; then
        echo -e "${RED}Installing waybackurls now${NC}"
        go install github.com/tomnomnom/waybackurls@latest &> /dev/null
        echo -e "${GREEN}waybackurls has been installed${NC}"
    else
        echo -e "${GREEN}waybackurls is already installed${NC}"
    fi

    if ! command -v subzy &> /dev/null; then
        go install -v github.com/LukaSikic/subzy@latest &> /dev/null
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
        echo -e "${GREEN}dnsx has been installed${NC}"
    else
        echo -e "${GREEN}dnsx is already installed${NC}"
    fi

    if ! command -v gospider &> /dev/null; then
        echo -e "${RED}Installing gospider now${NC}"
        go install github.com/jaeles-project/gospider@latest &> /dev/null
        echo -e "${GREEN}gospider has been installed${NC}"
    else
        echo -e "${GREEN}gospider is already installed${NC}"
    fi

    if ! command -v CRLFuzz &> /dev/null; then
        echo -e "${RED}Installing CRLFuzz now${NC}"
        go install github.com/dwisiswant0/crlfuzz/cmd/crlfuzz@latest &> /dev/null
        echo -e "${GREEN}CRLFuzz has been installed${NC}"
    else
        echo -e "${GREEN}CRLFuzz is already installed${NC}"
    fi

    if ! command -v uncover &> /dev/null; then
        echo -e "${RED}Installing uncover now${NC}"
        go install -v github.com/projectdiscovery/uncover/cmd/uncover@latest &> /dev/null
        echo -e "${GREEN}uncover has been installed${NC}"
    else
        echo -e "${GREEN}uncover is already installed${NC}"
    fi

    if ! command -v dalfox &> /dev/null; then
        echo -e "${RED}Installing Dalfox now${NC}"
        go install github.com/hahwul/dalfox/v2@latest &> /dev/null
        echo -e "${GREEN}dalfox has been installed${NC}"
    else
        echo -e "${GREEN}dalfox is already installed${NC}"
    fi

    if ! command -v GoLinkFinder &> /dev/null; then
        echo -e "${RED}Installing GoLinkFinder now${NC}"
        go install github.com/0xsha/GoLinkFinder@latest &> /dev/null
        echo -e "${GREEN}GoLinkFinder has been installed${NC}"
    else
        echo -e "${GREEN}GoLinkFinder is already installed${NC}"
    fi

    if ! command -v hakrawler &> /dev/null; then
        echo -e "${RED}Installing hakrawler now${NC}"
        go install github.com/hakluke/hakrawler@latest &> /dev/null
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

    if command -v parshu &> /dev/null; then
        echo -e "${RED}parshu is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing parshu${NC}"
        pip3 install parshu &> /dev/null
        echo -e "${GREEN}parshu installed successfully.${NC}"
    fi

    if command -v corscanner &> /dev/null; then
        echo -e "${RED}corscanner is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing corscanner${NC}"
        pip3 install corscanner &> /dev/null
        echo -e "${GREEN}corscanner installed successfully.${NC}"
    fi

    if ! command -v kxss &> /dev/null; then
        echo -e "${RED}Installing kxss now${NC}"
        go install github.com/Emoe/kxss@latest &> /dev/null
        echo -e "${GREEN}kxss has been installed${NC}"
    else
        echo -e "${GREEN}kxss is already installed${NC}"
    fi

    if ! command -v Gxss &> /dev/null; then
        echo -e "${RED}Installing Gxss now${NC}"
        go install github.com/KathanP19/Gxss@latest &> /dev/null
        echo -e "${GREEN}Gxss has been installed${NC}"
    else
        echo -e "${GREEN}Gxss is already installed${NC}"
    fi

    if ! command -v anew &> /dev/null; then
        echo -e "${RED}Installing anew now${NC}"
        go install -v github.com/tomnomnom/anew@latest &> /dev/null
        echo -e "${GREEN}anew has been installed${NC}"
    else
        echo -e "${GREEN}anew is already installed${NC}"
    fi

    if ! command -v qsreplace &> /dev/null; then
        echo -e "${RED}Installing qsreplace now${NC}"
        go install github.com/tomnomnom/qsreplace@latest &> /dev/null
        echo -e "${GREEN}qsreplace has been installed${NC}"
    else
        echo -e "${GREEN}qsreplace is already installed${NC}"
    fi

    if ! command -v gau &> /dev/null; then
        echo -e "${RED}Installing gau now${NC}"
        go install github.com/lc/gau/v2/cmd/gau@latest &> /dev/null
        echo -e "${GREEN}gau has been installed${NC}"
    else
        echo -e "${GREEN}gau is already installed${NC}"
    fi

    if ! command -v smap &> /dev/null; then
        echo -e "${RED}Installing smap now${NC}"
        go install -v github.com/s0md3v/smap/cmd/smap@latest &> /dev/null
        echo -e "${GREEN}smap has been installed${NC}"
    else
        echo -e "${GREEN}smap is already installed${NC}"
    fi

    if ! command -v qsreplace &> /dev/null; then
        echo -e "${RED}Installing qsreplace now${NC}"
        go install github.com/tomnomnom/qsreplace@latest
        echo -e "${GREEN}qsreplace has been installed${NC}"
    else
        echo -e "${GREEN}qsreplace is already installed${NC}"
    fi

    if [ -d $HOME/tools/web_app/SSTImap ]; then
        echo -e "${RED}SSTImap is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing SSTImap${NC}"
        git clone 'https://github.com/vladko312/SSTImap.git' $HOME/tools/web_app/SSTImap &> /dev/null
        pip install -r $HOME/tools/web_app/SSTImap/requirements.txt &> /dev/null
        chmod +x $HOME/tools/web_app/SSTImap/sstimap.py
        echo -e "${GREEN}SSTImap installed successfully${NC}"
    fi

    if [ -d $HOME/tools/web_app/SSRFmap ]; then
        echo -e "${RED}SSRFmap is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing SSRFmap${NC}"
        git clone 'https://github.com/swisskyrepo/SSRFmap.git' $HOME/tools/web_app/SSRFmap &> /dev/null
        echo -e "${GREEN}SSRFmap installed successfully${NC}"
    fi

    if [ -d $HOME/tools/web_app/EyeWitness ]; then
        echo -e "${RED}EyeWitness is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading EyeWitness${NC}"
        git clone https://github.com/RedSiege/EyeWitness.git $HOME/tools/web_app/EyeWitness &> /dev/null
        echo -e "${GREEN}EyeWitness downloaded successfully.${NC}"
        echo -e "${YELLOW}Installing EyeWitness${NC}"
        HOME/tools/web_app/EyeWitness/Python/setup/setup.sh &> /dev/null
        echo -e "${GREEN}EyeWitness installed successfully.${NC}"
    fi

    if ! command -v paramspider &> /dev/null; then 
        echo -e "${YELLOW}Installing ParamSpider${NC}"
        git clone https://github.com/devanshbatham/paramspider.git $HOME/tools/web_app/paramspider &> /dev/null
        cd $HOME/tools/web_app/paramspider || exit 
        pip install . &> /dev/null
        echo -e "${GREEN}ParamSpider installed successfully${NC}"
    else
        echo -e "${RED}ParamSpider is already installed.${NC}"
    fi 

    if ! command -v openredirex &> /dev/null; then 
        echo -e "${YELLOW}Installing OpenRedireX${NC}"
        git clone https://github.com/devanshbatham/openredirex.git $HOME/tools/web_app/openredirex &> /dev/null
        cd $HOME/tools/web_app/openredirex 
        chmod +x setup.sh && ./setup.sh &> /dev/null
        echo -e "${GREEN}OpenRedireX installed successfully${NC}"
    else
        echo -e "${RED}OpenRedireX is already installed.${NC}"
    fi 

    if ! command -v headerpwn &> /dev/null; then
        echo -e "${RED}Installing headerpwn now${NC}"
        go install github.com/devanshbatham/headerpwn@latest &> /dev/null
        echo -e "${GREEN}headerpwn has been installed${NC}"
    else
        echo -e "${GREEN}headerpwn is already installed${NC}"
    fi

    if ! command -v rayder &> /dev/null; then
        echo -e "${RED}Installing rayder now${NC}"
        go install github.com/devanshbatham/rayder@latest &> /dev/null
        echo -e "${GREEN}rayder has been installed${NC}"
    else
        echo -e "${GREEN}rayder is already installed${NC}"
    fi
    
    if command -v userefuzz &> /dev/null; then
        echo -e "${RED}userefuzz is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing userefuzz${NC}"
        pip3 install userefuzz &> /dev/null
        echo -e "${GREEN}userefuzz installed successfully.${NC}"
    fi

    if command -v smap &> /dev/null; then
        echo -e "${RED}smap is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing smap${NC}"
        go install -v github.com/s0md3v/smap/cmd/smap@latest &> /dev/null
        echo -e "${GREEN}smap installed successfully.${NC}"
    fi
    
    if [ -f $HOME/tools/web_app/dontgo403_linux_amd64 ]; then
        echo -e "${RED}dontgo403 is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading dontgo403${NC}"
        # Get the latest release URL
        RELEASE_URL=$(curl -s https://api.github.com/repos/devploit/dontgo403/releases/latest | grep 'browser_' | cut -d\" -f4 | grep 'dontgo403_linux_amd64')
        
        wget -q "$RELEASE_URL" -O $HOME/tools/web_app/dontgo403 &> /dev/null
        chmod +x $HOME/tools/web_app/dontgo403
        echo -e "${GREEN}dontgo403 downloaded successfully.${NC}"
    fi
    
    # Moving every go binary in /usr/local/bin
    sudo mv $HOME/go/bin/* /usr/local/bin

    sleep 2
}

function appsec_menu() {
    clear
    echo -e ""
    cat << "EOF"
   _____                .__  .__               __  .__                  _________                          .__  __          
  /  _  \ ______ ______ |  | |__| ____ _____ _/  |_|__| ____   ____    /   _____/ ____   ____  __ _________|__|/  |_ ___.__.
 /  /_\  \\____ \\____ \|  | |  |/ ___\\__  \\   __\  |/  _ \ /    \   \_____  \_/ __ \_/ ___\|  |  \_  __ \  \   __<   |  |
/    |    \  |_> >  |_> >  |_|  \  \___ / __ \|  | |  (  <_> )   |  \  /        \  ___/\  \___|  |  /|  | \/  ||  |  \___  |
\____|__  /   __/|   __/|____/__|\___  >____  /__| |__|\____/|___|  / /_______  /\___  >\___  >____/ |__|  |__||__|  / ____|
        \/|__|   |__|                \/     \/                    \/          \/     \/     \/                       \/     
EOF
echo
    echo -e "Key      Menu Option:"
    echo -e "---      -------------------------"
    echo -e " 1    -  Bug Bounty Tools"
    echo -e " 2    -  API Penetration Testing Tools"
    echo -e " 3    -  Mobile Application Penetration Testing Tools"
    echo ""
    echo -e " A    -  Download/Install all Appsec tools"
    echo ""
    echo -e "${BLUE} 0    -  Back to Main Menu"${NC}
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        0) main_menu;;
        1) Bug_Bounty_Tools; appsec_menu;;
        2) API_Tools;;
        3) Mobile_App_Tools;;
        A) install_all_appsectools; appsec_menu;;
        *) echo "Invalid option"; appsec_menu;;
    esac
}

    # --[ API Pentesting tools ]--
function install_mitmproxy2swagger() {
    if command -v mitmproxy2swagger &> /dev/null; then
        echo -e "${RED}mitmproxy2swagger is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing mitmproxy2swagger${NC}"
        pip3 install mitmproxy2swagger &> /dev/null
        echo -e "${GREEN}mitmproxy2swagger installed successfully.${NC}"
    fi
    sleep 2
}

function install_postman() {
    mkdir -p $HOME/tools/api
    if [ -d $HOME/tools/api/Postman ]; then
        echo -e "${RED}Postman is already installed.${NC}"
    else
        echo -e "${YELLOW}Downloading and installing latest Postman${NC}"
        wget https://dl.pstmn.io/download/latest/linux64 -O postman-linux-x64.tar.gz &> /dev/null
        tar -zxvf postman-linux-x64.tar.gz -C $HOME/tools/api &> /dev/null
        rm -rf postman-linux-x64.tar.gz
        ln -sf $HOME/tools/api/Postman/Postman /usr/bin/postman
        echo -e "${GREEN}Postman installed successfully.${NC}"
    fi
    sleep 2
}

function install_jwt_tool() {
    mkdir -p $HOME/tools/api
    if [ -d $HOME/tools/api/jwt_tool ]; then
        echo -e "${RED}jwt_tool is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing jwt_tool${NC}"
        git clone https://github.com/ticarpi/jwt_tool.git $HOME/tools/api/jwt_tool
        pip3 install -r $HOME/tools/api/jwt_tool/requirements.txt &> /dev/null
        chmod +x $HOME/tools/api/jwt_tool/jwt_tool.py
        ln -sf $HOME/tools/api/jwt_tool/jwt_tool.py /usr/bin/jwt_tool
        echo -e "${GREEN}jwt_tool installed successfully.${NC}"
    fi
    sleep 2
}

function install_kiterunner() {
    mkdir -p $HOME/tools/api
    if [ -d $HOME/tools/api/kiterunner ]; then
        echo -e "${RED}kiterunner is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing kiterunner${NC}"
        git clone https://github.com/assetnote/kiterunner.git $HOME/tools/api/kiterunner &> /dev/null
        make -C $HOME/tools/api/kiterunner build &> /dev/null
        ln -sf $HOME/tools/api/kiterunner/dist/kr /usr/bin/kr
        echo -e "${GREEN}kiterunner installed successfully.${NC}"
    fi
    sleep 2
}

function install_arjun() {
    mkdir -p $HOME/tools/api
    if [ -d $HOME/tools/api/Arjun ]; then
        echo -e "${RED}Arjun is already installed.${NC}"
    else
        echo -e "${YELLOW}Installing Arjun${NC}"
        git clone https://github.com/s0md3v/Arjun.git $HOME/tools/api/Arjun &> /dev/null
        cd $HOME/tools/api/Arjun 
        python3 setup.py install &> /dev/null
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
echo
    echo -e "\n Select an option from menu:"
    echo -e "\nKey     Menu Option:"
    echo -e "---     -------------------------"
    echo -e " 1   -  Install mitmproxy2swagger"
    echo -e " 2   -  Install postman "
    echo -e " 3   -  install jwt tool"
    echo -e " 4   -  Install kiterunner"
    echo -e " 5   -  Install arjun"
    echo ""    
    echo -e " A   -  Download/Install All Tools"
    echo ""
    echo -e "${BLUE} 0    -  Back to AppSec Menu"${NC}
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) install_mitmproxy2swagger; API_Tools;;
        2) install_postman; API_Tools;;
        3) install_jwt_tool; API_Tools;;
        4) install_kiterunner; API_Tools;;
        5) install_arjun; API_Tools;;
        A) download_install_all_API_tools; API_Tools;;
        0) appsec_menu;;
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

function insall_apkleaks() {
    if command -v apkleaks &> /dev/null; then
	echo -e "${RED}apkleaks is already installed.${NC}"
    else
	echo -e "${YELLOW}Installing apkleaks${NC}"
	pip3 install apkleaks
	echo -e "${GREEN}apkleaks installed successfully.${NC}"
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
    mkdir -p $HOME/tools/mobile_app

    # Check if MobSF is already installed
    if [ -d $HOME/tools/mobile_app/MobSF ]; then
        echo -e "${RED}Mobile-Security-Framework-MobSF is already installed via GitHub.${NC}"
    elif docker images | grep -q 'opensecurity/mobile-security-framework-mobsf'; then
        echo -e "${RED}Mobile-Security-Framework-MobSF Docker image is already present.${NC}"

        # Ask for creating run script if not already there
        if [ ! -f $HOME/tools/mobile_app/run_mobsf.sh ]; then
            echo ""
            echo -e "${YELLOW}Would you like to have the following script to run MobSF Docker container?:${NC}"
            echo -e "${GREEN}
#!/bin/bash
read -p \"Would you like to start MobSF? [Y/n] \" response
if [[ \"\$response\" =$~ ^([yY][eE][sS]|[yY])+$ ]]
then
    docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest
else
    echo \"MobSF will not be started. Run this script again if you change your mind.\"
fi
${NC}"
            read -p "I will save it under this path $HOME/tools/mobile_app choose [Y/n] " response
            if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
            then
                echo -e "${YELLOW}Creating script to run MobSF Docker container${NC}"
                cat << EOF > ~/tools/mobile_app/run_mobsf.sh
#!/bin/bash
read -p "Would you like to start MobSF? [Y/n] " response
if [[ "\$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest
else
    echo "MobSF will not be started. Run this script again if you change your mind."
fi
EOF
                chmod +x $HOME/tools/mobile_app/run_mobsf.sh
                echo -e "${GREEN}Script created successfully. Run $HOME/tools/mobile_app/run_mobsf.sh to start MobSF.${NC}"
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
                git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF $HOME/tools/mobile_app/MobSF
                chmod +x $HOME/tools/mobile_app/MobSF/*.sh
                cd $HOME/tools/mobile_app/MobSF/
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
    install_apkleaks
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
echo
    echo -e "\n Select an option from menu:"
    echo -e "\nKey     Menu Option:"
    echo -e "---     -------------------------"
    echo -e " 1   -  Install aapt"
    echo -e " 2   -  Install apktool "
    echo -e " 3   -  install adb"
    echo -e " 4   -  Install apksigner"
    echo -e " 5   -  Install apkleaks"
    echo -e " 6   -  Install zipalign"
    echo -e " 7   -  Install wkhtmltopdf"
    echo -e " 8   -  Install default-jdk"
    echo -e " 9   -  Install jadx"
    echo -e " 10   -  Install MobFS"
    echo ""
    echo -e " A   -  Download/Install All Tools"
    echo ""
    echo -e "${BLUE} 0    -  Back to AppSec Menu"${NC}
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) install_aapt; Mobile_App_Tools;;
        2) install_apktool; Mobile_App_Tools;;
        3) install_adb; Mobile_App_Tools;;
        4) install_apksigner; Mobile_App_Tools;;
	5) install_apkleaks; Mobile_App_Tools;;
        6) install_zipalign; Mobile_App_Tools;;
        7) install_wkhtmltopdf; Mobile_App_Tools;;
        8) install_default_jdk; Mobile_App_Tools;;
        9) install_jadx; Mobile_App_Tools;;
        10) install_MobSF; Mobile_App_Tools;;
        A) download_install_all_Mobile_App_tools; Mobile_App_Tools;;
        0) appsec_menu;;
        *) echo "Invalid option"; Mobile_App_Tools;;
    esac
}

# --[ Reporting tools ]--
function download_pwndoc() {
    mkdir -p $HOME/tools/reporting/
    if [ -d $HOME/tools/reporting/pwndoc ]; then
        echo -e "${RED}pwndoc is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading pwndoc${NC}"
        git clone 'https://github.com/pwndoc/pwndoc.git' $HOME/tools/reporting/pwndoc 
        echo -e "${GREEN}pwndoc downloaded successfully.${NC}"
    fi
    sleep 2
}

function download_ghostwriter() {
    mkdir -p $HOME/tools/reporting/
    if [ -d $HOME/tools/reporting/ghostwriter ]; then
        echo -e "${RED}ghostwriter is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Downloading ghostwriter${NC}"
        git clone 'https://github.com/GhostManager/Ghostwriter.git' $HOME/tools/reporting/ghostwriter 
        echo -e "${GREEN}ghostwriter downloaded successfully.${NC}"
    fi
    sleep 2
}

function install_Sysreptor() {
    mkdir -p $HOME/tools/reporting/
    if [ -d $HOME/tools/reporting/OSCP-Reporting ]; then
        echo -e "${RED}OSCP-Reporting is already downloaded.${NC}"
    else
        echo -e "${YELLOW}Installing OSCP-Reporting${NC}"
        curl -s https://docs.sysreptor.com/install.sh | bash
        rm -rf /opt/sysreptor.tar.gz
        echo -e "${GREEN}OSCP-Reporting installed successfully.${NC}"
    fi
    sleep 2
}

function download_install_all_Reporting_tools() {
    download_pwndoc
    download_ghostwriter
    install_Sysreptor
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
echo
    echo -e "\n Select an option from menu:"
    echo -e "\nKey     Menu Option:"
    echo -e "---     -------------------------"
    echo -e " 1   -  Download pwndoc"
    echo -e " 2   -  Download ghostwriter"
    echo -e " 3   -  Install Sysreport"
    echo ""
    echo -e " A   -  Download/Install all Reporting tools"
    echo ""
    echo -e "${BLUE} 0    -  Back to Main Menu"${NC}
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) download_pwndoc; Reporting_Tools;;
        2) download_ghostwriter; Reporting_Tools;;
        3) install_Sysreptor; Reporting_Tools;;
        A) download_install_all_Reporting_tools; Reporting_Tools;;
        0) main_menu;;
        *) echo "Invalid option"; Reporting_Tools;;
    esac
}

function install_all_appsectools() {
    Bug_Bounty_Tools
    download_install_all_API_tools
    download_install_all_Mobile_App_tools
}

function run_pimpmykali() {
    echo -e "${RED}Downloading pimpmykali${NC}"
    git clone 'https://github.com/Dewalt-arch/pimpmykali.git' $HOME/tools/pimpmykali
    cd $HOME/tools/pimpmykali
    chmod +x pimpmykali.sh
    exec sudo ./pimpmykali.sh
    rm -rf $HOME/tools/pimpmykali
}

function install_vscode() {
    if command -v code &> /dev/null; then
        echo -e "${GREEN}Visual Studio Code is already installed${NC}"
        sleep 2
    else
        echo -e "${YELLOW}Downloading Visual Studio Code${NC}"
        wget -O vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
        echo -e "${GREEN}Installing Visual Studio Code${NC}"
        dpkg -i vscode.deb
        sudo apt-get install -f # This line is to fix any missing dependencies if dpkg couldn't handle them
        rm vscode.deb
        echo -e "${GREEN}Visual Studio Code installed successfully.${NC}"
        sleep 2
    fi
}

function install_kali_clean() {
    # Create a temporary directory
    TEMP_DIR=$(mktemp -d)

    # Clone the git repository
    echo "${YELLOW}Cloning kali-clean repository...${NC}"
    git clone https://github.com/xct/kali-clean.git $TEMP_DIR/kali-clean

    # Change the permissions of install.sh to make it executable
    echo "${YELLOW}Changing permissions of install.sh...${NC}"
    chmod +x $TEMP_DIR/kali-clean/install.sh

    # Run install.sh
    echo "${YELLOW}Running install.sh...${NC}"
    $TEMP_DIR/kali-clean/install.sh

    # Remove the temporary directory
    rm -rf $TEMP_DIR

    echo "${GREEN}Installation of kali-clean is complete. Please Reboot your kali machine${NC}"
}

function install_arsenal() {
    if ! pip3 list 2>/dev/null | grep -q arsenal-cli; then
        echo -e "${YELLOW}Installing arsenal-cli.${NC}"
        python3 -m pip install arsenal-cli
        echo -e "${GREEN}arsenal-cli installed successfully.${NC}"
    else
        echo -e "${RED}arsenal-cli is already installed.${NC}"
    fi
    sleep 2
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
    echo -e "\n Select an option from the menu:"
    echo ""
    echo -e "\nKey      Menu Option:"
    echo -e "---      -------------------------"
    echo -e " 1    -  ${RED}Red Team Operations${NC}"
    echo -e " 2    -  ${YELLOW}Application Security${NC}"
    echo -e " 3    -  ${GREEN}Reporting${NC}"
    echo -e " 4    -  Miscellaneous"
    echo ""
    echo -e "${BLUE} 0  -  Quit"${NC}
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        1) red_team_menu;;
        2) appsec_menu;;
        3) Reporting_Tools;;
        4) miscellaneous_menu;;
        0) exit;;
        *) echo "Invalid option"; main_menu;;
    esac
}

function miscellaneous_menu() {
    clear
    echo -e ""
    cat << "EOF"
   _____  .__                    .__  .__                                           
  /     \ |__| ______ ____  ____ |  | |  | _____    ____   ____  ____  __ __  ______
 /  \ /  \|  |/  ___// ___\/ __ \|  | |  | \__  \  /    \_/ __ \/  _ \|  |  \/  ___/
/    Y    \  |\___ \\  \__\  ___/|  |_|  |__/ __ \|   |  \  ___(  <_> )  |  /\___ \ 
\____|__  /__/____  >\___  >___  >____/____(____  /___|  /\___  >____/|____//____  >
        \/        \/     \/    \/               \/     \/     \/                 \/ 
EOF
echo
    echo -e "Key      Menu Option:"
    echo -e "---      -------------------------"
    echo -e " 1    -  Run PimpMyKali"
    echo -e " 2    -  Install Visual Studio Code"
    echo -e " 3    -  Install xct/kali-clean"
    echo -e " 4    -  Orange-Cyberdefense/arsenal"
    echo ""
    echo -e "${BLUE} 0    -  Back to Main Menu"${NC}
    echo ""
    echo -n "Choose an option: "
    read option

    case $option in
        0) main_menu;;
        1) run_pimpmykali; miscellaneous_menu;;
        2) install_vscode; miscellaneous_menu;;
        3) install_kali_clean; miscellaneous_menu;;
        4) install_arsenal; miscellaneous_menu;;
        *) echo "Invalid option"; miscellaneous_menu;;
    esac
}

main_menu
