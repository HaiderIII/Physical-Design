# Quiz Phase 3: Floorplan

## Key Concepts
- Die area vs Core area
- LEF files (Library Exchange Format)
- IO pin placement
- Tap cells and power grid

---

## Questions

### Q1: What is the difference between die area and core area?

- [X] a) Die area = total chip area, Core area = where standard cells are placed
- [ ] b) They are the same thing
- [ ] c) Core area is always larger than die area
- [ ] d) Die area is for analog, core area is for digital

---

### Q2: What information does a LEF file contain?

- [ ] a) Timing information
- [X] b) Physical layout information (cell dimensions, pin locations, metal layers)
- [ ] c) Power consumption data
- [ ] d) Test patterns

---

### Q3: Why do we need tap cells?

- [ ] a) To improve timing
- [X] b) To connect wells to power/ground (prevent latch-up)
- [ ] c) To reduce area
- [ ] d) To enable testing

---

### Q4: What is the purpose of the power grid (PDN)?

- [ ] a) To distribute clock signal
- [X] b) To distribute VDD and VSS to all cells
- [ ] c) To connect input/output pins
- [ ] d) To reduce noise

---

### Q5: For a design with ~68,000 cells at 7nm, what is a reasonable die area estimate?

- [ ] a) 100 × 100 μm
- [ ] b) 400 × 400 μm
- [X] c) 800 × 800 μm
- [ ] d) 2000 × 2000 μm

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

## Phase 3 Summary

```
Floorplan Hierarchy:
┌─────────────────────────────────────────┐
│              Die Area                   │
│  ┌─────────────────────────────────┐   │
│  │         Core Area               │   │
│  │  ┌─────┐ ┌─────┐ ┌─────┐      │   │
│  │  │Cell │ │Cell │ │Cell │ ...  │   │ ← Standard Cells
│  │  └─────┘ └─────┘ └─────┘      │   │
│  │                                 │   │
│  │  ═══════════════════════════   │   │ ← Power Stripes (VDD)
│  │  ───────────────────────────   │   │ ← Power Stripes (VSS)
│  │                                 │   │
│  └─────────────────────────────────┘   │
│  ↑                               ↑     │
│  IO Pins                    IO Pins    │
└─────────────────────────────────────────┘

Key Files:
- LEF: Physical cell definitions
- DEF: Design Exchange Format (output)
- SDC: Timing constraints
```
