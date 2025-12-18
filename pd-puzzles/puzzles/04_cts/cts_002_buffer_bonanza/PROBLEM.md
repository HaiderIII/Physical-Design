# CTS_002 - The Buffer Bonanza

**Phase**: Clock Tree Synthesis
**Level**: Intermediate
**PDK**: Sky130HD
**Estimated time**: 20-25 min

---

## Context

You're on the CTS team at SiliconClock Inc. working on a DSP datapath design. Your colleague set up the CTS script but used inverters (sky130_fd_sc_hd__inv_*) instead of proper clock buffers (sky130_fd_sc_hd__clkbuf_*).

"An inverter pair is basically a buffer, right?" they said. But clock buffers are specifically designed for clock distribution with balanced rise/fall times and low skew characteristics.

---

## Observed Symptoms

When you run `openroad run.tcl`, you see:

```
Using root buffer: sky130_fd_sc_hd__inv_8
Using buffer list: sky130_fd_sc_hd__inv_1 sky130_fd_sc_hd__inv_2 sky130_fd_sc_hd__inv_4
...
[WARNING] Using non-clock buffers for CTS may cause skew issues
```

The script uses inverters instead of clock buffers. While CTS may complete, using non-clock cells can lead to:
- Unbalanced rise/fall times (duty cycle distortion)
- Higher skew variation across corners
- Timing issues in sign-off

---

## Objective

Fix the `run.tcl` script to use proper Sky130 clock buffers.

**Success criteria**:
- [ ] CTS uses sky130_fd_sc_hd__clkbuf_* cells
- [ ] Root buffer is a strong clock buffer (clkbuf_16)
- [ ] Buffer list contains proper clock buffers
- [ ] CTS completes without warnings

---

## Skills Covered

- [ ] Understanding Sky130 clock buffer cells
- [ ] Configuring CTS buffer selection in OpenROAD
- [ ] Reading CTS reports to verify buffer usage
- [ ] Best practices for clock tree design

---

## Files Provided

```
cts_002_buffer_bonanza/
├── PROBLEM.md          # This file
├── run.tcl             # Script to fix (contains TODO)
├── resources/
│   ├── dsp_core.v      # Pre-synthesized DSP netlist
│   └── constraints.sdc # Timing constraints
├── hints.md            # Hints if you're stuck
└── QUIZ.md             # Validation quiz
```

---

## Key Concepts

### Sky130 Clock Buffers vs Inverters

| Cell Type | Purpose | Rise/Fall Balance |
|-----------|---------|-------------------|
| sky130_fd_sc_hd__clkbuf_* | Clock distribution | Optimized |
| sky130_fd_sc_hd__inv_* | Logic inversion | Not guaranteed |
| sky130_fd_sc_hd__buf_* | Data buffering | Not for clocks |

### Available Sky130 Clock Buffers

| Cell | Drive Strength | Use Case |
|------|----------------|----------|
| sky130_fd_sc_hd__clkbuf_1 | Low | Leaf buffers |
| sky130_fd_sc_hd__clkbuf_2 | Medium-Low | Lower tree levels |
| sky130_fd_sc_hd__clkbuf_4 | Medium | Intermediate levels |
| sky130_fd_sc_hd__clkbuf_8 | High | Upper tree levels |
| sky130_fd_sc_hd__clkbuf_16 | Very High | Root buffer |

### CTS Command Syntax

```tcl
clock_tree_synthesis -root_buf sky130_fd_sc_hd__clkbuf_16 \
                     -buf_list {sky130_fd_sc_hd__clkbuf_1 \
                                sky130_fd_sc_hd__clkbuf_2 \
                                sky130_fd_sc_hd__clkbuf_4 \
                                sky130_fd_sc_hd__clkbuf_8}
```

---

## Getting Started

1. Read `run.tcl` and find the buffer configuration
2. Identify which cells are being used (inv_* or clkbuf_*)
3. Change to proper clock buffers
4. Run and verify the CTS report shows clkbuf usage

```bash
cd puzzles/04_cts/cts_002_buffer_bonanza
openroad run.tcl
```

---

## Rules

1. **Don't look** at the `.solution/` folder before completing the quiz
2. If stuck for more than 10 minutes, check `hints.md`
3. Once CTS uses proper clock buffers, answer the quiz in `QUIZ.md`

---

Good luck!
