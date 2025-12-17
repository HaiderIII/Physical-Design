# Quiz Answers - RTE_001: The Layer Labyrinth

---

## Question 1: Metal Layer Purpose

**Why should you avoid using metal1 for signal routing?**

✅ **B) Metal1 is already crowded with cell pin connections**

**Explanation:** Metal1 is the lowest metal layer, directly above the transistors. It's primarily used for:
- Connecting transistor gates/drains/sources to cell pins
- Internal cell routing
- Local connections within standard cells

Using metal1 for global signal routing causes severe congestion because it's already heavily utilized.

---

## Question 2: Layer Range

**In the command `set_routing_layers -signal metal2-metal6`, how many routing layers are available?**

✅ **C) 5 layers**

**Explanation:** The range metal2-metal6 includes:
- metal2
- metal3
- metal4
- metal5
- metal6

That's 5 layers total (6 - 2 + 1 = 5).

---

## Question 3: Congestion Cause

**What happens when you limit routing to only 2 metal layers?**

✅ **C) Severe congestion and routing failures**

**Explanation:** With only 2 layers:
- All signals compete for the same limited tracks
- Horizontal and vertical routes interfere
- Router cannot find valid paths
- Results in overflow, DRC violations, or complete failure

More layers = more routing resources = less congestion.

---

## Question 4: Layer Direction

**In most process technologies, metal layers alternate direction. Why?**

✅ **B) Allows efficient horizontal and vertical routing**

**Explanation:** Metal layers typically alternate:
```
metal6: Horizontal  ═══════
metal5: Vertical    ║║║║║║║
metal4: Horizontal  ═══════
metal3: Vertical    ║║║║║║║
metal2: Horizontal  ═══════
```

This allows signals to change direction by switching layers (using vias), enabling efficient Manhattan routing.

---

## Question 5: Global vs Detailed Routing

**What is the difference between global routing and detailed routing?**

✅ **B) Global plans routes coarsely, detailed assigns exact tracks**

**Explanation:**
- **Global routing**: Divides the chip into regions (GCells), finds coarse paths through regions
- **Detailed routing**: Assigns exact metal tracks and creates actual wire geometries

Think of it as: Global = highway planning, Detailed = street-level navigation.

---

## Question 6: Layer Adjustment

**What does `set_global_routing_layer_adjustment metal1 0.8` do?**

✅ **B) Reduces metal1's available routing capacity by 20%**

**Explanation:** Layer adjustment of 0.8 means:
- Only 80% of metal1's tracks are available for routing
- 20% is "reserved" (for blockages, power, etc.)
- Helps model real-world constraints where not all tracks are usable

This makes the router more conservative and realistic.

---

## Score Interpretation

| Score | Level | Recommendation |
|-------|-------|----------------|
| 6/6 | Expert | You understand routing configuration perfectly |
| 4-5/6 | Good | Review the concepts you missed |
| 3/6 | Fair | Re-read PROBLEM.md and hints.md |
| <3/6 | Needs Work | Study routing fundamentals before proceeding |

---

## Key Takeaways

1. **Avoid metal1** for signal routing - it's for cell pins
2. **Use multiple layers** (typically metal2-metal6) for signals
3. **Alternating directions** enable efficient routing
4. **Global routing** plans, **detailed routing** executes
5. **Layer adjustments** model real-world capacity constraints

---

**Next puzzle:** Try `rte_002_*` for more advanced routing concepts!
