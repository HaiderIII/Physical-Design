# Quiz Phase 1: RTL with Fake SRAM

## Key Concepts
- Fake SRAM vs Real SRAM
- Memory structure in Verilog
- SoC Architecture (CPU + memories)

---

## Questions

### Q1: How many flip-flops will be generated for ONE fake_sram of 1024 words × 32 bits?

- [ ] a) 1,024 FF
- [ ] b) 32,768 FF
- [ ] c) 4,096 FF
- [ ] d) 65,536 FF

---

### Q2: Why do we use addr[11:2] instead of addr[9:0] for the SRAM address?

- [ ] a) Word-aligned: byte addresses ÷ 4 = word addresses
- [ ] b) To save wires
- [ ] c) Bug fix
- [ ] d) To improve performance

---

### Q3: What is the main difference between IMEM and DMEM?

- [ ] a) IMEM = read-only (we=0), DMEM = read/write
- [ ] b) IMEM is larger
- [ ] c) IMEM is faster
- [ ] d) No difference

---

### Q4: Why do we use a "fake SRAM" in ASAP7 instead of a real macro?

- [ ] a) Faster
- [ ] b) Cheaper
- [ ] c) No SRAM macro available for ASAP7
- [ ] d) Smaller area

---

### Q5: What is the main disadvantage of a fake SRAM?

- [ ] a) Slower
- [ ] b) Much larger area
- [ ] c) Doesn't work
- [ ] d) Uses less power

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

## Phase 1 Summary

```
Fake SRAM = reg [31:0] mem [0:1023]  →  32,768 flip-flops

SoC Architecture:
┌─────────────────────────────────────┐
│            riscv_soc                │
│  ┌─────────────────────────────┐   │
│  │        riscv_core           │   │
│  └──────┬──────────────┬───────┘   │
│         │              │           │
│    ┌────▼────┐    ┌────▼────┐     │
│    │  IMEM   │    │  DMEM   │     │
│    │  (RO)   │    │  (RW)   │     │
│    └─────────┘    └─────────┘     │
└─────────────────────────────────────┘
```
