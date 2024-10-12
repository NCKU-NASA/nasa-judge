#!/bin/bash

iptables -t mangle -A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

ip route add 10.210.128.0/24 via 10.210.0.3 dev eth1
ip route add 10.210.129.0/24 via 10.210.0.3 dev eth1
ip route add 10.210.255.0/24 via 10.210.0.2 dev eth1
ip route add 10.210.254.0/24 via 10.210.0.2 dev eth1

sleep infinity
