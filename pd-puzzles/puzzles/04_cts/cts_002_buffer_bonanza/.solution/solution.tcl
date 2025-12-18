#===============================================================================
# CTS_002 - SOLUTION: Use Proper Clock Buffers
#===============================================================================
# The fix is to use clkbuf_* cells instead of inv_* cells
#===============================================================================

puts "=============================================="
puts " CTS_002 - DSP Core CTS (SOLUTION)"
puts "=============================================="

set script_dir [file dirname [file normalize [info script]]]
set puzzle_dir [file dirname $script_dir]

# Sky130 PDK paths
set orfs_root "/home/faiz/OpenROAD-flow-scripts"
set sky130_lib_dir "$orfs_root/tools/OpenROAD/test/sky130hd"
set sky130_platform "$orfs_root/flow/platforms/sky130hd"

set lib_file "$sky130_lib_dir/sky130_fd_sc_hd__tt_025C_1v80.lib"
set tech_lef "$sky130_platform/lef/sky130_fd_sc_hd.tlef"
set cell_lef "$sky130_platform/lef/sky130_fd_sc_hd_merged.lef"

set design_file "$puzzle_dir/resources/dsp_core.v"
set sdc_file "$puzzle_dir/resources/constraints.sdc"
set results_dir "$puzzle_dir/results"
file mkdir $results_dir

# Load PDK
puts "\nLoading PDK..."
read_liberty $lib_file
read_lef $tech_lef
read_lef $cell_lef

# Load design
puts "\nLoading design..."
read_verilog $design_file
link_design dsp_core

# Load constraints
read_sdc $sdc_file

# Floorplan
puts "\n=============================================="
puts " Creating Floorplan"
puts "=============================================="

initialize_floorplan -die_area {0 0 100 100} \
                     -core_area {10 10 90 90} \
                     -site unithd

make_tracks
place_pins -hor_layers met3 -ver_layers met2
set_wire_rc -layer met2

# Placement
puts "\n=============================================="
puts " Running Placement"
puts "=============================================="

global_placement -density 0.50 -timing_driven
detailed_placement
check_placement -verbose

# CTS - THE FIX
puts "\n=============================================="
puts " Running Clock Tree Synthesis"
puts "=============================================="

set_wire_rc -clock -layer met3

# SOLUTION: Use proper clock buffers!
set root_buffer "sky130_fd_sc_hd__clkbuf_16"
set buffer_list {sky130_fd_sc_hd__clkbuf_1 sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8 sky130_fd_sc_hd__clkbuf_16}

puts "\nBuffer Configuration (FIXED):"
puts "  Root buffer: $root_buffer"
puts "  Buffer list: $buffer_list"
puts ""

clock_tree_synthesis -root_buf $root_buffer \
                     -buf_list $buffer_list \
                     -sink_clustering_enable \
                     -sink_clustering_max_diameter 50

repair_clock_nets

# Analysis
puts "\n=============================================="
puts " Post-CTS Analysis"
puts "=============================================="

report_cts
estimate_parasitics -placement

puts "\nTiming Summary:"
report_checks -path_delay max -format summary

set worst_slack [sta::worst_slack -max]
puts "\n--------------------------------------------------------------"
puts [format "Worst slack: %.2f ns" $worst_slack]
puts "--------------------------------------------------------------"

# Write outputs
set output_def "$results_dir/dsp_cts.def"
write_def $output_def

puts "\n=============================================="
puts " CTS COMPLETE WITH PROPER CLOCK BUFFERS!"
puts "=============================================="

exit 0
