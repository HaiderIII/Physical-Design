#===============================================================================
# SYN_001 - SOLUTION
#===============================================================================
# Corrected synthesis script for Counter Design
#===============================================================================

puts "=============================================="
puts " SYN_001 - Counter Synthesis"
puts "=============================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

# Get the directory where this script is located
set script_dir [file dirname [file normalize [info script]]]

# Go up to .solution/, then syn_001/, then 01_synthesis/, then puzzles/, then dojo_root
# Since solution is in .solution/ subfolder, we need 4 levels up
set puzzle_dir [file dirname $script_dir]
set dojo_root [file dirname [file dirname [file dirname $puzzle_dir]]]

puts "Script directory: $script_dir"
puts "Puzzle directory: $puzzle_dir"
puts "Dojo root: $dojo_root"

# Design files
set design_file "$puzzle_dir/resources/counter.v"
set sdc_file "$puzzle_dir/resources/constraints.sdc"

# Results directory
set results_dir "$puzzle_dir/results"
file mkdir $results_dir

#-------------------------------------------------------------------------------
# Step 2: PDK Configuration - CORRECTED!
#-------------------------------------------------------------------------------

# SOLUTION: Use the full path constructed from dojo_root
set pdk_root "$dojo_root/common/pdks/nangate45"

# Liberty file (timing library) - in lib/ subdirectory
set lib_file "$pdk_root/lib/NangateOpenCellLibrary_typical.lib"

# LEF files (physical library) - in lef/ subdirectory
set tech_lef "$pdk_root/lef/NangateOpenCellLibrary.tech.lef"
set cell_lef "$pdk_root/lef/NangateOpenCellLibrary.lef"

# Alternative using file join (more portable):
# set lib_file [file join $pdk_root "lib" "NangateOpenCellLibrary_typical.lib"]
# set tech_lef [file join $pdk_root "lef" "NangateOpenCellLibrary.tech.lef"]
# set cell_lef [file join $pdk_root "lef" "NangateOpenCellLibrary.lef"]

#-------------------------------------------------------------------------------
# Step 3: Read PDK files
#-------------------------------------------------------------------------------

puts ""
puts "Loading PDK files..."

# Read Liberty (timing)
puts "  Reading Liberty: $lib_file"
read_liberty $lib_file

# Read LEF (physical)
puts "  Reading Tech LEF: $tech_lef"
read_lef $tech_lef

puts "  Reading Cell LEF: $cell_lef"
read_lef $cell_lef

puts "PDK loaded successfully!"

#-------------------------------------------------------------------------------
# Step 4: Read design
#-------------------------------------------------------------------------------

puts ""
puts "Loading design..."

# Read Verilog
puts "  Reading Verilog: $design_file"
read_verilog $design_file

# Link design
link_design counter
puts "Design linked: counter"

#-------------------------------------------------------------------------------
# Step 5: Read constraints
#-------------------------------------------------------------------------------

puts ""
puts "Loading constraints..."
puts "  Reading SDC: $sdc_file"
read_sdc $sdc_file

#-------------------------------------------------------------------------------
# Step 6: Report pre-synthesis info
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Pre-Synthesis Report"
puts "=============================================="

set num_cells [llength [get_cells -hierarchical *]]
puts "Cells before synthesis: $num_cells"

#-------------------------------------------------------------------------------
# Step 7: Post-synthesis report
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Post-Synthesis Report"
puts "=============================================="

# Count cells by type
set all_cells [get_cells -hierarchical *]
puts "Total cells: [llength $all_cells]"

# Try to get cell breakdown
puts ""
puts "Cell breakdown:"
set cell_types [dict create]
foreach cell $all_cells {
    set ref_name [get_property $cell ref_name]
    if {[dict exists $cell_types $ref_name]} {
        dict incr cell_types $ref_name
    } else {
        dict set cell_types $ref_name 1
    }
}

dict for {type count} $cell_types {
    puts [format "  %-25s : %3d" $type $count]
}

#-------------------------------------------------------------------------------
# Step 8: Check timing
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Timing Summary"
puts "=============================================="

report_checks -path_delay max -format summary

#-------------------------------------------------------------------------------
# Step 9: Write outputs
#-------------------------------------------------------------------------------

puts ""
puts "Writing output files..."

set output_verilog "$results_dir/counter_synth.v"
write_verilog $output_verilog
puts "  Synthesized netlist: $output_verilog"

set output_sdc "$results_dir/counter_synth.sdc"
write_sdc $output_sdc
puts "  Constraints: $output_sdc"

#-------------------------------------------------------------------------------
# Done!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " SYNTHESIS COMPLETE!"
puts "=============================================="
puts ""
puts "Output files in: $results_dir"
puts ""

exit 0
