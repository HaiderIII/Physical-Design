# SGN_002: The Constraint Crisis

## Difficulty: Intermediate

## PDK: Sky130HD

## Problem Description

You're running timing signoff on a counter design. The script completes but reports "No paths found" for I/O timing analysis. The timing constraints are incomplete!

The SDC file is missing `set_input_delay` and `set_output_delay` constraints, causing I/O paths to be **unconstrained**.

## Symptoms

When you run `openroad run.tcl`, you see:
- "Paths FROM inputs: No paths found"
- "Paths TO outputs: No paths found"
- "SIGNOFF FAILED: Incomplete timing constraints!"

## Your Task

Fix `resources/constraints.sdc` to add proper input and output delay constraints.

## Background

### Why I/O Delays Matter

Without I/O delays, STA doesn't know:
- When inputs arrive relative to the clock
- When outputs need to be ready for downstream logic

This makes I/O timing **unconstrained** - a serious signoff issue!

### Input Delay

```
External           Your
Flip-Flop         Design
    │                │
    Q ────────────── D
         ↑
    external delay
```

`set_input_delay` tells STA how late the input might arrive after the clock edge.

### Output Delay

```
Your              External
Design            Flip-Flop
    │                │
    Q ────────────── D
         ↑
    external setup requirement
```

`set_output_delay` tells STA how early the output must be ready (external setup time).

### SDC Commands

```sdc
# Input arrives 2ns after clock edge
set_input_delay -clock clk 2.0 [get_ports {input1 input2}]

# Output must be ready 2ns before clock edge
set_output_delay -clock clk 2.0 [get_ports output[*]]
```

## Files

- `run.tcl` - Main signoff script
- `resources/counter.v` - 8-bit counter design
- `resources/constraints.sdc` - **FIX THIS FILE** - add I/O delays

## Success Criteria

After fixing:
1. I/O paths appear in timing reports
2. "SIGNOFF PASSED: All timing constraints are complete!"

## Hints

See `hints.md` for progressive hints if you get stuck.

## Verification

Run the script:
```bash
openroad run.tcl
```

Check that:
- Paths FROM inputs show actual timing paths
- Paths TO outputs show actual timing paths
- Signoff status shows PASSED

Good luck!
