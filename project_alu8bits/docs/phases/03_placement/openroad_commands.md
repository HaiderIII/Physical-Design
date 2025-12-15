# Phase 3: Placement - OpenROAD Commands

## Overview

This document covers the essential OpenROAD commands used during the placement phase.

## Reading Design Database

### Load Floorplan Results

Read the database from floorplanning:
    read_db <path_to_floorplan.odb>

Example:
    read_db results/alu_8bit/02_floorplan/alu_8bit_fp.odb

This loads the floorplan with die/core areas, pins, and PDN.

## Global Placement

### Basic Global Placement

Run global placement with default settings:
    global_placement

This performs analytical placement to minimize wirelength.

### Global Placement with Options

Control placement behavior with parameters:

    global_placement \
      -density <target_density> \
      -timing_driven \
      -routability_driven \
      -pad_left <sites> \
      -pad_right <sites>

Parameters:
- density: Target cell density (0.0-1.0, e.g., 0.7 = 70%)
- timing_driven: Enable timing optimization
- routability_driven: Enable congestion optimization
- pad_left/right: Padding around cells (in sites)

Example:
    global_placement -density 0.6 -timing_driven

### Density Control

Adjust how densely cells are packed:

Lower density (0.4-0.6):
- More routing space
- Less congestion
- May increase wirelength

Higher density (0.7-0.9):
- Tighter packing
- Less area waste
- Risk of routing problems

## Detailed Placement

### Basic Detailed Placement

Legalize the global placement:
    detailed_placement

This removes overlaps and snaps cells to legal sites.

### Detailed Placement with Max Displacement

Limit how far cells can move during legalization:

    detailed_placement -max_displacement <distance_microns>

Example:
    detailed_placement -max_displacement 50

Smaller values preserve global placement better but may fail to legalize.

## Placement Optimization

### Improve Placement Quality

Refine placement after detailed placement:
    improve_placement

This performs local optimizations to reduce wirelength and improve timing.

### Check Placement Quality

Verify placement is legal:
    check_placement

This reports any placement violations (overlaps, off-site cells, etc.).

## Design Inspection

### Report Cell Positions

View placed cell locations:
    report_instance <instance_name>

List all instances:
    get_cells *

### Report Design Statistics

After placement, check statistics:
    report_design_area

Shows area utilization including placed cells.

## Timing Analysis After Placement

### Static Timing Analysis

Run timing analysis on placed design:
    report_checks -path_delay min_max

Detailed timing report:
    report_checks \
      -path_delay min_max \
      -format full_clock_expanded \
      -fields {slew cap input_pins nets fanout} \
      -digits 3

### Check Specific Paths

Report timing for specific endpoints:
    report_checks -to <pin_name>

Report timing from specific startpoints:
    report_checks -from <pin_name>

### Worst Negative Slack

Report worst timing violation:
    report_worst_slack

Shows the most critical timing path.

### Total Negative Slack

Report sum of all timing violations:
    report_tns

Useful metric for overall timing health.

## Congestion Analysis

### Report Routing Congestion

Analyze routing resource usage:
    estimate_parasitics -placement

Then check congestion:
    report_wire_length

### Global Routing Estimation

Run global routing to predict congestion:
    global_route

Note: This is typically done later, but can check routability after placement.

## Placement Density

### Report Density Map

Check cell density distribution:
    report_design_area

For detailed density analysis, use GUI visualization or scripting.

### Density Heatmap

In OpenROAD GUI:
    gui::show_density_map

This visualizes high-density regions.

## Placement Constraints

### Create Placement Blockages

Block cells from specific regions:

    create_placement_blockage \
      -name <blockage_name> \
      -bbox {llx lly urx ury}

Example:
    create_placement_blockage \
      -name center_block \
      -bbox {30 30 50 50}

### Soft Blockages

Create soft blockages (cells discouraged but allowed):

    create_placement_blockage \
      -name <blockage_name> \
      -bbox {llx lly urx ury} \
      -soft

### Remove Blockages

Delete a placement blockage:
    delete_placement_blockage -name <blockage_name>

## Cell-Specific Placement

### Lock Cell Position

Prevent cell from moving during optimization:
    set_placement_padding -cell <instance_name> -left 0 -right 0

### Move Specific Cell

Manually place a cell (advanced):
    place_cell <instance_name> <x> <y> -orient <orientation>

Orientations: N, S, E, W, FN, FS, FE, FW

## Buffer Insertion

### Insert Buffers for Long Nets

Add buffers to improve timing:
    buffer_ports

This adds buffers near I/O ports if needed.

### Repair Design

Fix timing violations with buffers and sizing:
    repair_design

This is typically done during optimization phases.

## Writing Output Files

### Save Placement Database

Write current state to database:
    write_db <output.odb>

Example:
    write_db results/alu_8bit/03_placement/alu_8bit_placed.odb

### Write DEF

Export to DEF format:
    write_def <output.def>

Example:
    write_def results/alu_8bit/03_placement/alu_8bit_placed.def

### Write Verilog

Export netlist with physical annotations:
    write_verilog <output.v>

## Visualization Commands

### GUI Placement View

If using OpenROAD GUI:

Fit design in window:
    gui::fit

Show placement:
    gui::show_placement

Highlight specific cell:
    gui::highlight_instance <instance_name>

Highlight net:
    gui::highlight_net <net_name>

### Zoom to Cell

Zoom to specific cell location:
    gui::zoom_to_instance <instance_name>

## Complete Placement Command Sequence

Here is a typical command sequence for placement:

Step 1 - Load floorplan:
    read_db results/alu_8bit/02_floorplan/alu_8bit_fp.odb

Step 2 - Run global placement:
    global_placement -density 0.6 -timing_driven

Step 3 - Run detailed placement:
    detailed_placement

Step 4 - Check placement legality:
    check_placement

Step 5 - Improve placement:
    improve_placement

Step 6 - Estimate parasitics:
    estimate_parasitics -placement

Step 7 - Run timing analysis:
    report_checks -path_delay min_max

Step 8 - Report wire length:
    report_wire_length

Step 9 - Save placement:
    write_db results/alu_8bit/03_placement/alu_8bit_placed.odb
    write_def results/alu_8bit/03_placement/alu_8bit_placed.def

Step 10 - Exit:
    exit

## Advanced Placement Options

### Incremental Placement

Update placement for design changes:
    global_placement -incremental

Faster than full placement, preserves most positions.

### Skip Initial Placement

If cells already have positions:
    global_placement -skip_initial_place

### Set Initial Density

Control starting density for global placement:
    global_placement -init_density <value>

Lower initial density can improve convergence.

## Timing-Driven Placement

### Enable Timing Optimization

Use timing information during placement:
    global_placement -timing_driven

Requires SDC constraints to be loaded.

### Set Critical Path Weight

Emphasize critical paths:
    set_wire_rc -clock <clock_resistance> <clock_capacitance>
    set_wire_rc -signal <signal_resistance> <signal_capacitance>

Affects timing-driven placement behavior.

## Routability-Driven Placement

### Enable Congestion Optimization

Consider routing resources during placement:
    global_placement -routability_driven

Spreads cells to avoid congestion.

### Adjust Overflow Iterations

Control congestion optimization effort:
    global_placement \
      -routability_driven \
      -routability_check_overflow <iterations>

More iterations = better congestion but slower.

## Placement Padding

### Add Spacing Around Cells

Create space between cells for routing:

    set_placement_padding -global -left <sites> -right <sites>

Example:
    set_placement_padding -global -left 2 -right 2

This adds 2 sites of padding on each side of every cell.

### Cell-Specific Padding

Add padding to specific cells:
    set_placement_padding -cell <instance_name> -left <sites> -right <sites>

Useful for noisy or critical cells.

## Troubleshooting Commands

### Check for Overlaps

Verify no cells overlap:
    check_placement -verbose

Reports any overlapping cells or violations.

### Report Placement Failures

If placement fails, check:
    report_design_area

Look for:
- Insufficient sites
- Blockages preventing legalization
- Cells too large for rows

### Debug Specific Cells

Find cell location:
    get_property [get_cells <instance_name>] origin

Check if cell is placed:
    get_property [get_cells <instance_name>] is_placed

## Metrics and Reporting

### Wirelength Report

Total wirelength after placement:
    report_wire_length

Shows half-perimeter wirelength (HPWL) for all nets.

### Timing Summary

Quick timing overview:
    report_checks -format summary

Shows count of violated paths and worst slack.

### Detailed Timing

Full timing path details:
    report_checks -path_delay min_max -format full_clock_expanded

Includes cell delays, net delays, arrival times.

## Best Practices

1. Always run check_placement after detailed_placement
2. Use timing_driven for designs with tight timing
3. Use routability_driven if placement is dense
4. Visualize placement in GUI before proceeding
5. Save database after successful placement
6. Check timing reports for violations
7. Iterate if quality is poor
8. Document any manual interventions

## Common Issues and Solutions

Issue: Global placement doesn't converge
Solution: Adjust density, increase core area, check for blockages

Issue: Detailed placement fails
Solution: Lower density, increase displacement limit, remove tight constraints

Issue: Bad timing after placement
Solution: Enable timing_driven, check SDC, increase clock period for learning

Issue: High congestion
Solution: Enable routability_driven, lower density, increase routing layers

Issue: Cells off-grid
Solution: Ensure LEF/DEF units match, check site definitions

## Tips for Learning

1. Start with default global_placement
2. Visualize in GUI after each step
3. Experiment with different density values
4. Compare timing with and without timing_driven
5. Understand trade-offs between density and routability
6. Save multiple placement versions to compare

## Next Phase Commands

After placement succeeds, proceed to CTS:
    clock_tree_synthesis

This will be covered in Phase 4: Clock Tree Synthesis.
