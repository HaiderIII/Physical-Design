#===============================================================================
# PLC_002 - SOLUTION: Timing-Driven Placement
#===============================================================================
# The fix is on the global_placement command - add -timing_driven flag
#===============================================================================

puts "=============================================="
puts " PLC_002 - Timing-Driven Placement (SOLUTION)"
puts "=============================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]
set puzzle_dir [file dirname $script_dir]

puts "Script directory: $script_dir"

# Sky130 PDK paths
set orfs_root "/home/faiz/OpenROAD-flow-scripts"
set sky130_lib_dir "$orfs_root/tools/OpenROAD/test/sky130hd"
set sky130_platform "$orfs_root/flow/platforms/sky130hd"

set lib_file "$sky130_lib_dir/sky130_fd_sc_hd__tt_025C_1v80.lib"
set tech_lef "$sky130_platform/lef/sky130_fd_sc_hd.tlef"
set cell_lef "$sky130_platform/lef/sky130_fd_sc_hd_merged.lef"

# Design files
set design_file "$puzzle_dir/resources/datapath.v"
set sdc_file "$puzzle_dir/resources/constraints.sdc"

# Results directory
set results_dir "$puzzle_dir/results"
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

set die_area {0 0 150 150}
set core_area {10 10 140 140}

initialize_floorplan -die_area $die_area \
                     -core_area $core_area \
                     -site unithd

make_tracks
place_pins -hor_layers met3 -ver_layers met2

puts "Floorplan created."

# Set wire RC for timing estimation (required for timing-driven placement)
set_wire_rc -layer met2

#-------------------------------------------------------------------------------
# Step 6: Placement - THE FIX
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Timing-Driven Placement"
puts "=============================================="

# SOLUTION: Add -timing_driven flag!
# This tells the placer to consider timing constraints from SDC
puts "Running global placement with TIMING-DRIVEN mode..."
global_placement -density 0.60 -timing_driven

# Detailed placement
puts "Running detailed placement..."
detailed_placement

# Check placement
check_placement -verbose

#-------------------------------------------------------------------------------
# Step 7: Report Timing
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Post-Placement Timing Report"
puts "=============================================="

estimate_parasitics -placement

puts ""
puts "Timing Summary:"
puts "--------------------------------------------------------------"
report_checks -path_delay max -format summary

set worst_slack [sta::worst_slack -max]
puts ""
puts "--------------------------------------------------------------"
puts [format "Worst slack: %.2f ns" $worst_slack]

if {$worst_slack < -0.5} {
    puts "TIMING FAILURE: Slack is worse than -0.5ns!"
} elseif {$worst_slack < 0} {
    puts "TIMING WARNING: Small negative slack."
} else {
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

puts ""
puts "=============================================="
puts " PLACEMENT COMPLETE WITH TIMING OPTIMIZATION!"
puts "=============================================="
puts ""

exit 0
