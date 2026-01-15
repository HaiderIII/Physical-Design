# Quiz Phase 2: Synthesis (Yosys → ASAP7)

## Key Concepts
- Yosys synthesis flow
- Technology mapping (dfflibmap, abc)
- Liberty libraries (.lib files)
- Gate-level netlist generation

---

## Questions

### Q1: What does the `dfflibmap` command do in Yosys?

- [ ] a) Maps combinational logic to standard cells
- [X] b) Maps flip-flops to sequential cells from a liberty library
- [ ] c) Flattens the design hierarchy
- [ ] d) Optimizes the design for area

---

### Q2: Why did we use `abc -g AND,NAND,OR,...` instead of `abc -liberty`?

- [ ] a) It's faster
- [X] b) ABC had issues with the ASAP7 liberty file format
- [ ] c) Generic gates use less area
- [ ] d) Liberty mapping is deprecated

---

### Q3: What does `memory_map` do in the synthesis flow?

- [ ] a) Creates a memory map file for debugging
- [X] b) Converts memory arrays into individual flip-flops
- [ ] c) Maps memories to SRAM macros
- [ ] d) Optimizes memory access patterns

---

### Q4: How many flip-flops were generated for the two fake SRAMs (2 × 1024 × 32 bits)?

- [ ] a) 2,048 FF
- [ ] b) 32,768 FF
- [X] c) 65,536 FF
- [ ] d) 131,072 FF

---

### Q5: What is the difference between `DFFHQNx1_ASAP7_75t_R` and `DFFASRHQNx1_ASAP7_75t_R`?

- [ ] a) One is faster than the other
- [X] b) DFFASRH has asynchronous set/reset, DFFH is simple DFF
- [ ] c) One uses less power
- [ ] d) They are identical, just different names

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

## Phase 2 Summary

```
Synthesis Flow:
┌─────────────┐
│  RTL (.v)   │
└──────┬──────┘
       │ read_verilog
       ▼
┌─────────────┐
│  hierarchy  │  Build module tree
└──────┬──────┘
       │ proc, opt, flatten
       ▼
┌─────────────┐
│   memory    │  Convert reg arrays → DFFs
└──────┬──────┘
       │ techmap
       ▼
┌─────────────┐
│  dfflibmap  │  Map DFFs → ASAP7 sequential cells
└──────┬──────┘
       │ abc -g gates
       ▼
┌─────────────┐
│   Netlist   │  Gate-level Verilog
└─────────────┘

Result: ~68,700 cells (65,600 DFFs + ~3,100 combinational)
```
