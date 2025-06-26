#!/bin/bash

# Couleurs
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

#SUBFINDER

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

#HTTPX

# API GitHub pour la dernière version
GITHUB_API_URL="https://api.github.com/repos/projectdiscovery/httpx/releases/latest"

echo -e "${GREEN}[+] Téléchargement des informations de la dernière version de HTTPX...${RESET}"

# Récupérer l’URL de téléchargement du binaire linux_amd64
LATEST_URL=$(curl -s "$GITHUB_API_URL" | grep browser_download_url | grep linux_amd64 | cut -d '"' -f 4)

if [[ -z "$LATEST_URL" ]]; then
    echo -e "${RED}[-] Impossible de récupérer l'URL de téléchargement de HTTPX.${RESET}"
    exit 1
fi

echo -e "${GREEN}[+] URL trouvée : $LATEST_URL${RESET}"
echo -e "${GREEN}[+] Téléchargement de l'archive...${RESET}"

# Créer un répertoire temporaire
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR" || exit 1
curl -LO "$LATEST_URL"

ARCHIVE_NAME=$(basename "$LATEST_URL")
tar -xzf "$ARCHIVE_NAME"

if [[ ! -f httpx ]]; then
    echo -e "${RED}[-] Le binaire httpx n'a pas été trouvé après extraction.${RESET}"
    exit 1
fi

echo -e "${GREEN}[+] Binaire extrait avec succès.${RESET}"

# Déplacement dans /usr/bin
echo -e "${GREEN}[+] Installation de httpx dans /usr/bin...${RESET}"
sudo mv httpx /usr/bin/httpx
sudo chmod +x /usr/bin/httpx

echo -e "${GREEN}[✓] HTTPX installé avec succès dans /usr/bin/httpx${RESET}"

# Nettoyage
cd ~
rm -rf "$TMP_DIR"

#XSSSTRIKE

INSTALL_DIR="/opt/xssstrike"
BIN_PATH="/usr/bin/xssstrike"

echo -e "${GREEN}[+] Installation de XSSStrike...${RESET}"

# Vérification de Python 3
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}[-] Python3 n'est pas installé.${RESET}"
    exit 1
fi

# Clonage du dépôt
echo -e "${GREEN}[+] Clonage du dépôt GitHub...${RESET}"
sudo git clone https://github.com/s0md3v/xssstrike "$INSTALL_DIR" || {
    echo -e "${RED}[-] Échec du clonage du dépôt.${RESET}"
    exit 1
}

cd "$INSTALL_DIR" || exit 1

# Installation des dépendances
echo -e "${GREEN}[+] Installation des dépendances Python...${RESET}"
sudo pip3 install -r requirements.txt || {
    echo -e "${RED}[-] Échec de l'installation des dépendances.${RESET}"
    exit 1
}

# Ajout d'un lien symbolique
echo -e "${GREEN}[+] Création du lien symbolique dans /usr/bin...${RESET}"
sudo ln -sf "$INSTALL_DIR/xssstrike.py" "$BIN_PATH"
sudo chmod +x "$INSTALL_DIR/xssstrike.py"

echo -e "${GREEN}[✓] XSSStrike est installé. Utilisez la commande : xssstrike${RESET}"

#WAPITI3

#!/bin/bash

GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

INSTALL_DIR="/opt/wapiti"
BIN_PATH="/usr/bin/wapiti"

echo -e "${GREEN}[+] Installation de Wapiti 3...${RESET}"

sudo apt update
sudo apt install -y python3 python3-pip git

echo -e "${GREEN}[+] Clonage du dépôt GitHub...${RESET}"
sudo git clone https://github.com/wapiti-scanner/wapiti.git "$INSTALL_DIR"

cd "$INSTALL_DIR" || exit 1
sudo pip3 install -r requirements.txt

echo -e "${GREEN}[+] Création du lien dans /usr/bin...${RESET}"
sudo ln -sf "$INSTALL_DIR/wapiti.py" "$BIN_PATH"
sudo chmod +x "$INSTALL_DIR/wapiti.py"

echo -e "${GREEN}[✓] Wapiti est prêt. Utilise la commande : wapiti${RESET}"
