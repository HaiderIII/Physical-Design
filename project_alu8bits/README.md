# 8-Bit ALU Project

**Complete RTL-to-GDSII Flow with OpenROAD**

A fully working Physical Design project demonstrating the complete flow from Verilog to GDSII using an 8-bit Arithmetic Logic Unit.

---

## Overview

This project implements an **8-bit ALU** through all 7 phases of the Physical Design flow:

1. **Synthesis** - RTL to gate-level netlist
2. **Floorplanning** - Die/Core area definition
3. **Placement** - Standard cell positioning
4. **Clock Tree Synthesis** - Clock distribution network
5. **Routing** - Metal interconnects
6. **Optimization** - Timing and power fixes
7. **Sign-off** - Final verification (STA, DRC, LVS)

---

## Technology

| Parameter | Value |
|-----------|-------|
| **PDK** | SkyWater Sky130 |
| **Node** | 130nm |
| **Library** | sky130_fd_sc_hd (High Density) |
| **Tools** | OpenROAD, Yosys |

---

## Project Structure

```
project_alu8bits/
├── designs/
│   └── alu_8bit/
│       ├── rtl/
│       │   └── alu_8bit.v          # Verilog source
│       └── constraints/
│           └── alu_8bit.sdc        # Timing constraints
│
├── config/
│   └── tech_config.tcl             # Sky130 PDK configuration
│
├── scripts/
│   ├── 01_synthesis.tcl            # Yosys synthesis
│   ├── 02_floorplan.tcl            # Die/Core setup
│   ├── 03_placement.tcl            # Cell placement
│   ├── 04_cts.tcl                  # Clock tree synthesis
│   ├── 05_routing.tcl              # Global & detailed routing
│   ├── 06_optimization.tcl         # Timing optimization
│   ├── 07_signoff.tcl              # Final verification
│   ├── 08_gdsii_export.sh          # GDSII generation
│   ├── run_flow.sh                 # Execute full flow
│   └── open_gui.sh                 # Launch OpenROAD GUI
│
├── results/
│   └── alu_8bit/
│       ├── 01_synthesis/           # Synthesized netlist
│       ├── 02_floorplan/           # Floorplan DEF
│       ├── 03_placement/           # Placed design
│       ├── 04_cts/                 # Post-CTS design
│       ├── 05_routing/             # Routed design
│       ├── 06_optimization/        # Optimized design
│       ├── 07_signoff/             # Sign-off reports
│       └── 08_gdsii/               # Final GDSII
│
├── docs/
│   ├── FINAL_CONCLUSION.md         # Project summary
│   ├── phases/                     # Phase documentation
│   └── resources/                  # Reference materials
│
├── check_tools.sh                  # Verify tool installation
└── README.md                       # This file
```

---

## Prerequisites

### Required Tools

- OpenROAD
- Yosys
- Sky130 PDK (via volare)

### Verify Installation

```bash
./check_tools.sh
```

### PDK Setup

The project expects Sky130 PDK at `~/.volare/`. Configuration is in `config/tech_config.tcl`.

---

## Running the Flow

### Full Flow (All Phases)

```bash
cd scripts
./run_flow.sh
```

### Individual Phases

```bash
cd scripts
openroad 01_synthesis.tcl
openroad 02_floorplan.tcl
openroad 03_placement.tcl
openroad 04_cts.tcl
openroad 05_routing.tcl
openroad 06_optimization.tcl
openroad 07_signoff.tcl
./08_gdsii_export.sh
```

### View Design in GUI

```bash
./scripts/open_gui.sh
```

---

## Design Specifications

### ALU Operations

The 8-bit ALU supports basic arithmetic and logic operations:

- Addition
- Subtraction
- AND, OR, XOR
- Shift operations

### Timing Constraints

Defined in `designs/alu_8bit/constraints/alu_8bit.sdc`

---

## Output Files

After running the flow, key outputs are in `results/alu_8bit/`:

| Phase | Output |
|-------|--------|
| Synthesis | `*.v` (gate-level netlist) |
| Floorplan | `*.def` (design exchange format) |
| Placement | `*.def` (placed cells) |
| CTS | `*.def` (with clock tree) |
| Routing | `*.def` (routed design) |
| Sign-off | `*.rpt` (timing/DRC reports) |
| GDSII | `*.gds` (final layout) |

---

## Learning Objectives

By studying this project, you will understand:

- How each PD phase transforms the design
- Script structure for OpenROAD flows
- Reading and interpreting tool reports
- Common issues and their solutions

---

## Documentation

- [FINAL_CONCLUSION.md](docs/FINAL_CONCLUSION.md) - Project results and lessons learned
- [docs/phases/](docs/phases/) - Detailed phase documentation
- [docs/resources/](docs/resources/) - Tool references and tutorials
