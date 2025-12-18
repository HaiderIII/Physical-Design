# Quiz - SGN_002 The Constraint Crisis

Answer these questions **BEFORE** checking the solution.

---

## Question 1

What happens when an input has no `set_input_delay` constraint?

- [ ] A) STA assumes the input arrives exactly at the clock edge
- [X] B) STA assumes the input arrives at time 0 (start of cycle)
- [ ] C) STA flags an error and stops
- [ ] D) STA uses a default delay of 1ns

---

## Question 2

What does `set_input_delay -clock clk 2.0 [get_ports data_in]` mean?

- [ ] A) data_in must arrive within 2ns of the clock edge
- [X] B) data_in arrives 2ns after the clock edge from external logic
- [ ] C) data_in has 2ns of internal delay
- [ ] D) data_in will be delayed by 2ns

---

## Question 3

What does `set_output_delay -clock clk 3.0 [get_ports data_out]` mean?

- [ ] A) data_out will be delayed by 3ns
- [X] B) External logic needs data_out 3ns before the clock edge
- [ ] C) data_out must remain stable for 3ns
- [ ] D) data_out has 3ns of wire delay

---

## Question 4

Why are I/O delay constraints important for signoff?

- [ ] A) They make simulation faster
- [ ] B) They reduce power consumption
- [X] C) They ensure I/O timing paths are analyzed by STA
- [ ] D) They are only needed for FPGA designs

---

## Question 5

If STA shows "No paths found" for I/O timing, what's the likely cause?

- [ ] A) The design has no registers
- [X] B) Missing input_delay or output_delay constraints
- [ ] C) The clock is not defined
- [ ] D) The design is too small

---

## Question 6

What three timing-related SDC commands are typically needed for I/O ports?

- [ ] A) create_clock, set_case_analysis, set_false_path
- [X] B) set_input_delay, set_output_delay, set_driving_cell/set_load
- [ ] C) set_max_delay, set_min_delay, set_multicycle_path
- [ ] D) create_generated_clock, set_clock_groups, set_clock_latency

---

## Question 7

What is a typical input_delay value for synchronous interfaces?

- [ ] A) 0 ns (inputs are ideal)
- [X] B) 1-3 ns (accounts for external FF Tco + routing)
- [ ] C) 10 ns (full clock period)
- [ ] D) 50 ns (very conservative)

---

## Score Interpretation

Count your correct answers:
- 7/7: Excellent! You understand SDC I/O constraints
- 5-6/7: Good understanding, review the missed concepts
- 3-4/7: Review hints.md and PROBLEM.md
- <3/7: Re-study SDC constraint fundamentals

---

Check `.solution/quiz_answers.md` to verify your answers.
