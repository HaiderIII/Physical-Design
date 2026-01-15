# Quiz Phase 6: Routing

## Key Concepts
- Global vs Detailed routing
- Metal layers and via stacks
- DRC (Design Rule Check)
- Congestion and overflow

---

## Questions

### Q1: What is the difference between global routing and detailed routing?

- [ ] a) Global routing is faster, detailed routing is slower
- [ ] b) Global routing creates actual wires, detailed routing plans the path
- [X] c) Global routing creates routing guides, detailed routing creates actual metal wires
- [ ] d) There is no difference

---

### Q2: What is a "via" in VLSI routing?

- [ ] a) A horizontal wire segment
- [X] b) A vertical connection between two metal layers
- [ ] c) A type of standard cell
- [ ] d) A timing constraint

---

### Q3: What does "routing congestion" mean?

- [X] a) Too many cells in one area
- [ ] b) Too many wires trying to use the same routing resources
- [ ] c) Clock skew is too high
- [ ] d) Power consumption is too high

---

### Q4: In ASAP7, which metal layers are typically used for signal routing?

- [ ] a) M1 only
- [X] b) M2 to M7
- [ ] c) M8 and M9 only
- [ ] d) All layers equally

---

### Q5: What is a DRC (Design Rule Check) violation in routing?

- [ ] a) A timing violation
- [ ] b) A power violation
- [X] c) A violation of physical manufacturing rules (spacing, width, etc.)
- [ ] d) A functional error

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

## Phase 6 Summary

```
Routing Flow:

┌─────────────────────────────────────────────────────────┐
│                   Global Routing                         │
│  ┌─────┐    ┌─────┐    ┌─────┐    ┌─────┐             │
│  │ GR  │ -> │ GR  │ -> │ GR  │ -> │ GR  │  Guides     │
│  │Cell1│    │     │    │     │    │Cell2│             │
│  └─────┘    └─────┘    └─────┘    └─────┘             │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│                  Detailed Routing                        │
│  ┌─────┐════════════════════════════┌─────┐            │
│  │Cell1│────────┬───────────────────│Cell2│  M3       │
│  └─────┘        │                   └─────┘            │
│                 ■ Via (M3→M4)                          │
│                 │                                       │
│  ═══════════════╧═══════════════════════════  M4      │
└─────────────────────────────────────────────────────────┘

ASAP7 Metal Stack:
┌────────────────────────────────────┐
│  M9  │  Thick (power/clock)        │
│  M8  │  Thick (power/clock)        │
│──────│─────────────────────────────│
│  M7  │  Signal routing             │
│  M6  │  Signal routing             │
│  M5  │  Signal routing (vertical)  │
│  M4  │  Signal routing (horizontal)│
│  M3  │  Signal routing             │
│  M2  │  Signal routing             │
│──────│─────────────────────────────│
│  M1  │  Local interconnect         │
└────────────────────────────────────┘

Common DRC Violations:
- Minimum spacing: Wires too close
- Minimum width: Wire too thin
- Via enclosure: Metal doesn't cover via enough
- Antenna: Long wire charges up gate oxide
```

## Useful Commands

```tcl
# Global routing
global_route

# Detailed routing
detailed_route

# Check DRC
check_drc

# Report routing statistics
report_design_area

# Estimate parasitics after routing
estimate_parasitics -global_routing
```
