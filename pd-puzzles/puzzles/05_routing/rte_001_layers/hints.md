# Hints - RTE_001: The Layer Labyrinth

Try to solve the puzzle yourself first! Use these hints only if stuck.

---

## Hint 1: Understanding the Error

Look at the `set_routing_layers` command. It currently says:
```tcl
set_routing_layers -signal metal1-metal2
```

This means the router can ONLY use metal1 and metal2 for all signal wires. Is that enough for a real design?

---

## Hint 2: Why metal1 is Problematic

Metal1 is the **lowest metal layer**, directly connected to the transistors.

Problems with metal1:
- Already crowded with **cell pin connections**
- Very **narrow** pitch (tracks close together)
- High **resistance** (thin layer)
- Causes **congestion** when used for routing

**Best practice**: Avoid metal1 for signal routing!

---

## Hint 3: How Many Layers?

For signal routing, you typically want **4-5 metal layers**.

Nangate45 layer stack for routing:
```
metal6  ← Good for signals (top signal layer)
metal5  ← Good for signals
metal4  ← Good for signals
metal3  ← Good for signals
metal2  ← Good for signals (bottom signal layer)
metal1  ← AVOID (cell pins only)
```

The command should specify a range like `metal2-metal6`.

---

## Hint 4: The Solution

Change:
```tcl
set_routing_layers -signal metal1-metal2
```

To:
```tcl
set_routing_layers -signal metal2-metal6
```

This gives the router 5 layers (metal2 through metal6) instead of just 2, dramatically reducing congestion.

---

## Summary

| Setting | Layers | Result |
|---------|--------|--------|
| `metal1-metal2` | 2 layers | Congestion, overflow |
| `metal2-metal6` | 5 layers | Clean routing |

**Key insight**: More routing layers = less congestion = successful routing!
