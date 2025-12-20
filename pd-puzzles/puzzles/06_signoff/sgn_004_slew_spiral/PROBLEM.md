# Slew Spiral

## Difficulty: Expert
## PDK: Sky130HD

---

## Background

You're working on a high-performance 4-stage data processor pipeline running at 200 MHz. The design has passed synthesis, placement, CTS, and routing. Now you're performing sign-off timing analysis.

The timing reports show the design meets setup requirements, but there are numerous transition (slew) violations that could cause problems in silicon.

---

## The Problem

Run the flow:
```bash
openroad run.tcl
```

The sign-off analysis completes, but check the transition/slew reports carefully. The SDC constraints are missing critical slew limits, which means:
1. No transition violations are reported (because no limits are set)
2. The design may have excessive slew in silicon
3. Hold time calculations may be inaccurate

---

## Your Task

1. Analyze the timing reports in `run.tcl` output
2. Examine the SDC constraints in `resources/constraints.sdc`
3. Identify what slew-related constraints are missing
4. Add appropriate transition constraints

---

## Success Criteria

After fixing:
- `set_max_transition` constraint is applied
- Slew violations are detected and reported
- Use `repair_timing` to fix violations
- Design achieves timing closure

---

## Hints

See `hints.md` for progressive hints if you get stuck.

---

## Key Concepts

- Transition time (slew) and its impact on timing
- `set_max_transition` command
- Relationship between slew and setup/hold timing
- Design rule constraints vs timing constraints
