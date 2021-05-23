FROM golang:1.13

# TODO: do we need these?
RUN apt-get update && apt-get install -y git libx11-dev tor net-tools less apt-transport-https

WORKDIR /go/src/
RUN export GO111MODULE=on && go install git.torproject.org/pluggable-transports/snowflake.git/client

RUN export GO111MODULE=on && go install github.com/pion/stun/cmd/stun-nat-behaviour
