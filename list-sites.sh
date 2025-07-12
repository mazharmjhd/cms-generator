#!/bin/bash

BASE_DIR="/opt/docker/wordpress"

echo "Daftar WordPress Sites:"
echo "-----------------------"

for site in "$BASE_DIR"/*; do
  if [ -d "$site" ]; then
    webname=$(basename "$site")
    if [ -f "$site/.approved" ]; then
      status="Approved"
    else
      status="Pending Approval"
    fi
    echo "- $webname : $status"
  fi
done

