# Solution Explanation - FLP_004: Blockage Blunder

## The Bug

The blockage coordinates extended outside the core area:

```tcl
set blockage_urx 95    ;# BUG! Core ends at 90
set blockage_ury 95    ;# BUG! Core ends at 90
```

## The Fix

Adjust coordinates to fit within core:

```tcl
set blockage_llx 70
set blockage_lly 70
set blockage_urx 90    ;# Fixed: matches core_urx
set blockage_ury 90    ;# Fixed: matches core_ury
```

## Why This Matters

### Floorplan Hierarchy

```
+----------------------------------+
|            Die (0,0)-(100,100)   |
|   +------------------------+     |
|   |    Core (10,10)-(90,90)|     |
|   |                        |     |
|   |  Standard cells go     |     |
|   |  ONLY in core area     |     |
|   |                        |     |
|   +------------------------+     |
|   I/O ring / power straps        |
+----------------------------------+
```

### Blockage Must Be In Core

The placer only works within the core area. A blockage outside the core:
- Is meaningless (no cells would be placed there anyway)
- May cause undefined tool behavior
- Indicates a configuration error

### Real-World Scenario

```
Core Area (10,10) to (90,90):
+------------------------+
|                        |
|  [logic cells]         |
|                        |
|            +-----------+
|            | Reserved  |
|            | for       |
|            | Analog IP |
|            +-----------+
+------------------------+
             (70,70)-(90,90)
```

The 20x20 reserved area is for a future analog block like:
- PLL (Phase-Locked Loop)
- ADC (Analog-to-Digital Converter)
- Voltage regulator
- Temperature sensor
