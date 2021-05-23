#!/bin/sh

set -e

ip route del default

ip route add default via "$NAT_ROUTER_LAN_ADDR"

exec "$@"
