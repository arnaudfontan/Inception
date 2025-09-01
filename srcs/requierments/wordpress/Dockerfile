FROM    debian:bookworm-slim

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y \
        wget \
        curl \
        php \
        php-fpm \
        php-mysql \
        mariadb-client \
        unzip \
        less \
        php-redis \
        netcat-openbsd && \
    rm -rf /var/lib/apt/lists/*
        
RUN     mkdir -p /run/php

COPY    www.conf /etc/php/8.2/fpm/pool.d/www.conf

RUN     wget https://fr.wordpress.org/wordpress-6.8.2-fr_FR.tar.gz -P /var/www && \
        tar -xzf /var/www/wordpress-6.8.2-fr_FR.tar.gz -C /var/www && \
        rm /var/www/wordpress-6.8.2-fr_FR.tar.gz && \
        chown -R www-data:www-data /var/www/wordpress


RUN     curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
        chmod +x wp-cli.phar && \
        mv wp-cli.phar /usr/local/bin/wp

COPY setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

WORKDIR /var/www/wordpress

EXPOSE 9000

CMD ["/bin/bash", "-c", "/usr/local/bin/setup.sh && exec php-fpm8.2 -F"]

