# SGN_005: DRC Disaster

## Level: Master

## Objective

Debug a signoff flow that passes timing but fails DRC checks due to slew, capacitance, and fanout violations.

## Background

Physical design signoff requires checking not just timing, but also Design Rule Checks (DRC) including:
- **Max Slew (Transition)**: Signal edges must not be too slow
- **Max Capacitance**: Output loads must not exceed cell driving capability
- **Max Fanout**: Number of sinks per driver must be limited

These constraints are set in the SDC file and violations indicate the design won't work reliably in silicon.

## Problem Description

Running the design shows timing is met (positive slack), but the DRC report shows many violations:

```
=== DRC Violation Report ===
rst_n                     5     47    -42 (VIOLATED)
clkbuf_2_1__f_clk/Z      5     14     -9 (VIOLATED)
...
rst_n                  0.01   93.50  -93.49 (VIOLATED)
_146_/Q                0.01   17.86  -17.85 (VIOLATED)
```

The format is: `pin  limit  actual  slack (VIOLATED)`

## Design

- **Module**: fast_path
- **Function**: 4-stage pipelined data processor with MUX operations
- **Inputs**: clk, rst_n, data_a[7:0], data_b[7:0], sel, enable, mode[1:0]
- **Outputs**: result[7:0], valid

## Files

```
sgn_005_drc_disaster/
  run.tcl              # Main signoff flow (BUG: missing repair_design)
  synth.ys             # Yosys synthesis script
  resources/
    fast_path.v        # Verilog design
    constraints.sdc    # Timing constraints (with DRC limits)
  results/             # Output directory
```

## Task

1. Run `openroad run.tcl` and observe the DRC violations
2. Analyze the SDC constraints for max_fanout, max_transition, max_capacitance
3. Identify what's missing in the flow to fix these violations
4. Add the appropriate repair command
5. Verify violations are resolved

## Success Criteria

- No fanout violations (or acceptable count)
- No slew/transition violations
- No capacitance violations
- Timing still met after repairs

## Hints

Check `hints.md` if you get stuck.
