# Phase 2: Floorplanning

## Vue d'Ensemble

Le floorplanning définit la **géométrie physique** du chip: dimensions du die, zone de placement des cellules, positionnement des macros, et structure du réseau d'alimentation (PDN).

```
Gate-level Netlist → [Floorplanning] → Floorplan DEF
```

---

## 1. Concepts Fondamentaux

### 1.1 Die vs Core Area

```
┌─────────────────────────────────────────┐
│              DIE AREA                    │
│  ┌───────────────────────────────────┐  │
│  │         CORE AREA                 │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │    Placement Area           │  │  │
│  │  │    (Standard Cells)         │  │  │
│  │  │                             │  │  │
│  │  │    ┌─────────┐              │  │  │
│  │  │    │  MACRO  │              │  │  │
│  │  │    │ (SRAM)  │              │  │  │
│  │  │    └─────────┘              │  │  │
│  │  │                             │  │  │
│  │  └─────────────────────────────┘  │  │
│  │         Power Rings               │  │
│  └───────────────────────────────────┘  │
│              I/O Pads                    │
└─────────────────────────────────────────┘
```

| Zone | Description |
|------|-------------|
| **Die Area** | Surface totale du chip (incluant I/O pads) |
| **Core Area** | Zone interne pour les cellules et macros |
| **Core Margin** | Espace entre die et core (pour power rings) |
| **Placement Area** | Zone effective pour le placement des cellules |

### 1.2 Formules Clés

```
Core Area = Die Area - (2 × Core Margin)²

Utilization = (Cell Area + Macro Area) / Core Area × 100%

Target Utilization:
- 50-60% : Facile à router (recommandé pour débutants)
- 60-70% : Standard
- 70-80% : Dense, routing difficile
- >80%   : Très dense, risque de congestion
```

### 1.3 Sites et Rows

Les cellules standard sont placées sur des **rows** définies par des **sites**:

```
Row 3: │ site │ site │ site │ site │ site │ site │...
Row 2: │ site │ site │ site │ site │ site │ site │...
Row 1: │ site │ site │ site │ site │ site │ site │...
Row 0: │ site │ site │ site │ site │ site │ site │...
       └──────────────────────────────────────────
       Origin (0,0)
```

| Paramètre | Sky130HD | ASAP7 |
|-----------|----------|-------|
| Site Width | 0.46 µm | 0.054 µm |
| Site Height | 2.72 µm | 0.270 µm |
| Row Orientation | Alternée (N/FS) | Alternée |

---

## 2. Étapes du Floorplanning

### 2.1 Initialisation du Floorplan

```tcl
# Méthode 1: Spécifier die et core explicitement
initialize_floorplan \
    -die_area "0 0 1000 1000" \
    -core_area "50 50 950 950" \
    -site FreePDK45_38x28_10R_NP_162NW_34O

# Méthode 2: Calcul automatique basé sur utilization
initialize_floorplan \
    -utilization 60 \
    -aspect_ratio 1.0 \
    -core_space "50 50 50 50" \
    -site $site_name
```

### 2.2 Création des Tracks de Routage

```tcl
# Tracks pour chaque couche de métal
make_tracks Metal1 -x_offset 0.1 -x_pitch 0.2 -y_offset 0.1 -y_pitch 0.2
make_tracks Metal2 -x_offset 0.1 -x_pitch 0.2 -y_offset 0.1 -y_pitch 0.2
# ... pour toutes les couches

# Ou utiliser le script PDK
source $PDK_ROOT/make_tracks.tcl
```

### 2.3 Placement des I/O Pins

```tcl
# Placement automatique
place_pins -hor_layers Metal3 \
           -ver_layers Metal2 \
           -random

# Placement manuel (fichier .io)
place_pins -hor_layers Metal3 \
           -ver_layers Metal2 \
           -pin_file pins.io
```

Fichier `.io` pour placement manuel:
```
#N (North side)
clk
rst_n

#S (South side)
data_out[7]
data_out[6]
...

#E (East side)
data_in[7:0]

#W (West side)
control[3:0]
```

### 2.4 Placement des Macros

```tcl
# Placement manuel des SRAM
place_cell -cell imem_sram -origin {100 100} -orient R0
place_cell -cell dmem_sram -origin {100 400} -orient R0

# Orientations possibles
# R0   : Normal
# R90  : Rotation 90°
# R180 : Rotation 180°
# R270 : Rotation 270°
# MX   : Mirror X
# MY   : Mirror Y
# MXR90: Mirror X + Rotation 90°
# MYR90: Mirror Y + Rotation 90°
```

### 2.5 Halo et Blockages

```tcl
# Halo autour des macros (zone d'exclusion pour cellules standard)
set_placement_padding -masters $sram_master -left 10 -right 10 -top 10 -bottom 10

# Blockage de placement (zone interdite)
create_placement_blockage -boundary "100 100 200 200"

# Blockage de routage
create_routing_blockage -layers {Metal1 Metal2} -boundary "100 100 200 200"
```

---

## 3. Power Distribution Network (PDN)

### 3.1 Structure du PDN

```
                VDD Rail (Top Metal)
    ────────────────────────────────────────
         │              │              │
    ─────┼──────────────┼──────────────┼───── Straps (Metal5)
         │              │              │
    ━━━━━│━━━━━━━━━━━━━━│━━━━━━━━━━━━━━│━━━━━ Rings
         │              │              │
    ─────┼──────────────┼──────────────┼───── Straps (Metal3)
         │   │   │   │   │   │   │   │
    ─────┼───┼───┼───┼───┼───┼───┼───┼───── Rails (Metal1)
         │   │   │   │   │   │   │   │
        VDD VSS VDD VSS VDD VSS VDD VSS    (Standard Cells)
```

### 3.2 Composants du PDN

| Composant | Description | Couche typique |
|-----------|-------------|----------------|
| **Rails** | Alimentent les cellules standard | Metal1 |
| **Straps** | Distribuent le courant horizontalement/verticalement | Metal3-5 |
| **Rings** | Encadrent le core, connectent aux pads | Metal4-5 |
| **Vias** | Connexions entre couches | Via1-4 |

### 3.3 Configuration PDN OpenROAD

```tcl
# Définir le PDN
pdngen $pdn_config

# Fichier pdn.cfg
set_voltage_domain -name CORE -power VDD -ground VSS

# Rails sur Metal1
define_pdn_grid -name main_grid \
    -voltage_domains CORE \
    -pins Metal5

# Straps verticaux sur Metal4
add_pdn_stripe -layer Metal4 \
    -width 1.0 \
    -pitch 50.0 \
    -offset 10.0 \
    -followpins

# Straps horizontaux sur Metal5
add_pdn_stripe -layer Metal5 \
    -width 1.0 \
    -pitch 50.0 \
    -offset 10.0

# Connexions via
add_pdn_connect -layers {Metal1 Metal4}
add_pdn_connect -layers {Metal4 Metal5}
```

---

## 4. Tap Cells et Endcaps

### 4.1 Tap Cells (Well Taps)

Connectent les wells (N-well, P-well) aux rails d'alimentation pour éviter le **latch-up**.

```tcl
# Insertion des tap cells
tapcell -tapcell_master TAP_X1 \
        -endcap_master ENDCAP_X1 \
        -distance 30 \
        -halo_width_x 2 \
        -halo_width_y 2
```

**Règle:** Tap cells tous les 20-30 µm (dépend du PDK).

### 4.2 Endcaps

Cellules aux extrémités des rows pour fermer les wells.

```
Row: │ ENDCAP │ CELL │ CELL │ CELL │ CELL │ ENDCAP │
     └────────┴──────┴──────┴──────┴──────┴────────┘
```

---

## 5. Fichiers et Formats

### 5.1 LEF (Library Exchange Format)

**Technology LEF** - Informations sur les couches:
```
LAYER Metal1
    TYPE ROUTING ;
    DIRECTION HORIZONTAL ;
    PITCH 0.2 ;
    WIDTH 0.1 ;
    SPACING 0.1 ;
END Metal1
```

**Cell LEF** - Géométrie des cellules:
```
MACRO AND2_X1
    CLASS CORE ;
    SIZE 0.76 BY 1.12 ;
    SITE FreePDK45_38x28_10R_NP_162NW_34O ;
    PIN A1
        DIRECTION INPUT ;
        PORT
            LAYER Metal1 ;
            RECT 0.05 0.4 0.15 0.7 ;
        END
    END A1
    PIN ZN
        DIRECTION OUTPUT ;
        PORT
            LAYER Metal1 ;
            RECT 0.6 0.4 0.7 0.7 ;
        END
    END ZN
END AND2_X1
```

### 5.2 DEF (Design Exchange Format)

```
VERSION 5.8 ;
DESIGN alu_8bit ;
UNITS DISTANCE MICRONS 1000 ;

DIEAREA ( 0 0 ) ( 500000 500000 ) ;

COMPONENTS 9804 ;
- AND2_X1_1 AND2_X1 + PLACED ( 10000 20000 ) N ;
- DFF_X1_1 DFF_X1 + PLACED ( 15000 20000 ) N ;
...
END COMPONENTS

PINS 32 ;
- clk + NET clk + DIRECTION INPUT + USE SIGNAL
  + LAYER Metal2 ( -100 0 ) ( 100 200 )
  + PLACED ( 250000 0 ) N ;
...
END PINS

NETS 5432 ;
- net_1 ( AND2_X1_1 ZN ) ( DFF_X1_1 D ) ;
...
END NETS
```

---

## 6. Script Floorplanning Complet

```tcl
# === 1. CHARGEMENT DES FICHIERS ===
read_lef $tech_lef
read_lef $cell_lef
read_lef $sram_lef  ;# Si macros SRAM

read_liberty $lib_file
read_verilog $netlist
link_design $top_module

# === 2. INITIALISATION FLOORPLAN ===
initialize_floorplan \
    -utilization 60 \
    -aspect_ratio 1.0 \
    -core_space {50 50 50 50} \
    -site FreePDK45_38x28_10R_NP_162NW_34O

# === 3. TRACKS ===
source $pdk_dir/make_tracks.tcl

# === 4. PLACEMENT I/O ===
place_pins -hor_layers Metal3 -ver_layers Metal2

# === 5. PLACEMENT MACROS (si applicable) ===
# place_cell -cell sram_inst -origin {100 100} -orient R0

# === 6. HALOS ET BLOCKAGES ===
# set_placement_padding -masters SRAM_MACRO -left 10 -right 10

# === 7. TAP CELLS ===
tapcell -tapcell_master TAP_X1 \
        -endcap_master ENDCAP_X1 \
        -distance 25

# === 8. PDN ===
pdngen $pdn_cfg

# === 9. VÉRIFICATION ===
check_placement

# === 10. SAUVEGARDE ===
write_def floorplan.def
```

---

## 7. Métriques et Vérifications

### 7.1 Métriques clés

| Métrique | Valeur cible | Impact |
|----------|--------------|--------|
| **Utilization** | 50-70% | Routabilité, timing |
| **Aspect Ratio** | 0.8-1.2 | Wire length, routage |
| **Macro Coverage** | <40% | Flexibilité placement |

### 7.2 Commandes de vérification

```tcl
# Vérifier le floorplan
check_placement

# Rapport d'aire
report_design_area

# Statistiques
report_instance_count

# Densité
report_cell_density
```

---

## 8. Considérations Avancées

### 8.1 Macro Placement Guidelines

1. **Périphérie préférée**: Placer les macros sur les bords
2. **Orientation des pins**: Pins vers le centre pour minimiser le routage
3. **Grouping**: Macros liées proches les unes des autres
4. **Channels**: Laisser des canaux de routage entre macros

```
┌───────────────────────────────────────┐
│  ┌──────┐               ┌──────┐      │
│  │ SRAM │    Channel    │ SRAM │      │
│  │  A   │  ←─────────→  │  B   │      │
│  └──────┘               └──────┘      │
│           ↑                           │
│        Channel                        │
│           ↓                           │
│      ┌─────────────────────┐          │
│      │   Standard Cells    │          │
│      │      Placement      │          │
│      └─────────────────────┘          │
└───────────────────────────────────────┘
```

### 8.2 Congestion Anticipation

Facteurs causant la congestion:
- Haute utilization (>75%)
- Macros mal placées
- Nets à high fanout
- Clock tree dense

Solutions:
- Réduire l'utilization
- Ajouter des canaux de routage
- Placement-aware synthesis

---

## 9. Questions d'Interview - Floorplanning

### Q1: Comment choisir l'utilization target?
**R:** Dépend de plusieurs facteurs:
- **Design complexity**: Plus de nets = utilization plus basse
- **Timing criticality**: Timing serré = plus d'espace pour buffers
- **Technology node**: Nœuds avancés ont plus de congestion
- **Règle générale**: Commencer à 60%, ajuster selon les résultats de routage

### Q2: Pourquoi le core margin est-il nécessaire?
**R:** Le core margin fournit l'espace pour:
1. **Power rings** autour du core
2. **I/O routing** vers les pads externes
3. **ESD structures** et level shifters
4. **Decoupling capacitors** près des rails

### Q3: Qu'est-ce que le latch-up et comment le prévenir?
**R:** Le **latch-up** est un court-circuit parasite causé par les structures PNPN inhérentes au CMOS. Prévention:
1. **Tap cells** régulièrement espacées (garde les wells au bon potentiel)
2. **Guard rings** autour des I/O
3. **Proper well contacts** dans les macros

### Q4: Comment placer les macros pour minimiser le wire length?
**R:**
1. Analyser la **connectivity** (netlist) entre macros et logique
2. Placer les macros fortement connectées **proches**
3. Orienter les **pins vers la logique** qui les utilise
4. Utiliser des **fly-lines** pour visualiser les connexions

### Q5: Quelle est la différence entre placement blockage et routing blockage?
**R:**
- **Placement blockage**: Interdit le placement de cellules standard dans la zone
- **Routing blockage**: Interdit le routage sur certaines couches dans la zone
- On peut avoir un routing blockage sans placement blockage (ex: over-the-macro routing)

### Q6: Comment gérer un design avec beaucoup de macros?
**R:**
1. **Hierarchical floorplanning**: Diviser en blocs
2. **Macro grouping**: Regrouper par fonction
3. **Channel planning**: Prévoir les canaux de routage
4. **Utilization budgeting**: Ajuster par région
5. **Flyline analysis**: Visualiser les connexions avant placement

### Q7: Qu'est-ce que l'aspect ratio et pourquoi est-il important?
**R:** L'**aspect ratio** = Height / Width du core. Important car:
- **Ratio ~1.0**: Minimise le wire length moyen
- **Ratio éloigné de 1**: Peut causer des problèmes de timing (longs wires)
- Doit être compatible avec les contraintes de packaging

---

## Commandes Essentielles

```tcl
# OpenROAD
initialize_floorplan -utilization 60 -aspect_ratio 1.0
make_tracks
place_pins -hor_layers M3 -ver_layers M2
tapcell -tapcell_master TAP -distance 25
pdngen config.pdn

# Vérification
check_placement
report_design_area
report_cell_density

# Export
write_def floorplan.def
```

---

## Ressources

- [OpenROAD Floorplanning](https://openroad.readthedocs.io/en/latest/main/src/ifp/README.html)
- [LEF/DEF Reference](https://www.ispd.cc/contests/18/lefdefref.pdf)
- [Cadence Floorplanning Guide](https://www.cadence.com/)
