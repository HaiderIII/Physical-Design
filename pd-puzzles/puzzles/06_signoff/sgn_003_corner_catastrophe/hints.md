# Hints - SGN_003: Corner Catastrophe

Try to solve the puzzle on your own first! Use these hints progressively.

---

## Hint 1: Understanding the Error

The script says "Multi-corner analysis DISABLED". Look for variables that control which corners are loaded.

<details>
<summary>More detail...</summary>

Search for variables named like `use_*_corner` in the script.
</details>

---

## Hint 2: Corner Variables

There are two boolean variables controlling corner loading:
- `use_slow_corner` - Controls SS corner loading
- `use_fast_corner` - Controls FF corner loading

<details>
<summary>More detail...</summary>

Both are currently set to `false`. They need to be `true` for proper signoff.
</details>

---

## Hint 3: Why Each Corner Matters

- **SS (Slow-Slow)**: Cells are slow, so data paths take longer. This is worst-case for setup timing.
- **FF (Fast-Fast)**: Cells are fast, so data arrives quickly. This is worst-case for hold timing.

<details>
<summary>More detail...</summary>

At 7nm, process variation can be 20-30%, so a "fast" chip may have cells running 30% faster than typical!
</details>

---

## Hint 4: What to Change

Look for lines around line 50-51:

```tcl
set use_slow_corner false    ;# <-- BUG! Should be true for setup
set use_fast_corner false    ;# <-- BUG! Should be true for hold
```

<details>
<summary>More detail...</summary>

Change both `false` to `true`:
```tcl
set use_slow_corner true
set use_fast_corner true
```
</details>

---

## Hint 5: Complete Solution

<details>
<summary>Click to reveal...</summary>

In `run.tcl`, change:

```tcl
# TODO: Fix the corner configuration!
# Currently: Only TT loaded - INSUFFICIENT for signoff!
set use_slow_corner true     ;# Fixed: Enable SS for setup
set use_fast_corner true     ;# Fixed: Enable FF for hold
```

This enables multi-corner analysis:
- SS libraries are loaded for worst-case setup analysis
- FF libraries are loaded for worst-case hold analysis
- TT remains for nominal behavior

</details>

---

## Still Stuck?

Check `.solution/EXPLANATION.md` for a complete walkthrough.
