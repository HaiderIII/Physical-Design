# Hints - CTS_002 The Buffer Bonanza

Read these hints progressively - try to solve the puzzle after each hint.

---

## Hint 1 - Understanding the Problem (reveal after 10 min)

<details>
<summary>Click to reveal</summary>

Look at lines 115-116 in `run.tcl`:

```tcl
set root_buffer "sky130_fd_sc_hd__inv_8"
set buffer_list {sky130_fd_sc_hd__inv_1 sky130_fd_sc_hd__inv_2 sky130_fd_sc_hd__inv_4 sky130_fd_sc_hd__inv_8}
```

These are **inverters** (inv_*), not clock buffers (clkbuf_*)!

Inverters invert the signal, so CTS needs to use them in pairs. This is inefficient and not designed for clock distribution.

</details>

---

## Hint 2 - Sky130 Clock Buffer Cells (reveal after 15 min)

<details>
<summary>Click to reveal</summary>

Sky130HD provides dedicated clock buffers:

| Cell | Drive Strength |
|------|----------------|
| sky130_fd_sc_hd__clkbuf_1 | Smallest |
| sky130_fd_sc_hd__clkbuf_2 | Small |
| sky130_fd_sc_hd__clkbuf_4 | Medium |
| sky130_fd_sc_hd__clkbuf_8 | Large |
| sky130_fd_sc_hd__clkbuf_16 | Largest |

Use `clkbuf_16` for the root (high fanout) and a mix of sizes for the tree.

</details>

---

## Hint 3 - The Fix (reveal after 20 min)

<details>
<summary>Click to reveal</summary>

Change lines 115-116 to:

```tcl
set root_buffer "sky130_fd_sc_hd__clkbuf_16"
set buffer_list {sky130_fd_sc_hd__clkbuf_1 sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8 sky130_fd_sc_hd__clkbuf_16}
```

This tells CTS to use proper clock buffers with:
- Strong root buffer (clkbuf_16) for the clock input
- Various sizes for building a balanced tree

</details>

---

## Key Concepts

### Why Clock Buffers?

```
Inverters:                    Clock Buffers:
- Invert signal              - Buffer signal (no inversion)
- Used in pairs              - Used individually
- Unbalanced rise/fall       - Balanced rise/fall
- Not clock-optimized        - Clock-optimized
```

### Duty Cycle Impact

```
Ideal clock:  __|‾‾|__|‾‾|__|‾‾|  (50% duty cycle)

With unbalanced rise/fall:
              __|‾|___|‾|___|‾|   (distorted duty cycle)
```

Clock buffers maintain the 50% duty cycle, inverters may not.

### Buffer Sizing

| Tree Level | Buffer Size | Why |
|------------|-------------|-----|
| Root | clkbuf_16 | High fanout to first level |
| Upper | clkbuf_8, clkbuf_4 | Medium fanout |
| Lower | clkbuf_2, clkbuf_1 | Low fanout to sinks |
