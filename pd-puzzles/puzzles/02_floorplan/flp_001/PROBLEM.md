# FLP_001 - The Impossible Floorplan

**Phase**: Floorplan
**Level**: Beginner
**PDK**: Nangate45
**Estimated time**: 15-20 min

---

## Context

You just joined the backend team at SiliconDreams. Your first task: create a floorplan for a small data processing block.

Your senior colleague sent you a script saying: "I set the die area to 10x10 microns. That should be plenty for this tiny design. Run it and we'll move to placement."

You run the script... and problems begin.

---

## Observed Symptoms

When you run `openroad run.tcl`, you see:

```
[INFO GPL-0018] Movable instances area:        122.211 um^2
[INFO GPL-0019] Utilization:                   494.022 %
[ERROR GPL-0301] Utilization 494.022 % exceeds 100%.
```

The floorplan is created but placement fails miserably - the design is trying to fit 122 um^2 of cells into only ~36 um^2 of core area (6x6 um after 2um margins)!

---

## Objective

Fix the `run.tcl` script to create a viable floorplan where placement can succeed.

**Success criteria**:
- [ ] Script runs without errors
- [ ] Floorplan has a realistic utilization (< 80%)
- [ ] Global placement succeeds without errors
- [ ] A DEF file is generated in results/

---

## Skills Covered

- [ ] Understanding die area vs core area vs cell area
- [ ] Calculating required floorplan dimensions
- [ ] Setting appropriate margins for routing and buffers
- [ ] Reading and interpreting OpenROAD error messages

---

## Files Provided

```
flp_001/
├── PROBLEM.md          # This file
├── run.tcl             # Script to fix (contains TODO)
├── resources/
│   ├── data_path.v     # Pre-synthesized design netlist
│   └── constraints.sdc # Timing constraints
├── hints.md            # Hints if you're stuck
└── QUIZ.md             # Validation quiz
```

---

## Key Concepts

### Die Area vs Core Area

```
+---------------------------+
|         Die Area          |
|  +---------------------+  |
|  |     IO Ring         |  |
|  |  +---------------+  |  |
|  |  |   Core Area   |  |  |
|  |  | (for cells)   |  |  |
|  |  +---------------+  |  |
|  +---------------------+  |
+---------------------------+

Core Area = Die Area - IO margins (typically 2-5 um per side)
```

### Utilization Formula

```
Utilization = (Total Cell Area) / (Core Area) x 100%

For this design:
- Cell Area = ~122 um^2
- Target Utilization = 60-70% (leaving room for routing)
- Required Core Area = 122 / 0.65 = ~188 um^2
- Core dimensions = sqrt(188) = ~14 um per side
- Die dimensions = Core + margins = ~18 um per side
```

---

## Getting Started

1. Read `run.tcl` and find the die_area parameter
2. Calculate: How much core area do you need for 122 um^2 of cells at 65% utilization?
3. Add margins for IO ring (2um on each side)
4. Fix the TODO and test

```bash
cd puzzles/02_floorplan/flp_001
openroad run.tcl
```

---

## Rules

1. **Don't look** at the `.solution/` folder before completing the quiz
2. If stuck for more than 10 minutes, check `hints.md`
3. Once the script works, answer the quiz in `QUIZ.md`

---

Good luck!
