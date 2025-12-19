# PLC_003 - Padding Panic

## Difficulty: Advanced

## PDK: ASAP7 (7nm)

## Problem Description

You're placing a 16-bit shift register on ASAP7 (7nm technology). The placement runs but routing will fail with DRC violations because **cells are placed too close together**.

At advanced nodes like 7nm:
- Metal pitches are extremely tight (36nm for M1/M2)
- Cells need extra spacing for pin access
- Sequential cells (flip-flops) need even more room due to clock routing

## Symptoms

When you run the puzzle without fixing it:
```
>>> WARNING: No cell padding configured! <<<
    Cells will be placed edge-to-edge.
    This causes routing congestion at 7nm!
```

## The Bug

The script has **no cell padding** configured:
```tcl
set padding_global 0      ;# <-- BUG! Should be at least 1-2 sites
set padding_sequential 0  ;# <-- BUG! Should be 3-4 sites for DFFs
```

## Your Task

1. Find the padding configuration section in `run.tcl`
2. Set appropriate padding values for ASAP7:
   - Global padding for all cells
   - Extra padding for sequential cells (DFFs)
3. Run the script until placement passes

## Hints

<details>
<summary>Hint 1: What is cell padding?</summary>

Cell padding adds empty sites on the left and right of each cell during placement. This creates spacing between cells for routing resources.

```
Without padding:  [CELL1][CELL2][CELL3]
With padding=2:   [CELL1]__[CELL2]__[CELL3]
```
</details>

<details>
<summary>Hint 2: Why do sequential cells need more padding?</summary>

Sequential cells (flip-flops) have:
- Clock pins that need routing
- More internal metal for latches
- Scan chain connections (in DFT)

Typical values for ASAP7:
- Combinational: 1-2 sites
- Sequential: 3-4 sites
</details>

<details>
<summary>Hint 3: The OpenROAD command</summary>

```tcl
# For all cells
set_placement_padding -global -left N -right N

# For specific cell types
set_placement_padding -masters {CellName} -left N -right N
```
</details>

## Success Criteria

The placement passes when:
- Global padding >= 1 site
- Sequential padding >= 3 sites
- Congestion risk is not CRITICAL or HIGH

## Files

- `run.tcl` - Main script with the bug
- `resources/shift_register.v` - 16-bit shift register netlist
- `resources/constraints.sdc` - Timing constraints (1.5 GHz)

## Learning Objectives

- Understand cell padding for advanced nodes
- Learn the relationship between placement and routing
- Configure different padding for cell types
