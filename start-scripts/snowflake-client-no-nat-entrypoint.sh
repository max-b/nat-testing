#!/bin/sh

set -e

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

exec "$@"
