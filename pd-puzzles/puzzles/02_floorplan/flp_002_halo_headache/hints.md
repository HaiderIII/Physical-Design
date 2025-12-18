# Hints - FLP_002 The Halo Headache

If you're stuck, reveal hints progressively.

---

## Hint 1 - Understanding the Problem (reveal after 10 min)

<details>
<summary>Click to reveal</summary>

The script places two macros but doesn't define any keepout zones around them.

Look at the run.tcl file around line 130-156 where the macros are placed. After the placement commands, there's a TODO section asking you to add halos.

Key information:
- Macro size: 40um x 30um
- Required halo: 10um on ALL sides
- ANALOG_BLOCK_0 at (20, 20) -> occupies (20,20) to (60,50)
- ANALOG_BLOCK_1 at (130, 140) -> occupies (130,140) to (170,170)

</details>

---

## Hint 2 - The OpenROAD Command (reveal after 20 min)

<details>
<summary>Click to reveal</summary>

OpenROAD provides `create_blockage` to define placement blockage regions.

Syntax:
```tcl
create_blockage -region {x1 y1 x2 y2}
```

This creates a rectangular region where standard cells cannot be placed.

For ANALOG_BLOCK_0:
- Macro occupies: (20, 20) to (60, 50)
- With 10um halo: (10, 10) to (70, 60)

You need to create blockages for BOTH macros!

</details>

---

## Hint 3 - The Complete Solution (reveal after 30 min)

<details>
<summary>Click to reveal</summary>

Add these lines in the TODO section (around line 155):

```tcl
# Add 10um halos around both analog macros using placement blockages
puts "Adding placement blockages around macros..."

# ANALOG_BLOCK_0: macro at (20,20) size 40x30
# Halo region: (20-10, 20-10) to (60+10, 50+10) = (10,10) to (70,60)
create_blockage -region {10 10 70 60}

# ANALOG_BLOCK_1: macro at (130,140) size 40x30
# Halo region: (130-10, 140-10) to (170+10, 170+10) = (120,130) to (180,180)
create_blockage -region {120 130 180 180}

puts "Blockages created: 10um clearance on all sides of macros"
```

This tells OpenROAD's placer to keep standard cells out of these rectangular regions during global and detailed placement.

</details>

---

## Key Concept

```
Without Blockage:                With Blockage:
+--------+                       +------------------+
|  MACRO |[CELLS]                |    BLOCKAGE      |
|        |[CELLS]                |   +--------+     |
|        |[CELLS]                |   |  MACRO |     |
+--------+[CELLS]                |   |        |     |
          [CELLS]                |   +--------+     |
                                 +------------------+
                                           [CELLS]
                                           [CELLS]

Problem: Noise coupling         Solution: Clean separation
```

## Calculating Blockage Coordinates

```
Macro position: (x, y)
Macro size: (width, height)
Halo size: H

Blockage coordinates:
  x1 = x - H
  y1 = y - H
  x2 = x + width + H
  y2 = y + height + H
```

For ANALOG_BLOCK_0:
- Position: (20, 20), Size: (40, 30), Halo: 10
- x1 = 20 - 10 = 10
- y1 = 20 - 10 = 10
- x2 = 20 + 40 + 10 = 70
- y2 = 20 + 30 + 10 = 60
- Blockage: {10 10 70 60}
