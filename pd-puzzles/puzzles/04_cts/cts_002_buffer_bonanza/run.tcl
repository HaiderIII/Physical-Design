#===============================================================================
# CTS_002 - Clock Tree Synthesis for DSP Core
#===============================================================================
# This script runs CTS on a DSP core design.
#
# PROBLEM: Using inverters instead of clock buffers!
#          Inverters are not designed for clock distribution.
#
# YOUR TASK: Use proper Sky130 clock buffers (clkbuf_*).
#===============================================================================

puts "=============================================="
puts " CTS_002 - DSP Core Clock Tree Synthesis"
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
set design_file "$script_dir/resources/dsp_core.v"
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
link_design dsp_core
puts "Design linked."

#-------------------------------------------------------------------------------
# Step 4: Read constraints
#-------------------------------------------------------------------------------

puts ""
puts "Loading constraints..."
read_sdc $sdc_file
puts "Constraints loaded - Target: 100 MHz"

#-------------------------------------------------------------------------------
# Step 5: Floorplan
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Creating Floorplan"
puts "=============================================="

set die_area {0 0 100 100}
set core_area {10 10 90 90}

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

global_placement -density 0.50 -timing_driven
detailed_placement
check_placement -verbose

puts "Placement complete."

#-------------------------------------------------------------------------------
# Step 7: Clock Tree Synthesis - THIS IS WHERE THE BUG IS!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Clock Tree Synthesis"
puts "=============================================="

# TODO: Fix the buffer selection below!
#
# BUG: Using inverters (inv_*) instead of clock buffers (clkbuf_*)!
#
# Inverters are NOT suitable for clock trees because:
# - Unbalanced rise/fall times
# - Not characterized for clock networks
# - Can cause duty cycle distortion
# - Higher skew variation across PVT corners
#
# Sky130 provides dedicated clock buffers:
# - sky130_fd_sc_hd__clkbuf_1  (small)
# - sky130_fd_sc_hd__clkbuf_2  (medium-small)
# - sky130_fd_sc_hd__clkbuf_4  (medium)
# - sky130_fd_sc_hd__clkbuf_8  (large)
# - sky130_fd_sc_hd__clkbuf_16 (very large - good for root)

set_wire_rc -clock -layer met3

# BUG: These are inverters, not clock buffers!
set root_buffer "sky130_fd_sc_hd__clkbuf_16"
set buffer_list {sky130_fd_sc_hd__clkbuf_1 sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8}

puts ""
puts "Buffer Configuration:"
puts "  Root buffer: $root_buffer"
puts "  Buffer list: $buffer_list"
puts ""
puts "WARNING: Using inverters for clock tree is not recommended!"
puts ""

clock_tree_synthesis -root_buf $root_buffer \
                     -buf_list $buffer_list \
                     -sink_clustering_enable \
                     -sink_clustering_max_diameter 50

repair_clock_nets

#-------------------------------------------------------------------------------
# Step 8: Post-CTS Analysis
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Post-CTS Analysis"
puts "=============================================="

report_cts

estimate_parasitics -placement

puts ""
puts "Timing Summary:"
puts "--------------------------------------------------------------"
report_checks -path_delay max -format summary

set worst_slack [sta::worst_slack -max]
puts ""
puts "--------------------------------------------------------------"
puts [format "Worst slack: %.2f ns" $worst_slack]
puts "--------------------------------------------------------------"

# Check if using proper clock buffers
puts ""
puts "Buffer Usage Check:"
puts "--------------------------------------------------------------"
if {[string match "*inv*" $root_buffer]} {
    puts "WARNING: Root buffer is an inverter, not a clock buffer!"
    puts ">>> FIX: Use sky130_fd_sc_hd__clkbuf_* cells <<<"
} else {
    puts "OK: Using proper clock buffers"
}
puts "--------------------------------------------------------------"

#-------------------------------------------------------------------------------
# Step 9: Write outputs
#-------------------------------------------------------------------------------

puts ""
puts "Writing output files..."

set output_def "$results_dir/dsp_cts.def"
write_def $output_def
puts "  DEF: $output_def"

puts ""
puts "=============================================="
puts " CTS COMPLETE!"
puts "=============================================="
puts ""

exit 0
