# Padding Overflow

## Level: Expert
## PDK: Sky130HD

---

## Scenario

The physical design team has configured cell padding for a critical design to ensure proper metal density around cells. However, the detailed placement step is now failing with multiple cells unable to find legal positions.

The design is a simple 8-bit ALU that should easily fit in the floorplan with the target density.

## Symptoms

When you run the flow:
```
[ERROR DPL-0036] Detailed placement failed.
```

The detailed placement reports multiple instances that cannot be placed:
```
[INFO DPL-0034] Detailed placement failed on the following instances:
```

## Your Mission

1. Run the flow and observe the failure
2. Analyze why cells cannot be placed
3. Identify the configuration issue
4. Fix the problem and achieve successful placement

## Success Criteria

- [ ] Flow runs without placement errors
- [ ] `check_placement` passes
- [ ] All cells are legally placed

## Commands

```bash
# Run the puzzle
cd /path/to/plc_004_padding_overflow
openroad run.tcl

# When solved, verify
openroad .solution/run_fixed.tcl
```

## Hints

See `hints.md` for progressive hints if you get stuck.
