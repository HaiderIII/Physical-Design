#!/bin/bash

echo "=== Vérification des outils pour Physical Design ==="
echo ""

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

check_tool() {
    if command -v $1 &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 installé"
        $1 --version 2>&1 | head -n 1
    else
        echo -e "${RED}✗${NC} $1 non installé"
        echo "   Installation: $2"
    fi
    echo ""
}

check_tool "openroad" "sudo apt install openroad (ou compilation depuis source)"
check_tool "yosys" "sudo apt install yosys"
check_tool "magic" "sudo apt install magic"
check_tool "klayout" "sudo apt install klayout"
check_tool "git" "sudo apt install git"

echo "=== Vérification du PDK Sky130 ==="
if [ -d "$HOME/.volare" ] || [ -d "/usr/local/share/pdk" ]; then
    echo -e "${GREEN}✓${NC} PDK Sky130 détecté"
else
    echo -e "${RED}✗${NC} PDK Sky130 non trouvé"
    echo "   Installation: pip install volare && volare enable sky130"
fi
echo ""

echo "=== Fin de la vérification ==="
