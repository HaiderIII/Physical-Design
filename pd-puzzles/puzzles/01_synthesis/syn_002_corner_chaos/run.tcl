#===============================================================================
# SYN_002 - Multi-Corner Timing Analysis
#===============================================================================
# This script performs timing analysis on an SPI controller design.
#
# PROBLEM: The script only loads the TYPICAL corner, giving optimistic
#          timing results. Real signoff requires multi-corner analysis!
#
# YOUR TASK: Fix the script to load all corners and report worst-case timing.
#===============================================================================

puts "=============================================="
puts " SYN_002 - SPI Controller Timing Analysis"
puts "=============================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]
set dojo_root [file dirname [file dirname [file dirname $script_dir]]]

# Sky130 PDK paths - Liberty files are in OpenROAD-flow-scripts
set orfs_root "/home/faiz/OpenROAD-flow-scripts"
set sky130_lib_dir "$orfs_root/tools/OpenROAD/test/sky130hd"
set sky130_platform "$orfs_root/flow/platforms/sky130hd"

puts "Script directory: $script_dir"
puts "ORFS root: $orfs_root"

# Design files
set design_file "$script_dir/resources/spi_controller.v"
set sdc_file "$script_dir/resources/constraints.sdc"

# Results directory
set results_dir "$script_dir/results"
file mkdir $results_dir

#-------------------------------------------------------------------------------
# Step 2: Load Liberty files
#-------------------------------------------------------------------------------
#
# TODO: Currently only loading TYPICAL corner - this is WRONG for signoff!
#
# Available Liberty files:
#   - sky130_fd_sc_hd__tt_025C_1v80.lib  (Typical: 25C, 1.80V)
#   - sky130_fd_sc_hd__ss_n40C_1v40.lib  (Slow: -40C, 1.40V)
#   - sky130_fd_sc_hd__ff_n40C_1v95.lib  (Fast: -40C, 1.95V)
#
# For proper signoff:
#   - Setup analysis needs SLOW corner (worst-case late arrival)
#   - Hold analysis needs FAST corner (worst-case early arrival)
#
#-------------------------------------------------------------------------------

puts ""
puts "Loading Liberty files..."

# BUG: Only loading typical corner!
# This gives OPTIMISTIC timing results - not valid for signoff!
set lib_typical "$sky130_lib_dir/sky130_fd_sc_hd__tt_025C_1v80.lib"
puts "  Loading Typical corner: $lib_typical"
read_liberty $lib_typical

# TODO: Add slow corner for setup analysis
# Hint: Use read_liberty with the slow liberty file
set lib_slow "$sky130_lib_dir/sky130_fd_sc_hd__ss_n40C_1v40.lib"
puts "  Loading Slow corner: $lib_slow"
read_liberty $lib_slow

# TODO: Add fast corner for hold analysis
# Hint: Use read_liberty with the fast liberty file
set lib_fast "$sky130_lib_dir/sky130_fd_sc_hd__ff_n40C_1v95.lib"
puts "  Loading Fast corner: $lib_fast"
read_liberty $lib_fast

puts "Liberty files loaded."

#-------------------------------------------------------------------------------
# Step 3: Load LEF files
#-------------------------------------------------------------------------------

puts ""
puts "Loading LEF files..."

set tech_lef "$sky130_platform/lef/sky130_fd_sc_hd.tlef"
set cell_lef "$sky130_platform/lef/sky130_fd_sc_hd_merged.lef"

read_lef $tech_lef
read_lef $cell_lef

puts "LEF files loaded."

#-------------------------------------------------------------------------------
# Step 4: Load design
#-------------------------------------------------------------------------------

puts ""
puts "Loading design..."

read_verilog $design_file
link_design spi_controller

puts "Design loaded: spi_controller"

#-------------------------------------------------------------------------------
# Step 5: Load constraints
#-------------------------------------------------------------------------------

puts ""
puts "Loading timing constraints..."
read_sdc $sdc_file

#-------------------------------------------------------------------------------
# Step 6: Timing Analysis - THIS IS WHERE THE PROBLEM SHOWS
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Timing Summary (Setup - max path delay)"
puts "=============================================="

# TODO: This report uses whatever liberty was loaded (typical only)
#       For accurate setup analysis, we need the SLOW corner loaded
#
# When multiple corners are loaded, OpenROAD will use:
#   - Slowest delays for -path_delay max (setup)
#   - Fastest delays for -path_delay min (hold)

report_checks -path_delay max -format full_clock_expanded

puts ""
puts "=============================================="
puts " Timing Summary (Hold - min path delay)"
puts "=============================================="

# TODO: For hold analysis, we need the FAST corner
#       Currently using typical corner - results are NOT accurate!

report_checks -path_delay min -format full_clock_expanded

#-------------------------------------------------------------------------------
# Step 7: Summary
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Analysis Complete"
puts "=============================================="
puts ""
puts "WARNING: If you only loaded the typical corner,"
puts "         your timing analysis is NOT signoff-clean!"
puts ""
puts "Real chips must pass timing in ALL corners:"
puts "  - Setup: Must pass in SLOW corner (ss)"
puts "  - Hold:  Must pass in FAST corner (ff)"
puts ""
puts "Check which Liberty files were loaded above."
puts ""

exit 0
