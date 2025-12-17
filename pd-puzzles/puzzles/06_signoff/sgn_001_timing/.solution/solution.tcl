#===============================================================================
# SGN_001 - SOLUTION
#===============================================================================
# This is the corrected timing signoff script.
# The fix: Add estimate_parasitics -global_routing before timing analysis.
#===============================================================================

puts "=============================================="
puts " SGN_001 - ALU Timing Signoff (SOLUTION)"
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
set design_file "$puzzle_dir/resources/alu.v"
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

# Set wire RC for parasitics estimation
set_wire_rc -signal \
    -resistance 1.0e-03 \
    -capacitance 1.0e-03
set_wire_rc -clock \
    -resistance 1.0e-03 \
    -capacitance 1.0e-03

# Estimate parasitics for CTS
estimate_parasitics -placement

clock_tree_synthesis -root_buf CLKBUF_X3 \
                     -buf_list {CLKBUF_X1 CLKBUF_X2 CLKBUF_X3} \
                     -sink_clustering_enable

repair_clock_nets

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
# Step 9: Timing Signoff - FIXED!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Timing Signoff Analysis"
puts "=============================================="

# SOLUTION: Estimate parasitics from global routing
#
# This command extracts RC (resistance/capacitance) values from the routed
# wires and annotates them for timing analysis. Without this step, timing
# uses ideal wires with zero delay, which is unrealistically optimistic.

estimate_parasitics -global_routing   ;# FIXED: Extract wire RC for timing

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
puts " TIMING SIGNOFF COMPLETE - WITH PARASITICS!"
puts "=============================================="
puts ""
puts "Timing is now based on realistic wire delays."
puts ""

exit 0
