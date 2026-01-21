# Phase 5: Routing

## Vue d'Ensemble

Le routage crée les **interconnexions métalliques** entre toutes les cellules selon la netlist. C'est l'étape finale avant le signoff qui détermine les performances réelles du circuit.

```
CTS DEF → [Routing] → Fully Routed DEF (avec géométries métal)
```

---

## 1. Concepts Fondamentaux

### 1.1 Structure des Couches Métalliques

```
    ┌─────────────────────────────────────┐
    │  Metal 9 (Top) - Power/Signals      │  ← Couches épaisses
    │  Metal 8       - Power straps       │     (faible R)
    ├─────────────────────────────────────┤
    │  Metal 7       - Long routes        │
    │  Metal 6       - Long routes        │  ← Couches semi-globales
    │  Metal 5       - Clock/Power        │
    ├─────────────────────────────────────┤
    │  Metal 4       - Vertical signals   │
    │  Metal 3       - Horizontal signals │  ← Couches locales
    │  Metal 2       - Vertical signals   │
    │  Metal 1       - Cell connections   │
    ├─────────────────────────────────────┤
    │  Polysilicon   - Gates              │  ← Niveau transistor
    │  Diffusion     - Source/Drain       │
    └─────────────────────────────────────┘
```

### 1.2 Routing Layers par PDK

| Layer | Sky130HD | ASAP7 | Direction |
|-------|----------|-------|-----------|
| M1 | li1 | M1 | Local (cells) |
| M2 | met1 | M2 | Vertical |
| M3 | met2 | M3 | Horizontal |
| M4 | met3 | M4 | Vertical |
| M5 | met4 | M5 | Horizontal |
| M6 | met5 | M6-M9 | Var. |

### 1.3 Tracks et Pitch

```
Track:
    ════════════════════════════════ Track N

    ════════════════════════════════ Track N-1
           ↑
         Pitch
           ↓
    ════════════════════════════════ Track N-2
```

**Track pitch** = Distance entre centres de deux tracks adjacents

---

## 2. Étapes du Routage

### 2.1 Global Routing

**Objectif:** Trouver les **chemins approximatifs** pour tous les nets

```
┌─────┬─────┬─────┬─────┐
│ G1  │ G2  │ G3  │ G4  │   Global Routing Cells (GCells)
├─────┼─────┼─────┼─────┤
│ G5  │ G6  │ G7  │ G8  │
├─────┼─────┼─────┼─────┤
│ G9  │ G10 │ G11 │ G12 │
└─────┴─────┴─────┴─────┘

Net A: G1 → G2 → G6 → G10  (chemin global)
```

**Caractéristiques:**
- Divise le chip en **Global Cells (GCells)**
- Calcule la **congestion** par région
- Génère des **routing guides**
- Rapide mais approximatif

### 2.2 Track Assignment

**Objectif:** Assigner chaque segment de net à un **track spécifique**

### 2.3 Detailed Routing

**Objectif:** Générer la **géométrie exacte** des wires et vias

```
Global:                    Detailed:
┌─────────┐               ┌─────────┐
│    ●────┼───            │    ●════╪═══
│         │               │         ║
│         │               │    ═════╬═══
│    ●────┼───            │    ●════╝
└─────────┘               └─────────┘
(Approximatif)            (Géométrie exacte avec vias)
```

---

## 3. Règles de Design (DRC)

### 3.1 Règles Fondamentales

```
Width Rule:
    ═════════════
    ↑   width   ↑
    └───────────┘
    width ≥ min_width

Spacing Rule:
    ═══════     ═══════
           ←→
         spacing
    spacing ≥ min_spacing

Enclosure Rule (Via):
    ┌─────────────┐
    │  ┌───────┐  │
    │  │  Via  │  │  Metal enclosure around via
    │  └───────┘  │
    └─────────────┘
```

### 3.2 Règles Avancées

| Règle | Description |
|-------|-------------|
| **Min Area** | Surface minimale d'un shape |
| **End-of-Line** | Espacement aux extrémités |
| **Parallel Run Length** | Espacement dépend de la longueur parallèle |
| **Cut Spacing** | Espacement entre vias |
| **Density** | Min/max métal par région |

### 3.3 Exemple Sky130

```tcl
# Règles Met1
Metal1:
    min_width:    0.14 µm
    min_spacing:  0.14 µm
    min_area:     0.083 µm²

# Via1
Via1:
    size:         0.15 × 0.15 µm
    enclosure:    0.055 µm (Met1), 0.055 µm (Met2)
    cut_spacing:  0.17 µm
```

---

## 4. Configuration du Routage

### 4.1 Global Routing (FastRoute)

```tcl
# Configuration globale
set_global_routing_layer_adjustment Metal1 0.8
set_global_routing_layer_adjustment Metal2-Metal5 0.5

# Options de routage
global_route -guide_file route.guide \
             -congestion_iterations 50 \
             -congestion_report_file congestion.rpt \
             -verbose

# Vérifier la congestion
report_global_routing_congestion
```

### 4.2 Detailed Routing (TritonRoute)

```tcl
# Configuration
set_thread_count 8

# Routage détaillé
detailed_route -output_drc drc_report.rpt \
               -output_maze maze_log.txt \
               -bottom_routing_layer Metal1 \
               -top_routing_layer Metal5 \
               -save_guide_updates \
               -verbose

# Ou configuration avancée
detailed_route_cmd \
    -bottom_routing_layer 2 \
    -top_routing_layer 6 \
    -droute_end_iteration 64 \
    -or_seed 42
```

### 4.3 Script Routage Complet

```tcl
# === 1. CHARGEMENT ===
read_lef $tech_lef
read_lef $cell_lef
read_liberty $lib_file
read_def $cts_def
read_sdc $sdc_file

# === 2. CONFIGURATION RC ===
set_wire_rc -layer Metal3
estimate_parasitics -placement

# === 3. GLOBAL ROUTING ===
# Ajustement des couches
set_global_routing_layer_adjustment Metal1 0.8
set_global_routing_layer_adjustment Metal2 0.7
set_global_routing_layer_adjustment Metal3-Metal5 0.5

# NDR pour clock (optionnel)
define_ndr -name clk_ndr -width {Metal3:0.2 Metal4:0.2} \
                         -spacing {Metal3:0.2 Metal4:0.2}
create_clock_tree_ndr -ndr clk_ndr

# Routage global
global_route -guide_file routing.guide \
             -congestion_iterations 100 \
             -overflow_iterations 100 \
             -allow_congestion

# === 4. DETAILED ROUTING ===
detailed_route -bottom_routing_layer Metal1 \
               -top_routing_layer Metal5 \
               -output_drc drc_results.rpt

# === 5. VÉRIFICATION ===
check_routes

# Timing final
estimate_parasitics -global_routing
report_checks -path_delay max -slack_max 0

# === 6. SAUVEGARDE ===
write_def routed.def
```

---

## 5. Analyse de Congestion

### 5.1 Métriques de Congestion

```
Congestion = Demand / Capacity × 100%

où:
  Demand  = Nombre de routes traversant la GCell
  Capacity = Nombre de tracks disponibles

Niveaux:
  < 80%  : OK
  80-100%: Warning
  > 100% : Overflow (impossible à router)
```

### 5.2 Visualisation

```tcl
# Rapport de congestion
report_global_routing_congestion -show_violations

# Carte de congestion (GUI)
gui::show_congestion_map

# Histogram
report_congestion_histogram
```

### 5.3 Résolution de Congestion

| Problème | Solution |
|----------|----------|
| **Overflow local** | Réduire utilization localement |
| **Macro blockage** | Repositionner ou ajouter channels |
| **High-fanout nets** | Ajouter des buffers, split nets |
| **Global overflow** | Augmenter die size ou réduire cells |

---

## 6. Special Routing

### 6.1 Power/Ground Routing

Fait pendant le floorplanning (PDN):
```tcl
# Straps et rails déjà définis
pdngen $pdn_config

# Le signal routing évite automatiquement le PDN
```

### 6.2 Clock Routing

Les nets clock ont souvent des règles spéciales:

```tcl
# NDR pour clock: largeur et espacement doublés
define_ndr -name clock_ndr \
    -width {Metal3:0.28 Metal4:0.28} \
    -spacing {Metal3:0.28 Metal4:0.28}

# Appliquer aux nets clock
create_ndr_rule -name clock_rule -ndr clock_ndr
assign_ndr_rule -rule clock_rule -nets [get_nets clk*]
```

### 6.3 Shielding

Protection contre le crosstalk:

```
    Signal wire
    ══════════════════════
    ───────────────────── VSS (shield)
    ══════════════════════
    Sensitive signal
    ══════════════════════
    ───────────────────── VDD (shield)
```

```tcl
# Shielding automatique
route_shielding -nets [get_nets sensitive_*] \
                -shield_net VSS
```

---

## 7. DRC Fixing

### 7.1 Types de violations

| Type | Description | Fix |
|------|-------------|-----|
| **Spacing** | Wires trop proches | Reroute/push |
| **Width** | Wire trop fin | Widen |
| **Short** | Wires connectés | Reroute |
| **Open** | Connection manquante | Add via/wire |
| **Via enclosure** | Metal insuffisant | Extend metal |

### 7.2 Fixing automatique

```tcl
# Tentatives de fix automatique
detailed_route -droute_end_iteration 100

# Rapport des violations restantes
check_routes -output drc_final.rpt

# Si violations persistent
# 1. Vérifier le placement
# 2. Ajouter des tracks
# 3. Utiliser des couches supplémentaires
```

---

## 8. Extraction Parasitique

### 8.1 Parasites RC

Chaque wire a des parasites:
- **R** (résistance): Dépend de longueur, largeur, matériau
- **C** (capacitance): Vers le substrat + couplage

```
    Wire 1          Wire 2
    ═══════════    ═══════════
       ↕ Cc (coupling cap)

       ↓ Cg (ground cap)
    ─────────────────────────── Substrate
```

### 8.2 Extraction Post-Route

```tcl
# Estimation rapide
estimate_parasitics -global_routing

# Extraction détaillée (génère SPEF)
extract_parasitics -output design.spef

# Pour STA précis
read_spef design.spef
```

### 8.3 Format SPEF

```
*DESIGN "alu_8bit"
*DATE "Mon Jan 20 10:00:00 2025"
*VENDOR "OpenROAD"

*NAME_MAP
*1 net_1
*2 net_2

*D_NET *1 0.0234  ;# Total cap in pF
*CONN
*I U1:ZN O         ;# Driver
*I U2:A I          ;# Load
*CAP
1 U1:ZN 0.0012
2 U2:A 0.0022
3 *1:1 0.0200      ;# Wire segment
*RES
1 U1:ZN *1:1 1.23  ;# Resistance in Ohms
2 *1:1 U2:A 2.34
*END
```

---

## 9. Métriques Post-Route

### 9.1 Rapport typique

```
=== Routing Summary ===

Total wire length:      125.4 mm
  Metal1:               12.3 mm (9.8%)
  Metal2:               34.5 mm (27.5%)
  Metal3:               45.6 mm (36.4%)
  Metal4:               23.4 mm (18.7%)
  Metal5:                9.6 mm (7.6%)

Total vias:             45,678
  Via1:                 12,345
  Via2:                 15,678
  Via3:                 10,234
  Via4:                  7,421

DRC violations:         0
Antenna violations:     3

Timing (post-route):
  WNS (setup):          -0.05 ns
  TNS (setup):          -0.89 ns
  WNS (hold):           +0.02 ns
```

### 9.2 Checklist post-route

- [ ] **DRC clean** (0 violations)
- [ ] **No opens** (toutes connexions faites)
- [ ] **Timing proche** du target
- [ ] **Antenna rules** respectées
- [ ] **Density** dans les limites

---

## 10. Problèmes Courants

### 10.1 Congestion Overflow

**Symptôme:** Routes impossibles, GCells > 100%

**Solutions:**
```tcl
# 1. Réduire l'utilization
# 2. Ajouter des couches de routage
set_global_routing_layer_adjustment Metal6 0.3

# 3. Permettre temporairement l'overflow
global_route -allow_congestion -overflow_iterations 200

# 4. Bloquer les zones problématiques
create_routing_blockage -boundary {x1 y1 x2 y2} -layers {Metal2 Metal3}
```

### 10.2 Timing Degradation

**Symptôme:** WNS empire après routage

**Causes:** Wire delay sous-estimé, crosstalk

**Solutions:**
```tcl
# 1. Extraction plus précise
estimate_parasitics -global_routing

# 2. Optimisation post-route
repair_timing -setup -slack_margin 0.1

# 3. NDR pour nets critiques
assign_ndr_rule -rule wide_spacing -nets [get_nets critical_*]
```

### 10.3 Antenna Violations

**Symptôme:** Charge accumulée endommage les gates

**Solutions:**
```tcl
# Insertion de diodes
repair_antenna -iterations 10

# Vérification
check_antenna_rules
```

---

## 11. Questions d'Interview - Routing

### Q1: Quelle est la différence entre global et detailed routing?
**R:**
- **Global routing**: Planification grossière, divise en GCells, trouve les chemins approximatifs
- **Detailed routing**: Génère la géométrie exacte sur les tracks, résout les DRC

### Q2: Qu'est-ce que la congestion et comment l'éviter?
**R:** **Congestion** = demande de routage > capacité des tracks

**Prévention:**
1. Utilization modérée (60-70%)
2. Placement timing-driven
3. Répartition uniforme des cellules
4. Channels entre macros

### Q3: Expliquez les règles DRC courantes
**R:**
- **Min width**: Largeur min du métal
- **Min spacing**: Distance min entre métaux
- **Via enclosure**: Métal autour du via
- **Min area**: Surface min d'un shape
- **Antenna**: Limite de charge pendant fabrication

### Q4: Qu'est-ce que le crosstalk et comment le minimiser?
**R:** **Crosstalk** = couplage capacitif entre wires adjacents

**Solutions:**
1. **Spacing** augmenté (NDR)
2. **Shielding** avec VDD/VSS
3. **Routage sur couches différentes**
4. **Wire spreading** dans les zones peu denses

### Q5: Pourquoi utiliser des NDR pour les clock nets?
**R:** Les **Non-Default Rules** pour le clock:
1. **Largeur plus grande**: Réduit la résistance → moins de latence
2. **Espacement plus grand**: Réduit le couplage → moins de jitter
3. **Double/triple via**: Améliore la fiabilité

### Q6: Comment l'extraction parasitique impacte-t-elle le timing?
**R:** L'extraction capture les **vraies** R et C des wires:
- **Pre-route**: Estimations basées sur placement
- **Post-route**: Valeurs réelles des géométries
- Différence typique: 10-30% sur les delays
- Le timing final doit utiliser l'extraction post-route (SPEF)

### Q7: Qu'est-ce que l'effet antenna et comment le résoudre?
**R:** **Antenna effect** = charge électrostatique accumulée sur le métal pendant la fabrication, pouvant endommager les gates.

**Solutions:**
1. **Antenna diodes**: Décharger vers le substrat
2. **Jumper routing**: Monter sur une couche supérieure
3. **Metal splitting**: Réduire la longueur des antennes

---

## Commandes Essentielles

```tcl
# OpenROAD Routing

# Global routing
set_global_routing_layer_adjustment Metal2-Metal5 0.5
global_route -guide_file route.guide

# Detailed routing
detailed_route -bottom_routing_layer Metal1 \
               -top_routing_layer Metal5

# Vérification
check_routes
report_global_routing_congestion

# Extraction
estimate_parasitics -global_routing
extract_parasitics -output design.spef

# Timing
report_checks -path_delay max

# Export
write_def routed.def
```

---

## Ressources

- [OpenROAD FastRoute](https://github.com/The-OpenROAD-Project/OpenROAD/tree/master/src/grt)
- [TritonRoute](https://github.com/The-OpenROAD-Project/OpenROAD/tree/master/src/drt)
- [ISPD Global Routing Contest](http://www.ispd.cc/contests/)
- [DRC Rules Reference](https://skywater-pdk.readthedocs.io/)
