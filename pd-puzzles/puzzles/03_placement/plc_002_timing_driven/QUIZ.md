# Quiz - PLC_002 The Timing Tunnel Vision

Answer these questions **BEFORE** checking the solution.

---

## Question 1

What does the default `global_placement` command optimize for?

- [ ] A) Timing slack
- [ ] B) Power consumption
- [X] C) Total wirelength (HPWL)
- [ ] D) Routing congestion

---

## Question 2

What flag enables timing-driven placement in OpenROAD?

- [ ] A) `-optimize_timing`
- [X] B) `-timing_driven`
- [ ] C) `-use_sdc`
- [ ] D) `-critical_path`

---

## Question 3

For timing-driven placement to work, what must be loaded BEFORE placement?

- [ ] A) DEF file with pre-placed cells
- [X] B) Timing constraints (SDC file)
- [ ] C) Routing information
- [ ] D) Power grid

---

## Question 4

In timing-driven placement, what is "net criticality"?

- [ ] A) The number of fanouts on a net
- [X] B) How much delay the net contributes to timing violations
- [ ] C) The physical length of the wire
- [ ] D) The capacitance of the net

---

## Question 5

A path has 8ns total delay and 2ns of remaining slack. The target is 10ns. What is the approximate criticality?

- [ ] A) 0.2 (low - plenty of slack)
- [X] B) 0.8 (high - near critical)
- [ ] C) 1.0 (maximum - no slack)
- [ ] D) 0.0 (not on any path)

---

## Question 6

Why does non-timing-driven placement hurt pipelined designs particularly badly?

- [ ] A) Pipelines have more cells
- [X] B) Carry chains and datapath structures become long wires when placed randomly
- [ ] C) Pipeline registers use more power
- [ ] D) Pipelines need more routing layers

---

## Question 7

After enabling timing-driven placement, timing still fails. What else could help?

- [ ] A) Lower the placement density
- [ ] B) Run multiple placement iterations
- [ ] C) Check if clock constraints are correct
- [X] D) All of the above

---

## Score Interpretation

Count your correct answers:
- 7/7: Excellent! You understand timing-driven placement
- 5-6/7: Good understanding, review the concepts you missed
- 3-4/7: Review the hints and PROBLEM.md
- <3/7: Re-read the material and experiment more

---

Check `.solution/quiz_answers.md` to verify your answers.
