#===============================================================================
# FLP_001 - Floorplan Script for Data Path Design
#===============================================================================
# This script creates a floorplan and runs placement on a data processing block.
#
# PROBLEM: The utilization is set too high, causing placement to fail.
#          Find and fix the TODO to make it work!
#===============================================================================

puts "=============================================="
puts " FLP_001 - Data Path Floorplan"
puts "=============================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]
set dojo_root [file dirname [file dirname [file dirname $script_dir]]]

puts "Script directory: $script_dir"

# PDK paths
set pdk_dir "$dojo_root/common/pdks/nangate45"
set lib_file "$pdk_dir/lib/NangateOpenCellLibrary_typical.lib"
set tech_lef "$pdk_dir/lef/NangateOpenCellLibrary.tech.lef"
set cell_lef "$pdk_dir/lef/NangateOpenCellLibrary.macro.mod.lef"

# Design files
set design_file "$script_dir/resources/data_path.v"
set sdc_file "$script_dir/resources/constraints.sdc"

# Results directory
set results_dir "$script_dir/results"
file mkdir $results_dir

#-------------------------------------------------------------------------------
# Step 2: Load PDK
#-------------------------------------------------------------------------------

puts ""
puts "Loading PDK..."
read_liberty $lib_file
read_lef $tech_lef
read_lef $cell_lef
puts "PDK loaded."

#-------------------------------------------------------------------------------
# Step 3: Load design
#-------------------------------------------------------------------------------

puts ""
puts "Loading design..."
read_verilog $design_file
link_design data_path
puts "Design linked."

#-------------------------------------------------------------------------------
# Step 4: Read constraints
#-------------------------------------------------------------------------------

puts ""
puts "Loading constraints..."
read_sdc $sdc_file

#-------------------------------------------------------------------------------
# Step 5: Floorplan - THIS IS WHERE THE BUG IS!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Creating Floorplan"
puts "=============================================="

# TODO: Fix the die_area below
# Hint: The die area is WAY too small for this design!
#
#       The design has ~35 cells, total cell area ~122 um²
#       With a 10x10 die, core area is only ~36 um² (after margins)
#       That means we're trying to fit 122 um² of cells in 36 um²!
#
#       Think about:
#       - How much area do the cells need?
#       - Add ~30-50% margin for routing and buffers
#       - What die size would give enough core area?
#
#       Formula: Core Area ≈ (die_size - 2*margin)²
#                Needed Area = Cell Area / target_utilization

# Die area specification: {x_min y_min x_max y_max} in microns
set die_area {0 0 18.04 18.04}  ;# <-- TODO: This die is too small! Fix it.

# Initialize floorplan with explicit die area
# Note: core area = die area minus IO ring (2um on each side)
set core_area {2 2 16.04 16.04}
initialize_floorplan -die_area $die_area \
                     -core_area $core_area \
                     -site FreePDK45_38x28_10R_NP_162NW_34O

# Create routing tracks
make_tracks

# Place IO pins on die boundary
place_pins -hor_layers metal3 -ver_layers metal2

puts ""
puts "Floorplan created with specified die area: $die_area"

# Report actual floorplan info
set actual_die_area [ord::get_die_area]
puts "Actual die area: $actual_die_area"

#-------------------------------------------------------------------------------
# Step 6: Placement
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Placement"
puts "=============================================="

# Global placement
puts "Running global placement..."
global_placement -density 0.7

# Detailed placement
puts "Running detailed placement..."
detailed_placement

# Check placement
set placement_check [check_placement -verbose]
puts "Placement check: $placement_check"

#-------------------------------------------------------------------------------
# Step 7: Report results
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Results Summary"
puts "=============================================="

# Cell count
set all_cells [get_cells *]
puts "Total cells: [llength $all_cells]"

# Timing
report_checks -path_delay max -format summary

#-------------------------------------------------------------------------------
# Step 8: Write outputs
#-------------------------------------------------------------------------------

puts ""
puts "Writing output files..."

set output_def "$results_dir/data_path_floorplan.def"
write_def $output_def
puts "  DEF: $output_def"

#-------------------------------------------------------------------------------
# Done!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " FLOORPLAN COMPLETE!"
puts "=============================================="
puts ""

exit 0
