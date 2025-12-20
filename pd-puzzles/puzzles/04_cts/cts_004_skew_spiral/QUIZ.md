# Quiz - Skew Spiral

Test your understanding of clock tree synthesis and wire RC.

---

## Question 1: Wire RC Purpose
Why is wire RC important for CTS?

- [ ] A) It determines the color of the wires in the layout
- [X] B) It enables accurate delay estimation for buffer sizing and skew calculation
- [ ] C) It controls the number of clock sinks
- [ ] D) It sets the clock frequency

## Question 2: Clock Wire Layer
Why are higher metal layers preferred for clock routing?

- [ ] A) They are easier to see in the layout viewer
- [X] B) They have lower resistance and capacitance per unit length
- [ ] C) They are closer to the flip-flops
- [ ] D) They use less area

## Question 3: set_wire_rc Command
What does the `-clock` flag in `set_wire_rc -clock -layer met3` specify?

- [ ] A) The clock frequency
- [X] B) That these RC values apply to clock nets specifically
- [ ] C) The clock source location
- [ ] D) The clock buffer type

## Question 4: Warning Meaning
What does the warning "EST-0027: no estimated parasitics" indicate?

- [ ] A) The design has no parasitic capacitance
- [X] B) Wire RC values are not configured, using default models
- [ ] C) The PDK is corrupted
- [ ] D) Clock tree synthesis failed

## Question 5: Impact of Missing Wire RC
What happens if CTS runs without proper wire RC?

- [ ] A) The design will not compile
- [X] B) Buffer sizing and skew estimation may be inaccurate
- [ ] C) All flip-flops will be removed
- [ ] D) The clock will stop working

## Question 6: Command Placement
When should `set_wire_rc -clock` be called?

- [ ] A) After routing
- [X] B) Before clock_tree_synthesis
- [ ] C) After write_def
- [ ] D) Before read_liberty

## Question 7: The Bug
What was missing in this puzzle?

- [ ] A) Clock definition in SDC
- [X] B) set_wire_rc -clock command before CTS
- [ ] C) Buffer list for CTS
- [ ] D) Floorplan initialization

---

## Answers
Complete this section after solving the puzzle:

Q1: [ ]  Q2: [ ]  Q3: [ ]  Q4: [ ]  Q5: [ ]  Q6: [ ]  Q7: [ ]
