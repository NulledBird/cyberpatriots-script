clear

echo -e "\033[1mCYBERPATRIOTS SCRIPT"
printf '%.s─' $(seq 1 $(tput cols))
echo -e "\033[0m\n"

echo -ne "\e[4m" && printf "%-$(tput cols)b" "BASIC SECURITY" && echo -e "\e[0m\n"

sudo ufw enable > /dev/null && echo "Firewall enabled!"
sed -i 's/^.*PermitRootLogin.*$/PermitRootLogin no/' /etc/ssh/sshd_config && echo "Disabled root login!"
sed -i 's/PASS_MAX_DAYS.*$/PASS_MAX_DAYS 90/' /etc/login.defs
sed -i 's/PASS_MIN_DAYS.*$/PASS_MIN_DAYS 10/' /etc/login.defs && echo "Password Age Set!"
echo "!!! DISABLE GUEST IF YOU CAN, MY TEST OS NO LIKE LIGHTDM IDK !!!"

chmod 440 /etc/sudoers && chmod 440 /etc/sudoers.d/ && echo "Set /etc/sudoers permissions"
chmod 644 /etc/group && echo "Set /etc/group permissions"
chmod 644 /etc/passwd && echo "Set /etc/passwd permissions"
chmod 640 /etc/shadow && echo "Set /etc/shadow permissions"
passwd -l root > /dev/null && echo "Locked root user"

echo -ne "\n\e[4m" && printf "%-$(tput cols)b" "KERNEL HARDENING" && echo -e "\e[0m\n"

sysctl -q -w -n net.ipv4.tcp_syncookies=1 && echo "IPv4 TCP SYN cookies enabled"
sysctl -q -w -n net.ipv4.tcp_rfc1337=0 && echo "IPv4 TIME-WAIT ASSASINATION protection enabled"
sysctl -q -w -n net.ipv4.ip_forward=0 && echo "IPv4 forwarding disabled"
sysctl -q -w -n net.ipv4.conf.all.accept_source_route=0 && echo "Source Routing disabled"
sysctl -q -w -n net.ipv4.icmp_echo_ignore_broadcasts=1 && echo "Ignore ICMP Redirects"
sysctl -q -w -n net.ipv4.conf.all.log_martians=1 && echo "Log all Martian Packets"
sysctl -q -w -n net.ipv4.conf.all.rp_filter=1 && echo "Source Address Verfication Enabled"
sysctl -q -w -n kernel.randomize_va_space=2 && echo "Kernel ASLR Enabled"
sysctl -q -w -n kernel.pid_max=5000 && echo "Kernel Process Limit Set"
sysctl -q -w -n net.ipv6.conf.all.disable_ipv6=1 && sysctl -q -w -n net.ipv6.conf.default.disable_ipv6=1 && sysctl -q -w -n net.ipv6.conf.lo.disable_ipv6=1 && echo "Disabled IPv6"
sysctl -q -w -n kernel.exec-shield=1 && echo "Kernel ExecShield enabled"

grub_cmd=$(grep -e 'GRUB_CMDLINE_LINUX=' /etc/default/grub | rev | cut -c 2- | rev | sed "s/lockdown=confidentiality//g")
sed -i "s/$grub_cmd/$grub_cmd lockdown=confidentiality/" /etc/default/grub && sudo update-grub &> /dev/null && echo "Lockdowned boot"

echo -ne "\e[4m\n" && printf "%-$(tput cols)b" "PAM" && echo -e "\e[0m\n"

sudo gnome-terminal -- bash -c "sudo su -c \"echo -e 'Hey, if PAM bricks you will be fine since this is a root terminal. As said in the script a backup of the original pam files can be found at /etc/pam.d.backup/\n\n'\" root; exec bash" &
sudo cp -R /etc/pam.d/ /etc/pam.d.backup/ && echo "Backed up PAM to /etc/pam.d.backup/"

sed -i "s/minlen=12//" /etc/pam.d/common-password
sed -i "s/remember=5//" /etc/pam.d/common-password
sed -i "s/pam_unix.so/pam_unix.so minlen=12 remember=5/" /etc/pam.d/common-password && echo "Added minimum length for passwords in PAM"
echo "PAM remembers used passwords"

if grep -q "pam_faillock.so" "/etc/pam.d/common-auth"; then
	echo "Account lockout already implemented.."
else
	echo "auth	sufficient	pam_faillock.so authsucc" >> /etc/pam.d/common-auth && echo "Added account lockout policy in PAM"
fi

echo -ne "\e[4m\n" && printf "%-$(tput cols)b" "Complex Security" && echo -e "\e[0m\n"

echo "Checking for LD_PRELOAD..."
echo "\$LD_PRELOAD = $LD_PRELOAD"
if [ ! -f /etc/ld.so.preload ]; then
	echo "No ld.so.preload file..."
fi
echo -e "Contents of ld.so.conf:\n\n$(cat /etc/ld.so.conf)\n\n"
echo -e "ld.so.conf.d contains $(ls -CF /etc/ld.so.conf.d)"

echo -e "\nCheck if anything there is suspicious and move it away (or comment it out). \n!!! MAKE SURE ITS NOT A FORENSIC FIRST !!!"

echo -e "\n\nChecking for crontabs..."
echo -e "All users that have crontabs: $(ls -CF /var/spool/cron/crontabs)"
echo -e "Please check /etc/crontab on your own"
echo -e "Contents of /etc/cron.daily: $(ls -CF /etc/cron.daily)"
echo -e "Contents of /etc/cron.hourly: $(ls -CF /etc/cron.hourly)"
echo -e "Contents of /etc/cron.weekly: $(ls -CF /etc/cron.weekly)"
echo -e "Contents of /etc/cron.monthly: $(ls -CF /etc/cron.monthly)"
echo -e "Contents of /etc/cron.yearly: $(ls -CF /etc/cron.yearly)"

echo -e "\n\nChecking for suspicious files..."

find /home/ -mindepth 1 -maxdepth 1 -type d \( ! -name . \) -exec bash -c "cd '{}' && pwd && echo -e '	/Videos/: $(ls -CF ./Videos/)\n	/Music/: $(ls -CF ./Music/)\n	/Pictures/: $(ls -CF ./Pictures/)\n	/.bash_alias: $(cat ./.bash_alias 2>/dev/null)'" \;


echo -e "\n\n\n\n"

