#!/bin/bash

read -p "Subdomain Name (Example: sub.example.com): " SUBDOMAIN

if host "$SUBDOMAIN" > /dev/null 2>&1; then
    echo "[NO] Subdomain $SUBDOMAIN Already Used (DNS Found)."
else
    echo "[OK] Subdomain $SUBDOMAIN Available (DNS Not Found)."
fi

