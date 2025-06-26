#!/bin/bash

# Couleurs
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

set -e

### --- Fonctions --- ###

install_subfinder() {
    echo -e "${GREEN}[+] Installation de Subfinder...${RESET}"
    local url=$(curl -s https://api.github.com/repos/projectdiscovery/subfinder/releases/latest | grep browser_download_url | grep linux_amd64 | cut -d '"' -f 4)
    [[ -z "$url" ]] && echo -e "${RED}[-] Échec de récupération de l'URL Subfinder${RESET}" && return 1

    tmpdir=$(mktemp -d)
    cd "$tmpdir"
    curl -LO "$url"
    tar -xzf subfinder-linux-amd64*.tar.gz

    sudo mv subfinder /usr/bin/subfinder
    sudo chmod +x /usr/bin/subfinder
    echo -e "${GREEN}[✓] Subfinder installé avec succès.${RESET}"
    cd ~
    rm -rf "$tmpdir"
}

install_httpx() {
    echo -e "${GREEN}[+] Installation de HTTPX...${RESET}"
    local url=$(curl -s https://api.github.com/repos/projectdiscovery/httpx/releases/latest | grep browser_download_url | grep linux_amd64 | cut -d '"' -f 4)
    [[ -z "$url" ]] && echo -e "${RED}[-] Échec de récupération de l'URL HTTPX${RESET}" && return 1

    tmpdir=$(mktemp -d)
    cd "$tmpdir"
    curl -LO "$url"
    tar -xzf httpx-linux-amd64*.tar.gz

    sudo mv httpx /usr/bin/httpx
    sudo chmod +x /usr/bin/httpx
    echo -e "${GREEN}[✓] HTTPX installé avec succès.${RESET}"
    cd ~
    rm -rf "$tmpdir"
}

install_xssstrike() {
    echo -e "${GREEN}[+] Installation de XSSStrike...${RESET}"
    sudo apt-get update -y
    sudo apt-get install -y python3 python3-pip git

    local install_dir="/opt/xssstrike"
    local bin_path="/usr/bin/xssstrike"

    sudo git clone https://github.com/s0md3v/xssstrike "$install_dir"
    sudo pip3 install -r "$install_dir/requirements.txt"

    sudo ln -sf "$install_dir/xssstrike.py" "$bin_path"
    sudo chmod +x "$install_dir/xssstrike.py"
    echo -e "${GREEN}[✓] XSSStrike installé avec succès.${RESET}"
}

install_wapiti() {
    echo -e "${GREEN}[+] Installation de Wapiti 3...${RESET}"
    sudo apt update
    sudo apt install -y python3 python3-pip git

    local install_dir="/opt/wapiti"
    local bin_path="/usr/bin/wapiti"

    sudo git clone https://github.com/wapiti-scanner/wapiti.git "$install_dir"
    sudo pip3 install -r "$install_dir/requirements.txt"

    sudo ln -sf "$install_dir/wapiti.py" "$bin_path"
    sudo chmod +x "$install_dir/wapiti.py"

    echo -e "${GREEN}[✓] Wapiti installé avec succès.${RESET}"
}

### --- Menu --- ###

while true; do
    echo -e "\n${GREEN}==== Installeur d'outils de reconnaissance ====${RESET}"
    echo "1. Installer Subfinder"
    echo "2. Installer HTTPX"
    echo "3. Installer XSSStrike"
    echo "4. Installer Wapiti"
    echo "5. Tout installer"
    echo "0. Quitter"
    read -p "Choix : " choix

    case $choix in
        1) install_subfinder ;;
        2) install_httpx ;;
        3) install_xssstrike ;;
        4) install_wapiti ;;
        5) install_subfinder && install_httpx && install_xssstrike && install_wapiti ;;
        0) echo -e "${GREEN}Fermeture.${RESET}"; exit 0 ;;
        *) echo -e "${RED}Choix invalide.${RESET}" ;;
    esac
done
