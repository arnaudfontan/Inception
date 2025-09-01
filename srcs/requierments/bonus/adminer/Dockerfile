FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-mysql \
    curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -L https://www.adminer.org/latest.php -o /var/www/html/index.php \
    && rm -f /var/www/html/index.html

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]
