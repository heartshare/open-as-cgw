#!/bin/bash

# Default Variables
modprobe ip_tables			# core iptables
modprobe ip_conntrack			# connectrion tracking
modprobe ip_conntrack_ftp		# ip conntrack
modprobe ipt_iprange			# ip range

# flush everything on startup
iptables -F
iptables -t nat -F
iptables -t mangle -F
iptables -X
iptables -t nat -X
iptables -t mangle -X

# set default policies
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# MY_REJECT-Chain
iptables -N MY_REJECT
iptables -A MY_REJECT -p tcp -j REJECT --reject-with tcp-reset
iptables -A MY_REJECT -p udp -j REJECT --reject-with icmp-port-unreachable
iptables -A MY_REJECT -j REJECT --reject-with icmp-proto-unreachable

# USER chain
iptables -N USER
iptables -A USER -i eth0 -p tcp --dport 22 -j ACCEPT # ssh
iptables -A USER -i eth0 -p tcp --dport 443 -j ACCEPT # https
iptables -A USER -i eth0 -j DROP

# MY_DROP-Chain
iptables -N MY_DROP
iptables -A MY_DROP -j DROP

# log all blocked packages
#iptables -A INPUT -m state --state INVALID -m limit --limit 7200/h -j LOG --log-prefix "INPUT INVALID "
#iptables -A OUTPUT -m state --state INVALID -m limit --limit 7200/h -j LOG --log-prefix "OUTPUT INVALID "

# block corrupt packages
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A OUTPUT -m state --state INVALID -j DROP

# SNMP
# must be explicitly enabled within the GUI [ds,14/08/16]
#iptables -A INPUT -i eth0 -p udp --dport 161 -j ACCEPT # snmp

# drop stealth scans etc.
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j MY_DROP
iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j MY_DROP # SYN FIN
iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j MY_DROP # SYN RST
iptables -A INPUT -p tcp --tcp-flags FIN,RST FIN,RST -j MY_DROP # FIN RST
iptables -A INPUT -p tcp --tcp-flags ACK,FIN FIN -j MY_DROP # FIN ACK
iptables -A INPUT -p tcp --tcp-flags ACK,PSH PSH -j MY_DROP # PSH ACK
iptables -A INPUT -p tcp --tcp-flags ACK,URG URG -j MY_DROP #URG without ACK

# allow loopback-communication
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# activate connection-tracking
iptables -A OUTPUT -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# ICMP
iptables -A INPUT -p icmp -j ACCEPT

# SMTP ports
iptables -A INPUT -i eth0 -m state --state NEW -p tcp --dport 25 -j ACCEPT # SMTP 
iptables -A INPUT -i eth0 -m state --state NEW -p tcp --dport 587 -j ACCEPT # SMTPS 

# previously defined USER table which contains ssh and adminrange
iptables -A INPUT -i eth0 -p tcp -j USER

# Default-Policies
iptables -A INPUT -j MY_REJECT
iptables -A OUTPUT -j MY_REJECT

exit 0
