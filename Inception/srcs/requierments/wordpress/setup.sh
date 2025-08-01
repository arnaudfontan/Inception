#!/bin/bash

set -e  # Arrêt en cas d'erreur

echo "⌛ En attente que MariaDB soit prête..."
until mysqladmin ping -h"$SQL_HOST" -u"$SQL_USER" -p"$SQL_PASSWORD" --silent; do
  sleep 1
done
echo "✅ MariaDB est prête."

cd /var/www/wordpress

if [ ! -f wp-config.php ]; then
  echo "🛠 Création de wp-config.php..."
  wp config create \
    --dbname="$SQL_DATABASE" \
    --dbuser="$SQL_USER" \
    --dbpass="$SQL_PASSWORD" \
    --dbhost="$SQL_HOST" \
    --path=/var/www/wordpress --allow-root

  echo "🛠 Installation de WordPress..."
  wp core install \
    --url="$DOMAIN_NAME" \
    --title="$WEBSITE_TITLE" \
    --admin_user="$WP_ADMIN_LOGIN" \
    --admin_password="$WP_ADMIN_PASSWORD" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --skip-email \
    --path=/var/www/wordpress --allow-root

  echo "👤 Création de l'utilisateur auteur..."
  wp user create "$WP_USER_LOGIN" "$WP_USER_EMAIL" \
    --role=author \
    --user_pass="$WP_USER_PASSWORD" \
    --path=/var/www/wordpress --allow-root
else
  echo "✅ WordPress déjà configuré."
fi

echo "🚀 Lancement de PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F
