# nat-testing

This is just a proof of concept demonstrating how one could use docker/docker-compose networking to create a testbed for evaluating NAT traversal for the snowflake protocol.

## Concepts
This creates 2 hosts, one running a [snowbox](https://github.com/cohosh/snowbox) container and one running some very simple iptables and routing rules which make it into a NAT router:

![nat-testing basic topology](./nat-testing-1.png)


I'm not actually super familiar with various NAT implementations, but I _believe_ that they could be implemented with iptables. 

[This answer](https://stackoverflow.com/a/28525022/1787596) seems to outline the iptables rules that would implement various NAT strategies, but I haven't thoroughly evaluated it and would need to do more research. 

If it's not possible to implement the full variety of NAT strategies with iptables this is an extremely flawed approach 🙃.


Ultimately, I think it would be more straightforward to actually have each component of the snowflake topology running in its own container:
![nat-testing advanced topology](./nat-testing-2.png)


## Setup
The [.env](./.env) file currently holds all of the configurable values. 

At the moment, before running, you'll need to fill out the paths to your [snowflake-webext](https://gitweb.torproject.org/pluggable-transports/snowflake-webext.git) and [snowflake](https://gitweb.torproject.org/pluggable-transports/snowflake.git) local repositories.

You'll also have to specify your own user id and group id.

[snowbox](https://github.com/cohosh/snowbox) is currently configured as a git submodule, so after cloning this repo, update submodules:
```
$ git submodule update --init
```

## Running
First start the nat-router:
```
$ docker-compose up -d nat-router
```

Then start the snowbox container:
```
$ docker-compose up -d snowbox
```

Each of these containers have start scripts specified in their docker-compose definitions which setup networking and then simply `sleep infinity`. 

This is a just a hacky and temporary way to allow for manual exploration on the `snowbox` container:
```
$ docker-compose exec snowbox /bin/bash
$ su snowflake
$ script.sh -b
$ script.sh -c
```

I wasn't super familiar with the build scripts, so I attempted to leave them as is, especially since this is more of a sandbox POC.

I'm not 100% sure they work correctly at the moment, but I wanted to just demonstrate the idea of the network testbed.
