# 06_signoff Puzzles - Timing Analysis & Verification

## Puzzle List

| ID | Name | Level | PDK | Status |
|----|------|-------|-----|--------|
| sgn_001_timing | [The Timing Terror](sgn_001_timing/PROBLEM.md) | Beginner | Nangate45 | Completed |
| sgn_002_constraint_crisis | [The Constraint Crisis](sgn_002_constraint_crisis/PROBLEM.md) | Intermediate | Sky130HD | Completed |
| sgn_003_corner_catastrophe | [Corner Catastrophe](sgn_003_corner_catastrophe/PROBLEM.md) | Advanced | ASAP7 | ✅ |

---

## Progression Path

1. **sgn_001_timing** - Parasitic estimation (15-20 min)
   - *Bug*: Missing `estimate_parasitics` before timing analysis
   - *Skills*: Parasitic extraction, accurate timing analysis

2. **sgn_002_constraint_crisis** - I/O timing constraints (20-25 min)
   - *Bug*: Missing `set_input_delay` and `set_output_delay` in SDC
   - *Skills*: I/O constraints, complete SDC for signoff

3. **sgn_003_corner_catastrophe** - Multi-corner analysis (20-25 min)
   - *Bug*: Only TT corner loaded, missing SS/FF for proper signoff
   - *Skills*: Multi-corner timing, PVT variation, signoff methodology

---

## Key Concepts

### I/O Delay Constraints

| Constraint | Purpose | Example |
|------------|---------|---------|
| `set_input_delay` | When inputs arrive after clock | `set_input_delay -clock clk 2.0 [get_ports data_in]` |
| `set_output_delay` | When outputs must be ready | `set_output_delay -clock clk 2.0 [get_ports data_out]` |

### Complete SDC Checklist

1. **Clock**: `create_clock`
2. **Input delays**: `set_input_delay` for all inputs
3. **Output delays**: `set_output_delay` for all outputs
4. **Driving cells**: `set_driving_cell` for input characteristics
5. **Output loads**: `set_load` for output fanout

### PVT Corners (Advanced Nodes)

| Corner | Meaning | Used For |
|--------|---------|----------|
| SS | Slow-Slow | Setup analysis (worst-case slow) |
| FF | Fast-Fast | Hold analysis (worst-case fast) |
| TT | Typical-Typical | Nominal behavior |
| SF/FS | Mixed corners | Special cases |

### Common Issues

- "No paths found" = Missing I/O constraints
- Unconstrained I/O = Timing problems hidden from STA
- Missing constraints = False confidence in timing
- TT-only analysis = Hidden violations at process corners

---

## Prerequisites

Before starting signoff puzzles, complete:
1. All previous phases (synthesis through routing)
2. Understanding of STA fundamentals
3. Familiarity with timing constraints (SDC)

Signoff is the final verification step before tape-out.
