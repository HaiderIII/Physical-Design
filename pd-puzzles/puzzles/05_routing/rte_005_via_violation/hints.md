# Hints for RTE_005: Via Violation

## Hint 1: Check the Routing Layers
Look at the `set_routing_layers` command in run.tcl. How many layers are allocated for signal routing?

## Hint 2: Layer Capacity
The congestion report shows:
```
Layer         Resource        Demand
metal2          230146          2620
metal3          322498          3447
```
With only 2 layers available, capacity is very limited.

## Hint 3: Compare with Standard Flow
A typical Nangate45 flow uses metal2-metal6 for signals:
```tcl
set_routing_layers -signal metal2-metal6 -clock metal3-metal6
```

## Hint 4: The Bug Location
Look at line with `set_routing_layers`:
```tcl
set_routing_layers -signal metal2-metal3 -clock metal2-metal3
```
Only metal2 and metal3 are used for ALL routing.

## Hint 5: The Fix
Expand the routing layer range to use more metal layers:
```tcl
set_routing_layers -signal metal2-metal6 -clock metal3-metal6
```

Also add layer adjustments for the additional layers:
```tcl
set_global_routing_layer_adjustment metal4 0.3
set_global_routing_layer_adjustment metal5 0.2
set_global_routing_layer_adjustment metal6 0.2
```

## Why This Matters

1. **Layer alternation**: Metal layers alternate between horizontal and vertical directions. Using only 2 layers limits routing flexibility.

2. **Resource distribution**: More layers = more tracks = less congestion.

3. **Via stacking**: With only 2 layers, all signals must transition through the same via layer (metal2-metal3), creating bottlenecks.

4. **Clock vs Signal**: Clock and signal nets competing for the same 2 layers causes contention.

## Prevention Tips

1. Always use the full routing stack available in the PDK
2. Reserve upper metal layers (metal5-metal6) for long-distance signals
3. Use different layer ranges for clock (higher metals, lower resistance)
4. Check PDK documentation for recommended routing layer usage
