# Phase 1 — Synthèse par Bloc

## Objectifs de cette phase

1. Synthétiser chaque bloc **indépendamment**
2. Comprendre le **timing budget** aux frontières
3. Analyser les métriques de chaque bloc
4. Préparer les netlists pour le P&R hiérarchique

## Résultats de synthèse

### Tableau récapitulatif

| Bloc   | Module            | Aire (µm²) | % du SoC | Description                     |
|--------|-------------------|------------|----------|----------------------------------|
| CPU    | cpu_wb_wrapper    | 80,961     | 78.1%    | Pipeline 5 étages + LSU         |
| GPIO   | gpio_wb           | 7,953      | 7.7%     | 32 bits I/O + IRQ               |
| Timer  | timer_wb          | 5,011      | 4.8%     | 32-bit + prescaler              |
| UART   | uart_wb           | 4,160      | 4.0%     | TX/RX + diviseur                |
| SPI    | spi_wb            | 2,432      | 2.3%     | Master CPOL/CPHA                |
| Bus    | wb_interconnect   | 1,305      | 1.3%     | Décodeur + mux                  |
| DMEM   | dmem_wb_wrapper   | 958        | 0.9%     | Wrapper SRAM (sans macro)       |
| **Total** |                | **102,780** | 100%    | *Sans les SRAM macros*          |

**Note** : Les 2 SRAM macros (IMEM + DMEM) ajoutent environ **150,000 µm²** chacune,
soit ~300,000 µm² supplémentaires. Le SoC total fait environ **400,000 µm² (0.4 mm²)**.

### Observations

1. **Le CPU domine** : 78% de la logique totale — normal pour un pipeline 5 étages
   avec register file, ALU, hazard unit, etc.

2. **GPIO relativement grand** : 32 bits × (sync + IRQ detection + output reg)
   → beaucoup de flip-flops

3. **Bus minimal** : Le décodeur d'adresses est purement combinatoire, très petit

4. **DMEM wrapper petit** : Toute la complexité est dans le macro SRAM

## Script de synthèse

Le script `run_synth.sh` utilise Yosys avec le flow suivant :

```
RTL (Verilog)
    │
    ▼
read_liberty     ← Charger la bibliothèque Sky130
    │
    ▼
read_verilog     ← Charger le RTL du bloc
    │
    ▼
hierarchy        ← Élaborer la hiérarchie
    │
    ▼
synth            ← Synthèse générique (opt, fsm, memory, techmap)
    │
    ▼
dfflibmap        ← Mapper les flip-flops sur les cellules Sky130
    │
    ▼
abc              ← Mapper la logique combinatoire (optimisation)
    │
    ▼
write_verilog    ← Netlist gate-level
```

### Commandes clés Yosys

```tcl
# Charger la bibliothèque de cellules (Liberty format)
read_liberty -lib sky130_fd_sc_hd__tt_025C_1v80.lib

# Charger le RTL (SystemVerilog)
read_verilog -sv module.v

# Élaborer et vérifier la hiérarchie
hierarchy -check -top module_name

# Blackboxer un macro (SRAM)
setattr -mod -set blackbox 1 sky130_sram_1rw1r_128x256_8

# Synthèse complète
synth -top module_name

# Mapping technologique
dfflibmap -liberty sky130.lib    # Flip-flops
abc -liberty sky130.lib          # Logique combinatoire

# Statistiques avec estimation d'aire
stat -liberty sky130.lib

# Écrire la netlist (sans attributs pour lisibilité)
write_verilog -noattr output.v
```

## Timing Budget — Concept clé

### Le problème

Comment garantir que les chemins **inter-blocs** seront corrects au top-level ?

```
         Bloc A              Bloc B
    ┌──────────────┐    ┌──────────────┐
    │   FF ─►──────│───►│──────► FF    │
    │              │    │              │
    │   7 ns       │ ?  │   ? ns       │
    └──────────────┘    └──────────────┘

Si Bloc A utilise 7 ns et la période est 10 ns,
Bloc B n'a que 3 ns (moins setup time, uncertainty)
→ Bloc B doit être contraint en conséquence
```

### La solution : Input/Output Delays

Dans les contraintes SDC de chaque bloc :

```tcl
# cpu.sdc — contraintes du CPU
create_clock -name clk -period 10.0 [get_ports clk]

# Budget accordé au CPU pour piloter le bus : 3 ns après le clock
set_output_delay -clock clk 3.0 [get_ports wb_adr_o[*]]
set_output_delay -clock clk 3.0 [get_ports wb_dat_o[*]]
set_output_delay -clock clk 3.0 [get_ports wb_stb_o]
# ...

# Budget accordé au bus + esclave pour répondre : données arrivent 3 ns avant le clock
set_input_delay -clock clk 3.0 [get_ports wb_dat_i[*]]
set_input_delay -clock clk 3.0 [get_ports wb_ack_i]
```

### Budget de notre SoC

```
Période totale : 10 ns (100 MHz)

     CPU output    Bus    Slave input   Slave output   Bus    CPU input
    ├─── 3 ns ───┤─1ns─┤─── 3 ns ───┤─── 1 ns ───┤─1ns─┤── 1 ns ──┤

    Contraintes :
    - CPU:   output_delay = 3 ns, input_delay = 3 ns (7 ns restants)
    - Slave: input_delay = 3 ns, output_delay = 3 ns (4 ns pour logique interne)
    - Marge: ~1 ns pour clock uncertainty + setup
```

## Structure des fichiers générés

```
soc-sky130/
├── blocks/
│   ├── cpu/results/
│   │   ├── synth_cpu.ys           # Script Yosys généré
│   │   ├── synth_cpu.log          # Log complet
│   │   ├── cpu_wb_wrapper_synth.v # Netlist gate-level
│   │   └── cpu_wb_wrapper_stats.txt
│   ├── uart/results/
│   │   ├── uart_wb_synth.v
│   │   └── uart_wb_stats.txt
│   ├── spi/results/
│   ├── timer/results/
│   ├── gpio/results/
│   ├── bus/results/
│   └── dmem/results/
└── results/
    ├── soc_top_synth.v           # Netlist top-level complet
    └── soc_top_stats.txt
```

## Exercices de compréhension

### Quiz 1 : Pourquoi synthétiser par bloc ?

**Q** : On pourrait synthétiser le SoC entier d'un coup. Pourquoi se compliquer
avec la synthèse par bloc ?

**R** :
1. **Parallélisation** : Plusieurs ingénieurs peuvent travailler en parallèle
2. **Itération rapide** : Modifier un bloc ne resynthétise que ce bloc
3. **Timing closure plus facile** : Contraintes claires aux frontières
4. **Réutilisation** : Un bloc validé peut être réutilisé dans d'autres projets

### Quiz 2 : L'aire DMEM est suspicieuse

**Q** : Le DMEM fait seulement 958 µm², mais il contient un SRAM de 4KB. Pourquoi ?

**R** : Le macro SRAM est **blackboxé** (`setattr -set blackbox 1`). Yosys ne
synthétise pas l'intérieur du macro — il le traite comme une boîte noire.
Les 958 µm² représentent uniquement :
- Le wrapper (dmem_wb_wrapper)
- Le word selector (sram_wrapper_4kb)
- La logique de write mask

L'aire réelle du macro SRAM (~150,000 µm²) sera ajoutée lors du floorplanning.

### Quiz 3 : Que se passe-t-il si le timing budget est mal réparti ?

**Q** : Imaginons qu'on donne 8 ns au CPU et 2 ns aux esclaves. Problème ?

**R** :
- Le CPU optimisera ses sorties pour arriver 8 ns après le clock
- Les esclaves n'auront que 2 ns pour traiter l'accès et répondre
- Le timing des esclaves ne fermera probablement pas
- Au top-level, les chemins CPU→slave→CPU auront des violations
- Il faudra re-synthétiser avec un budget corrigé

**Règle** : Le timing budget doit être réaliste et respecté par tous les blocs.

## Commandes utiles

```bash
# Synthétiser un seul bloc
./scripts/block_level/run_synth.sh cpu

# Synthétiser tous les blocs
./scripts/block_level/run_synth.sh all

# Synthétiser le top-level complet
./scripts/block_level/run_synth.sh top

# Voir le résumé des aires
for f in blocks/*/results/*_stats.txt; do
  grep "Chip area for top module" "$f"
done
```

## Prochaine étape

**Phase 2** : Physical Design par bloc
- Floorplan, placement, CTS, routage pour chaque bloc
- Génération des vues abstraites (LEF)
- Validation DRC/timing bloc par bloc
