# Phase 3: Placement

## Vue d'Ensemble

Le placement positionne toutes les **cellules standard** dans la zone de placement définie lors du floorplanning. C'est une étape critique qui influence directement le timing, la routabilité et la consommation.

```
Floorplan DEF → [Placement] → Placed DEF (avec coordonnées)
```

---

## 1. Types de Placement

### 1.1 Global Placement

Première étape: placement approximatif optimisant le **wirelength** global.

```
Avant:                     Après Global Placement:
┌─────────────────────┐    ┌─────────────────────┐
│  A B C D E F G H    │    │  A   C     E   G    │
│  (cellules          │ →  │    B   D     F   H  │
│   non placées)      │    │  (placement global) │
└─────────────────────┘    └─────────────────────┘
```

**Caractéristiques:**
- Optimise le **Half-Perimeter Wire Length (HPWL)**
- Autorise le **cell overlap** temporairement
- Rapide mais imprécis

### 1.2 Detailed Placement (Légalisation)

Deuxième étape: placement légal sur les **rows** et **sites**.

```
Après Global:              Après Légalisation:
┌─────────────────────┐    ┌─────────────────────┐
│  A  C    E   G      │    │ A │ B │ C │ D │ E │ │
│    B  D    F   H    │ →  │ F │ G │ H │   │   │ │
│  (overlap possible) │    │ (sur grille, légal) │
└─────────────────────┘    └─────────────────────┘
```

**Caractéristiques:**
- Élimine tous les **overlaps**
- Aligne sur les **sites** de la row
- Minimise le déplacement depuis le global placement

---

## 2. Algorithmes de Placement

### 2.1 Quadratic Placement (Analytique)
- Modélise les connexions comme des **ressorts**
- Minimise la **fonction quadratique** de wirelength
- Rapide pour les gros designs
- Utilisé par: OpenROAD (RePlAce), Cadence Innovus

### 2.2 Simulated Annealing
- Exploration stochastique
- Échappe aux minima locaux
- Lent mais peut trouver de meilleurs résultats
- Utilisé pour: petits designs, macro placement

### 2.3 Partitioning-Based
- Divise le design récursivement (min-cut)
- FM algorithm (Fiduccia-Mattheyses)
- Bon pour les designs hiérarchiques

---

## 3. Métriques de Placement

### 3.1 Half-Perimeter Wire Length (HPWL)

```
    ┌─────────────────┐
    │                 │
    │  Pin1 ●         │ Height
    │         ● Pin2  │
    └─────────────────┘
           Width

HPWL = Width + Height
Total HPWL = Σ HPWL(net_i) pour tous les nets
```

### 3.2 Timing Metrics

| Métrique | Description | Cible |
|----------|-------------|-------|
| **WNS** | Worst Negative Slack | ≥ 0 ns |
| **TNS** | Total Negative Slack | ≥ 0 ns |
| **FEP** | Failing Endpoint count | 0 |

### 3.3 Congestion Metrics

```
Congestion = (Demand / Supply) × 100%

où:
- Demand = Nombre de routes nécessaires
- Supply = Nombre de tracks disponibles
```

---

## 4. Placement Timing-Driven

### 4.1 Concept

Le placement timing-driven utilise les **timing paths** pour influencer le placement:

```
Chemin critique:
    ┌───┐    Long wire    ┌───┐
    │ A │ ──────────────→ │ B │   Slack négatif!
    └───┘                 └───┘

Après timing-driven:
    ┌───┐ ┌───┐
    │ A │→│ B │   Slack amélioré
    └───┘ └───┘
```

### 4.2 Configuration

```tcl
# Estimer les RC des wires
estimate_parasitics -placement

# Global placement avec timing
global_placement -timing_driven \
                 -density 0.6 \
                 -pad_left 2 \
                 -pad_right 2

# Réseau de timing pour le placement
set_wire_rc -layer Metal3
```

---

## 5. Optimisation Post-Placement

### 5.1 Design Repair

```tcl
# Réparer les problèmes de design
repair_design \
    -max_wire_length 500 \
    -slew_margin 0.1 \
    -cap_margin 0.1

# Répare:
# - Long wires (buffer insertion)
# - High fanout nets (buffer tree)
# - Slew violations
# - Capacitance violations
```

### 5.2 Timing Repair

```tcl
# Réparer le timing setup
repair_timing -setup \
              -slack_margin 0.1 \
              -max_buffer_percent 20

# Réparer le timing hold (après CTS généralement)
repair_timing -hold \
              -slack_margin 0.1
```

### 5.3 Techniques d'optimisation

| Technique | Description | Impact |
|-----------|-------------|--------|
| **Buffer insertion** | Ajoute des buffers sur les longs wires | ↓ Delay, ↑ Area |
| **Cell sizing** | Remplace par des cellules plus fortes | ↓ Delay, ↑ Power |
| **Cell moving** | Repositionne les cellules critiques | ↓ Wire delay |
| **Pin swapping** | Échange les pins équivalentes | ↓ Wire length |
| **Net splitting** | Divise les nets à high fanout | ↓ Load capacitance |

---

## 6. Gestion de la Congestion

### 6.1 Causes de congestion

1. **Haute utilization** (>75%)
2. **Clusters de cellules** fortement connectées
3. **High fanout nets** (clock, reset)
4. **Macros mal placées**

### 6.2 Solutions

```tcl
# Augmenter le padding entre cellules
global_placement -pad_left 4 -pad_right 4

# Réduire la densité cible
global_placement -density 0.5

# Cellules de padding explicites
set_placement_padding -masters "*" -left 2 -right 2

# Route blockages pour guider le placement
create_route_guide -boundary "100 100 200 200" -layers {Metal2 Metal3}
```

### 6.3 Analyse de congestion

```tcl
# Rapport de congestion
report_congestion -routing

# Visualisation
gui::show_congestion_map
```

---

## 7. Script de Placement Complet

```tcl
# === 1. CHARGEMENT (si pas déjà fait) ===
read_lef $tech_lef
read_lef $cell_lef
read_liberty $lib_file
read_def $floorplan_def

# === 2. CONTRAINTES DE TIMING ===
read_sdc $sdc_file

# === 3. ESTIMATION RC ===
set_wire_rc -layer Metal3
estimate_parasitics -placement

# === 4. GLOBAL PLACEMENT ===
global_placement \
    -timing_driven \
    -density 0.6 \
    -pad_left 2 \
    -pad_right 2 \
    -skip_initial_place

# === 5. LÉGALISATION ===
detailed_placement

# === 6. OPTIMISATION ===
# Réparer les violations de design
repair_design -max_wire_length 500

# Réestimer les parasitics
estimate_parasitics -placement

# Réparer le timing setup
repair_timing -setup -slack_margin 0.1

# === 7. VÉRIFICATION ===
check_placement

# Rapport de timing
report_checks -path_delay max -slack_max 0 -group_count 10
report_checks -path_delay min -slack_max 0 -group_count 10

# Rapport de design
report_design_area
report_cell_usage

# === 8. SAUVEGARDE ===
write_def placement.def
```

---

## 8. Placement de Cellules Spéciales

### 8.1 Spare Cells

Cellules de réserve pour les ECO (Engineering Change Orders):

```tcl
# Ajouter des spare cells
add_spare_cells -cell_type "NAND2_X1 NOR2_X1 INV_X1" \
                -num_per_type 10

# Les placer uniformément
distribute_spare_cells
```

### 8.2 Filler Cells

Remplissent les gaps entre cellules pour:
- Continuité des rails VDD/VSS
- Continuité des wells
- DRC (design rules)

```tcl
# Insertion automatique
filler_placement -prefix FILLER \
                 -masters "FILLCELL_X1 FILLCELL_X2 FILLCELL_X4"
```

### 8.3 Decoupling Capacitors (Decaps)

Stabilisent l'alimentation localement:

```tcl
# Ajouter des decaps
add_decaps -prefix DECAP \
           -max_density 0.1 \
           -masters "DECAP_X1 DECAP_X2"
```

---

## 9. Placement Constraints

### 9.1 Grouping

```tcl
# Garder des cellules ensemble
create_placement_group -name critical_group \
                       -cells [get_cells critical_*]

# Contraintes de région
create_region -name fast_region -boundary {100 100 200 200}
assign_to_region -region fast_region -cells [get_cells fast_*]
```

### 9.2 Bounds

```tcl
# Limiter la position d'un groupe
create_bounds -name timing_bound \
              -region {0 0 500 500} \
              -cells [get_cells timing_critical*]
```

### 8.3 Relative Placement

```tcl
# A doit être à gauche de B
create_relative_floorplan -name rel1 \
                          -cells {A B} \
                          -constraint "A LEFT_OF B"
```

---

## 10. Métriques Post-Placement

### 10.1 Rapport typique

```
=== Placement Summary ===
Total instances:        9,804
  Standard cells:       9,702
  Macros:                   2
  Filler cells:           100

Total cell area:       81,234 µm²
Core area:            135,000 µm²
Utilization:              60.2%

HPWL:                  45.2 mm

Timing (estimated):
  WNS (setup):          -0.12 ns
  TNS (setup):          -2.34 ns
  WNS (hold):           +0.05 ns
```

### 10.2 Checklist post-placement

- [ ] **Pas d'overlap** de cellules
- [ ] **Toutes les cellules** sur des sites légaux
- [ ] **Utilization** dans la cible (50-70%)
- [ ] **Congestion** acceptable (<90%)
- [ ] **WNS setup** proche de 0 ou positif
- [ ] **Macros** bien positionnées (pas de blockage)

---

## 11. Questions d'Interview - Placement

### Q1: Quelle est la différence entre global et detailed placement?
**R:**
- **Global placement**: Positionnement approximatif optimisant le wirelength total, permet les overlaps
- **Detailed placement**: Légalisation sur les rows/sites, élimine les overlaps, affine le placement

### Q2: Comment le timing influence-t-il le placement?
**R:** Le **timing-driven placement**:
1. Identifie les **chemins critiques** via STA
2. Assigne des **poids** aux nets critiques
3. **Minimise le wirelength** sur ces nets en priorité
4. Place les cellules critiques **proches** les unes des autres

### Q3: Qu'est-ce que le HPWL et pourquoi l'utiliser?
**R:** **Half-Perimeter Wire Length** = demi-périmètre du bounding box des pins d'un net. Avantages:
- **Rapide** à calculer
- **Bonne approximation** du routage réel
- **Dérivable** (pour les algorithmes analytiques)

Limitation: Sous-estime les nets multi-pin.

### Q4: Comment gérer un design avec des violations de congestion?
**R:**
1. **Réduire l'utilization** target (ex: 70% → 60%)
2. **Augmenter le padding** entre cellules
3. **Bloquer le routage** dans les zones critiques
4. **Répartir les high-fanout nets** avec des buffers
5. **Repositionner les macros** pour ouvrir des channels

### Q5: Pourquoi faire du repair_design après placement?
**R:** `repair_design` corrige les violations de:
- **Long wires**: Insert des buffers
- **High fanout**: Crée des arbres de buffers
- **Slew violations**: Ajoute des drivers plus forts
- **Max capacitance**: Réduit la charge avec des buffers

Ces problèmes ne peuvent être résolus qu'après connaître les positions des cellules.

### Q6: Qu'est-ce que le cell padding et quand l'utiliser?
**R:** Le **cell padding** ajoute un espace virtuel autour des cellules:
- **Cas d'utilisation**:
  - Réduire la congestion de routage
  - Faciliter la légalisation
  - Laisser de l'espace pour les buffers de timing
  - Améliorer la routabilité des pins internes

```tcl
set_placement_padding -masters "*" -left 2 -right 2
```

### Q7: Comment vérifier la qualité du placement?
**R:** Métriques à vérifier:
1. **HPWL total**: Plus bas = meilleur
2. **WNS/TNS estimés**: Proche de 0 ou positifs
3. **Congestion**: <90% sur toutes les régions
4. **Utilization**: Dans la cible (60-70%)
5. **Pas d'overlaps** ou DRC violations

---

## Commandes Essentielles

```tcl
# OpenROAD Placement
global_placement -timing_driven -density 0.6
detailed_placement

# Optimisation
estimate_parasitics -placement
repair_design
repair_timing -setup

# Vérification
check_placement
report_checks -path_delay max -slack_max 0
report_design_area

# Export
write_def placement.def
```

---

## Ressources

- [OpenROAD RePlAce](https://github.com/The-OpenROAD-Project/OpenROAD/tree/master/src/gpl)
- [Placement Algorithms Survey](https://dl.acm.org/doi/10.1145/1278480.1278484)
- [Timing-Driven Placement](https://ieeexplore.ieee.org/document/1203259)
