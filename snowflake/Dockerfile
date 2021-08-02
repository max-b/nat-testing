FROM golang:1.13

RUN apt-get update && apt-get install -y git libx11-dev tor net-tools less apt-transport-https netcat tcpdump nmap

ENV GO111MODULE=on

WORKDIR /go/src/
RUN go install git.torproject.org/pluggable-transports/snowflake.git/client
RUN go install git.torproject.org/pluggable-transports/snowflake.git/proxy
RUN go install git.torproject.org/pluggable-transports/snowflake.git/broker

RUN go install github.com/pion/stun/cmd/stun-nat-behaviour
