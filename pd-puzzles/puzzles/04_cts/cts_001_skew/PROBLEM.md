# CTS_001 - The Buffer Blunder

**Phase**: Clock Tree Synthesis
**Level**: Beginner
**PDK**: Nangate45
**Estimated time**: 15-20 min

---

## Context

You're implementing a pipelined processor at TimingFirst Corp. The design has passed placement and now needs clock tree synthesis. Your colleague set up the CTS script but made a common mistake: using regular buffers (BUF_X*) instead of dedicated clock buffers (CLKBUF_X*).

"A buffer is a buffer, right?" they said. But clock buffers are specifically designed for clock distribution with balanced rise/fall times.

---

## Observed Symptoms

When you run `openroad run.tcl`, you see:

```
Using root buffer: BUF_X4
Using buffer list: BUF_X1 BUF_X2 BUF_X4
[INFO CTS-0050] Root buffer is BUF_X4.
[INFO CTS-0051] Sink buffer is BUF_X1.
...
```

The script uses regular BUF_X* cells instead of CLKBUF_X* cells. While CTS may complete, using non-clock buffers can lead to:
- Unbalanced rise/fall times
- Higher skew
- Timing issues in sign-off

---

## Objective

Fix the `run.tcl` script to use proper clock buffers.

**Success criteria**:
- [ ] CTS uses CLKBUF_X* cells (not BUF_X*)
- [ ] Root buffer is a strong clock buffer (CLKBUF_X3)
- [ ] Buffer list contains proper clock buffers
- [ ] DEF file is generated in results/

---

## Skills Covered

- [ ] Understanding the difference between regular and clock buffers
- [ ] Configuring CTS buffer selection
- [ ] Reading CTS reports to verify buffer usage
- [ ] Best practices for clock tree design

---

## Files Provided

```
cts_001_skew/
├── PROBLEM.md          # This file
├── run.tcl             # Script to fix (contains TODO)
├── resources/
│   ├── pipeline.v      # Pre-synthesized 4-stage pipeline
│   └── constraints.sdc # Timing constraints
├── hints.md            # Hints if you're stuck
└── QUIZ.md             # Validation quiz
```

---

## Key Concepts

### Clock Buffers vs Regular Buffers

| Feature | CLKBUF_X* | BUF_X* |
|---------|-----------|--------|
| Rise/Fall balance | Optimized | Not guaranteed |
| Skew characteristics | Low | Variable |
| Clock network use | Designed for | Not recommended |
| Timing closure | Predictable | May cause issues |

### Why Use Clock Buffers?

1. **Balanced transitions**: Equal rise and fall times reduce duty cycle distortion
2. **Low skew**: Designed for minimal variation across process corners
3. **Characterized for clocks**: Timing models optimized for clock paths
4. **Sign-off clean**: No DRC violations for clock networks

### Available Clock Buffers (Nangate45)

| Cell | Drive Strength | Use Case |
|------|----------------|----------|
| CLKBUF_X1 | Low | Leaf buffers, low fanout |
| CLKBUF_X2 | Medium | Intermediate levels |
| CLKBUF_X3 | High | Root buffer, high fanout |

### CTS Command Parameters

```tcl
clock_tree_synthesis -root_buf CLKBUF_X3 \
                     -buf_list {CLKBUF_X1 CLKBUF_X2 CLKBUF_X3} \
                     ...
```

- `-root_buf`: Buffer for the clock root (use strongest)
- `-buf_list`: Available buffers for tree construction

---

## Getting Started

1. Read `run.tcl` and find the buffer configuration
2. Identify which cells are being used (BUF_X* or CLKBUF_X*)
3. Change to proper clock buffers
4. Run and verify the CTS report shows CLKBUF usage

```bash
cd puzzles/04_cts/cts_001_skew
openroad run.tcl
```

---

## Rules

1. **Don't look** at the `.solution/` folder before completing the quiz
2. If stuck for more than 10 minutes, check `hints.md`
3. Once CTS uses proper clock buffers, answer the quiz in `QUIZ.md`

---

Good luck!
