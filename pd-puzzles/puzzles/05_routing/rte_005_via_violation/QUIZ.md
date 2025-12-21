# RTE_005: Via Violation - Quiz

Test your understanding of this puzzle.

---

## Question 1: Root Cause
What causes the routing congestion in this puzzle?

- [ ] A) Too high placement density
- [X] B) Only 2 metal layers allocated for routing
- [ ] C) Missing clock tree
- [ ] D) Wrong PDK configuration

## Question 2: Extra Iterations
Why does the router run 50 "extra iterations"?

- [ ] A) To optimize wire length
- [X] B) To resolve routing overflow/congestion
- [ ] C) To add more vias
- [ ] D) To balance clock tree

## Question 3: Layer Direction
In a typical PDK, metal layers alternate directions. What does this mean?

- [ ] A) Odd layers are thicker than even layers
- [X] B) Metal2 routes horizontally, metal3 vertically, etc.
- [ ] C) Each layer can only have one net
- [ ] D) Vias are only allowed between odd layers

## Question 4: Congestion Impact
What happens when routing congestion cannot be resolved?

- [ ] A) The tool automatically adds more layers
- [X] B) Routing fails with an error
- [ ] C) The design runs slower
- [ ] D) Power consumption increases

## Question 5: Clock Layer Separation
Why should clock nets use different (higher) metal layers than signals?

- [ ] A) Clocks are always faster
- [X] B) Higher layers have lower resistance for better signal integrity
- [ ] C) It's a PDK requirement
- [ ] D) Clock buffers only connect to upper metals

## Question 6: The Fix
What is the correct fix for this puzzle?

- [ ] A) Reduce placement density
- [X] B) Expand routing layers from metal2-metal3 to metal2-metal6
- [ ] C) Remove the clock constraint
- [ ] D) Increase layer adjustment values

## Question 7: Via Stacking
When only 2 metal layers are used, what becomes a bottleneck?

- [ ] A) The clock buffer
- [X] B) The via layer connecting metal2 to metal3
- [ ] C) The power grid
- [ ] D) The standard cells

---

## Scoring

| Score | Level |
|-------|-------|
| 7/7   | Master |
| 5-6/7 | Advanced |
| 3-4/7 | Intermediate |
| 0-2/7 | Review routing fundamentals |
