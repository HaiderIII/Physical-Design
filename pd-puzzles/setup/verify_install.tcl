#===============================================================================
# PD-Puzzles Installation Verification Script
#===============================================================================
# Run with: openroad verify_install.tcl
#
# This script verifies that all PDKs are correctly installed and accessible
# from OpenROAD.
#===============================================================================

puts ""
puts "╔════════════════════════════════════════════════════════════════╗"
puts "║  🥋 PD-Puzzles Installation Verification                      ║"
puts "╚════════════════════════════════════════════════════════════════╝"
puts ""

#-------------------------------------------------------------------------------
# Configuration
#-------------------------------------------------------------------------------
# Get the directory where this script is located
set script_dir [file dirname [file normalize [info script]]]
set dojo_root [file dirname $script_dir]
set pdk_dir [file join $dojo_root "common" "pdks"]

puts "PD-Puzzles root: $dojo_root"
puts "PDK directory: $pdk_dir"
puts ""

#-------------------------------------------------------------------------------
# Helper procedures
#-------------------------------------------------------------------------------
proc check_file_exists {filepath description} {
    if {[file exists $filepath]} {
        puts "  ✓ $description"
        return 1
    } else {
        puts "  ✗ $description - NOT FOUND"
        return 0
    }
}

proc verify_liberty {lib_file pdk_name} {
    puts "  → Testing Liberty file loading..."
    if {[catch {read_liberty $lib_file} err]} {
        puts "  ✗ Failed to read Liberty: $err"
        return 0
    }
    puts "  ✓ Liberty file loaded successfully"
    return 1
}

proc verify_lef {lef_files pdk_name} {
    puts "  → Testing LEF file loading..."
    foreach lef $lef_files {
        if {[catch {read_lef $lef} err]} {
            puts "  ✗ Failed to read LEF $lef: $err"
            return 0
        }
    }
    puts "  ✓ LEF files loaded successfully"
    return 1
}

#-------------------------------------------------------------------------------
# Verification Results
#-------------------------------------------------------------------------------
set results {}
set total_pdks 3
set passed_pdks 0

#-------------------------------------------------------------------------------
# Verify Nangate45
#-------------------------------------------------------------------------------
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "Checking Nangate45 (Beginner PDK)..."
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

set ng45_dir [file join $pdk_dir "nangate45"]
set ng45_ok 1

if {[file isdirectory $ng45_dir]} {
    puts "  ✓ Directory exists: $ng45_dir"

    # Check key files (note: ORFS uses .macro.lef instead of .lef)
    set ng45_lib [file join $ng45_dir "lib" "NangateOpenCellLibrary_typical.lib"]
    set ng45_lef [file join $ng45_dir "lef" "NangateOpenCellLibrary.macro.mod.lef"]
    set ng45_tlef [file join $ng45_dir "lef" "NangateOpenCellLibrary.tech.lef"]

    if {![check_file_exists $ng45_lib "Liberty file (typical)"]} {set ng45_ok 0}
    if {![check_file_exists $ng45_lef "Library LEF (macro.mod)"]} {set ng45_ok 0}
    if {![check_file_exists $ng45_tlef "Tech LEF"]} {set ng45_ok 0}

    # Try to load files
    if {$ng45_ok} {
        # Clear any previous design state
        if {[catch {
            read_lef $ng45_tlef
            read_lef $ng45_lef
            read_liberty $ng45_lib
        } err]} {
            puts "  ✗ Failed to load PDK files: $err"
            set ng45_ok 0
        } else {
            puts "  ✓ PDK files load correctly in OpenROAD"
        }
    }
} else {
    puts "  ✗ Directory NOT FOUND: $ng45_dir"
    set ng45_ok 0
}

if {$ng45_ok} {
    incr passed_pdks
    puts "\n  ✅ Nangate45: PASS\n"
} else {
    puts "\n  ❌ Nangate45: FAIL\n"
}

#-------------------------------------------------------------------------------
# Verify Sky130
#-------------------------------------------------------------------------------
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "Checking Sky130 HD (Intermediate PDK)..."
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

set sky130_dir [file join $pdk_dir "sky130hd"]
set sky130_ok 1

if {[file isdirectory $sky130_dir]} {
    puts "  ✓ Directory exists: $sky130_dir"

    # Check key files - Sky130 has different naming conventions
    set sky130_lib [file join $sky130_dir "lib" "sky130_fd_sc_hd__tt_025C_1v80.lib"]
    set sky130_tlef [file join $sky130_dir "lef" "sky130_fd_sc_hd.tlef"]
    set sky130_lef [file join $sky130_dir "lef" "sky130_fd_sc_hd_merged.lef"]

    if {![check_file_exists $sky130_lib "Liberty file (typical)"]} {set sky130_ok 0}
    if {![check_file_exists $sky130_tlef "Tech LEF"]} {set sky130_ok 0}
    if {![check_file_exists $sky130_lef "Library LEF (merged)"]} {set sky130_ok 0}

    # Note: We don't try to load Sky130 in the same session as Nangate45
    # because they have conflicting technology definitions
    if {$sky130_ok} {
        puts "  ✓ Key files present (not loaded to avoid tech conflict)"
    }
} else {
    puts "  ✗ Directory NOT FOUND: $sky130_dir"
    set sky130_ok 0
}

if {$sky130_ok} {
    incr passed_pdks
    puts "\n  ✅ Sky130: PASS\n"
} else {
    puts "\n  ❌ Sky130: FAIL\n"
}

#-------------------------------------------------------------------------------
# Verify ASAP7
#-------------------------------------------------------------------------------
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
puts "Checking ASAP7 (Advanced PDK)..."
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

set asap7_dir [file join $pdk_dir "asap7"]
set asap7_ok 1

if {[file isdirectory $asap7_dir]} {
    puts "  ✓ Directory exists: $asap7_dir"

    # ASAP7 has multiple lib/lef variants - check for any
    set asap7_lib_dir [file join $asap7_dir "lib"]
    set asap7_lef_dir [file join $asap7_dir "lef"]

    if {[file isdirectory $asap7_lib_dir]} {
        set lib_files [glob -nocomplain [file join $asap7_lib_dir "*.lib"]]
        if {[llength $lib_files] > 0} {
            puts "  ✓ Liberty files found: [llength $lib_files] files"
        } else {
            puts "  ✗ No Liberty files found in lib/"
            set asap7_ok 0
        }
    } else {
        puts "  ✗ lib/ directory not found"
        set asap7_ok 0
    }

    if {[file isdirectory $asap7_lef_dir]} {
        set lef_files [glob -nocomplain [file join $asap7_lef_dir "*.lef"]]
        if {[llength $lef_files] > 0} {
            puts "  ✓ LEF files found: [llength $lef_files] files"
        } else {
            puts "  ✗ No LEF files found in lef/"
            set asap7_ok 0
        }
    } else {
        puts "  ✗ lef/ directory not found"
        set asap7_ok 0
    }

    if {$asap7_ok} {
        puts "  ✓ Key files present (not loaded to avoid tech conflict)"
    }
} else {
    puts "  ✗ Directory NOT FOUND: $asap7_dir"
    set asap7_ok 0
}

if {$asap7_ok} {
    incr passed_pdks
    puts "\n  ✅ ASAP7: PASS\n"
} else {
    puts "\n  ❌ ASAP7: FAIL\n"
}

#-------------------------------------------------------------------------------
# Final Summary
#-------------------------------------------------------------------------------
puts "╔════════════════════════════════════════════════════════════════╗"
puts "║  📋 Verification Summary                                       ║"
puts "╚════════════════════════════════════════════════════════════════╝"
puts ""
puts "  PDKs verified: $passed_pdks / $total_pdks"
puts ""

if {$passed_pdks == $total_pdks} {
    puts "  🎉 All PDKs installed correctly!"
    puts "  You're ready to start the puzzles!"
    puts ""
    puts "  Next step: cd puzzles/01_synthesis/syn_001"
} elseif {$passed_pdks > 0} {
    puts "  ⚠️  Some PDKs are missing or incomplete."
    puts "  Run: ./setup/install_pdks.sh --all"
} else {
    puts "  ❌ No PDKs installed."
    puts "  Run: ./setup/install_pdks.sh"
}

puts ""
puts "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

exit 0
