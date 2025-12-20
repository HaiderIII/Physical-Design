# plc_004: Padding Overflow
# Level: Expert
# PDK: Sky130HD

puts "=============================================="
puts " PLC_004 - Padding Overflow"
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
set design_file "$script_dir/resources/alu.v"
set sdc_file "$script_dir/resources/constraints.sdc"

# Results directory
set results_dir "$script_dir/results"
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
link_design alu
puts "Design linked."

puts ""
puts "Loading timing constraints..."
read_sdc $sdc_file
puts "Constraints loaded."

puts ""
puts "=============================================="
puts " Creating Floorplan"
puts "=============================================="

initialize_floorplan -die_area "0 0 50 50" \
                     -core_area "5 5 45 45" \
                     -site unithd

make_tracks

place_pins -hor_layers met3 -ver_layers met2

puts "Floorplan created."

puts ""
puts "=============================================="
puts " Running Placement"
puts "=============================================="

set_placement_padding -global -left 2 -right 2

puts "Running global placement..."
global_placement -density 0.7

puts "Running detailed placement..."
detailed_placement

puts ""
puts "Checking placement..."
check_placement -verbose

puts ""
puts "=============================================="
puts " PLACEMENT COMPLETE!"
puts "=============================================="

write_def $results_dir/alu_placed.def

exit 0
