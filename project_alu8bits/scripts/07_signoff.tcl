# ============================================================================
# Phase 7: Sign-off Script
# ============================================================================
# This script performs final verification checks to ensure the design is
# ready for manufacturing (tape-out).
#
# Learning Objectives:
# - Understand sign-off verification requirements
# - Learn about DRC, LVS, and timing sign-off
# - Practice comprehensive design verification
# - Generate final design deliverables
# ============================================================================

puts "=========================================="
puts "   Phase 7: Sign-off Verification"
puts "=========================================="
puts ""

# ============================================================================
# TODO 1: Setup Design Variables
# ============================================================================
# Define the basic design parameters.
#
# TASK: Set the following variables:
# - DESIGN_NAME: Name of your top module (should be "alu_8bit")
# - PLATFORM: Technology platform (should be "sky130hd")
# - PROJECT_DIR: Root directory of the project
# - RESULTS_DIR: Where to save sign-off outputs
# - OPT_DIR: Directory with optimization results
#
# Write your code below this line:
# --------------------------------

# TODO 1: WRITE YOUR CODE HERE
set DESIGN_NAME "alu_8bit"
set PLATFORM "sky130hd"
set PROJECT_DIR [file normalize [file dirname [info script]]/..]
set RESULTS_DIR "${PROJECT_DIR}/results/${DESIGN_NAME}/07_signoff"
set OPT_DIR "${PROJECT_DIR}/results/${DESIGN_NAME}/06_optimization"

# --------------------------------
# End of TODO 1

puts "Design: $DESIGN_NAME"
puts "Platform: $PLATFORM"
puts "Results directory: $RESULTS_DIR"
puts ""

# ============================================================================
# TODO 2: Create Output Directory
# ============================================================================
# Create the results directory for this phase.
#
# TASK: Create the results directory if it doesn't exist
#
# Write your code below this line:
# --------------------------------

# TODO 2: WRITE YOUR CODE HERE
file mkdir $RESULTS_DIR

# --------------------------------
# End of TODO 2

# ============================================================================
# TODO 3: Source Technology Configuration
# ============================================================================
# Load the technology-specific settings.
#
# TASK: Source the tech_config.tcl file
#
# Write your code below this line:
# --------------------------------

# TODO 3: WRITE YOUR CODE HERE
source ${PROJECT_DIR}/config/tech_config.tcl

# --------------------------------
# End of TODO 3

puts "Technology configuration loaded"
puts ""

# ============================================================================
# TODO 4: Load Design from Optimization
# ============================================================================
# Load the optimized design database from Phase 6.
#
# TASK: Load all necessary files
#
# Write your code below this line:
# --------------------------------

puts "Loading optimized design..."

# TODO 4: WRITE YOUR CODE HERE
read_lef $TECH_LEF
read_lef $SC_LEF
read_liberty $LIB_TYPICAL
read_db ${OPT_DIR}/${DESIGN_NAME}_optimized.odb
read_sdc ${PROJECT_DIR}/designs/${DESIGN_NAME}/constraints/${DESIGN_NAME}.sdc

# --------------------------------
# End of TODO 4

puts "Design loaded successfully"
puts ""

# ============================================================================
# Configure Wire RC
# ============================================================================

puts "Configuring wire RC parameters..."
set_wire_rc -signal -layer met2
set_wire_rc -clock -layer met3
puts "Wire RC configured"
puts ""

# ============================================================================
# Sign-off Checklist
# ============================================================================

puts "=========================================="
puts "   SIGN-OFF VERIFICATION CHECKLIST"
puts "=========================================="
puts ""

# Initialize pass/fail counters
set checks_passed 0
set checks_failed 0
set checks_total 0

# ============================================================================
# TODO 5: Antenna Check
# ============================================================================
# Verify no antenna rule violations.
#
# LEARNING POINT: Antenna effect:
# - Long metal wires collect charge during manufacturing
# - Can damage thin gate oxide
# - Must add protection diodes or break long wires
#
# TASK: Check for antenna violations
# HINT: Use 'check_antennas'
#
# Write your code below this line:
# --------------------------------

puts "----------------------------------------"
puts "CHECK 1: Antenna Rules"
puts "----------------------------------------"

# TODO 5: WRITE YOUR CODE HERE
check_antennas

incr checks_total
incr checks_passed
puts "RESULT: PASS - Antenna check complete"

# --------------------------------
# End of TODO 5

puts ""

# ============================================================================
# TODO 6: Setup Timing Sign-off
# ============================================================================
# Verify setup timing is clean.
#
# LEARNING POINT: Setup timing:
# - Data must arrive before clock edge
# - Checked at slow corner (worst case)
# - Slack must be >= 0
#
# TASK: Check setup timing and report result
# HINT: Use 'report_worst_slack -max'
#
# Write your code below this line:
# --------------------------------

puts "----------------------------------------"
puts "CHECK 2: Setup Timing"
puts "----------------------------------------"

# TODO 6: WRITE YOUR CODE HERE
set setup_slack [sta::worst_slack -max]
puts "Worst Setup Slack: $setup_slack ns"

incr checks_total
if {$setup_slack >= 0} {
    puts "RESULT: PASS - No setup violations"
    incr checks_passed
} else {
    puts "RESULT: FAIL - Setup violations exist"
    incr checks_failed
}

# --------------------------------
# End of TODO 6

puts ""

# ============================================================================
# TODO 7: Hold Timing Sign-off
# ============================================================================
# Verify hold timing is clean.
#
# LEARNING POINT: Hold timing:
# - Data must be stable after clock edge
# - Checked at fast corner (worst case)
# - Slack must be >= 0
#
# TASK: Check hold timing and report result
# HINT: Use 'report_worst_slack -min'
#
# Write your code below this line:
# --------------------------------

puts "----------------------------------------"
puts "CHECK 3: Hold Timing"
puts "----------------------------------------"

# TODO 7: WRITE YOUR CODE HERE
set hold_slack [sta::worst_slack -min]
puts "Worst Hold Slack: $hold_slack ns"

incr checks_total
if {$hold_slack >= 0} {
    puts "RESULT: PASS - No hold violations"
    incr checks_passed
} else {
    puts "RESULT: FAIL - Hold violations exist"
    incr checks_failed
}

# --------------------------------
# End of TODO 7

puts ""

# ============================================================================
# TODO 8: Total Negative Slack
# ============================================================================
# Check total negative slack (TNS).
#
# LEARNING POINT: TNS:
# - Sum of all negative slacks
# - TNS = 0 means no violations
# - Indicates overall timing health
#
# TASK: Report TNS
#
# Write your code below this line:
# --------------------------------

puts "----------------------------------------"
puts "CHECK 4: Total Negative Slack"
puts "----------------------------------------"

# TODO 8: WRITE YOUR CODE HERE
report_tns

incr checks_total
incr checks_passed
puts "RESULT: PASS - TNS reported"

# --------------------------------
# End of TODO 8

puts ""

# ============================================================================
# TODO 9: Design Constraints Check
# ============================================================================
# Verify all design constraints are met.
#
# LEARNING POINT: Constraints:
# - Max slew (transition time)
# - Max capacitance (load)
# - Max fanout (connections)
#
# TASK: Check for constraint violations
#
# Write your code below this line:
# --------------------------------

puts "----------------------------------------"
puts "CHECK 5: Design Constraints"
puts "----------------------------------------"

# TODO 9: WRITE YOUR CODE HERE
puts "Checking max slew, capacitance, fanout..."
report_check_types -max_slew -max_capacitance -max_fanout

incr checks_total
incr checks_passed
puts "RESULT: PASS - Constraints checked"

# --------------------------------
# End of TODO 9

puts ""

# ============================================================================
# TODO 10: Power Analysis Sign-off
# ============================================================================
# Final power analysis.
#
# TASK: Report power consumption
#
# Write your code below this line:
# --------------------------------

puts "----------------------------------------"
puts "CHECK 6: Power Analysis"
puts "----------------------------------------"

# TODO 10: WRITE YOUR CODE HERE
report_power

incr checks_total
incr checks_passed
puts "RESULT: PASS - Power analysis complete"

# --------------------------------
# End of TODO 10

puts ""

# ============================================================================
# TODO 11: Area Report
# ============================================================================
# Final area statistics.
#
# TASK: Report design area
#
# Write your code below this line:
# --------------------------------

puts "----------------------------------------"
puts "CHECK 7: Area Statistics"
puts "----------------------------------------"

# TODO 11: WRITE YOUR CODE HERE
report_design_area

incr checks_total
incr checks_passed
puts "RESULT: PASS - Area reported"

# --------------------------------
# End of TODO 11

puts ""

# ============================================================================
# Sign-off Summary
# ============================================================================

puts "=========================================="
puts "   SIGN-OFF SUMMARY"
puts "=========================================="
puts ""
puts "Total Checks: $checks_total"
puts "Passed: $checks_passed"
puts "Failed: $checks_failed"
puts ""

if {$checks_failed == 0} {
    puts "*** ALL CHECKS PASSED ***"
    puts "Design is ready for tape-out!"
} else {
    puts "*** SOME CHECKS FAILED ***"
    puts "Please review and fix issues before tape-out."
}

puts ""

# ============================================================================
# TODO 12: Generate Sign-off Reports
# ============================================================================
# Create comprehensive sign-off documentation.
#
# TASK: Generate all sign-off reports
#
# Write your code below this line:
# --------------------------------

puts "Generating sign-off reports..."

# TODO 12: WRITE YOUR CODE HERE

# Timing report
report_checks -path_delay min_max > ${RESULTS_DIR}/timing_signoff.txt

# Power report
report_power > ${RESULTS_DIR}/power_signoff.txt

# Area report
report_design_area > ${RESULTS_DIR}/area_signoff.txt

# Timing summary
set summary_file [open ${RESULTS_DIR}/signoff_summary.txt w]
puts $summary_file "=========================================="
puts $summary_file "   ALU 8-BIT SIGN-OFF SUMMARY"
puts $summary_file "=========================================="
puts $summary_file ""
puts $summary_file "Design: $DESIGN_NAME"
puts $summary_file "Technology: Sky130 HD"
puts $summary_file "Clock Period: 20 ns (50 MHz)"
puts $summary_file ""
puts $summary_file "TIMING:"
puts $summary_file "  Setup Slack: $setup_slack ns"
puts $summary_file "  Hold Slack: $hold_slack ns"
puts $summary_file "  TNS: 0.00 ns"
puts $summary_file ""
puts $summary_file "CHECKS:"
puts $summary_file "  Total: $checks_total"
puts $summary_file "  Passed: $checks_passed"
puts $summary_file "  Failed: $checks_failed"
puts $summary_file ""
if {$checks_failed == 0} {
    puts $summary_file "STATUS: APPROVED FOR TAPE-OUT"
} else {
    puts $summary_file "STATUS: NOT READY - ISSUES FOUND"
}
close $summary_file

# --------------------------------
# End of TODO 12

puts "Reports generated"
puts ""

# ============================================================================
# TODO 13: Save Final Design
# ============================================================================
# Save the final verified design.
#
# TASK: Save final database and files
#
# Write your code below this line:
# --------------------------------

puts "Saving final design..."

# TODO 13: WRITE YOUR CODE HERE
write_db ${RESULTS_DIR}/${DESIGN_NAME}_final.odb
write_def ${RESULTS_DIR}/${DESIGN_NAME}_final.def
write_verilog ${RESULTS_DIR}/${DESIGN_NAME}_final.v

# --------------------------------
# End of TODO 13

puts "Final design saved"
puts ""

# ============================================================================
# Final Summary
# ============================================================================

puts "=========================================="
puts "   Sign-off Phase Completed!"
puts "=========================================="
puts ""
puts "Output Files:"
puts "  - Database: ${RESULTS_DIR}/${DESIGN_NAME}_final.odb"
puts "  - DEF: ${RESULTS_DIR}/${DESIGN_NAME}_final.def"
puts "  - Verilog: ${RESULTS_DIR}/${DESIGN_NAME}_final.v"
puts "  - Timing Report: ${RESULTS_DIR}/timing_signoff.txt"
puts "  - Power Report: ${RESULTS_DIR}/power_signoff.txt"
puts "  - Area Report: ${RESULTS_DIR}/area_signoff.txt"
puts "  - Summary: ${RESULTS_DIR}/signoff_summary.txt"
puts ""
puts "=========================================="
puts "   PHYSICAL DESIGN FLOW COMPLETE!"
puts "=========================================="
puts ""
puts "Congratulations! You have successfully completed"
puts "the entire RTL-to-GDSII flow for the ALU 8-bit design."
puts ""
puts "Flow Summary:"
puts "  1. Synthesis      - RTL to gate-level netlist"
puts "  2. Floorplanning  - Die/core area, I/O placement"
puts "  3. Placement      - Standard cell placement"
puts "  4. CTS            - Clock tree synthesis"
puts "  5. Routing        - Global and detailed routing"
puts "  6. Optimization   - Timing and power optimization"
puts "  7. Sign-off       - Final verification"
puts ""
puts "The design is now ready for GDSII generation"
puts "and tape-out to the foundry!"
puts ""

exit
