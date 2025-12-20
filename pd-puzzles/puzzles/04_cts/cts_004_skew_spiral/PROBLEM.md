# Skew Spiral

## Level: Expert
## PDK: Sky130HD

---

## Scenario

Your CTS engineer has configured the clock tree synthesis for a register file design. The flow completes, but there are warnings in the log about wire RC estimation. The timing analysis may not be accurate.

When you check the CTS report, you notice that the clock tree was built without proper wire characterization.

## Symptoms

When you run the flow:
```
[WARNING EST-0027] no estimated parasitics. Using wire load models.
[WARNING EST-0018] wire capacitance for corner default is zero.
```

The CTS completes but without proper wire RC estimation, the clock tree quality cannot be verified.

## Your Mission

1. Run the flow and observe the warnings
2. Identify what configuration is missing for CTS
3. Fix the issue to enable proper clock wire RC estimation
4. Verify the warnings are resolved

## Success Criteria

- [ ] Flow runs without wire RC warnings
- [ ] CTS uses proper layer-based RC values
- [ ] Clock tree timing is accurately estimated

## Commands

```bash
# Run the puzzle
cd /path/to/cts_004_skew_spiral
openroad run.tcl

# When solved, verify
openroad .solution/run_fixed.tcl
```

## Hints

See `hints.md` for progressive hints if you get stuck.
