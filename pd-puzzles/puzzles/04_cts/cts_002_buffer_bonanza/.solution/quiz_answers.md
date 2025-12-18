# Quiz Answers - CTS_002 The Buffer Bonanza

---

## Question 1: B
**Clock buffers have balanced rise/fall times for stable duty cycle**

Clock buffers are specifically designed for clock distribution:
- Balanced rise and fall times
- Consistent duty cycle across PVT corners
- Characterized for clock networks

---

## Question 2: C
**sky130_fd_sc_hd__clkbuf_16 (largest clock buffer)**

The root buffer drives the first level of the clock tree, which typically has high fanout. Use the strongest clock buffer available.

---

## Question 3: B
**The high and low times are no longer equal (not 50/50)**

Ideal clock: 50% high, 50% low
Distorted: e.g., 45% high, 55% low

This can cause setup/hold timing issues and reduce noise margins.

---

## Question 4: B
**`-root_buf`**

The correct syntax is:
```tcl
clock_tree_synthesis -root_buf sky130_fd_sc_hd__clkbuf_16 ...
```

---

## Question 5: B
**It needs to drive many cells at the first tree level (high fanout)**

The clock root connects to many first-level buffers. A strong buffer prevents excessive delay and maintains signal integrity.

---

## Question 6: B
**The available buffer cells CTS can use to build the tree**

CTS selects from this list based on required drive strength:
```tcl
-buf_list {sky130_fd_sc_hd__clkbuf_1 sky130_fd_sc_hd__clkbuf_2 ...}
```

---

## Question 7: B
**The root_buf and buf_list parameters - they should use clkbuf_* cells**

If you see inv_* cells in the CTS report, the buffer configuration is wrong. Change to clkbuf_* cells.

---

## Key Takeaways

1. **Always use clock buffers** (clkbuf_*) for clock trees
2. **Use strong root buffer** (clkbuf_16) for high fanout
3. **Provide a range of sizes** in buf_list for flexibility
4. **Check CTS reports** to verify correct buffer usage

```tcl
# Correct CTS configuration for Sky130:
clock_tree_synthesis \
    -root_buf sky130_fd_sc_hd__clkbuf_16 \
    -buf_list {sky130_fd_sc_hd__clkbuf_1 \
               sky130_fd_sc_hd__clkbuf_2 \
               sky130_fd_sc_hd__clkbuf_4 \
               sky130_fd_sc_hd__clkbuf_8 \
               sky130_fd_sc_hd__clkbuf_16}
```
