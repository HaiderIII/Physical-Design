#===============================================================================
# FLP_002 - Mixed-Signal Floorplan with Analog Macros
#===============================================================================
# This script creates a floorplan with two analog macro blocks.
#
# PROBLEM: The macros are placed but have NO HALOS defined!
#          Standard cells get placed right next to sensitive analog blocks.
#          This causes noise coupling issues.
#
# YOUR TASK: Add proper 10um halos around both analog macros.
#===============================================================================

puts "=============================================="
puts " FLP_002 - Mixed-Signal Floorplan"
puts "=============================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]
set dojo_root [file dirname [file dirname [file dirname $script_dir]]]

puts "Script directory: $script_dir"

# Sky130 PDK paths
set orfs_root "/home/faiz/OpenROAD-flow-scripts"
set sky130_lib_dir "$orfs_root/tools/OpenROAD/test/sky130hd"
set sky130_platform "$orfs_root/flow/platforms/sky130hd"

set lib_file "$sky130_lib_dir/sky130_fd_sc_hd__tt_025C_1v80.lib"
set tech_lef "$sky130_platform/lef/sky130_fd_sc_hd.tlef"
set cell_lef "$sky130_platform/lef/sky130_fd_sc_hd_merged.lef"

# Design files
set design_file "$script_dir/resources/mixed_signal.v"
set macro_lef "$script_dir/resources/analog_macro.lef"
set macro_lib "$script_dir/resources/analog_macro.lib"
set sdc_file "$script_dir/resources/constraints.sdc"

# Results directory
set results_dir "$script_dir/results"
file mkdir $results_dir

#-------------------------------------------------------------------------------
# Step 2: Load PDK and Macro libraries
#-------------------------------------------------------------------------------

puts ""
puts "Loading PDK..."
read_liberty $lib_file
read_liberty $macro_lib
read_lef $tech_lef
read_lef $cell_lef
read_lef $macro_lef
puts "PDK and macro libraries loaded."

#-------------------------------------------------------------------------------
# Step 3: Load design
#-------------------------------------------------------------------------------

puts ""
puts "Loading design..."
read_verilog $design_file
link_design mixed_signal_top
puts "Design linked."

#-------------------------------------------------------------------------------
# Step 4: Read constraints
#-------------------------------------------------------------------------------

puts ""
puts "Loading constraints..."
read_sdc $sdc_file

#-------------------------------------------------------------------------------
# Step 5: Initialize Floorplan
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Creating Floorplan"
puts "=============================================="

# Die size: 200um x 200um (plenty of room for 2 macros + standard cells)
set die_area {0 0 200 200}
set core_area {10 10 190 190}

initialize_floorplan -die_area $die_area \
                     -core_area $core_area \
                     -site unithd

make_tracks

#-------------------------------------------------------------------------------
# Step 6: Place Macros using ODB
#-------------------------------------------------------------------------------

puts ""
puts "Placing analog macros..."

# Get the database block
set block [ord::get_db_block]

# Place ANALOG_BLOCK_0 at (20, 20) in microns
set inst0 [$block findInst "ANALOG_BLOCK_0"]
if {$inst0 != "NULL"} {
    # Convert microns to DBU (1um = 1000 DBU for Sky130)
    $inst0 setLocation [expr {20 * 1000}] [expr {20 * 1000}]
    $inst0 setPlacementStatus FIRM
    puts "  ANALOG_BLOCK_0 placed at (20, 20) um"
} else {
    puts "  WARNING: ANALOG_BLOCK_0 not found in design"
}

# Place ANALOG_BLOCK_1 at (130, 140) in microns
set inst1 [$block findInst "ANALOG_BLOCK_1"]
if {$inst1 != "NULL"} {
    $inst1 setLocation [expr {130 * 1000}] [expr {140 * 1000}]
    $inst1 setPlacementStatus FIRM
    puts "  ANALOG_BLOCK_1 placed at (130, 140) um"
} else {
    puts "  WARNING: ANALOG_BLOCK_1 not found in design"
}

puts "Macros placed."

#-------------------------------------------------------------------------------
# Step 7: Add Halos - THIS IS WHERE THE BUG IS!
#-------------------------------------------------------------------------------

# TODO: Add halos around macros!
#
# BUG: No halos are defined! Standard cells will be placed right next
#      to the analog macros, causing noise coupling issues.
#
# The analog team requires 10um clearance on ALL sides of each macro.
#
# Hint: Use create_blockage to define placement blockage regions around macros
#
# Macro dimensions: 40um x 30um each
# ANALOG_BLOCK_0 is at (20, 20) -> occupies (20,20) to (60,50)
# ANALOG_BLOCK_1 is at (130, 140) -> occupies (130,140) to (170,170)
#
# With 10um halos:
#   ANALOG_BLOCK_0 halo region: (10, 10) to (70, 60)
#   ANALOG_BLOCK_1 halo region: (120, 130) to (180, 180)
#
# Command syntax:
#   create_blockage -region {x1 y1 x2 y2}

# TODO: Uncomment and complete the lines below to add 10um halos
# Hint: Calculate the halo region coordinates based on macro position + size + 10um margin

create_blockage -region {10 10 70 60}  ;# Halo for ANALOG_BLOCK_0
create_blockage -region {120 130 180 180}  ;# Halo for ANALOG_BLOCK_1

#-------------------------------------------------------------------------------
# Step 8: Place IO pins
#-------------------------------------------------------------------------------

puts ""
puts "Placing IO pins..."
place_pins -hor_layers met3 -ver_layers met2

#-------------------------------------------------------------------------------
# Step 9: Global Placement
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Placement"
puts "=============================================="

puts "Running global placement..."
global_placement -density 0.5

puts "Running detailed placement..."
detailed_placement

#-------------------------------------------------------------------------------
# Step 10: Verify Halo Compliance
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Halo Compliance Check"
puts "=============================================="

# Check if any cells are placed within halo regions
set halo_size 10.0

# ANALOG_BLOCK_0: macro at (20,20) size (40,30)
# Halo region should be: (10,10) to (70,60)
set macro0_x1 20.0
set macro0_y1 20.0
set macro0_x2 60.0
set macro0_y2 50.0
set macro0_halo_x1 [expr {$macro0_x1 - $halo_size}]
set macro0_halo_y1 [expr {$macro0_y1 - $halo_size}]
set macro0_halo_x2 [expr {$macro0_x2 + $halo_size}]
set macro0_halo_y2 [expr {$macro0_y2 + $halo_size}]

# ANALOG_BLOCK_1: macro at (130,140) size (40,30)
# Halo region should be: (120,130) to (180,180)
set macro1_x1 130.0
set macro1_y1 140.0
set macro1_x2 170.0
set macro1_y2 170.0
set macro1_halo_x1 [expr {$macro1_x1 - $halo_size}]
set macro1_halo_y1 [expr {$macro1_y1 - $halo_size}]
set macro1_halo_x2 [expr {$macro1_x2 + $halo_size}]
set macro1_halo_y2 [expr {$macro1_y2 + $halo_size}]

set violations 0
set violation_examples {}

foreach inst [$block getInsts] {
    set inst_name [$inst getName]

    # Skip the macros themselves
    if {[string match "ANALOG_BLOCK*" $inst_name]} {
        continue
    }

    # Get cell bounding box
    set bbox [$inst getBBox]
    set cell_x1 [expr {[$bbox xMin] / 1000.0}]
    set cell_y1 [expr {[$bbox yMin] / 1000.0}]
    set cell_x2 [expr {[$bbox xMax] / 1000.0}]
    set cell_y2 [expr {[$bbox yMax] / 1000.0}]

    # Check overlap with ANALOG_BLOCK_0 halo (excluding macro itself)
    if {$cell_x2 > $macro0_halo_x1 && $cell_x1 < $macro0_halo_x2 &&
        $cell_y2 > $macro0_halo_y1 && $cell_y1 < $macro0_halo_y2} {
        # Make sure it's not inside the macro itself
        if {!($cell_x1 >= $macro0_x1 && $cell_x2 <= $macro0_x2 &&
              $cell_y1 >= $macro0_y1 && $cell_y2 <= $macro0_y2)} {
            incr violations
            if {[llength $violation_examples] < 3} {
                lappend violation_examples "  $inst_name near ANALOG_BLOCK_0 at ([format %.1f $cell_x1], [format %.1f $cell_y1])"
            }
        }
    }

    # Check overlap with ANALOG_BLOCK_1 halo (excluding macro itself)
    if {$cell_x2 > $macro1_halo_x1 && $cell_x1 < $macro1_halo_x2 &&
        $cell_y2 > $macro1_halo_y1 && $cell_y1 < $macro1_halo_y2} {
        # Make sure it's not inside the macro itself
        if {!($cell_x1 >= $macro1_x1 && $cell_x2 <= $macro1_x2 &&
              $cell_y1 >= $macro1_y1 && $cell_y2 <= $macro1_y2)} {
            incr violations
            if {[llength $violation_examples] < 3} {
                lappend violation_examples "  $inst_name near ANALOG_BLOCK_1 at ([format %.1f $cell_x1], [format %.1f $cell_y1])"
            }
        }
    }
}

puts ""
if {$violations > 0} {
    puts "HALO CHECK: FAILED - $violations cells in halo regions!"
    puts ""
    puts "Example violations:"
    foreach v $violation_examples {
        puts $v
    }
    puts ""
    puts "The analog team will reject this floorplan."
    puts ""
    puts ">>> FIX: Add set_placement_padding commands after macro placement <<<"
} else {
    puts "HALO CHECK: PASSED - No cells in halo regions!"
    puts "The analog team approves this floorplan."
}

#-------------------------------------------------------------------------------
# Step 11: Write outputs
#-------------------------------------------------------------------------------

puts ""
puts "Writing output files..."

set output_def "$results_dir/mixed_signal_floorplan.def"
write_def $output_def
puts "  DEF: $output_def"

#-------------------------------------------------------------------------------
# Done!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
if {$violations > 0} {
    puts " FLOORPLAN NEEDS FIXES!"
} else {
    puts " FLOORPLAN COMPLETE!"
}
puts "=============================================="
puts ""

exit 0
