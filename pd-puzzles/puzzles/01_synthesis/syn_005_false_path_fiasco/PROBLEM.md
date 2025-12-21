# False Path Fiasco

## Difficulty: Master
## PDK: Nangate45 (45nm)
## Phase: Synthesis / Timing Constraints

---

## Problem Description

You're working on a burst controller that handles data transfers. The design has been through synthesis and PnR, and the timing report shows clean results with positive slack.

However, when the chip comes back from fabrication, it fails timing in real operation! Data is corrupted during burst transfers.

Something is wrong with the timing analysis - it's not checking all the paths it should.

## Symptoms

1. Timing report shows positive slack (looks clean!)
2. All endpoints seem to be met
3. But functional signals like `burst_mode`, `first_data`, and `first_ack` are being ignored
4. The chip fails in silicon despite "passing" timing

## Your Task

1. Run the flow and observe the timing results
2. Analyze the false path declarations in the SDC
3. Understand why timing looks "too good"
4. Fix the SDC to properly analyze all functional paths

## Files

- `resources/burst_controller.v` - Burst transfer controller
- `resources/constraints.sdc` - Timing constraints (contains the bug!)
- `synth.ys` - Yosys synthesis script
- `run.tcl` - OpenROAD flow script

## Running the Puzzle

```bash
cd /path/to/syn_005_false_path_fiasco
openroad run.tcl 2>&1 | tee run.log
```

## Success Criteria

- Identify which false paths are incorrectly excluding functional signals
- Fix the SDC to use precise port names instead of wildcards
- The design may show timing violations after fixing (that's correct!)

## Hints

See `hints.md` for progressive hints if you get stuck.
