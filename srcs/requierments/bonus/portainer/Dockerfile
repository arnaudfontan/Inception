FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /opt/portainer

RUN apt-get update && apt-get install -y \
    curl \
    && curl -L https://github.com/portainer/portainer/releases/download/2.11.1/portainer-2.11.1-linux-arm64.tar.gz -o portainer.tar.gz \
    && tar xzf portainer.tar.gz \
    && rm portainer.tar.gz

EXPOSE 9443 8000 9000

ENTRYPOINT ["./portainer/portainer"]