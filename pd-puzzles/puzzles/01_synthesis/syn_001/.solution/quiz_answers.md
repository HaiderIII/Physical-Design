# 📝 Quiz Answers - SYN_001

---

## Question 1 : Pourquoi le script original échouait-il ?

**Réponse correcte : B**

> Le chemin vers le fichier Liberty était incorrect (chemin relatif au lieu d'absolu)

Le script utilisait `set pdk_dir "liberty"` qui est un chemin relatif. Quand OpenROAD essaie d'ouvrir `liberty/NangateOpenCellLibrary_typical.lib`, il cherche ce dossier dans le répertoire courant d'exécution, qui n'existe pas.

---

## Question 2 : Quelle commande TCL permet de construire un chemin de fichier de manière portable ?

**Réponse correcte : C**

> `file join $dir $file`

La commande `file join` est la méthode recommandée en TCL car elle :
- Gère automatiquement les séparateurs de chemin (`/` vs `\`)
- Évite les doubles slashes
- Fonctionne sur tous les systèmes d'exploitation

```tcl
# Exemple
file join "/home" "user" "file.txt"
# Retourne: /home/user/file.txt
```

L'option B (`"$dir/$file"`) fonctionne aussi sur Linux/Mac mais est moins portable.

---

## Question 3 : Pourquoi utiliser des chemins absolus plutôt que relatifs ?

**Réponse correcte : C**

> Les chemins relatifs dépendent du répertoire d'exécution, ce qui peut causer des erreurs

Un chemin relatif comme `liberty/file.lib` est résolu depuis le **répertoire courant** (`pwd`), pas depuis l'emplacement du script. Si vous lancez le script depuis un autre dossier, le chemin sera incorrect.

```bash
# Fonctionne (si lancé depuis syn_001/)
cd puzzles/01_synthesis/syn_001
openroad run.tcl

# Ne fonctionne pas (le chemin relatif est faux)
cd /home/user
openroad puzzles/01_synthesis/syn_001/run.tcl
```

---

## Question 4 : Quel est le rôle du fichier Liberty (.lib) ?

**Réponse correcte : B**

> Il contient les informations de timing et de puissance des cellules standard

Le fichier Liberty définit :
- **Timing** : délais de propagation, temps de setup/hold
- **Puissance** : consommation statique et dynamique
- **Fonctionnalité** : table de vérité des cellules

Le fichier LEF (réponse A) définit la géométrie physique.

---

## Question 5 : Pourquoi `file dirname` est appelé 3 fois ?

**Réponse correcte : A**

> Pour remonter de 3 niveaux dans l'arborescence depuis le script

Le script est dans :
```
pd-puzzles/puzzles/01_synthesis/syn_001/run.tcl
```

Pour atteindre `pd-puzzles/` (dojo_root) :
```tcl
set script_dir "/.../pd-puzzles/puzzles/01_synthesis/syn_001"

file dirname $script_dir
# -> "/.../pd-puzzles/puzzles/01_synthesis"

file dirname [file dirname $script_dir]
# -> "/.../pd-puzzles/puzzles"

file dirname [file dirname [file dirname $script_dir]]
# -> "/.../pd-puzzles"  <- dojo_root!
```

---

## Barème

| Score | Appréciation |
|-------|--------------|
| 5/5   | Excellent ! Vous maîtrisez les bases du scripting TCL pour OpenROAD |
| 4/5   | Très bien ! Un petit point à revoir |
| 3/5   | Bien, mais relisez `tcl_fundamentals/01_basics.md` |
| 2/5   | À améliorer - pratiquez les exercices TCL |
| 0-1/5 | Reprenez depuis le début de `tcl_fundamentals/` |

---

**Prochaine étape** : Lisez `EXPLANATION.md` pour comprendre en profondeur !
