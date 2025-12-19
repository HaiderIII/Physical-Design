# Hints - PLC_003: Padding Panic

## Hint 1: Understanding the Error

The warning message tells you exactly what's wrong:
```
>>> WARNING: No cell padding configured! <<<
    Cells will be placed edge-to-edge.
```

Edge-to-edge placement at 7nm = routing disaster!

---

## Hint 2: What is Cell Padding?

Cell padding reserves empty sites around each cell:

```
Without padding (default):
┌────┐┌────┐┌────┐┌────┐
│ FF ││ FF ││ FF ││ FF │  ← No room for routing between cells!
└────┘└────┘└────┘└────┘

With padding = 2 sites:
┌────┐  ┌────┐  ┌────┐  ┌────┐
│ FF │__│ FF │__│ FF │__│ FF │  ← Routing space available!
└────┘  └────┘  └────┘  └────┘
```

---

## Hint 3: Why Different Padding for DFFs?

Flip-flops need more space than combinational cells:

| Cell Type | Pins | Clock | Typical Padding |
|-----------|------|-------|-----------------|
| INV, BUF  | 2    | No    | 1-2 sites       |
| AND, OR   | 3    | No    | 1-2 sites       |
| DFF       | 3-4  | Yes   | 3-4 sites       |

The clock network needs routing resources near every flip-flop!

---

## Hint 4: The Fix Location

Look for these lines in `run.tcl`:
```tcl
set padding_global 0      ;# <-- FIX THIS
set padding_sequential 0  ;# <-- FIX THIS
```

---

## Hint 5: Recommended Values

For ASAP7 (7nm):
```tcl
set padding_global 2      ;# 2 sites for all cells
set padding_sequential 4  ;# 4 sites for flip-flops
```

These values provide:
- Enough space for M1/M2 local routing
- Room for clock tree insertion
- Margin for buffer insertion during optimization

---

## Hint 6: OpenROAD Commands

The script uses these commands based on your settings:

```tcl
# Applied to all cells
set_placement_padding -global -left 2 -right 2

# Extra padding for DFFs (overrides global for these cells)
set_placement_padding -masters {DFFHQNx1_ASAP7_75t_R} -left 4 -right 4
```

---

## Solution Summary

Change the two variables from 0 to appropriate values:
- `padding_global`: 1-2 sites minimum
- `padding_sequential`: 3-4 sites minimum

The script will pass when both conditions are met and congestion risk drops to acceptable levels.
