#!/bin/bash

if [ $# -lt 1 ]
then
    echo "$0 <domain>"
    exit 1
fi

dnssec-keygen -a RSASHA256 -f KSK -K . -b 2048 -n ZONE $1 > kskname
dnssec-keygen -a RSASHA256 -K . -b 2048 $1
dnssec-dsfromkey $(cat kskname).key > ds
