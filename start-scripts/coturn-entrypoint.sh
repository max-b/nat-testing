#!/bin/bash

# Adapted from https://github.com/coturn/coturn/blob/60e7a199fe748cb7080594a458d22c2f7bb15a8c/docker/coturn/debian/rootfs/usr/local/bin/docker-entrypoint.sh

# First add a second ip addr on the WAN interface
WAN_INTERFACE=$(ip addr | grep "$WAN_ADDR1" | awk '{ print $NF }')
ip addr add "$WAN_ADDR2/$WAN_SUFFIX" dev "$WAN_INTERFACE"

# Then do as default coturn entrypoint:

# If command starts with an option, prepend it with a `turnserver` binary.
if [ "${1:0:1}" == '-' ]; then
  set -- turnserver "$@"
fi

exec $(eval "echo $@")
