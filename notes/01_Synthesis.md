# Phase 1: Synthesis (Synthèse Logique)

## Vue d'Ensemble

La synthèse transforme le code RTL (Verilog/VHDL) en une **netlist gate-level** utilisant les cellules de la librairie standard du PDK cible.

```
RTL (Verilog) → [Synthesis] → Gate-level Netlist
```

---

## 1. Étapes de la Synthèse

### 1.1 Elaboration (Parsing)
- Lecture et analyse syntaxique du RTL
- Construction de l'arbre syntaxique abstrait (AST)
- Vérification des erreurs de syntaxe

### 1.2 High-Level Synthesis
- **proc**: Conversion des process/always blocks en logique
- **opt**: Optimisations logiques de haut niveau
- **fsm**: Détection et optimisation des machines à états
- **memory**: Inférence des mémoires (RAM/ROM)

### 1.3 Technology Mapping
- **dfflibmap**: Mapping des flip-flops vers les cellules de la librairie
- **abc**: Mapping combinatoire avec optimisation timing/area
- Sélection des cellules selon les contraintes

### 1.4 Post-Processing
- **hilomap**: Insertion des cellules tie-high/tie-low
- **insbuf**: Insertion de buffers
- **clean**: Nettoyage de la netlist

---

## 2. Outils et Flow

### Yosys (Open Source)
```bash
# Commande de base
yosys -c synthesis.ys
```

### Script Yosys typique (.ys)
```tcl
# 1. Lecture du RTL
read_verilog -sv rtl/alu_8bit.v
read_verilog -sv rtl/register_file.v

# 2. Élaboration
hierarchy -check -top top_module

# 3. Synthèse high-level
proc; opt
fsm; opt
memory -nomap; opt

# 4. Mapping technologique
# Mapping des flip-flops
dfflibmap -liberty $::env(LIB_FILE)

# Mapping combinatoire avec ABC
abc -liberty $::env(LIB_FILE) \
    -constr $::env(SDC_FILE) \
    -D [expr $::env(CLOCK_PERIOD) * 1000]  ;# en ps

# 5. Post-processing
hilomap -hicell {TIE_HI Y} -locell {TIE_LO Y}
insbuf -buf {BUF X} A Y
opt_clean -purge

# 6. Vérifications
check
stat -liberty $::env(LIB_FILE)

# 7. Export
write_verilog -noattr -noexpr -nohex netlist/design_synth.v
```

---

## 3. Fichiers d'Entrée

### 3.1 RTL (Verilog)
```verilog
module alu_8bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  a, b,
    input  wire [2:0]  op,
    output reg  [7:0]  result,
    output reg         zero, carry, overflow
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            result <= 8'b0;
        else
            case (op)
                3'b000: result <= a + b;
                3'b001: result <= a - b;
                // ...
            endcase
    end
endmodule
```

### 3.2 Liberty (.lib)
Fichier décrivant les cellules standard:
- Timing arcs (delays, transitions)
- Power consumption
- Capacitances (input/output)
- Fonctions logiques

```
cell (AND2_X1) {
    area : 1.064;
    pin (A1) {
        direction : input;
        capacitance : 0.001;
    }
    pin (ZN) {
        direction : output;
        function : "(A1 & A2)";
        timing() {
            cell_rise (delay_template) { values(...) }
            cell_fall (delay_template) { values(...) }
        }
    }
}
```

### 3.3 SDC (Synopsys Design Constraints)
```tcl
# Définition de l'horloge
create_clock -name clk -period 10.0 [get_ports clk]
set_clock_uncertainty 0.1 [get_clocks clk]

# Input/Output delays
set_input_delay -clock clk 2.0 [all_inputs]
set_output_delay -clock clk 2.0 [all_outputs]

# Driving cell et load
set_driving_cell -lib_cell BUF_X2 [all_inputs]
set_load 0.01 [all_outputs]

# False paths (si applicable)
set_false_path -from [get_ports rst_n]
```

---

## 4. Fichiers de Sortie

### 4.1 Netlist Gate-Level
```verilog
module alu_8bit (clk, rst_n, a, b, op, result, zero, carry, overflow);
    input clk, rst_n;
    input [7:0] a, b;
    input [2:0] op;
    output [7:0] result;
    output zero, carry, overflow;

    wire n1, n2, n3, ...;

    DFF_X1 result_reg_0 (.D(n1), .CK(clk), .Q(result[0]));
    AND2_X1 U1 (.A1(a[0]), .A2(b[0]), .ZN(n1));
    // ... milliers de cellules
endmodule
```

### 4.2 Rapport de Synthèse
```
=== design_top ===

   Number of wires:              12543
   Number of wire bits:          45678
   Number of public wires:        1234
   Number of cells:               9804
     DFF_X1                       2048
     AND2_X1                       856
     OR2_X1                        743
     INV_X1                       1523
     ...

   Estimated chip area:        81234.56 µm²
```

---

## 5. Optimisations de Synthèse

### 5.1 Optimisation par Contrainte

| Objectif | Stratégie | Impact |
|----------|-----------|--------|
| **Area** | Partage de ressources, réduction logique | ↓ Power, ↑ Delay |
| **Speed** | Duplication, parallel paths | ↑ Area, ↑ Power |
| **Power** | Clock gating, operand isolation | ↑ Area, variable timing |

### 5.2 Options ABC
```tcl
# Optimisation area
abc -liberty $lib -script "+strash;fraig;refactor"

# Optimisation timing
abc -liberty $lib -D 10000 -script "+strash;dc2;map"

# Balanced
abc -liberty $lib -script "+strash;dc2;fraig;rewrite;balance;map"
```

### 5.3 Multi-Vt Synthesis
Les PDKs avancés offrent plusieurs types de transistors:
- **HVT** (High-Vt): Faible leakage, plus lent
- **RVT** (Regular-Vt): Balance
- **LVT** (Low-Vt): Rapide, high leakage
- **SLVT** (Super Low-Vt): Très rapide, très high leakage

```tcl
# Synthèse avec multi-Vt (ASAP7)
read_liberty asap7_rvt.lib
read_liberty asap7_lvt.lib
read_liberty asap7_slvt.lib

abc -liberty asap7_rvt.lib  ;# Utiliser RVT par défaut
# L'outil de timing choisira LVT/SLVT pour les chemins critiques
```

---

## 6. Multi-Corner Synthesis

### Corners PVT (Process, Voltage, Temperature)

| Corner | Process | Voltage | Temp | Usage |
|--------|---------|---------|------|-------|
| **SS** (Slow-Slow) | Slow | Low (0.95V) | Hot (125°C) | Setup check |
| **TT** (Typical) | Typical | Nom (1.0V) | 25°C | Design target |
| **FF** (Fast-Fast) | Fast | High (1.1V) | Cold (-40°C) | Hold check |

### Script multi-corner
```tcl
# Charger toutes les librairies
read_liberty -corner slow sky130_fd_sc_hd__ss_100C_1v60.lib
read_liberty -corner typical sky130_fd_sc_hd__tt_025C_1v80.lib
read_liberty -corner fast sky130_fd_sc_hd__ff_n40C_1v95.lib

# Synthèse visant le corner slow (pire cas setup)
abc -liberty sky130_fd_sc_hd__ss_100C_1v60.lib -D $period
```

---

## 7. Inférence de Mémoires

### 7.1 RAM Inférée
```verilog
// RTL style pour inférence RAM
reg [31:0] memory [0:1023];

always @(posedge clk) begin
    if (we)
        memory[addr] <= din;
    dout <= memory[addr];
end
```

### 7.2 Options Yosys
```tcl
# Garder les mémoires comme arrays (pour macro SRAM)
memory -nomap

# Convertir en flip-flops (si pas de macro disponible)
memory_map
```

### 7.3 SRAM Macros vs Flip-Flops

| Approche | Avantages | Inconvénients |
|----------|-----------|---------------|
| **SRAM Macro** | Dense, faible power | Nécessite macro, timing complexe |
| **Flip-Flops** | Flexible, simple | Grande area, high power |

---

## 8. Vérification Post-Synthèse

### 8.1 Formal Verification (LEC)
Vérifier l'équivalence logique RTL ↔ Netlist:
```bash
# Avec Yosys
yosys -p "read_verilog rtl.v; rename top gold"
yosys -p "read_verilog netlist.v; rename top gate"
yosys -p "equiv_make gold gate equiv; equiv_simple; equiv_status"
```

### 8.2 Simulation Post-Synthèse
```bash
# Inclure les modèles de timing
iverilog -o sim -s testbench \
    -DPOST_SYNTH \
    netlist.v \
    cells_sim.v \
    testbench.v
vvp sim
```

---

## 9. Métriques Clés

### 9.1 Rapport de cellules
```
Cell Type        Count    Area (µm²)
-----------------------------------------
DFF_X1           2048     4096.0
AND2_X1           856      912.3
NAND2_X1          643      685.4
...
-----------------------------------------
TOTAL            9804    81234.5
```

### 9.2 Slack estimé
```
Timing estimate (pre-layout):
  Clock period: 10.0 ns
  Estimated WNS: -0.5 ns (VIOLATED)
  Critical path: data_in → ALU → result_reg
```

---

## 10. Questions d'Interview - Synthèse

### Q1: Quelle est la différence entre synthèse logique et synthèse physique?
**R:** La synthèse **logique** convertit RTL en netlist gate-level sans considération de placement. La synthèse **physique** intègre les informations de placement/routage pour des optimisations timing-aware plus précises.

### Q2: Comment le timing est-il optimisé pendant la synthèse?
**R:** L'outil utilise:
1. Les delay models des cellules (.lib)
2. Les contraintes SDC (clock period, I/O delays)
3. Les estimations de wire delay (pré-layout)
4. Restructuration logique (retiming, buffer insertion)

### Q3: Qu'est-ce que le technology mapping?
**R:** C'est la conversion de la représentation logique abstraite (AND, OR, NOT) vers des cellules physiques spécifiques de la librairie standard (NAND2_X1, NOR3_X2, etc.), en optimisant area/timing/power.

### Q4: Comment gérer les chemins multi-cycle?
**R:** Utiliser `set_multicycle_path` dans les contraintes SDC:
```tcl
set_multicycle_path 2 -setup -from [get_pins mul/Q] -to [get_pins acc/D]
set_multicycle_path 1 -hold -from [get_pins mul/Q] -to [get_pins acc/D]
```

### Q5: Pourquoi utiliser des cellules multi-Vt?
**R:** Pour optimiser le compromis power/performance:
- **HVT** sur chemins non-critiques → réduire le leakage
- **LVT/SLVT** sur chemins critiques → améliorer le timing
- Typiquement 70% HVT, 20% RVT, 10% LVT dans un design power-efficient

### Q6: Comment réduire le design area?
**R:**
1. Partage de ressources (resource sharing)
2. Réduction logique (constant propagation, dead code elimination)
3. Utiliser des cellules plus petites (X1 vs X2)
4. Éviter la duplication de logique
5. Clock gating pour réduire les registres actifs

### Q7: Qu'est-ce que la "dont_touch" constraint?
**R:** Elle empêche l'outil d'optimiser certaines cellules/nets:
```tcl
set_dont_touch [get_cells scan_chain*]
set_dont_touch [get_nets critical_net]
```
Utilisée pour préserver des structures spécifiques (scan chains, debug logic).

---

## Commandes Essentielles

```tcl
# Yosys
read_verilog design.v
hierarchy -check -top top
proc; opt; fsm; opt
memory -nomap; opt
dfflibmap -liberty $lib
abc -liberty $lib -D $period_ps
write_verilog netlist.v
stat -liberty $lib

# Vérification
check
stat
show  # Visualisation graphique
```

---

## Ressources

- [Yosys Manual](https://yosyshq.readthedocs.io/)
- [ABC User Guide](https://people.eecs.berkeley.edu/~alanmi/abc/)
- [Liberty Format Specification](https://www.opensourceliberty.org/)
