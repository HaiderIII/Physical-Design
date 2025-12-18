# Solution Explanation - CTS_002 The Buffer Bonanza

## The Problem

The original `run.tcl` used:
```tcl
set root_buffer "sky130_fd_sc_hd__inv_8"
set buffer_list {sky130_fd_sc_hd__inv_1 sky130_fd_sc_hd__inv_2 sky130_fd_sc_hd__inv_4 sky130_fd_sc_hd__inv_8}
```

These are **inverters**, not clock buffers!

## The Solution

```tcl
set root_buffer "sky130_fd_sc_hd__clkbuf_16"
set buffer_list {sky130_fd_sc_hd__clkbuf_1 sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8 sky130_fd_sc_hd__clkbuf_16}
```

## Why Clock Buffers Matter

### 1. Signal Integrity

Clock buffers maintain signal polarity:
```
clkbuf: IN → OUT (same polarity)
inv:    IN → OUT (inverted)
```

CTS must use inverters in pairs to maintain polarity, which is inefficient.

### 2. Balanced Rise/Fall Times

Clock buffers are designed with equal rise and fall times:
```
clkbuf: t_rise ≈ t_fall → 50% duty cycle maintained
inv:    t_rise ≠ t_fall → duty cycle distortion possible
```

### 3. PVT Variation

Clock buffers are characterized for clock networks across all Process, Voltage, and Temperature corners. Their behavior is predictable and consistent.

### 4. Skew Characteristics

Clock buffers have consistent delay characteristics, making skew easier to control and predict.

## Sky130 Clock Buffer Family

| Cell | Drive | Typical Use |
|------|-------|-------------|
| clkbuf_1 | 1x | Leaf buffers, low fanout |
| clkbuf_2 | 2x | Lower tree levels |
| clkbuf_4 | 4x | Intermediate levels |
| clkbuf_8 | 8x | Upper tree levels |
| clkbuf_16 | 16x | Root buffer, high fanout |

## Best Practices

1. **Always use clock buffers** for clock trees
2. **Strong root buffer** to drive first level
3. **Provide full range** of sizes in buf_list
4. **Verify in reports** that clkbuf_* cells are used
