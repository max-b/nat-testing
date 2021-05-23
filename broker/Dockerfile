FROM golang:1.13

# TODO: do we need all of these?
RUN apt-get update && apt-get install -y git libx11-dev tor net-tools less apt-transport-https

WORKDIR /go/src/
RUN export GO111MODULE=on && go install git.torproject.org/pluggable-transports/snowflake.git/broker
