# FLP_004: Blockage Blunder

## Difficulty: Expert

## PDK: Sky130HD

## Problem Description

You're creating a floorplan with a reserved area for a future analog IP block. The placement blockage must prevent standard cells from being placed in this region.

However, the blockage coordinates extend **OUTSIDE the core area**, causing an error!

## Symptoms

When you run `openroad run.tcl`:
- ">>> ERROR: Blockage extends OUTSIDE core area! <<<"
- "blockage_urx (95) > core_urx (90)"
- "PUZZLE FAILED - Invalid blockage coordinates!"

## Your Task

Fix the blockage coordinates in `run.tcl` to fit within the core area.

## Background

### What Are Placement Blockages?

Blockages prevent the placer from putting cells in specific regions:

```
+----------------------------------+
|            Die Area              |
|   +------------------------+     |
|   |      Core Area         |     |
|   |                        |     |
|   |    [cells]  +------+   |     |
|   |             |BLOCK |   |     |
|   |    [cells]  |      |   |     |
|   |             +------+   |     |
|   +------------------------+     |
+----------------------------------+
```

### Why Use Blockages?

1. **Analog IP reservation** - Reserve space for future analog blocks
2. **Power strap clearance** - Avoid placing under wide power stripes
3. **Sensitive area protection** - Keep logic away from noisy regions
4. **Hierarchical design** - Reserve space for sub-blocks

### Coordinate Rules

Blockages must be **INSIDE** the core area:
- `blockage_llx >= core_llx`
- `blockage_lly >= core_lly`
- `blockage_urx <= core_urx`
- `blockage_ury <= core_ury`

## Files

- `run.tcl` - **FIX THIS FILE** - Correct the blockage coordinates
- `resources/datapath.v` - 8-bit datapath netlist
- `resources/constraints.sdc` - Timing constraints

## Success Criteria

After fixing:
1. Blockage fits within core area
2. Placement succeeds
3. "PUZZLE PASSED - Blockage correctly configured!"

## Hints

See `hints.md` if you get stuck.

## Verification

```bash
openroad run.tcl
```
