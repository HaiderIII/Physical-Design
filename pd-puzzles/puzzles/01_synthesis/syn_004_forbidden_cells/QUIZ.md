# Quiz - SYN_004: Forbidden Cells

Answer these questions after fixing the puzzle.

---

## Question 1

What does `set_dont_use` do in synthesis?

- [ ] A) Removes cells from the library file
- [x] B) Prevents the synthesizer from using specified cells
- [ ] C) Deletes cells from the netlist after synthesis
- [ ] D) Marks cells for manual review

---

## Question 2

Why are `dlygate` cells forbidden in regular logic synthesis?

- [ ] A) They are too fast
- [ ] B) They consume too much power
- [x] C) They have high variability and cause yield issues
- [ ] D) They are not in the standard cell library

---

## Question 3

When should `clkdlybuf` cells be used?

- [ ] A) In all combinational logic
- [ ] B) For high-fanout nets
- [x] C) Only in clock tree synthesis (CTS)
- [ ] D) Never - they should be removed from the library

---

## Question 4

What is the consequence of using forbidden cells in production?

- [ ] A) Faster design closure
- [x] B) DRC violations and yield loss in manufacturing
- [ ] C) Better timing results
- [ ] D) Lower power consumption

---

## Question 5

Which cells are typically physical-only and should never appear in synthesis?

- [ ] A) BUF, INV, AND, OR
- [ ] B) DFF, LATCH, MUX
- [x] C) decap, fill, tap, conb
- [ ] D) NAND, NOR, XOR

---

## Question 6

What is the correct syntax for excluding all delay gates?

- [ ] A) `dont_use sky130_fd_sc_hd__dlygate*`
- [x] B) `set_dont_use [get_lib_cells sky130_fd_sc_hd__dlygate*]`
- [ ] C) `remove_cells dlygate*`
- [ ] D) `exclude_lib_cells *dlygate*`

---

## Question 7

In a real flow, when should dont_use constraints be applied?

- [ ] A) After synthesis, before placement
- [ ] B) After placement, before routing
- [x] C) Before synthesis, as part of library setup
- [ ] D) Only during signoff

---

Check your answers in `.solution/quiz_answers.md`.
