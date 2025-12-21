# PLC_005: Routability Ruin

## Level: Master
## PDK: Nangate45

---

## Problem Statement

The matrix multiplier passes synthesis, floorplan, and placement, but global routing runs indefinitely with:

```
[INFO GRT-0102] Start extra iteration 1/50
[INFO GRT-0102] Start extra iteration 2/50
...
[INFO GRT-0102] Start extra iteration 50/50
[WARNING GRT-0273] Disabled NDR (to reduce congestion)
[INFO GRT-0102] Start extra iteration 1/50
...
```

The router cannot converge and keeps trying to resolve overflow.

## Your Task

1. Understand why routing resources are exhausted
2. Identify the relationship between placement and routing congestion
3. Find the parameters causing excessive resource reduction
4. Fix the flow to achieve successful routing

## Key Information

- Look at the "Routing resources analysis" section
- Resource Reduction percentages above 80% are dangerous
- `set_global_routing_layer_adjustment` controls how much routing capacity is reserved
- High placement density combined with reduced routing resources causes congestion

## Running the Puzzle

```bash
cd puzzles/03_placement/plc_005_routability_ruin
openroad run.tcl
```

## Success Criteria

- Global routing completes without infinite loops
- No overflow in congestion report
- All timing checks pass
