# Phase 7: Sign-off - OpenROAD Commands

## Overview

This document covers the essential OpenROAD commands used during the sign-off phase, along with external tool usage for complete verification.

## Reading Design Database

### Load Optimized Design

Read the database from optimization:
    read_db <path_to_optimized.odb>

Example:
    read_db results/alu_8bit/06_optimization/alu_8bit_optimized.odb

## Design Rule Checking

### Basic DRC in OpenROAD

OpenROAD has limited DRC capabilities. For full DRC, use Magic.

Check for violations:
    check_placement -verbose

Check routing:
    check_routing

### Antenna Check

Check antenna rule violations:
    check_antennas

Reports any antenna violations that could damage gates.

### Repair Antennas

If violations found:
    repair_antennas <diode_cell>

Example:
    repair_antennas sky130_fd_sc_hd__diode_2

## Timing Sign-off

### Final Timing Analysis

Complete timing report:
    report_checks -path_delay min_max

Setup timing:
    report_checks -path_delay max

Hold timing:
    report_checks -path_delay min

### Multi-Path Analysis

Report multiple worst paths:
    report_checks -path_delay max -endpoint_count 20

### Timing Summary

Quick summary:
    report_worst_slack -max
    report_worst_slack -min
    report_tns

### Clock Analysis

Check clock skew:
    report_clock_skew

Check clock timing:
    report_checks -path_delay max -through [get_ports clk]

### Constraint Verification

Check all constraints:
    report_check_types -max_slew -max_capacitance -max_fanout -violators

## Power Sign-off

### Power Analysis

Full power report:
    report_power

Hierarchical power:
    report_power -hierarchy

### Save Power Report

Write to file:
    report_power > power_signoff.txt

## Design Statistics

### Area Report

Final area:
    report_design_area

### Cell Count

Count by type:
    report_cell_usage

### Net Statistics

Report all nets:
    report_nets

## Writing Final Files

### Save Final Database

Write OpenROAD database:
    write_db <output.odb>

Example:
    write_db results/alu_8bit/07_signoff/alu_8bit_final.odb

### Write DEF

Export layout:
    write_def <output.def>

Example:
    write_def results/alu_8bit/07_signoff/alu_8bit_final.def

### Write Verilog

Export final netlist:
    write_verilog <output.v>

### Write SPEF

Export parasitics:
    write_spef <output.spef>

### Write SDC

Export constraints:
    write_sdc <output.sdc>

## External Tools for Full Sign-off

### Magic for DRC

Magic provides comprehensive DRC for Sky130.

Launch Magic:
    magic -T sky130A

Load DEF:
    def read alu_8bit_final.def

Run DRC:
    drc check
    drc why
    drc count

### Magic for Extraction

Extract layout for LVS:
    extract all
    ext2spice lvs
    ext2spice

### Netgen for LVS

Compare layout vs schematic:
    netgen -batch lvs "alu_8bit_extracted.spice alu_8bit" "alu_8bit.v alu_8bit"

### KLayout for DRC

KLayout can also run DRC:
    klayout -b -r sky130.drc -rd input=alu_8bit_final.gds

## Complete Sign-off Sequence

Typical command sequence in OpenROAD:

Step 1 - Load optimized design:
    read_db results/alu_8bit/06_optimization/alu_8bit_optimized.odb

Step 2 - Load constraints:
    read_sdc designs/alu_8bit/constraints/alu_8bit.sdc

Step 3 - Check antenna violations:
    check_antennas

Step 4 - Final timing analysis:
    puts "=== Setup Timing ==="
    report_worst_slack -max
    
    puts "=== Hold Timing ==="
    report_worst_slack -min
    
    puts "=== TNS ==="
    report_tns

Step 5 - Detailed timing:
    report_checks -path_delay min_max -format full_clock_expanded

Step 6 - Check constraints:
    report_check_types -max_slew -max_capacitance -max_fanout -violators

Step 7 - Power analysis:
    report_power

Step 8 - Area report:
    report_design_area

Step 9 - Generate reports:
    report_checks -path_delay min_max > signoff_timing.txt
    report_power > signoff_power.txt
    report_design_area > signoff_area.txt

Step 10 - Write final files:
    write_db results/alu_8bit/07_signoff/alu_8bit_final.odb
    write_def results/alu_8bit/07_signoff/alu_8bit_final.def
    write_verilog results/alu_8bit/07_signoff/alu_8bit_final.v

## Sign-off Checklist Commands

### Timing Checklist

Setup timing clean:
    set setup_slack [sta::worst_slack -max]
    if {$setup_slack >= 0} {
        puts "PASS: Setup timing clean (slack = $setup_slack)"
    } else {
        puts "FAIL: Setup violations exist"
    }

Hold timing clean:
    set hold_slack [sta::worst_slack -min]
    if {$hold_slack >= 0} {
        puts "PASS: Hold timing clean (slack = $hold_slack)"
    } else {
        puts "FAIL: Hold violations exist"
    }

### Design Checklist

Check all:
    puts "=== Sign-off Checklist ==="
    puts ""
    puts "Timing:"
    report_worst_slack -max
    report_worst_slack -min
    puts ""
    puts "Power:"
    report_power
    puts ""
    puts "Area:"
    report_design_area

## Troubleshooting

### Common Issues

Issue: Timing violations at sign-off
Solution: Return to optimization, fix violations

Issue: DRC violations in Magic
Solution: May need manual fixes or re-routing

Issue: LVS mismatch
Solution: Check for missing connections, verify netlist

Issue: Antenna violations
Solution: Run repair_antennas with appropriate diode

## Summary Reports

### Generate All Reports

Create comprehensive sign-off documentation:

    # Timing
    report_checks -path_delay min_max > ${RESULTS_DIR}/timing_signoff.txt
    
    # Power
    report_power > ${RESULTS_DIR}/power_signoff.txt
    
    # Area
    report_design_area > ${RESULTS_DIR}/area_signoff.txt
    
    # Constraints
    report_check_types -max_slew -max_capacitance -max_fanout > ${RESULTS_DIR}/constraints_signoff.txt

## Best Practices

1. Run all checks before declaring sign-off complete
2. Document any waivers or known issues
3. Keep all reports for reference
4. Verify timing at multiple corners if possible
5. Use external tools (Magic, Netgen) for thorough verification
6. Save final database and all output files

## Next Steps After Sign-off

After clean sign-off:
1. Generate GDSII (using Magic or KLayout)
2. Final archive of all files
3. Documentation complete
4. Ready for tape-out (if real fabrication)

Congratulations on completing the Physical Design flow!
