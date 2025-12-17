#===============================================================================
# FLP_001 - SOLUTION
#===============================================================================
# This is the corrected floorplan script.
# The fix: Increase die_area and core_area to fit the cells.
#===============================================================================

puts "=============================================="
puts " FLP_001 - Data Path Floorplan (SOLUTION)"
puts "=============================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]
set puzzle_dir [file dirname $script_dir]
set dojo_root [file dirname [file dirname [file dirname $puzzle_dir]]]

puts "Script directory: $script_dir"

# PDK paths
set pdk_dir "$dojo_root/common/pdks/nangate45"
set lib_file "$pdk_dir/lib/NangateOpenCellLibrary_typical.lib"
set tech_lef "$pdk_dir/lef/NangateOpenCellLibrary.tech.lef"
set cell_lef "$pdk_dir/lef/NangateOpenCellLibrary.macro.mod.lef"

# Design files
set design_file "$puzzle_dir/resources/data_path.v"
set sdc_file "$puzzle_dir/resources/constraints.sdc"

# Results directory
set results_dir "$puzzle_dir/results"
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
# Step 5: Floorplan - FIXED!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Creating Floorplan"
puts "=============================================="

# SOLUTION: Use -utilization instead of fixed die_area
# This lets the tool calculate appropriate die size automatically
#
# Calculation for manual approach:
#   Cell area = 122 um^2
#   Target utilization = 65%
#   Required core area = 122 / 0.65 = 188 um^2
#   Core side = sqrt(188) = 13.7 um -> round to 14 um
#   Die side = 14 + 2*2 (margins) = 18 um -> use 20 um for safety

# Method 1: Automatic sizing (recommended)
initialize_floorplan -utilization 0.65 \
                     -aspect_ratio 1.0 \
                     -core_space 2 \
                     -site FreePDK45_38x28_10R_NP_162NW_34O

# Method 2: Manual sizing (alternative)
# set die_area {0 0 20 20}
# set core_area {2 2 18 18}
# initialize_floorplan -die_area $die_area \
#                      -core_area $core_area \
#                      -site FreePDK45_38x28_10R_NP_162NW_34O

# Create routing tracks
make_tracks

# Place IO pins on die boundary
place_pins -hor_layers metal3 -ver_layers metal2

puts ""
puts "Floorplan created successfully!"

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
