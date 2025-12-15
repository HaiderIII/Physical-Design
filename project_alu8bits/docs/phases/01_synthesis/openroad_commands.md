# Phase 1: Synthesis - OpenROAD Commands

## Overview

This document covers the essential OpenROAD and Yosys commands used during the synthesis phase.

## Basic OpenROAD Commands

### Starting OpenROAD

Launch OpenROAD shell:
    openroad

Run a TCL script:
    openroad script.tcl

Run with logging:
    openroad -log synthesis.log script.tcl

### Reading Technology Files

Read Liberty timing library (typical corner):
    read_liberty <path_to_lib_file>

Read multiple corners (fast, typical, slow):
    read_liberty -corner fast <path_to_fast_lib>
    read_liberty -corner typical <path_to_typical_lib>
    read_liberty -corner slow <path_to_slow_lib>

### Reading LEF Files

Read technology LEF (layers, vias, design rules):
    read_lef <path_to_tech_lef>

Read standard cell LEF (cell abstracts):
    read_lef <path_to_sc_lef>

## Synthesis with Yosys

OpenROAD can invoke Yosys for synthesis or you can use Yosys standalone.

### Using Yosys Directly

Read Verilog RTL:
    read_verilog <rtl_file.v>

Synthesize to generic gates:
    synth -top <top_module_name>

Technology mapping to Liberty library:
    dfflibmap -liberty <lib_file>
    abc -liberty <lib_file>

Cleanup:
    clean

Write synthesized netlist:
    write_verilog -noattr <output_netlist.v>

### Synthesis in OpenROAD

Read RTL:
    read_verilog <rtl_file.v>

Link design (elaborate):
    link_design <top_module_name>

Read timing constraints:
    read_sdc <constraints.sdc>

Note: Synthesis is typically done separately with Yosys, then the netlist is imported into OpenROAD.

## Reading Design Files

### Reading Verilog Netlist

Read gate-level netlist after synthesis:
    read_verilog <netlist.v>

Link the design:
    link_design <top_module_name>

### Reading Constraints

Read SDC (Synopsys Design Constraints):
    read_sdc <constraints.sdc>

Create clock if not in SDC:
    create_clock -name <clock_name> -period <period_ns> [get_ports <clock_port>]

## Design Inspection Commands

### Reporting Design Information

Report design hierarchy:
    report_design

Report all instances:
    report_instance

Report all nets:
    report_net

Report all ports:
    report_port

### Checking Design

Check for design issues:
    check_setup

Report unmapped cells:
    report_checks -unconstrained

Report design statistics:
    report_design_area

## Timing Analysis Commands

### Basic Timing Reports

Report timing summary:
    report_checks

Report worst paths:
    report_checks -path_delay min_max -format full_clock_expanded

Report specific number of paths:
    report_checks -path_delay max -n 10

Report timing for specific path:
    report_checks -from <start_pin> -to <end_pin>

### Setup and Hold Analysis

Setup timing (max delay):
    report_checks -path_delay max

Hold timing (min delay):
    report_checks -path_delay min

Both setup and hold:
    report_checks -path_delay min_max

### Clock Analysis

Report clock networks:
    report_clock_properties

Report clock skew:
    report_clock_skew

Report clock tree:
    report_clock_tree

## Area and Power Reports

### Area Reports

Report design area:
    report_design_area

Report cell area breakdown:
    report_instance -area

### Power Reports

Report power (requires VCD or activity data):
    report_power

Report power by hierarchy:
    report_power -hierarchy

## Writing Output Files

### Save Design Database

Write OpenROAD database:
    write_db <output.odb>

Write DEF (Design Exchange Format):
    write_def <output.def>

### Export Results

Write Verilog netlist:
    write_verilog <output.v>

Write SDC with updated constraints:
    write_sdc <output.sdc>

## Useful Utility Commands

### Variables and Settings

Set variable:
    set var_name value

Get variable:
    puts $var_name

Set time unit:
    set_time_unit -picoseconds

### File Operations

Source another TCL script:
    source <script.tcl>

Print message:
    puts "Message text"

Exit OpenROAD:
    exit

## Complete Synthesis Command Sequence

Here is a typical command sequence for synthesis phase:

Step 1 - Setup:
    source config/tech_config.tcl

Step 2 - Read libraries:
    read_liberty $LIB_TYPICAL
    read_lef $TECH_LEF
    read_lef $SC_LEF

Step 3 - Read synthesized netlist (from Yosys):
    read_verilog results/alu_8bit/01_synthesis/alu_8bit_synth.v

Step 4 - Link design:
    link_design alu_8bit

Step 5 - Read constraints:
    read_sdc designs/alu_8bit/constraints/alu_8bit.sdc

Step 6 - Check design:
    check_setup

Step 7 - Report timing:
    report_checks -path_delay min_max

Step 8 - Report area:
    report_design_area

Step 9 - Save database:
    write_db results/alu_8bit/01_synthesis/alu_8bit.odb

Step 10 - Exit:
    exit

## Common Command Options

### Verbosity Control

Enable verbose output:
    set_verbose 1

Disable verbose output:
    set_verbose 0

### Report Formatting

Report in brief format:
    report_checks -format brief

Report in full format:
    report_checks -format full

Report to file:
    report_checks > timing_report.txt

## Tips and Best Practices

1. Always check the design after reading files using check_setup
2. Review timing reports carefully to identify critical paths
3. Save intermediate databases for debugging
4. Use meaningful names for output files
5. Document any warnings or errors encountered
6. Keep a log file of all commands executed

## Next Steps

After completing synthesis and verifying timing, proceed to Phase 2: Floorplanning.
