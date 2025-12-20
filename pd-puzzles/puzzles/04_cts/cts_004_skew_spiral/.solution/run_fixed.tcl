# cts_004: Skew Spiral - SOLUTION
# Level: Expert
# PDK: Sky130HD

puts "=============================================="
puts " CTS_004 - Skew Spiral (FIXED)"
puts "=============================================="

set script_dir [file dirname [file normalize [info script]]]

# Sky130 PDK paths
set orfs_root "/home/faiz/OpenROAD-flow-scripts"
set sky130_lib_dir "$orfs_root/tools/OpenROAD/test/sky130hd"
set sky130_platform "$orfs_root/flow/platforms/sky130hd"

set lib_file "$sky130_lib_dir/sky130_fd_sc_hd__tt_025C_1v80.lib"
set tech_lef "$sky130_platform/lef/sky130_fd_sc_hd.tlef"
set cell_lef "$sky130_platform/lef/sky130_fd_sc_hd_merged.lef"

# Design files
set design_file "$script_dir/../resources/register_file.v"
set sdc_file "$script_dir/../resources/constraints.sdc"

# Results directory
set results_dir "$script_dir/../results"
file mkdir $results_dir

puts ""
puts "Loading PDK..."
read_liberty $lib_file
read_lef $tech_lef
read_lef $cell_lef
puts "PDK loaded."

puts ""
puts "Loading design..."
read_verilog $design_file
link_design register_file
puts "Design linked."

puts ""
puts "Loading timing constraints..."
read_sdc $sdc_file
puts "Constraints loaded."

puts ""
puts "=============================================="
puts " Creating Floorplan"
puts "=============================================="

initialize_floorplan -die_area "0 0 100 100" \
                     -core_area "10 10 90 90" \
                     -site unithd

make_tracks

place_pins -hor_layers met3 -ver_layers met2

puts "Floorplan created."

# FIX: Set wire RC for BOTH signal and clock nets
# This is required for accurate parasitic estimation
set_wire_rc -layer met2
set_wire_rc -clock -layer met3

puts ""
puts "=============================================="
puts " Running Placement"
puts "=============================================="

global_placement -density 0.5
detailed_placement
check_placement -verbose

puts "Placement complete."

puts ""
puts "=============================================="
puts " Clock Tree Synthesis"
puts "=============================================="

set cts_buffer "sky130_fd_sc_hd__clkbuf_4"
set buffer_list "sky130_fd_sc_hd__clkbuf_1 sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_4"

clock_tree_synthesis -root_buf $cts_buffer \
                     -buf_list $buffer_list

repair_clock_nets

puts ""
puts "=============================================="
puts " Post-CTS Analysis"
puts "=============================================="

report_cts

estimate_parasitics -placement

puts ""
puts "Timing Analysis:"
report_checks -path_delay max -format summary

set worst_slack [sta::worst_slack -max]
puts ""
puts [format "Worst slack: %.3f ns" $worst_slack]

puts ""
puts "=============================================="
puts " CTS COMPLETE"
puts "=============================================="

write_def $results_dir/register_file_cts.def

exit 0
