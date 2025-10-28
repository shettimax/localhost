#!/bin/bash
# Author: Shettimax
# Description: Interactive script to assign custom local domains to Apache virtual hosts on Ubuntu

# === Color codes ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# === Check if Apache is installed ===
if ! command -v apache2 >/dev/null 2>&1; then
  echo -e "${RED}Apache is not installed. Please install it with: sudo apt install apache2${NC}"
  exit 1
fi

# === Show Apache version ===
echo -e "${CYAN}Apache version:${NC}"
apache2 -v | grep "Server version"

# === Setup paths ===
WWWROOT="/var/www"
SITES_AVAILABLE="/etc/apache2/sites-available"

# === List folders in /var/www ===
echo -e "\n${CYAN}Available project folders in $WWWROOT:${NC}"
mapfile -t FOLDERS < <(find "$WWWROOT" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)

while true; do
  select FOLDER in "${FOLDERS[@]}"; do
    if [ -n "$FOLDER" ]; then
      DOCROOT="$WWWROOT/$FOLDER"
      echo -e "${YELLOW}You selected: $FOLDER (${DOCROOT})${NC}"
      read -p "Confirm selection? (y/n): " CONFIRM
      if [[ "$CONFIRM" == "y" ]]; then
        break 2
      else
        echo -e "${CYAN}Let's try again...${NC}"
        break
      fi
    else
      echo -e "${RED}Invalid selection. Try again.${NC}"
    fi
  done
done

# === Check if folder already has a domain ===
EXISTING_DOMAIN=$(grep -rl "$DOCROOT" "$SITES_AVAILABLE" 2>/dev/null | xargs -n1 basename 2>/dev/null | sed 's/\.conf$//')

if [ -n "$EXISTING_DOMAIN" ]; then
  echo -e "${YELLOW}This folder is already assigned to domain: $EXISTING_DOMAIN${NC}"
  read -p "Do you want to assign a new domain anyway? (y/n): " CONFIRM
  if [ "$CONFIRM" != "y" ]; then
    echo -e "${RED}Aborting setup.${NC}"
    exit 0
  fi
fi

# === Ask for new domain name ===
read -p "Enter your custom local domain (e.g. mysite.local): " DOMAIN
VHOST_FILE="$SITES_AVAILABLE/$DOMAIN.conf"

# === Add to /etc/hosts ===
if grep -q "$DOMAIN" /etc/hosts; then
  echo -e "${GREEN}$DOMAIN already exists in /etc/hosts${NC}"
else
  echo "127.0.0.1 $DOMAIN" | sudo tee -a /etc/hosts > /dev/null
  echo -e "${GREEN}Added $DOMAIN to /etc/hosts${NC}"
fi

# === Optional: Create index.html (commented out) ===
# if [ ! -f "$DOCROOT/index.html" ]; then
#   echo "<h1>$DOMAIN is live!</h1>" | sudo tee "$DOCROOT/index.html"
# fi

# === Create Virtual Host ===
sudo tee "$VHOST_FILE" > /dev/null <<EOF
<VirtualHost *:80>
    ServerName $DOMAIN
    DocumentRoot $DOCROOT

    <Directory $DOCROOT>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/$DOMAIN-error.log
    CustomLog \${APACHE_LOG_DIR}/$DOMAIN-access.log combined
</VirtualHost>
EOF

# === Enable Site and Restart Apache ===
sudo a2ensite "$DOMAIN.conf" > /dev/null
sudo systemctl reload apache2

echo -e "${GREEN}Setup complete. $DOMAIN is now active at http://$DOMAIN${NC}"
