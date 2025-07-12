#!/bin/bash

BACKUP_DIR=/opt/docker/backups/$(date +%F)
mkdir -p "$BACKUP_DIR"

for SITE in /opt/docker/wordpress/*; do
  WEBNAME=$(basename "$SITE")
  echo "[*] Membackup $WEBNAME..."

  tar -czf "$BACKUP_DIR/${WEBNAME}_files.tar.gz" -C "$SITE/wp-data" .
  docker exec db_$WEBNAME /usr/bin/mysqldump -u root --password=rootpass wordpress > "$BACKUP_DIR/${WEBNAME}_db.sql"
done

echo "[✓] Backup selesai di $BACKUP_DIR"

