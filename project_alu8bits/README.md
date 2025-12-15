# Physical Design Flow - Projet Pédagogique

## Objectif
Apprendre le flow complet du Physical Design en utilisant OpenROAD, phase par phase, avec un ALU 8 bits.

## Structure du Projet

- **docs/** : Documentation théorique et commandes OpenROAD par phase
- **designs/** : Design RTL (ALU 8 bits) et contraintes
- **scripts/** : Scripts TCL pour chaque phase avec TODO pédagogiques
- **config/** : Configuration de la technologie Sky130
- **results/** : Résultats générés pour chaque phase

## Technologies Utilisées

- **PDK** : SkyWater Sky130 (130nm)
- **Outils** : OpenROAD, Yosys, Magic, KLayout
- **Design** : ALU 8 bits

## Installation

Tous les outils nécessaires sont installés. Vérifier avec :
```bash
./check_tools.sh
```

## Flow du Physical Design

1. **Synthesis** : RTL vers netlist
2. **Floorplanning** : Définition de la surface et placement des I/O
3. **Placement** : Placement des cellules standard
4. **Clock Tree Synthesis** : Synthèse de l'arbre d'horloge
5. **Routing** : Routage global et détaillé
6. **Optimization** : Optimisations timing et puissance
7. **Sign-off** : Vérifications finales (STA, DRC, LVS)

## Exécution
```bash
cd scripts
./run_flow.sh
```

## Auteur

Projet pédagogique pour l'apprentissage du Physical Design avec OpenROAD.
