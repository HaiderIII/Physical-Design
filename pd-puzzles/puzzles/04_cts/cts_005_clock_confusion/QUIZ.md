# CTS_005: Clock Confusion - Quiz

Test your understanding of this puzzle.

---

## Question 1: Root Cause
What is the root cause of "No clock nets found"?

- [ ] A) No flip-flops in the design
- [ ] B) Wrong buffer cell specified
- [X] C) SDC clock port name doesn't match design port
- [ ] D) Missing clock period constraint

## Question 2: Case Sensitivity
In Verilog, are port names case-sensitive?

- [ ] A) No, clk and CLK are the same
- [X] B) Yes, clk and CLK are different ports
- [ ] C) Depends on the synthesis tool
- [ ] D) Only for clock ports

## Question 3: SDC get_ports
What does `get_ports CLK` return if port CLK doesn't exist?

- [X] A) An empty collection
- [ ] B) An error that stops execution
- [ ] C) The nearest matching port
- [ ] D) A wildcard pattern

## Question 4: CTS Without Clock
What happens when CTS runs without a valid clock definition?

- [ ] A) Tool crashes with error
- [ ] B) Clock buffers are inserted randomly
- [X] C) No clock tree is built (registers left unbalanced)
- [ ] D) Tool uses default 1ns clock

## Question 5: Timing Impact
Why does timing analysis show "No paths found"?

- [ ] A) Design has no combinational logic
- [X] B) There's no valid clock to define timing paths
- [ ] C) All paths have infinite slack
- [ ] D) Timing constraints file is missing

## Question 6: Warning Level
The message "[WARNING STA-0366] port 'CLK' not found" is a warning, not an error. Why is this problematic?

- [X] A) The flow continues but produces incorrect results
- [ ] B) Warnings are always safe to ignore
- [ ] C) It only affects debug builds
- [ ] D) OpenROAD will retry with correct port

## Question 7: Best Practice
What's the best way to prevent this issue in production flows?

- [ ] A) Always use uppercase clock names
- [X] B) Add validation checks that clock nets are found after CTS
- [ ] C) Use virtual clocks instead
- [ ] D) Run CTS twice

---

## Scoring

| Score | Level |
|-------|-------|
| 7/7   | Master |
| 5-6/7 | Advanced |
| 3-4/7 | Intermediate |
| 0-2/7 | Review CTS fundamentals |
