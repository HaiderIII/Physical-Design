# Quiz - CTS_002 The Buffer Bonanza

Answer these questions **BEFORE** checking the solution.

---

## Question 1

Why are clock buffers (clkbuf_*) preferred over inverters (inv_*) for clock trees?

- [ ] A) Clock buffers are smaller
- [X] B) Clock buffers have balanced rise/fall times for stable duty cycle
- [ ] C) Inverters cost more
- [ ] D) Inverters use more power

---

## Question 2

In Sky130HD, which cell would you use as the root buffer for a clock tree?

- [ ] A) sky130_fd_sc_hd__clkbuf_1 (smallest)
- [ ] B) sky130_fd_sc_hd__inv_8 (large inverter)
- [X] C) sky130_fd_sc_hd__clkbuf_16 (largest clock buffer)
- [ ] D) sky130_fd_sc_hd__buf_8 (data buffer)

---

## Question 3

What is "duty cycle distortion" in clock signals?

- [ ] A) The clock runs at wrong frequency
- [X] B) The high and low times are no longer equal (not 50/50)
- [ ] C) The clock has too much jitter
- [ ] D) The clock tree uses too many buffers

---

## Question 4

Which OpenROAD command parameter specifies the root buffer for CTS?

- [X] A) `-root_buffer`
- [ ] B) `-root_buf`
- [ ] C) `-clock_buffer`
- [ ] D) `-top_buffer`

---

## Question 5

Why is a larger buffer (clkbuf_16) used at the root of the clock tree?

- [ ] A) It looks better in the layout
- [X] B) It needs to drive many cells at the first tree level (high fanout)
- [ ] C) Smaller buffers are not allowed at the root
- [ ] D) It reduces power consumption

---

## Question 6

What does the `-buf_list` parameter in clock_tree_synthesis specify?

- [ ] A) The order in which buffers are placed
- [X] B) The available buffer cells CTS can use to build the tree
- [ ] C) The number of buffers to use
- [ ] D) The buffer delay targets

---

## Question 7

If CTS reports using "sky130_fd_sc_hd__inv_*" cells, what should you check?

- [ ] A) The power supply voltage
- [X] B) The root_buf and buf_list parameters - they should use clkbuf_* cells
- [ ] C) The clock frequency
- [ ] D) The die size

---

## Score Interpretation

Count your correct answers:
- 7/7: Excellent! You understand CTS buffer selection
- 5-6/7: Good understanding, review the missed concepts
- 3-4/7: Review hints.md and PROBLEM.md
- <3/7: Re-study CTS fundamentals

---

Check `.solution/quiz_answers.md` to verify your answers.
