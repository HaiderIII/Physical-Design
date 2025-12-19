#===============================================================================
# RTE_003 - Routing with Min Layer Constraints for ASAP7
#===============================================================================
# This script runs routing on a counter design using ASAP7.
#
# PROBLEM: The minimum routing layer is set too LOW!
#          At 7nm, lower metal layers (M1-M3) are very congested with
#          local cell connections. Using them for signal routing causes
#          severe congestion and DRC violations.
#
# YOUR TASK: Set the correct minimum routing layer for ASAP7.
#===============================================================================

puts "=============================================="
puts " RTE_003 - Counter Routing (ASAP7)"
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
# Step 8: Global Routing - THIS IS WHERE THE BUG IS!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Routing Layer Configuration"
puts "=============================================="

# ASAP7 Metal Stack:
# M1 - Local interconnect (cell internal, very congested)
# M2 - Local routing (cell pins, very congested)
# M3 - Semi-global (still congested at 7nm)
# M4 - Semi-global (preferred for signals)
# M5 - Global routing (good for signals)
# M6 - Global routing (good for signals)
# M7 - Top metal (power/clock)

#-------------------------------------------------------------------------------
# BUG: Minimum routing layer is set too LOW!
#
# At 7nm (ASAP7):
# - M1/M2 are extremely congested with cell connections
# - M3 is still congested with local routing
# - Signal routing should start at M4 minimum
#
# Using M2 as minimum causes:
# - Competition with cell pin connections
# - Severe routing congestion
# - Many DRC violations
# - Potential shorts with cell internal wiring
#-------------------------------------------------------------------------------

# TODO: Fix the minimum routing layer!
set min_routing_layer "M2"    ;# <-- BUG! Too low for 7nm
set max_routing_layer "M7"

puts ""
puts "Routing Layer Configuration:"
puts "  Min layer: $min_routing_layer"
puts "  Max layer: $max_routing_layer"

if {$min_routing_layer eq "M2" || $min_routing_layer eq "M3"} {
    puts ""
    puts ">>> WARNING: Min routing layer too low for 7nm! <<<"
    puts "    M2/M3 are congested with cell connections."
    puts "    Signal routing should start at M4."
}

#-------------------------------------------------------------------------------
# Step 9: Run Global Routing
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Global Routing"
puts "=============================================="

set_routing_layers -signal ${min_routing_layer}-${max_routing_layer}

# Layer adjustments for ASAP7
set_global_routing_layer_adjustment M1 1.0
set_global_routing_layer_adjustment M2 0.9
set_global_routing_layer_adjustment M3 0.7
set_global_routing_layer_adjustment M4 0.4
set_global_routing_layer_adjustment M5 0.2
set_global_routing_layer_adjustment M6 0.2
set_global_routing_layer_adjustment M7 0.5

puts ""
puts "Running global route..."

if {[catch {
    global_route -congestion_iterations 50 \
                 -allow_congestion \
                 -verbose
} route_error]} {
    puts ""
    puts ">>> ROUTING ERROR: $route_error <<<"
}

#-------------------------------------------------------------------------------
# Step 10: Post-Route Analysis
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Post-Route Analysis"
puts "=============================================="

estimate_parasitics -global_routing

puts ""
puts "Timing Summary:"
puts "--------------------------------------------------------------"
report_checks -path_delay max -format summary

set worst_slack [sta::worst_slack -max]
puts ""
puts "--------------------------------------------------------------"
puts [format "Worst slack: %.3f ns" $worst_slack]
puts "--------------------------------------------------------------"

#-------------------------------------------------------------------------------
# Step 11: Pass/Fail Determination
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Routing Quality Check"
puts "=============================================="

set routing_quality "UNKNOWN"

if {$min_routing_layer eq "M2" || $min_routing_layer eq "M3"} {
    set routing_quality "FAIL"
    puts ""
    puts ">>> FAILED: Min routing layer too low! <<<"
    puts ""
    puts "At 7nm, M2/M3 are congested with local cell wiring."
    puts "Using them for signal routing causes congestion."
    puts ""
    puts "FIX: Set min_routing_layer to \"M4\""
    puts ""
    puts "ASAP7 Routing Layer Guidelines:"
    puts "  M1-M2: Cell internal only (blocked)"
    puts "  M3:    Local connections (limited)"
    puts "  M4-M6: Signal routing (preferred)"
    puts "  M7:    Power/clock (special)"
    puts ""
} else {
    set routing_quality "PASS"
    puts ""
    puts "Min routing layer: $min_routing_layer (OK for ASAP7)"
    puts ""
}

#-------------------------------------------------------------------------------
# Step 12: Write outputs
#-------------------------------------------------------------------------------

puts ""
puts "Writing output files..."

set output_def "$results_dir/counter_routed.def"
write_def $output_def
puts "  DEF: $output_def"

#-------------------------------------------------------------------------------
# Final Result
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
if {$routing_quality eq "PASS"} {
    puts " ROUTING PASSED!"
    puts "=============================================="
    puts ""
    puts "  Min layer: $min_routing_layer"
    puts "  Max layer: $max_routing_layer"
    puts "  Slack:     [format "%.3f" $worst_slack] ns"
    puts ""
    exit 0
} else {
    puts " ROUTING FAILED!"
    puts "=============================================="
    puts ""
    puts "Fix the minimum routing layer configuration."
    puts ""
    exit 1
}
