# Quiz Phase 4: Placement

## Key Concepts
- Global placement vs Detail placement
- Placement density
- Timing-driven placement
- Cell legalization

---

## Questions

### Q1: What is the difference between global placement and detail placement?

- [ ] a) Global is faster, detail is slower
- [X] b) Global finds approximate positions, detail legalizes to valid sites
- [ ] c) Global is for macros, detail is for standard cells
- [ ] d) They are the same thing

---

### Q2: What does "placement density" control?

- [ ] a) The number of metal layers used
- [X] b) The percentage of core area filled with cells
- [ ] c) The clock frequency
- [ ] d) The power consumption

---

### Q3: Why is timing-driven placement important?

- [ ] a) It reduces power consumption
- [X] b) It places timing-critical cells closer together to meet timing
- [ ] c) It increases the number of cells
- [ ] d) It simplifies routing

---

### Q4: What does "legalization" mean in placement?

- [ ] a) Checking if the design is legal to manufacture
- [X] b) Snapping cells to valid placement sites and removing overlaps
- [ ] c) Adding legal documentation to the design
- [ ] d) Verifying timing constraints

---

### Q5: What happens if placement density is too high (e.g., 90%)?

- [ ] a) Better timing
- [ ] b) Lower power
- [X] c) Routing congestion and potential DRC violations
- [ ] d) Smaller die area

---

## Score

| Correct Answers | Level |
|-----------------|-------|
| 5/5 | Excellent! |
| 4/5 | Very Good |
| 3/5 | Good |
| 2/5 | Review needed |
| 0-1/5 | Re-read the course |

---

## Phase 4 Summary

```
Placement Flow:
┌─────────────────────────────────────────┐
│         Floorplan (from Phase 3)        │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│          Global Placement               │
│  - Minimize wirelength                  │
│  - Respect density constraints          │
│  - Approximate cell positions           │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│        Timing Optimization              │
│  - Estimate parasitics                  │
│  - Analyze timing paths                 │
│  - Optimize critical paths              │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│         Detail Placement                │
│  - Legalize to valid sites              │
│  - Remove cell overlaps                 │
│  - Local optimization                   │
└──────────────────┬──────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────┐
│           Placed DEF                    │
└─────────────────────────────────────────┘

Key Metrics:
- Placement density: 60% (typical)
- Worst negative slack (WNS): should be >= 0
- Total negative slack (TNS): should be >= 0
```
