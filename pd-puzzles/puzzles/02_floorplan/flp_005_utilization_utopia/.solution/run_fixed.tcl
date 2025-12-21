# flp_005: Utilization Utopia - FIXED
# Level: Master
# PDK: Nangate45

puts "=============================================="
puts " FLP_005 - Utilization Utopia (FIXED)"
puts "=============================================="

set script_dir [file dirname [file normalize [info script]]]
set parent_dir [file dirname $script_dir]

# Nangate45 PDK paths
set pdk_dir "/home/faiz/OpenROAD-flow-scripts/flow/platforms/nangate45"
set lib_file "$pdk_dir/lib/NangateOpenCellLibrary_typical.lib"
set tech_lef "$pdk_dir/lef/NangateOpenCellLibrary.tech.lef"
set cell_lef "$pdk_dir/lef/NangateOpenCellLibrary.macro.lef"

# Design files
set netlist_file "$parent_dir/results/dsp_engine_synth.v"
set sdc_file "$parent_dir/resources/constraints.sdc"

# Results directory
set results_dir "$parent_dir/results"
file mkdir $results_dir

# Check if netlist exists, if not run Yosys
if {![file exists $netlist_file]} {
    puts ""
    puts "Netlist not found. Running Yosys synthesis..."
    cd $parent_dir
    exec yosys synth.ys > results/yosys.log 2>&1
    cd $parent_dir
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
link_design dsp_engine

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

# FIX: Use -utilization to let OpenROAD calculate proper die/core sizes
# Target 60% utilization with 1:1 aspect ratio and 10um core margin
initialize_floorplan -utilization 0.6 \
                     -aspect_ratio 1.0 \
                     -core_space 10 \
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
global_placement -density 0.7

puts ""
puts "Checking placement..."
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
report_checks -path_delay max -group_count 3

puts ""
puts "=== Timing Summary ==="
report_tns
report_wns

set wns [sta::worst_slack -max]
puts ""
puts [format "Worst Negative Slack (WNS): %.3f ns" $wns]

puts ""
puts "=============================================="
puts " Analysis Complete"
puts "=============================================="

write_def $results_dir/dsp_engine.def

exit 0
