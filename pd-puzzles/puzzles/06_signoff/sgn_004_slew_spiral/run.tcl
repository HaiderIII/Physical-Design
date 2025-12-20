# sgn_004: Slew Spiral
# Level: Expert
# PDK: Sky130HD

puts "=============================================="
puts " SGN_004 - Slew Spiral"
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
set design_file "$script_dir/resources/data_processor.v"
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
link_design data_processor
puts "Design linked."

puts ""
puts "Loading timing constraints..."
read_sdc $sdc_file
puts "Constraints loaded."

puts ""
puts "=============================================="
puts " Creating Floorplan"
puts "=============================================="

initialize_floorplan -die_area "0 0 120 120" \
                     -core_area "10 10 110 110" \
                     -site unithd

make_tracks

place_pins -hor_layers met3 -ver_layers met2

puts "Floorplan created."

puts ""
puts "=============================================="
puts " Running Placement"
puts "=============================================="

set_wire_rc -layer met2
set_wire_rc -clock -layer met3

global_placement -density 0.7
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

puts "CTS complete."

puts ""
puts "=============================================="
puts " Global Routing"
puts "=============================================="

set_global_routing_layer_adjustment met1 0.8
set_global_routing_layer_adjustment met2 0.7
set_global_routing_layer_adjustment met3 0.5
set_global_routing_layer_adjustment met4 0.3
set_global_routing_layer_adjustment met5 0.2

set_routing_layers -signal met1-met5 -clock met3-met5

global_route -verbose


puts ""
puts "=============================================="
puts " Sign-off Timing Analysis"
puts "=============================================="


estimate_parasitics -global_routing

# Repair design for slew violations (inserts buffers for high fanout nets)
repair_design -slew_margin 0.1 -cap_margin 0.1

# Re-run placement after buffer insertion
detailed_placement
check_placement -verbose

# Re-estimate parasitics after changes
estimate_parasitics -global_routing 

puts ""
puts "=== Timing Summary ==="
report_checks -path_delay max -format full_clock_expanded

puts ""
puts "=== Transition (Slew) Report ==="
report_check_types -max_slew -violators

puts ""
puts "=== Capacitance Report ==="
report_check_types -max_capacitance -violators

puts ""
puts "=== Fanout Report ==="
report_check_types -max_fanout -violators

set worst_slack [sta::worst_slack -max]
puts ""
puts [format "Worst slack: %.3f ns" $worst_slack]

puts ""
puts "=============================================="
puts " SIGNOFF ANALYSIS COMPLETE"
puts "=============================================="

write_def $results_dir/data_processor_signoff.def

exit 0
