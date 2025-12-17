# 📝 Quiz - SYN_001

> Répondez à ces questions **après** avoir corrigé le script et réussi la synthèse.
> Une seule réponse correcte par question.

---

## Question 1 : Pourquoi le script original échouait-il ?

**A)** Le fichier Liberty n'existait pas du tout

**B)** Le chemin vers le fichier Liberty était incorrect (chemin relatif au lieu d'absolu)

**C)** OpenROAD ne supporte pas Nangate45

**D)** Le fichier Verilog avait une erreur de syntaxe

---B---

## Question 2 : Quelle commande TCL permet de construire un chemin de fichier de manière portable ?

**A)** `concat $dir "/" $file`

**B)** `set path "$dir/$file"`

**C)** `file join $dir $file`

**D)** `path_combine $dir $file`

---C---

## Question 3 : Dans un script OpenROAD, pourquoi est-il préférable d'utiliser des chemins absolus plutôt que relatifs ?

**A)** Les chemins absolus sont plus courts à écrire

**B)** OpenROAD ne supporte pas les chemins relatifs

**C)** Les chemins relatifs dépendent du répertoire d'exécution, ce qui peut causer des erreurs

**D)** Les chemins absolus sont plus rapides à parser

---C---

## Question 4 : Quel est le rôle du fichier Liberty (.lib) dans le flow de synthèse ?

**A)** Il définit la géométrie physique des cellules (dimensions, pins)

**B)** Il contient les informations de timing et de puissance des cellules standard

**C)** Il décrit les règles de routage entre les couches de métal

**D)** Il stocke le netlist synthétisé du design

---B---

## Question 5 : La variable `$dojo_root` est calculée avec `file dirname` appelé 3 fois. Pourquoi ?

**A)** Pour remonter de 3 niveaux dans l'arborescence depuis le script

**B)** Pour supprimer l'extension du fichier

**C)** Pour convertir le chemin en chemin absolu

**D)** Pour normaliser les séparateurs de chemin

---A---

## Votre score

Notez vos réponses ici avant de vérifier :

| Question | Votre réponse |
|----------|---------------|
| Q1       |      B        |
| Q2       |      C        |
| Q3       |      C        |
| Q4       |      A        |
| Q5       |      A        |

---

## Vérifier vos réponses

Les réponses sont dans `.solution/quiz_answers.md`.

**Barème :**
- 5/5 : Excellent ! Vous maîtrisez les bases 🏆
- 4/5 : Très bien ! Relisez la question manquée
- 3/5 : Bien, mais revoyez les concepts TCL
- <3/5 : Reprenez les exercices dans `tcl_fundamentals/`

---

> Une fois le quiz complété, vous pouvez consulter `.solution/EXPLANATION.md` pour une explication détaillée.
