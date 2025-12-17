# PLC_001 - The Density Dilemma

**Phase**: Placement
**Level**: Beginner
**PDK**: Nangate45
**Estimated time**: 15-20 min

---

## Context

You're working on a processor datapath at ChipWorks Inc. Your colleague configured the global placement with a very high target density of 0.95, thinking "higher density = smaller chip = lower cost".

While the placement completes, you notice the detailed placement has high displacement and the wirelength increased significantly. This will hurt timing in later stages.

---

## Observed Symptoms

When you run `openroad run.tcl`, you see placement metrics:

```
Running global placement with density: 0.95
...
Running detailed placement...
Placement Analysis
---------------------------------
total displacement        XXX u
average displacement      X.X u
max displacement          X.X u
original HPWL           XXX.X u
legalized HPWL          XXX.X u
delta HPWL                 XX %    <-- High value indicates problems!
```

A high delta HPWL (>15-20%) during legalization indicates the global placement was too aggressive and cells had to move significantly to find legal positions.

---

## Objective

Fix the `run.tcl` script to achieve better placement quality.

**Success criteria**:
- [ ] Script runs without errors
- [ ] Delta HPWL during legalization is < 15%
- [ ] Placement completes cleanly
- [ ] DEF file is generated in results/

---

## Skills Covered

- [ ] Understanding placement density parameter
- [ ] Interpreting placement quality metrics (HPWL, displacement)
- [ ] Choosing appropriate density values
- [ ] Balancing density vs quality tradeoffs

---

## Files Provided

```
plc_001_density/
├── PROBLEM.md          # This file
├── run.tcl             # Script to fix (contains TODO)
├── resources/
│   ├── processor.v     # Pre-synthesized processor netlist
│   └── constraints.sdc # Timing constraints
├── hints.md            # Hints if you're stuck
└── QUIZ.md             # Validation quiz
```

---

## Key Concepts

### What is Placement Density?

The `-density` parameter in `global_placement` controls how tightly cells are packed:

```
density = 0.95 → Pack cells to fill 95% of available space
density = 0.60 → Pack cells to fill 60% of available space
```

### Why Lower Density is Better

1. **More routing space**: Wires can take direct paths
2. **Less displacement**: Cells stay near optimal positions
3. **Better timing**: Shorter wires = faster signals
4. **Easier CTS**: Room for clock buffers

### Placement Quality Metrics

| Metric | Good | Bad | Meaning |
|--------|------|-----|---------|
| delta HPWL | <15% | >25% | Movement during legalization |
| avg displacement | <1.5um | >3um | Average cell movement |
| max displacement | <5um | >10um | Worst-case movement |

### Typical Density Values

| Use Case | Density | Notes |
|----------|---------|-------|
| Area-critical | 0.80-0.90 | Only if routing is simple |
| Balanced | 0.60-0.70 | Good default choice |
| Timing-critical | 0.40-0.50 | Best for complex designs |

---

## Getting Started

1. Read `run.tcl` and find the `global_placement -density` parameter
2. Run the script and note the placement metrics (especially delta HPWL)
3. Try different density values (0.9, 0.7, 0.5) and compare metrics
4. Fix the TODO with an appropriate value

```bash
cd puzzles/03_placement/plc_001_density
openroad run.tcl
```

---

## Rules

1. **Don't look** at the `.solution/` folder before completing the quiz
2. If stuck for more than 10 minutes, check `hints.md`
3. Once the script works with good metrics, answer the quiz in `QUIZ.md`

---

Good luck!
