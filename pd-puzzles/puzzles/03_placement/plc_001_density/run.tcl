#===============================================================================
# PLC_001 - Placement Script for Processor Design
#===============================================================================
# This script runs placement on a small processor datapath.
#
# PROBLEM: The placement density is set too high, causing congestion.
#          Find and fix the TODO to make placement work cleanly!
#===============================================================================

puts "=============================================="
puts " PLC_001 - Processor Placement"
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
set design_file "$script_dir/resources/processor.v"
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

# Use automatic floorplan sizing with 50% utilization
initialize_floorplan -utilization 0.50 \
                     -aspect_ratio 1.0 \
                     -core_space 2 \
                     -site FreePDK45_38x28_10R_NP_162NW_34O

# Create routing tracks
make_tracks

# Place IO pins
place_pins -hor_layers metal3 -ver_layers metal2

puts "Floorplan created."

# Report floorplan info
set die_area [ord::get_die_area]
puts "Die area: $die_area"

#-------------------------------------------------------------------------------
# Step 6: Placement - THIS IS WHERE THE BUG IS!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Placement"
puts "=============================================="

# TODO: Fix the density value below
# Hint: A density of 0.95 (95%) is WAY too aggressive!
#
#       High density means cells are packed very tightly, leaving
#       almost no room for routing wires between them.
#
#       Think about:
#       - What space is needed for routing?
#       - How does density affect congestion?
#       - What's a reasonable density for a design with moderate routing?
#
#       Typical density values:
#       - Aggressive (simple designs): 0.80-0.90
#       - Normal (moderate routing): 0.60-0.70
#       - Relaxed (complex routing): 0.40-0.50

set placement_density 0.50  ;# <-- TODO: This density is too high! Fix it.

puts "Running global placement with density: $placement_density"
global_placement -density $placement_density

# Detailed placement
puts "Running detailed placement..."
detailed_placement

# Check placement
puts ""
check_placement -verbose

#-------------------------------------------------------------------------------
# Step 7: Estimate congestion (routing preview)
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Congestion Analysis"
puts "=============================================="

# Quick routing estimate to check congestion
set_global_routing_layer_adjustment metal1 0.8
set_global_routing_layer_adjustment metal2 0.7
set_global_routing_layer_adjustment metal3 0.7

set_routing_layers -signal metal2-metal6

# Run global route estimation
global_route -allow_congestion -congestion_iterations 30

#-------------------------------------------------------------------------------
# Step 8: Report results
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Results Summary"
puts "=============================================="

# Cell count
set all_cells [get_cells *]
puts "Total cells: [llength $all_cells]"

# Report timing
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
