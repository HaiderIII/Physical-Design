#===============================================================================
# SGN_001 - Timing Signoff Script for ALU Design
#===============================================================================
# This script performs timing signoff on an ALU design.
#
# PROBLEM: The timing analysis is misconfigured, causing false violations.
#          Find and fix the TODO to get accurate timing results!
#===============================================================================

puts "=============================================="
puts " SGN_001 - ALU Timing Signoff"
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
set design_file "$script_dir/resources/alu.v"
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
link_design alu
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

set_wire_rc -signal \
    -resistance 1.0e-03 \
    -capacitance 1.0e-03    

puts "CTS complete."

#-------------------------------------------------------------------------------
# Step 8: Global Routing
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Global Routing"
puts "=============================================="

set_routing_layers -signal metal2-metal6

set_global_routing_layer_adjustment metal2 0.7
set_global_routing_layer_adjustment metal3 0.5

global_route -congestion_iterations 50

puts "Global routing complete."

#-------------------------------------------------------------------------------
# Step 9: Timing Signoff - THIS IS WHERE THE BUG IS!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Timing Signoff Analysis"
puts "=============================================="

# TODO: Fix the timing analysis configuration below
#
# PROBLEM: The parasitic estimation is missing!
#
# After routing, we need to extract parasitic RC values (resistance and
# capacitance of the wires) to get accurate timing. Without parasitics,
# the timing analysis uses ideal wires with zero delay, which is unrealistic.
#
# Think about:
# - What command estimates wire parasitics after routing?
# - Why are parasitics important for timing accuracy?
# - What happens if you analyze timing with ideal wires?
#
# Hint: Look for a command that "estimates parasitics"

# BUG: Missing parasitic estimation!
# Without this, timing uses wire load models (approximation)
# After routing, we should use actual RC from global routing

# TODO: Add the command to estimate parasitics from global routing
# Hint: estimate_parasitics -???
estimate_parasitics -global_routing
# End of TODO
 

puts ""
puts "=== SETUP (max delay) Analysis ==="
puts ""

report_checks -path_delay max \
              -format full_clock_expanded \
              -fields {slew cap input_pins nets fanout} \
              -digits 3

puts ""
puts "=== HOLD (min delay) Analysis ==="
puts ""

report_checks -path_delay min \
              -format full_clock_expanded \
              -fields {slew cap input_pins nets fanout} \
              -digits 3

puts ""
puts "=== Timing Summary ==="
puts ""

report_checks -path_delay max -format summary
report_checks -path_delay min -format summary

# Report worst slack
report_worst_slack -max
report_worst_slack -min

#-------------------------------------------------------------------------------
# Step 10: Write outputs
#-------------------------------------------------------------------------------

puts ""
puts "Writing output files..."

set output_def "$results_dir/alu_signoff.def"
write_def $output_def
puts "  DEF: $output_def"

#-------------------------------------------------------------------------------
# Done!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " TIMING SIGNOFF COMPLETE!"
puts "=============================================="
puts ""
puts "Check the timing reports above for violations."
puts ""

exit 0
