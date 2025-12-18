# Quiz - FLP_002 The Halo Headache

Answer these questions **BEFORE** checking the solution.

---

## Question 1

What is a halo (or keepout) in floorplanning?

- [ ] A) A decorative ring around the chip logo
- [X] B) A region around a macro where standard cells cannot be placed
- [ ] C) A type of power ring around the core
- [ ] D) A clock distribution network

---

## Question 2

Why do analog macros need halos around them?

- [ ] A) To make the chip look more organized
- [X] B) To reduce noise coupling from digital switching activity
- [ ] C) To increase the chip area for marketing purposes
- [ ] D) Halos are optional and have no real purpose

---

## Question 3

Which OpenROAD command creates a placement blockage region?

- [ ] A) `add_halo -region {x1 y1 x2 y2}`
- [X] B) `create_blockage -region {x1 y1 x2 y2}`
- [ ] C) `set_keepout -bbox {x1 y1 x2 y2}`
- [ ] D) `placement_blockage -area {x1 y1 x2 y2}`

---

## Question 4

A macro is placed at origin (50, 50) and has size 30um x 20um. With a 5um halo, what are the blockage coordinates?

- [ ] A) {50 50 80 70} - just the macro
- [X] B) {45 45 85 75} - macro plus halo on all sides
- [ ] C) {55 55 75 65} - smaller than macro
- [ ] D) {50 50 85 75} - halo only on right and top

---

## Question 5

What happens if you define blockages AFTER running placement?

- [ ] A) The placer automatically moves cells out of blockages
- [X] B) Nothing - cells already placed will stay in the blockage region
- [ ] C) OpenROAD throws an error
- [ ] D) The blockages are automatically applied retroactively

---

## Question 6

Besides noise isolation, what other reasons justify using halos around macros?

- [] A) Routing channels for signals and power to reach macro pins
- [ ] B) Space for decoupling capacitors
- [ ] C) Manufacturing constraints near macro edges
- [X] D) All of the above

---

## Question 7

If the placer ignores your blockage and places cells inside it, what could be wrong?

- [ ] A) The blockage command was placed AFTER placement ran
- [ ] B) The coordinates in the command are incorrect
- [ ] C) The placement density is too high forcing cells everywhere
- [X] D) All of the above could cause this issue

---

## Score Interpretation

Count your correct answers:
- 7/7: Excellent! You understand macro placement constraints
- 5-6/7: Good understanding, review the hints for details
- 3-4/7: Review the concepts before moving on
- <3/7: Re-read PROBLEM.md and hints.md carefully

---

Check `.solution/quiz_answers.md` to verify your answers.
