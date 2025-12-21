# sgn_005: DRC Disaster - FIXED
# Level: Master
# PDK: Nangate45

puts "=============================================="
puts " SGN_005 - DRC Disaster (FIXED)"
puts "=============================================="

set script_dir [file dirname [file normalize [info script]]]
set script_dir [file dirname $script_dir]

# Nangate45 PDK paths
set pdk_dir "/home/faiz/OpenROAD-flow-scripts/flow/platforms/nangate45"
set lib_file "$pdk_dir/lib/NangateOpenCellLibrary_typical.lib"
set tech_lef "$pdk_dir/lef/NangateOpenCellLibrary.tech.lef"
set cell_lef "$pdk_dir/lef/NangateOpenCellLibrary.macro.lef"

# Design files
set netlist_file "$script_dir/results/fast_path_synth.v"
set sdc_file "$script_dir/resources/constraints.sdc"

# Results directory
set results_dir "$script_dir/results"
file mkdir $results_dir

# Check if netlist exists, if not run Yosys
if {![file exists $netlist_file]} {
    puts ""
    puts "Netlist not found. Running Yosys synthesis..."
    cd $script_dir
    exec yosys synth.ys > results/yosys.log 2>&1
    cd $script_dir
    puts "Yosys synthesis complete."
}

puts ""
puts "Loading PDK..."
read_liberty $lib_file
read_lef $tech_lef
read_lef $cell_lef
puts "PDK loaded."

puts ""
puts "=============================================="
puts " Loading Synthesized Netlist"
puts "=============================================="

read_verilog $netlist_file
link_design fast_path

puts ""
puts "Reading timing constraints..."
read_sdc $sdc_file

puts ""
puts "=== Design Statistics ==="
report_design_area

puts ""
puts "=============================================="
puts " Floorplan"
puts "=============================================="

initialize_floorplan -utilization 0.40 \
                     -aspect_ratio 1.0 \
                     -core_space 5 \
                     -site FreePDK45_38x28_10R_NP_162NW_34O

make_tracks

# PDN setup
add_global_connection -net {VDD} -inst_pattern {.*} -pin_pattern {^VDD$} -power
add_global_connection -net {VSS} -inst_pattern {.*} -pin_pattern {^VSS$} -ground
global_connect

set_voltage_domain -name {CORE} -power {VDD} -ground {VSS}
define_pdn_grid -name {grid} -voltage_domains {CORE}
add_pdn_stripe -grid {grid} -layer {metal1} -width {0.17} -followpins
add_pdn_stripe -grid {grid} -layer {metal4} -width {0.48} -pitch {56.0} -offset {2}
add_pdn_connect -grid {grid} -layers {metal1 metal4}
pdngen

place_pins -hor_layers metal3 -ver_layers metal2

puts ""
puts "=============================================="
puts " Placement"
puts "=============================================="

set_wire_rc -layer metal3

global_placement -density 0.40
detailed_placement
check_placement -verbose

puts ""
puts "=============================================="
puts " Clock Tree Synthesis"
puts "=============================================="

set_wire_rc -clock -layer metal3

clock_tree_synthesis -root_buf CLKBUF_X3 \
                     -buf_list {CLKBUF_X1 CLKBUF_X2 CLKBUF_X3} \
                     -sink_clustering_enable \
                     -sink_clustering_size 10 \
                     -sink_clustering_max_diameter 50

repair_clock_nets

puts ""
puts "=============================================="
puts " Global Routing"
puts "=============================================="

set_routing_layers -signal metal2-metal6 -clock metal3-metal6

set_global_routing_layer_adjustment metal2 0.5
set_global_routing_layer_adjustment metal3 0.5
set_global_routing_layer_adjustment metal4 0.3
set_global_routing_layer_adjustment metal5 0.2
set_global_routing_layer_adjustment metal6 0.2

global_route -verbose

puts ""
puts "=============================================="
puts " Sign-off Timing Analysis"
puts "=============================================="

estimate_parasitics -global_routing

# FIXED: Run repair_design to fix DRC violations
puts ""
puts "Running repair_design to fix DRC violations..."
repair_design -slew_margin 0.1 -cap_margin 0.1

detailed_placement
check_placement -verbose

estimate_parasitics -global_routing

puts ""
puts "=== DRC Violation Report (After Repair) ==="
report_check_types -max_slew -max_capacitance -max_fanout -violators

puts ""
puts "=== Setup Timing Report ==="
report_checks -path_delay max -group_count 3

puts ""
puts "=== Timing Summary ==="
set wns_setup [sta::worst_slack -max]
puts [format "Setup WNS: %.3f ns" $wns_setup]

puts ""
puts "=============================================="
puts " Sign-off Complete (DRC Fixed)"
puts "=============================================="

write_def $results_dir/fast_path.def

exit 0
