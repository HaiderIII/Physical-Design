# 🥋 PD-Dojo

**Physical Design Puzzle Challenges with OpenROAD**

Un système de casse-têtes progressifs pour maîtriser le flow Physical Design et développer les compétences d'un ingénieur PD.

---

## 🎯 Objectif

Apprendre à résoudre les problèmes **réels** rencontrés par les ingénieurs Physical Design :
- Debugging de scripts TCL
- Analyse et correction de violations
- Optimisation des résultats (timing, area, power)
- Interprétation des logs et rapports

> **Philosophie** : Focus sur les compétences où l'ingénieur apporte une vraie valeur ajoutée, pas sur ce que l'IA peut faire automatiquement.

---

## 🛠️ Technologies

| PDK | Node | Usage |
|-----|------|-------|
| **Nangate45** | 45nm | Puzzles débutants, flow rapide |
| **Sky130** | 130nm | Puzzles intermédiaires, PDK industriel |
| **ASAP7** | 7nm | Puzzles avancés, effets FinFET |

---

## 📊 Niveaux de difficulté

| Niveau | Description | Temps estimé |
|--------|-------------|--------------|
| 🟢 Débutant | Concepts fondamentaux, erreurs simples | 15-20 min |
| 🟡 Intermédiaire | Problèmes courants, analyse requise | 30-45 min |
| 🔴 Avancé | Cas complexes, multi-facteurs | 45-60 min |

---

## 📁 Structure

```
pd-dojo/
├── setup/                  # Installation des PDKs
├── tcl_fundamentals/       # Cours TCL avant les puzzles
├── puzzles/
│   ├── 01_synthesis/       # Puzzles synthèse
│   ├── 02_floorplan/       # Puzzles floorplanning
│   ├── 03_placement/       # Puzzles placement
│   ├── 04_cts/             # Puzzles Clock Tree Synthesis
│   ├── 05_routing/         # Puzzles routing
│   └── 06_signoff/         # Puzzles signoff
└── common/                 # Ressources partagées
```

---

## 🚀 Pour commencer

### 1. Installation des PDKs
```bash
cd setup
./install_pdks.sh
openroad -gui verify_install.tcl
```

### 2. Apprendre les bases TCL
```bash
cd tcl_fundamentals
# Suivre 01_basics.md → 02_control_flow.md → 03_openroad_api.md
```

### 3. Premier puzzle
```bash
cd puzzles/01_synthesis/syn_001
cat PROBLEM.md              # Lire l'énoncé
openroad -gui run.tcl       # Tenter de résoudre
cat QUIZ.md                 # Valider la compréhension
```

---

## 📋 Format d'un puzzle

Chaque puzzle contient :

| Fichier | Description |
|---------|-------------|
| `PROBLEM.md` | Contexte, symptômes, objectif |
| `resources/` | Fichiers fournis (design, libs, etc.) |
| `run.tcl` | Script avec TODO à compléter |
| `hints.md` | Indices progressifs (optionnel) |
| `QUIZ.md` | QCM de validation |
| `.solution/` | Solution révélée après le quiz |

---

## 📈 Progression

Suivre sa progression dans [PROGRESS.md](PROGRESS.md)

---

## 🎓 Compétences développées

- ✅ Scripting TCL pour EDA
- ✅ Lecture et analyse de logs
- ✅ Debug méthodique
- ✅ Compréhension des trade-offs PD
- ✅ Utilisation de l'API OpenROAD
- ✅ Résolution de violations (timing, DRC, antenna)
