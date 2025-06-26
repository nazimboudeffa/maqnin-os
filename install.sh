#!/bin/bash

# Couleurs
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# URL GitHub API pour obtenir la dernière version
GITHUB_API_URL="https://api.github.com/repos/projectdiscovery/subfinder/releases/latest"

echo -e "${GREEN}[+] Téléchargement des informations de la dernière version de Subfinder...${RESET}"

# Obtenir la dernière version
LATEST_URL=$(curl -s "$GITHUB_API_URL" | grep browser_download_url | grep linux_amd64 | cut -d '"' -f 4)

if [[ -z "$LATEST_URL" ]]; then
    echo -e "${RED}[-] Impossible de récupérer l'URL de téléchargement.${RESET}"
    exit 1
fi

echo -e "${GREEN}[+] URL trouvée : $LATEST_URL${RESET}"
echo -e "${GREEN}[+] Téléchargement de l'archive...${RESET}"

# Téléchargement
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR" || exit 1
curl -LO "$LATEST_URL"

ARCHIVE_NAME=$(basename "$LATEST_URL")
tar -xzf "$ARCHIVE_NAME"

if [[ ! -f subfinder ]]; then
    echo -e "${RED}[-] Le binaire subfinder n'a pas été trouvé après extraction.${RESET}"
    exit 1
fi

echo -e "${GREEN}[+] Binaire extrait avec succès.${RESET}"

# Déplacement dans /usr/bin
echo -e "${GREEN}[+] Déplacement de subfinder vers /usr/bin/subfinder...${RESET}"
sudo mv subfinder /usr/bin/subfinder
sudo chmod +x /usr/bin/subfinder

echo -e "${GREEN}[✓] Subfinder installé avec succès dans /usr/bin/subfinder${RESET}"

# Nettoyage
cd ~
rm -rf "$TMP_DIR"
