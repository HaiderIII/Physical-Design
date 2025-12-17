# Quiz - SGN_001: The Timing Terror

Answer these questions to validate your understanding.
Check your answers in `.solution/quiz_answers.md` after completing the quiz.

---

## Question 1: Parasitic Estimation

Why is `estimate_parasitics` necessary before timing signoff?

- [ ] A) It makes the design smaller
- [x] B) It calculates wire RC values for accurate timing
- [ ] C) It fixes routing violations
- [ ] D) It's optional and just for debugging

---

## Question 2: Timing Without Parasitics

What happens if you run timing analysis without parasitic estimation?

- [ ] A) Timing looks worse than reality
- [x] B) Timing looks better than reality (optimistic)
- [ ] C) Timing is exactly accurate
- [ ] D) The tool crashes

---

## Question 3: Setup vs Hold

What is the difference between setup and hold timing checks?

- [ ] A) Setup is for inputs, hold is for outputs
- [x] B) Setup checks data arrives before clock, hold checks data stable after clock
- [ ] C) Setup is faster, hold is slower
- [ ] D) They are the same thing

---

## Question 4: Clock Uncertainty

What does `set_clock_uncertainty 0.2` represent?

- [ ] A) Clock frequency of 0.2 GHz
- [x] B) Margin for jitter and skew variations
- [ ] C) Clock duty cycle of 20%
- [ ] D) Number of clock buffers

---

## Question 5: Slack Interpretation

A timing report shows "slack = -0.5 ns". What does this mean?

- [ ] A) Design meets timing with 0.5ns margin
- [x] B) Design violates timing by 0.5ns
- [ ] C) Clock period is 0.5ns
- [ ] D) Wire delay is 0.5ns

---

## Question 6: Signoff Corners

Why do production designs analyze timing at multiple corners (slow, typical, fast)?

- [ ] A) To generate more reports
- [x] B) To account for manufacturing variations
- [ ] C) Because the tool requires it
- [ ] D) To make timing look better

---

## Scoring

- 6/6: Excellent! You understand timing signoff well
- 4-5/6: Good! Review the concepts you missed
- 3/6: Fair - re-read PROBLEM.md and hints.md
- <3/6: Start over and focus on timing fundamentals

---

**Ready to check your answers?** See `.solution/quiz_answers.md`
