# Quiz Answers - PLC_002 The Timing Tunnel Vision

---

## Question 1: C
**Total wirelength (HPWL)**

By default, `global_placement` minimizes Half-Perimeter Wire Length (HPWL), which is the sum of bounding box half-perimeters for all nets. This produces compact placement but ignores timing completely.

---

## Question 2: B
**`-timing_driven`**

The correct OpenROAD syntax is:
```tcl
global_placement -density 0.60 -timing_driven
```

This flag tells the placer to consider timing constraints when optimizing cell positions.

---

## Question 3: B
**Timing constraints (SDC file)**

Timing-driven placement requires:
1. Liberty files (cell delays) - loaded with `read_liberty`
2. SDC constraints (clock, I/O delays) - loaded with `read_sdc`

Without these, the placer has no timing information to use.

---

## Question 4: B
**How much delay the net contributes to timing violations**

Net criticality measures how "timing-critical" a net is:
- criticality = 1.0: Net is on the critical path with zero slack
- criticality = 0.0: Net has infinite slack (not timing-critical)

The placer uses criticality to weight nets during optimization.

---

## Question 5: B
**0.8 (high - near critical)**

Calculation:
- Path delay: 8ns
- Slack: 2ns
- Target: 10ns
- Criticality ≈ delay_used / target = 8/10 = 0.8

A criticality of 0.8 means the path is quite critical and the placer should prioritize keeping it short.

---

## Question 6: B
**Carry chains and datapath structures become long wires when placed randomly**

Pipelined designs have:
- Long combinational paths (carry chains, multiplexers)
- Sequential dependencies between stages

Without timing guidance, the placer may spread these cells across the die, creating very long wires that add excessive delay.

---

## Question 7: D
**All of the above**

When timing-driven placement alone isn't enough:
1. **Lower density**: More whitespace allows better cell positioning
2. **Multiple iterations**: `global_placement` can run iteratively
3. **Check constraints**: Wrong clock period or missing constraints cause problems
4. Additional techniques: Different timing weights, manual cell placement hints

---

## Key Takeaways

1. **Always use `-timing_driven`** for designs with timing constraints
2. **Load SDC before placement** - order matters!
3. **Check timing after placement** - use `estimate_parasitics -placement` and `report_checks`
4. **Criticality guides the placer** - it's not just about total wirelength
5. **Pipelined/datapath designs benefit most** from timing-driven placement

```
Good Flow:
1. read_liberty (cell delays)
2. read_lef (physical info)
3. read_verilog (netlist)
4. link_design
5. read_sdc (timing constraints) ← Critical!
6. initialize_floorplan
7. global_placement -timing_driven ← The fix!
8. detailed_placement
9. Check timing
```
