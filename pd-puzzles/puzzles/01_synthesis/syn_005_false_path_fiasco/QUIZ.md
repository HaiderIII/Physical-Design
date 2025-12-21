# Quiz - False Path Fiasco

Test your understanding of false path constraints.

---

## Question 1: False Path Purpose
What is the purpose of `set_false_path`?

- [ ] A) Speed up the design
- [X] B) Exclude paths from timing analysis
- [ ] C) Fix timing violations
- [ ] D) Add more timing margin

## Question 2: Valid False Path
Which of these is a legitimate use of `set_false_path`?

- [ ] A) Exclude all data paths
- [X] B) Exclude asynchronous reset paths
- [ ] C) Exclude clock paths
- [ ] D) Exclude all outputs

## Question 3: Wildcard Danger
Why is `set_false_path -from [get_ports *rst*]` dangerous?

- [ ] A) It's too slow
- [X] B) It may match unintended ports like "burst_mode"
- [ ] C) It causes routing errors
- [ ] D) It breaks the clock tree

## Question 4: Hidden Problem
What's the danger of overly broad false paths?

- [ ] A) Design takes longer to compile
- [X] B) Critical timing violations are hidden from analysis
- [ ] C) Power consumption increases
- [ ] D) Area increases

## Question 5: Silicon Failure
Why did the chip fail in silicon despite "passing" timing?

- [ ] A) The PDK was wrong
- [X] B) Timing paths were incorrectly excluded from analysis
- [ ] C) The clock was too fast
- [ ] D) The routing was bad

## Question 6: Debugging Approach
How can you check what ports match a wildcard pattern?

- [ ] A) Run synthesis again
- [X] B) Use `get_ports *pattern*` in TCL
- [ ] C) Check the routing log
- [ ] D) Look at the floorplan

## Question 7: The Fix
What's the correct way to exclude only the async reset?

- [ ] A) `set_false_path -from [get_ports *rst*]`
- [X] B) `set_false_path -from [get_ports rst_n]`
- [ ] C) `set_false_path -from [all_inputs]`
- [ ] D) `set_false_path -from [get_clocks]`

---

## Answers
Complete this section after solving the puzzle:

Q1: [ ]  Q2: [ ]  Q3: [ ]  Q4: [ ]  Q5: [ ]  Q6: [ ]  Q7: [ ]
