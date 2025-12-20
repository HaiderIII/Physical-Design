# Solution - Congestion Catastrophe

## The Bug

The layer adjustment configuration was inverted - it blocked the upper metal layers that have the most routing capacity:

```tcl
set_global_routing_layer_adjustment met4 1.0  # WRONG: Completely blocked!
set_global_routing_layer_adjustment met5 1.0  # WRONG: Completely blocked!
```

With adjustment = 1.0, these layers have **zero routing capacity**.

## The Fix

Use proper adjustment values that reflect natural congestion:

```tcl
set_global_routing_layer_adjustment met1 0.8  # High - cell internal wiring
set_global_routing_layer_adjustment met2 0.7  # High - cell pins
set_global_routing_layer_adjustment met3 0.5  # Medium - local routing
set_global_routing_layer_adjustment met4 0.3  # Low - global routing available
set_global_routing_layer_adjustment met5 0.2  # Lowest - most capacity
```

## Explanation

### Metal Layer Characteristics

In a typical CMOS process, metal layers have different properties:

| Layer | Width | Pitch | Primary Use |
|-------|-------|-------|-------------|
| met1 | Thin | Small | Cell internal wiring |
| met2 | Thin | Small | Cell pins, local routing |
| met3 | Medium | Medium | Local/intermediate |
| met4 | Wide | Large | Global routing |
| met5 | Widest | Largest | Power, global signals |

### Why Upper Layers Have More Capacity

1. **Wider tracks**: More current capacity, lower resistance
2. **Larger pitch**: Fewer tracks per unit length, but less coupling
3. **Less congestion**: Not used for cell internals
4. **Designed for long routes**: Cross-die connections

### The Crossbar Problem

A crossbar switch has a unique routing challenge:
- Every input must potentially reach every output
- Signals cross the entire die
- No spatial locality to exploit
- Maximum wire crossings

This creates massive demand for global routing resources (met4/met5). Blocking these layers forces all traffic onto the already-congested lower layers, causing overflow.

### Layer Adjustment Strategy

The adjustment value represents how much capacity to **remove**:

| Value | Interpretation | Use For |
|-------|---------------|---------|
| 0.0 | Full capacity | Upper layers, power |
| 0.3 | 30% reduction | Global routing layers |
| 0.5 | Half capacity | Intermediate layers |
| 0.8 | 80% reduction | Congested layers |
| 1.0 | Blocked | Reserved layers |

**Rule of thumb**: Higher adjustment for lower layers, lower adjustment for upper layers.

## Verification

After fixing, the routing should complete with:
- 0 overflow
- No GR DRC violations
- Positive slack (timing met)

---

## Quiz Answers

1. **B** - met4 is completely blocked for routing
2. **B** - They are used for cell internal wiring and pins
3. **C** - Signals cross the entire die with no locality
4. **B** - High adjustment on lower layers, low on upper layers
5. **B** - Routing demand exceeds available track capacity
6. **B** - They have wider tracks and more routing capacity
7. **B** - met4 and met5 were completely blocked (1.0)
