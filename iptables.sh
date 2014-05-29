#!/bin/bash

setup_iptables() {
	echo "Start setup IP tables"
	
	iptables -P INPUT ACCEPT

	#echo "Clean all rules"
	iptables -F

	#echo "Accept all loop (lo) interface"
	iptables -A INPUT -i lo -j ACCEPT

	# Accept all ESTABLISHED and related connection
	iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

	# Acept all icmp
	iptables -A INPUT -p icmp -j ACCEPT

	# Enable ssh
	iptables -A INPUT -p tcp --dport 22 -j ACCEPT

	# Accept all HTTP
	iptables -A INPUT -p tcp --dport 80 -j ACCEPT

	# Default rules
	# DROP all input, forward and accept all output
	iptables -P INPUT DROP
	iptables -P FORWARD DROP
	iptables -P OUTPUT ACCEPT

	iptables-save > /etc/iptables/rules.v4

	echo "Start setup IP table successfully"
	echo "iptables -L -v is:"
	iptables -L -v
}

usage() {
	echo "use command: sudo iptables [setup|list]"
}

check_permission_then_execute() {
	# Check root permission
	FILE="/tmp/out.$$"
	GREP="/bin/grep"
	if [ "$(id -u)" != "0" ]; then
   	echo "This script must be run as root" 1>&2
   	exit 1
	fi

	case $1 in
		setup)
			setup_iptables
			;;
		*)
			usage
			;;
	esac
}

check_permission_then_execute $@

