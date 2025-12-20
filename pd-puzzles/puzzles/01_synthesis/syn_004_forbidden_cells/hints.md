# Hints - SYN_004: Forbidden Cells

---

## Hint 1: The Warning

The script says "Forbidden cell check is DISABLED". Look for a boolean variable that controls this.

---

## Hint 2: The Variable

Search for `enable_forbidden_check` in run.tcl.

---

## Hint 3: The Fix

Find this line (around line 76):
```tcl
set enable_forbidden_check false    ;# <-- BUG! Should be true
```

Change `false` to `true`.

---

## Hint 4: Why This Matters

When enabled, the script scans all instances for patterns like:
- `dlygate` - delay gates
- `clkdlybuf` - clock delay buffers
- `dlymetal` - metal delay cells

These cells should never appear in synthesized logic.

---

## Still Stuck?

See `.solution/EXPLANATION.md` for the complete solution.
