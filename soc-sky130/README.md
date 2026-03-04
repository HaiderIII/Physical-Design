# SoC RISC-V — Hierarchical Physical Design (Sky130)

## Overview

Hierarchical physical design of a RISC-V RV32I SoC on **Sky130 130nm**.

The design is partitioned into independent blocks, each implemented through the
full P&R flow, then assembled at the top-level — following industry-standard
hierarchical methodology.

## SoC Architecture

```
┌──────────────────────────────────────────────────────────┐
│                        soc_top                           │
│                                                          │
│  ┌──────────┐      ┌─────────────┐                      │
│  │  IMEM    │◄────►│    CPU      │                      │
│  │ SRAM 4KB │      │  RV32I 5stg │                      │
│  └──────────┘      └──────┬──────┘                      │
│                           │ Wishbone B4                  │
│  ┌────────────────────────┴───────────────────────────┐  │
│  │             Wishbone B4 Interconnect                │  │
│  └──┬────────┬────────┬────────┬────────┬─────────────┘  │
│     │        │        │        │        │                │
│  ┌──┴──┐  ┌──┴──┐  ┌──┴──┐  ┌──┴──┐  ┌──┴──┐          │
│  │DMEM │  │UART │  │ SPI │  │Timer│  │GPIO │           │
│  │4KB  │  │     │  │     │  │     │  │     │           │
│  └─────┘  └─────┘  └─────┘  └─────┘  └─────┘           │
└──────────────────────────────────────────────────────────┘
```

## Specifications

| Parameter       | Value                          |
|-----------------|--------------------------------|
| PDK             | Sky130 (130nm CMOS)            |
| Target freq.    | 100 MHz                        |
| Voltage         | 1.8V                           |
| ISA             | RISC-V RV32I                   |
| Pipeline        | 5-stage (IF/ID/EX/MEM/WB)     |
| Bus             | Wishbone B4 classic            |
| SRAM            | 2× 4KB OpenRAM macros          |
| Peripherals     | UART, SPI, Timer, GPIO         |
| Metal layers    | 5 (li1 → met5)                |

## Memory Map

| Address range              | Size  | Peripheral |
|---------------------------|-------|------------|
| `0x0000_0000 - 0x0000_0FFF` | 4 KB  | IMEM (SRAM)  |
| `0x0001_0000 - 0x0001_0FFF` | 4 KB  | DMEM (SRAM)  |
| `0x1000_0000 - 0x1000_00FF` | 256 B | UART         |
| `0x1000_1000 - 0x1000_10FF` | 256 B | SPI          |
| `0x1000_2000 - 0x1000_20FF` | 256 B | Timer        |
| `0x1000_3000 - 0x1000_30FF` | 256 B | GPIO         |

## Hierarchical PD Flow

```
Phase 0: Architecture & RTL          ← current
Phase 1: Block-level synthesis
Phase 2: Block-level P&R
Phase 3: Abstract generation (LEF)
Phase 4: Top-level floorplanning
Phase 5: Top-level power planning
Phase 6: Top-level placement & CTS
Phase 7: Top-level routing
Phase 8: Top-level signoff & GDSII
```

## Project Structure

```
soc-sky130/
├── doc/
│   ├── architecture.md              # SoC architecture & register map
│   └── notes/                       # Pedagogical notes per phase
├── rtl/
│   ├── core/                        # RISC-V CPU (from riscv-sky130)
│   │   ├── riscv_core.v             #   5-stage pipeline
│   │   ├── cpu_wb_wrapper.v         #   Wishbone master wrapper
│   │   ├── alu.v, decoder.v, ...    #   CPU sub-modules
│   │   └── sram_wrapper_4kb.v       #   SRAM macro wrapper
│   ├── peripherals/
│   │   ├── uart_wb/uart_wb.v        # UART (TX/RX, baud config)
│   │   ├── spi_wb/spi_wb.v         # SPI master (CPOL/CPHA)
│   │   ├── timer_wb/timer_wb.v     # 32-bit timer + prescaler
│   │   └── gpio_wb/gpio_wb.v       # 32-bit GPIO + IRQ
│   ├── bus/
│   │   ├── wb_interconnect.v        # Wishbone address decoder + mux
│   │   └── dmem_wb_wrapper.v        # DMEM SRAM Wishbone wrapper
│   └── soc_top.v                    # Top-level SoC integration
├── constraints/
│   ├── soc_top.sdc                  # Top-level timing constraints
│   └── blocks/                      # Per-block SDC constraints
├── scripts/
│   ├── block_level/                 # Block-level PD scripts (Yosys + OpenROAD)
│   └── top_level/                   # Top-level PD scripts
├── blocks/                          # Per-block results & reports
│   ├── cpu/, uart/, spi/, timer/, gpio/
├── results/                         # Top-level results
└── images/                          # Layout screenshots
```

## Tools

| Tool     | Purpose                                   |
|----------|-------------------------------------------|
| Yosys    | Logic synthesis (RTL → gate-level)        |
| OpenROAD | Floorplan, placement, CTS, routing        |
| OpenSTA  | Static timing analysis                    |
| KLayout  | GDSII visualization                       |
