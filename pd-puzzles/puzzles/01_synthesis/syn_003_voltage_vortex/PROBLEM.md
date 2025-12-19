# SYN_003 - The Voltage Vortex

**Phase**: Synthesis / Power Analysis
**Level**: Advanced
**PDK**: ASAP7 (7nm)
**Estimated time**: 30-45 min

---

## Context

You've been assigned to a new 7nm project at your company. The design team synthesized an 8-bit ALU using ASAP7's **RVT (Regular-Vt)** cells for a balanced speed/power trade-off.

Your task is to run power analysis on the design. You launch the existing script and... something is very wrong. The tool reports missing cells and the power numbers look suspicious.

"Did you load the right libraries?" asks the senior engineer, looking at your screen with concern.

---

## Symptoms

When you run `openroad run.tcl`, you see alarming warnings:

```
Loading ASAP7 Liberty files...
  Vt type selected: SLVT
  Reading: asap7sc7p5t_SIMPLE_SLVT_TT_nldm_211120.lib.gz
  ...

Loading design...
[WARNING] module AND2x2_ASAP7_75t_R not found. Creating black box.
[WARNING] module DFFHQNx1_ASAP7_75t_R not found. Creating black box.
  ...

>>> SYNTHESIS FAILED: Library mismatch! <<<
  29 cells could not be found in the loaded libraries!
```

The netlist cells end with `_R` but the libraries contain `_SL` cells. What's going on?

---

## Objective

Fix `run.tcl` to load the correct Vt library that matches the netlist cells.

**Success criteria**:
- [ ] All cells are found in the library (no black boxes)
- [ ] Power analysis runs without errors
- [ ] Leakage power is within budget (< 100 uW)

---

## Target Skills

- [ ] Understand Multi-Vt concepts in advanced nodes
- [ ] Know the ASAP7 naming convention (_R, _L, _SL suffixes)
- [ ] Understand the leakage vs speed trade-off
- [ ] Match library selection to netlist requirements

---

## Files Provided

```
syn_003_voltage_vortex/
├── PROBLEM.md              # This file
├── run.tcl                 # Script to fix (wrong Vt library)
├── resources/
│   ├── alu_netlist.v       # ALU design (uses RVT cells)
│   └── constraints.sdc     # Timing constraints (500 MHz)
├── hints.md                # Progressive hints
└── QUIZ.md                 # Validation quiz
```

---

## Background: Multi-Vt in ASAP7

In advanced technology nodes, standard cells come in multiple **threshold voltage (Vt)** variants:

| Vt Type | ASAP7 Suffix | Speed | Leakage | Use Case |
|---------|--------------|-------|---------|----------|
| **SLVT** | `_SL` | Fastest | Highest | Critical paths only |
| **LVT** | `_L` | Fast | High | Performance-critical |
| **RVT** | `_R` | Balanced | Moderate | Default choice |

**Key insight**: The library you load must match the cells in your netlist!

---

## Getting Started

1. Examine `run.tcl` - what Vt type is being loaded?
2. Look at `resources/alu_netlist.v` - what suffix do the cells have?
3. Fix the mismatch
4. Run the script:

```bash
cd puzzles/01_synthesis/syn_003_voltage_vortex
openroad run.tcl
```

---

## Rules

1. **Don't look** at the `.solution/` folder before completing the quiz
2. If stuck for more than 10 minutes, check `hints.md`
3. Once the script works, answer the quiz in `QUIZ.md`

---

Good luck! May the right Vt be with you!
