#!/bin/sh

set -e

LAN_INTERFACE=$(ip addr | grep "$LAN_ADDR" | awk '{ print $NF }')
WAN_INTERFACE=$(ip addr | grep "$WAN_ADDR" | awk '{ print $NF }')

ip route del default
ip route add default via "$WAN_HOST_GATEWAY"


if [ "$RANDOMIZE_NAT" = "false" ]; then
  # Port Restricted Cone NAT;
  # NAT mapping behavior: endpoint-independent
  # NAT filtering behavior: address and port-dependent
  # (AI, AP)
  iptables -t nat -A POSTROUTING -o "$WAN_INTERFACE" -j SNAT --to-source "$WAN_ADDR"
else
# Symmetric NAT;
# NAT mapping behavior: address-dependent
# NAT filtering behavior: address and port-dependent
# (AO, AP)
  iptables -t nat -A POSTROUTING -o "$WAN_INTERFACE" -j MASQUERADE --random
  iptables -P FORWARD DROP
  iptables -A FORWARD -i "$WAN_INTERFACE" -o "$LAN_INTERFACE" -m state --state RELATED,ESTABLISHED -j ACCEPT
  iptables -A FORWARD -o "$WAN_INTERFACE" -i "$LAN_INTERFACE" -j ACCEPT
fi

sleep infinity
