# Hints for PLC_005: Routability Ruin

## Hint 1: Read the Resource Analysis
Look at the routing resources report:
```
Layer     Direction    Original      Derated      Resource
                      Resources     Resources    Reduction (%)
---------------------------------------------------------------
metal2     Vertical    1044214        71022          93.20%
```
93.20% reduction means only 6.8% of tracks are available!

---

## Hint 2: Layer Adjustment Values
The bug is in lines 95-99:
```tcl
set_global_routing_layer_adjustment metal2 0.9
set_global_routing_layer_adjustment metal3 0.9
...
```
0.9 = 90% of capacity is reserved/blocked.

---

## Hint 3: What Layer Adjustment Does
```
layer_adjustment = fraction of capacity to REMOVE
0.9 → remove 90% → only 10% available
0.5 → remove 50% → 50% available
0.3 → remove 30% → 70% available
```

---

## Hint 4: Why Reserve Capacity?
Layer adjustments account for:
- Power/ground stripes blocking tracks
- Clock tree routing
- Manufacturing margins

But 90% is way too aggressive!

---

## Hint 5: Typical Industry Values
```tcl
set_global_routing_layer_adjustment metal2 0.5  # Lower layers more blocked
set_global_routing_layer_adjustment metal3 0.4
set_global_routing_layer_adjustment metal4 0.3
set_global_routing_layer_adjustment metal5 0.2  # Upper layers less blocked
set_global_routing_layer_adjustment metal6 0.2
```

---

## Hint 6: Routability-Driven Placement
You can also help by using:
```tcl
global_placement -density 0.7 -routability_driven
```
This makes placement aware of routing congestion.

---

## Hint 7: Complete Fix
Change lines 95-99 to:
```tcl
set_global_routing_layer_adjustment metal2 0.5
set_global_routing_layer_adjustment metal3 0.4
set_global_routing_layer_adjustment metal4 0.3
set_global_routing_layer_adjustment metal5 0.2
set_global_routing_layer_adjustment metal6 0.2
```
