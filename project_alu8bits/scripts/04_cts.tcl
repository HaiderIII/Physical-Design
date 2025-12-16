# ============================================================================
# Phase 4: Clock Tree Synthesis Script
# ============================================================================
# This script builds the clock distribution network by inserting clock buffers
# and balancing delays to minimize skew between all flip-flops.
#
# Learning Objectives:
# - Understand clock tree synthesis concepts
# - Learn about clock skew and latency
# - Practice clock tree analysis
# - Analyze timing with real clock delays
# ============================================================================

puts "=========================================="
puts "   Phase 4: Clock Tree Synthesis"
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
# - RESULTS_DIR: Where to save CTS outputs (${PROJECT_DIR}/results/${DESIGN_NAME}/04_cts)
# - PLACE_DIR: Directory with placement results (${PROJECT_DIR}/results/${DESIGN_NAME}/03_placement)
#
# Write your code below this line:
# --------------------------------

# TODO 1: WRITE YOUR CODE HERE
set DESIGN_NAME "alu_8bit"
set PLATFORM "sky130hd"
set PROJECT_DIR [file normalize [file dirname [info script]]/..]
set RESULTS_DIR "${PROJECT_DIR}/results/${DESIGN_NAME}/04_cts"
set PLACE_DIR "${PROJECT_DIR}/results/${DESIGN_NAME}/03_placement"

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
# TODO 4: Load Design from Placement
# ============================================================================
# Load the placed design database from Phase 3.
#
# LEARNING POINT: We need to load:
# 1. Technology LEF (layers, design rules)
# 2. Standard cell LEF (cell abstracts)
# 3. Liberty file (timing)
# 4. Placement database (.odb)
#
# TASK: Load all necessary files
# HINT:
# - read_lef $TECH_LEF
# - read_lef $SC_LEF
# - read_liberty $LIB_TYPICAL
# - read_db ${PLACE_DIR}/${DESIGN_NAME}_placed.odb
#
# Write your code below this line:
# --------------------------------

puts "Loading design from placement..."

# TODO 4: WRITE YOUR CODE HERE
read_lef $TECH_LEF
read_lef $SC_LEF
read_liberty $LIB_TYPICAL
read_db ${PLACE_DIR}/${DESIGN_NAME}_placed.odb


# --------------------------------
# End of TODO 4

puts "Design loaded successfully"
puts ""

# ============================================================================
# Load Timing Constraints (SDC)
# ============================================================================
# Load SDC file to define clocks for CTS

puts "Loading timing constraints..."
read_sdc ${PROJECT_DIR}/designs/${DESIGN_NAME}/constraints/${DESIGN_NAME}.sdc
puts "SDC loaded"
puts ""

# ============================================================================
# Configure Wire RC (Already done in placement, but reconfirm)
# ============================================================================

puts "Configuring wire RC parameters..."

# Set wire RC for signal and clock nets
set_wire_rc -signal -layer met2
set_wire_rc -clock -layer met3

puts "Wire RC configured"
puts ""

# ============================================================================
# TODO 5: Run Clock Tree Synthesis
# ============================================================================
# Build the clock distribution network.
#
# LEARNING POINT: CTS parameters:
# - buf_list: Clock buffers to use (different drive strengths)
# - root_buf: Larger buffer for clock root
# - Balances delays to minimize skew
#
# TASK: Run CTS with Sky130 clock buffers
# HINT: Use clock_tree_synthesis with buf_list parameter
#
# Sky130 clock buffers (in order of drive strength):
# - sky130_fd_sc_hd__clkbuf_1
# - sky130_fd_sc_hd__clkbuf_2
# - sky130_fd_sc_hd__clkbuf_4
# - sky130_fd_sc_hd__clkbuf_8
# - sky130_fd_sc_hd__clkbuf_16
#
# Write your code below this line:
# --------------------------------

puts "Running Clock Tree Synthesis..."

# TODO 5: WRITE YOUR CODE HERE
clock_tree_synthesis -buf_list {sky130_fd_sc_hd__clkbuf_1 sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8 sky130_fd_sc_hd__clkbuf_16} -root_buf sky130_fd_sc_hd__clkbuf_16



# --------------------------------
# End of TODO 5

puts "Clock Tree Synthesis completed"
puts ""

# ============================================================================
# TODO 6: Set Propagated Clock
# ============================================================================
# Tell the tool to use real clock delays (not ideal clock).
#
# LEARNING POINT: 
# - Before CTS: Clock assumed ideal (zero delay)
# - After CTS: Clock has real delays through buffers
# - Must tell tool to use propagated (real) delays
#
# TASK: Set propagated clock for all clocks
# HINT: Use 'set_propagated_clock [all_clocks]'
#
# Write your code below this line:
# --------------------------------

puts "Setting propagated clock..."

# TODO 6: WRITE YOUR CODE HERE
set_propagated_clock [all_clocks]



# --------------------------------
# End of TODO 6

puts "Propagated clock set"
puts ""

# ============================================================================
# TODO 7: Report Clock Skew
# ============================================================================
# Analyze clock skew after CTS.
#
# LEARNING POINT: Clock skew:
# - Difference in clock arrival times between flip-flops
# - Target: < 5-10% of clock period (< 1-2 ns for 20ns period)
# - Lower skew = easier timing closure
#
# TASK: Report clock skew
# HINT: Use 'report_clock_skew'
#
# Write your code below this line:
# --------------------------------

puts "Reporting clock skew..."

# TODO 7: WRITE YOUR CODE HERE
report_clock_skew


# --------------------------------
# End of TODO 7

puts ""

# ============================================================================
# TODO 8: Update Parasitics
# ============================================================================
# Re-estimate parasitics including clock tree.
#
# TASK: Estimate parasitics after CTS
# HINT: Use 'estimate_parasitics -placement'
#
# Write your code below this line:
# --------------------------------

puts "Updating parasitics estimation..."

# TODO 8: WRITE YOUR CODE HERE
estimate_parasitics -placement


# --------------------------------
# End of TODO 8

puts "Parasitics updated"
puts ""

# ============================================================================
# TODO 9: Run Post-CTS Timing Analysis
# ============================================================================
# Perform timing analysis with real clock delays.
#
# LEARNING POINT: Post-CTS timing:
# - More accurate than pre-CTS
# - Includes clock tree delays
# - May reveal new violations
# - Critical for timing closure
#
# TASK: Run timing analysis and save report
# HINT: Use 'report_checks -path_delay min_max' and redirect to file
#
# Write your code below this line:
# --------------------------------

puts "Running post-CTS timing analysis..."

# TODO 9: WRITE YOUR CODE HERE
report_checks -path_delay min_max > ${RESULTS_DIR}/timing_report.txt


# --------------------------------
# End of TODO 9

puts "Timing analysis completed"
puts ""

# ============================================================================
# TODO 10: Check Setup and Hold Timing
# ============================================================================
# Separately check setup (max) and hold (min) timing.
#
# TASK: Report worst slack for setup and hold
# HINT: Use 'report_worst_slack -max' and 'report_worst_slack -min'
#
# Write your code below this line:
# --------------------------------

puts "Checking setup and hold timing..."

# TODO 10: WRITE YOUR CODE HERE
report_worst_slack -max
report_worst_slack -min


# --------------------------------
# End of TODO 10

puts ""

# ============================================================================
# TODO 11: Repair Hold Violations (if any)
# ============================================================================
# Fix hold timing violations by inserting delay cells.
#
# LEARNING POINT: Hold violations:
# - Occur when clock arrives too early at destination
# - Common after CTS due to clock tree delays
# - Fixed by adding delay on data path
#
# TASK: Repair hold timing violations
# HINT: Use 'repair_timing -hold'
#
# Write your code below this line:
# --------------------------------

puts "Repairing hold violations (if any)..."

# TODO 11: WRITE YOUR CODE HERE
repair_timing -hold


# --------------------------------
# End of TODO 11

puts "Hold timing repair completed"
puts ""

# ============================================================================
# TODO 12: Generate Reports
# ============================================================================
# Create various reports to analyze CTS results.
#
# TASK: Generate the following reports:
# 1. Clock skew report: ${RESULTS_DIR}/clock_skew.rpt
# 2. Final timing report: ${RESULTS_DIR}/timing_report.txt
# 3. Design area report: ${RESULTS_DIR}/design_area.rpt
#
# HINT:
# - report_clock_skew > <file>
# - report_checks -path_delay min_max > <file>
# - report_design_area > <file>
#
# Write your code below this line:
# --------------------------------

puts "Generating reports..."

# TODO 12: WRITE YOUR CODE HERE
report_clock_skew > ${RESULTS_DIR}/clock_skew.rpt
report_checks -path_delay min_max > ${RESULTS_DIR}/timing_report.txt
report_design_area > ${RESULTS_DIR}/design_area.rpt


# --------------------------------
# End of TODO 12

puts "Reports generated"
puts ""

# ============================================================================
# TODO 13: Save Design Database
# ============================================================================
# Save the CTS results.
#
# TASK: Save:
# 1. OpenROAD database: ${RESULTS_DIR}/${DESIGN_NAME}_cts.odb
# 2. DEF file: ${RESULTS_DIR}/${DESIGN_NAME}_cts.def
# 3. Verilog netlist with clock buffers: ${RESULTS_DIR}/${DESIGN_NAME}_cts.v
#
# HINT: Use 'write_db', 'write_def', and 'write_verilog'
#
# Write your code below this line:
# --------------------------------

# TODO 13: WRITE YOUR CODE HERE
write_db ${RESULTS_DIR}/${DESIGN_NAME}_cts.odb
write_def ${RESULTS_DIR}/${DESIGN_NAME}_cts.def
write_verilog ${RESULTS_DIR}/${DESIGN_NAME}_cts.v


# --------------------------------
# End of TODO 13

puts "Design database saved"
puts ""

# ============================================================================
# Summary
# ============================================================================

puts "=========================================="
puts "   Clock Tree Synthesis Completed!"
puts "=========================================="
puts ""
puts "Output Files:"
puts "  - Database: ${RESULTS_DIR}/${DESIGN_NAME}_cts.odb"
puts "  - DEF: ${RESULTS_DIR}/${DESIGN_NAME}_cts.def"
puts "  - Verilog: ${RESULTS_DIR}/${DESIGN_NAME}_cts.v"
puts "  - Clock Skew Report: ${RESULTS_DIR}/clock_skew.rpt"
puts "  - Timing Report: ${RESULTS_DIR}/timing_report.txt"
puts "  - Design Area: ${RESULTS_DIR}/design_area.rpt"
puts ""
puts "Next Phase: Routing"
puts ""
puts "To visualize the clock tree, use:"
puts "  openroad -gui"
puts "  # Then: read_db ${RESULTS_DIR}/${DESIGN_NAME}_cts.odb"
puts ""

# ============================================================================
# LEARNING EXERCISES
# ============================================================================
# After running this script, try the following:
#
# 1. Visualize clock tree in GUI:
#    - Open design in OpenROAD GUI
#    - Highlight clock net
#    - See clock buffers inserted
#    - Check buffer placement
#
# 2. Analyze clock skew:
#    - Review clock_skew.rpt
#    - Check global skew value
#    - Compare to target (< 10% of period)
#    - Understand skew distribution
#
# 3. Compare timing pre-CTS vs post-CTS:
#    - Check slack values before CTS
#    - Check slack values after CTS
#    - Understand clock delay impact
#    - Note any new violations
#
# 4. Study clock buffers:
#    - Count how many buffers inserted
#    - Check buffer types used
#    - Understand buffer hierarchy
#    - See buffer drive strengths
#
# 5. Analyze hold timing:
#    - Check if hold violations exist
#    - See what repair_timing did
#    - Understand hold fixing strategy
#    - Verify hold timing meets spec
# ============================================================================

exit
