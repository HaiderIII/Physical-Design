#===============================================================================
# CTS_001 - Clock Tree Synthesis Script for Pipeline Design
#===============================================================================
# This script runs CTS on a 4-stage pipeline.
#
# PROBLEM: The clock buffer list is missing proper clock buffers!
#          Find and fix the TODO to make CTS work correctly.
#===============================================================================

puts "=============================================="
puts " CTS_001 - Pipeline Clock Tree Synthesis"
puts "=============================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]
set dojo_root [file dirname [file dirname [file dirname $script_dir]]]

puts "Script directory: $script_dir"

# PDK paths
set pdk_dir "$dojo_root/common/pdks/nangate45"
set lib_file "$pdk_dir/lib/NangateOpenCellLibrary_typical.lib"
set tech_lef "$pdk_dir/lef/NangateOpenCellLibrary.tech.lef"
set cell_lef "$pdk_dir/lef/NangateOpenCellLibrary.macro.mod.lef"

# Design files
set design_file "$script_dir/resources/pipeline.v"
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
link_design pipeline
puts "Design linked."

#-------------------------------------------------------------------------------
# Step 4: Read constraints
#-------------------------------------------------------------------------------

puts ""
puts "Loading constraints..."
read_sdc $sdc_file

#-------------------------------------------------------------------------------
# Step 5: Floorplan
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Creating Floorplan"
puts "=============================================="

initialize_floorplan -utilization 0.40 \
                     -aspect_ratio 1.0 \
                     -core_space 2 \
                     -site FreePDK45_38x28_10R_NP_162NW_34O

make_tracks
place_pins -hor_layers metal3 -ver_layers metal2

puts "Floorplan created."

#-------------------------------------------------------------------------------
# Step 6: Placement
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Placement"
puts "=============================================="

global_placement -density 0.60
detailed_placement
check_placement -verbose

puts "Placement complete."

#-------------------------------------------------------------------------------
# Step 7: Clock Tree Synthesis - THIS IS WHERE THE BUG IS!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Clock Tree Synthesis"
puts "=============================================="

# TODO: Fix the buffer list below
# Hint: Using regular buffers (BUF_X1) instead of clock buffers (CLKBUF_X*)
#       is a common mistake!
#
#       Clock buffers (CLKBUF) are specifically designed for clock distribution:
#       - Balanced rise/fall times
#       - Low skew characteristics
#       - Optimized for clock networks
#
#       Regular buffers (BUF_X1) are NOT suitable for clock trees:
#       - Unbalanced delays
#       - Not characterized for clock use
#       - Can cause skew and jitter issues
#
#       Available clock buffers in Nangate45:
#       - CLKBUF_X1: Small clock buffer
#       - CLKBUF_X2: Medium clock buffer
#       - CLKBUF_X3: Large clock buffer (good for root)

# BUG: Using regular buffers instead of clock buffers!
set root_buffer "CLKBUF_X3"
set buffer_list {CLKBUF_X1 CLKBUF_X2 CLKBUF_X3}  ;# <-- TODO: Wrong buffers! Use CLKBUF_X* instead

# Configure CTS
set_wire_rc -clock \
    -resistance 1.0e-03 \
    -capacitance 1.0e-03

# Run clock tree synthesis
puts "Using root buffer: $root_buffer"
puts "Using buffer list: $buffer_list"

clock_tree_synthesis -root_buf $root_buffer \
                     -buf_list $buffer_list \
                     -sink_clustering_enable \
                     -sink_clustering_max_diameter 50 \
                     -balance_levels

# Repair clock nets
repair_clock_nets

# Report CTS results
puts ""
puts "=============================================="
puts " CTS Results"
puts "=============================================="
report_cts

#-------------------------------------------------------------------------------
# Step 8: Post-CTS timing
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Post-CTS Timing"
puts "=============================================="

# Estimate parasitics
estimate_parasitics -placement

# Report timing
report_checks -path_delay max -format summary

#-------------------------------------------------------------------------------
# Step 9: Write outputs
#-------------------------------------------------------------------------------

puts ""
puts "Writing output files..."

set output_def "$results_dir/pipeline_cts.def"
write_def $output_def
puts "  DEF: $output_def"

#-------------------------------------------------------------------------------
# Done!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " CTS COMPLETE!"
puts "=============================================="
puts ""

exit 0
