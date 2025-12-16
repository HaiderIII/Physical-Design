# Phase 5: Routing - OpenROAD Commands

## Overview

This document covers the essential OpenROAD commands used during the routing phase.

## Reading Design Database

### Load CTS Results

Read the database from clock tree synthesis:
    read_db <path_to_cts.odb>

Example:
    read_db results/alu_8bit/04_cts/alu_8bit_cts.odb

This loads the design with placed cells and clock tree.

## Global Routing

### Basic Global Routing

Run global routing with default settings:
    global_route

This plans routes for all nets using GCell grid.

### Global Routing with Options

Control global routing behavior:

    global_route \
      -guide_file <output_guide_file> \
      -congestion_iterations <num> \
      -verbose

Parameters:
- guide_file: Save routing guides for detailed router
- congestion_iterations: Number of iterations to resolve congestion
- verbose: Print detailed progress

Example:
    global_route -guide_file route.guide -verbose

### Timing-Driven Global Routing

Enable timing optimization during global routing:
    global_route -critical_nets_percentage <value>

Example:
    global_route -critical_nets_percentage 10

Routes top 10% critical nets with priority.

### Set Global Routing Layer Range

Limit which metal layers can be used:
    set_global_routing_layer_adjustment <layer> <adjustment>

Example:
    set_global_routing_layer_adjustment met1 0.5

Reduces met1 capacity by 50% (avoid if congested).

## Detailed Routing

### Basic Detailed Routing

Run detailed routing:
    detailed_route

This completes the actual wire geometry.

### Detailed Routing with Options

Control detailed routing behavior:

    detailed_route \
      -guide <guide_file> \
      -output_guide <output_file> \
      -verbose \
      -param <parameter_file>

Parameters:
- guide: Use routing guides from global route
- output_guide: Save updated guides
- verbose: Detailed progress output
- param: Custom routing parameters file

### Detailed Routing Iterations

Run multiple passes to fix violations:
    detailed_route -bottom_routing_layer <layer>
    detailed_route -top_routing_layer <layer>

Example:
    detailed_route -bottom_routing_layer met1 -top_routing_layer met5

### Via Optimization

Minimize via count:
    detailed_route -via_in_pin_bottom_layer <layer>
    detailed_route -via_in_pin_top_layer <layer>

Controls via usage near pins.

## Design Rule Checking

### Check DRC Violations

Verify design rules after routing:
    check_drc

Reports any spacing, width, or other violations.

### Get DRC Report

Generate detailed DRC report:
    report_drc_violations

Shows violation types and locations.

### Count Violations

Get violation statistics:
    check_drc -verbose

Prints count of each violation type.

## Connectivity Verification

### Check All Nets Routed

Verify routing completion:
    check_connectivity

Reports any unrouted nets or opens.

### Report Unrouted Nets

List nets that failed to route:
    report_net <net_name>

Shows routing status of specific net.

## Antenna Rule Checking

### Check Antenna Violations

Verify antenna rules:
    check_antennas

Antenna violations can damage gates during manufacturing.

### Fix Antenna Violations

Automatically insert diodes:
    repair_antennas <diode_cell>

Example:
    repair_antennas sky130_fd_sc_hd__diode_2

Adds protection diodes where needed.

## Parasitics Extraction

### Extract Parasitics After Routing

Calculate RC values from routed wires:
    estimate_parasitics -spef_file <output.spef>

Example:
    estimate_parasitics -spef_file results/parasitics.spef

Generates Standard Parasitic Exchange Format file.

### Global Route Based Extraction

Quick extraction from global routing:
    estimate_parasitics -global_routing

Less accurate but faster than full extraction.

## Timing Analysis After Routing

### Post-Route Timing

Run timing with extracted parasitics:
    report_checks -path_delay min_max

Most accurate timing analysis.

### Setup Timing Check

Check max delay paths:
    report_checks -path_delay max

### Hold Timing Check

Check min delay paths:
    report_checks -path_delay min

### Detailed Timing Report

Full timing with routing parasitics:
    report_checks \
      -path_delay min_max \
      -format full_clock_expanded \
      -fields {slew cap input_pins nets fanout}

### Worst Slack

Report worst slack values:
    report_worst_slack -max
    report_worst_slack -min

### Total Negative Slack

Sum of all negative slacks:
    report_tns -max
    report_tns -min

## Timing Optimization After Routing

### Buffer Insertion

Add buffers to improve timing:
    repair_timing -setup
    repair_timing -hold

May need to reroute after buffer insertion.

### Gate Sizing

Resize gates for timing:
    repair_timing -setup -hold

Adjusts drive strength of cells.

### Repair Design

Comprehensive timing fix:
    repair_design -max_wire_length <value>

Inserts buffers on long wires.

## Congestion Analysis

### Report Routing Congestion

Check routing resource usage:
    report_congestion

Shows congested regions.

### Visualize Congestion

In GUI, view congestion map:
    gui::show_congestion

Heat map of routing demand.

## Routing Statistics

### Report Wire Length

Total routed wirelength:
    report_wire_length

Shows length per metal layer.

### Report Via Count

Number of vias used:
    report_design_area

Includes via statistics.

### Routing Resource Usage

Track utilization per layer:
    report_route_utilization

Shows percentage of tracks used.

## Writing Output Files

### Save Routed Database

Write database with routing:
    write_db <output.odb>

Example:
    write_db results/alu_8bit/05_routing/alu_8bit_routed.odb

### Write DEF

Export routed design:
    write_def <output.def>

Example:
    write_def results/alu_8bit/05_routing/alu_8bit_routed.def

### Write Verilog

Export netlist (unchanged by routing):
    write_verilog <output.v>

Netlist same as CTS, routing doesn't change connectivity.

### Write SPEF

Export parasitic data:
    write_spef <output.spef>

Used for accurate timing analysis.

### Write GDSII (if stream out available)

Final layout format:
    write_gds <output.gds>

Note: May require additional setup/tools.

## Complete Routing Command Sequence

Here is a typical command sequence for routing:

Step 1 - Load design with CTS:
    read_db results/alu_8bit/04_cts/alu_8bit_cts.odb

Step 2 - Load timing constraints:
    read_sdc designs/alu_8bit/constraints/alu_8bit.sdc

Step 3 - Configure wire RC:
    set_wire_rc -signal -layer met2
    set_wire_rc -clock -layer met3

Step 4 - Run global routing:
    global_route -verbose

Step 5 - Run detailed routing:
    detailed_route -verbose

Step 6 - Check for DRC violations:
    check_drc

Step 7 - Check antenna violations:
    check_antennas

Step 8 - Extract parasitics:
    estimate_parasitics -spef_file results/parasitics.spef

Step 9 - Run post-route timing:
    report_checks -path_delay min_max

Step 10 - Check worst slack:
    report_worst_slack -max
    report_worst_slack -min

Step 11 - Fix timing if needed:
    repair_timing -hold

Step 12 - Save routed design:
    write_db results/alu_8bit/05_routing/alu_8bit_routed.odb
    write_def results/alu_8bit/05_routing/alu_8bit_routed.def

## Visualization Commands

### GUI Routing View

If using OpenROAD GUI:

View routing:
    gui::fit

Show specific metal layer:
    gui::show_layer <layer_name>

Highlight net:
    gui::highlight_net <net_name>

Show routing congestion:
    gui::show_congestion

## Troubleshooting

### Common Issues and Solutions

Issue: Routing fails to complete (unrouted nets)
Solution: Check congestion, increase core area, reduce utilization

Issue: Many DRC violations
Solution: Run detailed_route multiple times, check design rules

Issue: Timing violations after routing
Solution: Use repair_timing, may need placement changes

Issue: High antenna violations
Solution: Run repair_antennas with appropriate diode cell

Issue: Long runtime
Solution: Reduce design size, use fewer routing iterations

## Advanced Options

### Multi-Threading

Speed up routing with parallel processing:
    set_thread_count <num_threads>

Example:
    set_thread_count 4
    global_route
    detailed_route

Uses 4 CPU cores for faster routing.

### Routing Guides

Use previous routing as guide:
    global_route -guide_file previous.guide
    detailed_route -guide previous.guide

Helpful for incremental changes.

### Layer-Specific Settings

Adjust routing on specific layers:
    set_routing_layers -signal <min_layer> <max_layer>

Example:
    set_routing_layers -signal met1 met5

Restricts signal routing to specified layers.

## Metrics and Reporting

### Wirelength Report

Total routed wire:
    report_wire_length

Broken down by metal layer.

### Via Count Report

Number of vias:
    report_design_area

Includes via statistics.

### DRC Summary

Violation count:
    check_drc -verbose

Shows number of each violation type.

### Timing Summary

Quick timing overview:
    report_checks -format summary

Shows worst paths only.

### Detailed Timing

Full path analysis:
    report_checks -path_delay min_max -format full_clock_expanded

Complete timing information.

## Best Practices

1. Always run global routing before detailed routing
2. Check DRC after detailed routing
3. Fix antenna violations before final timing
4. Extract parasitics for accurate timing
5. Iterate routing if violations remain
6. Save database after successful routing
7. Keep backup of routed design
8. Document any manual fixes

## Command Availability Notes

Some commands may vary by OpenROAD version:
- check_drc: Core command, should be available
- repair_antennas: May need specific cell library setup
- write_gds: May require additional tools/setup

Always check command help:
    help <command_name>

## Next Phase Commands

After routing succeeds, proceed to verification:
- DRC verification
- LVS verification
- Timing signoff
- Manufacturing checks

These typically use external tools (Magic, Netgen, etc).
