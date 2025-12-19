#===============================================================================
# PLC_003 - Placement Padding for Dense Sequential Design
#===============================================================================
# This script runs placement on a shift register design using ASAP7.
#
# PROBLEM: No cell padding is applied!
#          At advanced nodes (7nm), cells placed too close together cause
#          routing congestion and DRC violations. Cell padding adds spacing
#          between cells to ensure routability.
#
# YOUR TASK: Add proper cell padding for ASAP7 sequential cells.
#===============================================================================

puts "=============================================="
puts " PLC_003 - Placement Padding (ASAP7)"
puts "=============================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]

puts "Script directory: $script_dir"

# ASAP7 PDK paths
set platform_dir "$::env(HOME)/OpenROAD-flow-scripts/flow/platforms/asap7"

# Design files
set design_file "$script_dir/resources/shift_register.v"
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
link_design shift_register
puts "Design linked."

#-------------------------------------------------------------------------------
# Step 4: Read constraints
#-------------------------------------------------------------------------------

puts ""
puts "Loading timing constraints..."
read_sdc $sdc_file
puts "Constraints loaded - Target: 1.5 GHz"

#-------------------------------------------------------------------------------
# Step 5: Create Floorplan
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Creating Floorplan"
puts "=============================================="

# Die and core area
set die_area  {0 0 15 15}
set core_area {1 1 14 14}

initialize_floorplan -die_area $die_area \
                     -core_area $core_area \
                     -site asap7sc7p5t

source $platform_dir/openRoad/make_tracks.tcl

# Set wire RC
source $platform_dir/setRC.tcl

# Place IO pins
place_pins -hor_layers M4 -ver_layers M5

puts "Floorplan created: 15x15 um die"

#-------------------------------------------------------------------------------
# Step 6: Cell Padding - THIS IS WHERE THE BUG IS!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Cell Padding Configuration"
puts "=============================================="

# BUG: No cell padding is set!
#
# At 7nm (ASAP7), cells have very tight metal pitches:
# - M1 pitch: 36nm
# - M2 pitch: 36nm
# - Cells need extra spacing for local routing
#
# Without padding:
# - Cells are placed edge-to-edge
# - No room for local interconnect routing
# - Creates pin access problems
# - Results in DRC violations during routing
#
# The set_placement_padding command adds spacing:
# - -global: applies to all cells
# - -masters: applies to specific cell types
# - -left/-right: sites to add on each side

# TODO: Fix the padding values!
# Hint: Sequential cells (DFF*) need more padding than combinational cells
# Typical ASAP7 values: 2 sites for combinational, 4 sites for sequential

set padding_global 0      ;# <-- BUG! Should be at least 1-2 sites
set padding_sequential 0  ;# <-- BUG! Should be 3-4 sites for DFFs

puts "Current padding settings:"
puts "  Global padding:     $padding_global sites (left and right)"
puts "  Sequential padding: $padding_sequential sites (for DFF cells)"

if {$padding_global == 0 && $padding_sequential == 0} {
    puts ""
    puts ">>> WARNING: No cell padding configured! <<<"
    puts "    Cells will be placed edge-to-edge."
    puts "    This causes routing congestion at 7nm!"
}

# Apply global padding (affects all cells)
if {$padding_global > 0} {
    set_placement_padding -global -left $padding_global -right $padding_global
    puts "Applied global padding: $padding_global sites"
}

# Apply extra padding for sequential cells (they have more pins)
if {$padding_sequential > 0} {
    set_placement_padding -masters {DFFHQNx1_ASAP7_75t_R} \
                          -left $padding_sequential -right $padding_sequential
    puts "Applied sequential padding: $padding_sequential sites for DFFs"
}

#-------------------------------------------------------------------------------
# Step 7: Run Placement
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Placement"
puts "=============================================="

puts "Running global placement..."
global_placement -density 0.60 -timing_driven

puts "Running detailed placement..."
detailed_placement

#-------------------------------------------------------------------------------
# Step 8: Check Placement Quality
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Placement Quality Analysis"
puts "=============================================="

# Check placement legality
puts "Checking placement..."
if {[catch {check_placement -verbose} check_result]} {
    puts "Placement check failed: $check_result"
}

# Analyze cell spacing
puts ""
puts "Analyzing cell density and spacing..."

# Count cells
set num_cells [llength [get_cells -hierarchical *]]
puts "  Total cells placed: $num_cells"

# Estimate parasitics for congestion analysis
estimate_parasitics -placement

# Report congestion metrics
puts ""
puts "Congestion Analysis:"

# Check for routing congestion prediction
set core_width [expr {[lindex $core_area 2] - [lindex $core_area 0]}]
set core_height [expr {[lindex $core_area 3] - [lindex $core_area 1]}]
set core_total [expr {$core_width * $core_height}]

# Rough congestion estimate based on padding
set effective_density [expr {$num_cells * 0.054 / $core_total}]
set congestion_risk "LOW"

if {$padding_global == 0 && $padding_sequential == 0} {
    set congestion_risk "CRITICAL"
    puts "  >>> CRITICAL: No padding = guaranteed routing DRC violations! <<<"
} elseif {$padding_global < 2 || $padding_sequential < 3} {
    set congestion_risk "HIGH"
    puts "  >>> WARNING: Padding may be insufficient for 7nm routing <<<"
}

puts ""
puts "Summary:"
puts "  Core area:        [format "%.1f" $core_total] um^2"
puts "  Cell density:     [format "%.1f" [expr {$effective_density * 100}]]%"
puts "  Global padding:   $padding_global sites"
puts "  DFF padding:      $padding_sequential sites"
puts "  Congestion risk:  $congestion_risk"

#-------------------------------------------------------------------------------
# Step 9: Pass/Fail Determination
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="

if {$padding_global == 0 && $padding_sequential == 0} {
    puts " PLACEMENT FAILED - NO PADDING!"
    puts "=============================================="
    puts ""
    puts "At 7nm, cells MUST have padding for routability."
    puts ""
    puts "FIX: Set padding values in the Cell Padding section:"
    puts "  - padding_global >= 1 (1-2 sites for all cells)"
    puts "  - padding_sequential >= 3 (3-4 sites for DFFs)"
    puts ""
    puts "Typical ASAP7 padding:"
    puts "  set padding_global 2"
    puts "  set padding_sequential 4"
    puts ""
    exit 1
} elseif {$congestion_risk eq "HIGH"} {
    puts " PLACEMENT WARNING - INSUFFICIENT PADDING"
    puts "=============================================="
    puts ""
    puts "Padding may not be enough for clean routing."
    puts "Consider increasing values for better results."
    puts ""
    exit 1
}

#-------------------------------------------------------------------------------
# Step 10: Write outputs
#-------------------------------------------------------------------------------

puts ""
puts "Writing output files..."

set output_def "$results_dir/shift_register_placed.def"
write_def $output_def
puts "  DEF: $output_def"

#-------------------------------------------------------------------------------
# Success!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " PLACEMENT PASSED!"
puts "=============================================="
puts ""
puts "  Global padding:   $padding_global sites"
puts "  DFF padding:      $padding_sequential sites"
puts "  Congestion risk:  $congestion_risk"
puts ""
puts "Cells have proper spacing for 7nm routing."
puts ""

exit 0
