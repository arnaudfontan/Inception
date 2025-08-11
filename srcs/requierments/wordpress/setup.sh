#!/bin/bash

set -e  # Arrêt en cas d'erreur

until mysqladmin ping -h"$SQL_HOST" -u"$SQL_USER" -p"$SQL_PASSWORD" --silent; do
  sleep 1
done

cd /var/www/wordpress

if [ ! -f /var/www/wordpress/wp-config.php ]; then
  wp config create \
    --dbname="$SQL_DATABASE" \
    --dbuser="$SQL_USER" \
    --dbpass="$SQL_PASSWORD" \
    --dbhost="$SQL_HOST" \
    --path=/var/www/wordpress --allow-root



  wp core install \
    --url="$DOMAIN_NAME" \
    --title="$WEBSITE_TITLE" \
    --admin_user="$WP_ADMIN_LOGIN" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --skip-email \
    --path=/var/www/wordpress --allow-root

  wp user create "$WP_USER_LOGIN" "$WP_USER_EMAIL" \
    --role=author \
    --user_pass="$WP_USER_PASSWORD" \
    --path=/var/www/wordpress --allow-root

fi

wp config set WP_REDIS_HOST redis --type=constant --allow-root
wp config set WP_REDIS_PORT 6379 --type=constant --allow-root
wp plugin install redis-cache --activate --allow-root
wp redis enable --allow-root

exec /usr/sbin/php-fpm7.4 -F
