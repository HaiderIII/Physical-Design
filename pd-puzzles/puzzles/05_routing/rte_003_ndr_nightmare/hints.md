# Hints - RTE_003: NDR Nightmare

## Hint 1: Understanding the Warning

The script tells you the problem:
```
>>> WARNING: Min routing layer too low for 7nm! <<<
    M2/M3 are congested with cell connections.
```

At 7nm, lower metals are already busy with cell internals.

---

## Hint 2: ASAP7 Metal Stack

```
Layer  | Purpose              | Signal Routing?
-------|---------------------|----------------
M7     | Power/clock         | No (special)
M6     | Global routing      | Yes (good)
M5     | Global routing      | Yes (good)
M4     | Semi-global         | Yes (preferred) ← MIN HERE
M3     | Semi-global         | Limited (congested)
M2     | Local/pins          | No (very congested)
M1     | Cell internal       | No (blocked)
```

---

## Hint 3: Why Lower Layers Are Congested

At 7nm, standard cells are very compact:
- M1: Internal transistor connections, power rails
- M2: Cell pin access, local interconnect

If you route signals on M2:
```
Cell A        Signal wire on M2        Cell B
┌─────┐ ═══════════════════════════ ┌─────┐
│ M2  │ ← Competes with cell pins!  │ M2  │
│ M1  │                             │ M1  │
└─────┘                             └─────┘
```

Result: Congestion and potential DRC violations!

---

## Hint 4: The Fix Location

Look for this line in `run.tcl`:
```tcl
set min_routing_layer "M2"    ;# <-- FIX THIS
```

---

## Hint 5: Recommended Value

For ASAP7:
```tcl
set min_routing_layer "M4"    ;# Good for 7nm
```

This leaves M1-M3 for cell connections and gives signals M4-M7.

---

## Hint 6: Layer Adjustment Values

The script also sets layer adjustments:
```tcl
set_global_routing_layer_adjustment M1 1.0   ;# Blocked
set_global_routing_layer_adjustment M2 0.9   ;# Almost blocked
set_global_routing_layer_adjustment M3 0.7   ;# Limited
set_global_routing_layer_adjustment M4 0.4   ;# Available
set_global_routing_layer_adjustment M5 0.2   ;# Very available
```

Notice how lower layers have higher reduction = less capacity!

---

## Solution Summary

Change `min_routing_layer` from `"M2"` to `"M4"` to avoid congested lower layers.
