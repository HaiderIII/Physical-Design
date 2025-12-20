# Quiz - Slew Spiral

Test your understanding of slew constraints and timing sign-off.

---

## Question 1: Slew Definition
What is "slew" or "transition time" in digital circuits?

- [ ] A) The clock frequency
- [X] B) The time for a signal to change between logic levels
- [ ] C) The propagation delay through a gate
- [ ] D) The hold time requirement

## Question 2: Slow Slew Impact
What problems can excessive (slow) slew cause?

- [ ] A) Reduced power consumption
- [ ] B) Faster gate switching
- [X] C) Increased delay and timing uncertainty
- [ ] D) Smaller die area

## Question 3: SDC Command
Which SDC command sets the maximum allowed transition time?

- [ ] A) set_max_delay
- [X] B) set_max_transition
- [ ] C) set_max_fanout
- [ ] D) set_input_transition

## Question 4: Missing Constraint
Why did `report_check_types -max_slew` show no violations initially?

- [ ] A) The design has perfect slew
- [ ] B) The routing was not complete
- [X] C) No set_max_transition constraint was defined
- [ ] D) The clock was too slow

## Question 5: Typical Value
For Sky130HD, what is a reasonable max_transition value?

- [ ] A) 0.001 ns (1 ps)
- [X] B) 1.0 ns
- [ ] C) 100 ns
- [ ] D) 1 us

## Question 6: Fixing Slew
How does the tool fix slew violations?

- [ ] A) By changing the clock frequency
- [X] B) By inserting buffers to strengthen weak drivers
- [ ] C) By removing cells
- [ ] D) By changing the metal layers

## Question 7: The Bug
What was missing in the original constraints?

- [ ] A) Clock definition
- [ ] B) Input/output delays
- [X] C) set_max_transition constraint
- [ ] D) set_clock_uncertainty

---

## Answers
Complete this section after solving the puzzle:

Q1: [ ]  Q2: [ ]  Q3: [ ]  Q4: [ ]  Q5: [ ]  Q6: [ ]  Q7: [ ]
