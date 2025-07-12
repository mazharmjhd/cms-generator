#!/bin/bash

read -p "Masukkan nama website (webname): " WEBNAME
DOMAIN="$WEBNAME.daltek.id"

echo "[*] Requesting SSL for $DOMAIN ..."

# Jalankan certbot untuk dapatkan sertifikat
certbot certonly --nginx -d "$DOMAIN" --non-interactive --agree-tos -m admin@$DOMAIN

if [ $? -ne 0 ]; then
  echo "[!] Failed request SSL for $DOMAIN"
  exit 1
fi

echo "[OK] Cert Already Generate $DOMAIN"

NGINX_CONF="/etc/nginx/sites-enabled/$WEBNAME.conf"
if [ -f "$NGINX_CONF" ]; then
  sed -i 's/listen 80;/listen 443 ssl;/' "$NGINX_CONF"
  sed -i "/server_name/a \\
  ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;\\
  ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;" "$NGINX_CONF"

  echo "[OK] NGINX New Config Update to HTTPS for $DOMAIN"
  nginx -t && systemctl reload nginx
else
  echo "[OK] File NGINX config not found : $NGINX_CONF"
fi

