#===============================================================================
# SGN_002 - Timing Signoff for Counter Design
#===============================================================================
# This script performs timing signoff on a counter design.
#
# PROBLEM: The SDC constraints are incomplete - missing input/output delays!
#          This causes I/O timing paths to be UNCONSTRAINED.
#
# YOUR TASK: Fix constraints.sdc to add proper input_delay and output_delay.
#===============================================================================

puts "=============================================="
puts " SGN_002 - Counter Timing Signoff"
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
set design_file "$script_dir/resources/counter.v"
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
link_design counter
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

set die_area {0 0 80 80}
set core_area {5 5 75 75}

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
# Step 8: Global Routing
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Global Routing"
puts "=============================================="

set_routing_layers -signal met2-met5

set_global_routing_layer_adjustment met1 0.8
set_global_routing_layer_adjustment met2 0.5

global_route -congestion_iterations 30

puts "Global routing complete."

#-------------------------------------------------------------------------------
# Step 9: Timing Signoff Analysis
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Timing Signoff Analysis"
puts "=============================================="

estimate_parasitics -global_routing

puts ""
puts "=== I/O Path Analysis ==="
puts ""

# Check paths from inputs
puts "Paths FROM inputs (require input_delay constraint):"
puts "--------------------------------------------------------------"
set input_paths [report_checks -from [all_inputs] -path_delay max -format summary]

puts ""
puts "Paths TO outputs (require output_delay constraint):"
puts "--------------------------------------------------------------"
set output_paths [report_checks -to [all_outputs] -path_delay max -format summary]

puts ""
puts "=== Timing Summary ==="
puts "--------------------------------------------------------------"

set setup_slack [sta::worst_slack -max]
set hold_slack [sta::worst_slack -min]

puts [format "Worst Setup Slack: %.3f ns" $setup_slack]
puts [format "Worst Hold Slack:  %.3f ns" $hold_slack]
puts "--------------------------------------------------------------"

#-------------------------------------------------------------------------------
# Step 10: Constraint Check
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " SDC Constraint Check"
puts "=============================================="

# Read the SDC file and check for set_input_delay / set_output_delay commands
set sdc_content [open $sdc_file r]
set sdc_text [read $sdc_content]
close $sdc_content

# Check for actual commands (set_), not just mentions in comments
set has_input_delay [string match "*set_input_delay*" $sdc_text]
set has_output_delay [string match "*set_output_delay*" $sdc_text]

puts ""
puts "Constraint Status:"
puts "--------------------------------------------------------------"

if {$has_input_delay} {
    puts "  input_delay:  FOUND - Input paths are constrained"
} else {
    puts "  input_delay:  MISSING!"
    puts "                >>> I/O paths from inputs are UNCONSTRAINED <<<"
}

puts ""

if {$has_output_delay} {
    puts "  output_delay: FOUND - Output paths are constrained"
} else {
    puts "  output_delay: MISSING!"
    puts "                >>> I/O paths to outputs are UNCONSTRAINED <<<"
}

puts ""
puts "--------------------------------------------------------------"

if {!$has_input_delay || !$has_output_delay} {
    puts ""
    puts "SIGNOFF FAILED: Incomplete timing constraints!"
    puts ""
    puts ">>> FIX: Add the following to resources/constraints.sdc: <<<"
    puts ""
    if {!$has_input_delay} {
        puts "  set_input_delay -clock clk 2.0 \[get_ports {rst_n enable}\]"
    }
    if {!$has_output_delay} {
        puts "  set_output_delay -clock clk 2.0 \[get_ports count\[*\]\]"
    }
    puts ""
    puts "--------------------------------------------------------------"
} else {
    puts ""
    puts "SIGNOFF PASSED: All timing constraints are complete!"
    puts ""
    puts "--------------------------------------------------------------"
}

#-------------------------------------------------------------------------------
# Step 11: Write outputs
#-------------------------------------------------------------------------------

puts ""
puts "Writing output files..."

set output_def "$results_dir/counter_signoff.def"
write_def $output_def
puts "  DEF: $output_def"

puts ""
puts "=============================================="
puts " SIGNOFF COMPLETE"
puts "=============================================="
puts ""

exit 0
