#===============================================================================
# SOLUTION - RTE_002 The Adjustment Agony
#===============================================================================
# Fixed layer adjustment configuration
#===============================================================================

puts "=============================================="
puts " RTE_002 - Shift Register Routing (SOLUTION)"
puts "=============================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]
set puzzle_dir [file dirname $script_dir]

puts "Script directory: $script_dir"

# Sky130 PDK paths
set orfs_root "/home/faiz/OpenROAD-flow-scripts"
set sky130_lib_dir "$orfs_root/tools/OpenROAD/test/sky130hd"
set sky130_platform "$orfs_root/flow/platforms/sky130hd"

set lib_file "$sky130_lib_dir/sky130_fd_sc_hd__tt_025C_1v80.lib"
set tech_lef "$sky130_platform/lef/sky130_fd_sc_hd.tlef"
set cell_lef "$sky130_platform/lef/sky130_fd_sc_hd_merged.lef"

# Design files
set design_file "$puzzle_dir/resources/shift_reg.v"
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
link_design shift_reg
puts "Design linked."

#-------------------------------------------------------------------------------
# Step 4: Read constraints
#-------------------------------------------------------------------------------

puts ""
puts "Loading constraints..."
read_sdc $sdc_file
puts "Constraints loaded - Target: 50 MHz"

#-------------------------------------------------------------------------------
# Step 5: Floorplan
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Creating Floorplan"
puts "=============================================="

set die_area {0 0 120 120}
set core_area {10 10 110 110}

initialize_floorplan -die_area $die_area \
                     -core_area $core_area \
                     -site unithd

make_tracks
place_pins -hor_layers met3 -ver_layers met2

puts "Floorplan created."

set_wire_rc -layer met2

#-------------------------------------------------------------------------------
# Step 6: Placement
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Placement"
puts "=============================================="

global_placement -density 0.55 -timing_driven
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

set_wire_rc -clock -layer met3

clock_tree_synthesis -root_buf sky130_fd_sc_hd__clkbuf_16 \
                     -buf_list {sky130_fd_sc_hd__clkbuf_1 sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8} \
                     -sink_clustering_enable

repair_clock_nets

puts "CTS complete."

#-------------------------------------------------------------------------------
# Step 8: Global Routing - FIXED!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Global Routing"
puts "=============================================="

set_routing_layers -signal met2-met5

# SOLUTION: Correct layer adjustments
# - Lower layers (met1, met2): HIGH adjustment (congested, reduce capacity)
# - Upper layers (met4, met5): LOW adjustment (available, keep capacity)
set_global_routing_layer_adjustment met1 0.9
set_global_routing_layer_adjustment met2 0.7
set_global_routing_layer_adjustment met3 0.4
set_global_routing_layer_adjustment met4 0.2
set_global_routing_layer_adjustment met5 0.1

puts ""
puts "Layer Adjustment Configuration (FIXED):"
puts "  met1: 0.9 (90% reduction - very congested)"
puts "  met2: 0.7 (70% reduction - congested)"
puts "  met3: 0.4 (40% reduction - moderate)"
puts "  met4: 0.2 (20% reduction - available)"
puts "  met5: 0.1 (10% reduction - most available)"
puts ""

# Run global routing
puts "Running global route..."
global_route -congestion_iterations 30 \
             -verbose

#-------------------------------------------------------------------------------
# Step 9: Post-Route Analysis
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Post-Route Analysis"
puts "=============================================="

estimate_parasitics -global_routing

puts ""
puts "Timing Summary:"
puts "--------------------------------------------------------------"
report_checks -path_delay max -format summary

set worst_slack [sta::worst_slack -max]
puts ""
puts "--------------------------------------------------------------"
puts [format "Worst slack: %.2f ns" $worst_slack]
puts "--------------------------------------------------------------"

#-------------------------------------------------------------------------------
# Step 10: Write outputs
#-------------------------------------------------------------------------------

puts ""
puts "Writing output files..."

set output_def "$results_dir/shift_reg_routed.def"
write_def $output_def
puts "  DEF: $output_def"

puts ""
puts "=============================================="
puts " ROUTING COMPLETE! (SOLUTION)"
puts "=============================================="
puts ""

exit 0
