#===============================================================================
# CTS_003 - Clock Tree Synthesis with Sink Clustering
#===============================================================================
# This script runs CTS on an 8-stage pipeline using ASAP7.
#
# PROBLEM: Sink clustering is DISABLED and diameter is too large!
#          At 7nm, proper sink clustering is critical for:
#          - Reducing clock skew
#          - Managing wire capacitance
#          - Balancing clock tree depth
#
# YOUR TASK: Enable sink clustering with appropriate parameters.
#===============================================================================

puts "=============================================="
puts " CTS_003 - Pipeline Clock Tree (ASAP7)"
puts "=============================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]

puts "Script directory: $script_dir"

# ASAP7 PDK paths
set platform_dir "$::env(HOME)/OpenROAD-flow-scripts/flow/platforms/asap7"

# Design files
set design_file "$script_dir/resources/pipeline.v"
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
link_design pipeline
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

# Set padding for sequential cells
set_placement_padding -global -left 2 -right 2

global_placement -density 0.50 -timing_driven
detailed_placement
check_placement -verbose

puts "Placement complete."

#-------------------------------------------------------------------------------
# Step 7: Clock Tree Synthesis - THIS IS WHERE THE BUG IS!
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Clock Tree Synthesis Configuration"
puts "=============================================="

# Set clock wire RC (use higher metal for clock routing)
set_wire_rc -clock -layer M5

# ASAP7 buffers (from the PDK)
set root_buffer "BUFx24_ASAP7_75t_R"
set buffer_list {BUFx2_ASAP7_75t_R BUFx4_ASAP7_75t_R BUFx8_ASAP7_75t_R BUFx12_ASAP7_75t_R}

puts "Buffer configuration:"
puts "  Root buffer: $root_buffer"
puts "  Buffer list: $buffer_list"

#-------------------------------------------------------------------------------
# BUG: Sink clustering is DISABLED!
#
# At 7nm with tight timing (1.5 GHz), proper sink clustering is essential:
# - Groups nearby flip-flops together
# - Reduces local skew within clusters
# - Controls wire capacitance per buffer
#
# Problems without proper clustering:
# - Each buffer may drive too many sinks
# - Long wires to distant sinks
# - High skew between clock sinks
# - Capacitance violations
#
# The sink_clustering_max_diameter parameter controls cluster size:
# - Too large (e.g., 200): clusters span too much area, high skew
# - Too small (e.g., 5): too many buffers, power waste
# - Good value for ASAP7: 20-50 um
#-------------------------------------------------------------------------------

# TODO: Fix these parameters!
set enable_clustering false    ;# <-- BUG! Should be true
set cluster_diameter  200      ;# <-- BUG! Too large for 7nm (should be 20-50)

puts ""
puts "Sink Clustering Configuration:"
puts "  Clustering enabled: $enable_clustering"
puts "  Cluster diameter:   $cluster_diameter um"

if {!$enable_clustering} {
    puts ""
    puts ">>> WARNING: Sink clustering is DISABLED! <<<"
    puts "    This will cause high skew at 7nm frequencies!"
}

if {$cluster_diameter > 100} {
    puts ""
    puts ">>> WARNING: Cluster diameter too large! <<<"
    puts "    Large clusters = long wires = high skew"
}

#-------------------------------------------------------------------------------
# Step 8: Run CTS
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Running Clock Tree Synthesis"
puts "=============================================="

if {$enable_clustering} {
    puts "Running CTS with sink clustering..."
    clock_tree_synthesis -root_buf $root_buffer \
                         -buf_list $buffer_list \
                         -sink_clustering_enable \
                         -sink_clustering_max_diameter $cluster_diameter
} else {
    puts "Running CTS WITHOUT sink clustering..."
    clock_tree_synthesis -root_buf $root_buffer \
                         -buf_list $buffer_list
}

repair_clock_nets

#-------------------------------------------------------------------------------
# Step 9: Post-CTS Analysis
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " Post-CTS Analysis"
puts "=============================================="

report_cts

# Estimate parasitics
estimate_parasitics -placement

# Report timing
puts ""
puts "Timing Analysis:"
puts "--------------------------------------------------------------"
report_checks -path_delay max -format summary

set worst_slack [sta::worst_slack -max]
puts ""
puts "--------------------------------------------------------------"
puts [format "Worst slack: %.3f ns" $worst_slack]
puts "--------------------------------------------------------------"

#-------------------------------------------------------------------------------
# Step 10: Quality Check
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
puts " CTS Quality Check"
puts "=============================================="

# Determine pass/fail
set cts_quality "UNKNOWN"

if {!$enable_clustering} {
    set cts_quality "FAIL"
    puts ""
    puts ">>> FAILED: Sink clustering is disabled! <<<"
    puts ""
    puts "At 7nm with 1.5 GHz clock, you MUST enable sink clustering."
    puts ""
    puts "FIX: Set enable_clustering to true"
    puts "     Set cluster_diameter to 20-50 um"
    puts ""
} elseif {$cluster_diameter > 100} {
    set cts_quality "WARNING"
    puts ""
    puts ">>> WARNING: Cluster diameter too large! <<<"
    puts ""
    puts "Current: $cluster_diameter um"
    puts "Recommended for ASAP7: 20-50 um"
    puts ""
} else {
    set cts_quality "PASS"
    puts ""
    puts "Sink clustering: ENABLED"
    puts "Cluster diameter: $cluster_diameter um (OK for ASAP7)"
    puts ""
}

#-------------------------------------------------------------------------------
# Step 11: Write outputs
#-------------------------------------------------------------------------------

puts ""
puts "Writing output files..."

set output_def "$results_dir/pipeline_cts.def"
write_def $output_def
puts "  DEF: $output_def"

#-------------------------------------------------------------------------------
# Final Result
#-------------------------------------------------------------------------------

puts ""
puts "=============================================="
if {$cts_quality eq "PASS"} {
    puts " CTS PASSED!"
    puts "=============================================="
    puts ""
    puts "  Clustering: enabled"
    puts "  Diameter:   $cluster_diameter um"
    puts "  Slack:      [format "%.3f" $worst_slack] ns"
    puts ""
    exit 0
} elseif {$cts_quality eq "WARNING"} {
    puts " CTS COMPLETED WITH WARNINGS"
    puts "=============================================="
    puts ""
    puts "Consider reducing cluster_diameter for better results."
    puts ""
    exit 1
} else {
    puts " CTS FAILED!"
    puts "=============================================="
    puts ""
    puts "Fix the sink clustering configuration:"
    puts "  set enable_clustering true"
    puts "  set cluster_diameter 30"
    puts ""
    exit 1
}
