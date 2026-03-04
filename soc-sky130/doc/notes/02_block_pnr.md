# Phase 2 : Place & Route des Blocs

## Vue d'ensemble

Cette phase réalise le Place & Route (P&R) de chaque bloc individuellement avant l'intégration top-level. L'approche hiérarchique permet :
- Itérations rapides sur les petits blocs
- Isolation des problèmes de timing/routage
- Génération d'abstracts (LEF) pour l'intégration

## Statut des Blocs

| Bloc | Module | Synthèse | P&R | Die Size | Notes |
|------|--------|----------|-----|----------|-------|
| bus | wb_interconnect | ✅ 1,305 µm² | ✅ | 450×450 µm | Pin-dominated (626 pins) |
| spi | spi_wb | ✅ 2,432 µm² | ❌ | 140×140 µm | - |
| uart | uart_wb | ✅ 4,160 µm² | ❌ | 150×150 µm | - |
| timer | timer_wb | ✅ 5,011 µm² | ❌ | 160×160 µm | - |
| gpio | gpio_wb | ✅ 7,953 µm² | ❌ | 200×200 µm | - |
| cpu | cpu_wb_wrapper | ✅ 80,961 µm² | ❌ | 450×450 µm | Le plus gros bloc |
| dmem | dmem_wb_wrapper | ✅ 958 µm² | - | - | Wrapper SRAM, pas de P&R standalone |

## Résultats du Bloc Bus (Référence)

Le bloc bus est le premier à avoir complété le P&R avec succès :

```
Block: wb_interconnect (bus)
Die size: 450 × 450 µm
Core area: 192,580 µm²
Cell area: 1,569 µm² (après optimisation)
Utilization: 1% (pin-dominated design)

Timing:
- Setup slack (WNS): +0.02 ns ✅ MET
- Hold slack (WNS min): +3.93 ns ✅ MET
- TNS: 0.00 ns

Routing:
- DRC violations: 0 ✅
- Total wire length: 28,581 µm
- Vias: 2,912
- Layers used: li1, met1, met2, met3, met4
```

### Observations sur le Bus

1. **Pin-dominated** : Avec 626 pins et seulement 1,305 µm² de logique, le die de 450×450 µm est dimensionné pour les pins, pas la logique.

2. **CTS skip** : Le bus n'a pas de registres internes (logique combinatoire pure), donc CTS n'a rien à faire :
   ```
   [WARNING CTS-0041] Net "wb_clk_i" has 0 sinks. Skipping...
   ```

3. **Routing convergence** : 14 itérations pour converger de 1,763 violations à 0.

## Flow P&R OpenROAD

Le script `run_pnr.sh` génère un script TCL pour chaque bloc :

```
┌─────────────────────────────────────────────────────────────┐
│                      FLOORPLAN                              │
├─────────────────────────────────────────────────────────────┤
│  initialize_floorplan (die_area, core_area, site)          │
│  source make_tracks.tcl                                     │
│  place_pins -hor_layers met3 -ver_layers met2              │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                      PLACEMENT                              │
├─────────────────────────────────────────────────────────────┤
│  global_placement -density 0.7                              │
│  detailed_placement                                         │
│  estimate_parasitics -placement                             │
│  repair_design / repair_timing                              │
│  detailed_placement (re-legalize)                           │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                         CTS                                 │
├─────────────────────────────────────────────────────────────┤
│  clock_tree_synthesis                                       │
│    -root_buf sky130_fd_sc_hd__clkbuf_16                    │
│    -buf_list {clkbuf_1..16}                                │
│    -sink_clustering_enable                                  │
│  repair_clock_nets                                          │
│  detailed_placement                                         │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                       ROUTING                               │
├─────────────────────────────────────────────────────────────┤
│  set_routing_layers -signal li1-met4 -clock met3-met5      │
│  add_global_connection (VDD/VSS)                            │
│  global_route                                               │
│  detailed_route                                             │
└─────────────────────────────────────────────────────────────┘
```

## Dimensionnement des Die

Le dimensionnement du die dépend de deux facteurs :

### 1. Surface logique
```
Die_area_logic = Cell_area / Target_utilization
```
Exemple CPU : 80,961 µm² / 0.4 ≈ 202,000 µm² → 450×450 µm

### 2. Nombre de pins
```
Perimeter_needed = Num_pins × Pin_pitch
Die_side = Perimeter_needed / 4
```
Exemple Bus : 626 pins × ~2.7 µm pitch ≈ 1,690 µm perimeter → 423 µm/côté → 450×450 µm

**Règle** : Prendre le max des deux calculs.

| Bloc | Pins | Logic Area | Die (logic) | Die (pins) | Die Final |
|------|------|------------|-------------|------------|-----------|
| bus | 626 | 1,305 µm² | 60×60 | 420×420 | **450×450** (pins) |
| cpu | ~200 | 80,961 µm² | 450×450 | 140×140 | **450×450** (logic) |
| gpio | ~240 | 7,953 µm² | 140×140 | 165×165 | **200×200** |
| spi | ~140 | 2,432 µm² | 80×80 | 100×100 | **140×140** |

## Fichiers Générés

Pour chaque bloc, le P&R génère :

```
blocks/<block>/results/
├── pnr_<block>.tcl          # Script OpenROAD généré
├── pnr_<block>.log          # Log complet
├── <module>_floorplan.def   # Checkpoint après floorplan
├── <module>_placed.def      # Checkpoint après placement
├── <module>_cts.def         # Checkpoint après CTS
├── <module>_routed.def      # Design final routé
├── <module>_timing.rpt      # Rapport timing
└── <module>_area.rpt        # Rapport surface
```

## Commandes pour les Blocs Restants

Exécuter dans le répertoire `soc-sky130/` :

```bash
# SPI (le plus petit après bus)
./scripts/block_level/run_pnr.sh spi

# UART
./scripts/block_level/run_pnr.sh uart

# Timer
./scripts/block_level/run_pnr.sh timer

# GPIO
./scripts/block_level/run_pnr.sh gpio

# CPU (le plus gros - à faire en dernier)
./scripts/block_level/run_pnr.sh cpu
```

Ou tous d'un coup :
```bash
./scripts/block_level/run_pnr.sh all
```

## Critères de Succès

Pour chaque bloc, vérifier :

1. **DRC** : 0 violations
   ```
   [INFO DRT-0199]   Number of violations = 0.
   ```

2. **Timing Setup** : Slack positif
   ```
   worst slack max > 0
   ```

3. **Timing Hold** : Slack positif
   ```
   worst slack min > 0
   ```

## Problèmes Courants et Solutions

### 1. "Cannot fit design in core"
**Cause** : Die trop petit
**Solution** : Augmenter DIE_SIZE dans run_pnr.sh

### 2. "Cannot fit X pins"
**Cause** : Périmètre insuffisant pour les pins
**Solution** : Augmenter DIE_SIZE (facteur pins)

### 3. Timing violations persistantes
**Cause** : Chemins critiques trop longs
**Solutions** :
- Augmenter le die (moins de congestion)
- Réduire la densité de placement
- Vérifier les contraintes SDC

### 4. DRC violations non résolues
**Cause** : Congestion de routage
**Solutions** :
- Augmenter le die
- Réduire la densité
- Ajouter des couches de routage

## Prochaines Étapes

1. ✅ P&R bloc bus
2. ⬜ P&R bloc spi
3. ⬜ P&R bloc uart
4. ⬜ P&R bloc timer
5. ⬜ P&R bloc gpio
6. ⬜ P&R bloc cpu
7. ⬜ Génération des abstracts (LEF) pour chaque bloc
8. ⬜ Phase 3 : Intégration top-level
