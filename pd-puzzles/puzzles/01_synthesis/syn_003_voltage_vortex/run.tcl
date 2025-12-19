#===============================================================================
# SYN_003 - Multi-Vt Power Analysis
#===============================================================================
# This script analyzes power consumption of an ALU design using ASAP7 7nm PDK.
#
# PROBLEM: The script loads the WRONG Vt library (SLVT instead of RVT)!
#          The netlist uses RVT cells (_R suffix), but we're loading SLVT libs.
#          This causes cells not to be found AND gives wrong power estimates.
#
# YOUR TASK: Fix the library loading to match the netlist's Vt type.
#===============================================================================

puts "=============================================="
puts " SYN_003 - ALU Multi-Vt Power Analysis"
puts "=============================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]

puts "Script directory: $script_dir"

# ASAP7 PDK paths
set platform_dir "$::env(HOME)/OpenROAD-flow-scripts/flow/platforms/asap7"

# Design files
set design_file "$script_dir/resources/alu_netlist.v"
set sdc_file "$script_dir/resources/constraints.sdc"

#-------------------------------------------------------------------------------
# Step 2: Load Liberty files
#-------------------------------------------------------------------------------
#
# BUG: Loading SLVT (Super Low-Vt) libraries instead of RVT!
#
# The netlist uses RVT cells (suffix _R), for example:
#   - AND2x2_ASAP7_75t_R
#   - DFFHQNx1_ASAP7_75t_R
#
# But we're loading SLVT libraries (suffix _SL), which don't contain
# the _R cells! This will cause "cell not found" errors.
#
# Available Vt types in ASAP7:
#   - "R"  = RVT (Regular Vt) - Balanced speed/power
#   - "L"  = LVT (Low Vt) - Faster, more leakage
#   - "SL" = SLVT (Super Low Vt) - Fastest, highest leakage
#
# TODO: Change vt_type to match the netlist cells!
#-------------------------------------------------------------------------------

puts ""
puts "Loading ASAP7 Liberty files..."

# BUG: Wrong Vt type! Netlist uses RVT (_R) but we load SLVT (_SL)
set vt_type "SL"  ;# <-- FIX THIS! Should match netlist cell suffix

puts "  Vt type selected: ${vt_type}VT"

# Load liberty files for the selected Vt
set lib_files [glob -nocomplain $platform_dir/lib/NLDM/asap7sc7p5t_*_${vt_type}VT_TT_nldm_*.lib.gz]

if {[llength $lib_files] == 0} {
    puts "ERROR: No liberty files found for ${vt_type}VT!"
    exit 1
}

foreach lib_file $lib_files {
    puts "  Reading: [file tail $lib_file]"
    read_liberty $lib_file
}

# Also read the sequential library
set seq_lib "$platform_dir/lib/NLDM/asap7sc7p5t_SEQ_${vt_type}VT_TT_nldm_220123.lib"
if {[file exists $seq_lib]} {
    puts "  Reading: [file tail $seq_lib]"
    read_liberty $seq_lib
}

puts "Liberty files loaded."

#-------------------------------------------------------------------------------
# Step 3: Load LEF files
#-------------------------------------------------------------------------------

puts ""
puts "Loading LEF files..."

read_lef $platform_dir/lef/asap7_tech_1x_201209.lef
read_lef $platform_dir/lef/asap7sc7p5t_28_${vt_type}_1x_220121a.lef

puts "LEF files loaded."

#-------------------------------------------------------------------------------
# Step 4: Load design
#-------------------------------------------------------------------------------

puts ""
puts "Loading design..."

read_verilog $design_file
link_design alu_8bit

puts "Design linked: alu_8bit"

#-------------------------------------------------------------------------------
# Step 5: Load constraints
#-------------------------------------------------------------------------------

puts ""
puts "Loading timing constraints..."
read_sdc $sdc_file
puts "Constraints loaded - Target: 500 MHz (2ns period)"

#-------------------------------------------------------------------------------
# Step 6: Analyze cells and power
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Design Analysis"
puts "=============================================="

# Count expected cells by parsing the netlist
# This works even when cells become black boxes
set fp [open $design_file r]
set netlist_content [read $fp]
close $fp

# Count cell instances (lines with ASAP7 cells)
set expected_cells 0
set netlist_vt ""
foreach line [split $netlist_content "\n"] {
    if {[regexp {ASAP7_75t_(\w+)\s+\w+\s*\(} $line match suffix]} {
        incr expected_cells
        if {$netlist_vt == ""} {
            set netlist_vt $suffix
        }
    }
}

# Check if library matches netlist
set lib_matches_netlist [expr {$vt_type eq $netlist_vt}]

# Count cells found in design
set all_cells [get_cells -hierarchical *]
set found_cells [llength $all_cells]

puts ""
puts "Cell Statistics:"
puts "  Netlist cells expected: $expected_cells"
puts "  Netlist Vt type: ${netlist_vt}VT (cells end with _${netlist_vt})"
puts "  Library Vt loaded: ${vt_type}VT"
puts "  Cells found in library: $found_cells"

if {!$lib_matches_netlist} {
    puts ""
    puts "  >>> MISMATCH DETECTED! <<<"
    puts "  Netlist uses _${netlist_vt} cells but loaded _${vt_type} libraries!"
}

#-------------------------------------------------------------------------------
# Step 7: Power estimation based on Vt type
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Power Analysis"
puts "=============================================="

# Leakage power varies significantly with Vt type
# These are approximate relative values for ASAP7
switch $vt_type {
    "SL" {
        set leakage_factor 8.0
        set vt_description "Super Low-Vt (SLVT) - Fastest, highest leakage"
    }
    "L" {
        set leakage_factor 3.0
        set vt_description "Low-Vt (LVT) - Fast, moderate leakage"
    }
    "R" {
        set leakage_factor 1.0
        set vt_description "Regular-Vt (RVT) - Balanced speed/power"
    }
    default {
        set leakage_factor 1.0
        set vt_description "Unknown Vt"
    }
}

# Base leakage per cell (arbitrary units for demonstration)
set base_leakage 2.5
set total_leakage [expr {$expected_cells * $base_leakage * $leakage_factor}]
set leakage_budget 100.0

puts ""
puts "Vt Characteristics:"
puts "  Type: $vt_description"
puts "  Leakage factor: ${leakage_factor}x (relative to RVT)"
puts ""
puts "Leakage Power Estimate:"
puts "  Base leakage/cell: $base_leakage uW"
puts "  Vt multiplier: ${leakage_factor}x"
puts "  Total cells: $expected_cells"
puts "  Estimated leakage: [format "%.1f" $total_leakage] uW"
puts "  Power budget: $leakage_budget uW"

#-------------------------------------------------------------------------------
# Step 8: Timing Analysis
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Timing Analysis"
puts "=============================================="

report_checks -path_delay max -format summary

#-------------------------------------------------------------------------------
# Step 9: Final Verdict
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Final Verdict"
puts "=============================================="

# Check for cell mismatch (main bug indicator)
if {!$lib_matches_netlist} {
    puts ""
    puts ">>> SYNTHESIS FAILED: Library mismatch! <<<"
    puts ""
    puts "  Netlist uses ${netlist_vt}VT cells (suffix _${netlist_vt})"
    puts "  But you loaded ${vt_type}VT libraries (suffix _${vt_type})"
    puts ""
    puts "  $expected_cells cells could not be found in the libraries!"
    puts ""
    puts "  HINT: Look at the vt_type variable in run.tcl (around line 57)"
    puts "        Change it to match the netlist cell suffix."
    puts ""
    puts "=============================================="
    exit 1
}

# Check power budget
if {$total_leakage > $leakage_budget} {
    set excess [expr {int(($total_leakage / $leakage_budget - 1) * 100)}]
    puts ""
    puts ">>> SYNTHESIS FAILED: Power budget exceeded! <<<"
    puts ""
    puts "  Leakage: [format "%.1f" $total_leakage] uW (budget: $leakage_budget uW)"
    puts "  Excess: ${excess}%"
    puts ""
    puts "  Using ${vt_type}VT cells causes excessive leakage."
    puts "  For a 500MHz design, consider using RVT instead."
    puts ""
    puts "=============================================="
    exit 1
}

puts ""
puts ">>> SYNTHESIS PASSED! <<<"
puts ""
puts "  All cells found in library: OK"
puts "  Leakage within budget: [format "%.1f" $total_leakage] uW < $leakage_budget uW"
puts "  Vt selection: ${vt_type}VT is appropriate for this design"
puts ""
puts "=============================================="

exit 0
