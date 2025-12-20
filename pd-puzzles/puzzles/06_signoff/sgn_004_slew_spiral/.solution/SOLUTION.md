# Solution - Slew Spiral

## The Bug

The SDC constraints file was missing `set_max_transition` constraints:

```tcl
# MISSING in original:
# set_max_transition <value> [current_design]
```

Without this, the timing analyzer has no slew limit to check against, so:
- No slew violations are reported
- The design may have excessive transition times
- Silicon behavior may differ from simulation

## The Fix

Add to `constraints.sdc`:
```tcl
# Maximum transition (slew) constraints
set_max_transition 1.0 [current_design]

# Stricter slew for clock network
set_max_transition 0.5 [get_clocks clk]
```

And add timing repair in `run.tcl` after global routing:
```tcl
repair_timing
```

## Explanation

### What is Slew/Transition Time?

Slew (or transition time) measures how fast a signal changes between logic levels:
- **Rise time**: Time from 10% to 90% of VDD
- **Fall time**: Time from 90% to 10% of VDD

### Why Slew Matters

| Slew | Effect |
|------|--------|
| Fast (<0.5ns) | Good timing, sharp edges |
| Moderate (0.5-1.5ns) | Acceptable for most designs |
| Slow (>2ns) | Problems: increased delay, uncertainty |

### Problems from Excessive Slew

1. **Increased Gate Delay**: Slow input transition = slow gate response
2. **Timing Uncertainty**: Threshold crossing becomes ambiguous
3. **Hold Violations**: Slow slew can cause hold failures
4. **Increased Power**: Longer time in transition = more short-circuit current
5. **Noise Sensitivity**: Slow edges are more susceptible to noise

### Typical Max Transition Values

| Technology | Typical max_transition |
|------------|----------------------|
| 180nm | 2.0-3.0 ns |
| 130nm (Sky130) | 1.0-1.5 ns |
| 65nm | 0.5-0.8 ns |
| 28nm | 0.2-0.4 ns |
| 7nm | 0.05-0.1 ns |

### How repair_timing Fixes Slew

The tool:
1. Identifies nets with slew violations
2. Sizes up weak drivers
3. Inserts buffers to break long nets
4. Re-checks until slew is within limits

---

## Quiz Answers

1. **B** - The time for a signal to change between logic levels
2. **C** - Increased delay and timing uncertainty
3. **B** - set_max_transition
4. **C** - No set_max_transition constraint was defined
5. **B** - 1.0 ns
6. **B** - By inserting buffers to strengthen weak drivers
7. **C** - set_max_transition constraint
