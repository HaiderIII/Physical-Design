# 04_cts Puzzles - Clock Tree Synthesis

## Puzzle List

| ID | Name | Level | PDK | Status |
|----|------|-------|-----|--------|
| cts_001_skew | [The Buffer Blunder](cts_001_skew/PROBLEM.md) | Beginner | Nangate45 | Completed |
| cts_002_buffer_bonanza | [The Buffer Bonanza](cts_002_buffer_bonanza/PROBLEM.md) | Intermediate | Sky130HD | Completed |

---

## Progression Path

1. **cts_001_skew** - Clock buffer basics (15-20 min)
   - *Bug*: Using BUF_X* instead of CLKBUF_X*
   - *Skills*: Clock vs regular buffers, buffer selection

2. **cts_002_buffer_bonanza** - Sky130 clock buffers (20-25 min)
   - *Bug*: Using inverters (inv_*) instead of clock buffers (clkbuf_*)
   - *Skills*: Sky130 clock buffer cells, duty cycle, CTS configuration

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

### Common CTS Errors

- Using wrong buffer types (inv_*, buf_* instead of clkbuf_*)
- Root buffer too weak for fanout
- Missing buffer sizes in buf_list
