# FLP_003 - The Density Disaster

**Phase**: Floorplan
**Level**: Advanced
**PDK**: ASAP7 (7nm)
**Estimated time**: 30-45 min

---

## Context

You're working on a 16-bit datapath unit that needs to run at 1 GHz on ASAP7 7nm technology. The previous engineer set up the floorplan, but when you try to run placement, everything fails catastrophically.

"The die is too small," says the backend lead. "And that density target... 95%? Are you trying to create a black hole?"

---

## Symptoms

When you run `openroad run.tcl`, placement fails immediately:

```
==============================================
 Creating Floorplan
==============================================
Die area: 0 0 2 2
Core area: 0.2 0.2 1.8 1.8

Floorplan dimensions:
  Die:  2 x 2 um = 4.00 um^2
  Core: 1.6 x 1.6 um = 2.56 um^2

[ERROR PPL-0024] Number of IO pins (53) exceeds maximum number of available positions (20).
```

Even if you fix the die size, there's another problem waiting...

---

## Objective

Fix `run.tcl` to create a valid floorplan that passes placement.

**Success criteria**:
- [ ] Die area is large enough for all IO pins
- [ ] Core area provides sufficient space for cells
- [ ] Placement density target is reasonable (< 80%)
- [ ] Placement completes without errors

---

## Target Skills

- [ ] Calculate required die/core area from cell count
- [ ] Understand utilization vs density targets
- [ ] Know typical density ranges for advanced nodes
- [ ] Configure floorplan parameters for ASAP7

---

## Files Provided

```
flp_003_density_disaster/
├── PROBLEM.md              # This file
├── run.tcl                 # Script to fix (wrong die size + density)
├── resources/
│   ├── datapath.v          # 16-bit datapath netlist (66 cells)
│   └── constraints.sdc     # Timing constraints (1 GHz)
├── hints.md                # Progressive hints
└── QUIZ.md                 # Validation quiz
```

---

## Background: Floorplan Density in ASAP7

### Key Concepts

1. **Die Area**: Total chip area including I/O ring
2. **Core Area**: Area available for standard cells
3. **Utilization**: Actual cell area / Core area
4. **Density Target**: Placement algorithm's target density

### Typical Values for ASAP7

| Parameter | Typical Range | Notes |
|-----------|---------------|-------|
| Utilization | 50-70% | Higher = more congestion |
| Density Target | 0.5-0.7 | Used by global placement |
| IO margin | 0.5-1.0 um | Space for pins and routing |

### Formula

```
Required Core Area = Total Cell Area / Target Utilization
```

For 66 cells at ~0.054 um² each = ~3.6 um² of cells.
At 60% utilization, you need: 3.6 / 0.6 = 6 um² minimum.

---

## Getting Started

1. Run the script and observe the error
2. Calculate how much area you actually need
3. Fix `die_area` and `core_area`
4. Also check `target_density` - 95% is way too high!
5. Run again:

```bash
cd puzzles/02_floorplan/flp_003_density_disaster
openroad run.tcl
```

---

## Rules

1. **Don't look** at the `.solution/` folder before completing the quiz
2. If stuck for more than 10 minutes, check `hints.md`
3. Once the script works, answer the quiz in `QUIZ.md`

---

Good luck! May your floorplan have room to breathe!
