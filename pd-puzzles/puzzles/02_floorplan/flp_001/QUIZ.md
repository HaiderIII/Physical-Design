# Quiz - FLP_001: The Impossible Floorplan

Answer these questions to validate your understanding.
Check your answers in `.solution/quiz_answers.md` after completing the quiz.

---

## Question 1: Die Area Calculation

A design has 500 um^2 of cell area. You want 60% utilization and 3um IO margins on each side.

What should be the **minimum die dimensions** (assuming square)?

- [ ] A) 25 x 25 um
- [ ] B) 29 x 29 um
- [X] C) 35 x 35 um
- [ ] D) 41 x 41 um

---

## Question 2: Understanding Utilization

Which statement about utilization is **FALSE**?

- [ ] A) Higher utilization means smaller die area for the same design
- [ ] B) Typical utilization for complex designs is 40-60%
- [X] C) 95% utilization is excellent and should always be the target
- [ ] D) Low utilization leaves room for routing and CTS buffers

---

## Question 3: Core vs Die Area

If die_area is `{0 0 100 100}` and core_area is `{5 5 95 95}`, what is the IO margin?

- [X] A) 5 um on each side
- [ ] B) 10 um on each side
- [ ] C) 95 um total
- [ ] D) 90 um on each side

---

## Question 4: Placement Failure

The placer reports "Utilization 150% exceeds 100%". What are valid solutions? (Select all that apply)

- [X] A) Increase die/core area
- [ ] B) Reduce target utilization parameter
- [X] C) Remove cells from the design
- [X] D) Use a different PDK with smaller cells

---

## Question 5: OpenROAD Command

Which `initialize_floorplan` option lets the tool automatically calculate die size based on cell area?

- [ ] A) `-die_area`
- [ ] B) `-core_area`
- [X] C) `-utilization`
- [ ] D) `-aspect_ratio`

---

## Question 6: Real-World Scenario

You inherit a floorplan script from a colleague. The design has grown from 10K to 50K cells, but the die_area hasn't changed. What will happen?

- [ ] A) The tool will automatically resize the die
- [X] B) Placement will likely fail with utilization errors
- [ ] C) The design will be placed but with poor timing
- [ ] D) Nothing, cell count doesn't affect floorplan

---

## Scoring

- 6/6: Excellent! You fully understand floorplan basics
- 4-5/6: Good! Review the concepts you missed
- 3/6: Fair - re-read PROBLEM.md and hints.md
- <3/6: Start over and take your time understanding each concept

---

**Ready to check your answers?** See `.solution/quiz_answers.md`
