#!/bin/bash

ip route del default
ip route add default via 10.210.0.254 dev eth1

nohup bash flush.sh &
