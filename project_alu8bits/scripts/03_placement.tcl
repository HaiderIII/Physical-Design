# ============================================================================
# Phase 3: Placement Script
# ============================================================================
# This script performs global placement, detailed placement, and placement
# optimization to assign physical locations to all standard cells.
#
# Learning Objectives:
# - Understand global vs detailed placement
# - Learn timing-driven placement concepts
# - Practice placement quality analysis
# - Analyze wirelength and congestion metrics
# ============================================================================

puts "=========================================="
puts "   Phase 3: Placement"
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
# - RESULTS_DIR: Where to save placement outputs (${PROJECT_DIR}/results/${DESIGN_NAME}/03_placement)
# - FP_DIR: Directory with floorplan results (${PROJECT_DIR}/results/${DESIGN_NAME}/02_floorplan)
#
# Write your code below this line:
# --------------------------------

# TODO 1: WRITE YOUR CODE HERE
set DESIGN_NAME "alu_8bit"
set PLATFORM "sky130hd"
set PROJECT_DIR [file normalize [file dirname [info script]]/..]
set RESULTS_DIR "${PROJECT_DIR}/results/${DESIGN_NAME}/03_placement"
set FP_DIR "${PROJECT_DIR}/results/${DESIGN_NAME}/02_floorplan"



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
source [file join $PROJECT_DIR config tech_config.tcl]


# --------------------------------
# End of TODO 3

puts "Technology configuration loaded"
puts ""

# ============================================================================
# TODO 4: Load Design from Floorplanning
# ============================================================================
# Load the floorplan database from Phase 2.
#
# LEARNING POINT: We need to load:
# 1. Technology LEF (layers, design rules)
# 2. Standard cell LEF (cell abstracts)
# 3. Liberty file (timing)
# 4. Floorplan database (.odb)
#
# TASK: Load all necessary files
# HINT:
# - read_lef $TECH_LEF
# - read_lef $SC_LEF
# - read_liberty $LIB_TYPICAL
# - read_db ${FP_DIR}/${DESIGN_NAME}_fp.odb
#
# Write your code below this line:
# --------------------------------

puts "Loading design from floorplanning..."

# TODO 4: WRITE YOUR CODE HERE
read_lef $TECH_LEF
read_lef $SC_LEF
read_liberty $LIB_TYPICAL
read_db [file join $FP_DIR "${DESIGN_NAME}_fp.odb"]



# --------------------------------
# End of TODO 4

puts "Design loaded successfully"
puts ""

# ============================================================================
# Configure Wire RC Parameters
# ============================================================================
# Set wire resistance and capacitance for timing-driven placement
# Sky130 typical values for signal wires

puts "Configuring wire RC parameters..."

# Set wire RC for signal nets (based on met2)
# Resistance in ohms/micron, Capacitance in fF/micron
set_wire_rc -signal -layer met2
set_wire_rc -clock -layer met3

puts "Wire RC configured"
puts ""

# ============================================================================
# TODO 5: Run Global Placement
# ============================================================================
# Perform global placement to find approximate cell positions.
#
# LEARNING POINT: Global placement parameters:
# - density: Target cell density (0.6 = 60%, leaves routing space)
# - timing_driven: Optimize for timing (requires SDC loaded)
# - May produce overlaps (fixed in detailed placement)
#
# TASK: Run global placement with:
# - density: 0.6 (60% target density)
# - timing_driven: enabled
#
# HINT: Use 'global_placement -density 0.6 -timing_driven'
#
# Write your code below this line:
# --------------------------------

puts "Running global placement..."

# TODO 5: WRITE YOUR CODE HERE
global_placement -density 0.6 -timing_driven


# --------------------------------
# End of TODO 5

puts "Global placement completed"
puts ""

# ============================================================================
# TODO 6: Run Detailed Placement
# ============================================================================
# Legalize the placement by removing overlaps and snapping to sites.
#
# LEARNING POINT: Detailed placement:
# - Removes all cell overlaps
# - Snaps cells to legal placement sites
# - Maintains row alignment
# - Minimal perturbation from global placement
#
# TASK: Run detailed placement
# HINT: Use 'detailed_placement'
#
# Write your code below this line:
# --------------------------------

puts "Running detailed placement..."

# TODO 6: WRITE YOUR CODE HERE
detailed_placement  


# --------------------------------
# End of TODO 6

puts "Detailed placement completed"
puts ""

# ============================================================================
# TODO 7: Check Placement Legality
# ============================================================================
# Verify that all cells are legally placed.
#
# LEARNING POINT: Checks for:
# - No overlapping cells
# - Cells on valid sites
# - Proper row alignment
# - Design rule compliance
#
# TASK: Check placement legality
# HINT: Use 'check_placement -verbose'
#
# Write your code below this line:
# --------------------------------

puts "Checking placement legality..."

# TODO 7: WRITE YOUR CODE HERE
check_placement -verbose


# --------------------------------
# End of TODO 7

puts "Placement is legal"
puts ""

# ============================================================================
# TODO 8: Optimize Placement
# ============================================================================
# Refine placement to improve quality metrics.
#
# LEARNING POINT: Optimization improves:
# - Wirelength
# - Timing
# - Congestion
# - Through local cell movements
#
# TASK: Run placement optimization
# HINT: Use 'improve_placement'
#
# Write your code below this line:
# --------------------------------

puts "Optimizing placement..."

# TODO 8: WRITE YOUR CODE HERE
improve_placement


# --------------------------------
# End of TODO 8

puts "Placement optimization completed"
puts ""

# ============================================================================
# TODO 9: Estimate Parasitics
# ============================================================================
# Estimate wire resistance and capacitance for timing analysis.
#
# LEARNING POINT: Parasitics estimation:
# - Calculates wire RC based on placement
# - Needed for accurate timing analysis
# - Uses half-perimeter wirelength model
#
# TASK: Estimate parasitics based on placement
# HINT: Use 'estimate_parasitics -placement'
#
# Write your code below this line:
# --------------------------------

puts "Estimating parasitics..."

# TODO 9: WRITE YOUR CODE HERE
estimate_parasitics -placement


# --------------------------------
# End of TODO 9

puts "Parasitics estimated"
puts ""

# ============================================================================
# TODO 10: Run Timing Analysis
# ============================================================================
# Perform static timing analysis on placed design.
#
# TASK: Run timing analysis and save report
# HINT: Use 'report_checks -path_delay min_max' and redirect to file
#
# Write your code below this line:
# --------------------------------

puts "Running timing analysis..."

# TODO 10: WRITE YOUR CODE HERE
set TIMING_REPORT_FILE [file join $RESULTS_DIR "timing_report.txt"]
report_checks -path_delay min_max > $TIMING_REPORT_FILE


# --------------------------------
# End of TODO 10

puts "Timing analysis completed"
puts ""

# ============================================================================
# TODO 11: Generate Reports
# ============================================================================
# Create various reports to analyze placement quality.
#
# TASK: Generate the following reports:
# 1. Design area report: ${RESULTS_DIR}/design_area.rpt
# 2. Wire length report: ${RESULTS_DIR}/wire_length.rpt
# 3. Timing summary: ${RESULTS_DIR}/timing_summary.rpt
#
# HINT:
# - report_design_area > <file>
# - report_wire_length > <file>
# - report_checks -format summary > <file>
#
# Write your code below this line:
# --------------------------------

puts "Generating reports..."

# TODO 11: WRITE YOUR CODE HERE
set DESIGN_AREA_FILE [file join $RESULTS_DIR "design_area.rpt"]
report_design_area > $DESIGN_AREA_FILE

# Skip wire_length report (needs global routing tracks)
puts "Wire length report skipped (requires routing configuration)"

set TIMING_SUMMARY_FILE [file join $RESULTS_DIR "timing_summary.rpt"]
report_checks -format summary > $TIMING_SUMMARY_FILE



# --------------------------------
# End of TODO 11

puts "Reports generated"
puts ""

# ============================================================================
# TODO 12: Save Design Database
# ============================================================================
# Save the placement results.
#
# TASK: Save:
# 1. OpenROAD database: ${RESULTS_DIR}/${DESIGN_NAME}_placed.odb
# 2. DEF file: ${RESULTS_DIR}/${DESIGN_NAME}_placed.def
#
# HINT: Use 'write_db' and 'write_def'
#
# Write your code below this line:
# --------------------------------

# TODO 12: WRITE YOUR CODE HERE
set PLACED_DB_FILE [file join $RESULTS_DIR "${DESIGN_NAME}_placed.odb"]
write_db $PLACED_DB_FILE
set PLACED_DEF_FILE [file join $RESULTS_DIR "${DESIGN_NAME}_placed.def"]
write_def $PLACED_DEF_FILE  


# --------------------------------
# End of TODO 12

puts "Design database saved"
puts ""

# ============================================================================
# Summary
# ============================================================================

puts "=========================================="
puts "   Placement Phase Completed!"
puts "=========================================="
puts ""
puts "Output Files:"
puts "  - Database: ${RESULTS_DIR}/${DESIGN_NAME}_placed.odb"
puts "  - DEF: ${RESULTS_DIR}/${DESIGN_NAME}_placed.def"
puts "  - Timing Report: ${RESULTS_DIR}/timing_report.txt"
puts "  - Design Area: ${RESULTS_DIR}/design_area.rpt"
puts "  - Wire Length: ${RESULTS_DIR}/wire_length.rpt"
puts "  - Timing Summary: ${RESULTS_DIR}/timing_summary.rpt"
puts ""
puts "Next Phase: Clock Tree Synthesis"
puts ""
puts "To visualize the placement, use:"
puts "  openroad -gui ${RESULTS_DIR}/${DESIGN_NAME}_placed.odb"
puts ""

# ============================================================================
# LEARNING EXERCISES
# ============================================================================
# After running this script, try the following:
#
# 1. Visualize the placement in GUI:
#    - Open in OpenROAD GUI
#    - See cells positioned in rows
#    - Zoom in to see individual cells
#    - Check for uniform distribution
#
# 2. Analyze timing results:
#    - Review timing report
#    - Identify critical paths
#    - Check setup and hold slack
#    - Compare with post-synthesis timing
#
# 3. Experiment with density:
#    - Try density 0.4 (more space)
#    - Try density 0.8 (tighter)
#    - Observe impact on wirelength and timing
#    - Find optimal balance
#
# 4. Study wirelength:
#    - Check total wirelength
#    - Compare different placements
#    - Understand wirelength vs timing trade-off
#
# 5. Check cell distribution:
#    - Look for clustering
#    - Identify empty regions
#    - Verify uniform spread
#    - Check routing space availability
# ============================================================================

exit
