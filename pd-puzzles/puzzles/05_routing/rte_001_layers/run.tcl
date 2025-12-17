#===============================================================================
# RTE_001 - Routing Script for Counter Bank Design
#===============================================================================
# This script runs routing on a counter bank design.
#
# PROBLEM: The routing layer configuration is wrong, causing congestion.
#          Find and fix the TODO to make routing work cleanly!
#===============================================================================

puts "=============================================="
puts " RTE_001 - Counter Bank Routing"
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
set design_file "$script_dir/resources/counter.v"
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
link_design counter_bank
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

initialize_floorplan -utilization 0.40 \
                     -aspect_ratio 1.0 \
                     -core_space 2 \
                     -site FreePDK45_38x28_10R_NP_162NW_34O

make_tracks
place_pins -hor_layers metal3 -ver_layers metal2

puts "Floorplan created."

#-------------------------------------------------------------------------------
# Step 6: Placement
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Placement"
puts "=============================================="

global_placement -density 0.50
detailed_placement
check_placement -verbose

puts "Placement complete."

#-------------------------------------------------------------------------------
# Step 7: CTS
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Clock Tree Synthesis"
puts "=============================================="

set_wire_rc -clock \
    -resistance 1.0e-03 \
    -capacitance 1.0e-03

clock_tree_synthesis -root_buf CLKBUF_X3 \
                     -buf_list {CLKBUF_X1 CLKBUF_X2 CLKBUF_X3} \
                     -sink_clustering_enable

repair_clock_nets

puts "CTS complete."

#-------------------------------------------------------------------------------
# Step 8: Global Routing - THIS IS WHERE THE BUG IS!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Global Routing"
puts "=============================================="

# TODO: Fix the routing layer configuration below
# Hint: Look at the available metal layers in Nangate45
#
#       The current configuration restricts routing to only 2 layers,
#       which causes severe congestion. Signal routing needs more layers!
#
#       Metal layer stack (Nangate45):
#       - metal1: Local connections (very congested, avoid for routing)
#       - metal2-metal6: Signal routing layers
#       - metal7-metal10: Power/clock (usually reserved)
#
#       Think about:
#       - How many layers should signals use?
#       - Which layers are appropriate for signal routing?
#       - What happens if you only use 2 layers?

# BUG: Only using metal1-metal2 for signal routing!
# This causes massive congestion because:
# 1. metal1 is already crowded with cell pins
# 2. Only 2 layers for all signals = routing impossible
set_routing_layers -signal metal2-metal6  ;# <-- TODO: Wrong layers! Need more routing space

# Layer adjustments (reduce available capacity)
set_global_routing_layer_adjustment metal1 0.8
set_global_routing_layer_adjustment metal2 0.7
set_global_routing_layer_adjustment metal3 0.5

# Run global routing
puts "Running global route..."
global_route -congestion_iterations 50 \
             -allow_congestion

#-------------------------------------------------------------------------------
# Step 9: Post-Route Analysis
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Post-Route Analysis"
puts "=============================================="

# Estimate parasitics
estimate_parasitics -global_routing

# Check timing
report_checks -path_delay max -format summary

#-------------------------------------------------------------------------------
# Step 10: Write outputs
#-------------------------------------------------------------------------------

puts ""
puts "Writing output files..."

set output_def "$results_dir/counter_routed.def"
write_def $output_def
puts "  DEF: $output_def"

#-------------------------------------------------------------------------------
# Done!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " ROUTING COMPLETE!"
puts "=============================================="
puts ""

exit 0
