# Quiz Answers - RTE_002 The Adjustment Agony

---

## Question 1: B
**70% of metal2 routing capacity is blocked/reduced**

Layer adjustment is a capacity reduction factor:
- 0.0 = no reduction (full capacity)
- 0.7 = 70% reduction (only 30% capacity available)
- 1.0 = 100% reduction (layer blocked)

---

## Question 2: B
**Lower layers are congested with cell pins and local connections**

Met1 has:
- Cell I/O pins connecting on this layer
- Power rails within standard cells
- Very short local interconnects

This makes met1 already crowded before signal routing even starts.

---

## Question 3: C
**met1 (lowest layer, cell pins)**

Metal1 is the most congested because:
- All standard cell pins connect on met1
- Internal cell routing uses met1
- Power/ground rails in cells use met1

---

## Question 4: B
**The layer is completely blocked for routing**

Adjustment = 1.0 means 100% capacity reduction, effectively blocking the layer from being used by the global router for signal routing.

---

## Question 5: B
**met1=0.9, met2=0.7, met3=0.4, met4=0.2, met5=0.1**

This follows the correct pattern:
- Lower layers: high adjustment (more blocked)
- Upper layers: low adjustment (more available)

Option A is inverted (the bug in this puzzle).
Option C/D don't account for layer congestion differences.

---

## Question 6: A
**Number of times to rip up and reroute congested areas**

Congestion iterations control how many times the router will:
1. Identify congested areas
2. Rip up problematic routes
3. Re-route to find better paths

More iterations can resolve congestion but take longer.

---

## Question 7: B
**They have fewer cell pin obstructions and local routing**

Upper layers are cleaner because:
- No cell pins on these layers
- No standard cell internal routing
- Only signal routes placed by the global router

This makes them ideal for longer signal routes.

---

## Scoring

- 7/7: Excellent! Ready for advanced routing challenges
- 5-6/7: Good foundation, minor concepts to review
- 3-4/7: Review layer adjustment concepts
- <3/7: Study global routing fundamentals
