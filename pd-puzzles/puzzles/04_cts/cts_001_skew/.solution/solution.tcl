#===============================================================================
# CTS_001 - SOLUTION
#===============================================================================
# This is the corrected CTS script.
# The fix: Use CLKBUF_X* cells instead of BUF_X* cells.
#===============================================================================

puts "=============================================="
puts " CTS_001 - Pipeline Clock Tree Synthesis (SOLUTION)"
puts "=============================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]
set puzzle_dir [file dirname $script_dir]
set dojo_root [file dirname [file dirname [file dirname $puzzle_dir]]]

puts "Script directory: $script_dir"

# PDK paths
set pdk_dir "$dojo_root/common/pdks/nangate45"
set lib_file "$pdk_dir/lib/NangateOpenCellLibrary_typical.lib"
set tech_lef "$pdk_dir/lef/NangateOpenCellLibrary.tech.lef"
set cell_lef "$pdk_dir/lef/NangateOpenCellLibrary.macro.mod.lef"

# Design files
set design_file "$puzzle_dir/resources/pipeline.v"
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
# Step 7: Clock Tree Synthesis - FIXED!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Clock Tree Synthesis"
puts "=============================================="

# SOLUTION: Use proper clock buffers (CLKBUF_X*) instead of regular buffers (BUF_X*)
#
# Why CLKBUF is better:
# - Balanced rise/fall times (reduces duty cycle distortion)
# - Designed for low skew
# - Characterized for clock networks
# - Sign-off clean (no DRC issues)

set root_buffer "CLKBUF_X3"                        ;# Strongest clock buffer for root
set buffer_list {CLKBUF_X1 CLKBUF_X2 CLKBUF_X3}   ;# Clock buffer range for tree

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

estimate_parasitics -placement
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
