FROM debian:latest as release

RUN apt-get update && apt-get full-upgrade -y && apt-get install ca-certificates curl wget jq iptables iproute2 iputils-ping dnsutils -y && update-ca-certificates

RUN mkdir -p /app

COPY docker-entrypoint.sh /app

WORKDIR /app

RUN chmod +x docker-entrypoint.sh

RUN touch init.sh

ENTRYPOINT ["./docker-entrypoint.sh"]
