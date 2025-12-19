# Quiz - plc_003: Padding Panic

Answer these questions after fixing the puzzle.

---

## Question 1

What happens when cells are placed without padding at 7nm?

- [ ] A) Cells overlap each other
- [X] B) No room for local routing, causing DRC violations
- [ ] C) Power consumption increases
- [ ] D) Clock frequency decreases

---

## Question 2

What does the `set_placement_padding` command do?

- [ ] A) Adds metal fill between cells
- [X] B) Reserves empty sites around cells during placement
- [ ] C) Increases cell drive strength
- [ ] D) Reduces cell area

---

## Question 3

Why do sequential cells (flip-flops) need more padding than combinational cells?

- [ ] A) They are physically larger
- [ ] B) They consume more power
- [X] C) They need routing for clock and potentially scan chains
- [ ] D) They have fewer pins

---

## Question 4

In ASAP7, what is the typical M1/M2 metal pitch?

- [ ] A) 100nm
- [ ] B) 72nm
- [X] C) 36nm
- [ ] D) 18nm

---

## Question 5
 
What is the effect of setting `-left 2 -right 2` for padding?

- [ ] A) 2 sites total spacing between cells
- [X] B) 4 sites total (2 left + 2 right) around each cell
- [ ] C) 2nm spacing on each side
- [ ] D) 2 metal tracks reserved

---

## Question 6

If you have cells A and B adjacent, and both have padding of 2 sites, how many empty sites are between them?

- [ ] A) 2 sites (padding doesn't stack)
- [X] B) 4 sites (2 from A's right + 2 from B's left)
- [ ] C) 0 sites (padding is internal only)
- [ ] D) 8 sites

---

## Question 7

What is the trade-off of using larger cell padding values?

- [ ] A) Faster timing but higher power
- [X] B) Better routability but larger die area
- [ ] C) Lower power but slower timing
- [ ] D) Smaller die area but harder routing

---

Check your answers in `.solution/quiz_answers.md` after completing the puzzle.
