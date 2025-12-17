# Explanation - RTE_001: The Layer Labyrinth

## The Bug

The original `run.tcl` used only 2 metal layers for signal routing:

```tcl
# WRONG - Only 2 layers, metal1 is congested
set_routing_layers -signal metal1-metal2
```

## The Fix

Use 5 metal layers, avoiding metal1:

```tcl
# CORRECT - 5 layers, avoids congested metal1
set_routing_layers -signal metal2-metal6
```

---

## Why This Matters

### Metal Layer Stack

```
Layer     | Direction | Typical Use          | Routing?
----------|-----------|----------------------|---------
metal10   | H         | Top power            | No
metal9    | V         | Power distribution   | No
metal8    | H         | Power distribution   | No
metal7    | V         | Clock/power          | Sometimes
metal6    | H         | Signal routing       | ✓ Yes
metal5    | V         | Signal routing       | ✓ Yes
metal4    | H         | Signal routing       | ✓ Yes
metal3    | V         | Signal routing       | ✓ Yes
metal2    | H         | Signal routing       | ✓ Yes
metal1    | V         | Cell pins/local      | ✗ Avoid
```

### Why Metal1 is Problematic

```
                Cell A                    Cell B
            ┌───────────┐            ┌───────────┐
            │  ┌─┐ ┌─┐  │            │  ┌─┐ ┌─┐  │
 metal1 →   │  │█│ │█│  │───────────→│  │█│ │█│  │
            │  └─┘ └─┘  │  This is   │  └─┘ └─┘  │
            │   pins    │  BLOCKED   │   pins    │
            └───────────┘            └───────────┘
```

Metal1 is **already used** for:
- Connecting transistors to cell pins
- Internal cell routing
- Local power connections

Adding global signal routing to metal1 = **guaranteed congestion**.

### Congestion Visualization

```
With metal1-metal2 only (WRONG):
┌─────────────────────────────────────┐
│ █████████████████████████████████ │ ← metal2 FULL
│ █████████████████████████████████ │ ← metal1 FULL
│         OVERFLOW! ❌               │
└─────────────────────────────────────┘

With metal2-metal6 (CORRECT):
┌─────────────────────────────────────┐
│ ████░░░░░░░░░░░░░░████░░░░░░░░░░░ │ ← metal6 OK
│ ░░░░████░░░░████░░░░░░████░░░░███ │ ← metal5 OK
│ ████░░░░████░░░░████░░░░░░████░░░ │ ← metal4 OK
│ ░░░░████░░░░████░░░░████░░░░████░ │ ← metal3 OK
│ ████░░░░████░░░░████░░░░████░░░░░ │ ← metal2 OK
│              ✓ ROUTED              │
└─────────────────────────────────────┘
```

---

## Routing Flow in OpenROAD

### 1. Set Routing Layers
```tcl
set_routing_layers -signal metal2-metal6
```

### 2. Adjust Layer Capacity (Optional)
```tcl
set_global_routing_layer_adjustment metal2 0.7  ;# 30% reserved
set_global_routing_layer_adjustment metal3 0.5  ;# 50% reserved
```

### 3. Global Routing
```tcl
global_route -congestion_iterations 50
```
- Divides chip into **GCells** (global cells)
- Finds coarse paths through GCells
- Generates **routing guides**

### 4. Detailed Routing
```tcl
detailed_route -bottom_routing_layer metal2 \
               -top_routing_layer metal6 \
               -output_drc "drc.rpt"
```
- Assigns **exact tracks** within guides
- Creates actual **wire geometries**
- Reports **DRC violations**

---

## Key Parameters

| Parameter | Description | Typical Value |
|-----------|-------------|---------------|
| `-signal` | Layers for signal nets | metal2-metal6 |
| `-clock` | Layers for clock nets | metal3-metal5 |
| `-congestion_iterations` | GR refinement iterations | 30-100 |
| `layer_adjustment` | Reduce layer capacity | 0.5-0.8 |

---

## Common Routing Issues

### 1. Congestion (Overflow)
**Cause**: Not enough routing resources
**Fix**: Add more layers, reduce utilization

### 2. DRC Violations
**Cause**: Spacing/width rules violated
**Fix**: More iterations, different layer config

### 3. Open Nets
**Cause**: Cannot connect all pins
**Fix**: Check blockages, add layers

### 4. Short Circuits
**Cause**: Wires too close together
**Fix**: Increase spacing, use different layers

---

## Industry Best Practices

1. **Reserve metal1** for cell connections only
2. **Use 4-6 layers** for typical signal routing
3. **Reserve top layers** for power/clock
4. **Apply layer adjustments** for realistic modeling
5. **Run DRC** after detailed routing
6. **Check timing** with extracted parasitics

---

## Further Reading

- Global vs Detailed Routing algorithms
- Metal layer properties (resistance, capacitance)
- DRC rules and spacing requirements
- Congestion analysis and optimization
