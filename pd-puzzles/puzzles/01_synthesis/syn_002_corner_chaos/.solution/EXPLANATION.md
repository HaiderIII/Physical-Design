# Solution Explanation - SYN_002 The Corner Chaos

## Le problème

Le script original ne chargeait qu'un seul fichier Liberty : le corner **typical**.

```tcl
# AVANT (problématique)
set lib_typical "$sky130_lib_dir/sky130_fd_sc_hd__tt_025C_1v80.lib"
read_liberty $lib_typical
```

Résultat : l'analyse timing utilisait des délais "moyens" au lieu des pires cas.

---

## La solution

Charger les **trois corners** avant l'analyse :

```tcl
# APRÈS (correct)

# Slow corner - pour setup analysis
set lib_slow "$sky130_lib_dir/sky130_fd_sc_hd__ss_n40C_1v40.lib"
puts "  Loading Slow corner: $lib_slow"
read_liberty $lib_slow

# Typical corner - pour référence
set lib_typical "$sky130_lib_dir/sky130_fd_sc_hd__tt_025C_1v80.lib"
puts "  Loading Typical corner: $lib_typical"
read_liberty $lib_typical

# Fast corner - pour hold analysis
set lib_fast "$sky130_lib_dir/sky130_fd_sc_hd__ff_n40C_1v95.lib"
puts "  Loading Fast corner: $lib_fast"
read_liberty $lib_fast
```

---

## Pourquoi ça fonctionne

OpenROAD maintient en mémoire tous les corners chargés. Lors de l'analyse timing :

| Commande | Corner utilisé | Raison |
|----------|----------------|--------|
| `report_checks -path_delay max` | Slow (ss) | Pire cas pour setup |
| `report_checks -path_delay min` | Fast (ff) | Pire cas pour hold |

L'outil sélectionne automatiquement le corner approprié selon le type d'analyse.

---

## Visualisation des corners

```
                    SLOW corner (ss)
                    ┌─────────────────┐
                    │ Process: Slow   │
                    │ Voltage: 1.40V  │  ──► Setup analysis
                    │ Temp: -40°C     │      (max delay)
                    └─────────────────┘
                           │
                           ▼
        ┌──────────────────────────────────┐
        │         TIMING SIGNOFF           │
        │   Design doit passer dans        │
        │   TOUS les corners               │
        └──────────────────────────────────┘
                           ▲
                           │
                    ┌─────────────────┐
                    │ Process: Fast   │
                    │ Voltage: 1.95V  │  ──► Hold analysis
                    │ Temp: -40°C     │      (min delay)
                    └─────────────────┘
                    FAST corner (ff)
```

---

## Impact sur les résultats

| Métrique | Typical seul | Multi-corner |
|----------|--------------|--------------|
| Setup slack | +2.1ns (optimiste) | Variable selon chemin |
| Hold slack | Non fiable | Calculé avec fast corner |
| Signoff ready | ❌ Non | ✅ Oui |

---

## Corners Sky130 disponibles

| Fichier | Process | Temp | Voltage | Usage |
|---------|---------|------|---------|-------|
| `*_tt_025C_1v80.lib` | Typical | 25°C | 1.80V | Estimation |
| `*_ss_n40C_1v40.lib` | Slow | -40°C | 1.40V | Setup signoff |
| `*_ff_n40C_1v95.lib` | Fast | -40°C | 1.95V | Hold signoff |

---

## Règles d'or du timing signoff

1. **Toujours** charger au minimum 2 corners (slow + fast)
2. **Setup** = max delay = slow corner
3. **Hold** = min delay = fast corner
4. **Ne jamais** signer off avec typical seul
5. En cas de doute, être **conservateur** (plus de corners)

---

## Dans l'industrie

Les vrais flows de signoff utilisent **MMMC** (Multi-Mode Multi-Corner) avec :
- 10-20+ corners PVT
- Plusieurs modes fonctionnels (normal, sleep, test...)
- OCV/AOCV/POCV pour les variations on-chip
- Analyse séparée pour différentes tensions d'alimentation

Ce puzzle vous a introduit au concept fondamental - la réalité industrielle est plus complexe mais repose sur les mêmes principes.
