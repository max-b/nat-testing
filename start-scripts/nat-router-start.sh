#!/bin/sh

LAN_INTERFACE=$(ip addr | grep "$LAN_ADDR" | awk '{ print $NF }')
WAN_INTERFACE=$(ip addr | grep "$WAN_ADDR" | awk '{ print $NF }')

ip route del default
ip route add default via $WAN_HOST_GATEWAY

iptables -t nat -A POSTROUTING -o "$WAN_INTERFACE" -j MASQUERADE

sleep infinity
