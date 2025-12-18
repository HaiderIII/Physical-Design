# Solution Explanation - FLP_002 The Halo Headache

## The Problem

The original script placed two analog macros but forgot to define blockages around them:

```tcl
# BEFORE (problematic)
# Macros are placed via ODB API...
$inst0 setLocation [expr {20 * 1000}] [expr {20 * 1000}]
$inst1 setLocation [expr {130 * 1000}] [expr {140 * 1000}]

# No blockages defined!
# Placer puts standard cells right next to macros
```

## The Solution

Add `create_blockage` commands after placing the macros:

```tcl
# AFTER (correct)
# After macro placement, add blockages:

# ANALOG_BLOCK_0: macro at (20,20) size 40x30
# Halo region: (10,10) to (70,60)
create_blockage -region {10 10 70 60}

# ANALOG_BLOCK_1: macro at (130,140) size 40x30
# Halo region: (120,130) to (180,180)
create_blockage -region {120 130 180 180}
```

## Why This Works

1. **create_blockage** tells OpenROAD's placer to treat the specified region as unavailable for standard cell placement
2. During global and detailed placement, cells are kept outside the blocked regions
3. The macro itself plus the surrounding halo forms a "no-go zone" for standard cells

## Visual Representation

```
Before (no blockage):            After (with blockage):

+--------+[CELL][CELL]           +----------------------+
| MACRO  |[CELL][CELL]           |     BLOCKAGE        |
|        |[CELL][CELL]           |   +--------+        |
+--------+[CELL][CELL]           |   | MACRO  |        |
[CELL][CELL][CELL][CELL]         |   |        |        |
[CELL][CELL][CELL][CELL]         |   +--------+        |
                                 +----------------------+
                                       [CELL][CELL]
                                       [CELL][CELL]
```

## Calculating Blockage Coordinates

For ANALOG_BLOCK_0:
- Macro position: (20, 20)
- Macro size: 40um x 30um
- Macro occupies: (20, 20) to (60, 50)
- With 10um halo on all sides:
  - x1 = 20 - 10 = 10
  - y1 = 20 - 10 = 10
  - x2 = 60 + 10 = 70
  - y2 = 50 + 10 = 60
- Blockage: {10 10 70 60}

For ANALOG_BLOCK_1:
- Macro position: (130, 140)
- Macro size: 40um x 30um
- Macro occupies: (130, 140) to (170, 170)
- With 10um halo on all sides:
  - x1 = 130 - 10 = 120
  - y1 = 140 - 10 = 130
  - x2 = 170 + 10 = 180
  - y2 = 170 + 10 = 180
- Blockage: {120 130 180 180}

## Real-World Considerations

In production designs, halos/blockages are used for:

1. **Analog macros**: 5-20um typical, depends on sensitivity
2. **Memory macros**: 2-5um for routing access
3. **Hard IP blocks**: Per-IP requirements from vendor
4. **Power switches**: Space for local decoupling

## Common Mistakes

1. **Wrong timing**: Adding blockages AFTER placement runs
2. **Wrong coordinates**: Calculate carefully - position + size + halo
3. **Insufficient size**: Halo too small for routing needs
4. **Overlapping blockages**: Two macros too close together
5. **Units mismatch**: Coordinates are in microns, not DBU

## Verification

Always verify blockage compliance after placement:
```tcl
# Check cell locations vs expected exclusion zones
# The script includes a verification section that does this
```

## Key Command Reference

```tcl
# Create a placement blockage region
create_blockage -region {x1 y1 x2 y2}

# Where:
#   x1, y1 = lower-left corner (microns)
#   x2, y2 = upper-right corner (microns)
```
