# ============================================================================
# Phase 6: Optimization Script
# ============================================================================
# This script performs post-route optimization to improve timing, power,
# and signal integrity of the design.
#
# Learning Objectives:
# - Understand timing optimization techniques
# - Learn about setup and hold repair
# - Practice design analysis and improvement
# - Analyze power consumption
# ============================================================================

puts "=========================================="
puts "   Phase 6: Optimization"
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
# - RESULTS_DIR: Where to save optimization outputs
# - ROUTING_DIR: Directory with routing results
#
# Write your code below this line:
# --------------------------------

# TODO 1: WRITE YOUR CODE HERE
set DESIGN_NAME "alu_8bit"
set PLATFORM "sky130hd"
set PROJECT_DIR [file normalize [file dirname [info script]]/..]
set RESULTS_DIR "${PROJECT_DIR}/results/${DESIGN_NAME}/06_optimization"
set ROUTING_DIR "${PROJECT_DIR}/results/${DESIGN_NAME}/05_routing"

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
# HINT: Use 'file mkdir $RESULTS_DIR'
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
# HINT: Use 'source ${PROJECT_DIR}/config/tech_config.tcl'
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
# TODO 4: Load Design from Routing
# ============================================================================
# Load the routed design database from Phase 5.
#
# TASK: Load all necessary files
# HINT:
# - read_lef $TECH_LEF
# - read_lef $SC_LEF
# - read_liberty $LIB_TYPICAL
# - read_db ${ROUTING_DIR}/${DESIGN_NAME}_routed.odb
# - read_sdc ${PROJECT_DIR}/designs/${DESIGN_NAME}/constraints/${DESIGN_NAME}.sdc
#
# Write your code below this line:
# --------------------------------

puts "Loading design from routing..."

# TODO 4: WRITE YOUR CODE HERE
read_lef $TECH_LEF
read_lef $SC_LEF
read_liberty $LIB_TYPICAL
read_db ${ROUTING_DIR}/${DESIGN_NAME}_routed.odb
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
# TODO 5: Initial Timing Analysis
# ============================================================================
# Analyze timing before optimization to establish baseline.
#
# LEARNING POINT: Before optimizing, we need to know:
# - Current worst slack (setup and hold)
# - Total negative slack (TNS)
# - Number of violating paths
#
# TASK: Report initial timing metrics
# HINT: Use report_worst_slack -max, report_worst_slack -min
#
# Write your code below this line:
# --------------------------------

puts "=========================================="
puts "   Initial Timing Analysis"
puts "=========================================="

# TODO 5: WRITE YOUR CODE HERE
puts "Setup timing (max):"
report_worst_slack -max

puts ""
puts "Hold timing (min):"
report_worst_slack -min

puts ""
puts "Total Negative Slack:"
report_tns

# --------------------------------
# End of TODO 5

puts ""

# ============================================================================
# TODO 6: Repair Setup Timing
# ============================================================================
# Fix setup timing violations if any exist.
#
# LEARNING POINT: Setup repair techniques:
# - Gate upsizing (faster cells)
# - Buffer insertion (reduce load)
# - Logic optimization
#
# TASK: Repair setup timing violations
# HINT: Use 'repair_timing -setup'
#
# Write your code below this line:
# --------------------------------

puts "=========================================="
puts "   Setup Timing Repair"
puts "=========================================="

# TODO 6: WRITE YOUR CODE HERE
puts "Repairing setup timing..."
repair_timing -setup

puts ""
puts "Setup timing after repair:"
report_worst_slack -max

# --------------------------------
# End of TODO 6

puts ""

# ============================================================================
# TODO 7: Repair Hold Timing
# ============================================================================
# Fix hold timing violations if any exist.
#
# LEARNING POINT: Hold repair techniques:
# - Delay cell insertion
# - Buffer insertion on short paths
# - Useful skew adjustment
#
# TASK: Repair hold timing violations
# HINT: Use 'repair_timing -hold'
#
# Write your code below this line:
# --------------------------------

puts "=========================================="
puts "   Hold Timing Repair"
puts "=========================================="

# TODO 7: WRITE YOUR CODE HERE
puts "Repairing hold timing..."
repair_timing -hold

puts ""
puts "Hold timing after repair:"
report_worst_slack -min

# --------------------------------
# End of TODO 7

puts ""

# ============================================================================
# TODO 8: Repair Design Violations
# ============================================================================
# Fix other design violations (slew, capacitance, fanout).
#
# LEARNING POINT: Design repair fixes:
# - Max slew violations (transitions too slow)
# - Max capacitance violations (load too high)
# - Max fanout violations (too many connections)
#
# TASK: Repair design violations
# HINT: Use 'repair_design'
#
# Write your code below this line:
# --------------------------------

puts "=========================================="
puts "   Design Violation Repair"
puts "=========================================="

# TODO 8: WRITE YOUR CODE HERE
puts "Repairing design violations..."
repair_design

# --------------------------------
# End of TODO 8

puts ""

# ============================================================================
# TODO 9: Update Parasitics
# ============================================================================
# Re-estimate parasitics after optimization changes.
#
# TASK: Estimate parasitics
# HINT: Use 'estimate_parasitics -placement'
#
# Write your code below this line:
# --------------------------------

puts "Updating parasitics..."

# TODO 9: WRITE YOUR CODE HERE
estimate_parasitics -placement

# --------------------------------
# End of TODO 9

puts "Parasitics updated"
puts ""

# ============================================================================
# TODO 10: Final Timing Analysis
# ============================================================================
# Verify timing after all optimizations.
#
# TASK: Report final timing metrics and save to file
# HINT: Use report_checks and report_worst_slack
#
# Write your code below this line:
# --------------------------------

puts "=========================================="
puts "   Final Timing Analysis"
puts "=========================================="

# TODO 10: WRITE YOUR CODE HERE
puts "Final Setup timing:"
report_worst_slack -max

puts ""
puts "Final Hold timing:"
report_worst_slack -min

puts ""
puts "Final TNS:"
report_tns

# Save detailed timing report
report_checks -path_delay min_max > ${RESULTS_DIR}/timing_report.txt

# --------------------------------
# End of TODO 10

puts ""

# ============================================================================
# TODO 11: Power Analysis
# ============================================================================
# Analyze power consumption of the optimized design.
#
# LEARNING POINT: Power components:
# - Internal power (cell switching)
# - Switching power (net charging)
# - Leakage power (static)
#
# TASK: Report power consumption
# HINT: Use 'report_power'
#
# Write your code below this line:
# --------------------------------

puts "=========================================="
puts "   Power Analysis"
puts "=========================================="

# TODO 11: WRITE YOUR CODE HERE
report_power

# Save power report
report_power > ${RESULTS_DIR}/power_report.txt

# --------------------------------
# End of TODO 11

puts ""

# ============================================================================
# TODO 12: Generate Reports
# ============================================================================
# Create summary reports for the optimized design.
#
# TASK: Generate area and timing summary reports
#
# Write your code below this line:
# --------------------------------

puts "Generating reports..."

# TODO 12: WRITE YOUR CODE HERE
report_design_area > ${RESULTS_DIR}/design_area.rpt

# Save timing summary
set timing_summary [open ${RESULTS_DIR}/timing_summary.txt w]
puts $timing_summary "Optimization Timing Summary"
puts $timing_summary "==========================="
puts $timing_summary ""
close $timing_summary

# Append worst slack to summary
report_worst_slack -max >> ${RESULTS_DIR}/timing_summary.txt
report_worst_slack -min >> ${RESULTS_DIR}/timing_summary.txt

# --------------------------------
# End of TODO 12

puts "Reports generated"
puts ""

# ============================================================================
# TODO 13: Save Optimized Design
# ============================================================================
# Save the optimized design database and files.
#
# TASK: Save:
# 1. OpenROAD database: ${RESULTS_DIR}/${DESIGN_NAME}_optimized.odb
# 2. DEF file: ${RESULTS_DIR}/${DESIGN_NAME}_optimized.def
# 3. Verilog netlist: ${RESULTS_DIR}/${DESIGN_NAME}_optimized.v
#
# Write your code below this line:
# --------------------------------

puts "Saving optimized design..."

# TODO 13: WRITE YOUR CODE HERE
write_db ${RESULTS_DIR}/${DESIGN_NAME}_optimized.odb
write_def ${RESULTS_DIR}/${DESIGN_NAME}_optimized.def
write_verilog ${RESULTS_DIR}/${DESIGN_NAME}_optimized.v

# --------------------------------
# End of TODO 13

puts "Design saved"
puts ""

# ============================================================================
# Summary
# ============================================================================

puts "=========================================="
puts "   Optimization Phase Completed!"
puts "=========================================="
puts ""
puts "Output Files:"
puts "  - Database: ${RESULTS_DIR}/${DESIGN_NAME}_optimized.odb"
puts "  - DEF: ${RESULTS_DIR}/${DESIGN_NAME}_optimized.def"
puts "  - Verilog: ${RESULTS_DIR}/${DESIGN_NAME}_optimized.v"
puts "  - Timing Report: ${RESULTS_DIR}/timing_report.txt"
puts "  - Power Report: ${RESULTS_DIR}/power_report.txt"
puts "  - Design Area: ${RESULTS_DIR}/design_area.rpt"
puts ""
puts "Next Phase: Sign-off"
puts ""

exit
