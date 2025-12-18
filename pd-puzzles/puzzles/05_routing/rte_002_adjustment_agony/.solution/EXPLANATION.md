# Solution Explanation - RTE_002 The Adjustment Agony

## The Problem

The original `run.tcl` had inverted layer adjustments:
```tcl
set_global_routing_layer_adjustment met1 0.2
set_global_routing_layer_adjustment met2 0.3
set_global_routing_layer_adjustment met3 0.5
set_global_routing_layer_adjustment met4 0.8
set_global_routing_layer_adjustment met5 0.9
```

This configuration:
- Kept lower layers (met1, met2) mostly available
- Blocked upper layers (met4, met5) almost completely

## The Solution

```tcl
set_global_routing_layer_adjustment met1 0.9
set_global_routing_layer_adjustment met2 0.7
set_global_routing_layer_adjustment met3 0.4
set_global_routing_layer_adjustment met4 0.2
set_global_routing_layer_adjustment met5 0.1
```

## Why This Matters

### Understanding Layer Adjustment

The adjustment value is a **capacity reduction factor**:
- `0.0` = 0% reduction (full capacity available)
- `0.5` = 50% reduction (half capacity)
- `1.0` = 100% reduction (layer blocked)

### Physical Layer Characteristics

| Layer | Characteristics | Recommended Adjustment |
|-------|----------------|----------------------|
| met1 | Cell pins, power rails, very congested | 0.8-1.0 (high) |
| met2 | Local routing, moderate congestion | 0.5-0.7 (medium-high) |
| met3 | Signal routing, some congestion | 0.3-0.5 (medium) |
| met4 | Signal routing, less congested | 0.1-0.3 (low) |
| met5 | Top layer, most available | 0.0-0.2 (very low) |

### Why Lower Layers Are Congested

1. **Cell Pins**: All standard cell I/O pins connect on metal1
2. **Internal Cell Routing**: Cells have internal metal1 connections
3. **Power Rails**: Local VDD/VSS in cells use metal1
4. **Via Density**: Many vias go through lower layers

### Why Upper Layers Are Available

1. **No Cell Obstructions**: Only routing wires, no cell structures
2. **Dedicated to Signal Routing**: Cleaner routing canvas
3. **Thicker Wires**: Lower resistance, good for longer routes

## Routing Strategy

The correct approach:
1. **Discourage met1**: Reserve for cell pins (adjustment 0.9)
2. **Limit met2**: Some local routing okay (adjustment 0.7)
3. **Balance met3**: Moderate use (adjustment 0.4)
4. **Encourage met4-met5**: Use for signal routing (adjustment 0.1-0.2)

## Impact of Wrong Configuration

With inverted adjustments:
- Router tries to use met1/met2 heavily → congestion
- Router avoids met4/met5 → wasted resources
- Results in routing overflow and DRC violations

With correct adjustments:
- Router spreads load to upper layers
- Lower layers reserved for necessary connections
- Cleaner routing with fewer violations

## Best Practices

1. **Start with standard adjustments** for your PDK
2. **Monitor congestion reports** during routing
3. **Adjust iteratively** based on congestion hotspots
4. **Consider clock/signal separation** on different layers
