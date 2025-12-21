# Solution: PLC_005 - Routability Ruin

## The Bug

The layer adjustment values are set to 0.9 (90% reduction):

```tcl
set_global_routing_layer_adjustment metal2 0.9
set_global_routing_layer_adjustment metal3 0.9
set_global_routing_layer_adjustment metal4 0.9
set_global_routing_layer_adjustment metal5 0.9
set_global_routing_layer_adjustment metal6 0.9
```

This leaves only 10% of routing resources available on each layer.

## Why This Causes Problems

1. **Severe resource reduction**: 90% of tracks are blocked
2. **Routing demand exceeds supply**: Even with low utilization, nets can't be routed
3. **Infinite loop**: Router keeps trying to resolve overflow
4. **Clock NDR disabled**: Router desperately disables clock spacing rules

## The Fix

Use reasonable layer adjustment values:

```tcl
set_global_routing_layer_adjustment metal2 0.5
set_global_routing_layer_adjustment metal3 0.4
set_global_routing_layer_adjustment metal4 0.3
set_global_routing_layer_adjustment metal5 0.2
set_global_routing_layer_adjustment metal6 0.2
```

**Explanation**:
- Lower layers (metal2/3): More blocked by power stripes, local routing
- Upper layers (metal5/6): Less blocked, used for long-distance signals

## Optional Enhancement

Enable routability-driven placement:

```tcl
global_placement -density 0.7 -routability_driven
```

This makes the placer aware of potential routing congestion.

## Layer Adjustment Guidelines

| Adjustment Value | Resources Available | Use Case |
|------------------|--------------------|----|
| 0.0 | 100% | No blocking |
| 0.2-0.3 | 70-80% | Upper metal layers |
| 0.4-0.5 | 50-60% | Middle layers |
| 0.6-0.8 | 20-40% | Heavy power mesh |
| 0.9+ | <10% | Almost never use! |

## Quiz Answers

1. **B** - Reserve 90% of capacity (only 10% available)
2. **B** - Only 6.8% of metal2 tracks are available
3. **B** - To resolve routing overflow/congestion
4. **B** - Layer adjustments reserving too much capacity
5. **B** - 0.3 to 0.5 (30-50% reduction)
6. **A** - By clustering cells in congested areas
7. **B** - Reduce layer adjustment values and/or enable routability_driven placement
