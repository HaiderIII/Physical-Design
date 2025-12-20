# Hints - Congestion Catastrophe

## Hint 1: Understanding the Design
<details>
<summary>Click to reveal</summary>

The crossbar switch has a 4x4 interconnect matrix:
- 4 input ports × 8 bits = 32 input registers
- 4 output ports × 8 bits = 32 output registers
- 36 4:1 muxes connecting all inputs to all outputs

This creates a "mesh" of wires where signals from any corner need to reach any other corner. Unlike a simple pipeline, the crossbar has **no locality** - wires cross the entire die.
</details>

## Hint 2: Layer Adjustment Meaning
<details>
<summary>Click to reveal</summary>

The `set_global_routing_layer_adjustment` command reduces available routing capacity:

| Adjustment | Available Capacity |
|------------|-------------------|
| 0.0 | 100% (full capacity) |
| 0.5 | 50% capacity |
| 0.8 | 20% capacity |
| 1.0 | 0% (layer blocked!) |

A value of 1.0 means the layer is **completely blocked** for routing.
</details>

## Hint 3: Examine the Current Configuration
<details>
<summary>Click to reveal</summary>

Look at the layer adjustments in `run.tcl`:
```tcl
set_global_routing_layer_adjustment met1 0.8
set_global_routing_layer_adjustment met2 0.7
set_global_routing_layer_adjustment met3 0.5
set_global_routing_layer_adjustment met4 1.0  # ← Blocked!
set_global_routing_layer_adjustment met5 1.0  # ← Blocked!
```

met4 and met5 are completely blocked! These are the layers with the **most routing capacity**.
</details>

## Hint 4: Metal Layer Characteristics
<details>
<summary>Click to reveal</summary>

In a typical metal stack:

| Layer | Characteristics |
|-------|-----------------|
| met1 | Thin, high R. Cell internal wiring. Very congested. |
| met2 | Cell pins, local routing. Congested. |
| met3 | Local/intermediate routing. Moderate capacity. |
| met4 | Wide tracks, global routing. **High capacity.** |
| met5 | Widest tracks, power/global. **Highest capacity.** |

Blocking met4/met5 forces ALL routing onto the already-congested lower layers!
</details>

## Hint 5: The Correct Strategy
<details>
<summary>Click to reveal</summary>

Layer adjustments should reflect **natural congestion**:
- Lower layers (met1/met2): Already congested with cell pins → high adjustment (reduce capacity)
- Upper layers (met4/met5): Naturally available → low adjustment (keep capacity)

The current config has it **backwards** - it blocks the layers with most capacity.
</details>

## Hint 6: Solution
<details>
<summary>Click to reveal</summary>

Fix the layer adjustments to follow proper strategy:
```tcl
set_global_routing_layer_adjustment met1 0.8   # Keep - cell internal
set_global_routing_layer_adjustment met2 0.7   # Keep - cell pins
set_global_routing_layer_adjustment met3 0.5   # Keep - moderate
set_global_routing_layer_adjustment met4 0.3   # FIX: Was 1.0
set_global_routing_layer_adjustment met5 0.2   # FIX: Was 1.0
```

This allows the router to use met4/met5 for global signal routing.
</details>
