# RISC-V RV32I Physical Design Project - ASAP7 (7nm)

## Project Overview

| Attribute | Value |
|-----------|-------|
| **Design** | RISC-V RV32I 5-Stage Pipeline CPU |
| **Target PDK** | ASAP7 (7nm FinFET) |
| **Target Frequency** | 500 MHz (2ns period) |
| **Estimated Gates** | ~200K (with synthesized SRAMs) |
| **Tools** | Yosys + OpenROAD |

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         riscv_soc                               │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                     riscv_core                           │  │
│  │  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐           │  │
│  │  │ IF  │→ │ ID  │→ │ EX  │→ │ MEM │→ │ WB  │           │  │
│  │  └─────┘  └─────┘  └─────┘  └─────┘  └─────┘           │  │
│  │     ↑        │        │                                  │  │
│  │     └────────┴────────┘ (Forwarding & Hazard)           │  │
│  └──────────────────────────────────────────────────────────┘  │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐               │
│  │   IMEM     │  │    DMEM    │  │    GPIO    │               │
│  │   4KB      │  │    4KB     │  │   32-bit   │               │
│  └────────────┘  └────────────┘  └────────────┘               │
└─────────────────────────────────────────────────────────────────┘
```

## Progress Tracker

### Phase 1: RTL Design ✅
- [x] RISC-V package (opcodes, constants)
- [x] Register file (32x32-bit)
- [x] ALU (all RV32I operations)
- [x] Instruction decoder
- [x] Branch unit
- [x] Hazard detection & forwarding
- [x] Pipeline registers (IF/ID, ID/EX, EX/MEM, MEM/WB)
- [x] Memory controller
- [x] SRAM model
- [x] Top-level SoC

### Phase 2: Synthesis ✅
- [x] Verify RTL syntax with Yosys
- [x] Run synthesis
- [x] Analyze gate count
- [x] Technology mapping to ASAP7 cells

**Synthesis Results (2024-12-20):**

| Metric | Value |
|--------|-------|
| Total Cells | ~201,740 |
| Flip-flops | 34,393 |
| Combinational Logic | ~167,347 |
| Netlist Size | 23 MB |

**Cell Distribution:**

| Cell Type | Count | Description |
|-----------|-------|-------------|
| NAND2xp33_ASAP7 | 117,764 | 2-input NAND |
| NAND3xp33_ASAP7 | 36,348 | 3-input NAND |
| DFFHQNx1_ASAP7 | 32,800 | D Flip-flop (SRAM) |
| NAND4xp25_ASAP7 | 12,826 | 4-input NAND |
| DFFASRHQNx1_ASAP7 | 1,593 | DFF with async reset |
| XOR2x2_ASAP7 | 42 | 2-input XOR |
| Others | ~367 | NOR, MAJ, OR, XNOR |

**Note:** The large flip-flop count (32,800) comes from the 2x 4KB SRAMs synthesized as registers. In a real design, these would be replaced by SRAM macros.

### Phase 3: Floorplanning 🔲
- [ ] Define die area
- [ ] Place power pins
- [ ] Place macros (SRAMs)
- [ ] Analyze utilization

**Screenshot espace réservé:**
![Floorplan](docs/images/02_floorplan.png)

### Phase 4: Placement 🔲
- [ ] Global placement
- [ ] Detailed placement
- [ ] Check congestion
- [ ] Optimize placement

**Screenshot espace réservé:**
![Placement](docs/images/03_placement.png)

### Phase 5: Clock Tree Synthesis (CTS) 🔲
- [ ] Build clock tree
- [ ] Analyze skew
- [ ] Buffer insertion
- [ ] Verify timing

**Screenshot espace réservé:**
![CTS](docs/images/04_cts.png)

### Phase 6: Routing 🔲
- [ ] Global routing
- [ ] Detailed routing
- [ ] Fix DRC violations
- [ ] Antenna fixes

**Screenshot espace réservé:**
![Routing](docs/images/05_routing.png)

### Phase 7: Signoff 🔲
- [ ] Static Timing Analysis (STA)
- [ ] Power analysis
- [ ] DRC/LVS clean
- [ ] Final GDSII

**Screenshot espace réservé:**
![Final Layout](docs/images/06_final.png)

---

## Files Structure

```
riscv-asap7/
├── README.md                 # This file (progress tracker)
├── docs/
│   └── images/              # Screenshots from OpenROAD GUI
├── src/
│   ├── riscv_pkg.v          # Constants & defines
│   ├── register_file.v      # 32x32 register file
│   ├── alu.v                # Arithmetic Logic Unit
│   ├── decoder.v            # Instruction decoder
│   ├── branch_unit.v        # Branch condition evaluation
│   ├── hazard_unit.v        # Hazard detection & forwarding
│   ├── memory_controller.v  # Load/Store unit
│   ├── pipeline_registers.v # All pipeline registers
│   ├── sram_32x1024.v       # SRAM model (4KB)
│   ├── riscv_core.v         # CPU core (5-stage pipeline)
│   └── riscv_soc.v          # Top-level SoC
├── constraints/
│   └── design.sdc           # Timing constraints
├── scripts/                 # TCL scripts for each phase
├── results/                 # Output files
└── reports/                 # Timing, area, power reports
```

---

## How to Run

### Test GUI OpenROAD
```bash
cd ~/projects/Physical-Design/riscv-asap7
openroad -gui
```

### Run Synthesis
```bash
cd ~/projects/Physical-Design/riscv-asap7
mkdir -p results/riscv_soc/01_synthesis
yosys -s scripts/01_synthesis.ys
```

---

## Notes & Observations

### Phase 2 - Synthesis Notes

**Leçons apprises:**
1. ABC (technology mapper) cannot read compressed `.lib.gz` files directly - need to decompress first
2. Yosys `.ys` scripts use `log` command instead of `echo` for messages
3. ASAP7 cells are split across multiple liberty files (SIMPLE, SEQ, INVBUF, AO, OA)

**Problèmes rencontrés:**
1. `ABC failed with status 8B` - Fixed by decompressing the liberty file
2. Duplicate `abc -liberty abc -liberty` typo in script

**Optimisations futures:**
1. Use SRAM macros instead of synthesized flip-flops to reduce cell count
2. Consider multi-Vt optimization (mix LVT/RVT/SLVT cells)
