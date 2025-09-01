FROM debian:bookworm-slim

RUN		apt update -y && \
		apt install -y nginx openssl curl gettext-base && \
		apt clean && \
		rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

ENV SSL_CERT=/etc/nginx/ssl/inception.crt
ENV SSL_KEY=/etc/nginx/ssl/inception.key
 
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out ${SSL_CERT} \
    -keyout ${SSL_KEY} \
    -subj "/C=FR/ST=Paris/L=Paris/O=42/CN=afontan.42.fr"

COPY nginx.conf /etc/nginx/nginx.conf

RUN envsubst '${SSL_CERT} ${SSL_KEY} ${DOMAIN_NAME}' < /etc/nginx/nginx.conf > /etc/nginx/nginx.conf.tmp && \
    mv /etc/nginx/nginx.conf.tmp /etc/nginx/nginx.conf

RUN chmod 755 /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
