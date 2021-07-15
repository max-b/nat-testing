#!/bin/sh

set -e

LAN_INTERFACE=$(ip addr | grep "$LAN_ADDR" | awk '{ print $NF }')
WAN_INTERFACE=$(ip addr | grep "$WAN_ADDR" | awk '{ print $NF }')

ip route del default
ip route add default via "$WAN_HOST_GATEWAY"

iptables -t nat -A POSTROUTING -o "$WAN_INTERFACE" -j MASQUERADE

# An attempt at different NAT type here:
# iptables -t nat -A POSTROUTING -s "$LAN_SUBNET/$LAN_SUFFIX" -j MASQUERADE --random

sleep infinity
