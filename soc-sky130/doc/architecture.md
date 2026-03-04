# Architecture du SoC RISC-V — Sky130

## Vue d'ensemble

SoC basé sur un processeur RISC-V RV32I pipeline 5 étages, avec bus Wishbone B4
et périphériques intégrés. Ciblé pour le PDK Sky130 (130nm) @ 100 MHz.

## Diagramme de blocs

```
┌──────────────────────────────────────────────────────────────────┐
│                          soc_top                                 │
│                                                                  │
│  ┌─────────────┐        ┌──────────────┐                        │
│  │   IMEM      │◄──────►│  CPU         │                        │
│  │  SRAM 4KB   │  direct│  RISC-V      │                        │
│  │  (macro)    │  port  │  RV32I       │                        │
│  └─────────────┘        │  5-stage     │                        │
│                         │  pipeline    │                        │
│                         └──────┬───────┘                        │
│                                │ Wishbone Master                │
│                                ▼                                │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │              Wishbone B4 Interconnect                    │    │
│  │         (address decoder + read data mux)                │    │
│  └──┬──────────┬──────────┬──────────┬──────────┬──────────┘    │
│     │          │          │          │          │               │
│     ▼          ▼          ▼          ▼          ▼               │
│  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐            │
│  │ DMEM │  │ UART │  │ SPI  │  │Timer │  │ GPIO │            │
│  │ SRAM │  │      │  │Master│  │      │  │      │            │
│  │ 4KB  │  │      │  │      │  │      │  │      │            │
│  │(macro)│  │      │  │      │  │      │  │      │            │
│  └──────┘  └──┬───┘  └──┬───┘  └──────┘  └──┬───┘            │
│               │         │                    │                 │
│              TX/RX    SCLK/MOSI           IN/OUT/OE            │
│                       MISO/CS_N                                │
└──────────────────────────────────────────────────────────────────┘
```

## Memory Map

| Adresse début  | Adresse fin    | Taille | Périphérique | Accès   |
|----------------|----------------|--------|-------------|---------|
| `0x0000_0000`  | `0x0000_0FFF`  | 4 KB   | IMEM (SRAM) | R       |
| `0x0001_0000`  | `0x0001_0FFF`  | 4 KB   | DMEM (SRAM) | R/W     |
| `0x1000_0000`  | `0x1000_00FF`  | 256 B  | UART        | R/W     |
| `0x1000_1000`  | `0x1000_10FF`  | 256 B  | SPI         | R/W     |
| `0x1000_2000`  | `0x1000_20FF`  | 256 B  | Timer       | R/W     |
| `0x1000_3000`  | `0x1000_30FF`  | 256 B  | GPIO        | R/W     |

## Bus Wishbone B4

### Protocole

Le bus utilise le protocole Wishbone B4 en mode **classic** (single-cycle ACK) :

```
         ┌───┐   ┌───┐   ┌───┐   ┌───┐
CLK      │   │   │   │   │   │   │   │
     ────┘   └───┘   └───┘   └───┘   └──

         ┌───────────────┐
CYC  ────┘               └──────────────
         ┌───────────────┐
STB  ────┘               └──────────────
         ┌───────────────┐
ADR  ────┤  valid addr   ├──────────────
         └───────────────┘
                         ┌───────┐
ACK  ────────────────────┘       └──────
                         ┌───────┐
DAT_I────────────────────┤ valid ├──────
                         └───────┘
```

### Signaux Wishbone

| Signal     | Direction | Largeur | Description                      |
|------------|-----------|---------|----------------------------------|
| `wb_clk_i` | Input    | 1       | Horloge système                  |
| `wb_rst_i` | Input    | 1       | Reset (actif haut, convention WB)|
| `wb_adr`   | M→S      | 32      | Adresse                          |
| `wb_dat_w` | M→S      | 32      | Données écriture (master→slave)  |
| `wb_dat_r` | S→M      | 32      | Données lecture (slave→master)   |
| `wb_sel`   | M→S      | 4       | Sélection d'octets (byte enable) |
| `wb_we`    | M→S      | 1       | Write enable                     |
| `wb_stb`   | M→S      | 1       | Strobe (transfert valide)        |
| `wb_cyc`   | M→S      | 1       | Cycle bus actif                  |
| `wb_ack`   | S→M      | 1       | Acquittement                     |

### Décodage d'adresses

```
sel_dmem  = (adr[31:16] == 16'h0001)
sel_uart  = (adr[31:12] == 20'h10000)
sel_spi   = (adr[31:12] == 20'h10001)
sel_timer = (adr[31:12] == 20'h10002)
sel_gpio  = (adr[31:12] == 20'h10003)
```

## Registres des périphériques

### UART (base: 0x1000_0000)

| Offset | Nom      | Accès | Bits   | Description                        |
|--------|----------|-------|--------|------------------------------------|
| 0x00   | TX_DATA  | W     | [7:0]  | Octet à transmettre                |
| 0x04   | RX_DATA  | R     | [7:0]  | Octet reçu                         |
| 0x08   | STATUS   | R     | [2:0]  | {rx_overrun, rx_valid, tx_busy}    |
| 0x0C   | CTRL     | RW    | [1:0]  | {rx_irq_en, tx_irq_en}            |
| 0x10   | DIVISOR  | RW    | [15:0] | Diviseur baud (clk/(div+1))        |

### SPI (base: 0x1000_1000)

| Offset | Nom      | Accès | Bits   | Description                        |
|--------|----------|-------|--------|------------------------------------|
| 0x00   | TX_DATA  | W     | [7:0]  | Octet à transmettre (lance SPI)    |
| 0x04   | RX_DATA  | R     | [7:0]  | Octet reçu                         |
| 0x08   | STATUS   | R     | [0:0]  | {busy}                             |
| 0x0C   | CTRL     | RW    | [3:0]  | {cs_manual, cpol, cpha, enable}    |
| 0x10   | DIVIDER  | RW    | [7:0]  | Diviseur (sclk=clk/(2*(div+1)))    |
| 0x14   | CS       | RW    | [0:0]  | Chip select (actif bas)            |

### Timer (base: 0x1000_2000)

| Offset | Nom       | Accès | Bits   | Description                       |
|--------|-----------|-------|--------|-----------------------------------|
| 0x00   | CTRL      | RW    | [3:0]  | {ovf_irq, match_irq, reload, en} |
| 0x04   | COUNT     | RW    | [31:0] | Valeur courante du compteur       |
| 0x08   | COMPARE   | RW    | [31:0] | Valeur de comparaison             |
| 0x0C   | STATUS    | R/W1C | [1:0]  | {overflow, match}                 |
| 0x10   | PRESCALER | RW    | [15:0] | Pré-diviseur                      |

### GPIO (base: 0x1000_3000)

| Offset | Nom        | Accès | Bits   | Description                      |
|--------|------------|-------|--------|----------------------------------|
| 0x00   | DATA_IN    | R     | [31:0] | Valeur des pins (synchronisée)   |
| 0x04   | DATA_OUT   | RW    | [31:0] | Valeur de sortie                 |
| 0x08   | DIR        | RW    | [31:0] | Direction (0=in, 1=out)          |
| 0x0C   | IRQ_EN     | RW    | [31:0] | IRQ enable par pin (front mont.) |
| 0x10   | IRQ_STATUS | R/W1C | [31:0] | Statut IRQ (écrire 1 pour clear) |

## Hiérarchie pour le Physical Design

### Blocs de niveau 1 (implémentés individuellement)

| Bloc  | Module            | Contenu                           | Macro SRAM |
|-------|-------------------|-----------------------------------|------------|
| CPU   | cpu_wb_wrapper    | riscv_core + memory_controller    | Non        |
| DMEM  | dmem_wb_wrapper   | sram_wrapper_4kb (DMEM)           | Oui        |
| UART  | uart_wb           | UART TX/RX + registres            | Non        |
| SPI   | spi_wb            | SPI master + registres            | Non        |
| Timer | timer_wb          | Timer 32-bit + prescaler          | Non        |
| GPIO  | gpio_wb           | GPIO 32-bit + IRQ                 | Non        |

### Niveau top (intégration)

| Élément             | Type   | Notes                              |
|---------------------|--------|------------------------------------|
| IMEM SRAM           | Macro  | Placé directement au top-level     |
| wb_interconnect     | Logic  | Glue logic, placée au top-level    |
| Power rings/stripes | PG     | Planifié au top-level              |
| I/O pads            | I/O    | Ring périphérique                   |

## Spécifications cibles

| Paramètre          | Valeur            |
|--------------------|-------------------|
| PDK                | Sky130 (130nm)    |
| Fréquence cible    | 100 MHz (10 ns)   |
| Tension            | 1.8V              |
| SRAM               | 2x sky130_sram_1rw1r_128x256_8 |
| Layers métal       | 5 (li1 → met5)   |
| Utilisation cible  | 60-70%            |
