FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y nginx openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY html/ /var/www/html/
COPY default.conf /etc/nginx/sites-available/default

EXPOSE 81

CMD ["nginx", "-g", "daemon off;"]
