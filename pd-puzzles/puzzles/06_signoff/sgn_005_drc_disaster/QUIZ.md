# SGN_005: DRC Disaster - Quiz

Test your understanding of this puzzle.

---

## Question 1: Violation Type
What does a fanout violation indicate?

- [ ] A) Clock is too fast
- [X] B) One driver is connected to too many sinks
- [ ] C) Power supply is insufficient
- [ ] D) Routing is congested

## Question 2: Max Transition
What happens when max_transition is violated?

- [ ] A) Setup timing fails
- [X] B) Signal edges are too slow, causing noise and timing uncertainty
- [ ] C) Power consumption increases
- [ ] D) Clock skew increases

## Question 3: Repair Command
Which OpenROAD command fixes DRC violations?

- [ ] A) fix_violations
- [ ] B) repair_timing
- [X] C) repair_design
- [ ] D) buffer_ports

## Question 4: Violation Format
In the report `rst_n  5  47  -42 (VIOLATED)`, what do the numbers mean?

- [X] A) limit=5, actual=47, slack=-42
- [ ] B) pin_count=5, net_count=47, delay=-42
- [ ] C) min=5, max=47, average=-42
- [ ] D) width=5, length=47, area=-42

## Question 5: Fix Method
How does repair_design fix high fanout?

- [ ] A) Increases clock frequency
- [X] B) Inserts buffers to split the load
- [ ] C) Removes extra connections
- [ ] D) Changes cell placement

## Question 6: Capacitance Violation
A capacitance violation means:

- [ ] A) Wire is too long
- [X] B) Load exceeds driver capability
- [ ] C) Power grid is weak
- [ ] D) Clock tree is unbalanced

## Question 7: Signoff Requirement
Why must DRC violations be fixed before tapeout?

- [ ] A) They cause compilation errors
- [X] B) They indicate potential silicon failures
- [ ] C) They increase simulation time
- [ ] D) They are cosmetic issues only

---

## Scoring

| Score | Level |
|-------|-------|
| 7/7   | Master |
| 5-6/7 | Advanced |
| 3-4/7 | Intermediate |
| 0-2/7 | Review signoff fundamentals |
