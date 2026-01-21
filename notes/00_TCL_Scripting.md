# TCL Scripting pour EDA

## Introduction

TCL (Tool Command Language) est le langage de scripting standard pour les outils EDA (Electronic Design Automation). Tous les outils majeurs (Synopsys, Cadence, OpenROAD) utilisent TCL comme interface de commande.

---

## 1. Syntaxe de Base

### Variables
```tcl
# Affectation
set variable_name value
set design_name "alu_8bit"
set clock_period 10.0

# Lecture
puts $variable_name
puts "Design: $design_name"

# Expression mathématique
set result [expr {$clock_period / 2}]
```

### Listes
```tcl
# Création
set lib_files {sky130_fd_sc_hd__tt_025C_1v80.lib sky130_fd_sc_hd__ff_n40C_1v95.lib}
set corners [list slow typical fast]

# Accès
lindex $lib_files 0          ;# Premier élément
llength $lib_files           ;# Longueur
lappend lib_files new.lib    ;# Ajouter

# Itération
foreach lib $lib_files {
    read_liberty $lib
}
```

### Dictionnaires
```tcl
# Création
set design_params [dict create \
    name "riscv_core" \
    clock_period 10.0 \
    utilization 0.7]

# Accès
dict get $design_params name
dict set design_params target_freq 100
```

---

## 2. Structures de Contrôle

### Conditions
```tcl
if {$slack < 0} {
    puts "TIMING VIOLATION: WNS = $slack"
} elseif {$slack < 0.1} {
    puts "Warning: Tight timing margin"
} else {
    puts "Timing OK"
}

# Switch
switch $corner {
    "slow"    { set voltage 0.95 }
    "typical" { set voltage 1.0 }
    "fast"    { set voltage 1.1 }
    default   { error "Unknown corner" }
}
```

### Boucles
```tcl
# For
for {set i 0} {$i < 10} {incr i} {
    puts "Iteration $i"
}

# While
while {$iterations < $max_iter && $slack < 0} {
    repair_timing
    incr iterations
}

# Foreach avec index
foreach {name value} $param_list {
    puts "$name = $value"
}
```

---

## 3. Procédures et Fonctions

### Définition de procédures
```tcl
proc report_timing_summary {corner} {
    puts "=== Timing Report for $corner ==="
    report_checks -path_delay max
    report_checks -path_delay min
}

# Avec valeurs par défaut
proc set_clock {name period {uncertainty 0.1}} {
    create_clock -name $name -period $period [get_ports clk]
    set_clock_uncertainty $uncertainty [get_clocks $name]
}

# Retourner une valeur
proc get_worst_slack {} {
    set timing_report [report_checks -digits 3]
    # Parse and return worst slack
    return $slack
}
```

### Portée des variables
```tcl
proc my_proc {} {
    global design_name        ;# Accès variable globale
    upvar 1 local_var alias   ;# Référence variable appelant
    variable namespace_var    ;# Variable de namespace
}
```

---

## 4. Manipulation de Chaînes

### Opérations courantes
```tcl
# Concaténation
set full_path "${dir}/${filename}.v"

# Substitution
set new_name [string map {old new} $name]

# Extraction
string range $str 0 5
string index $str 3

# Recherche
string first "clk" $signal_name
string match "*_reg*" $cell_name

# Formatage
set msg [format "Slack: %.3f ns" $slack]
```

### Expressions régulières
```tcl
# Match
if {[regexp {^clk_} $signal]} {
    puts "Clock signal detected"
}

# Extraction avec capture
regexp {(\w+)/(\w+)} $path match cell pin
puts "Cell: $cell, Pin: $pin"

# Substitution
regsub -all {_reg\[(\d+)\]} $name {_ff[\1]} new_name
```

---

## 5. Fichiers et I/O

### Lecture de fichiers
```tcl
# Lire tout le contenu
set fp [open "design.v" r]
set content [read $fp]
close $fp

# Ligne par ligne
set fp [open "timing.rpt" r]
while {[gets $fp line] >= 0} {
    if {[string match "*VIOLATED*" $line]} {
        puts "Found violation: $line"
    }
}
close $fp
```

### Écriture de fichiers
```tcl
set fp [open "results.txt" w]
puts $fp "Design: $design_name"
puts $fp [format "WNS: %.3f ns" $wns]
close $fp

# Append mode
set fp [open "log.txt" a]
puts $fp "[clock format [clock seconds]]: $message"
close $fp
```

---

## 6. Commandes OpenROAD Essentielles

### Chargement du design
```tcl
# Lire les fichiers technologiques
read_lef $tech_lef
read_lef $cell_lef

# Lire les fichiers de timing
read_liberty $lib_file

# Lire le design
read_verilog $netlist
link_design $top_module

# Lire les contraintes
read_sdc $sdc_file
```

### Floorplanning
```tcl
# Définir la zone de die
initialize_floorplan -die_area "0 0 500 500" \
                     -core_area "10 10 490 490" \
                     -site $site_name

# Placer les I/O
place_pins -hor_layers $h_layer -ver_layers $v_layer

# Créer les tracks de routage
make_tracks
```

### Placement
```tcl
# Placement global
global_placement -density 0.7 -pad_left 2 -pad_right 2

# Légalisation
detailed_placement

# Optimisation
repair_design
repair_timing -hold -setup
```

### Clock Tree Synthesis
```tcl
# Configuration CTS
set_wire_rc -layer $clk_layer
clock_tree_synthesis -root_buf $clk_buf \
                     -buf_list $buf_cells \
                     -sink_clustering_enable

# Rapport
report_cts
```

### Routage
```tcl
# Routage global
global_route -guide_file $guide_file \
             -congestion_iterations 50

# Routage détaillé
detailed_route -output_drc $drc_file \
               -output_maze $maze_log
```

---

## 7. Commandes OpenSTA Essentielles

### Configuration timing
```tcl
# Charger les librairies
read_liberty -corner slow $slow_lib
read_liberty -corner fast $fast_lib

# Charger le design
read_verilog $netlist
link_design $top

# Charger les parasitics
read_spef $spef_file

# Lire les contraintes
read_sdc $sdc_file
```

### Analyse de timing
```tcl
# Rapport de timing
report_checks -path_delay max -slack_max 0
report_checks -path_delay min

# Statistiques
report_tns    ;# Total Negative Slack
report_wns    ;# Worst Negative Slack

# Chemins spécifiques
report_checks -from [get_pins $start] -to [get_pins $end]
report_checks -through [get_pins $through]
```

### Contraintes SDC courantes
```tcl
# Horloge
create_clock -name clk -period 10 [get_ports clk]
set_clock_uncertainty 0.1 [get_clocks clk]
set_clock_transition 0.2 [get_clocks clk]

# Input/Output delays
set_input_delay -clock clk 2.0 [get_ports {data_in*}]
set_output_delay -clock clk 2.0 [get_ports {data_out*}]

# False paths
set_false_path -from [get_clocks clk_a] -to [get_clocks clk_b]

# Multicycle paths
set_multicycle_path 2 -setup -from [get_pins */Q] -to [get_pins */D]
```

---

## 8. Patterns Courants en EDA

### Itération sur les cellules
```tcl
foreach cell [get_cells -hierarchical *] {
    set cell_name [get_property $cell name]
    set cell_type [get_property $cell ref_name]

    if {[string match "*BUF*" $cell_type]} {
        puts "Buffer found: $cell_name"
    }
}
```

### Itération sur les pins
```tcl
foreach pin [get_pins -of_objects [get_nets $net_name]] {
    set pin_dir [get_property $pin direction]
    if {$pin_dir eq "output"} {
        set driver $pin
    }
}
```

### Rapport personnalisé
```tcl
proc custom_timing_report {filename} {
    set fp [open $filename w]

    puts $fp "========== TIMING SUMMARY =========="
    puts $fp "WNS (Setup): [report_wns]"
    puts $fp "TNS (Setup): [report_tns]"
    puts $fp "WNS (Hold):  [report_wns -path_delay min]"

    puts $fp "\n========== CRITICAL PATHS =========="
    puts $fp [report_checks -path_delay max -slack_max 0 -format full]

    close $fp
}
```

---

## 9. Debugging TCL

### Trace et debug
```tcl
# Afficher les commandes exécutées
proc debug_trace {cmd args} {
    puts "DEBUG: $cmd $args"
}

# Vérifier si variable existe
if {[info exists var]} {
    puts "var = $var"
}

# Lister les procédures
info procs *timing*

# Type d'une variable
info exists var
string is double $value
string is integer $value
```

### Gestion d'erreurs
```tcl
if {[catch {read_verilog $file} err]} {
    puts "ERROR reading $file: $err"
    exit 1
}

# Try-catch moderne
try {
    read_liberty $lib_file
} on error {msg} {
    puts "Failed to read liberty: $msg"
}
```

---

## 10. Questions d'Interview TCL

### Q1: Quelle est la différence entre `set` et `puts`?
**R:** `set` assigne une valeur à une variable, `puts` affiche une chaîne sur stdout.

### Q2: Comment passer une variable par référence?
**R:** Utiliser `upvar` pour créer un alias vers la variable de l'appelant:
```tcl
proc modify {varName} {
    upvar 1 $varName local
    set local "modified"
}
```

### Q3: Différence entre `[list a b c]` et `{a b c}`?
**R:** `{a b c}` est une chaîne littérale sans substitution. `[list a b c]` crée une liste avec substitution des variables.

### Q4: Comment parser un fichier de timing report?
**R:** Utiliser `regexp` pour extraire les valeurs:
```tcl
regexp {Slack\s*:\s*([-\d.]+)} $line match slack
```

### Q5: Comment itérer sur toutes les cellules d'un design?
**R:**
```tcl
foreach_in_collection cell [get_cells -hierarchical *] {
    # Synopsys style
}
# ou
foreach cell [get_cells -hierarchical *] {
    # OpenROAD style
}
```

---

## Ressources

- [TCL Tutorial](https://www.tcl.tk/man/tcl8.6/tutorial/tcltutorial.html)
- [OpenROAD TCL Commands](https://openroad.readthedocs.io/)
- [OpenSTA User Guide](https://github.com/The-OpenROAD-Project/OpenSTA)
