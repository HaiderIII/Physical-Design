#===============================================================================
# RTE_002 - Global Routing for Shift Register
#===============================================================================
# This script runs routing on a shift register design.
#
# PROBLEM: Layer adjustments are inverted - blocking upper layers instead
#          of lower layers, causing severe congestion!
#
# YOUR TASK: Fix the layer adjustment values to reduce congestion.
#===============================================================================

puts "=============================================="
puts " RTE_002 - Shift Register Routing"
puts "=============================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]

puts "Script directory: $script_dir"

# Sky130 PDK paths
set orfs_root "/home/faiz/OpenROAD-flow-scripts"
set sky130_lib_dir "$orfs_root/tools/OpenROAD/test/sky130hd"
set sky130_platform "$orfs_root/flow/platforms/sky130hd"

set lib_file "$sky130_lib_dir/sky130_fd_sc_hd__tt_025C_1v80.lib"
set tech_lef "$sky130_platform/lef/sky130_fd_sc_hd.tlef"
set cell_lef "$sky130_platform/lef/sky130_fd_sc_hd_merged.lef"

# Design files
set design_file "$script_dir/resources/shift_reg.v"
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
# Step 8: Global Routing - THIS IS WHERE THE BUG IS!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Global Routing"
puts "=============================================="

# TODO: Fix the layer adjustment values below!
#
# BUG: The adjustments are INVERTED!
#      - Lower layers (met1, met2) should have HIGH adjustment (reduce capacity)
#        because they are congested with cell pins and local connections
#      - Upper layers (met4, met5) should have LOW adjustment (keep capacity)
#        because they have more space for signal routing
#
# Current (WRONG):
#      met1: 0.2 (too available - this layer is very congested!)
#      met2: 0.3 (too available)
#      met3: 0.5 (moderate)
#      met4: 0.8 (too restricted!)
#      met5: 0.9 (almost blocked - but this should be most available!)
#
# This causes the router to:
#      - Overuse congested lower layers
#      - Avoid available upper layers
#      - Result in routing overflow and congestion

set_routing_layers -signal met2-met5

# BUG: Layer adjustments are inverted!
set_global_routing_layer_adjustment met1 0.9
set_global_routing_layer_adjustment met2 0.7
set_global_routing_layer_adjustment met3 0.4
set_global_routing_layer_adjustment met4 0.2
set_global_routing_layer_adjustment met5 0.1

puts ""
puts "Layer Adjustment Configuration:"
puts "  met1: 0.2 (20% reduction)"
puts "  met2: 0.3 (30% reduction)"
puts "  met3: 0.5 (50% reduction)"
puts "  met4: 0.8 (80% reduction)"
puts "  met5: 0.9 (90% reduction)"
puts ""
puts "WARNING: Upper layers are more restricted than lower layers!"
puts ""

# Run global routing
puts "Running global route..."
global_route -congestion_iterations 30 \
             -allow_congestion \
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

# Check layer adjustment configuration
puts ""
puts "Layer Configuration Check:"
puts "--------------------------------------------------------------"
puts "Current adjustments make upper layers LESS available than lower!"
puts ""
puts "  PROBLEM: met4 and met5 are being blocked (80-90% reduction)"
puts "           while met1/met2 are kept available (20-30% reduction)"
puts ""
puts "  This is INVERTED! Lower layers are congested with cell pins."
puts "  Upper layers should be MORE available for signal routing."
puts ""
puts ">>> FIX: Invert the adjustment values! <<<"
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
puts " ROUTING COMPLETE!"
puts "=============================================="
puts ""

exit 0
