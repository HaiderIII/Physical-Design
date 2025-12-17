# Hints - SGN_001: The Timing Terror

Try to solve the puzzle yourself first! Use these hints only if stuck.

---

## Hint 1: Look for Warnings

Run `openroad run.tcl` and look carefully at the output. There's a **WARNING** message that tells you exactly what's wrong.

The warning mentions something about "parasitics" and "wire load models". What does that mean?

---

## Hint 2: What's Missing?

Look at the timing signoff section (around line 160-170). The script does routing, then immediately runs timing analysis. What step is missing between routing and timing?

After routing, the wires have:
- **Resistance** (R) - causes voltage drop
- **Capacitance** (C) - causes delay

These RC values need to be **extracted** before timing analysis.

---

## Hint 3: The Missing Command

OpenROAD has a command to estimate parasitics from the routing:

```tcl
estimate_parasitics -???
```

What parameter should you use? Think about what type of routing we just completed.

Options:
- `-placement` : Use placement-based estimation
- `-global_routing` : Use global routing for estimation

---

## Hint 4: Why It Matters

Without parasitic estimation:
```
Wire delay = 0 (ideal wire)
Timing looks BETTER than reality
False "passing" timing
```

With parasitic estimation:
```
Wire delay = f(R, C, length)
Timing is REALISTIC
Accurate signoff
```

The command you need is:
```tcl
estimate_parasitics -global_routing
```

---

## Hint 5: The Solution

Add these lines BEFORE the timing reports (around line 167):

```tcl
# Define wire RC values
set_wire_rc -signal -resistance 1.0e-03 -capacitance 1.0e-03

# Extract parasitics from routing
estimate_parasitics -global_routing
```

This tells OpenROAD to:
1. Use the defined RC values per unit length
2. Look at the global routing to get actual wire lengths
3. Calculate total wire R and C for each net
4. Use these values for timing analysis

---

## Summary

| Without Parasitics | With Parasitics |
|-------------------|-----------------|
| Ideal wires (R=0, C=0) | Realistic RC values |
| Optimistic timing | Accurate timing |
| False passing | True signoff |

**Key insight**: Always estimate parasitics before timing signoff!
