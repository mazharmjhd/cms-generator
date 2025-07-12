#!/bin/bash

read -p "Masukkan nama website yang ingin di-approve: " WEBNAME
SITE_DIR=/opt/docker/wordpress/$WEBNAME

if [ -d "$SITE_DIR" ]; then
  touch "$SITE_DIR/.approved"
  echo "[✓] Approved: $WEBNAME"
else
  echo "[!] Folder tidak ditemukan: $SITE_DIR"
fi

