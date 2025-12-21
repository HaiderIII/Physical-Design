# syn_005: False Path Fiasco
# Level: Master
# PDK: Nangate45

puts "=============================================="
puts " SYN_005 - False Path Fiasco"
puts "=============================================="

set script_dir [file dirname [file normalize [info script]]]

# Nangate45 PDK paths
set pdk_dir "/home/faiz/OpenROAD-flow-scripts/flow/platforms/nangate45"
set lib_file "$pdk_dir/lib/NangateOpenCellLibrary_typical.lib"
set tech_lef "$pdk_dir/lef/NangateOpenCellLibrary.tech.lef"
set cell_lef "$pdk_dir/lef/NangateOpenCellLibrary.macro.lef"

# Design files
set netlist_file "$script_dir/results/burst_controller_synth.v"
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
link_design burst_controller

puts ""
puts "=== Design Statistics ==="
report_design_area

puts ""
puts "=============================================="
puts " Floorplan and Placement"
puts "=============================================="

initialize_floorplan -die_area "0 0 100 100" \
                     -core_area "10 10 90 90" \
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

set_wire_rc -layer metal3
global_placement -timing_driven -density 0.6
detailed_placement
check_placement -verbose

puts ""
puts "=============================================="
puts " CTS and Routing"
puts "=============================================="

clock_tree_synthesis -root_buf CLKBUF_X3 \
                     -buf_list {CLKBUF_X1 CLKBUF_X2 CLKBUF_X3}
repair_clock_nets

set_global_routing_layer_adjustment metal2 0.8
set_global_routing_layer_adjustment metal3 0.7
set_global_routing_layer_adjustment metal4 0.5
set_global_routing_layer_adjustment metal5 0.4
set_global_routing_layer_adjustment metal6 0.3

set_routing_layers -signal metal2-metal6 -clock metal3-metal6
global_route -verbose

estimate_parasitics -global_routing

puts ""
puts "=============================================="
puts " Timing Analysis"
puts "=============================================="

puts ""
puts "Reading timing constraints..."
read_sdc $sdc_file

puts ""
puts "=== Timing Report ==="
report_checks -path_delay max -format full_clock_expanded -group_count 3

set wns [sta::worst_slack -max]
puts ""
puts [format "Worst Negative Slack (WNS): %.3f ns" $wns]

puts ""
puts "=============================================="
puts " False Path Analysis"
puts "=============================================="

puts ""
puts "Ports matching the '*rst*' wildcard in SDC:"
foreach port [get_ports *rst*] {
    puts "  - [get_full_name $port]"
}

puts ""
puts "Ports matching the '*first*' wildcard in SDC:"
foreach port [get_ports *first*] {
    puts "  - [get_full_name $port]"
}

puts ""
puts "=============================================="
puts " Analysis Complete"
puts "=============================================="

write_def $results_dir/burst_controller.def

exit 0
