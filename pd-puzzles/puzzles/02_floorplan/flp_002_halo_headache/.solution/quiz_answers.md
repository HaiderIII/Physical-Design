# Quiz Answers - FLP_002 The Halo Headache

---

## Question 1: B
**A region around a macro where standard cells cannot be placed**

A halo (also called keepout or placement blockage) defines an exclusion zone around a macro. The placer must keep standard cells outside this region.

---

## Question 2: B
**To reduce noise coupling from digital switching activity**

Analog circuits are sensitive to noise. Digital cells switching nearby can inject noise through:
- Substrate coupling
- Power supply fluctuations (IR drop)
- Electromagnetic interference
- Capacitive coupling

The halo provides physical separation to minimize these effects.

---

## Question 3: B
**`create_blockage -region {x1 y1 x2 y2}`**

This is the correct OpenROAD syntax for creating a placement blockage region.

---

## Question 4: B
**{45 45 85 75} - macro plus halo on all sides**

Calculation:
- Macro: origin (50, 50), size 30x20 → occupies (50,50) to (80,70)
- With 5um halo on all sides:
  - Left edge: 50 - 5 = 45
  - Bottom edge: 50 - 5 = 45
  - Right edge: 80 + 5 = 85
  - Top edge: 70 + 5 = 75
- Total blockage: {45 45 85 75}

---

## Question 5: B
**Nothing - cells already placed will stay in the blockage region**

Blockages must be defined BEFORE placement runs. If you define them after, they have no effect on already-placed cells. The placer only respects blockages during placement operations.

---

## Question 6: D
**All of the above**

Halos serve multiple purposes:
1. **Routing channels**: Space for wires to reach macro pins
2. **Decap placement**: Area for decoupling capacitors near power-hungry macros
3. **Manufacturing**: Some macros have DRC-sensitive edges
4. **Noise isolation**: Primary reason for analog macros
5. **IR drop**: Prevents cells from competing for power near macro

---

## Question 7: D
**All of the above could cause this issue**

Common blockage problems:
1. **Timing**: Blockage commands must come BEFORE `global_placement`
2. **Coordinates**: Wrong region coordinates won't protect the right area
3. **Density**: If utilization is too high, placer may overflow
4. **Syntax errors**: Wrong command format silently fails

Debug tip: Verify blockage coordinates match your intended halo region.

---

## Key Takeaways

1. **Always add blockages** around sensitive macros (analog, memory, IP blocks)
2. **Order matters**: Define blockages BEFORE running placement
3. **Verify**: Check that no cells violate the blockage after placement
4. **Document**: Record halo requirements in your floorplan spec

```
Good Floorplan Flow:
1. Initialize floorplan (die/core area)
2. Place macros
3. Define blockages (create_blockage)  ← Don't forget!
4. Place pins
5. Run global placement
6. Run detailed placement
7. Verify halo compliance
```
