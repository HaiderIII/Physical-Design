#===============================================================================
# PLC_002 - Timing-Driven Placement for Pipelined Datapath
#===============================================================================
# This script runs placement on a pipelined datapath design.
#
# PROBLEM: Placement is NOT timing-driven!
#          The placer optimizes only for wirelength, ignoring timing.
#          Critical paths get long wires, destroying timing.
#
# YOUR TASK: Enable timing-driven placement mode.
#===============================================================================

puts "=============================================="
puts " PLC_002 - Timing-Driven Placement"
puts "=============================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]
set dojo_root [file dirname [file dirname [file dirname $script_dir]]]

puts "Script directory: $script_dir"

# Sky130 PDK paths
set orfs_root "/home/faiz/OpenROAD-flow-scripts"
set sky130_lib_dir "$orfs_root/tools/OpenROAD/test/sky130hd"
set sky130_platform "$orfs_root/flow/platforms/sky130hd"

set lib_file "$sky130_lib_dir/sky130_fd_sc_hd__tt_025C_1v80.lib"
set tech_lef "$sky130_platform/lef/sky130_fd_sc_hd.tlef"
set cell_lef "$sky130_platform/lef/sky130_fd_sc_hd_merged.lef"

# Design files
set design_file "$script_dir/resources/datapath.v"
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
link_design datapath
puts "Design linked."

#-------------------------------------------------------------------------------
# Step 4: Read constraints
#-------------------------------------------------------------------------------

puts ""
puts "Loading timing constraints..."
read_sdc $sdc_file
puts "Constraints loaded - Target: 125 MHz (8ns period)"

#-------------------------------------------------------------------------------
# Step 5: Floorplan
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Creating Floorplan"
puts "=============================================="

# Die size: 150um x 150um
set die_area {0 0 150 150}
set core_area {10 10 140 140}

initialize_floorplan -die_area $die_area \
                     -core_area $core_area \
                     -site unithd

# Create routing tracks
make_tracks

# Place IO pins
place_pins -hor_layers met3 -ver_layers met2

puts "Floorplan created."

# Set wire RC for timing estimation (required for timing-driven placement)
set_wire_rc -layer met2

#-------------------------------------------------------------------------------
# Step 6: Placement - THIS IS WHERE THE BUG IS!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Placement"
puts "=============================================="

# TODO: The placement below does NOT consider timing!
#
# By default, global_placement minimizes total wirelength (HPWL).
# This is fine for non-critical designs, but our pipelined datapath
# has tight timing requirements (125 MHz = 8ns period).
#
# Without timing-driven mode:
# - Placer treats all nets equally
# - Critical carry chain paths can get long wires
# - Timing fails badly after placement
#
# With timing-driven mode:
# - Placer reads timing constraints
# - Critical nets get shorter wires
# - Timing is preserved through placement

puts "Running global placement..."
global_placement -density 0.60 -timing_driven

# Detailed placement
puts "Running detailed placement..."
detailed_placement

# Check placement
check_placement -verbose

#-------------------------------------------------------------------------------
# Step 7: Report Timing - Check the damage!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Post-Placement Timing Report"
puts "=============================================="

# Estimate wire delays for timing
estimate_parasitics -placement

# Report worst paths
puts ""
puts "Timing Summary:"
puts "--------------------------------------------------------------"
report_checks -path_delay max -format summary

# Get worst slack
set worst_slack [sta::worst_slack -max]
puts ""
puts "--------------------------------------------------------------"
puts [format "Worst slack: %.2f ns" $worst_slack]

if {$worst_slack < -0.5} {
    puts ""
    puts "TIMING FAILURE: Slack is worse than -0.5ns!"
    puts ""
    puts "The placer ignored timing constraints."
    puts "Critical paths have long wires, adding excessive delay."
    puts ""
    puts ">>> FIX: Enable timing-driven placement mode <<<"
} elseif {$worst_slack < 0} {
    puts ""
    puts "TIMING WARNING: Small negative slack."
    puts "Timing-driven mode is helping but may need tuning."
} else {
    puts ""
    puts "TIMING PASSED: Design meets timing after placement!"
}

puts "--------------------------------------------------------------"

#-------------------------------------------------------------------------------
# Step 8: Write outputs
#-------------------------------------------------------------------------------

puts ""
puts "Writing output files..."

set output_def "$results_dir/datapath_placed.def"
write_def $output_def
puts "  DEF: $output_def"

#-------------------------------------------------------------------------------
# Done!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
if {$worst_slack < -0.5} {
    puts " PLACEMENT NEEDS TIMING FIX!"
} else {
    puts " PLACEMENT COMPLETE!"
}
puts "=============================================="
puts ""

exit 0
