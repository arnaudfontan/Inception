FROM debian:bullseye-slim


RUN apt update -y && \
    apt upgrade -y && \
    apt install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql

COPY 50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init.sh /init.sh


HEALTHCHECK --interval=3s --timeout=3s --retries=3 \
CMD mysqladmin ping --silent || exit 1

RUN chmod +x /init.sh  

EXPOSE 3306

ENTRYPOINT ["bash", "/init.sh"]