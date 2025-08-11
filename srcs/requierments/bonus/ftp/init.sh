#!/bin/bash

set -e

# Crée un utilisateur FTP avec accès à /var/www/wordpress
FTP_USER="ftpuser"
FTP_PASS="ftppassword"
FTP_HOME="/var/www/wordpress"

# Créer l'utilisateur s'il n'existe pas
if ! id "$FTP_USER" &>/dev/null; then
  useradd -m "$FTP_USER"
  echo "$FTP_USER:$FTP_PASS" | chpasswd
  usermod -d "$FTP_HOME" "$FTP_USER"
fi

# S'assurer que l'utilisateur peut accéder au dossier
chown -R "$FTP_USER":"$FTP_USER" "$FTP_HOME"

# Lancer vsftpd
exec /usr/sbin/vsftpd /etc/vsftpd.conf
