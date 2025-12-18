# SYN_002 - The Corner Chaos

**Phase**: Synthesis / Timing Setup
**Niveau**: Intermediate
**PDK**: Sky130HD
**Temps estimé**: 30-45 min

---

## Contexte

Après quelques semaines chez ChipStart Inc., vous avez gagné en confiance. Votre manager vous confie maintenant un design plus critique : un contrôleur SPI qui doit fonctionner dans des conditions environnementales variées (température, voltage).

"Ce design part en fabrication," vous prévient-il. "Le timing doit être garanti dans TOUS les corners PVT."

Vous lancez le script de synthèse existant... Le timing passe avec 2ns de slack positif. Parfait !

Mais lors de la revue, l'ingénieur senior fronce les sourcils : "Tu as vérifié quel corner ? Ce slack me semble trop optimiste..."

---

## Symptômes observés

Quand vous exécutez `openroad run.tcl`, le script termine sans erreur :

```
=============================================
 Timing Summary (Setup)
=============================================
Endpoint                       Slack
---------------------------------------------
spi_data_out                   2.145ns (MET)
---------------------------------------------
All paths meet timing!
```

Pourtant, l'ingénieur senior affirme que le design a des violations de timing. Comment est-ce possible ?

---

## Objectif

Corriger le script `run.tcl` pour effectuer une analyse multi-corner correcte.

**Critères de succès** :
- [ ] Les 3 corners PVT sont chargés (slow, typical, fast)
- [ ] L'analyse setup utilise le corner slow
- [ ] L'analyse hold utilise le corner fast
- [ ] Le rapport affiche le VRAI worst-case slack

---

## Compétences visées

- [ ] Comprendre les corners PVT (Process, Voltage, Temperature)
- [ ] Savoir quel corner utiliser pour setup vs hold
- [ ] Configurer une analyse multi-corner dans OpenROAD
- [ ] Interpréter les résultats de timing par corner

---

## Fichiers fournis

```
syn_002_corner_chaos/
├── PROBLEM.md          # Ce fichier
├── run.tcl             # Script à corriger (analyse single-corner)
├── resources/
│   ├── spi_controller.v    # Design Verilog (contrôleur SPI)
│   └── constraints.sdc     # Contraintes de timing (100 MHz)
├── hints.md            # Indices progressifs
└── QUIZ.md             # Quiz de validation
```

---

## Rappel : Corners PVT

| Corner | Process | Voltage | Temp | Usage |
|--------|---------|---------|------|-------|
| **Slow (ss)** | Slow | Low (1.60V) | Hot (100°C) ou Cold (-40°C) | Setup analysis |
| **Typical (tt)** | Typical | Nominal (1.80V) | 25°C | Estimation |
| **Fast (ff)** | Fast | High (1.95V) | Cold (-40°C) | Hold analysis |

**Règle d'or** :
- **Setup** (données arrivent trop tard) → Pire cas = **SLOW** corner
- **Hold** (données changent trop tôt) → Pire cas = **FAST** corner

---

## Fichiers Liberty disponibles

Dans le PDK Sky130, vous avez accès à :

```
sky130_fd_sc_hd__tt_025C_1v80.lib  # Typical
sky130_fd_sc_hd__ss_n40C_1v40.lib  # Slow
sky130_fd_sc_hd__ff_n40C_1v95.lib  # Fast
```

---

## Pour commencer

1. Examinez `run.tcl` - quel corner est actuellement utilisé ?
2. Identifiez les TODO dans le script
3. Ajoutez le chargement des corners manquants
4. Configurez l'analyse pour utiliser le bon corner
5. Testez avec :

```bash
cd puzzles/01_synthesis/syn_002_corner_chaos
openroad run.tcl
```

---

## Règles du jeu

1. **Ne regardez pas** le dossier `.solution/` avant d'avoir complété le quiz
2. Si vous êtes bloqué plus de 10 minutes, consultez `hints.md`
3. Une fois le script fonctionnel, répondez au quiz dans `QUIZ.md`

---

Bonne chance ! Le timing signoff n'attend pas !
