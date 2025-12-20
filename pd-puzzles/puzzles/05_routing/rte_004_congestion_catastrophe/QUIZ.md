# Quiz - Congestion Catastrophe

Test your understanding of global routing and layer adjustment strategy.

---

## Question 1: Layer Adjustment Value
What does `set_global_routing_layer_adjustment met4 1.0` mean?

- [ ] A) met4 has maximum routing capacity
- [X] B) met4 is completely blocked for routing
- [ ] C) met4 is preferred for clock routing
- [ ] D) met4 resistance is set to 1.0 ohms

## Question 2: Lower Metal Congestion
Why are lower metal layers (met1/met2) typically congested?

- [ ] A) They are thinner and have higher resistance
- [X] B) They are used for cell internal wiring and pins
- [ ] C) They are reserved for power distribution
- [ ] D) They have manufacturing defects

## Question 3: Crossbar Routing Challenge
Why is a crossbar switch particularly challenging for routing?

- [ ] A) It has too many flip-flops
- [ ] B) It has no clock tree
- [X] C) Signals cross the entire die with no locality
- [ ] D) It requires analog routing

## Question 4: Adjustment Strategy
What is the correct layer adjustment strategy?

- [ ] A) Block all layers equally with 0.5
- [X] B) High adjustment on lower layers, low on upper layers
- [ ] C) High adjustment on upper layers, low on lower layers
- [ ] D) Set all adjustments to 0.0

## Question 5: Routing Overflow
What causes routing overflow?

- [ ] A) Not enough cells in the design
- [X] B) Routing demand exceeds available track capacity
- [ ] C) Clock frequency too high
- [ ] D) Wrong liberty file format

## Question 6: Upper Metal Advantage
What advantage do upper metal layers (met4/met5) have?

- [ ] A) They are closer to the substrate
- [X] B) They have wider tracks and more routing capacity
- [ ] C) They are always horizontal
- [ ] D) They have zero resistance

## Question 7: The Bug
What was wrong with the layer adjustment configuration?

- [ ] A) met1 adjustment was too low
- [X] B) met4 and met5 were completely blocked (1.0)
- [ ] C) Clock layers were not specified
- [ ] D) The signal layer range was wrong

---

## Answers
Complete this section after solving the puzzle:

Q1: [ ]  Q2: [ ]  Q3: [ ]  Q4: [ ]  Q5: [ ]  Q6: [ ]  Q7: [ ]
