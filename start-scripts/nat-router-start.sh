#!/bin/sh

# Identify which interfaces are "lan" vs "wan"
LAN_ADDR=$NAT_ROUTER_LAN_ADDR
WAN_ADDR=$NAT_ROUTER_WAN_ADDR

LAN_INTERFACE=$(ip addr | grep "$LAN_ADDR" | awk '{ print $NF }')
WAN_INTERFACE=$(ip addr | grep "$WAN_ADDR" | awk '{ print $NF }')

ip route del default
ip route add default via $WAN_HOST_GATEWAY

iptables -t nat -A POSTROUTING -o "$WAN_INTERFACE" -j MASQUERADE

sleep infinity
