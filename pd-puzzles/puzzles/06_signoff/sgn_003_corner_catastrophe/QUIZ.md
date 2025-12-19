# Quiz - sgn_003: Corner Catastrophe

Answer these questions after fixing the puzzle.

---

## Question 1

What does "SS" corner stand for in ASAP7?

- [ ] A) Super-Speed
- [X] B) Slow-Slow (slow NMOS, slow PMOS)
- [ ] C) Single-Supply
- [ ] D) Static-Switching

---

## Question 2

Which corner should be used for SETUP timing analysis?

- [X] A) SS (Slow-Slow) - cells are slower, data paths take longer
- [ ] B) FF (Fast-Fast) - cells are faster
- [ ] C) TT (Typical-Typical) - nominal behavior
- [ ] D) SF (Slow-Fast) - mixed corner

---

## Question 3

Which corner should be used for HOLD timing analysis?

- [ ] A) SS (Slow-Slow) - cells are slower
- [X] B) FF (Fast-Fast) - data arrives too quickly
- [ ] C) TT (Typical-Typical) - nominal behavior
- [ ] D) FS (Fast-Slow) - mixed corner

---

## Question 4

Why is multi-corner analysis critical at 7nm?

- [ ] A) It reduces power consumption
- [ ] B) It speeds up the design process
- [X] C) Process variation is significant, corners can differ by 20-30%
- [ ] D) It's only needed for analog designs

---

## Question 5

What happens if you only analyze TT corner for signoff?

- [ ] A) The design will work perfectly in silicon
- [X] B) Setup/hold violations at extreme corners may be hidden
- [ ] C) The analysis runs faster
- [ ] D) Power estimates are more accurate

---

## Question 6

In ASAP7 liberty files, what does `*_RVT_SS_*.lib` represent?

- [ ] A) Regular Vt cells, Super-Speed corner
- [X] B) Regular Vt cells, Slow-Slow process corner
- [ ] C) Reduced Vt cells, Single-Supply corner
- [ ] D) Regular Vt cells, Standard-Standard voltage

---

## Question 7

At which corner does a chip manufactured at the "fast" process extreme operate?

- [X] A) Cells switch faster, hold violations more likely
- [ ] B) Cells switch slower, setup violations more likely
- [ ] C) No difference from typical
- [ ] D) Only affects power, not timing

---

Check your answers in `.solution/quiz_answers.md` after completing the puzzle.
