#!/bin/bash
# Script pour exécuter OpenROAD via Docker
# Usage:
#   ./docker_openroad.sh              - Mode interactif
#   ./docker_openroad.sh openroad     - Lance OpenROAD
#   ./docker_openroad.sh yosys        - Lance Yosys
#   ./docker_openroad.sh <script.tcl> - Exécute un script TCL

IMAGE="openroad/orfs:latest"
WORKDIR="/Users/faizmohammad/Projects/Physical-Design"

# Vérifie si Docker est en cours d'exécution
if ! docker info > /dev/null 2>&1; then
    echo "Docker n'est pas en cours d'execution."
    echo "Veuillez lancer Docker Desktop d'abord."
    exit 1
fi

# Pull l'image si elle n'existe pas
if ! docker image inspect $IMAGE > /dev/null 2>&1; then
    echo "Telechargement de l'image OpenROAD..."
    docker pull --platform linux/amd64 $IMAGE
fi

# Exécute OpenROAD interactivement ou avec une commande
if [ $# -eq 0 ]; then
    echo "Lancement d'OpenROAD en mode interactif..."
    echo "Commandes disponibles: openroad, yosys, sta"
    echo ""
    docker run -it --rm \
        --platform linux/amd64 \
        -e HOME=/ \
        -v "$WORKDIR:/work" \
        -w /work \
        $IMAGE \
        bash -c "source /OpenROAD-flow-scripts/env.sh && exec bash"
else
    # Detecte si on a un TTY
    if [ -t 0 ]; then
        TTY_FLAG="-it"
    else
        TTY_FLAG="-i"
    fi
    # Pour Yosys: convertir $::env(HOME) en chemin absolu dans les scripts .ys
    CMD="$*"
    if [[ "$CMD" == *"yosys"* ]] && [[ "$CMD" == *".ys"* ]]; then
        # Extraire le fichier .ys et son repertoire parent
        YS_FILE=$(echo "$CMD" | grep -oE '[^ ]+\.ys')
        YS_DIR=$(dirname "$YS_FILE")
        PROJECT_DIR=$(dirname "$YS_DIR")
        docker run $TTY_FLAG --rm \
            --platform linux/amd64 \
            -e HOME=/ \
            -v "$WORKDIR:/work" \
            -w "$PROJECT_DIR" \
            $IMAGE \
            bash -c "source /OpenROAD-flow-scripts/env.sh && sed 's|\$::env(HOME)|/|g' $YS_FILE > /tmp/script.ys && yosys /tmp/script.ys"
    else
        docker run $TTY_FLAG --rm \
            --platform linux/amd64 \
            -e HOME=/ \
            -v "$WORKDIR:/work" \
            -w /work \
            $IMAGE \
            bash -c "source /OpenROAD-flow-scripts/env.sh && $*"
    fi
fi
