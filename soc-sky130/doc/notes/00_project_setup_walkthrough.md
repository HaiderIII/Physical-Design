# Walkthrough Complet — De l'idée au SoC synthétisé

Ce document explique **pas à pas** tout ce qui a été fait pour créer ce projet
de SoC hiérarchique, avec les raisons derrière chaque décision.

---

## Table des matières

1. [Décisions architecturales](#1-décisions-architecturales)
2. [Structure du projet](#2-structure-du-projet)
3. [Le RTL créé](#3-le-rtl-créé)
4. [Les contraintes de timing](#4-les-contraintes-de-timing)
5. [La synthèse par bloc](#5-la-synthèse-par-bloc)
6. [Résumé des fichiers](#6-résumé-des-fichiers)

---

## 1. Décisions architecturales

### Pourquoi un SoC ?

Tu avais déjà un CPU RISC-V fonctionnel dans `riscv-sky130/`. Pour apprendre
la conception **hiérarchique**, il fallait un design avec plusieurs blocs
distincts. Un SoC est parfait car :

- Plusieurs blocs de tailles variées (CPU gros, périphériques petits)
- Interfaces standardisées entre blocs (bus)
- Cas d'usage réaliste (c'est ce qu'on fait en industrie)

### Choix du bus : Wishbone B4

```
Pourquoi Wishbone et pas AXI ou APB ?

┌─────────────────────────────────────────────────────────────┐
│ Wishbone B4                                                  │
├─────────────────────────────────────────────────────────────┤
│ ✓ Open-source, bien documenté                               │
│ ✓ Simple : 1 cycle = 1 transfert (mode classic)             │
│ ✓ Très utilisé avec RISC-V open-source                      │
│ ✓ Facile à implémenter et débugger                          │
│ ✗ Moins performant que AXI (pas de burst, pas de pipeline)  │
└─────────────────────────────────────────────────────────────┘
```

Pour un projet pédagogique, la simplicité prime sur la performance.

### Architecture Harvard vs Von Neumann

```
Von Neumann :                    Harvard :
┌─────┐      ┌──────┐            ┌─────┐      ┌──────┐
│ CPU │─────►│ MEM  │            │ CPU │─────►│ IMEM │  (instructions)
└─────┘      └──────┘            │     │      └──────┘
   │                              │     │      ┌──────┐
   └── 1 seul port mémoire       │     │─────►│ DMEM │  (données)
                                  └─────┘      └──────┘
                                     │
                                     └── 2 ports indépendants
```

Notre SoC utilise **Harvard** :
- IMEM : port direct (le CPU lit une instruction chaque cycle)
- DMEM + périphériques : via le bus Wishbone

**Pourquoi ?** Si IMEM était sur le bus, chaque instruction devrait "attendre"
que le bus soit libre. Avec Harvard, le fetch d'instruction est indépendant
des accès data.

### Memory Map

```
0x0000_0000 ┌─────────────────┐
            │     IMEM        │  4 KB - Instructions (SRAM)
0x0000_0FFF └─────────────────┘
            │    (gap)        │
0x0001_0000 ┌─────────────────┐
            │     DMEM        │  4 KB - Données (SRAM)
0x0001_0FFF └─────────────────┘
            │    (gap)        │
0x1000_0000 ┌─────────────────┐
            │     UART        │  256 B - Communication série
0x1000_00FF └─────────────────┘
0x1000_1000 ┌─────────────────┐
            │     SPI         │  256 B - Interface SPI
0x1000_10FF └─────────────────┘
0x1000_2000 ┌─────────────────┐
            │     Timer       │  256 B - Compteur/Timer
0x1000_20FF └─────────────────┘
0x1000_3000 ┌─────────────────┐
            │     GPIO        │  256 B - Entrées/Sorties
0x1000_30FF └─────────────────┘
```

**Logique du choix** :
- IMEM à 0x0 : c'est où le CPU démarre (PC = 0 au reset)
- DMEM à 0x1_0000 : séparé de IMEM, facile à décoder
- Périphériques à 0x1000_xxxx : espace I/O distinct, facile à décoder

---

## 2. Structure du projet

### Organisation des dossiers

```
soc-sky130/
│
├── rtl/                         # Code source Verilog
│   ├── core/                    # CPU et ses sous-modules
│   ├── peripherals/             # UART, SPI, Timer, GPIO
│   │   ├── uart_wb/
│   │   ├── spi_wb/
│   │   ├── timer_wb/
│   │   └── gpio_wb/
│   ├── bus/                     # Interconnect Wishbone
│   └── soc_top.v               # Top-level
│
├── constraints/                 # Fichiers SDC (timing)
│   ├── soc_top.sdc             # Contraintes top-level
│   └── blocks/                  # Contraintes par bloc
│
├── scripts/                     # Scripts d'automatisation
│   ├── block_level/            # Synthèse/P&R par bloc
│   └── top_level/              # P&R top-level (à venir)
│
├── blocks/                      # Résultats par bloc
│   ├── cpu/results/
│   ├── uart/results/
│   └── ...
│
├── results/                     # Résultats top-level
│
└── doc/                         # Documentation
    ├── architecture.md
    └── notes/
```

**Pourquoi cette structure ?**

1. **Séparation RTL/scripts/résultats** : le code source ne se mélange pas
   avec les fichiers générés

2. **Un dossier par bloc** : facilite le travail en parallèle et la navigation

3. **Contraintes séparées** : chaque bloc a ses propres contraintes SDC

---

## 3. Le RTL créé

### 3.1 Le wrapper CPU (`cpu_wb_wrapper.v`)

Le CPU existant (`riscv_core.v`) avait une interface mémoire "maison" :

```verilog
// Interface originale du CPU
output [31:0] dmem_addr,
output [31:0] dmem_wdata,
output [3:0]  dmem_be,      // Byte enables
output        dmem_we,
output        dmem_re,
input  [31:0] dmem_rdata
```

Il fallait la convertir en Wishbone :

```verilog
// Interface Wishbone B4
output [31:0] wb_adr_o,     // Adresse
output [31:0] wb_dat_o,     // Write data
input  [31:0] wb_dat_i,     // Read data
output [3:0]  wb_sel_o,     // Byte select (= byte enables)
output        wb_we_o,      // Write enable
output        wb_stb_o,     // Strobe (transfert valide)
output        wb_cyc_o,     // Cycle actif
input         wb_ack_i      // Acknowledge
```

**Le wrapper fait le mapping** :

```verilog
// cpu_wb_wrapper.v - lignes clés

// Le CPU est instancié à l'intérieur
riscv_core u_riscv_core (
    .dmem_addr  (dmem_addr),
    .dmem_wdata (dmem_wdata),
    ...
);

// Conversion vers Wishbone (très simple dans notre cas)
assign wb_adr_o = dmem_addr;
assign wb_dat_o = dmem_wdata;
assign wb_sel_o = dmem_be;       // Même sémantique
assign wb_we_o  = dmem_we;
assign wb_stb_o = dmem_we | dmem_re;  // Strobe quand accès
assign wb_cyc_o = dmem_we | dmem_re;  // Cycle = strobe (pas de burst)
assign dmem_rdata = wb_dat_i;
```

### 3.2 L'interconnect Wishbone (`wb_interconnect.v`)

C'est le "routeur" du bus. Il fait deux choses :

**1. Décodage d'adresses** (vers quel esclave ?)

```verilog
// Logique de sélection basée sur les bits hauts de l'adresse
wire sel_dmem  = (m_wb_adr_i[31:16] == 16'h0001);  // 0x0001_xxxx
wire sel_uart  = (m_wb_adr_i[31:12] == 20'h10000); // 0x1000_0xxx
wire sel_spi   = (m_wb_adr_i[31:12] == 20'h10001); // 0x1000_1xxx
wire sel_timer = (m_wb_adr_i[31:12] == 20'h10002); // 0x1000_2xxx
wire sel_gpio  = (m_wb_adr_i[31:12] == 20'h10003); // 0x1000_3xxx
```

**2. Multiplexage des données de retour**

```verilog
// Quel esclave répond ? Multiplexer ses données
always @(*) begin
    case (1'b1)
        sel_dmem:  rdata_mux = s0_wb_dat_i;  // Données du DMEM
        sel_uart:  rdata_mux = s1_wb_dat_i;  // Données de l'UART
        sel_spi:   rdata_mux = s2_wb_dat_i;
        sel_timer: rdata_mux = s3_wb_dat_i;
        sel_gpio:  rdata_mux = s4_wb_dat_i;
        default:   rdata_mux = 32'hDEAD_BEEF;  // Erreur bus
    endcase
end
```

### 3.3 Les périphériques

Chaque périphérique suit le même pattern :

```verilog
module peripheral_wb (
    // Interface Wishbone esclave
    input  wire        wb_clk_i,
    input  wire        wb_rst_i,
    input  wire [31:0] wb_adr_i,
    input  wire [31:0] wb_dat_i,
    output reg  [31:0] wb_dat_o,
    input  wire [3:0]  wb_sel_i,
    input  wire        wb_we_i,
    input  wire        wb_stb_i,
    input  wire        wb_cyc_i,
    output wire        wb_ack_o,

    // Signaux spécifiques au périphérique
    ...
);
    // 1. Handshake Wishbone (ACK après 1 cycle)
    reg ack_r;
    assign wb_ack_o = ack_r;
    always @(posedge wb_clk_i) begin
        if (wb_rst_i)
            ack_r <= 1'b0;
        else
            ack_r <= wb_stb_i & wb_cyc_i & ~ack_r;
    end

    // 2. Registres internes
    reg [31:0] reg_ctrl;
    reg [31:0] reg_data;
    ...

    // 3. Logique d'écriture
    always @(posedge wb_clk_i) begin
        if (wb_valid && wb_we_i) begin
            case (wb_adr_i[4:2])  // Offset / 4
                3'd0: reg_ctrl <= wb_dat_i;
                3'd1: reg_data <= wb_dat_i;
                ...
            endcase
        end
    end

    // 4. Logique de lecture (mux)
    always @(*) begin
        case (wb_adr_i[4:2])
            3'd0: wb_dat_o = reg_ctrl;
            3'd1: wb_dat_o = reg_data;
            ...
        endcase
    end
endmodule
```

### 3.4 Le top-level (`soc_top.v`)

C'est le fichier qui **assemble tout** :

```verilog
module soc_top (
    input  wire        clk,
    input  wire        rst_n,
    // Interfaces externes
    output wire        uart_tx,
    input  wire        uart_rx,
    ...
);
    // Signaux internes pour le bus
    wire [31:0] cpu_wb_adr, cpu_wb_dat_w, cpu_wb_dat_r;
    ...

    // Instanciation du CPU
    cpu_wb_wrapper u_cpu (
        .clk        (clk),
        .rst_n      (rst_n),
        .imem_addr  (imem_addr),
        .imem_rdata (imem_rdata),
        .wb_adr_o   (cpu_wb_adr),
        ...
    );

    // Instanciation de l'IMEM (port direct)
    sram_wrapper_4kb u_imem (...);

    // Instanciation du bus
    wb_interconnect u_wb_bus (...);

    // Instanciation des esclaves
    dmem_wb_wrapper u_dmem (...);
    uart_wb u_uart (...);
    spi_wb u_spi (...);
    timer_wb u_timer (...);
    gpio_wb u_gpio (...);
endmodule
```

---

## 4. Les contraintes de timing

### Pourquoi des contraintes par bloc ?

En conception hiérarchique, chaque bloc est implémenté **séparément**.
L'outil P&R ne connaît pas le contexte du top-level. Il faut donc lui dire :

> "Les signaux qui arrivent sur ce port viennent d'un autre bloc.
> Ils arrivent X ns après le front d'horloge."

### Structure d'un fichier SDC

```tcl
# === cpu.sdc ===

# 1. Définir l'horloge
create_clock -name clk -period 10.0 [get_ports clk]

# 2. Incertitude (jitter + skew)
set_clock_uncertainty 0.5 [get_clocks clk]

# 3. Input delays : quand les données ARRIVENT
#    "Les données du bus arrivent 3 ns après le front d'horloge"
set_input_delay -clock clk 3.0 [get_ports wb_dat_i[*]]
set_input_delay -clock clk 3.0 [get_ports wb_ack_i]

# 4. Output delays : quand les données doivent PARTIR
#    "Les sorties doivent être stables 3 ns après le front"
#    (équivalent : 7 ns de budget pour la logique interne)
set_output_delay -clock clk 3.0 [get_ports wb_adr_o[*]]
set_output_delay -clock clk 3.0 [get_ports wb_dat_o[*]]
```

### Le timing budget expliqué

```
Période = 10 ns

Chemin : CPU_FF → logique CPU → wb_adr_o → bus → wb_adr_i → logique UART → UART_FF
         └────────────────────┘           └───────────────────────────────┘
              Budget CPU : 7 ns              Budget UART : 7 ns

Comment ?
- output_delay = 3 ns signifie "la sortie doit être prête 3 ns AVANT la fin"
  → le CPU a 10 - 3 = 7 ns pour produire sa sortie

- input_delay = 3 ns signifie "l'entrée arrive 3 ns APRÈS le début"
  → l'UART a 10 - 3 = 7 ns pour traiter l'entrée

Le bus prend ~0 ns (fils directs), absorbé dans la marge.
```

---

## 5. La synthèse par bloc

### Le script `run_synth.sh`

C'est un script **paramétrique** : un seul script pour tous les blocs.

```bash
./scripts/block_level/run_synth.sh cpu    # Synthétise le CPU
./scripts/block_level/run_synth.sh uart   # Synthétise l'UART
./scripts/block_level/run_synth.sh all    # Synthétise tout
```

### Comment ça marche ?

1. **Génère un script Yosys** spécifique au bloc demandé
2. **Lance Yosys** avec ce script
3. **Produit** : netlist + statistiques + log

### Le flow Yosys expliqué

```
┌─────────────────────────────────────────────────────────────┐
│  read_liberty -lib sky130.lib                               │
│  ↓                                                          │
│  Charge la bibliothèque de cellules (portes logiques,       │
│  flip-flops, etc.) avec leurs caractéristiques (délai,      │
│  surface, puissance)                                        │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  read_verilog -sv module.v                                  │
│  ↓                                                          │
│  Parse le RTL et crée une représentation interne            │
│  (AST → RTLIL)                                              │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  hierarchy -check -top module_name                          │
│  ↓                                                          │
│  Analyse la hiérarchie, vérifie que tous les modules        │
│  sont définis, établit "module_name" comme top              │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  synth -top module_name                                     │
│  ↓                                                          │
│  Synthèse générique :                                       │
│  - proc : convertit les always en logique                   │
│  - fsm  : optimise les machines d'état                      │
│  - opt  : optimisations logiques                            │
│  - memory : infère les mémoires                             │
│  - techmap : mapping vers primitives génériques             │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  dfflibmap -liberty sky130.lib                              │
│  ↓                                                          │
│  Mappe les flip-flops génériques vers les cellules          │
│  Sky130 (ex: sky130_fd_sc_hd__dfrtp_1)                      │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  abc -liberty sky130.lib                                    │
│  ↓                                                          │
│  ABC = outil d'optimisation logique                         │
│  Mappe la logique combinatoire vers les cellules Sky130     │
│  (AND, OR, MUX, etc.) en optimisant surface/délai           │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│  write_verilog -noattr output.v                             │
│  ↓                                                          │
│  Écrit la netlist gate-level :                              │
│  - Plus de "always", "if", "case"                           │
│  - Que des instances de cellules Sky130                     │
│  - -noattr : sans les attributs Yosys (plus lisible)        │
└─────────────────────────────────────────────────────────────┘
```

### Exemple : avant/après synthèse

**Avant (RTL)** :
```verilog
always @(posedge clk)
    if (!rst_n)
        count <= 0;
    else if (enable)
        count <= count + 1;
```

**Après (netlist)** :
```verilog
sky130_fd_sc_hd__dfrtp_1 count_reg_0 (
    .CLK(clk),
    .RESET_B(rst_n),
    .D(next_count_0),
    .Q(count[0])
);

sky130_fd_sc_hd__fa_1 adder_0 (
    .A(count[0]),
    .B(1'b1),
    .CIN(1'b0),
    .SUM(sum_0),
    .COUT(carry_0)
);

sky130_fd_sc_hd__mux2_1 mux_0 (
    .A0(count[0]),
    .A1(sum_0),
    .S(enable),
    .X(next_count_0)
);
// ... etc pour chaque bit
```

---

## 6. Résumé des fichiers

### Fichiers créés manuellement (RTL)

| Fichier | Lignes | Rôle |
|---------|--------|------|
| `soc_top.v` | 250 | Top-level SoC |
| `cpu_wb_wrapper.v` | 80 | Wrapper CPU → Wishbone |
| `wb_interconnect.v` | 180 | Bus décodeur + mux |
| `dmem_wb_wrapper.v` | 45 | SRAM wrapper Wishbone |
| `uart_wb.v` | 190 | UART TX/RX |
| `spi_wb.v` | 180 | SPI master |
| `timer_wb.v` | 130 | Timer 32-bit |
| `gpio_wb.v` | 120 | GPIO 32-bit |

### Fichiers copiés (CPU existant)

Les 10 fichiers du CPU ont été copiés depuis `riscv-sky130/src/` vers
`soc-sky130/rtl/core/`. Ils n'ont pas été modifiés.

### Fichiers générés (synthèse)

| Fichier | Taille | Contenu |
|---------|--------|---------|
| `*_synth.v` | 30KB-1MB | Netlist gate-level |
| `*_stats.txt` | 5KB | Statistiques (aires, cellules) |
| `*.log` | 50KB | Log complet Yosys |

### Scripts

| Fichier | Rôle |
|---------|------|
| `run_synth.sh` | Lance la synthèse d'un bloc |
| `synth_*.ys` | Script Yosys généré (1 par bloc) |

---

## Prochaines étapes

1. **Phase 2** : P&R bloc par bloc (floorplan → CTS → routing)
2. **Phase 3** : Génération des abstracts LEF
3. **Phase 4-7** : Intégration top-level
4. **Phase 8** : Signoff et GDSII

Chaque phase aura sa propre note explicative.
