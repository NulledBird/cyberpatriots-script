R='\033[0m'
ITALIC='\033[3m'

RED='\033[00;91m'
GREEN='\033[00;92m'
YELLOW='\033[00;93m'
BLUE='\033[00;34m'
PURPLE='\033[00;35m'
CYAN='\033[00;96m'
LIGHTGRAY='\033[01;37m'

LRED='\033[01;31m'
LGREEN='\033[01;32m'
LYELLOW='\033[01;33m'
LBLUE='\033[01;34m'
LCYAN='\033[01;96m'
WHITE='\033[01;37m'

# LOGO
clear

nprint() {
  echo -e "$1"

  tput sc
  tput cup 0 0
  echo -e "${LCYAN}░█▀▀░█▀▄░█▀█░░░█░░░▀█▀░█▀█░█░█░█░█░░░█▀▀░█▀▀░█▀▄░▀█▀░█▀█░▀█▀${R}${LIGHTGRAY}   Made with\n${CYAN}░█░░░█▀▄░█▀▀░░░█░░░░█░░█░█░█░█░▄▀▄░░░▀▀█░█░░░█▀▄░░█░░█▀▀░░█░${R}${LIGHTGRAY}    ❤️  from\n${CYAN}░▀▀▀░▀▀░░▀░░░░░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░░░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░░░░▀░${R}${LIGHTGRAY}    Rishbob \n"
  tput rc
}


tput cup 6 0  

# NO ROOT?

if [ "$EUID" -ne 0 ]; then
  nprint "${LRED}${ITALIC}[!]${R}${RED} Please run as root"
  exit
fi

# UPDATE

nprint "${ITALIC}${LCYAN}[$]${R}${CYAN} Updating System..."
apt-get -y install &> /dev/null
nprint "   ${ITALIC}${LGREEN}[✓]${R}${GREEN} Updated package list!"
apt-get -y upgrade &> /dev/null
apt-get -y dist-upgrade &> /dev/null
nprint "   ${ITALIC}${LGREEN}[✓]${R}${GREEN} Updated packages!\n"

# UFW

nprint "${ITALIC}${LCYAN}[$]${R}${CYAN} Checking if UFW is installed..."
UFW_OK=$(dpkg-query -W --showformat='${Status}\n' ufw|grep "install ok installed")

if [ "" = "$UFW_OK" ]; then
  nprint "	${LRED}${ITALIC}[!]${R}${RED} UFW is not installed, will install it now..."
  apt-get -y install ufw &> /dev/null
  nprint"	${LGREEN}${ITALIC}[✓]${R}${GREEN} Installed UFW!"
else
  nprint "	${LGREEN}${ITALIC}[✓]${R}${GREEN} UFW is already installed!"
fi

ufw enable &> /dev/null

nprint "	${LGREEN}${ITALIC}[✓]${R}${GREEN} Enabled firewall!"

sudo ufw allow from 192.168.2.0/24 to any port 22 &> /dev/null

nprint "	${LGREEN}${ITALIC}[✓]${R}${GREEN} Made firewall more secure!\n"

# Lock Root User

nprint "${ITALIC}${LCYAN}[$]${R}${CYAN} Locking root user..."
passwd -l root &> /dev/null
nprint "	${LGREEN}${ITALIC}[✓]${R}${GREEN} Finished!"

# Finish!

nprint "\n\n${LGREEN}${ITALIC}[✓]${R}${GREEN} Script over!"

tput cup $(tput lines) 0

