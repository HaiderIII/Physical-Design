# Interview Feedback - Session de Pratique

## Bilan Général

| Domaine | Niveau | Commentaire |
|---------|--------|-------------|
| **Flow RTL-to-GDSII** | ✓ Bon | Étapes connues, préciser les détails |
| **Timing (setup/hold)** | ✓ Solide | Formules OK, solutions à étoffer |
| **CTS/Skew** | ✓ Bon | Concept et useful skew maîtrisés |
| **Floorplanning** | ✓ Correct | Macros, halos compris |
| **Routing/Congestion** | ⚠️ À revoir | Confusions global/detailed, crosstalk |
| **Power** | ⚠️ À approfondir | Composantes pas maîtrisées |
| **Signal Integrity** | ⚠️ À revoir | Crosstalk mal compris |
| **DRC/LVS** | ✓ Correct | Concepts OK |

---

## Points à Réviser

### 1. Composantes de la Power

```
Total Power = Dynamic + Static

Dynamic = Switching + Internal
        = α × C × V² × f + P_internal

Static = Leakage = I_leak × V
```

| Composante | Réduction |
|------------|-----------|
| **Switching** | Clock gating, réduire V (effet V²!) |
| **Leakage** | Multi-Vt (HVT), power gating |

### 2. Global vs Detailed Routing

| Étape | Description |
|-------|-------------|
| **Global Routing** | Chemins approximatifs par GCells (régions), calcule la congestion |
| **Detailed Routing** | Géométrie exacte sur les tracks, place les vias, respecte DRC |

**Le placement est TERMINÉ avant le routing !**

### 3. Crosstalk (Diaphonie)

**Définition** : Couplage capacitif entre wires parallèles adjacents

```
Aggressor ════════════════════
              ↕ Cc (couplage)
Victim    ════════════════════
```

**Effets** :
- Glitch (spike parasite)
- Variation de delay

**Solutions** :
- Spacing augmenté (NDR)
- Shielding (VDD/VSS entre wires)
- Couches différentes
- Wire spreading

### 4. Congestion

```
Congestion = Demand / Capacity

> 100% = Overflow = Impossible à router
```

**Ce n'est PAS** : Un problème de signal ou d'antenna
**C'est** : Pas assez de tracks pour tous les wires

### 5. Antenna Effect (Différent du Crosstalk!)

- Problème de **fabrication**
- Charge électrostatique accumulée pendant gravure
- Peut détruire l'oxyde de gate
- **Solutions** : Diodes, jumper vers couche supérieure

---

## Erreurs Corrigées

### Placement des Macros
- ❌ "Macros placées au placement"
- ✓ Macros placées au **floorplanning**, le placement ne concerne que les **standard cells**

### PVT Corners
- ❌ "SS = faible courant"
- ✓ SS = **Slow-Slow Process** (transistors lents)

| Corner | Process | Voltage | Temp | Check |
|--------|---------|---------|------|-------|
| **SS** | Slow | Low | Hot | Setup (pire cas) |
| **FF** | Fast | High | Cold | Hold (pire cas) |

### Hold vs Fréquence
- ❌ Réduire la fréquence pour fixer le hold
- ✓ Hold est **indépendant** de la période clock !
- ✓ Solution hold : Ajouter des **delay buffers**

---

## Structure de Réponse Recommandée

Pour chaque question technique :

1. **Définition** : Qu'est-ce que c'est ?
2. **Impact** : Pourquoi c'est important ?
3. **Solutions** : Du moins invasif au plus invasif

### Exemple : Violation Setup

1. **Définition** : Données arrivent trop tard par rapport au clock edge
2. **Impact** : Le circuit ne fonctionne pas à la fréquence cible
3. **Solutions** :
   - Upsize cells sur chemin critique
   - Buffer insertion
   - Useful skew
   - Swap HVT → LVT
   - (Dernier recours) Réduire la fréquence

---

## Commandes à Connaître

```tcl
# Timing analysis
report_checks -path_delay max -slack_max 0  ;# Setup
report_checks -path_delay min -slack_max 0  ;# Hold
report_wns
report_tns

# Fixing
repair_timing -setup
repair_timing -hold -slack_margin 0.05

# Congestion
report_global_routing_congestion

# Power
report_power
```

---

## Prochaines Révisions

1. [ ] Relire `05_Routing.md` - Global vs Detailed
2. [ ] Relire `06_Signoff.md` - Power analysis
3. [ ] Pratiquer les calculs de slack
4. [ ] Mémoriser les solutions par ordre de priorité
