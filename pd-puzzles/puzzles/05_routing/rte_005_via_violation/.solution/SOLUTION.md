# Solution: RTE_005 - Via Violation

## The Bug

In `run.tcl`, the routing layers are restricted to only metal2 and metal3:

```tcl
set_routing_layers -signal metal2-metal3 -clock metal2-metal3
```

This leaves only 2 layers for ALL routing (signal and clock), which is insufficient.

## Why This Causes Problems

1. **Limited capacity**: Only ~550K tracks available instead of millions
2. **Layer contention**: Signal and clock nets compete for same resources
3. **Via bottleneck**: All layer transitions go through metal2-metal3 via
4. **No direction flexibility**: Only one horizontal + one vertical layer
5. **50 extra iterations**: Router desperately tries to resolve overflow

## The Fix

Expand the routing layer range to use the full metal stack:

```tcl
set_routing_layers -signal metal2-metal6 -clock metal3-metal6

set_global_routing_layer_adjustment metal2 0.5
set_global_routing_layer_adjustment metal3 0.5
set_global_routing_layer_adjustment metal4 0.3
set_global_routing_layer_adjustment metal5 0.2
set_global_routing_layer_adjustment metal6 0.2
```

## After the Fix

```
[INFO GRT-0096] Final congestion report:
Layer         Resource        Demand        Usage (%)    Max H / Max V / Total Overflow
---------------------------------------------------------------------------------------
metal2          230146          2620            1.14%             0 /  0 /  0
metal3          322498          1234            0.38%             0 /  0 /  0
metal4          ...
metal5          ...
metal6          ...
---------------------------------------------------------------------------------------
Total          1500000+         6000            0.40%             0 /  0 /  0
```

No congestion, no extra iterations, routing completes cleanly.

## Metal Layer Stack (Nangate45)

| Layer | Direction | Typical Use |
|-------|-----------|-------------|
| metal1 | Horizontal | Standard cell internal |
| metal2 | Vertical | Local routing |
| metal3 | Horizontal | Short/medium routing |
| metal4 | Vertical | Medium/long routing |
| metal5 | Horizontal | Long routing, power |
| metal6 | Vertical | Power, long signals |

## Quiz Answers

1. **B** - Only 2 metal layers allocated for routing
2. **B** - To resolve routing overflow/congestion
3. **B** - Metal2 routes horizontally, metal3 vertically, etc.
4. **B** - Routing fails with an error
5. **B** - Higher layers have lower resistance for better signal integrity
6. **B** - Expand routing layers from metal2-metal3 to metal2-metal6
7. **B** - The via layer connecting metal2 to metal3
