# Hints - flp_003: Density Disaster

## Hint 1: Understanding the Error
The first error is about IO pins:
```
[ERROR PPL-0024] Number of IO pins (53) exceeds maximum number of available positions (20)
```

This means the die perimeter is too small to fit all the pins. You need a larger die!

---

## Hint 2: Calculate Required Area
The design has ~66 cells, each about 0.054 um² on average.

Total cell area ≈ 66 × 0.054 = 3.6 um²

For 60% utilization:
Required core area = 3.6 / 0.6 = 6 um²

So you need at least 6 um² of core area, plus margins for IO.

---

## Hint 3: Find the Bug Locations
Look for these lines in `run.tcl`:

```tcl
set die_area  {0 0 2 2}          ;# Line ~121 - TOO SMALL!
set core_area {0.2 0.2 1.8 1.8}  ;# Line ~122 - TOO SMALL!
set target_density 0.95          ;# Line ~163 - TOO HIGH!
```

---

## Hint 4: Reasonable Values
Try these values:

```tcl
set die_area  {0 0 10 10}        ;# 10x10 um die = 100 um² total
set core_area {0.5 0.5 9.5 9.5}  ;# 9x9 um core = 81 um²
set target_density 0.60          ;# 60% density - much more reasonable
```

This gives:
- Plenty of room for 53 IO pins around the 40um perimeter
- 81 um² core area (way more than the 6 um² minimum)
- 60% density target for good routability

---

## Hint 5: Why 95% Density is Bad

At 95% utilization:
- Almost no space for routing channels
- No room for buffer insertion
- Severe congestion → timing failures
- DRC violations from crowded wires

For advanced nodes like ASAP7, target 50-70% max.
