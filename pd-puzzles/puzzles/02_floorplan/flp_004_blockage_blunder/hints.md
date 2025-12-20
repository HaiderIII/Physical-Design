# Hints - FLP_004: Blockage Blunder

---

## Hint 1: The Error Message

The error says "blockage_urx (95) > core_urx (90)". The blockage extends beyond the core boundary.

---

## Hint 2: Core Area

The core area is from (10, 10) to (90, 90). Any blockage must fit within these bounds.

---

## Hint 3: The Bug

Look for these lines around line 103-106:
```tcl
set blockage_llx 75
set blockage_lly 75
set blockage_urx 95    ;# <-- BUG! 95 > 90
set blockage_ury 95    ;# <-- BUG! 95 > 90
```

---

## Hint 4: The Fix

Change the upper-right coordinates to fit within core:
```tcl
set blockage_llx 70
set blockage_lly 70
set blockage_urx 90    ;# Fixed: equals core_urx
set blockage_ury 90    ;# Fixed: equals core_ury
```

This creates a 20x20 blockage in the top-right corner, within bounds.

---

## Still Stuck?

See `.solution/EXPLANATION.md` for the complete solution.
