# Quiz - RTE_001: The Layer Labyrinth

Answer these questions to validate your understanding.
Check your answers in `.solution/quiz_answers.md` after completing the quiz.

---

## Question 1: Metal Layer Purpose

Why should you avoid using metal1 for signal routing?

- [ ] A) Metal1 is too expensive
- [x] B) Metal1 is already crowded with cell pin connections
- [ ] C) Metal1 has better performance
- [ ] D) There is no reason to avoid metal1

---

## Question 2: Layer Range

In the command `set_routing_layers -signal metal2-metal6`, how many routing layers are available?

- [ ] A) 2 layers
- [ ] B) 4 layers
- [x] C) 5 layers
- [ ] D) 6 layers

---

## Question 3: Congestion Cause

What happens when you limit routing to only 2 metal layers?

- [ ] A) Routing is faster
- [ ] B) Power consumption decreases
- [x] C) Severe congestion and routing failures
- [ ] D) Better timing performance

---

## Question 4: Layer Direction

In most process technologies, metal layers alternate direction. Why?

- [ ] A) It looks better visually
- [x] B) Allows efficient horizontal and vertical routing
- [ ] C) Reduces manufacturing cost
- [] D) Required by law

---

## Question 5: Global vs Detailed Routing

What is the difference between global routing and detailed routing?

- [ ] A) Global is for clocks, detailed is for signals
- [x] B) Global plans routes coarsely, detailed assigns exact tracks
- [ ] C) Global is optional, detailed is required
- [ ] D) They are the same thing

---

## Question 6: Layer Adjustment

What does `set_global_routing_layer_adjustment metal1 0.8` do?

- [] A) Makes metal1 80% wider
- [x] B) Reduces metal1's available routing capacity by 20%
- [ ] C) Uses only 80% of metal1
- [ ] D) Increases metal1 priority by 80%

---

## Scoring

- 6/6: Excellent! You understand routing layer configuration well
- 4-5/6: Good! Review the concepts you missed
- 3/6: Fair - re-read PROBLEM.md and hints.md
- <3/6: Start over and focus on metal layer usage

---

**Ready to check your answers?** See `.solution/quiz_answers.md`
