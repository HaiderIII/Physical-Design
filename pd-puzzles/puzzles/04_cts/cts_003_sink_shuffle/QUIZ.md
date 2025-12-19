# Quiz - cts_003: Sink Shuffle

Answer these questions after fixing the puzzle.

---

## Question 1

What is the purpose of sink clustering in CTS?

- [ ] A) Reduce power consumption
- [X] B) Group nearby flip-flops to minimize local skew
- [ ] C) Increase clock frequency
- [ ] D) Reduce the number of flip-flops

---

## Question 2

What happens when sink clustering is disabled at high frequencies?

- [ ] A) Clock tree uses fewer buffers
- [X] B) Some sinks get long wires, causing high skew
- [ ] C) Power consumption decreases
- [ ] D) Timing improves

---

## Question 3

What does `sink_clustering_max_diameter` control?

- [ ] A) The size of clock buffers
- [X] B) The maximum physical span of a cluster
- [ ] C) The clock frequency
- [ ] D) The number of pipeline stages

---

## Question 4

For ASAP7 at 1.5 GHz, what is an appropriate cluster diameter?

- [ ] A) 200 um
- [ ] B) 500 um
- [X] C) 30 um
- [ ] D) 5 um

---

## Question 5

Why are large cluster diameters (e.g., 200 um) problematic?

- [ ] A) Uses too many buffers
- [X]B) Distant sinks have different wire delays, increasing skew
- [ ] C) Reduces clock frequency
- [ ] D) Causes power grid issues

---

## Question 6

In a clustered clock tree, what drives each cluster?

- [ ] A) The root buffer directly
- [X] B) A dedicated buffer for that cluster
- [ ] C) The flip-flops themselves
- [ ] D) No buffer is needed

---

## Question 7

What is the relationship between cluster diameter and number of buffers?

- [] A) Larger diameter = more buffers
- [X] B) Smaller diameter = more buffers (more clusters)
- [ ] C) Diameter doesn't affect buffer count
- [ ] D) Larger diameter = fewer flip-flops

---

Check your answers in `.solution/quiz_answers.md` after completing the puzzle.
