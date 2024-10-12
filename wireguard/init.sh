#!/bin/bash

ip link add judgevrf type vrf table 100
ip link set dev judgevrf up
ip rule add oif judgevrf table 10
ip rule add iif judgevrf table 10
ip link set dev eth1 master judgevrf
for a in $(echo "$SERVER" | jq -r '. | join(" ")')
do
    ip link set dev $a master judgevrf
done
ip route add table 100 default via 10.210.0.254 dev eth1

iptables -t mangle -A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
