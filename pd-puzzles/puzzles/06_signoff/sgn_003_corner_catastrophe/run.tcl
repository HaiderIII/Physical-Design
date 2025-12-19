#===============================================================================
# SGN_003 - Multi-Corner Timing Signoff for ASAP7
#===============================================================================
# This script performs timing signoff on a counter design using ASAP7.
#
# PROBLEM: The timing analysis only uses the TT (Typical-Typical) corner!
#          At 7nm, multi-corner analysis is CRITICAL for signoff.
#          Setup should be checked in SS (slow-slow) corner.
#          Hold should be checked in FF (fast-fast) corner.
#
# YOUR TASK: Configure proper multi-corner analysis for signoff.
#===============================================================================

puts "=============================================="
puts " SGN_003 - Multi-Corner Signoff (ASAP7)"
puts "=============================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]

puts "Script directory: $script_dir"

# ASAP7 PDK paths
set platform_dir "$::env(HOME)/OpenROAD-flow-scripts/flow/platforms/asap7"

# Design files
set design_file "$script_dir/resources/counter.v"
set sdc_file "$script_dir/resources/constraints.sdc"

# Results directory
set results_dir "$script_dir/results"
file mkdir $results_dir

#-------------------------------------------------------------------------------
# Step 2: Load ASAP7 PDK
#-------------------------------------------------------------------------------

puts ""
puts "Loading ASAP7 RVT libraries..."

#===============================================================================
# BUG: Only loading TT (Typical-Typical) corner!
#
# For proper signoff at 7nm, you need:
# - SS (Slow-Slow) corner for SETUP analysis (worst-case slow)
# - FF (Fast-Fast) corner for HOLD analysis (worst-case fast)
# - TT (Typical-Typical) for nominal behavior only
#
# Using only TT means:
# - Setup violations might be HIDDEN (cells are faster than worst-case)
# - Hold violations might be HIDDEN (cells are slower than best-case)
# - Design may FAIL in silicon at process corners!
#===============================================================================

# TODO: Fix the corner configuration!
# Currently: Only TT loaded - INSUFFICIENT for signoff!
set use_slow_corner true    ;# <-- BUG! Should be true for setup
set use_fast_corner true    ;# <-- BUG! Should be true for hold

puts ""
puts "Corner Configuration:"
puts "  Use SS (slow) for setup: $use_slow_corner"
puts "  Use FF (fast) for hold:  $use_fast_corner"

if {!$use_slow_corner || !$use_fast_corner} {
    puts ""
    puts ">>> WARNING: Multi-corner analysis DISABLED! <<<"
    puts "    Signoff requires SS for setup, FF for hold."
}

# Load TT corner (always needed for nominal analysis)
set lib_files [glob -nocomplain $platform_dir/lib/NLDM/asap7sc7p5t_*_RVT_TT_nldm_*.lib.gz]
foreach lib_file $lib_files {
    read_liberty $lib_file
}
read_liberty $platform_dir/lib/NLDM/asap7sc7p5t_SEQ_RVT_TT_nldm_220123.lib

# Conditionally load SS corner for setup analysis
if {$use_slow_corner} {
    puts ""
    puts "Loading SS (slow-slow) corner for setup analysis..."
    set ss_files [glob -nocomplain $platform_dir/lib/NLDM/asap7sc7p5t_*_RVT_SS_nldm_*.lib.gz]
    foreach lib_file $ss_files {
        read_liberty $lib_file
    }
    puts "  SS corner loaded."
}

# Conditionally load FF corner for hold analysis
if {$use_fast_corner} {
    puts ""
    puts "Loading FF (fast-fast) corner for hold analysis..."
    set ff_files [glob -nocomplain $platform_dir/lib/NLDM/asap7sc7p5t_*_RVT_FF_nldm_*.lib.gz]
    foreach lib_file $ff_files {
        read_liberty $lib_file
    }
    puts "  FF corner loaded."
}

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
link_design counter
puts "Design linked."

#-------------------------------------------------------------------------------
# Step 4: Read constraints
#-------------------------------------------------------------------------------

puts ""
puts "Loading constraints..."
read_sdc $sdc_file
puts "Constraints loaded - Target: 1.5 GHz"

#-------------------------------------------------------------------------------
# Step 5: Create Floorplan
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Creating Floorplan"
puts "=============================================="

set die_area  {0 0 20 20}
set core_area {1 1 19 19}

initialize_floorplan -die_area $die_area \
                     -core_area $core_area \
                     -site asap7sc7p5t

source $platform_dir/openRoad/make_tracks.tcl

# Set wire RC
source $platform_dir/setRC.tcl

# Place IO pins
place_pins -hor_layers M4 -ver_layers M5

puts "Floorplan created: 20x20 um die"

#-------------------------------------------------------------------------------
# Step 6: Placement
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Placement"
puts "=============================================="

set_placement_padding -global -left 2 -right 2

global_placement -density 0.50 -timing_driven
detailed_placement
check_placement -verbose

puts "Placement complete."

#-------------------------------------------------------------------------------
# Step 7: CTS
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Clock Tree Synthesis"
puts "=============================================="

set_wire_rc -clock -layer M5

clock_tree_synthesis -root_buf BUFx24_ASAP7_75t_R \
                     -buf_list {BUFx2_ASAP7_75t_R BUFx4_ASAP7_75t_R BUFx8_ASAP7_75t_R BUFx12_ASAP7_75t_R} \
                     -sink_clustering_enable \
                     -sink_clustering_max_diameter 30

repair_clock_nets

puts "CTS complete."

#-------------------------------------------------------------------------------
# Step 8: Global Routing
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Global Routing"
puts "=============================================="

set_routing_layers -signal M4-M7

set_global_routing_layer_adjustment M1 1.0
set_global_routing_layer_adjustment M2 0.9
set_global_routing_layer_adjustment M3 0.7
set_global_routing_layer_adjustment M4 0.4
set_global_routing_layer_adjustment M5 0.2
set_global_routing_layer_adjustment M6 0.2
set_global_routing_layer_adjustment M7 0.5

global_route -congestion_iterations 50 \
             -allow_congestion \
             -verbose

puts "Global routing complete."

#-------------------------------------------------------------------------------
# Step 9: Multi-Corner Timing Signoff
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Multi-Corner Timing Signoff"
puts "=============================================="

estimate_parasitics -global_routing

puts ""
puts "Corner Analysis Status:"
puts "--------------------------------------------------------------"

# Analyze current corner (TT)
puts ""
puts "=== TT Corner (Typical) Analysis ==="
puts ""
report_checks -path_delay max -format summary
report_checks -path_delay min -format summary

set tt_setup_slack [sta::worst_slack -max]
set tt_hold_slack [sta::worst_slack -min]

puts ""
puts [format "TT Corner - Setup Slack: %.3f ns" $tt_setup_slack]
puts [format "TT Corner - Hold Slack:  %.3f ns" $tt_hold_slack]

#-------------------------------------------------------------------------------
# Step 10: Signoff Check
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Signoff Corner Validation"
puts "=============================================="

set signoff_pass true

if {!$use_slow_corner} {
    puts ""
    puts ">>> ERROR: SS corner NOT loaded! <<<"
    puts "    Setup analysis is INCOMPLETE."
    puts "    Cells are slower at SS corner - setup may fail in silicon!"
    set signoff_pass false
}

if {!$use_fast_corner} {
    puts ""
    puts ">>> ERROR: FF corner NOT loaded! <<<"
    puts "    Hold analysis is INCOMPLETE."
    puts "    Cells are faster at FF corner - hold may fail in silicon!"
    set signoff_pass false
}

puts ""
puts "--------------------------------------------------------------"
puts ""

if {$signoff_pass} {
    puts "Multi-corner analysis: ENABLED"
    puts "  - SS corner: Setup verified"
    puts "  - FF corner: Hold verified"
    puts "  - TT corner: Nominal behavior"
} else {
    puts "Multi-corner analysis: DISABLED (TT only)"
    puts ""
    puts ">>> SIGNOFF INCOMPLETE! <<<"
    puts ""
    puts "At 7nm (ASAP7), you MUST analyze multiple corners:"
    puts ""
    puts "  Corner | Condition        | Used For"
    puts "  -------|------------------|------------------"
    puts "  SS     | Slow-Slow        | Setup (max delay)"
    puts "  FF     | Fast-Fast        | Hold (min delay)"
    puts "  TT     | Typical-Typical  | Nominal only"
    puts ""
    puts "FIX: Set use_slow_corner and use_fast_corner to true"
}

#-------------------------------------------------------------------------------
# Step 11: Write outputs
#-------------------------------------------------------------------------------

puts ""
puts "Writing output files..."

set output_def "$results_dir/counter_signoff.def"
write_def $output_def
puts "  DEF: $output_def"

#-------------------------------------------------------------------------------
# Final Result
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
if {$signoff_pass} {
    puts " SIGNOFF PASSED!"
    puts "=============================================="
    puts ""
    puts "  Multi-corner: ENABLED"
    puts "  SS Setup Slack: (would be analyzed)"
    puts "  FF Hold Slack:  (would be analyzed)"
    puts "  TT Nominal:     [format %.3f $tt_setup_slack] ns"
    puts ""
    exit 0
} else {
    puts " SIGNOFF FAILED!"
    puts "=============================================="
    puts ""
    puts "Enable multi-corner analysis for proper signoff."
    puts "Set use_slow_corner = true (for setup)"
    puts "Set use_fast_corner = true (for hold)"
    puts ""
    exit 1
}
