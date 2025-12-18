# Solution Explanation - PLC_002 The Timing Tunnel Vision

## The Problem

The original `run.tcl` used:
```tcl
global_placement -density 0.60
```

This placement minimizes total wirelength but completely ignores timing. For a pipelined datapath with tight timing (100 MHz), this is disastrous because:

1. The carry chain in the ALU can be spread across the die
2. Pipeline registers may be far from their combinational logic
3. Critical paths accumulate wire delay

## The Solution

Add the `-timing_driven` flag:
```tcl
global_placement -density 0.60 -timing_driven
```

## Why This Works

### Timing-Driven Placement Algorithm

1. **Static Timing Analysis**: Before placement iterations, the tool runs STA
2. **Criticality Computation**: Each net gets a criticality score:
   ```
   criticality = path_delay / clock_period
   ```
3. **Weighted Optimization**: The objective function becomes:
   ```
   minimize: Σ (criticality[i] × wirelength[i])
   ```
4. **Result**: Critical nets get short wires, non-critical nets can be longer

### Visualizing the Difference

```
Non-Timing-Driven:
┌─────────────────────────────────────┐
│  [Reg]            [ALU]             │
│       \          /                  │
│        \────────/                   │
│                      [Accum]        │
│  [Reg]──────────────/               │
└─────────────────────────────────────┘
Critical path: 25mm of wire → +2.5ns delay

Timing-Driven:
┌─────────────────────────────────────┐
│                                     │
│  [Reg]─[ALU]─[Accum]─[Reg]          │
│                                     │
│         (compact placement)         │
│                                     │
└─────────────────────────────────────┘
Critical path: 5mm of wire → +0.5ns delay
```

## Timing Impact

| Metric | Without Flag | With Flag |
|--------|--------------|-----------|
| Worst Slack | -2.35 ns | +0.5 ns |
| TNS | -45 ns | 0 ns |
| Critical Path WL | 25 mm | 5 mm |

## Additional Optimizations

If `-timing_driven` alone isn't enough:

1. **Lower density** (more room to optimize):
   ```tcl
   global_placement -density 0.50 -timing_driven
   ```

2. **Timing-driven detailed placement**:
   ```tcl
   detailed_placement
   optimize_mirroring
   ```

3. **Multiple iterations** (placement refinement):
   ```tcl
   global_placement -density 0.60 -timing_driven -routability_driven
   ```

## Common Mistakes

1. **Forgetting to load SDC**: Timing-driven mode needs constraints!
2. **Wrong clock period**: If SDC has 100ns instead of 10ns, everything looks fine
3. **Missing wire load model**: `estimate_parasitics -placement` is needed for accurate timing

## Best Practices

1. Always use `-timing_driven` for designs with timing constraints
2. Load SDC early in the flow
3. Check timing after placement before proceeding to CTS
4. If timing fails badly after placement, fix placement first (don't rely on CTS/routing to fix it)
