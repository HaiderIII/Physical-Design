#===============================================================================
# FLP_003 - Floorplan Density Configuration
#===============================================================================
# This script creates a floorplan for a 16-bit datapath on ASAP7.
#
# PROBLEM: The floorplan has WRONG density settings!
#          - Die area is too small for the number of cells
#          - Placement density target is too aggressive (95%)
#          - This causes placement to fail or have severe congestion
#
# YOUR TASK: Fix the density configuration to allow successful placement.
#===============================================================================

puts "=============================================="
puts " FLP_003 - Datapath Floorplan (ASAP7)"
puts "=============================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]

puts "Script directory: $script_dir"

# ASAP7 PDK paths
set platform_dir "$::env(HOME)/OpenROAD-flow-scripts/flow/platforms/asap7"

# Design files
set design_file "$script_dir/resources/datapath.v"
set sdc_file "$script_dir/resources/constraints.sdc"

# Results directory
set results_dir "$script_dir/results"
file mkdir $results_dir

#-------------------------------------------------------------------------------
# Step 2: Load ASAP7 PDK (RVT)
#-------------------------------------------------------------------------------

puts ""
puts "Loading ASAP7 RVT libraries..."

# Load liberty files
set lib_files [glob -nocomplain $platform_dir/lib/NLDM/asap7sc7p5t_*_RVT_TT_nldm_*.lib.gz]
foreach lib_file $lib_files {
    read_liberty $lib_file
}
read_liberty $platform_dir/lib/NLDM/asap7sc7p5t_SEQ_RVT_TT_nldm_220123.lib

# Load LEF files
read_lef $platform_dir/lef/asap7_tech_1x_201209.lef
read_lef $platform_dir/lef/asap7sc7p5t_28_R_1x_220121a.lef

puts "PDK loaded."

#-------------------------------------------------------------------------------
# Step 3: Load design
#-------------------------------------------------------------------------------

puts ""
puts "Loading design..."
read_verilog $design_file
link_design datapath_unit
puts "Design linked."

#-------------------------------------------------------------------------------
# Step 4: Read constraints
#-------------------------------------------------------------------------------

puts ""
puts "Loading constraints..."
read_sdc $sdc_file
puts "Constraints loaded - Target: 1 GHz"

#-------------------------------------------------------------------------------
# Step 5: Analyze design size
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Design Analysis"
puts "=============================================="

# Count cells
set all_cells [get_cells -hierarchical *]
set cell_count [llength $all_cells]

puts ""
puts "Design Statistics:"
puts "  Total cells: $cell_count"

# Estimate area needed (rough calculation)
# ASAP7 cells are approximately 0.2um tall, 0.05-0.5um wide
# Average cell width ~0.15um, so area per cell ~0.03 um^2
set avg_cell_area 0.054  ;# um^2 (conservative estimate for ASAP7)
set total_cell_area [expr {$cell_count * $avg_cell_area}]

puts "  Estimated cell area: [format "%.2f" $total_cell_area] um^2"

#-------------------------------------------------------------------------------
# Step 6: Initialize Floorplan - THIS IS WHERE THE BUGS ARE!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Creating Floorplan"
puts "=============================================="

# BUG #1: Die area is TOO SMALL!
# With ~66 cells needing ~3.6 um^2, and at 60% utilization,
# we need at least 6 um^2 of core area.
# But this die is only 2x2 = 4 um^2 total, ~2.5 um^2 core!

# BUG #2: The aspect ratio is 1:1 but for a datapath,
# a wider aspect ratio (like 2:1) would be better for routing.

# TODO: Fix die_area and core_area to provide enough space!
# Hint: The design needs at least 6 um^2 of core area at 60% utilization

set die_area  {0 0 2 2}       ;# <-- TOO SMALL! Only 4 um^2 die
set core_area {0.2 0.2 1.8 1.8}  ;# <-- Only ~2.5 um^2 core area!

puts "Die area: $die_area"
puts "Core area: $core_area"

set die_width [expr {[lindex $die_area 2] - [lindex $die_area 0]}]
set die_height [expr {[lindex $die_area 3] - [lindex $die_area 1]}]
set core_width [expr {[lindex $core_area 2] - [lindex $core_area 0]}]
set core_height [expr {[lindex $core_area 3] - [lindex $core_area 1]}]
set die_total [expr {$die_width * $die_height}]
set core_total [expr {$core_width * $core_height}]

puts ""
puts "Floorplan dimensions:"
puts "  Die:  ${die_width} x ${die_height} um = [format "%.2f" $die_total] um^2"
puts "  Core: ${core_width} x ${core_height} um = [format "%.2f" $core_total] um^2"

initialize_floorplan -die_area $die_area \
                     -core_area $core_area \
                     -site asap7sc7p5t

source $platform_dir/openRoad/make_tracks.tcl

#-------------------------------------------------------------------------------
# Step 7: Set wire RC (from ASAP7 setRC.tcl)
#-------------------------------------------------------------------------------

source $platform_dir/setRC.tcl

#-------------------------------------------------------------------------------
# Step 8: Place IO pins
#-------------------------------------------------------------------------------

puts ""
puts "Placing IO pins..."
place_pins -hor_layers M4 -ver_layers M5

#-------------------------------------------------------------------------------
# Step 9: Global Placement with density check
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Placement"
puts "=============================================="

# BUG #3: Density target is WAY TOO HIGH!
# 95% density leaves almost no room for routing and buffers.
# For ASAP7, typical targets are 50-70%.

set target_density 0.60  ;# <-- TOO HIGH! Should be 0.60 or less

puts "Target density: [expr {int($target_density * 100)}]%"
puts ""

# Calculate expected utilization
set expected_util [expr {$total_cell_area / $core_total * 100}]
puts "Expected utilization: [format "%.1f" $expected_util]%"

if {$expected_util > 100} {
    puts ""
    puts ">>> ERROR: Design doesn't fit! <<<"
    puts "    Cell area ([format "%.2f" $total_cell_area] um^2) > Core area ([format "%.2f" $core_total] um^2)"
    puts ""
    puts "    HINT: Increase die_area and core_area to fit the design."
    puts "          For [format "%.2f" $total_cell_area] um^2 of cells at 60% density,"
    puts "          you need at least [format "%.2f" [expr {$total_cell_area / 0.6}]] um^2 of core area."
    puts ""
    puts "=============================================="
    puts " FLOORPLAN FAILED: Area too small!"
    puts "=============================================="
    exit 1
}

if {$expected_util > 80} {
    puts ""
    puts ">>> WARNING: Utilization very high! <<<"
    puts "    This may cause placement/routing congestion."
    puts ""
}

puts ""
puts "Running global placement..."

# Try placement - will fail or warn if density is wrong
if {[catch {global_placement -density $target_density -timing_driven} err]} {
    puts ""
    puts ">>> PLACEMENT FAILED! <<<"
    puts "Error: $err"
    puts ""
    puts "HINTS:"
    puts "  1. Increase die_area and core_area"
    puts "  2. Reduce target_density to 0.60 or less"
    puts ""
    puts "=============================================="
    puts " FLOORPLAN FAILED!"
    puts "=============================================="
    exit 1
}

puts "Running detailed placement..."
detailed_placement

#-------------------------------------------------------------------------------
# Step 10: Placement Quality Check
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Placement Quality Check"
puts "=============================================="

# Check placement
check_placement -verbose

# Estimate congestion based on density
if {$target_density > 0.80} {
    puts ""
    puts ">>> WARNING: High density may cause routing congestion! <<<"
    puts "    Target density: [expr {int($target_density * 100)}]%"
    puts "    Recommended: 50-70% for ASAP7"
    puts ""
    puts "=============================================="
    puts " FLOORPLAN COMPLETED WITH WARNINGS"
    puts "=============================================="
    puts ""
    puts "The floorplan may work but has high congestion risk."
    puts "Consider reducing density for better routability."
    puts ""
    exit 1
}

#-------------------------------------------------------------------------------
# Step 11: Write outputs
#-------------------------------------------------------------------------------

puts ""
puts "Writing output files..."

set output_def "$results_dir/datapath_floorplan.def"
write_def $output_def
puts "  DEF: $output_def"

#-------------------------------------------------------------------------------
# Success!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " FLOORPLAN PASSED!"
puts "=============================================="
puts ""
puts "  Die area: ${die_width} x ${die_height} um"
puts "  Core area: ${core_width} x ${core_height} um"
puts "  Target density: [expr {int($target_density * 100)}]%"
puts "  Utilization: [format "%.1f" $expected_util]%"
puts ""
puts "The floorplan is ready for CTS and routing."
puts ""

exit 0
