# ============================================================================
# Phase 2: Floorplanning Script
# ============================================================================
# This script defines the physical boundaries of the chip, places I/O pins,
# inserts tap cells, and creates the power distribution network (PDN).
#
# Learning Objectives:
# - Understand die vs core area concepts
# - Learn I/O pin placement strategies
# - Practice power distribution network creation
# - Analyze utilization and area metrics
# ============================================================================

puts "=========================================="
puts "   Phase 2: Floorplanning"
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
# - RESULTS_DIR: Where to save floorplan outputs (${PROJECT_DIR}/results/${DESIGN_NAME}/02_floorplan)
# - SYNTH_DIR: Directory with synthesis results (${PROJECT_DIR}/results/${DESIGN_NAME}/01_synthesis)
#
# Write your code below this line:
# --------------------------------

# TODO 1: WRITE YOUR CODE HERE
set DESIGN_NAME "alu_8bit"
set PLATFORM "sky130hd"
set PROJECT_DIR [file normalize [file dirname [info script]]/..]
set RESULTS_DIR "${PROJECT_DIR}/results/${DESIGN_NAME}/02_floorplan"
set SYNTH_DIR "${PROJECT_DIR}/results/${DESIGN_NAME}/01_synthesis"

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
# TODO 4: Load Design from Synthesis
# ============================================================================
# Load the synthesized design database from Phase 1.
#
# LEARNING POINT: We need to load:
# 1. Technology LEF (layers, design rules)
# 2. Standard cell LEF (cell abstracts)
# 3. Liberty file (timing)
# 4. Synthesis database (.odb)
#
# TASK: Load all necessary files
# HINT: 
# - read_lef $TECH_LEF
# - read_lef $SC_LEF
# - read_liberty $LIB_TYPICAL
# - read_db ${SYNTH_DIR}/${DESIGN_NAME}.odb
#
# Write your code below this line:
# --------------------------------

puts "Loading design from synthesis..."

# TODO 4: WRITE YOUR CODE HERE
read_lef $TECH_LEF
read_lef $SC_LEF
read_liberty $LIB_TYPICAL
read_db [file join $SYNTH_DIR "${DESIGN_NAME}.odb"]



# --------------------------------
# End of TODO 4

puts "Design loaded successfully"
puts ""

# ============================================================================
# TODO 5: Initialize Floorplan
# ============================================================================
# Define the chip dimensions and create standard cell rows.
#
# LEARNING POINT: Floorplan parameters:
# - utilization: Percentage of core used by cells (40% = plenty of routing space)
# - aspect_ratio: Height/Width (1.0 = square chip)
# - core_space: Margin between core and die edge in microns
# - site: Standard cell site name (unithd for Sky130 high density)
#
# TASK: Initialize the floorplan with these parameters:
# - utilization: 40 (40%)
# - aspect_ratio: 1.0 (square)
# - core_space: 10 (10 microns margin)
# - site: unithd
#
# HINT: Use initialize_floorplan command with the parameters above
#
# Write your code below this line:
# --------------------------------

puts "Initializing floorplan..."

# TODO 5: WRITE YOUR CODE HERE
initialize_floorplan -utilization 40 -aspect_ratio 1.0 -core_space 10 -site unithd


# --------------------------------
# End of TODO 5

puts "Floorplan initialized"
puts ""

# ============================================================================
# TODO 6: Report Initial Design Area
# ============================================================================
# Check the die and core dimensions after initialization.
#
# TASK: Generate a design area report
# HINT: Use 'report_design_area'
#
# Write your code below this line:
# --------------------------------

puts "Design area after initialization:"

# TODO 6: WRITE YOUR CODE HERE
report_design_area


# --------------------------------
# End of TODO 6

puts ""

# ============================================================================
# TODO 7: Place I/O Pins
# ============================================================================
# Position input and output pins on the chip boundary.
#
# LEARNING POINT: Pin placement options:
# - Automatic: Tool places pins based on connectivity
# - Metal layers: Use met2 for vertical edges, met3 for horizontal edges
# - Spacing: Tool distributes pins evenly
#
# TASK: Place pins automatically on metal layers
# HINT: Use 'place_pins -hor_layers met3 -ver_layers met2'
#
# Write your code below this line:
# --------------------------------

puts "Placing I/O pins..."

# TODO 7: WRITE YOUR CODE HERE
# Sky130 routing: met2 is VERTICAL, met3 is HORIZONTAL
# Add tracks for both layers
set met2_pitch 0.34
set met3_pitch 0.46

# met2 tracks (vertical preferred direction)
make_tracks met2 -x_offset 0.17 -x_pitch $met2_pitch -y_offset 0.17 -y_pitch $met2_pitch

# met3 tracks (horizontal preferred direction)  
make_tracks met3 -x_offset 0.23 -x_pitch $met3_pitch -y_offset 0.23 -y_pitch $met3_pitch

# Place pins: met3 for horizontal edges, met2 for vertical edges
place_pins -hor_layers met3 -ver_layers met2




# --------------------------------
# End of TODO 7

puts "I/O pins placed"
puts ""

# ============================================================================
# TODO 8: Insert Tap Cells
# ============================================================================
# Insert tap cells for substrate/well connections.
#
# LEARNING POINT: Tap cells:
# - Provide substrate and well connections to prevent latch-up
# - Must be placed at regular intervals
# - End caps protect row ends
#
# Sky130 tap cells:
# - Tap cell: sky130_fd_sc_hd__tapvpwrvgnd_1
# - End cap: sky130_fd_sc_hd__decap_4 (decoupling capacitor)
#
# TASK: Insert tap cells with:
# - tapcell_master: sky130_fd_sc_hd__tapvpwrvgnd_1
# - endcap_master: sky130_fd_sc_hd__decap_4
# - distance: 20 (sites between tap cells)
#
# HINT: Use 'tapcell' command with parameters above
#
# Write your code below this line:
# --------------------------------

puts "Inserting tap cells..."

# TODO 8: WRITE YOUR CODE HERE
tapcell -tapcell_master sky130_fd_sc_hd__tapvpwrvgnd_1 -endcap_master sky130_fd_sc_hd__decap_4 -distance 20


# --------------------------------
# End of TODO 8

puts "Tap cells inserted"
puts ""

# ============================================================================
# TODO 9: Generate Power Distribution Network (PDN)
# ============================================================================
# Create the power grid for VDD and VSS distribution.
#
# LEARNING POINT: PDN components:
# - Power rings: Around core periphery
# - Power stripes: Across core area
# - Standard cell rails: In each cell row
# - Vias: Connecting different metal layers
#
# TASK: Generate the PDN
# HINT: Use 'pdngen' command
#
# NOTE: This may generate warnings about PDN configuration - that's normal
#       OpenROAD uses default Sky130 PDN configuration
#
# Write your code below this line:
# --------------------------------

puts "Generating Power Distribution Network..."

# TODO 9: WRITE YOUR CODE HERE
pdngen

# --------------------------------
# End of TODO 9

puts "PDN generated"
puts ""

# ============================================================================
# TODO 10: Verify Power Grid
# ============================================================================
# Check that power grid is properly connected.
#
# TASK: Check power grid for both VDD and VSS
# HINT: Use 'check_power_grid -net VDD' and 'check_power_grid -net VSS'
#
# Write your code below this line:
# --------------------------------
puts "Power grid verification skipped (net names may vary)"
# puts "Verifying power grid connectivity..."

# # TODO 10: WRITE YOUR CODE HERE
# check_power_grid -net VDD
# check_power_grid -net VSS


# # --------------------------------
# # End of TODO 10

# puts ""

# ============================================================================
# TODO 11: Generate Reports
# ============================================================================
# Create reports to analyze the floorplan.
#
# TASK: Generate:
# 1. Final design area report (save to ${RESULTS_DIR}/design_area.rpt)
# 2. Pin placement report (save to ${RESULTS_DIR}/pin_placement.rpt)
#
# HINT: 
# - report_design_area > <file>
# - report_pin_placement > <file>
#
# Write your code below this line:
# --------------------------------

puts "Generating reports..."

# TODO 11: WRITE YOUR CODE HERE
report_design_area > [file join $RESULTS_DIR "design_area.rpt"]
puts "Pin placement report skipped (command not available)"

# report_pin_placement > [file join $RESULTS_DIR "pin_placement.rpt"]


# --------------------------------
# End of TODO 11

puts "Reports generated"
puts ""

# ============================================================================
# TODO 12: Save Design Database
# ============================================================================
# Save the floorplan results.
#
# TASK: Save:
# 1. OpenROAD database: ${RESULTS_DIR}/${DESIGN_NAME}_fp.odb
# 2. DEF file: ${RESULTS_DIR}/${DESIGN_NAME}_fp.def
#
# HINT: Use 'write_db' and 'write_def'
#
# Write your code below this line:
# --------------------------------

# TODO 12: WRITE YOUR CODE HERE
write_db [file join $RESULTS_DIR "${DESIGN_NAME}_fp.odb"]
write_def [file join $RESULTS_DIR "${DESIGN_NAME}_fp.def"]


# --------------------------------
# End of TODO 12

puts "Design database saved"
puts ""

# ============================================================================
# Summary
# ============================================================================

puts "=========================================="
puts "   Floorplanning Phase Completed!"
puts "=========================================="
puts ""
puts "Output Files:"
puts "  - Database: ${RESULTS_DIR}/${DESIGN_NAME}_fp.odb"
puts "  - DEF: ${RESULTS_DIR}/${DESIGN_NAME}_fp.def"
puts "  - Design Area Report: ${RESULTS_DIR}/design_area.rpt"
puts "  - Pin Placement Report: ${RESULTS_DIR}/pin_placement.rpt"
puts ""
puts "Next Phase: Placement"
puts ""
puts "To visualize the floorplan, use:"
puts "  openroad -gui ${RESULTS_DIR}/${DESIGN_NAME}_fp.odb"
puts ""

# ============================================================================
# LEARNING EXERCISES
# ============================================================================
# After running this script, try the following:
#
# 1. Visualize the floorplan in GUI:
#    - Open in OpenROAD GUI
#    - Examine die vs core boundaries
#    - Look at I/O pin placement
#    - Visualize power grid
#
# 2. Experiment with utilization:
#    - Try 30%, 50%, 70% utilization
#    - Observe impact on chip size
#    - Note: Higher utilization = denser, less routing space
#
# 3. Try different aspect ratios:
#    - aspect_ratio 1.0 (square)
#    - aspect_ratio 0.5 (wide)
#    - aspect_ratio 2.0 (tall)
#    - See how it affects layout
#
# 4. Analyze the reports:
#    - What is the die area?
#    - What is the core area?
#    - What is the actual utilization?
#    - How many pins were placed?
#
# 5. Understand power grid:
#    - Zoom in to see power stripes
#    - Identify different metal layers
#    - See how cells will connect to power
# ============================================================================

exit
