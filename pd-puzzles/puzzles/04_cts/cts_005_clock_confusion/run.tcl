# cts_005: Clock Confusion
# Level: Master
# PDK: Nangate45

puts "=============================================="
puts " CTS_005 - Clock Confusion"
puts "=============================================="

set script_dir [file dirname [file normalize [info script]]]

# Nangate45 PDK paths
set pdk_dir "/home/faiz/OpenROAD-flow-scripts/flow/platforms/nangate45"
set lib_file "$pdk_dir/lib/NangateOpenCellLibrary_typical.lib"
set tech_lef "$pdk_dir/lef/NangateOpenCellLibrary.tech.lef"
set cell_lef "$pdk_dir/lef/NangateOpenCellLibrary.macro.lef"

# Design files
set netlist_file "$script_dir/results/pipelined_adder_synth.v"
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
link_design pipelined_adder

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

initialize_floorplan -utilization 0.50 \
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

global_placement -density 0.50
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
puts " Post-CTS Analysis"
puts "=============================================="

set_propagated_clock [all_clocks]

puts ""
puts "=== Clock Tree Report ==="
report_clock_skew

puts ""
puts "=== Timing Analysis ==="
estimate_parasitics -placement

puts ""
report_checks -path_delay max -group_count 3

puts ""
puts "=== Timing Summary ==="
report_tns
report_wns

set wns [sta::worst_slack -max]
puts ""
puts [format "Worst Negative Slack (WNS): %.3f ns" $wns]

# Check for timing violations
if {$wns < 0} {
    puts ""
    puts "WARNING: Timing violations detected!"
    puts "Check clock tree insertion delay and buffer selection."
}

puts ""
puts "=============================================="
puts " Analysis Complete"
puts "=============================================="

write_def $results_dir/pipelined_adder.def

exit 0
