# PLC_002 - The Timing Tunnel Vision

**Phase**: Placement
**Level**: Intermediate
**PDK**: Sky130HD
**Estimated time**: 20-25 min

---

## Context

You're on the placement team at SiliconSpeed Corp. The synthesis team has delivered a pipelined datapath that should run at 125 MHz. They optimized the netlist carefully and synthesis timing looked great.

However, after running placement, the timing report shows negative slack! The design that passed synthesis at 125 MHz is now failing timing.

Your lead engineer suspects the placer isn't considering timing at all and is just minimizing wirelength blindly.

---

## Observed Symptoms

When you run `openroad run.tcl`, you see:

```
Running global placement...
[INFO] ... Placement done ...

Timing Report Summary
--------------------------------------------------------------
Worst slack: -0.02 ns    <-- Negative slack!
--------------------------------------------------------------
```

The synthesis team reports timing was positive before placement. Wire delays from non-optimal placement are causing timing violations!

---

## Objective

Fix the `run.tcl` script to achieve timing closure.

**Success criteria**:
- [ ] Script runs without errors
- [ ] Worst negative slack is better than -0.5 ns (ideally positive)
- [ ] Timing-critical paths are placed with short wire delays

---

## Skills Covered

- [ ] Enabling timing-driven placement mode
- [ ] Understanding placement's impact on timing
- [ ] Using timing constraints during placement
- [ ] Interpreting post-placement timing reports

---

## Files Provided

```
plc_002_timing_driven/
├── PROBLEM.md          # This file
├── run.tcl             # Script to fix (contains TODO)
├── resources/
│   ├── datapath.v      # Pre-synthesized datapath netlist
│   └── constraints.sdc # 125 MHz timing constraints
├── hints.md            # Hints if you're stuck
└── QUIZ.md             # Validation quiz
```

---

## Key Concepts

### Wire Delay in Placement

After placement, wire delay becomes significant:
```
Total delay = Gate delay + Wire delay
             (from synthesis)  (depends on placement!)
```

A 1mm wire at 130nm can add ~1ns of delay!

### Wirelength vs Timing Optimization

| Mode | Optimizes For | Result |
|------|--------------|--------|
| Default | Total wirelength | Short wires overall, but timing-critical paths may be long |
| Timing-driven | Timing slack | Critical paths get priority for short placement |

### Why Timing-Driven Placement Matters

```
Without timing-driven:
  A ----[long wire]---- B ----[long wire]---- C
  (Critical path gets same treatment as others)

With timing-driven:
  A --[short]-- B --[short]-- C
  (Placer knows this path is critical and keeps it compact)
```

---

## Getting Started

1. Read `run.tcl` and examine the global_placement command
2. Run the script and note the timing report
3. Find the TODO and understand what's missing
4. Fix the placement configuration

```bash
cd puzzles/03_placement/plc_002_timing_driven
openroad run.tcl
```

---

## Rules

1. **Don't look** at the `.solution/` folder before completing the quiz
2. If stuck for more than 10 minutes, check `hints.md`
3. Once timing improves, answer the quiz in `QUIZ.md`

---

Good luck!
