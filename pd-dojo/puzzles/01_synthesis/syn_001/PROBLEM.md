# 🧩 SYN_001 - The Missing Library

**Phase**: Synthesis
**Niveau**: 🟢 Débutant
**PDK**: Nangate45
**Temps estimé**: 15-20 min

---

## Contexte

C'est votre premier jour en tant qu'ingénieur Physical Design junior chez ChipStart Inc. Votre manager vous a confié une tâche simple : exécuter la synthèse d'un petit compteur 4 bits.

"Ça devrait être rapide," vous dit-il. "Le script est déjà prêt, il suffit de le lancer."

Confiant, vous ouvrez le terminal et lancez le script... mais OpenROAD refuse de coopérer.

---

## Symptômes observés

Quand vous exécutez `openroad run.tcl`, vous obtenez cette erreur :

```
Error: cannot open Liberty file 'liberty/NangateOpenCellLibrary_typical.lib'
```

Le script s'arrête immédiatement et aucune synthèse n'est effectuée.

---

## Objectif

Corriger le script `run.tcl` pour que la synthèse s'exécute correctement et génère un netlist synthétisé.

**Critères de succès** :
- [ ] Le script s'exécute sans erreur
- [ ] Un fichier `results/counter_synth.v` est généré
- [ ] Le rapport affiche le nombre de cellules utilisées

---

## Compétences visées

- [ ] Comprendre la structure des chemins de fichiers dans les scripts TCL
- [ ] Identifier et corriger les erreurs de chemin vers les fichiers PDK
- [ ] Utiliser les variables TCL pour construire des chemins robustes
- [ ] Lire et interpréter les messages d'erreur OpenROAD

---

## Fichiers fournis

```
syn_001/
├── PROBLEM.md          # Ce fichier
├── run.tcl             # Script à corriger (contient des TODO)
├── resources/
│   ├── counter.v       # Design Verilog (compteur 4 bits)
│   └── constraints.sdc # Contraintes de timing
├── hints.md            # Indices si vous êtes bloqué
└── QUIZ.md             # Quiz de validation
```

---

## Structure du PDK attendue

Le PDK Nangate45 devrait être installé dans `common/pdks/nangate45/` avec cette structure :

```
common/pdks/nangate45/
├── lib/
│   └── NangateOpenCellLibrary_typical.lib
├── lef/
│   ├── NangateOpenCellLibrary.tech.lef
│   └── NangateOpenCellLibrary.lef
└── ...
```

> 💡 Si le PDK n'est pas installé, exécutez d'abord : `./setup/install_pdks.sh --nangate45`

---

## Pour commencer

1. Lisez d'abord le fichier `run.tcl` pour comprendre ce qu'il essaie de faire
2. Identifiez la ligne qui pose problème
3. Corrigez le(s) TODO dans le script
4. Testez avec :

```bash
cd puzzles/01_synthesis/syn_001
openroad run.tcl
```

---

## Règles du jeu

1. **Ne regardez pas** le dossier `.solution/` avant d'avoir complété le quiz
2. Si vous êtes bloqué plus de 10 minutes, consultez `hints.md`
3. Une fois le script fonctionnel, répondez au quiz dans `QUIZ.md`

---

Bonne chance ! 🥋
