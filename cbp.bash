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
echo -e "\n!!! Enable Kernel lockdown using this: https://www.davekb.com/browse_computer_tips:linux_enable_lockdown_mode:txt !!!"

echo -e "\n\n\n\n"
