# Quiz - rte_003: NDR Nightmare

Answer these questions after fixing the puzzle.

---

## Question 1

Why are lower metal layers (M1-M2) congested at 7nm?

- [ ] A) They have fewer routing tracks
- [X] B) They are used for cell internal connections and pins
- [ ] C) They have higher resistance
- [ ] D) They are reserved for clock routing

---

## Question 2

What is the recommended minimum routing layer for ASAP7 signal routing?

- [ ] A) M1
- [ ] B) M2
- [X] C) M4
- [ ] D) M7

---

## Question 3

What happens when you route signals on M2 at 7nm?

- [ ] A) Faster signal propagation
- [X] B) Competition with cell pin connections, causing congestion
- [ ] C) Lower power consumption
- [ ] D) Better timing

---

## Question 4

In the `set_global_routing_layer_adjustment` command, what does a value of 1.0 mean?

- [ ] A) Full capacity available
- [X] B) Layer completely blocked (100% reduction)
- [ ] C) Double capacity
- [ ] D) Layer preferred for routing

---

## Question 5

Which metal layer is typically used for power distribution at advanced nodes?

- [ ] A) M1
- [ ] B) M3
- [ ] C) M5
- [X] D) Top metal (M7 in ASAP7)

---

## Question 6

What is the purpose of the `set_routing_layers -signal` command?

- [ ] A) Set clock routing layers
- [X] B) Define the range of layers available for signal routing
- [ ] C) Block specific layers
- [ ] D) Set power routing layers

---

## Question 7

At advanced nodes, why is M3 still considered "congested"?

- [ ] A) It's used only for clock
- [X] B) It handles local routing between nearby cells
- [ ] C) It has the highest resistance
- [ ] D) It's reserved for power

---

Check your answers in `.solution/quiz_answers.md` after completing the puzzle.
