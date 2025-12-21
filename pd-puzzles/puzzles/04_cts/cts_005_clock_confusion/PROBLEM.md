# CTS_005: Clock Confusion

## Level: Master

## Objective

Debug a CTS flow where the clock tree synthesis reports "No clock nets found" despite the design having clock-driven registers.

## Background

Clock Tree Synthesis (CTS) relies on proper clock definitions in the SDC constraints file. The clock must be defined on a port that actually exists in the design. A mismatch between the SDC clock definition and the actual design port names will cause CTS to fail silently - no clock tree will be built, leaving all registers with unbalanced clock arrival times.

## Problem Description

The design is a 5-stage pipelined 32-bit adder with 225 flip-flops. Running the flow produces:

```
[WARNING STA-0366] port 'CLK' not found.
[WARNING CTS-0083] No clock nets have been found.
[WARNING CTS-0082] No valid clock nets in the design.
```

And timing analysis shows:
```
No paths found.
```

This means:
1. The clock constraint is invalid (port doesn't exist)
2. CTS couldn't identify any clock network to balance
3. No timing paths exist (because there's no valid clock)

## Design

- **Module**: pipelined_adder
- **Inputs**: clk, rst_n, a[31:0], b[31:0], valid_in, op_mode[1:0]
- **Outputs**: result[31:0], valid_out, carry_out, overflow
- **Pipeline stages**: 5 (input reg, lower 16-bit, upper 16-bit, result assembly, output)
- **Clock sinks**: 225 flip-flops

## Files

```
cts_005_clock_confusion/
  run.tcl              # Main CTS flow script
  synth.ys             # Yosys synthesis script
  resources/
    pipelined_adder.v  # Verilog design
    constraints.sdc    # Timing constraints (BUG HERE)
  results/             # Output directory
```

## Task

1. Run `openroad run.tcl` and observe the CTS warnings
2. Find the mismatch between the SDC clock definition and design
3. Fix the constraints.sdc file
4. Verify CTS now builds a proper clock tree

## Success Criteria

- CTS should report clock sinks found (e.g., "Clock net 'clk' has 225 sinks")
- Clock tree buffers should be inserted
- Timing analysis should show valid paths
- WNS should be positive (timing met)

## Hints

Check `hints.md` if you get stuck.
