#===============================================================================
# SYN_004 - Detecting Forbidden Cells in Netlist
#===============================================================================
# This script checks a netlist for forbidden cells that shouldn't be used.
#
# PROBLEM: The check is disabled, allowing forbidden cells to pass through!
#
# YOUR TASK: Enable the forbidden cell check to catch DRC/yield issues.
#===============================================================================

puts "=============================================="
puts " SYN_004 - Forbidden Cells Check (Sky130HD)"
puts "=============================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]
set platform_dir "$::env(HOME)/OpenROAD-flow-scripts/flow/platforms/sky130hd"

set design_file "$script_dir/resources/fsm.v"
set sdc_file "$script_dir/resources/constraints.sdc"

set results_dir "$script_dir/results"
file mkdir $results_dir

#-------------------------------------------------------------------------------
# Step 2: Load Sky130HD library
#-------------------------------------------------------------------------------

puts ""
puts "Loading Sky130HD library..."

set lib_file "$platform_dir/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
read_liberty $lib_file

read_lef $platform_dir/lef/sky130_fd_sc_hd.tlef
read_lef $platform_dir/lef/sky130_fd_sc_hd_merged.lef

puts "Library loaded."

#-------------------------------------------------------------------------------
# Step 3: Load netlist
#-------------------------------------------------------------------------------

puts ""
puts "Loading netlist..."
read_verilog $design_file
link_design fsm
puts "Design linked."

#-------------------------------------------------------------------------------
# Step 4: Read constraints
#-------------------------------------------------------------------------------

puts ""
puts "Reading SDC constraints..."
read_sdc $sdc_file
puts "Target: 100 MHz"

#===============================================================================
# BUG SECTION: Forbidden cell check is DISABLED!
#
# In production, we MUST check for cells that should never be used:
# - dlygate*  : Delay cells - high variability, yield issues
# - clkdlybuf*: Clock delay buffers - CTS only, not for logic
# - dlymetal* : Metal delay cells - analog only
#
# If check is disabled, these cells slip through to manufacturing!
#===============================================================================

# TODO: Fix the forbidden cell check!
# Currently: Check is disabled - forbidden cells are NOT caught!

set enable_forbidden_check false    ;# <-- BUG! Should be true

puts ""
puts "=============================================="
puts " Forbidden Cell Verification"
puts "=============================================="

if {!$enable_forbidden_check} {
    puts ""
    puts ">>> WARNING: Forbidden cell check is DISABLED! <<<"
    puts ""
    puts "Skipping verification..."
    puts "Dangerous cells may be present in the netlist!"
    puts ""
    puts "FIX: Set enable_forbidden_check = true"
    set found_forbidden 0
} else {
    puts ""
    puts "Running forbidden cell check..."

    # Define forbidden cell patterns
    set forbidden_patterns {dlygate clkdlybuf dlymetal}
    set found_forbidden 0
    set forbidden_list {}

    # Check all instances
    foreach inst [get_cells *] {
        set cell_name [get_property $inst ref_name]
        foreach pattern $forbidden_patterns {
            if {[string match "*$pattern*" $cell_name]} {
                lappend forbidden_list "[get_property $inst full_name] ($cell_name)"
                set found_forbidden 1
            }
        }
    }

    if {$found_forbidden} {
        puts ""
        puts ">>> FORBIDDEN CELLS DETECTED! <<<"
        puts ""
        puts "Found [llength $forbidden_list] forbidden cell(s):"
        foreach item $forbidden_list {
            puts "  - $item"
        }
        puts ""
        puts "These cells cause:"
        puts "  - DRC violations in signoff"
        puts "  - Yield loss in manufacturing (10-20%)"
        puts "  - Unpredictable timing variation"
        puts ""
        puts "ACTION REQUIRED:"
        puts "  1. Return netlist to synthesis team"
        puts "  2. Add dont_use constraints for forbidden cells"
        puts "  3. Re-synthesize the design"
    } else {
        puts ""
        puts "No forbidden cells found. Design is clean!"
    }
}

#-------------------------------------------------------------------------------
# Step 5: Report statistics
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Design Statistics"
puts "=============================================="

set cell_count [llength [get_cells *]]
puts "Total cells: $cell_count"

#-------------------------------------------------------------------------------
# Step 6: Write outputs
#-------------------------------------------------------------------------------

puts ""
puts "Writing outputs..."
write_verilog $results_dir/fsm_checked.v
puts "  Netlist: $results_dir/fsm_checked.v"

#-------------------------------------------------------------------------------
# Final Result
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
if {!$enable_forbidden_check} {
    puts " PUZZLE FAILED - Verification disabled!"
    puts "=============================================="
    puts ""
    puts "The check must be enabled to catch forbidden cells."
    puts "Without verification, dangerous cells slip through!"
    exit 1
} else {
    puts " PUZZLE PASSED - Verification enabled!"
    puts "=============================================="
    puts ""
    if {$found_forbidden} {
        puts "The check correctly detected forbidden cells."
        puts "In production: return netlist to synthesis for fixing."
    } else {
        puts "No forbidden cells found. Design is clean!"
    }
    exit 0
}
