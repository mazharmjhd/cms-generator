#!/bin/bash

read -p "Input Name Website (webname): " WEBNAME
SITE_DIR=/opt/docker/wordpress/$WEBNAME
PORT_FILE="$SITE_DIR/.port"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -d "$SITE_DIR" ]; then
  echo "[*] Create folder & Config $WEBNAME"
  mkdir -p "$SITE_DIR/wp-data" "$SITE_DIR/db-data"

  PORT=$((RANDOM % 1000 + 8000))
  echo "$PORT" > "$PORT_FILE"

  cp "$SCRIPT_DIR/.env" "$SITE_DIR/.env"

  cp "$SCRIPT_DIR/templates/docker-compose.yml" "$SITE_DIR/docker-compose.yml"
  sed -i "s/{webname}/$WEBNAME/g; s/{port}/$PORT/g" "$SITE_DIR/docker-compose.yml"

  # Pastikan folder NGINX config ada
  mkdir -p /etc/nginx/sites-enabled

  # Generate config NGINX
  NGINX_SITE="/etc/nginx/sites-enabled/$WEBNAME.conf"
  cp "$SCRIPT_DIR/templates/nginx-site.conf" "$NGINX_SITE"
  sed -i "s/{webname}/$WEBNAME/g; s/{port}/$PORT/g" "$NGINX_SITE"

  echo "OK! Site $WEBNAME Ready"
  exit 0
fi

PORT=$(cat "$PORT_FILE")

if [ ! -f "$SITE_DIR/.approved" ]; then
  echo "[!] Site $WEBNAME need approve, please run approve.sh first"
  exit 1
fi

echo "[*] Deploying $WEBNAME port $PORT..."
cd "$SITE_DIR"
docker compose --env-file .env up -d

nginx -t && systemctl reload nginx

echo "OK! WordPress $WEBNAME Running di http://$WEBNAME.daltek.id"

