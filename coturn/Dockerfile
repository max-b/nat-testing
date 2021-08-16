FROM coturn/coturn:4-debian

# We need to be root to run our entrypoint which adds an additional ip address
USER root:root

# Add useful utils
RUN apt-get update && apt-get install -y git net-tools less netcat tcpdump nmap iproute2
