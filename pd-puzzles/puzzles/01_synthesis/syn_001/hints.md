# 💡 Hints - SYN_001

> Essayez de résoudre le puzzle par vous-même d'abord !
> Ne révélez un indice que si vous êtes bloqué depuis plus de 5 minutes.

---

## Hint 1 - Comprendre l'erreur

<details>
<summary>Cliquez pour révéler</summary>

L'erreur dit :
```
Error: cannot open Liberty file 'liberty/NangateOpenCellLibrary_typical.lib'
```

Cela signifie qu'OpenROAD cherche le fichier Liberty dans un dossier appelé `liberty/` **relatif au répertoire courant**.

**Questions à vous poser :**
- Est-ce que ce dossier `liberty/` existe vraiment ?
- Où est réellement installé le PDK ?
- Quelle variable dans le script définit ce chemin ?

</details>

---

## Hint 2 - Localiser le PDK

<details>
<summary>Cliquez pour révéler</summary>

Le PDK Nangate45 est installé dans :
```
pd-puzzles/common/pdks/nangate45/
```

La structure est :
```
nangate45/
├── lib/
│   └── NangateOpenCellLibrary_typical.lib
├── lef/
│   ├── NangateOpenCellLibrary.tech.lef
│   └── NangateOpenCellLibrary.lef
└── ...
```

**Ce qu'il faut faire :**
- Modifier la variable `pdk_dir` pour pointer vers le bon emplacement
- Utiliser la variable `$dojo_root` qui est déjà définie dans le script

</details>

---

## Hint 3 - La solution (presque)

<details>
<summary>Cliquez pour révéler</summary>

Regardez ces lignes dans le script :

```tcl
set dojo_root [file dirname [file dirname [file dirname $script_dir]]]
```

Cette ligne calcule le chemin vers la racine de pd-puzzles.

Ensuite, le problème est ici :
```tcl
set pdk_dir "liberty"  ;# <-- THIS IS WRONG!
```

Vous devez construire le chemin complet vers le PDK en utilisant `$dojo_root`.

**Format de la correction :**
```tcl
set pdk_dir "$dojo_root/common/pdks/nangate45/???"
```

Mais attention ! Les fichiers Liberty sont dans `lib/` et les fichiers LEF sont dans `lef/`.

Il y a donc **plusieurs lignes à corriger**, pas seulement `pdk_dir`.

</details>

---

## Toujours bloqué ?

Si vous avez lu les 3 indices et que ça ne fonctionne toujours pas :

1. Vérifiez que le PDK est installé : `ls -la ../../../common/pdks/nangate45/`
2. Vérifiez les sous-dossiers : `ls ../../../common/pdks/nangate45/lib/`
3. Testez votre chemin manuellement dans OpenROAD interactif

Si le PDK n'est pas installé, retournez à la racine et lancez :
```bash
./setup/install_pdks.sh --nangate45
```

---

> 📚 Une fois le puzzle résolu, complétez le quiz dans `QUIZ.md` avant de regarder la solution !
