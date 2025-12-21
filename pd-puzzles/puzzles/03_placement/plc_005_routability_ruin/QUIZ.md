# PLC_005: Routability Ruin - Quiz

Test your understanding of this puzzle.

---

## Question 1: Understanding Layer Adjustment
What does `set_global_routing_layer_adjustment metal2 0.9` mean?

- [ ] A) Use 90% of metal2 capacity for routing
- [X] B) Reserve 90% of metal2 capacity (only 10% available)
- [ ] C) Increase metal2 capacity by 90%
- [ ] D) Set metal2 routing pitch to 0.9um

## Question 2: Resource Reduction
In the log, "Resource Reduction: 93.20%" for metal2 means:

- [ ] A) 93.2% of nets are routed on metal2
- [X] B) Only 6.8% of metal2 tracks are available for routing
- [ ] C) Metal2 is 93.2% utilized
- [ ] D) 93.2% of metal2 vias are used

## Question 3: Extra Iterations
Why does the router run "extra iterations"?

- [ ] A) To optimize wire length
- [X] B) To resolve routing overflow/congestion
- [ ] C) To add more vias
- [ ] D) To balance clock tree

## Question 4: Congestion Root Cause
In this puzzle, congestion is caused by:

- [ ] A) Too many clock buffers
- [X] B) Layer adjustments reserving too much capacity
- [ ] C) Incorrect PDN configuration
- [ ] D) Missing timing constraints

## Question 5: Safe Layer Adjustment Values
What is a typical safe range for layer adjustment?

- [ ] A) 0.0 to 0.1 (0-10% reduction)
- [X] B) 0.3 to 0.5 (30-50% reduction)
- [ ] C) 0.7 to 0.9 (70-90% reduction)
- [ ] D) 0.95 to 1.0 (95-100% reduction)

## Question 6: Placement Impact
How can placement affect routing congestion?

- [X] A) By clustering cells in congested areas
- [ ] B) By using wrong cell libraries
- [ ] C) By adding too many buffers
- [ ] D) By setting wrong clock period

## Question 7: The Fix
To fix this puzzle, you should:

- [ ] A) Increase floorplan utilization
- [X] B) Reduce layer adjustment values and/or enable routability_driven placement
- [ ] C) Add more metal layers
- [ ] D) Remove timing constraints

---

## Scoring

| Score | Level |
|-------|-------|
| 7/7   | Master |
| 5-6/7 | Advanced |
| 3-4/7 | Intermediate |
| 0-2/7 | Review routing fundamentals |
