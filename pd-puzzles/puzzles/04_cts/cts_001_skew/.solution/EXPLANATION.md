# Explanation - CTS_001: The Buffer Blunder

## The Bug

The original `run.tcl` used **regular buffers** for clock tree synthesis:

```tcl
# WRONG - Using data path buffers for clock tree
set root_buffer "BUF_X4"
set buffer_list {BUF_X1 BUF_X2 BUF_X4}
```

## The Fix

Use **clock buffers** instead:

```tcl
# CORRECT - Using dedicated clock buffers
set root_buffer "CLKBUF_X3"
set buffer_list {CLKBUF_X1 CLKBUF_X2 CLKBUF_X3}
```

---

## Why This Matters

### 1. Balanced Rise/Fall Times

| Buffer Type | Rise Time | Fall Time | Ratio |
|-------------|-----------|-----------|-------|
| BUF_X2 | ~50ps | ~40ps | 1.25 |
| CLKBUF_X2 | ~45ps | ~45ps | 1.00 |

Clock buffers are designed with symmetric transistor sizing to ensure equal rise and fall times. This prevents **duty cycle distortion** as the clock propagates through the tree.

### 2. Clock Skew

```
With BUF_X*:
  Sink A: clk arrives at 1.2ns
  Sink B: clk arrives at 1.5ns
  Skew = 300ps ❌

With CLKBUF_X*:
  Sink A: clk arrives at 1.1ns
  Sink B: clk arrives at 1.15ns
  Skew = 50ps ✅
```

The unbalanced delays of regular buffers compound through the tree, leading to higher skew.

### 3. Process Corner Tracking

Clock buffers are characterized to track together across PVT (Process, Voltage, Temperature) corners. This means:
- All CLKBUF cells slow down/speed up proportionally
- Relative timing between sinks stays consistent
- Less margin needed for clock uncertainty

### 4. Sign-off Requirements

Production designs must pass:
- **Clock DRC** - Design rules specific to clock networks
- **Clock tree checks** - Verifying buffer types, fanout limits
- **EMIR** - Electromigration and IR drop on clock nets

Using BUF_X* cells often causes these checks to fail.

---

## How CTS Uses the Buffer List

```
                    [CLKBUF_X3]  ← Root (high fanout, needs strong driver)
                    /         \
           [CLKBUF_X2]       [CLKBUF_X2]  ← Level 1
            /      \          /      \
      [CLKBUF_X1] [X1]    [CLKBUF_X1] [X1]  ← Level 2 (lower fanout)
         /|\      /|\        /|\      /|\
        FFs     FFs        FFs      FFs    ← Sinks
```

CTS automatically selects buffer sizes based on:
1. **Fanout** at each node
2. **Timing constraints** (target skew/latency)
3. **Physical distance** to sinks
4. **Clustering** decisions

---

## OpenROAD CTS Commands

### Basic CTS
```tcl
clock_tree_synthesis -root_buf CLKBUF_X3 \
                     -buf_list {CLKBUF_X1 CLKBUF_X2 CLKBUF_X3}
```

### With Clustering (reduces buffer count)
```tcl
clock_tree_synthesis -root_buf CLKBUF_X3 \
                     -buf_list {CLKBUF_X1 CLKBUF_X2 CLKBUF_X3} \
                     -sink_clustering_enable \
                     -sink_clustering_max_diameter 50
```

### With Level Balancing (reduces skew)
```tcl
clock_tree_synthesis -root_buf CLKBUF_X3 \
                     -buf_list {CLKBUF_X1 CLKBUF_X2 CLKBUF_X3} \
                     -balance_levels
```

---

## Nangate45 Clock Buffers

| Cell | Drive Strength | Typical Use |
|------|---------------|-------------|
| CLKBUF_X1 | 1x | Low fanout, leaf nodes |
| CLKBUF_X2 | 2x | Medium fanout, intermediate |
| CLKBUF_X3 | 3x | High fanout, root buffer |

---

## Industry Best Practices

1. **Always use dedicated clock cells** - CLKBUF, CLKGATE, CLKINV
2. **Size the root buffer appropriately** - Usually the largest available
3. **Provide buffer options** - Let CTS choose the optimal size
4. **Enable clustering** - Reduces buffer count and power
5. **Balance levels** - Minimizes skew across the tree
6. **Run post-CTS timing** - Verify setup/hold with actual clock tree

---

## Further Reading

- Clock Tree Synthesis fundamentals
- CTS in OpenROAD documentation
- Clock distribution network design
- Useful skew vs zero skew approaches
