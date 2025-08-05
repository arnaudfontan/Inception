FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y redis-server && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["redis-server", "--protected-mode", "no"]