# Phase 4: Clock Tree Synthesis (CTS)

## Vue d'Ensemble

La CTS construit un **réseau de distribution d'horloge** qui délivre le signal clock à tous les registres avec un **skew minimal** et une **latence contrôlée**.

```
Placed DEF → [CTS] → DEF avec Clock Tree (buffers, inverters)
```

---

## 1. Concepts Fondamentaux

### 1.1 Anatomie d'un Clock Tree

```
                    Clock Source (PLL/Pad)
                           │
                    ┌──────┴──────┐
                    │  Root Buffer │
                    └──────┬──────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
         ┌────┴────┐  ┌────┴────┐  ┌────┴────┐
         │ Buffer  │  │ Buffer  │  │ Buffer  │  Level 1
         └────┬────┘  └────┬────┘  └────┬────┘
              │            │            │
         ┌────┴────┐  ┌────┴────┐  ┌────┴────┐
         │   ...   │  │   ...   │  │   ...   │  Level 2
         └────┬────┘  └────┬────┘  └────┬────┘
              │            │            │
        ┌─────┼─────┐  ┌───┼───┐  ┌─────┼─────┐
        ▼     ▼     ▼  ▼   ▼   ▼  ▼     ▼     ▼
       FF1   FF2   FF3 FF4 FF5 FF6 FF7  FF8  FF9  Sinks
```

### 1.2 Terminologie Clé

| Terme | Définition |
|-------|------------|
| **Clock Source** | Point d'origine du clock (PLL, pad I/O) |
| **Root Buffer** | Premier buffer après la source |
| **Sink** | Registre (flip-flop) recevant le clock |
| **Latency** | Délai source → sink |
| **Skew** | Différence de latency entre deux sinks |
| **Insertion Delay** | Délai total à travers l'arbre |

### 1.3 Skew vs Latency

```
         Source
            │
     ┌──────┴──────┐
     │             │
    Buf           Buf
     │             │
    Buf           Buf
     │             │
    FF1           FF2

  Latency1 = 1.2ns   Latency2 = 1.0ns

  Skew = |Latency1 - Latency2| = 0.2ns
```

---

## 2. Impact du Skew sur le Timing

### 2.1 Setup Time Analysis

```
          Launch FF                  Capture FF
             │                           │
    Clk ─────┴──────────────────────────┴─────
             │      Data Path           │
             └──────────────────────────┘

    Timing avec skew:

    T_clk + skew ≥ T_cq + T_data + T_setup

    Positive skew (capture retardé): AIDE le setup
    Negative skew (capture avancé): NUIT au setup
```

### 2.2 Hold Time Analysis

```
    T_skew + T_hold ≤ T_cq + T_data

    Positive skew: NUIT au hold
    Negative skew: AIDE au hold
```

### 2.3 Tableau récapitulatif

| Skew | Setup | Hold |
|------|-------|------|
| Positif (capture tard) | ✓ Aide | ✗ Nuit |
| Négatif (capture tôt) | ✗ Nuit | ✓ Aide |
| Zéro | Neutre | Neutre |

---

## 3. Topologies de Clock Tree

### 3.1 H-Tree

Distribution symétrique en forme de H:

```
           ┌───────────────────────┐
           │                       │
     ┌─────┼─────┐           ┌─────┼─────┐
     │     │     │           │     │     │
   ┌─┴─┐ ┌─┴─┐ ┌─┴─┐       ┌─┴─┐ ┌─┴─┐ ┌─┴─┐
   │ │ │ │ │ │ │ │ │       │ │ │ │ │ │ │ │ │
   ▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼       ▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼ ▼
```

**Avantages:** Skew minimal par construction
**Inconvénients:** Rigide, difficile avec placement irrégulier

### 3.2 Balanced Tree

Arbre équilibré par le nombre de sinks:

```
              Root
         ┌─────┼─────┐
         │     │     │
       ┌─┴─┐ ┌─┴─┐ ┌─┴─┐
       B   B B   B B   B
      ┌┴┐ ┌┴┐   ...
     FF FF FF FF
```

**Avantages:** Adaptatif au placement
**Inconvénients:** Peut avoir du skew si mal équilibré

### 3.3 Mesh/Grid

Grille de distribution:

```
    ═══════╪═══════╪═══════╪═══════
           │       │       │
    ═══════╪═══════╪═══════╪═══════
           │       │       │
    ═══════╪═══════╪═══════╪═══════
           │       │       │
          ▼▼▼     ▼▼▼     ▼▼▼
          FFs     FFs     FFs
```

**Avantages:** Très faible skew, robuste aux variations
**Inconvénients:** Haute consommation, grande area

---

## 4. Algorithme CTS

### 4.1 Étapes générales

1. **Clustering**: Grouper les sinks proches
2. **Tree construction**: Construire la topologie
3. **Buffer insertion**: Insérer buffers/inverters
4. **Balancing**: Équilibrer les latencies
5. **Optimization**: Minimiser skew/power

### 4.2 Sink Clustering

```
    Avant clustering:          Après clustering:

    •  •     •  •             ┌─────┐  ┌─────┐
       •  •     •             │  •  │  │  •  │
    •     •  •                │ • • │  │  •  │
       •     •  •             │  •  │  │• •  │
                              └─────┘  └─────┘
                              Cluster1  Cluster2
```

---

## 5. Configuration CTS dans OpenROAD

### 5.1 Sélection des buffers

```tcl
# Définir les buffers disponibles pour CTS
set cts_buffers [list \
    CLKBUF_X1 \
    CLKBUF_X2 \
    CLKBUF_X4 \
    CLKBUF_X8 \
    CLKBUF_X16]

# Root buffer (plus fort)
set root_buffer CLKBUF_X8
```

### 5.2 Paramètres CTS

```tcl
# Configuration wire RC
set_wire_rc -clock -layer Metal4

# Paramètres de clustering
set_clock_tree_options \
    -sink_clustering_enable true \
    -sink_clustering_size 20 \
    -sink_clustering_max_diameter 50

# CTS principale
clock_tree_synthesis \
    -root_buf $root_buffer \
    -buf_list $cts_buffers \
    -wire_unit 100 \
    -clk_nets clk \
    -obstruction_aware true
```

### 5.3 Script CTS complet

```tcl
# === 1. CHARGEMENT ===
read_lef $tech_lef
read_lef $cell_lef
read_liberty $lib_file
read_def $placed_def
read_sdc $sdc_file

# === 2. CONFIGURATION RC ===
# Wire RC pour l'estimation
set_wire_rc -signal -layer Metal3
set_wire_rc -clock -layer Metal4

# === 3. CTS ===
# Buffer list
set cts_buf_list [list CLKBUF_X2 CLKBUF_X4 CLKBUF_X8]

# Exécuter CTS
clock_tree_synthesis \
    -root_buf CLKBUF_X8 \
    -buf_list $cts_buf_list \
    -sink_clustering_enable \
    -sink_clustering_size 15 \
    -sink_clustering_max_diameter 60.0 \
    -balance_levels

# === 4. POST-CTS OPTIMISATION ===
# Estimer les parasitics
estimate_parasitics -placement

# Réparer le hold timing
repair_timing -hold -slack_margin 0.05

# Légaliser les nouveaux buffers
detailed_placement

# === 5. VÉRIFICATION ===
report_clock_tree
report_cts

# Timing check
report_checks -path_delay max -group_count 5
report_checks -path_delay min -group_count 5

# === 6. SAUVEGARDE ===
write_def cts.def
```

---

## 6. Analyse Post-CTS

### 6.1 Rapport CTS

```
=== Clock Tree Report ===

Clock: clk
  Number of sinks:           2048
  Number of buffers:          156
  Number of levels:             5

  Latency:
    Min:    0.85 ns
    Max:    1.12 ns
    Mean:   0.98 ns

  Skew:
    Max:    0.27 ns  (between FF_1234 and FF_5678)
    RMS:    0.08 ns

  Power:
    Dynamic:  12.3 mW
    Leakage:   0.4 mW
```

### 6.2 Commandes de rapport

```tcl
# Rapport général CTS
report_clock_tree

# Skew détaillé
report_clock_skew

# Timing post-CTS
report_checks -path_delay max -through [get_pins */CLK]
report_checks -path_delay min -through [get_pins */CLK]

# Buffers insérés
report_clock_tree_buffers
```

---

## 7. Optimisation CTS

### 7.1 Réduire le Skew

| Technique | Description |
|-----------|-------------|
| **Useful skew** | Introduire du skew intentionnel pour aider le timing |
| **Delay insertion** | Ajouter des delays sur les chemins rapides |
| **Buffer sizing** | Ajuster la taille des buffers |
| **Wire shielding** | Protéger les wires clock |

### 7.2 Useful Skew

```
    Chemin critique (setup violation):

    FF1 ─────[Longue logique]─────> FF2

    Solution: Retarder le clock de FF2

    Clock skew intentionnel = slack négatif récupéré
```

```tcl
# Activer useful skew
set_clock_tree_options -useful_skew true

# Ou spécifier manuellement
set_clock_latency -late 0.1 [get_pins FF_critical/CLK]
```

### 7.3 Réduire la Power

```tcl
# Utiliser des buffers plus petits quand possible
clock_tree_synthesis -buf_list {CLKBUF_X1 CLKBUF_X2}

# Limiter le nombre de niveaux
set_clock_tree_options -max_depth 6

# Clock gating
insert_clock_gate -cells {FF_group1 FF_group2}
```

---

## 8. Multi-Clock Designs

### 8.1 Horloges multiples

```tcl
# Définir plusieurs horloges
create_clock -name clk_fast -period 5.0 [get_ports clk_fast]
create_clock -name clk_slow -period 20.0 [get_ports clk_slow]

# CTS pour chaque horloge
clock_tree_synthesis -clk_nets {clk_fast clk_slow}
```

### 8.2 Clock Domain Crossing (CDC)

```
    Domain A (100 MHz)           Domain B (50 MHz)
         │                            │
        FF1 ─────[Sync FF]─────>     FF2
         │           │                │
        clk_a       clk_a            clk_b
                 (2-FF sync)
```

```tcl
# Marquer les chemins CDC comme false paths
set_false_path -from [get_clocks clk_a] -to [get_clocks clk_b]
set_false_path -from [get_clocks clk_b] -to [get_clocks clk_a]
```

---

## 9. Clock Gating

### 9.1 Concept

Réduire la consommation en désactivant le clock des registres inactifs:

```
         Clock Gating Cell
              ┌─────┐
    clk ─────>│ AND │──────> gated_clk ─────> FF
              └──┬──┘
    enable ──────┘
```

### 9.2 Intégration CTS

```tcl
# Identifier les cellules de clock gating
set_clock_gating_check -setup 0.1 -hold 0.1

# CTS avec clock gating
clock_tree_synthesis \
    -clock_gating_enable \
    -clock_gate_cells {TIEHI TIELO ICG_X1}
```

---

## 10. Problèmes Courants et Solutions

### 10.1 Skew trop élevé

**Causes:**
- Placement dispersé des sinks
- Buffers insuffisants
- Déséquilibre des branches

**Solutions:**
```tcl
# Augmenter le clustering
set_clock_tree_options -sink_clustering_size 10

# Ajouter des niveaux de buffers
clock_tree_synthesis -balance_levels

# Utiliser des buffers plus forts
clock_tree_synthesis -buf_list {CLKBUF_X4 CLKBUF_X8 CLKBUF_X16}
```

### 10.2 Hold Violations post-CTS

**Cause:** Le clock arrive avant que les données ne soient stables

**Solution:**
```tcl
# Réparer le hold avec des delay cells
repair_timing -hold \
              -slack_margin 0.05 \
              -max_buffer_percent 10
```

### 10.3 Congestion sur les couches clock

**Solution:**
```tcl
# Utiliser des couches supérieures pour le clock
set_wire_rc -clock -layer Metal5

# NDR (Non-Default Rules) pour le clock
create_ndr -name clock_ndr -width 2x -spacing 2x
set_clock_ndr -clock clk -ndr clock_ndr
```

---

## 11. Questions d'Interview - CTS

### Q1: Pourquoi le clock tree est-il critique?
**R:** Le clock tree:
1. **Synchronise** tous les registres
2. **Détermine la fréquence max** (skew impacte le timing)
3. **Consomme ~30-40%** de la power dynamique
4. Tout **skew non contrôlé** cause des violations setup/hold

### Q2: Quelle est la différence entre clock skew et clock jitter?
**R:**
- **Skew**: Différence **spatiale** de latency entre deux sinks (déterministe)
- **Jitter**: Variation **temporelle** du clock edge (stochastique, causé par bruit/PVT)

### Q3: Comment le skew affecte-t-il setup et hold?
**R:**
- **Setup**: Positive skew aide (plus de temps), negative skew nuit
- **Hold**: Positive skew nuit (données peuvent changer trop tôt), negative skew aide

Formules:
```
Setup: T_clk + skew ≥ T_cq + T_data + T_setup
Hold:  T_cq + T_data ≥ T_hold + skew
```

### Q4: Qu'est-ce que le useful skew?
**R:** **Useful skew** = introduction intentionnelle de skew pour améliorer le timing:
- Retarder le clock des registres de capture sur les chemins critiques (aide setup)
- Avancer le clock sur les chemins avec marge (aide les chemins longs)

### Q5: Pourquoi utiliser des buffers au lieu d'inverters pour le clock?
**R:** On utilise souvent les **deux**:
- **Buffers**: Non-inverting, plus simple à équilibrer
- **Inverters par paires**: Peuvent être plus rapides, meilleur drive
- Dans la pratique: l'outil choisit le meilleur selon les contraintes

### Q6: Comment réduire la power du clock tree?
**R:**
1. **Clock gating**: Désactiver le clock des blocs inactifs
2. **Buffers optimaux**: Pas de sur-dimensionnement
3. **Couches basses RC**: Minimiser la capacitance
4. **Clustering efficace**: Réduire le wire length

### Q7: Qu'est-ce que l'OCV (On-Chip Variation) et son impact sur CTS?
**R:** **OCV** = variations de process/voltage/temperature à travers le chip:
- Les delays varient selon la position
- L'outil applique des **derates** (10-20% sur clock path)
- Impact: Plus de marge nécessaire, design plus conservateur

```tcl
set_timing_derate -early 0.9 -cell_delay -clock
set_timing_derate -late 1.1 -cell_delay -clock
```

---

## Commandes Essentielles

```tcl
# OpenROAD CTS
set_wire_rc -clock -layer Metal4
clock_tree_synthesis -root_buf CLKBUF_X8 \
                     -buf_list {CLKBUF_X2 CLKBUF_X4}

# Post-CTS
repair_timing -hold
detailed_placement

# Rapports
report_clock_tree
report_clock_skew
report_checks -path_delay min  ;# Hold check

# Export
write_def cts.def
```

---

## Ressources

- [OpenROAD TritonCTS](https://github.com/The-OpenROAD-Project/OpenROAD/tree/master/src/cts)
- [Clock Tree Synthesis Fundamentals](https://www.vlsisystemdesign.com/)
- [Useful Skew Paper](https://ieeexplore.ieee.org/document/277026)
