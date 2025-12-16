# 📖 Explanation - SYN_001: The Missing Library

## Le problème en détail

### Ce qui se passait

Le script original contenait cette ligne problématique :

```tcl
set pdk_dir "liberty"  ;# WRONG!
```

Quand OpenROAD exécutait ensuite :

```tcl
set lib_file "$pdk_dir/NangateOpenCellLibrary_typical.lib"
read_liberty $lib_file
```

Il essayait d'ouvrir `liberty/NangateOpenCellLibrary_typical.lib`, un chemin **relatif** au répertoire d'exécution.

### Pourquoi ça échouait

```
Répertoire courant : /home/user/pd-puzzles/puzzles/01_synthesis/syn_001/
Chemin cherché     : /home/user/pd-puzzles/puzzles/01_synthesis/syn_001/liberty/
Chemin réel du PDK : /home/user/pd-puzzles/common/pdks/nangate45/
```

Le dossier `liberty/` n'existe tout simplement pas dans `syn_001/`.

---

## La solution

### Correction minimale

Remplacer la ligne fautive par un chemin absolu vers le PDK :

```tcl
# AVANT (faux)
set pdk_dir "liberty"

# APRÈS (correct)
set pdk_dir "$dojo_root/common/pdks/nangate45"
```

### Puis ajuster les sous-chemins

Les fichiers Liberty et LEF sont dans des sous-dossiers différents :

```tcl
# Liberty dans lib/
set lib_file "$pdk_dir/lib/NangateOpenCellLibrary_typical.lib"

# LEF dans lef/
set tech_lef "$pdk_dir/lef/NangateOpenCellLibrary.tech.lef"
set cell_lef "$pdk_dir/lef/NangateOpenCellLibrary.lef"
```

---

## Concepts clés appris

### 1. Chemins absolus vs relatifs

| Type | Exemple | Avantage | Inconvénient |
|------|---------|----------|--------------|
| Absolu | `/home/user/pdk/file.lib` | Toujours correct | Long, non portable |
| Relatif | `../pdk/file.lib` | Court | Dépend du `pwd` |
| Dynamique | `$root/pdk/file.lib` | Flexible | Nécessite calcul |

**Best practice** : Utilisez des chemins dynamiques construits à partir du chemin du script.

### 2. Calculer le chemin du script

```tcl
# Obtenir le chemin absolu du script en cours d'exécution
set script_path [file normalize [info script]]

# Obtenir le répertoire contenant le script
set script_dir [file dirname $script_path]
```

### 3. Naviguer dans l'arborescence

```tcl
# Remonter d'un niveau
set parent [file dirname $current]

# Descendre d'un niveau
set child [file join $current "subfolder"]

# Ou avec string concatenation (moins recommandé mais fonctionne)
set child "$current/subfolder"
```

### 4. Méthode portable avec `file join`

```tcl
# Plus propre et portable
set lib_file [file join $pdk_dir "lib" "NangateOpenCellLibrary_typical.lib"]
```

Avantages :
- Gère les séparateurs automatiquement (`/` sur Linux, `\` sur Windows)
- Évite les chemins mal formés (`//` ou `/./`)

---

## Pattern recommandé pour vos scripts

```tcl
#===============================================================================
# Script Setup - Pattern recommandé
#===============================================================================

# 1. Obtenir le chemin du script (fonctionne même avec source)
set script_dir [file dirname [file normalize [info script]]]

# 2. Définir les chemins relatifs au script
set design_dir [file join $script_dir "resources"]
set results_dir [file join $script_dir "results"]

# 3. Calculer le chemin vers les ressources partagées
set project_root [file dirname [file dirname $script_dir]]
set pdk_dir [file join $project_root "common" "pdks" "nangate45"]

# 4. Valider que les chemins existent
foreach path [list $design_dir $pdk_dir] {
    if {![file exists $path]} {
        error "Required path not found: $path"
    }
}

# 5. Construire les chemins des fichiers
set lib_file [file join $pdk_dir "lib" "NangateOpenCellLibrary_typical.lib"]
```

---

## Erreurs courantes similaires

### Erreur 1 : Oublier de mettre à jour tous les chemins

```tcl
# FAUX : pdk_dir corrigé mais lib_file utilise encore l'ancien sous-chemin
set pdk_dir "$dojo_root/common/pdks/nangate45"
set lib_file "$pdk_dir/NangateOpenCellLibrary_typical.lib"  # Manque "lib/"
```

### Erreur 2 : Confondre le répertoire du script et le répertoire courant

```tcl
# FAUX : pwd peut être n'importe où
set script_dir [pwd]

# CORRECT : info script donne le chemin du script
set script_dir [file dirname [info script]]
```

### Erreur 3 : Chemins hardcodés

```tcl
# FAUX : Ne fonctionnera que sur votre machine
set pdk_dir "/home/alice/pd-puzzles/common/pdks/nangate45"

# CORRECT : Chemin relatif au script
set pdk_dir "$dojo_root/common/pdks/nangate45"
```

---

## Pour aller plus loin

### Debugging des chemins

Si vous avez des doutes sur vos chemins, ajoutez des prints :

```tcl
puts "DEBUG: script_dir = $script_dir"
puts "DEBUG: dojo_root = $dojo_root"
puts "DEBUG: lib_file = $lib_file"
puts "DEBUG: exists? [file exists $lib_file]"
```

### Vérification automatique

```tcl
proc check_file {filepath description} {
    if {![file exists $filepath]} {
        puts "ERROR: $description not found"
        puts "  Expected: $filepath"
        exit 1
    }
    puts "OK: $description found"
}

check_file $lib_file "Liberty file"
check_file $tech_lef "Tech LEF"
check_file $cell_lef "Cell LEF"
```

---

## Résumé

| Ce que vous avez appris | Commande/Concept |
|------------------------|------------------|
| Obtenir le chemin du script | `[file dirname [info script]]` |
| Remonter dans l'arborescence | `[file dirname $path]` |
| Construire un chemin | `[file join $a $b $c]` ou `"$a/$b/$c"` |
| Vérifier l'existence | `[file exists $path]` |
| Normaliser un chemin | `[file normalize $path]` |

---

**Félicitations !** 🎉 Vous avez complété le premier puzzle de PD-Puzzles !

**Prochain puzzle** : `syn_002` - Clock Constraints Challenge
