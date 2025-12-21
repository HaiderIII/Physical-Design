# Hints for SGN_005: DRC Disaster

## Hint 1: Understanding the Violations
The DRC report shows violations in format: `pin  limit  actual  slack`
- Negative slack = violation
- Fanout violations: Too many sinks driven by one output
- Capacitance violations: Load too high for driver
- Slew violations: Transition time too long

## Hint 2: Check the SDC Constraints
Look at `resources/constraints.sdc`:
```tcl
set_max_fanout 5 [current_design]
set_max_transition 0.05 [current_design]
set_max_capacitance 0.01 [current_design]
```
These are very restrictive values causing violations.

## Hint 3: The Missing Command
The flow is missing `repair_design` which:
- Inserts buffers to reduce fanout
- Sizes up drivers to meet capacitance limits
- Adds buffers to fix slew violations

## Hint 4: The Fix
Add `repair_design` after `estimate_parasitics`:
```tcl
estimate_parasitics -global_routing
repair_design
detailed_placement
check_placement -verbose
estimate_parasitics -global_routing
```

## Hint 5: Alternative Fix
You could also relax the SDC constraints to more reasonable values:
```tcl
set_max_fanout 20 [current_design]
set_max_transition 0.5 [current_design]
set_max_capacitance 0.1 [current_design]
```

## Why This Matters

1. **Signal Integrity**: High fanout causes slow edges, noise issues
2. **Manufacturing**: DRC violations can cause yield issues
3. **Reliability**: Overstressed drivers have shorter lifespan
4. **Signoff**: Foundry won't accept designs with DRC violations

## Industry Practice

1. Always run `repair_design` after routing
2. Check DRC violations with `report_check_types -violators`
3. Fix violations before tapeout
4. Use reasonable DRC limits based on PDK recommendations
