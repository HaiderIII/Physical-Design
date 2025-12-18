# Physical Design Learning Platform

> Master chip design from RTL to GDSII using open-source tools

---

## Overview

This repository provides a complete learning platform for **Physical Design** of digital integrated circuits. It combines theoretical lessons, interactive puzzle challenges, and a complete working project to teach the full PD flow.

### What You'll Learn

- Complete Physical Design flow (Synthesis to GDSII)
- TCL scripting for EDA tools
- OpenROAD, Yosys, and OpenSTA usage
- Timing analysis and optimization
- Debug and troubleshooting skills

---

## Repository Structure

```
Physical-Design/
├── phases/                    # Sequential learning path
│   ├── phase_00_foundations/  # TCL basics & OpenSTA intro
│   └── phase1_floorplanning/  # Die/Core concepts
│
├── pd-puzzles/                # Interactive puzzle challenges
│   ├── tcl_fundamentals/      # TCL crash course
│   ├── puzzles/               # 6 puzzle categories
│   └── common/pdks/           # Nangate45 PDK
│
├── project_alu8bits/          # Complete RTL-to-GDSII example
│   ├── designs/               # 8-bit ALU RTL & constraints
│   ├── scripts/               # Full flow scripts (7 phases)
│   └── results/               # Generated outputs
│
├── install_eda.sh             # EDA tools installation script
└── physical_design_questions_answers.md  # Interview Q&A reference
```

---

## Learning Paths

### Path 1: Structured Learning (phases/)

Follow sequential lessons with theory and exercises:

| Phase | Topic | Content |
|-------|-------|---------|
| Phase 0 | Foundations | TCL scripting, OpenSTA basics |
| Phase 1 | Floorplanning | Die/Core, utilization, aspect ratio |

```bash
cd phases/phase_00_foundations
cat README.md
```

### Path 2: Puzzle Challenges (pd-puzzles/)

Learn by debugging real-world problems:

| Category | Puzzles | Focus |
|----------|---------|-------|
| Synthesis | syn_001 | Library configuration |
| Floorplan | flp_001 | Die area sizing |
| Placement | plc_001 | Density management |
| CTS | cts_001 | Clock skew optimization |
| Routing | rte_001 | Layer configuration |
| Sign-off | sgn_001 | Timing analysis |

```bash
cd pd-puzzles
cat README.md
```

### Path 3: Complete Project (project_alu8bits/)

See the full flow in action with an 8-bit ALU:

```bash
cd project_alu8bits
./scripts/run_flow.sh
```

---

## Prerequisites

### Required Tools

| Tool | Purpose |
|------|---------|
| OpenROAD | Complete PD flow |
| Yosys | Logic synthesis |
| OpenSTA | Static timing analysis |
| TCL 8.6+ | Scripting |

### Installation

```bash
# Install all EDA tools
./install_eda.sh

# Verify installation
openroad -version
yosys -version
sta -version
```

### Optional Tools

- **Magic** - Layout visualization
- **KLayout** - GDSII viewing

---

## Quick Start

### Option A: Start with Foundations
```bash
cd phases/phase_00_foundations/cours
cat 01_tcl_basics.md
```

### Option B: Jump into Puzzles
```bash
cd pd-puzzles/puzzles/01_synthesis/syn_001
cat PROBLEM.md
openroad run.tcl
```

### Option C: Run the Complete Flow
```bash
cd project_alu8bits
./check_tools.sh
./scripts/run_flow.sh
```

---

## Process Design Kits (PDKs)

| PDK | Node | Location | Usage |
|-----|------|----------|-------|
| Nangate45 | 45nm | pd-puzzles/common/pdks/ | Puzzles |
| Sky130 | 130nm | ~/.volare/ | ALU project |

---

## Physical Design Flow Overview

```
RTL (Verilog)
    │
    ▼
┌─────────────┐
│  Synthesis  │  → Gate-level netlist
└─────────────┘
    │
    ▼
┌─────────────┐
│ Floorplan   │  → Die/Core area, IO placement
└─────────────┘
    │
    ▼
┌─────────────┐
│  Placement  │  → Standard cell positioning
└─────────────┘
    │
    ▼
┌─────────────┐
│     CTS     │  → Clock tree synthesis
└─────────────┘
    │
    ▼
┌─────────────┐
│   Routing   │  → Metal interconnects
└─────────────┘
    │
    ▼
┌─────────────┐
│  Sign-off   │  → STA, DRC, LVS verification
└─────────────┘
    │
    ▼
   GDSII
```

---

## Additional Resources

- [physical_design_questions_answers.md](physical_design_questions_answers.md) - Junior PD interview prep (28 Q&A)
- [OpenROAD Documentation](https://openroad.readthedocs.io/)
- [Yosys Manual](https://yosyshq.net/yosys/)

---

## Contact

**Maintainer:** Faiz MOHAMMAD
**Email:** faiz.mohammad.pro@protonmail.com
**GitHub:** [HaiderIII](https://github.com/HaiderIII)

---

## License

MIT License - see LICENSE file for details
