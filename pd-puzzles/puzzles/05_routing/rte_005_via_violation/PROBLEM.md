# RTE_005: Via Violation

## Level: Master

## Objective

Debug a routing flow that fails with congestion errors due to insufficient routing layer allocation.

## Background

Global routing assigns nets to routing layers based on the `set_routing_layers` command. Each layer has:
- A preferred direction (horizontal or vertical)
- Limited track capacity
- Connection to adjacent layers via vias

When too few layers are allocated for routing, or when signal and clock compete for the same limited resources, congestion occurs.

## Problem Description

Running the design produces:

```
[INFO GRT-0101] Running extra iterations to remove overflow.
[INFO GRT-0102] Start extra iteration 1/50
...
[INFO GRT-0102] Start extra iteration 50/50
[ERROR GRT-0116] Global routing finished with congestion.
```

The router runs 50 extra iterations trying to resolve congestion but fails. The congestion report shows:

```
Layer         Resource        Demand        Usage (%)    Max H / Max V / Total Overflow
---------------------------------------------------------------------------------------
metal3          322498          3447            1.07%             1 /  0 /  3
---------------------------------------------------------------------------------------
Total           552644          6067            1.10%             1 /  0 /  3
```

## Design

- **Module**: shift_register
- **Function**: 64-bit shift register with parallel load
- **Inputs**: clk, rst_n, shift_en, load_en, shift_dir, data_in[63:0], serial_in
- **Outputs**: data_out[63:0], serial_out_left, serial_out_right
- **Registers**: 128 flip-flops creating long routing chains

## Files

```
rte_005_via_violation/
  run.tcl              # Main routing flow script (BUG HERE)
  synth.ys             # Yosys synthesis script
  resources/
    shift_register.v   # Verilog design
    constraints.sdc    # Timing constraints
  results/             # Output directory
```

## Task

1. Run `openroad run.tcl` and observe the routing congestion
2. Analyze the `set_routing_layers` configuration
3. Identify why the router cannot find enough resources
4. Fix the routing layer allocation
5. Verify routing completes without congestion

## Success Criteria

- No routing congestion errors
- Global routing completes without extra iterations (or minimal iterations)
- Total overflow should be 0
- Design should route successfully

## Hints

Check `hints.md` if you get stuck.
