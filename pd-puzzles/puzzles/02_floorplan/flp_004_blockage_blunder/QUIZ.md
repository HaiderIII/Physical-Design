# Quiz - FLP_004: Blockage Blunder

Answer these questions after fixing the puzzle.

---

## Question 1

What is the purpose of a placement blockage?

- [ ] A) To speed up placement runtime
- [X] B) To prevent cells from being placed in a specific region
- [ ] C) To reduce power consumption
- [ ] D) To improve timing

---

## Question 2

Where must a placement blockage be located?

- [ ] A) Anywhere in the die area
- [ ] B) Only outside the core area
- [X] C) Within the core area boundaries
- [ ] D) Only in the corners

---

## Question 3

What happens if a blockage extends outside the core area?

- [ ] A) Cells are placed there anyway
- [ ] B) The tool ignores the blockage
- [X] C) It causes an error or undefined behavior
- [ ] D) The die area expands automatically

---

## Question 4

What is a common use case for placement blockages?

- [ ] A) Improving clock frequency
- [X] B) Reserving space for analog IP or macros
- [ ] C) Reducing wire length
- [ ] D) Adding more standard cells

---

## Question 5

In the command `create_blockage -region "x1 y1 x2 y2"`, what do the coordinates represent?

- [ ] A) Center point and radius
- [X] B) Lower-left and upper-right corners
- [ ] C) Width and height
- [ ] D) Four corner points

---

## Question 6

If core area is (10,10) to (90,90), which blockage is VALID?

- [ ] A) (5, 5) to (50, 50)
- [ ] B) (70, 70) to (95, 95)
- [X] C) (20, 20) to (80, 80)
- [ ] D) (85, 85) to (100, 100)

---

## Question 7

Why might you reserve space in the top-right corner of a floorplan?

- [ ] A) It's always the hottest region
- [X] B) For future analog IP or power management blocks
- [ ] C) Standard cells work better there
- [ ] D) It reduces routing congestion

---

Check your answers in `.solution/quiz_answers.md`.
