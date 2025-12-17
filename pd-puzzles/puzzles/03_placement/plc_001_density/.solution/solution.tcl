#===============================================================================
# PLC_001 - SOLUTION
#===============================================================================
# This is the corrected placement script.
# The fix: Use a balanced density value (0.60) instead of aggressive (0.95)
#===============================================================================

puts "=============================================="
puts " PLC_001 - Processor Placement (SOLUTION)"
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
set design_file "$puzzle_dir/resources/processor.v"
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
link_design processor
puts "Design linked."

#-------------------------------------------------------------------------------
# Step 4: Read constraints
#-------------------------------------------------------------------------------

puts ""
puts "Loading constraints..."
read_sdc $sdc_file

#-------------------------------------------------------------------------------
# Step 5: Floorplan
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Creating Floorplan"
puts "=============================================="

initialize_floorplan -utilization 0.50 \
                     -aspect_ratio 1.0 \
                     -core_space 2 \
                     -site FreePDK45_38x28_10R_NP_162NW_34O

make_tracks
place_pins -hor_layers metal3 -ver_layers metal2

puts "Floorplan created."

set die_area [ord::get_die_area]
puts "Die area: $die_area"

#-------------------------------------------------------------------------------
# Step 6: Placement - FIXED!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Placement"
puts "=============================================="

# SOLUTION: Use balanced density (0.60) instead of aggressive (0.95)
#
# Why 0.60 is better:
# - Leaves 40% whitespace for routing
# - Cells can be placed at optimal positions
# - Less movement during legalization
# - Better timing (shorter wires)
# - Room for CTS buffers later

set placement_density 0.60

puts "Running global placement with density: $placement_density"
global_placement -density $placement_density

puts "Running detailed placement..."
detailed_placement

puts ""
check_placement -verbose

#-------------------------------------------------------------------------------
# Step 7: Congestion Analysis
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Congestion Analysis"
puts "=============================================="

set_global_routing_layer_adjustment metal1 0.8
set_global_routing_layer_adjustment metal2 0.7
set_global_routing_layer_adjustment metal3 0.7

set_routing_layers -signal metal2-metal6

global_route -allow_congestion -congestion_iterations 30

#-------------------------------------------------------------------------------
# Step 8: Report results
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Results Summary"
puts "=============================================="

set all_cells [get_cells *]
puts "Total cells: [llength $all_cells]"

report_checks -path_delay max -format summary

#-------------------------------------------------------------------------------
# Step 9: Write outputs
#-------------------------------------------------------------------------------

puts ""
puts "Writing output files..."

set output_def "$results_dir/processor_placed.def"
write_def $output_def
puts "  DEF: $output_def"

#-------------------------------------------------------------------------------
# Done!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " PLACEMENT COMPLETE!"
puts "=============================================="
puts ""

exit 0
