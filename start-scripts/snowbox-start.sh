#!/bin/sh

set -x

apt-get install iproute2

ip route del default

ip route add default via "$NAT_ROUTER_LAN_ADDR"


sleep infinity

# Currently ignoring these commands and running them manually

su snowflake
script.sh -b
script.sh -c
