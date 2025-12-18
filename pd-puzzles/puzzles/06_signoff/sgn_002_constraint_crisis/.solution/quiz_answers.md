# Quiz Answers - SGN_002 The Constraint Crisis

---

## Question 1: B
**STA assumes the input arrives at time 0 (start of cycle)**

Without `set_input_delay`, STA uses a default of 0, meaning the input is assumed to arrive at the very start of the clock cycle. This is unrealistic and can hide timing problems.

---

## Question 2: B
**data_in arrives 2ns after the clock edge from external logic**

`set_input_delay 2.0` means the external flip-flop's clock-to-Q plus routing delay totals 2ns. The data arrives 2ns into the clock cycle.

---

## Question 3: B
**External logic needs data_out 3ns before the clock edge**

`set_output_delay 3.0` specifies the external setup requirement. The output must be valid 3ns before the next clock edge to meet the external FF's setup time.

---

## Question 4: C
**They ensure I/O timing paths are analyzed by STA**

Without I/O delays, STA doesn't know the timing requirements for input and output paths. This can cause timing issues to be missed during signoff.

---

## Question 5: B
**Missing input_delay or output_delay constraints**

When STA reports "No paths found" for I/O, it usually means the paths are unconstrained. Adding proper I/O delay constraints makes these paths visible to timing analysis.

---

## Question 6: B
**set_input_delay, set_output_delay, set_driving_cell/set_load**

The complete I/O timing picture requires:
- `set_input_delay`: When inputs arrive
- `set_output_delay`: When outputs must be ready
- `set_driving_cell`/`set_load`: Physical characteristics

---

## Question 7: B
**1-3 ns (accounts for external FF Tco + routing)**

A typical input delay accounts for:
- External flip-flop clock-to-Q: ~0.5-1ns
- PCB/interconnect routing: ~0.5-1ns
- Clock skew margin: ~0.5ns

Total: ~1-3ns is reasonable for synchronous interfaces.

---

## Scoring

- 7/7: Excellent! Ready for production-quality SDC
- 5-6/7: Good foundation, minor concepts to review
- 3-4/7: Review I/O constraint concepts
- <3/7: Study SDC fundamentals before proceeding
