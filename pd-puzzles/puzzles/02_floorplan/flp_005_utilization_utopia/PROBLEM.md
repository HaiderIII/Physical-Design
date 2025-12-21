# FLP_005: Utilization Utopia

## Level: Master
## PDK: Nangate45

---

## Problem Statement

The DSP engine synthesis completed successfully, but OpenROAD fails during placement with:

```
[ERROR GPL-0301] Utilization 1123.680 % exceeds 100%.
```

The design is a DSP engine with:
- 4 parallel MAC (Multiply-Accumulate) units
- 3-stage pipeline
- 4 accumulators with overflow detection
- Multiple operating modes (direct, add pairs, cross multiply, butterfly)

## Your Task

1. Understand why utilization exceeds 100%
2. Find the relationship between die area and design area
3. Fix the floorplan parameters to achieve reasonable utilization

## Key Information

- Design area is reported before the floorplan step
- The `initialize_floorplan` command defines die and core dimensions
- Target utilization for complex designs: 50-70%

## Running the Puzzle

```bash
cd puzzles/02_floorplan/flp_005_utilization_utopia
openroad run.tcl
```

## Success Criteria

- Placement completes without utilization error
- Utilization between 50% and 70%
- Timing analysis runs to completion
