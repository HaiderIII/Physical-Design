# Phase 6: Signoff (Vérification Finale)

## Vue d'Ensemble

Le signoff est la **validation finale** avant la fabrication (tapeout). Il inclut l'analyse de timing (STA), la vérification physique (DRC/LVS), et l'analyse de puissance.

```
Routed DEF → [Signoff] → Design Sign-off (prêt pour GDSII)
                 │
                 ├── STA (timing clean)
                 ├── DRC (physical rules clean)
                 ├── LVS (layout vs schematic match)
                 ├── Power Analysis
                 └── IR Drop Analysis
```

---

## 1. Static Timing Analysis (STA)

### 1.1 Concepts Fondamentaux

```
             Launch Edge                    Capture Edge
                 │                               │
    Clock ───────┴───────────────────────────────┴───────
                 │                               │
                 │      Data Valid Window        │
           ┌─────┴─────┐                   ┌─────┴─────┐
           │   T_cq    │                   │  T_setup  │
           └─────┬─────┘                   └─────┬─────┘
                 │                               │
    Data  ═══════╪═══════════════════════════════╪═══════
                 │     Combinational Delay       │
                 └───────────────────────────────┘
```

### 1.2 Setup Time Check

```
T_clk ≥ T_cq + T_comb + T_setup - T_skew

Slack_setup = T_clk - (T_cq + T_comb + T_setup - T_skew)
            = T_clk - T_arrival + T_required

Si Slack < 0 → VIOLATION!
```

### 1.3 Hold Time Check

```
T_cq + T_comb ≥ T_hold + T_skew

Slack_hold = (T_cq + T_comb) - (T_hold + T_skew)

Si Slack < 0 → VIOLATION!
```

### 1.4 Terminologie

| Terme | Définition |
|-------|------------|
| **WNS** | Worst Negative Slack - pire violation |
| **TNS** | Total Negative Slack - somme des violations |
| **FEP** | Failing Endpoint count |
| **Clock Period** | Période de l'horloge (1/fréquence) |
| **Setup/Hold** | Temps de stabilité requis avant/après edge |

---

## 2. Multi-Corner Multi-Mode (MCMM)

### 2.1 Corners PVT

```
┌─────────────────────────────────────────────────────────┐
│                    PVT Cube                              │
│                                                          │
│         Fast (FF)          Typical (TT)    Slow (SS)     │
│         ┌────────┐         ┌────────┐      ┌────────┐   │
│   Hot   │        │         │        │      │ SETUP  │   │
│  125°C  │        │         │        │      │ WORST  │   │
│         └────────┘         └────────┘      └────────┘   │
│         ┌────────┐         ┌────────┐      ┌────────┐   │
│  Room   │        │         │ TARGET │      │        │   │
│   25°C  │        │         │  CASE  │      │        │   │
│         └────────┘         └────────┘      └────────┘   │
│         ┌────────┐         ┌────────┐      ┌────────┐   │
│  Cold   │ HOLD   │         │        │      │        │   │
│  -40°C  │ WORST  │         │        │      │        │   │
│         └────────┘         └────────┘      └────────┘   │
│                                                          │
│    Low V (0.95V)      Nom V (1.0V)     High V (1.1V)    │
└─────────────────────────────────────────────────────────┘
```

### 2.2 Corners Standard

| Corner | Process | Voltage | Temp | Usage |
|--------|---------|---------|------|-------|
| **ss_100C_1v60** | Slow | 1.60V | 100°C | Setup (worst case) |
| **tt_025C_1v80** | Typical | 1.80V | 25°C | Nominal |
| **ff_n40C_1v95** | Fast | 1.95V | -40°C | Hold (worst case) |

### 2.3 Configuration Multi-Corner

```tcl
# Définir les corners
create_corner slow
create_corner typical
create_corner fast

# Charger les librairies par corner
read_liberty -corner slow $slow_lib
read_liberty -corner typical $typical_lib
read_liberty -corner fast $fast_lib

# Charger les parasitics par corner (si disponibles)
read_spef -corner slow slow.spef
read_spef -corner typical typical.spef
read_spef -corner fast fast.spef
```

---

## 3. Script STA Complet

```tcl
# === 1. SETUP ===
# Charger les librairies (multi-corner)
read_liberty -corner slow sky130_fd_sc_hd__ss_100C_1v60.lib
read_liberty -corner typical sky130_fd_sc_hd__tt_025C_1v80.lib
read_liberty -corner fast sky130_fd_sc_hd__ff_n40C_1v95.lib

# Charger le design
read_verilog $netlist
link_design $top_module

# Charger les parasitics
read_spef design.spef

# Charger les contraintes
read_sdc $sdc_file

# === 2. CONFIGURATION ===
# OCV derating (On-Chip Variation)
set_timing_derate -early 0.95 -cell_delay -clock
set_timing_derate -late 1.05 -cell_delay -clock
set_timing_derate -early 0.95 -cell_delay -data
set_timing_derate -late 1.05 -cell_delay -data

# === 3. ANALYSE SETUP ===
puts "=== SETUP ANALYSIS ==="
report_checks -path_delay max \
              -slack_max 0 \
              -group_count 10 \
              -format full

report_wns
report_tns

# === 4. ANALYSE HOLD ===
puts "\n=== HOLD ANALYSIS ==="
report_checks -path_delay min \
              -slack_max 0 \
              -group_count 10 \
              -format full

# === 5. RAPPORTS DÉTAILLÉS ===
# Chemins critiques
report_checks -from [all_inputs] -to [all_registers -data_pins] \
              -path_delay max -group_count 5

report_checks -from [all_registers -clock_pins] -to [all_outputs] \
              -path_delay max -group_count 5

# Clock report
report_clocks
report_clock_skew

# === 6. SAUVEGARDE ===
# Rapport complet
redirect timing_report.txt {
    report_checks -path_delay max -slack_max 0 -format full
    report_checks -path_delay min -slack_max 0 -format full
    report_tns
    report_wns
}
```

---

## 4. Lecture d'un Rapport de Timing

### 4.1 Format du Rapport

```
Startpoint: data_in_reg (rising edge-triggered flip-flop clocked by clk)
Endpoint: result_reg[0] (rising edge-triggered flip-flop clocked by clk)
Path Group: clk
Path Type: max (setup check)

  Delay    Time   Description
---------------------------------------------------------
  0.000    0.000   clock clk (rise edge)
  0.000    0.000   clock network delay (ideal)
  0.000    0.000 ^ data_in_reg/CLK (DFF_X1)
  0.150    0.150 ^ data_in_reg/Q (DFF_X1)
  0.023    0.173 ^ U1/ZN (INV_X1)
  0.045    0.218 v U2/ZN (NAND2_X1)
  0.089    0.307 ^ U3/ZN (AND2_X1)
  0.056    0.363 v U4/ZN (OR2_X1)
           0.363   data arrival time

  10.000   10.000   clock clk (rise edge)
  0.000    10.000   clock network delay (ideal)
  -0.100    9.900   clock uncertainty
  0.000     9.900   clock reconvergence pessimism
  -0.050    9.850 ^ result_reg[0]/CLK (DFF_X1)
  -0.080    9.770   library setup time
           9.770   data required time
---------------------------------------------------------
           9.770   data required time
          -0.363   data arrival time
---------------------------------------------------------
           9.407   slack (MET)
```

### 4.2 Éléments Clés

| Élément | Description |
|---------|-------------|
| **Startpoint** | Point de départ du chemin |
| **Endpoint** | Point d'arrivée (registre de capture) |
| **Path Type** | max (setup) ou min (hold) |
| **Data Arrival** | Temps d'arrivée des données |
| **Data Required** | Temps requis pour capture |
| **Slack** | Required - Arrival (positif = OK) |

---

## 5. On-Chip Variation (OCV)

### 5.1 Concept

Les variations locales causent des différences de delay sur le même chip:

```
                    Nominal         Avec OCV
Launch path:        5.0 ns          5.0 × 1.05 = 5.25 ns (late)
Capture clock:      1.0 ns          1.0 × 0.95 = 0.95 ns (early)

Setup margin réduit à cause des derates!
```

### 5.2 Configuration OCV

```tcl
# Derates globaux
set_timing_derate -early 0.95 -late 1.05 -cell_delay
set_timing_derate -early 0.97 -late 1.03 -net_delay

# Ou AOCV (Advanced OCV) - par distance
# Plus la distance est grande, plus le derate est faible
set_timing_derate -cell_delay -early 0.93 -late 1.07 \
                  -path_type data
```

### 5.3 CRPR (Clock Reconvergence Pessimism Removal)

Retire le pessimisme excessif quand launch et capture partagent un chemin:

```
         Shared path
    ┌────────────────┐
    │  Source → Buf  │
    └───────┬────────┘
            │
      ┌─────┴─────┐
      │           │
   Launch      Capture
   (late)      (early)

Sans CRPR: Double derating sur le shared path (pessimiste)
Avec CRPR: Supprime le derate sur le shared path
```

```tcl
# Activer CRPR
set_timing_derate -crpr
```

---

## 6. Power Analysis

### 6.1 Composantes de Power

```
Total Power = Dynamic Power + Static Power

Dynamic Power = Switching Power + Internal Power
              = α × C × V² × f + Σ(P_internal × activity)

Static Power = Leakage Power
             = I_leak × V
```

| Composante | Cause | Facteurs |
|------------|-------|----------|
| **Switching** | Charge/décharge des caps | Activité, capacitance |
| **Internal** | Court-circuits internes | Transitions, cell type |
| **Leakage** | Courant de fuite | Température, Vt |

### 6.2 Script Power Analysis

```tcl
# Charger le design routé
read_lef $lef_files
read_def $routed_def
read_liberty $lib_file
read_sdc $sdc_file

# Charger les parasitics
read_spef $spef_file

# Définir l'activité (switching activity)
set_power_activity -global -activity 0.1 -duty_cycle 0.5

# Ou depuis un fichier SAIF (de simulation)
# read_saif simulation.saif

# Rapport de puissance
report_power -hier

# Détails par type
report_power -breakdown
```

### 6.3 Rapport de Power

```
=== Power Report ===

Total Power:          90.3 mW

  Internal Power:     45.2 mW  (50.1%)
  Switching Power:    32.1 mW  (35.5%)
  Leakage Power:      13.0 mW  (14.4%)

Power by Hierarchy:
  top                 90.3 mW  (100.0%)
    cpu_core          42.5 mW   (47.1%)
    memory            35.8 mW   (39.6%)
    peripherals       12.0 mW   (13.3%)

Power by Cell Type:
  Sequential:         38.2 mW  (42.3%)
  Combinational:      39.1 mW  (43.3%)
  Macro:              13.0 mW  (14.4%)
```

---

## 7. IR Drop Analysis

### 7.1 Concept

**IR Drop** = chute de tension dans le PDN due à la résistance

```
    VDD (1.8V nominal)
         │
         R (résistance des straps/rails)
         │
         ▼
    VDD_local = VDD - I × R

Si VDD_local < VDD_min → Timing degradation!
```

### 7.2 Static vs Dynamic IR Drop

| Type | Cause | Analyse |
|------|-------|---------|
| **Static** | Courant moyen DC | Plus simple |
| **Dynamic** | Pics de courant (switching) | Plus réaliste |

### 7.3 Commandes IR Drop

```tcl
# Analyse statique
analyze_power_grid -net VDD
analyze_power_grid -net VSS

# Rapport
report_ir_drop

# Carte de IR drop (GUI)
gui::show_ir_drop_map
```

---

## 8. Design Rule Check (DRC)

### 8.1 Types de règles

```
WIDTH RULE:
    ═══════════════
    └─── width ───┘
    width ≥ min_width

SPACING RULE:
    ═════════    ═════════
           ←──→
          space
    space ≥ min_spacing

ENCLOSURE RULE:
    ┌──────────────┐
    │  ┌────────┐  │
    │  │  Via   │  │   enc ≥ min_enclosure
    │  └────────┘  │
    └──────────────┘
```

### 8.2 Vérification DRC

```tcl
# Dans OpenROAD
check_routes -output drc_report.rpt

# Avec Magic (externe)
magic -dnull -noconsole << EOF
lef read $tech_lef
def read $routed_def
load $design_name
drc check
drc why
quit
EOF
```

---

## 9. Layout vs Schematic (LVS)

### 9.1 Concept

Compare le layout physique avec la netlist:
- Extraction des devices du layout
- Comparaison avec la netlist
- Vérification des connexions

### 9.2 Vérification LVS

```bash
# Avec netgen (open-source)
netgen -batch lvs \
    "layout.spice layout_top" \
    "netlist.v netlist_top" \
    $pdk_setup_file \
    lvs_report.txt
```

### 9.3 Erreurs LVS courantes

| Erreur | Description | Fix |
|--------|-------------|-----|
| **Open** | Connection manquante | Vérifier routage |
| **Short** | Connection non voulue | Vérifier spacing |
| **Device mismatch** | Paramètres différents | Vérifier sizing |
| **Net mismatch** | Noms différents | Vérifier aliases |

---

## 10. Checklist Signoff

### 10.1 Timing Signoff

- [ ] **WNS (setup) ≥ 0** sur tous les corners
- [ ] **WNS (hold) ≥ 0** sur tous les corners
- [ ] **Clock skew** acceptable (<5% période)
- [ ] **OCV/AOCV** appliqué
- [ ] **CRPR** activé
- [ ] **Tous les modes** vérifiés

### 10.2 Physical Signoff

- [ ] **DRC clean** (0 violations)
- [ ] **LVS clean** (netlist = layout)
- [ ] **Antenna clean**
- [ ] **Density rules** respectées
- [ ] **ERC** (Electrical Rule Check) OK

### 10.3 Power Signoff

- [ ] **IR drop** < 5% VDD
- [ ] **EM** (Electromigration) OK
- [ ] **Power budget** respecté

---

## 11. Questions d'Interview - Signoff

### Q1: Quelle est la différence entre setup et hold timing?
**R:**
- **Setup**: Données doivent être stables **avant** l'edge clock
  - Violation → Fréquence trop haute
  - Fix: Réduire fréquence ou optimiser le chemin
- **Hold**: Données doivent rester stables **après** l'edge clock
  - Violation → Données changent trop vite
  - Fix: Ajouter des buffers de delay

### Q2: Pourquoi faire du multi-corner analysis?
**R:** Les performances varient selon PVT:
- **Process**: Variations de fabrication
- **Voltage**: Fluctuations d'alimentation
- **Temperature**: Variations thermiques

Le design doit fonctionner dans **tous** les corners:
- **Slow corner**: Pire cas setup
- **Fast corner**: Pire cas hold

### Q3: Qu'est-ce que l'OCV et pourquoi est-il important?
**R:** **On-Chip Variation** = variations locales sur le même chip.
- Même technologie, même die, différents delays
- Causé par variations de process, gradients thermiques, IR drop local
- **Impact**: Rend le timing plus pessimiste mais réaliste
- **Derates typiques**: ±5-10% sur les cell delays

### Q4: Comment fixer une violation setup?
**R:**
1. **Réduire le delay du data path**:
   - Upsize les cellules sur le chemin critique
   - Ajouter des buffers pour réduire le load
   - Optimiser la logique (restructuring)
2. **Augmenter le delay du clock path** (useful skew):
   - Retarder le capture clock
3. **Réduire la fréquence** (dernier recours)

### Q5: Comment fixer une violation hold?
**R:**
1. **Augmenter le delay du data path**:
   - Insérer des **delay buffers**
   - Utiliser des cellules plus lentes
2. **Réduire le delay du clock path**:
   - Moins pratique, affecte d'autres chemins
3. **Ne jamais** réduire la fréquence (hold indépendant de la période)

### Q6: Qu'est-ce que le CRPR?
**R:** **Clock Reconvergence Pessimism Removal**:
- Quand launch et capture clock partagent un chemin commun
- Sans CRPR: le chemin commun est deraté deux fois (trop pessimiste)
- Avec CRPR: supprime le double derate sur le chemin partagé
- Résultat: analyse plus réaliste, moins de faux négatifs

### Q7: Comment réduire l'IR drop?
**R:**
1. **Améliorer le PDN**:
   - Straps plus larges
   - Plus de vias
   - Mesh plus dense
2. **Réduire le courant**:
   - Clock gating
   - Power gating des blocs inactifs
3. **Placement optimisé**:
   - Cellules high-power près des rails
   - Decaps dans les zones critiques

### Q8: Quelle est la différence entre DRC et LVS?
**R:**
- **DRC**: Vérifie que le layout respecte les **règles de fabrication** (spacing, width, etc.)
- **LVS**: Vérifie que le layout correspond à la **netlist** (connexions correctes)

Les deux sont nécessaires: DRC pour la fabricabilité, LVS pour la fonctionnalité.

---

## Commandes Essentielles

```tcl
# STA
read_liberty -corner slow $slow_lib
read_verilog $netlist
link_design $top
read_spef $spef
read_sdc $sdc

report_checks -path_delay max -slack_max 0
report_checks -path_delay min -slack_max 0
report_wns
report_tns

# Power
set_power_activity -global -activity 0.1
report_power

# DRC
check_routes

# Export
write_verilog final_netlist.v
```

---

## Ressources

- [OpenSTA User Guide](https://github.com/The-OpenROAD-Project/OpenSTA)
- [STA Concepts](https://www.vlsisystemdesign.com/)
- [Power Analysis](https://www.synopsys.com/glossary/what-is-power-analysis.html)
- [DRC/LVS with Magic](http://opencircuitdesign.com/magic/)
