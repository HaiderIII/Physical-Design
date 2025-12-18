# Quiz - RTE_002 The Adjustment Agony

Answer these questions **BEFORE** checking the solution.

---

## Question 1

What does `set_global_routing_layer_adjustment met2 0.7` mean?

- [ ] A) Metal2 is 70% faster than other layers
- [X] B) 70% of metal2 routing capacity is blocked/reduced
- [ ] C) Metal2 is the 7th preferred layer
- [ ] D) 70% of routes will use metal2

---

## Question 2

Why should lower metal layers (met1, met2) have higher adjustment values?

- [ ] A) Lower layers are wider and need more space
- [X] B) Lower layers are congested with cell pins and local connections
- [ ] C) Lower layers are reserved for power routing
- [ ] D) Lower layers have fewer routing tracks

---

## Question 3

In Sky130, which layer is typically most congested?

- [ ] A) met5 (topmost signal layer)
- [ ] B) met3 (middle layer)
- [X] C) met1 (lowest layer, cell pins)
- [ ] D) All layers are equally congested

---

## Question 4

What happens if you set adjustment = 1.0 for a layer?

- [ ] A) The layer gets maximum priority
- [X] B) The layer is completely blocked for routing
- [ ] C) The layer is only used for clock routing
- [ ] D) The layer capacity is doubled

---

## Question 5

Which is a correct layer adjustment strategy for signal routing?

- [ ] A) met1=0.1, met2=0.2, met3=0.5, met4=0.8, met5=0.9
- [X] B) met1=0.9, met2=0.7, met3=0.4, met4=0.2, met5=0.1
- [ ] C) met1=0.5, met2=0.5, met3=0.5, met4=0.5, met5=0.5
- [ ] D) met1=0.0, met2=0.0, met3=0.0, met4=0.0, met5=0.0

---

## Question 6

What does the `-congestion_iterations` parameter control in global_route?

- [X] A) Number of times to rip up and reroute congested areas
- [ ] B) Maximum number of wires per layer
- [ ] C) Number of metal layers to use
- [ ] D) Maximum wire length allowed

---

## Question 7

Why do upper metal layers (met4, met5) typically have more available capacity?

- [ ] A) They are wider and have more tracks
- [X] B) They have fewer cell pin obstructions and local routing
- [ ] C) They are reserved only for the router
- [ ] D) They have lower resistance

---

## Score Interpretation

Count your correct answers:
- 7/7: Excellent! You understand routing layer management
- 5-6/7: Good understanding, review the missed concepts
- 3-4/7: Review hints.md and PROBLEM.md
- <3/7: Re-study global routing fundamentals

---

Check `.solution/quiz_answers.md` to verify your answers.
