FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y vsftpd && \
    apt-get clean

COPY vsftpd.conf /etc/vsftpd.conf
COPY /init.sh /init.sh

RUN chmod +x /init.sh
RUN mkdir -p /var/run/vsftpd/empty

ENTRYPOINT ["/init.sh"]