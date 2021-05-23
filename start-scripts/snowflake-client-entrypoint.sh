#!/bin/sh

set -e

# TODO: refactor this from just nat-client-entrypoint.sh
ip route del default
ip route add default via "$NAT_ROUTER_LAN_ADDR"

# TODO: are these for specifying a local tor-server?
# Bridge snowflake 0.0.3.0:1
# UseBridges 1
# DataDirectory datadir

echo "
ClientTransportPlugin snowflake exec /go/bin/client \
-ice stun:stun.voip.blackberry.com:3478,stun:stun.altar.com.pl:3478,stun:stun.antisip.com:3478,stun:stun.bluesip.net:3478,stun:stun.dus.net:3478,stun:stun.epygi.com:3478,stun:stun.sonetel.com:3478,stun:stun.sonetel.net:3478,stun:stun.stunprotocol.org:3478,stun:stun.uls.co.za:3478,stun:stun.voipgate.com:3478,stun:stun.voys.nl:3478 \
-url http://$BROKER_WAN_ADDR:$BROKER_PORT/ -keep-local-addresses \
" > "$TORRC_PATH"


exec "$@"
