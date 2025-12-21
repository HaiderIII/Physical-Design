# Solution - False Path Fiasco

## The Bug

The SDC file contains overly broad false path declarations:

```tcl
set_false_path -from [get_ports *rst*]
set_false_path -to [get_ports *rst*]
set_false_path -from [get_ports *first*]
set_false_path -to [get_ports *first*]
```

## Why It's Wrong

The wildcards match far more than intended:

**`*rst*` matches:**
- `rst_n` - ✓ The actual reset (correct to exclude)
- `burst_mode` - ✗ Contains "rst" in "buRST_mode"
- `burst_length` - ✗ Contains "rst"
- `burst_active` - ✗ Contains "rst"
- `burst_done` - ✗ Contains "rst"
- `start_burst` - ✗ Contains "rst"

**`*first*` matches:**
- `first_beat` - ✗ Functional handshake signal
- `first_data` - ✗ Data capture signal
- `first_ack` - ✗ Protocol acknowledge

## The Impact

- Timing analysis skips critical data paths
- Design appears to "pass" timing
- Real violations are hidden
- Chip fails in silicon

## The Fix

Use exact port names instead of wildcards:

```tcl
# ONLY exclude the actual async reset
set_false_path -from [get_ports rst_n]

# Remove all other false path declarations!
# The "first*" signals are functional - they must be timed!
```

## Fixed SDC

```tcl
create_clock -name clk -period 2.0 [get_ports clk]
set_clock_uncertainty 0.1 [get_clocks clk]

set_input_delay -clock clk 0.3 [get_ports rst_n]
set_input_delay -clock clk 0.3 [get_ports start_burst]
# ... (all other inputs)

set_output_delay -clock clk 0.3 [get_ports burst_active]
# ... (all other outputs)

set_max_transition 0.15 [current_design]
set_max_fanout 16 [current_design]

# CORRECT: Only the actual async reset is a false path
set_false_path -from [get_ports rst_n]
```

## Quiz Answers

Q1: B) Exclude paths from timing analysis
Q2: B) Exclude asynchronous reset paths
Q3: B) It may match unintended ports like "burst_mode"
Q4: B) Critical timing violations are hidden from analysis
Q5: B) Timing paths were incorrectly excluded from analysis
Q6: B) Use `get_ports *pattern*` in TCL
Q7: B) `set_false_path -from [get_ports rst_n]`

## Key Lesson

**Never use wildcards in `set_false_path` without verifying what they match!**

Always run `get_ports *pattern*` to see exactly which ports will be affected before adding a false path constraint.
