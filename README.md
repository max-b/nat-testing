# nat-testing

This is a docker based testbed for evaluating [snowflake](https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake) NAT traversal.

## Concepts
This currently creates 8 services:
- A [snowflake-proxy](https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/tree/main/proxy) behind a nat router
- A [snowflake-proxy](https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/tree/main/proxy) that's not behind a nat router
- A nat router connecting the snowflake-proxy to the WAN network
- A [snowflake-client](https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/tree/main/client) behind a nat router
- A [snowflake-client](https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/tree/main/client) that's not behind a nat router
- A nat router connecting the snowflake-client to the WAN network
- [snowflake-broker](https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake/-/tree/main/broker)
- A [TURN/STUN](https://hub.docker.com/r/coturn/coturn) server

## Topology
![nat-testing topology](./nat-testing.png) 

## Setup
The [.env](./.env) file currently holds all of the configurable values. You _shouldn't_ need to change anything.

## Running
Running all services _should_ (🤞) be as simple as:
```
$ docker-compose up -d
```

To see logs:
```
$ docker-compose logs -f
```

Make a curl command on the client through tor to check connectivity:
```
$ docker-compose exec snowflake-client curl -x socks5h://localhost:9050 https://startpage.com
```

Test nat type:

where 172.21.0.20 is the $COTURN_WAN_ADDR1 as described in the [.env](./.env) file (a future improvement is to figure out how to just use that variable here)
```
$ docker-compose exec snowflake-proxy stun-nat-behaviour -server 172.21.0.20:3478
$ docker-compose exec snowflake-client stun-nat-behaviour -server 172.21.0.20:3478
```


Run arbitrary commands on any service you'd like eg:
```
$ docker-compose exec snowflake-client ping 8.8.8.8
$ docker-compose exec snowflake-broker ps aux
$ docker-compose exec proxy-nat-router /bin/sh
```

Test if a client is successfully able to make a tor-proxied request:
```
$ docker-compose exec snowflake-client curl -x socks5h://localhost:9050 https://startpage.com
$ docker-compose exec snowflake-client-no-nat curl -x socks5h://localhost:9050 https://startpage.com
```
(`snowflake-client-no-nat` is a snowflake-client that is not behind a NAT)

Get logs from a service:
```
$ docker-compose logs -f snowflake-proxy
$ docker-compose logs -f snowflake-proxy-no-nat
$ docker-compose logs -f snowflake-client
$ docker-compose logs -f snowflake-client-no-nat
```

Some logs are written to file instead of stdout, so you may need to tail them:
```
$ docker-compose exec snowflake-client-no-nat /usr/bin/tail -f /tmp/snowflake-client.log
```


## Rebuilding
The initial `docker-compose up` will build the relevant images, but subsequent executions will not. If you want to rebuild the container:
```
$ docker-compose up --build -d
```

## Stopping
To stop everything and clear volumes (can be helpful for cleanup):
```
$ docker-compose down --volumes
```

This won't remove networks, so if you'd like to clean them up, you _should_ be able to:
```
$ docker network prune
```

## NOTES:
- No snowflake-server/tor relay is included. We're currently depending on the external wss://snowflake.torproject.net/ websocket relay that the snowflake-proxy will connect to.

- The broker is not behind a NAT. I think that's the expected deployment strategy. No fronting is occuring between the proxy/client and the broker.

- I was occasionally getting "address is already taken" errors when trying to bring up certain containers. I'm not 100% sure if that was due to a slightly dirty working state, but the way I was reliably able to fix that was by changing the address for that container's "wan" interface.
