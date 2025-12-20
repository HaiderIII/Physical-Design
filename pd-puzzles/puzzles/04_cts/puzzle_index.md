# 04_cts Puzzles - Clock Tree Synthesis

## Puzzle List

| ID | Name | Level | PDK | Status |
|----|------|-------|-----|--------|
| cts_001_skew | [The Buffer Blunder](cts_001_skew/PROBLEM.md) | Beginner | Nangate45 | ✅ |
| cts_002_buffer_bonanza | [The Buffer Bonanza](cts_002_buffer_bonanza/PROBLEM.md) | Intermediate | Sky130HD | ✅ |
| cts_003_sink_shuffle | [Sink Shuffle](cts_003_sink_shuffle/PROBLEM.md) | Advanced | ASAP7 | ✅ |
| cts_004_skew_spiral | [Skew Spiral](cts_004_skew_spiral/PROBLEM.md) | Expert | Sky130HD | ✅ |

---

## Progression Path

1. **cts_001_skew** - Clock buffer basics (15-20 min)
   - *Bug*: Using BUF_X* instead of CLKBUF_X*
   - *Skills*: Clock vs regular buffers, buffer selection

2. **cts_002_buffer_bonanza** - Sky130 clock buffers (20-25 min)
   - *Bug*: Using inverters (inv_*) instead of clock buffers (clkbuf_*)
   - *Skills*: Sky130 clock buffer cells, duty cycle, CTS configuration

3. **cts_003_sink_shuffle** - Sink clustering for 7nm (15-20 min)
   - *Bug*: Sink clustering disabled, diameter too large
   - *Skills*: Sink clustering, cluster diameter, skew control

4. **cts_004_skew_spiral** - Wire RC for CTS (20-25 min)
   - *Bug*: Missing set_wire_rc commands for signal and clock nets
   - *Skills*: Wire RC estimation, parasitic modeling, layer selection

---

## Key Concepts

### Clock Buffers vs Regular Buffers

| Feature | Clock Buffers | Regular Buffers/Inverters |
|---------|--------------|---------------------------|
| Rise/Fall balance | Optimized | Not guaranteed |
| Duty cycle | Maintained | May distort |
| Skew behavior | Predictable | Variable |
| Purpose | Clock distribution | Logic/data |

### Sky130 Clock Buffer Family

| Cell | Drive Strength | Use Case |
|------|----------------|----------|
| clkbuf_1 | 1x | Leaf buffers |
| clkbuf_2 | 2x | Lower levels |
| clkbuf_4 | 4x | Intermediate |
| clkbuf_8 | 8x | Upper levels |
| clkbuf_16 | 16x | Root buffer |

### CTS Command Structure

```tcl
clock_tree_synthesis -root_buf <strong_clkbuf> \
                     -buf_list {<clkbuf_1> <clkbuf_2> ...} \
                     -sink_clustering_enable
```

### Sink Clustering (Advanced Nodes)

```tcl
clock_tree_synthesis -root_buf $root \
                     -buf_list $buffers \
                     -sink_clustering_enable \
                     -sink_clustering_max_diameter 30
```

| Diameter | Effect |
|----------|--------|
| 200+ um  | Too large - high skew |
| 50-100 um | Moderate |
| 20-50 um | Good for 7nm |
| <10 um | Too small - many buffers |

### Common CTS Errors

- Using wrong buffer types (inv_*, buf_* instead of clkbuf_*)
- Root buffer too weak for fanout
- Missing buffer sizes in buf_list
- Sink clustering disabled at advanced nodes
- Cluster diameter too large for technology
