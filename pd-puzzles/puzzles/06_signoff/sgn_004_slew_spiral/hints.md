# Hints - Slew Spiral

## Hint 1: Understanding Slew/Transition
<details>
<summary>Click to reveal</summary>

**Slew** (or transition time) is how long a signal takes to change from low to high (rise) or high to low (fall).

- Fast slew = quick transition = good for timing
- Slow slew = gradual transition = bad for timing

Slow slew causes:
- Increased gate delay
- Uncertainty in threshold crossing
- Hold time violations
- Increased power consumption
</details>

## Hint 2: Check the SDC File
<details>
<summary>Click to reveal</summary>

Look at `resources/constraints.sdc`. It has:
- Clock definition ✓
- Input delays ✓
- Output delays ✓

What's missing? There's no constraint on signal transition times!

Without `set_max_transition`, the tool doesn't know what slew limits to enforce.
</details>

## Hint 3: The Missing Command
<details>
<summary>Click to reveal</summary>

The SDC is missing:
```tcl
set_max_transition <value> [current_design]
```

This tells the timing analyzer to flag any signal with transition time exceeding `<value>`.

For Sky130HD at typical corner, reasonable values are:
- Aggressive: 0.5 ns
- Moderate: 1.0 ns
- Relaxed: 1.5 ns
</details>

## Hint 4: Why No Violations Reported?
<details>
<summary>Click to reveal</summary>

The command `report_check_types -max_slew -violators` shows nothing because:
1. No `set_max_transition` constraint exists
2. Without a limit, nothing can violate it!

It's like having no speed limit - nobody gets a ticket, but that doesn't mean everyone is driving safely.
</details>

## Hint 5: Adding the Constraint
<details>
<summary>Click to reveal</summary>

Add to your SDC file:
```tcl
# Set maximum transition time (slew) for all signals
set_max_transition 1.0 [current_design]
```

This applies a 1.0 ns max slew to all nets in the design.

You can also set different limits for:
- Clock nets: `set_max_transition 0.3 [get_clocks clk]`
- Data paths: `set_max_transition 1.0 [current_design]`
</details>

## Hint 6: Full Solution
<details>
<summary>Click to reveal</summary>

Add these lines to `resources/constraints.sdc`:
```tcl
# Maximum transition (slew) constraints
set_max_transition 1.0 [current_design]

# Stricter constraint for clock (optional)
set_max_transition 0.5 [get_clocks clk]
```

Then in `run.tcl`, after global routing, add:
```tcl
# Repair timing violations including slew
repair_timing -slew_margin 0.1
```

This will insert buffers to fix slow transitions.
</details>
