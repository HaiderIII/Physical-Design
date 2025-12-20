# Guide Physical Design - RISC-V ASAP7

## Phase 2 : Synthèse

### Objectif
Transformer le RTL (Verilog) en netlist de portes logiques ASAP7.

### Étapes

**1. Créer le script de synthèse `scripts/01_synthesis.tcl`**

```tcl
# Charger les librairies ASAP7
read_liberty <chemin_vers_lib_asap7>

# Lire le RTL
read_verilog src/*.v

# Définir le top module
hierarchy -top riscv_soc

# Synthèse
synth -top riscv_soc

# Mapping technologique
dfflibmap -liberty <chemin_lib>
abc -liberty <chemin_lib>

# Netlist finale
write_verilog results/riscv_soc_synth.v
```

**2. Trouver les fichiers ASAP7**
```bash
# Librairies Liberty (.lib)
ls ~/OpenROAD-flow-scripts/flow/platforms/asap7/lib/

# Tu cherches un fichier .lib (timing library)
```

**3. Lancer la synthèse**
```bash
cd ~/projects/Physical-Design/riscv-asap7
yosys -c scripts/01_synthesis.tcl
```

**4. Analyser les résultats**
- Nombre de cellules
- Types de cellules utilisées
- Warnings éventuels

---

## Phase 3 : Floorplanning

### Objectif
Définir la taille du die et placer les éléments principaux.

### Étapes

**1. Créer `scripts/02_floorplan.tcl`**

```tcl
# Lire les librairies
read_lef <fichier.lef>
read_liberty <fichier.lib>

# Lire la netlist synthétisée
read_verilog results/riscv_soc_synth.v
link_design riscv_soc

# Lire les contraintes
read_sdc constraints/design.sdc

# Définir le floorplan
# initialize_floorplan -die_area {x1 y1 x2 y2} -core_area {x1 y1 x2 y2}
# OU
# initialize_floorplan -utilization <pourcentage> -aspect_ratio 1.0

# Placer les pins I/O
# place_pins -hor_layers M3 -ver_layers M4

# Créer le power grid
# make_tracks
# pdngen
```

**2. Fichiers nécessaires**
```bash
# LEF (Library Exchange Format) - géométrie des cellules
ls ~/OpenROAD-flow-scripts/flow/platforms/asap7/lef/

# Tu cherches:
# - tech LEF (règles de fabrication)
# - cell LEF (géométrie des standard cells)
```

**3. Lancer dans OpenROAD**
```bash
openroad -gui
# Puis: source scripts/02_floorplan.tcl
```

**4. Vérifier**
- Utilisation cible : 40-70%
- Ratio d'aspect proche de 1.0
- Screenshot dans docs/images/

---

## Phase 4 : Placement

### Objectif
Placer toutes les cellules standard dans le core.

### Commandes clés
```tcl
# Placement global
global_placement

# Légalisation (aligner sur les rows)
detailed_placement

# Vérifier
check_placement
```

### Métriques à surveiller
- **HPWL** (Half-Perimeter Wire Length) - plus bas = mieux
- **Congestion** - éviter les zones rouges

---

## Phase 5 : Clock Tree Synthesis (CTS)

### Objectif
Distribuer le signal d'horloge avec un skew minimal.

### Commandes clés
```tcl
# Configurer le clock tree
set_wire_rc -clock -layer M5

# Construire le clock tree
clock_tree_synthesis -root_buf CLKBUF_X2 -buf_list {CLKBUF_X2 CLKBUF_X4}

# Réparer le timing
repair_clock_nets
```

### Métriques
- **Skew** < 100ps idéalement
- **Insertion delay** raisonnable

---

## Phase 6 : Routing

### Objectif
Connecter toutes les cellules avec des fils métalliques.

### Commandes clés
```tcl
# Routing global
global_route

# Routing détaillé
detailed_route
```

### Problèmes courants
- **DRC violations** : spacing, width, via
- **Antenna violations** : nécessite antenna diodes
- **Congestion** : peut nécessiter de refaire le placement

---

## Phase 7 : Signoff

### Objectif
Vérifier que le design respecte toutes les contraintes.

### Analyses
```tcl
# Timing
report_checks -path_delay min_max

# Power
report_power

# DRC
check_drc
```

### Critères de succès
- **Setup slack** ≥ 0
- **Hold slack** ≥ 0
- **DRC** = 0 violations
- **LVS** clean

---

## Commandes utiles OpenROAD

| Commande | Description |
|----------|-------------|
| `gui::show` | Afficher le GUI |
| `report_design_area` | Surface utilisée |
| `report_checks` | Timing paths |
| `report_clock_skew` | Skew du clock tree |
| `write_def <file>` | Sauvegarder le layout |

---

## Ressources

- **ASAP7 PDK** : `~/OpenROAD-flow-scripts/flow/platforms/asap7/`
- **Exemples** : `~/OpenROAD-flow-scripts/flow/designs/asap7/`
- **Documentation** : https://openroad.readthedocs.io/

---

## Checklist par phase

### Synthèse
- [ ] Script créé
- [ ] Librairies trouvées
- [ ] Netlist générée
- [ ] Stats notées dans README

### Floorplan
- [ ] Die area défini
- [ ] Utilisation correcte
- [ ] Power grid créé
- [ ] Screenshot pris

### Placement
- [ ] Placement terminé
- [ ] Pas de congestion critique
- [ ] Screenshot pris

### CTS
- [ ] Clock tree construit
- [ ] Skew acceptable
- [ ] Screenshot pris

### Routing
- [ ] Routing terminé
- [ ] DRC clean (ou minimal)
- [ ] Screenshot pris

### Signoff
- [ ] Timing clean
- [ ] Power acceptable
- [ ] GDS généré
