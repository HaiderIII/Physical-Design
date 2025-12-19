# Quiz - syn_003: Voltage Vortex

Answer these questions after fixing the puzzle.

---

## Question 1

What does "Vt" stand for in the context of standard cells?

- [ ] A) Virtual Terminal
- [ ] B) Voltage Threshold
- [ ] C) Verilog Type
- [ ] D) Variable Timing

---

## Question 2

In ASAP7, what does the `_R` suffix indicate in cell names like `AND2x2_ASAP7_75t_R`?

- [ ] A) Reduced size variant
- [ ] B) Regular Vt (RVT)
- [ ] C) Right-side orientation
- [ ] D) Registered output

---

## Question 3

What is the relationship between Vt and transistor switching speed?

- [ ] A) Lower Vt = slower switching
- [ ] B) Lower Vt = faster switching
- [ ] C) Vt doesn't affect speed
- [ ] D) Higher Vt = faster switching

---

## Question 4

What is the relationship between Vt and leakage current?

- [ ] A) Lower Vt = lower leakage
- [ ] B) Lower Vt = higher leakage
- [ ] C) Vt doesn't affect leakage
- [ ] D) Only temperature affects leakage

---

## Question 5

Why did the original script fail to find cells?

- [ ] A) The netlist was corrupted
- [ ] B) The LEF files were missing
- [ ] C) The library Vt didn't match the netlist cell Vt
- [ ] D) OpenROAD version mismatch

---

## Question 6

For a 500MHz design (not extremely aggressive), which Vt is typically the best default choice?

- [ ] A) SLVT - maximize timing margin
- [ ] B) LVT - best performance
- [ ] C) RVT - balanced speed and power
- [ ] D) Always use the fastest available

---

## Question 7

In a production multi-Vt optimization flow, what's the typical strategy?

- [ ] A) Use SLVT everywhere for maximum speed
- [ ] B) Use HVT/RVT by default, swap to LVT/SLVT only on critical paths
- [ ] C) Randomly mix Vt types
- [ ] D) Use LVT everywhere for best power

---

Check your answers in `.solution/quiz_answers.md` after completing the puzzle.
