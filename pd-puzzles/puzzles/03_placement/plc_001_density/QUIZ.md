# Quiz - PLC_001: The Density Dilemma

Answer these questions to validate your understanding.
Check your answers in `.solution/quiz_answers.md` after completing the quiz.

---

## Question 1: Density Definition

What does `-density 0.70` mean in `global_placement`?

- [ ] A) Use 70% of the die area
- [x] B) Pack cells to fill 70% of available placement space
- [ ] C) Achieve 70% timing slack
- [ ] D) Route 70% of the nets

---

## Question 2: Delta HPWL

After detailed placement, you see "delta HPWL 35%". What does this indicate?

- [ ] A) 35% of nets are unrouted
- [x] B) Wirelength increased 35% during legalization
- [ ] C) 35% of cells are overlapping
- [ ] D) Timing improved by 35%

---

## Question 3: High Density Problems

Which problems can result from setting density too high? (Select all that apply)

- [x] A) Routing congestion
- [x] B) Increased wirelength after legalization
- [ ] C) Faster placement runtime
- [x] D) Difficulty inserting clock buffers later

---

## Question 4: Density Selection

For a design with complex routing and tight timing requirements, which density would you choose?

- [ ] A) 0.95 (maximize area utilization)
- [ ] B) 0.80 (aggressive)
- [ ] C) 0.60 (balanced)
- [x] D) 0.45 (relaxed for routing)

---

## Question 5: Metrics Interpretation

Which placement result indicates better quality?

**Option A:**
```
delta HPWL: 12%
avg displacement: 0.9 um
```

**Option B:**
```
delta HPWL: 28%
avg displacement: 2.4 um
```

- [x] A) Option A
- [ ] B) Option B
- [ ] C) Both are equivalent
- [ ] D) Cannot determine from these metrics

---

## Question 6: Density vs Utilization

A floorplan has 60% utilization. You run placement with `-density 0.90`. What happens?

- [ ] A) Error: density cannot exceed utilization
- [x] B) Cells are packed tightly within the 60% utilized area
- [ ] C) Utilization automatically increases to 90%
- [ ] D) Placement is skipped

---

## Scoring

- 6/6: Excellent! You understand placement density well
- 4-5/6: Good! Review the concepts you missed
- 3/6: Fair - re-read PROBLEM.md and hints.md
- <3/6: Start over and experiment with different density values

---

**Ready to check your answers?** See `.solution/quiz_answers.md`
