#===============================================================================
# FLP_004 - Placement Blockage Configuration
#===============================================================================
# This script creates a floorplan with a reserved area for future analog IP.
#
# PROBLEM: The placement blockage coordinates are WRONG!
#          The blockage extends OUTSIDE the core area, causing errors.
#
# YOUR TASK: Fix the blockage coordinates to fit within the core area.
#===============================================================================

puts "=============================================="
puts " FLP_004 - Blockage Blunder (Sky130HD)"
puts "=============================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]
set platform_dir "$::env(HOME)/OpenROAD-flow-scripts/flow/platforms/sky130hd"

set design_file "$script_dir/resources/datapath.v"
set sdc_file "$script_dir/resources/constraints.sdc"

set results_dir "$script_dir/results"
file mkdir $results_dir

#-------------------------------------------------------------------------------
# Step 2: Load Sky130HD PDK
#-------------------------------------------------------------------------------

puts ""
puts "Loading Sky130HD PDK..."

read_liberty $platform_dir/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_lef $platform_dir/lef/sky130_fd_sc_hd.tlef
read_lef $platform_dir/lef/sky130_fd_sc_hd_merged.lef

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
puts "Reading constraints..."
read_sdc $sdc_file
puts "Target: 100 MHz"

#-------------------------------------------------------------------------------
# Step 5: Create Floorplan
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Creating Floorplan"
puts "=============================================="

# Die and core areas
set die_llx 0
set die_lly 0
set die_urx 100
set die_ury 100

set core_llx 10
set core_lly 10
set core_urx 90
set core_ury 90

initialize_floorplan -die_area "$die_llx $die_lly $die_urx $die_ury" \
                     -core_area "$core_llx $core_lly $core_urx $core_ury" \
                     -site unithd

make_tracks

puts "Floorplan: 100x100 die, 80x80 core"
puts "Core area: ($core_llx, $core_lly) to ($core_urx, $core_ury)"

set blockage_llx 75    ;# Lower-left X
set blockage_lly 75    ;# Lower-left Y
set blockage_urx 95    ;# Upper-right X
set blockage_ury 95    ;# Upper-right Y

puts ""
puts "=============================================="
puts " Creating Placement Blockage"
puts "=============================================="

puts ""
puts "Blockage coordinates: ($blockage_llx, $blockage_lly) to ($blockage_urx, $blockage_ury)"
puts "Core area:            ($core_llx, $core_lly) to ($core_urx, $core_ury)"

# Validate blockage coordinates
set blockage_valid 1
set error_msg ""

if {$blockage_llx < $core_llx} {
    set blockage_valid 0
    set error_msg "blockage_llx ($blockage_llx) < core_llx ($core_llx)"
}
if {$blockage_lly < $core_lly} {
    set blockage_valid 0
    set error_msg "blockage_lly ($blockage_lly) < core_lly ($core_lly)"
}
if {$blockage_urx > $core_urx} {
    set blockage_valid 0
    set error_msg "blockage_urx ($blockage_urx) > core_urx ($core_urx)"
}
if {$blockage_ury > $core_ury} {
    set blockage_valid 0
    set error_msg "blockage_ury ($blockage_ury) > core_ury ($core_ury)"
}

if {!$blockage_valid} {
    puts ""
    puts ">>> ERROR: Blockage extends OUTSIDE core area! <<<"
    puts "    $error_msg"
    puts ""
    puts "Blockage must be within core boundaries:"
    puts "    X: $core_llx to $core_urx"
    puts "    Y: $core_lly to $core_ury"
    puts ""
    puts "FIX: Adjust blockage_urx and blockage_ury to fit within core."
} else {
    puts ""
    puts "Blockage coordinates are valid."

    # Create the placement blockage
    create_blockage -region "$blockage_llx $blockage_lly $blockage_urx $blockage_ury"

    puts "Placement blockage created for analog IP reservation."
}

#-------------------------------------------------------------------------------
# Step 6: Place pins
#-------------------------------------------------------------------------------

puts ""
puts "Placing I/O pins..."
place_pins -hor_layers met3 -ver_layers met2

#-------------------------------------------------------------------------------
# Step 7: Run placement (if blockage valid)
#-------------------------------------------------------------------------------

if {$blockage_valid} {
    puts ""
    puts "=============================================="
    puts " Running Placement"
    puts "=============================================="

    set_wire_rc -layer met2

    global_placement -density 0.60
    detailed_placement

    puts "Placement complete."

    # Check if any cells placed in blockage area
    puts ""
    puts "Verifying blockage is respected..."
}

#-------------------------------------------------------------------------------
# Step 8: Write outputs
#-------------------------------------------------------------------------------

puts ""
puts "Writing outputs..."
write_def $results_dir/datapath_floorplan.def
puts "  DEF: $results_dir/datapath_floorplan.def"

#-------------------------------------------------------------------------------
# Final Result
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
if {$blockage_valid} {
    puts " PUZZLE PASSED - Blockage correctly configured!"
    puts "=============================================="
    puts ""
    puts "  Blockage area reserved for analog IP."
    puts "  No cells placed in blocked region."
    exit 0
} else {
    puts " PUZZLE FAILED - Invalid blockage coordinates!"
    puts "=============================================="
    puts ""
    puts "Fix the blockage to fit within the core area."
    exit 1
}
