# Hints for CTS_001 - The Buffer Blunder

Read these hints progressively - try to solve the puzzle after each hint before moving to the next one.

---

## Hint 1: Look at the CTS Output

When you run the script, pay attention to these lines:

```
Using root buffer: BUF_X4
Using buffer list: BUF_X1 BUF_X2 BUF_X4
[INFO CTS-0050] Root buffer is BUF_X4.
```

**Question**: What type of cells are being used? Are they clock buffers?

<details>
<summary>Click to reveal</summary>

The cells being used are:
- `BUF_X4` - Regular buffer (NOT a clock buffer)
- `BUF_X1` - Regular buffer
- `BUF_X2` - Regular buffer

These are standard buffers, not clock-specific buffers!
</details>

---

## Hint 2: Find the Configuration in run.tcl

Look at lines 128-130 in `run.tcl`:

```tcl
set root_buffer "BUF_X4"
set buffer_list {BUF_X1 BUF_X2 BUF_X4}  ;# <-- TODO: Wrong buffers!
```

**Question**: What should these be changed to?

<details>
<summary>Click to reveal</summary>

The Nangate45 PDK has dedicated clock buffers:
- `CLKBUF_X1` - Small clock buffer
- `CLKBUF_X2` - Medium clock buffer
- `CLKBUF_X3` - Large clock buffer

You should use these instead of regular BUF_X* cells.
</details>

---

## Hint 3: Clock Buffer Selection

For clock tree synthesis:

- **Root buffer**: Use the strongest clock buffer (CLKBUF_X3)
  - Drives the entire clock tree from the source
  - Needs high drive strength

- **Buffer list**: Include multiple sizes for flexibility
  - CTS will choose appropriate sizes for each level
  - Mix of CLKBUF_X1, X2, X3 is typical

---

## Hint 4: The Fix

Change the buffer configuration in `run.tcl`:

```tcl
# BEFORE (wrong):
set root_buffer "BUF_X4"
set buffer_list {BUF_X1 BUF_X2 BUF_X4}

# AFTER (correct):
set root_buffer "CLKBUF_X3"
set buffer_list {CLKBUF_X1 CLKBUF_X2 CLKBUF_X3}
```

---

## Verification

After fixing, run the script and verify:

```
Using root buffer: CLKBUF_X3
Using buffer list: CLKBUF_X1 CLKBUF_X2 CLKBUF_X3
[INFO CTS-0050] Root buffer is CLKBUF_X3.
...
Cells used:
  CLKBUF_X3: 9
```

You should see CLKBUF in the output, not BUF!
