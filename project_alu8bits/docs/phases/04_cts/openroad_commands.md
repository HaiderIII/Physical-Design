# Phase 4: Clock Tree Synthesis - OpenROAD Commands

## Overview

This document covers the essential OpenROAD commands used during the Clock Tree Synthesis (CTS) phase.

## Reading Design Database

### Load Placement Results

Read the database from placement:
    read_db <path_to_placement.odb>

Example:
    read_db results/alu_8bit/03_placement/alu_8bit_placed.odb

This loads the placed design ready for CTS.

## Clock Tree Synthesis

### Basic CTS Command

Run clock tree synthesis with default settings:
    clock_tree_synthesis

This builds the clock tree automatically using TritonCTS.

### CTS with Options

Control CTS behavior with parameters:

    clock_tree_synthesis \
      -buf_list <buffer_list> \
      -root_buf <root_buffer> \
      -sink_clustering_size <size> \
      -sink_clustering_max_diameter <distance>

Parameters:
- buf_list: List of buffers to use (e.g., "sky130_fd_sc_hd__clkbuf_1 sky130_fd_sc_hd__clkbuf_2")
- root_buf: Buffer for clock root (larger buffer)
- sink_clustering_size: Number of sinks per cluster
- sink_clustering_max_diameter: Maximum cluster diameter in microns

Example:
    clock_tree_synthesis \
      -buf_list "sky130_fd_sc_hd__clkbuf_1 sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_4" \
      -root_buf "sky130_fd_sc_hd__clkbuf_16"

### Set Clock Nets

Explicitly specify which nets are clocks:
    set_propagated_clock [all_clocks]

This tells the tool to use real (propagated) clock delays instead of ideal clocks.

## Clock Tree Analysis

### Report Clock Skew

Check clock skew after CTS:
    report_clock_skew

Shows skew between all clock sinks.

Alternative with more detail:
    report_clock_skew -setup
    report_clock_skew -hold

### Report Clock Latency

Check clock latency (if command available):
    report_clock_latency

Shows delay from clock source to each sink.

Note: This command may not be available in all OpenROAD versions.

### Report Clock Tree

Get statistics about the clock tree:
    report_clock_tree

Shows:
- Number of buffers inserted
- Buffer types used
- Tree levels
- Clock net information

Note: Command availability varies by version.

## Timing Analysis After CTS

### Post-CTS Timing

Run timing analysis with real clock tree:
    report_checks -path_delay min_max

This now includes clock tree delays.

### Setup Timing Check

Check setup timing (max delay):
    report_checks -path_delay max

### Hold Timing Check

Check hold timing (min delay):
    report_checks -path_delay min

### Detailed Timing Report

Full timing with clock tree:
    report_checks \
      -path_delay min_max \
      -format full_clock_expanded \
      -fields {slew cap input_pins nets fanout}

### Check All Paths

Report multiple paths:
    report_checks -path_delay min_max -endpoint_count 10

Shows timing for top 10 worst paths.

### Worst Slack

Report worst negative slack:
    report_worst_slack -max
    report_worst_slack -min

### Total Negative Slack

Sum of all negative slacks:
    report_tns -max
    report_tns -min

## Clock Tree Constraints

### Set Clock Uncertainty

Account for clock jitter and skew:
    set_clock_uncertainty <value> [get_clocks <clock_name>]

Example:
    set_clock_uncertainty 0.5 [get_clocks clk]

This was set in SDC, but can be adjusted post-CTS.

### Set Clock Transition

Control clock edge transition time:
    set_clock_transition <max_transition> [get_clocks <clock_name>]

Example:
    set_clock_transition 0.5 [get_clocks clk]

### Set Max Capacitance

Limit clock net capacitance:
    set_max_capacitance <value> [get_clocks <clock_name>]

## Clock Buffer Configuration

### List Available Buffers

Check which buffers exist in library:
    get_lib_cells *clkbuf*

Shows all clock buffer cells.

### Get Cell Properties

Check buffer characteristics:
    get_lib_cell <cell_name>
    get_property [get_lib_cell <cell_name>] <property>

Properties: area, capacitance, drive_strength, etc.

## Optimization After CTS

### Repair Hold Violations

Fix hold timing after CTS:
    repair_timing -hold

Inserts delay cells on paths with hold violations.

### Repair Setup Violations

Fix setup timing:
    repair_timing -setup

May resize gates or add buffers.

### Combined Repair

Fix both setup and hold:
    repair_timing -setup -hold

Be cautious: fixing one can break the other.

### Buffer Insertion

Add buffers for long nets:
    repair_design

Inserts buffers where needed for signal integrity and timing.

## Design Inspection

### Find Clock Buffers

List all clock buffers inserted:
    get_cells -filter {ref_name =~ *clkbuf*}

### Count Clock Buffers

Count inserted buffers:
    llength [get_cells -filter {ref_name =~ *clkbuf*}]

### Check Clock Network

Verify clock connectivity:
    report_net [get_nets <clock_net_name>]

Shows fanout, capacitance, etc.

## Parasitic Estimation

### Update Parasitics

Re-estimate parasitics after CTS:
    estimate_parasitics -placement

Includes clock tree in estimation.

### Set Clock Wire RC

Configure clock wire properties (if not already set):
    set_wire_rc -clock -layer <layer_name>

Example:
    set_wire_rc -clock -layer met3

## Writing Output Files

### Save CTS Database

Write database with clock tree:
    write_db <output.odb>

Example:
    write_db results/alu_8bit/04_cts/alu_8bit_cts.odb

### Write DEF

Export to DEF:
    write_def <output.def>

Example:
    write_def results/alu_8bit/04_cts/alu_8bit_cts.def

### Write Verilog

Export netlist with clock buffers:
    write_verilog <output.v>

Shows inserted clock buffers in netlist.

### Write SDC

Export timing constraints:
    write_sdc <output.sdc>

Includes updated clock constraints.

## Complete CTS Command Sequence

Here is a typical command sequence for CTS:

Step 1 - Load placed design:
    read_db results/alu_8bit/03_placement/alu_8bit_placed.odb

Step 2 - Configure clock buffers (optional):
    set buf_list "sky130_fd_sc_hd__clkbuf_1 sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_4"

Step 3 - Run CTS:
    clock_tree_synthesis -buf_list $buf_list

Step 4 - Set propagated clock:
    set_propagated_clock [all_clocks]

Step 5 - Report clock skew:
    report_clock_skew

Step 6 - Update parasitics:
    estimate_parasitics -placement

Step 7 - Check timing:
    report_checks -path_delay min_max

Step 8 - Check worst slack:
    report_worst_slack -max
    report_worst_slack -min

Step 9 - Repair timing if needed:
    repair_timing -hold

Step 10 - Save results:
    write_db results/alu_8bit/04_cts/alu_8bit_cts.odb
    write_def results/alu_8bit/04_cts/alu_8bit_cts.def

## Visualization Commands

### GUI Clock Tree View

If using OpenROAD GUI:

View clock tree:
    gui::show_clock_tree

Highlight clock nets:
    gui::highlight_net <clock_net>

Show clock buffers:
    gui::highlight_instance [get_cells -filter {ref_name =~ *clkbuf*}]

## Troubleshooting

### Common Issues and Solutions

**Issue: CTS fails with "No clock nets found"**
Solution: Check SDC, ensure create_clock is defined, verify clock port exists

**Issue: High clock skew**
Solution: Allow more buffers, increase buffer sizes, check FF placement

**Issue: Hold violations after CTS**
Solution: Run repair_timing -hold, may need to adjust clock tree

**Issue: Clock buffers not inserted**
Solution: Check buffer list, verify buffers exist in library

**Issue: Timing worse after CTS**
Solution: Normal (clock now has real delay), may need optimization

## Advanced Options

### Clock Tree Clustering

Control how sinks are clustered:
    clock_tree_synthesis \
      -sink_clustering_enable \
      -sink_clustering_size <number> \
      -sink_clustering_max_diameter <microns>

Smaller clusters = more balanced tree, more buffers.

### Distance Between Buffers

Control buffer insertion spacing:
    clock_tree_synthesis \
      -distance_between_buffers <microns>

Affects tree depth and skew.

### Obstruction Awareness

Make CTS avoid placement blockages:
    clock_tree_synthesis -obstruction_aware

Useful if design has blockages.

## Useful Skew

### Enable Useful Skew

Allow intentional skew for timing:
    clock_tree_synthesis -apply_ndr (non-default rules)

Or use post-CTS optimization:
    repair_timing -slack_margin <value>

## Best Practices

1. Always report clock skew after CTS
2. Check both setup and hold timing
3. Compare pre-CTS vs post-CTS timing
4. Visualize clock tree in GUI
5. Document buffer count and types
6. Save database after successful CTS
7. Be prepared to iterate (CTS + timing repair)

## Command Availability Notes

Some commands may not be available in all OpenROAD versions:
- report_clock_latency: May not exist
- report_clock_tree: May not exist
- gui::show_clock_tree: GUI-dependent

Use report_checks and report_clock_skew as primary analysis tools.

## Next Phase Commands

After CTS succeeds, proceed to routing:
    global_route
    detailed_route

These will be covered in Phase 5: Routing.
