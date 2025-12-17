# Hints for PLC_001 - The Density Dilemma

Read these hints progressively - try to solve the puzzle after each hint before moving to the next one.

---

## Hint 1: Understanding the Metrics

When you run the script, focus on the "Placement Analysis" section:

```
Placement Analysis
---------------------------------
total displacement        156.2 u
average displacement        1.2 u
max displacement            3.6 u
original HPWL             875.4 u
legalized HPWL           1047.2 u
delta HPWL                   20 %
```

**Question**: What does a high delta HPWL tell you about the placement?

<details>
<summary>Click to reveal</summary>

Delta HPWL = (legalized HPWL - original HPWL) / original HPWL

A 20% delta means cells moved 20% further apart during legalization.
This happens when global placement put cells too close together (high density)
and legalization had to spread them out to fit on legal sites.

Lower density → Less movement → Lower delta HPWL
</details>

---

## Hint 2: Find the Problem in the Script

Look at lines 115-121 in `run.tcl`:

```tcl
set placement_density 0.95  ;# <-- TODO: This density is too high!

puts "Running global placement with density: $placement_density"
global_placement -density $placement_density
```

**Question**: What is density 0.95 trying to achieve?

<details>
<summary>Click to reveal</summary>

Density 0.95 tells the placer to pack cells into 95% of the available space.

This leaves only 5% whitespace for:
- Routing channels
- Clock buffers (added later)
- Any cell movement during optimization

That's way too tight for most designs!
</details>

---

## Hint 3: Experiment with Values

Try running the script with different density values:

```tcl
set placement_density 0.95   # Current (bad)
set placement_density 0.80   # Still aggressive
set placement_density 0.60   # Balanced
set placement_density 0.40   # Relaxed
```

Compare the delta HPWL for each:

| Density | Expected delta HPWL |
|---------|---------------------|
| 0.95 | 25-35% |
| 0.80 | 18-25% |
| 0.60 | 12-18% |
| 0.40 | 8-12% |

---

## Hint 4: The Fix

Change line 118 in `run.tcl`:

```tcl
set placement_density 0.60  ;# Good balance for most designs
```

This gives cells room to be placed optimally while leaving space for routing.

---

## Still Stuck?

If you want to see the effect more dramatically:
1. Try density 0.30 (very relaxed) and compare metrics
2. Look at the "Iteration | Overflow" table during global placement
3. Notice how lower density converges faster

Remember: The goal isn't minimum area, it's **quality results**!
A placement that's 10% larger but routes cleanly is better than
one that causes congestion.
