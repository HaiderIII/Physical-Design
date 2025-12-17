# 04_cts Puzzles - Clock Tree Synthesis

## 📋 Liste des puzzles

| ID | Nom | Niveau | PDK | Status |
|----|-----|--------|-----|--------|
| cts_001_skew | The Buffer Blunder | ⭐ Débutant | Nangate45 | ✅ Prêt |

---

## 🎯 Concepts couverts

### cts_001_skew - The Buffer Blunder
- **Bug**: Utiliser BUF_X* au lieu de CLKBUF_X* pour le clock tree
- **Concept**: Différence entre buffers réguliers et clock buffers
- **Apprentissage**:
  - Rise/fall times équilibrés des clock buffers
  - Impact sur le skew
  - Sélection du root buffer
  - Best practices industrie

---

## 🚀 Puzzles à venir

| ID | Concept | Niveau |
|----|---------|--------|
| cts_002_latency | Optimisation de latence | ⭐⭐ |
| cts_003_multiclock | Multiple clock domains | ⭐⭐⭐ |
| cts_004_gating | Clock gating insertion | ⭐⭐ |

---

## 📝 Prérequis

Avant de commencer les puzzles CTS, assurez-vous d'avoir complété:
1. ✅ `flp_001_sizing` - Comprendre le floorplanning
2. ✅ `plc_001_density` - Comprendre le placement

Le CTS s'exécute après le placement et avant le routage.
