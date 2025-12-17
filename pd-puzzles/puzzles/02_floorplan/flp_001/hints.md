# Hints for FLP_001 - The Impossible Floorplan

Read these hints progressively - try to solve the puzzle after each hint before moving to the next one.

---

## Hint 1: Understanding the Error

The error message tells you everything:
```
[INFO GPL-0018] Movable instances area:        122.211 um^2
[INFO GPL-0019] Utilization:                   494.022 %
[ERROR GPL-0301] Utilization 494.022 % exceeds 100%.
```

**Question**: If utilization is 494%, what does that mean about the relationship between cell area and core area?

<details>
<summary>Click to reveal</summary>

Utilization = Cell Area / Core Area

If utilization is ~500%, it means you're trying to fit ~5x more cells than the available space!

The current core area is way too small.
</details>

---

## Hint 2: Find the Problem in the Script

Look at lines 90-98 in `run.tcl`:

```tcl
set die_area {0 0 10 10}  ;# <-- TODO: This die is too small!

set core_area {2 2 8 8}
initialize_floorplan -die_area $die_area \
                     -core_area $core_area \
                     -site FreePDK45_38x28_10R_NP_162NW_34O
```

**Question**: What is the current core area in um^2?

<details>
<summary>Click to reveal</summary>

Core area = (8-2) x (8-2) = 6 x 6 = 36 um^2

But cells need 122 um^2! That's why utilization is ~500%.
</details>

---

## Hint 3: Calculate the Required Size

You need:
- Cell area: 122 um^2
- Target utilization: ~65% (leaving room for routing)
- IO margin: 2 um on each side

**Step 1**: Required core area = Cell area / utilization
```
Core area = 122 / 0.65 = 188 um^2
```

**Step 2**: Core dimensions (assuming square)
```
Core side = sqrt(188) = 13.7 um ≈ 14 um
```

**Step 3**: Die dimensions = Core + margins
```
Die side = 14 + 2 + 2 = 18 um
```

---

## Hint 4: The Fix

You need to change two lines in `run.tcl`:

```tcl
set die_area {0 0 20 20}     ;# Bigger die (20x20 um)
set core_area {2 2 18 18}    ;# Core with 2um margin
```

This gives:
- Core area = 16 x 16 = 256 um^2
- Utilization = 122 / 256 = 48%

That's much better!

---

## Still Stuck?

If the script still fails after your fix, check:

1. Are both `die_area` and `core_area` updated consistently?
2. Is the core area inside the die area (with margins)?
3. Does the site row fit in your dimensions?

You can also try using `initialize_floorplan` with `-utilization` instead of explicit areas:

```tcl
initialize_floorplan -utilization 0.65 \
                     -aspect_ratio 1.0 \
                     -core_space 2 \
                     -site FreePDK45_38x28_10R_NP_162NW_34O
```

This lets the tool calculate the die size automatically!
