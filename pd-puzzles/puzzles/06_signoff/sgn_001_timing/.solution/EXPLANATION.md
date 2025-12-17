# Explanation - SGN_001: The Timing Terror

## The Bug

The original `run.tcl` was missing parasitic estimation:

```tcl
# BUG: Missing parasitic estimation!
# estimate_parasitics ???  ;# <-- TODO: What parameter should go here?

report_checks -path_delay max ...
```

## The Fix

Add parasitic estimation before timing analysis:

```tcl
# FIXED: Extract wire RC for timing
estimate_parasitics -global_routing

report_checks -path_delay max ...
```

---

## Why This Matters

### Without Parasitics (Bug)

```
Cell A ────────────────────────────── Cell B
         Wire delay = 0 (WRONG!)

Total path delay = Cell A delay + 0 + Cell B delay
                 = Optimistic (too fast)
```

### With Parasitics (Fixed)

```
Cell A ───────[R]───[C]───[R]───[C]─── Cell B
              └─────────────────┘
              Wire delay = f(R,C,length)

Total path delay = Cell A delay + Wire delay + Cell B delay
                 = Realistic
```

---

## Timing Analysis Flow

```
┌─────────────────┐
│  Place & Route  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ estimate_       │  ← Extract wire R,C
│ parasitics      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ report_checks   │  ← Timing with real delays
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Slack > 0 ?     │──No──► Fix violations
└────────┬────────┘
         │Yes
         ▼
┌─────────────────┐
│ SIGNOFF PASS    │
└─────────────────┘
```

---

## Key Commands

### Parasitic Estimation

```tcl
# After global routing
estimate_parasitics -global_routing

# After detailed routing (more accurate)
estimate_parasitics -detailed_routing
```

### Timing Reports

```tcl
# Worst setup path (max delay)
report_checks -path_delay max

# Worst hold path (min delay)
report_checks -path_delay min

# All violating paths
report_checks -slack_max 0

# Detailed path report
report_checks -path_delay max \
              -format full_clock_expanded \
              -fields {slew cap input_pins nets fanout}
```

### Slack Reports

```tcl
# Worst setup slack
report_worst_slack -max

# Worst hold slack
report_worst_slack -min

# Total negative slack (TNS)
report_tns
```

---

## Understanding Timing Reports

```
Startpoint: a_r7 (rising edge-triggered flip-flop clocked by clk)
Endpoint: res_r7 (rising edge-triggered flip-flop clocked by clk)
Path Group: clk
Path Type: max

  Delay    Time   Description
---------------------------------------------------------
   0.00    0.00   clock clk (rise edge)
   0.05    0.05   clock network delay (propagated)
          0.05   a_r7/CK (DFFR_X1)
   0.12    0.17   a_r7/Q (DFFR_X1)
   0.08    0.25   add7/S (FA_X1)          ← Cell delay
   0.15    0.40   wire delay              ← Wire delay (from parasitics!)
   0.06    0.46   mux7/Z (MUX4_X1)
   0.03    0.49   res_r7/D (DFFR_X1)
          0.49   data arrival time

  10.00   10.00   clock clk (rise edge)
   0.05   10.05   clock network delay (propagated)
  -0.20    9.85   clock uncertainty
   0.00    9.85   res_r7/CK (DFFR_X1)
  -0.04    9.81   library setup time
          9.81   data required time
---------------------------------------------------------
          9.81   data required time
         -0.49   data arrival time
---------------------------------------------------------
          9.32   slack (MET)             ← Positive = PASS
```

---

## Timing Corners

Production signoff uses multiple corners:

| Corner | Used For | Why |
|--------|----------|-----|
| ss (slow-slow) | Setup | Slowest transistors = longest delays |
| ff (fast-fast) | Hold | Fastest transistors = shortest delays |
| tt (typical) | Power | Nominal conditions |

OpenROAD uses the library corner you load. For complete signoff, run with each library.

---

## Common Timing Fixes

| Problem | Solution |
|---------|----------|
| Setup violation | Use faster cells, shorten path |
| Hold violation | Add buffers to slow path |
| High uncertainty | Improve clock tree |
| Missing constraints | Add input/output delays |

---

## Further Reading

- Static Timing Analysis (STA) fundamentals
- Multi-corner multi-mode (MCMM) analysis
- On-chip variation (OCV) derating
- Parasitic extraction methods
