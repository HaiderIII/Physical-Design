#===============================================================================
# SYN_001 - Synthesis Script for Counter Design
#===============================================================================
# This script runs logic synthesis on a simple 4-bit counter.
#
# PROBLEM: The script has an error in the PDK path configuration.
#          Find and fix the TODO to make it work!
#===============================================================================

puts "=============================================="
puts " SYN_001 - Counter Synthesis"
puts "=============================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

# Get the directory where this script is located
set script_dir [file dirname [file normalize [info script]]]
set dojo_root [file dirname [file dirname [file dirname $script_dir]]]

puts "Script directory: $script_dir"
puts "Dojo root: $dojo_root"

# Design files (these are correct)
set design_file "$script_dir/resources/counter.v"
set sdc_file "$script_dir/resources/constraints.sdc"

# Results directory
set results_dir "$script_dir/results"
file mkdir $results_dir

#-------------------------------------------------------------------------------
# Step 2: PDK Configuration - THIS IS WHERE THE BUG IS!
#-------------------------------------------------------------------------------

# TODO: Fix the PDK path below
# Hint: The PDK is installed in common/pdks/nangate45/ relative to dojo_root
#       The current path "liberty/" is WRONG - it's a relative path that
#       doesn't exist. You need to construct the FULL path to the PDK files.

set pdk_dir "liberty"  ;# <-- THIS IS WRONG! Fix this line

# Liberty file (timing library)
set lib_file "$pdk_dir/lib/NangateOpenCellLibrary_typical.lib"

# LEF files (physical library)
set tech_lef "$pdk_dir/lef/NangateOpenCellLibrary.tech.lef"
set cell_lef "$pdk_dir/lef/NangateOpenCellLibrary.macro.mod.lef"

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
# Step 7: Run synthesis (Note: OpenROAD uses Yosys internally via read_verilog)
#-------------------------------------------------------------------------------

# The design is already synthesized when we read it with a Liberty file loaded
# In a real flow, you might use: synth_design or call yosys separately

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
