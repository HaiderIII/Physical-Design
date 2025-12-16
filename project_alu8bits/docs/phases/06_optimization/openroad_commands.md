# Phase 6: Optimization - OpenROAD Commands

## Overview

This document covers the essential OpenROAD commands used during the optimization phase.

## Reading Design Database

### Load Routed Design

Read the database from routing:
    read_db <path_to_routed.odb>

Example:
    read_db results/alu_8bit/05_routing/alu_8bit_routed.odb

This loads the fully routed design for optimization.

## Timing Analysis

### Report Timing Paths

Basic timing report:
    report_checks

Detailed timing with options:
    report_checks -path_delay min_max -format full_clock_expanded

Setup timing only:
    report_checks -path_delay max

Hold timing only:
    report_checks -path_delay min

### Report Multiple Paths

Show multiple worst paths:
    report_checks -path_delay max -endpoint_count 10

Show paths through specific pin:
    report_checks -through <pin_name>

### Worst Slack

Report worst slack:
    report_worst_slack -max
    report_worst_slack -min

### Total Negative Slack

Sum of all violations:
    report_tns

Setup TNS:
    report_tns -max

Hold TNS:
    report_tns -min

### Timing Summary

Quick timing overview:
    report_check_types -max_slew -max_capacitance -max_fanout

## Timing Optimization

### Repair Setup Timing

Fix setup violations:
    repair_timing -setup

With slack margin:
    repair_timing -setup -slack_margin <value>

Example:
    repair_timing -setup -slack_margin 0.1

### Repair Hold Timing

Fix hold violations:
    repair_timing -hold

With slack margin:
    repair_timing -hold -slack_margin <value>

Example:
    repair_timing -hold -slack_margin 0.05

### Combined Repair

Fix both setup and hold:
    repair_timing -setup -hold

Note: Usually better to fix setup first, then hold.

### Repair Design

General design optimization:
    repair_design

This fixes:
- Max slew violations
- Max capacitance violations
- Max fanout violations
- Long wires

With specific options:
    repair_design -max_wire_length <value>

## Buffer Operations

### Buffer Insertion

Insert buffers on long nets:
    repair_design -max_wire_length 100

Insert buffers for fanout:
    repair_design -max_fanout 20

### Remove Buffers

Remove unnecessary buffers:
    remove_buffers

Note: Use carefully, may affect timing.

## Gate Sizing

### Resize Gates

Automatic gate sizing for timing:
    repair_timing -setup

This internally resizes gates.

### Report Cell Sizes

Check cells that were resized:
    report_design_area

## Power Analysis

### Report Power

Basic power report:
    report_power

Detailed power by hierarchy:
    report_power -hierarchy

### Power by Instance

Report power for specific instance:
    report_power -instance <instance_name>

### Switching Activity

Set switching activity for power analysis:
    set_switching_activity -activity <value> -duty <value>

Example:
    set_switching_activity -activity 0.1 -duty 0.5

## Design Analysis

### Report Design Area

Check area after optimization:
    report_design_area

### Report Cell Count

Count cells by type:
    report_cell_usage

### Report Net Statistics

Net information:
    report_net <net_name>

### Check Design

Verify design integrity:
    check_setup

## Parasitic Estimation

### Update Parasitics

Re-estimate after changes:
    estimate_parasitics -placement

Note: After buffer insertion or gate sizing, parasitics change.

## Clock Analysis

### Report Clock Skew

Check clock after optimization:
    report_clock_skew

### Report Clock Latency

Check clock delays:
    report_checks -path_delay max -group_count 5

## Constraint Verification

### Check Max Slew

Report slew violations:
    report_check_types -max_slew -violators

### Check Max Capacitance

Report capacitance violations:
    report_check_types -max_capacitance -violators

### Check Max Fanout

Report fanout violations:
    report_check_types -max_fanout -violators

## Incremental Optimization

### Iterative Flow

Typical optimization sequence:

Step 1 - Analyze initial timing:
    report_worst_slack -max
    report_worst_slack -min
    report_tns

Step 2 - Fix setup violations:
    repair_timing -setup

Step 3 - Re-analyze:
    report_worst_slack -max
    report_tns

Step 4 - Fix hold violations:
    repair_timing -hold

Step 5 - Final analysis:
    report_worst_slack -max
    report_worst_slack -min
    report_tns

Step 6 - Fix other violations:
    repair_design

## Writing Output Files

### Save Optimized Database

Write database after optimization:
    write_db <output.odb>

Example:
    write_db results/alu_8bit/06_optimization/alu_8bit_optimized.odb

### Write DEF

Export optimized design:
    write_def <output.def>

### Write Verilog

Export optimized netlist:
    write_verilog <output.v>

Note: Netlist may change if buffers added or gates resized.

### Write Timing Reports

Save timing to file:
    report_checks -path_delay min_max > timing_report.txt

## Complete Optimization Sequence

Typical command sequence:

Step 1 - Load routed design:
    read_db results/alu_8bit/05_routing/alu_8bit_routed.odb

Step 2 - Load constraints:
    read_sdc designs/alu_8bit/constraints/alu_8bit.sdc

Step 3 - Initial timing analysis:
    puts "Initial Timing:"
    report_worst_slack -max
    report_worst_slack -min
    report_tns

Step 4 - Repair setup timing:
    repair_timing -setup
    puts "After Setup Repair:"
    report_worst_slack -max

Step 5 - Repair hold timing:
    repair_timing -hold
    puts "After Hold Repair:"
    report_worst_slack -min

Step 6 - Repair design violations:
    repair_design
    puts "After Design Repair:"
    report_check_types -max_slew -max_capacitance -max_fanout

Step 7 - Update parasitics:
    estimate_parasitics -placement

Step 8 - Final timing:
    puts "Final Timing:"
    report_checks -path_delay min_max

Step 9 - Power analysis:
    report_power

Step 10 - Area report:
    report_design_area

Step 11 - Save results:
    write_db results/alu_8bit/06_optimization/alu_8bit_optimized.odb
    write_def results/alu_8bit/06_optimization/alu_8bit_optimized.def
    write_verilog results/alu_8bit/06_optimization/alu_8bit_optimized.v

## Troubleshooting

### Common Issues and Solutions

Issue: Setup violations remain after repair
Solution: Check if cells are at maximum size, may need design changes

Issue: Hold violations after setup repair
Solution: Run hold repair after setup repair, use slack margin

Issue: Repair causes new violations
Solution: Use smaller slack margins, iterate carefully

Issue: Power too high
Solution: Downsize non-critical cells, use high-Vt cells if available

Issue: Area increased significantly
Solution: Expected due to buffer insertion, check if acceptable

## Advanced Options

### Slack Margin

Add margin to repairs:
    repair_timing -setup -slack_margin 0.2
    repair_timing -hold -slack_margin 0.1

Larger margin = more conservative.

### Skip Specific Pins

Exclude pins from optimization:
    repair_timing -setup -skip_pin_swap

### Verbose Output

See detailed optimization progress:
    repair_timing -setup -verbose

Note: May not be available in all versions.

## Best Practices

1. Always check timing before and after optimization
2. Fix setup violations before hold violations
3. Use slack margins for robustness
4. Verify area impact is acceptable
5. Re-run parasitic estimation after changes
6. Save database after successful optimization
7. Document timing improvements

## Metrics to Track

Before and after optimization:
- Worst setup slack
- Worst hold slack
- Total negative slack (TNS)
- Number of violating paths
- Design area
- Buffer count
- Power consumption

## Next Phase

After optimization succeeds, proceed to sign-off:
- Final DRC verification
- LVS verification
- Timing signoff
- Power verification
