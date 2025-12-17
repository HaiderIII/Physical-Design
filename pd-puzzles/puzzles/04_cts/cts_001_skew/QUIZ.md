# Quiz - CTS_001: The Buffer Blunder

Answer these questions to validate your understanding.
Check your answers in `.solution/quiz_answers.md` after completing the quiz.

---

## Question 1: Clock Buffer Purpose

Why should you use CLKBUF_X* instead of BUF_X* for clock trees?

- [ ] A) Clock buffers are smaller in area
- [x] B) Clock buffers have balanced rise/fall times
- [ ] C) Clock buffers use less power
- [ ] D) There is no difference

---

## Question 2: Root Buffer Selection

For the clock tree root, which buffer should you typically use?

- [ ] A) The smallest buffer (CLKBUF_X1)
- [ ] B) A medium buffer (CLKBUF_X2)
- [x] C) The strongest buffer (CLKBUF_X3)
- [ ] D) Any buffer works equally well

---

## Question 3: CTS Parameters

In the command `clock_tree_synthesis -root_buf X -buf_list {A B C}`, what is `-buf_list` used for?

- [ ] A) Buffers that cannot be used
- [x] B) Available buffers for building the clock tree
- [ ] C) Output buffer names
- [ ] D) Debug buffer list

---

## Question 4: Skew Impact

How does using non-clock buffers (BUF_X*) affect clock skew?

- [ ] A) Reduces skew
- [ ] B) Has no effect on skew
- [x] C) Can increase skew due to unbalanced delays
- [ ] D) Eliminates skew completely

---

## Question 5: Buffer Sizing

Why does the CTS buffer list typically include multiple sizes (X1, X2, X3)?

- [ ] A) To make the script longer
- [x] B) CTS chooses appropriate sizes for different fanout levels
- [ ] C) Only one size is actually used
- [ ] D) For backwards compatibility

---

## Question 6: Industry Practice

In a real chip design, what would happen if you used regular buffers for the clock tree?

- [ ] A) Nothing, the chip would work fine
- [x] B) Design rule violations and potential timing failures
- [ ] C) Faster clock speeds
- [ ] D) Lower power consumption

---

## Scoring

- 6/6: Excellent! You understand CTS buffer selection well
- 4-5/6: Good! Review the concepts you missed
- 3/6: Fair - re-read PROBLEM.md and hints.md
- <3/6: Start over and focus on why clock buffers matter

---

**Ready to check your answers?** See `.solution/quiz_answers.md`
