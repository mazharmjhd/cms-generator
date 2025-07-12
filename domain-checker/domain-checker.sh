#!/bin/bash

read -p "Name Domain (Example: example.com): " DOMAIN

if whois "$DOMAIN" | grep -iq "No match for\|NOT FOUND\|No Data Found\|Status: free"; then
    echo "[OK] Domain $DOMAIN Available."
else
    echo "[NO] Domain $DOMAIN Not Available."
fi

