#!/bin/bash

read -p "Masukkan nama website yang ingin dihapus: " WEBNAME
SITE_DIR="/opt/docker/wordpress/$WEBNAME"
NGINX_CONF="/etc/nginx/sites-enabled/$WEBNAME.conf"
DOMAIN="$WEBNAME.daltek.id"

if [ ! -d "$SITE_DIR" ]; then
  echo "[!] Folder not found: $SITE_DIR"
  exit 1
fi

echo "[*] Delete site $WEBNAME..."

# Stop dan remove container
cd "$SITE_DIR"
docker compose down

# Hapus file konfigurasi nginx
if [ -f "$NGINX_CONF" ]; then
  rm -f "$NGINX_CONF"
  echo "[Done] Config NGINX delete"
fi

# ----> Hapus folder site
rm -rf "$SITE_DIR"
echo "[OK] Delete Folder Site: $SITE_DIR"

# ----> Hapus SSL cert (opsional)
read -p "Delete Cert SSL Let's Encrypt? (y/n): " HAPUS_SSL
if [[ "$HAPUS_SSL" == "y" ]]; then
  certbot delete --cert-name "$DOMAIN"
fi

# Reload nginx
nginx -t && systemctl reload nginx
echo "[OK] Cleanup Done."

