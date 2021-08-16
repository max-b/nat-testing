#!/bin/sh

set -e

# TODO: refactor this from just nat-client-entrypoint.sh
ip route del default
ip route add default via "$NAT_ROUTER_LAN_ADDR"

# I want this to work
echo "
Bridge snowflake 192.0.2.3:1
UseBridges 1

ClientTransportPlugin snowflake exec /go/bin/client \
-ice stun:$COTURN_WAN_ADDR1:3478 \
-url http://$BROKER_WAN_ADDR:$BROKER_PORT/ \
-keep-local-addresses \
-unsafe-logging \
-log /tmp/snowflake-client.log
" > "$TORRC_PATH"

# An atttempt at using lots of extra stun servers:
# echo "
# Bridge snowflake 192.0.2.3:1
# UseBridges 1

# ClientTransportPlugin snowflake exec /go/bin/client \
# -ice stun:stun.voip.blackberry.com:3478,stun:stun.altar.com.pl:3478,stun:stun.antisip.com:3478,stun:stun.bluesip.net:3478,stun:stun.dus.net:3478,stun:stun.epygi.com:3478,stun:stun.sonetel.com:3478,stun:stun.sonetel.net:3478,stun:stun.stunprotocol.org:3478,stun:stun.uls.co.za:3478,stun:stun.voipgate.com:3478,stun:stun.voys.nl:3478 \
# -url http://$BROKER_WAN_ADDR:$BROKER_PORT/ \
# -keep-local-addresses \
# -unsafe-logging \
# -log /tmp/snowflake-client.log
# " > "$TORRC_PATH"

exec "$@"
