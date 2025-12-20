# Quiz Answers - SYN_004: Forbidden Cells

## Answers

1. **B** - Prevents the synthesizer from using specified cells
2. **C** - They have high variability and cause yield issues
3. **C** - Only in clock tree synthesis (CTS)
4. **B** - DRC violations and yield loss in manufacturing
5. **C** - decap, fill, tap, conb (physical-only cells)
6. **B** - `set_dont_use [get_lib_cells sky130_fd_sc_hd__dlygate*]`
7. **C** - Before synthesis, as part of library setup

## Key Concepts

### Cell Categories

| Category | Examples | Usage |
|----------|----------|-------|
| Logic | BUF, INV, AND, OR, DFF | Regular synthesis |
| Clock | CLKBUF, CLKINV | CTS only |
| Delay | dlygate, clkdlybuf | Special timing fixes |
| Physical | decap, fill, tap | P&R physical insertion |
| Tie | conb (tie-high/low) | Post-synthesis tie-off |

### Real Production Flow

```
1. Library Setup
   └── set_dont_use constraints defined

2. Synthesis
   └── Forbidden cells excluded

3. Placement
   └── Physical cells inserted (tap, endcap)

4. CTS
   └── Clock buffers inserted (can use clkbuf)

5. Routing
   └── Fill cells inserted

6. Signoff
   └── Verify no forbidden cells in logic
```
