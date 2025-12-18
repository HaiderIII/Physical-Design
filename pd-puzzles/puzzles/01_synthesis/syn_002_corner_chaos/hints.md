# Hints - SYN_002 The Corner Chaos

Si vous êtes bloqué, révélez les indices progressivement.

---

## Hint 1 - Comprendre le problème (révéler après 10 min)

<details>
<summary>Cliquez pour révéler</summary>

Le problème n'est pas une erreur de syntaxe - le script fonctionne !

Le problème est **conceptuel** : nous faisons une analyse de timing avec le mauvais corner.

Questions à vous poser :
- Quel fichier Liberty est chargé actuellement ?
- C'est quel corner (slow, typical, fast) ?
- Pour une analyse setup, quel corner devrait-on utiliser ?

Regardez la commande `read_liberty` dans le script...

</details>

---

## Hint 2 - La solution technique (révéler après 20 min)

<details>
<summary>Cliquez pour révéler</summary>

OpenROAD permet de charger plusieurs fichiers Liberty. Quand vous appelez `read_liberty` plusieurs fois, l'outil garde tous les corners en mémoire.

Pour charger les 3 corners :
```tcl
read_liberty $lib_slow    ;# Pour setup (max delay)
read_liberty $lib_typical ;# Pour référence
read_liberty $lib_fast    ;# Pour hold (min delay)
```

Mais attention ! OpenROAD utilise automatiquement :
- Le **pire cas (slow)** pour `-path_delay max` (setup)
- Le **meilleur cas (fast)** pour `-path_delay min` (hold)

Donc la solution est simplement de **charger TOUS les corners** avant l'analyse.

</details>

---

## Hint 3 - Le code exact (révéler après 30 min)

<details>
<summary>Cliquez pour révéler</summary>

Voici les lignes à ajouter/modifier dans la section "Load Liberty files" :

```tcl
# Load ALL corners for proper multi-corner analysis
puts ""
puts "Loading Liberty files..."

# Slow corner - used for setup analysis (max delay)
set lib_slow "$sky130_lib_dir/sky130_fd_sc_hd__ss_n40C_1v40.lib"
puts "  Loading Slow corner: $lib_slow"
read_liberty $lib_slow

# Typical corner - for reference
set lib_typical "$sky130_lib_dir/sky130_fd_sc_hd__tt_025C_1v80.lib"
puts "  Loading Typical corner: $lib_typical"
read_liberty $lib_typical

# Fast corner - used for hold analysis (min delay)
set lib_fast "$sky130_lib_dir/sky130_fd_sc_hd__ff_n40C_1v95.lib"
puts "  Loading Fast corner: $lib_fast"
read_liberty $lib_fast

puts "All corners loaded for multi-corner analysis."
```

**Important** : L'ordre de chargement peut importer. Certains outils utilisent le dernier corner chargé par défaut. OpenROAD est intelligent et utilise le bon corner selon le type d'analyse (max vs min).

Après cette modification, `report_checks -path_delay max` utilisera le corner slow, et `report_checks -path_delay min` utilisera le corner fast.

</details>

---

## Concept clé à retenir

```
┌─────────────────────────────────────────────────────────────┐
│                    TIMING SIGNOFF                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   Setup Check (données arrivent trop tard)                  │
│   ├── Pire cas = chemins les plus LENTS                     │
│   └── Corner: SLOW (ss) - basse tension, process lent       │
│                                                             │
│   Hold Check (données changent trop tôt)                    │
│   ├── Pire cas = chemins les plus RAPIDES                   │
│   └── Corner: FAST (ff) - haute tension, process rapide     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```
