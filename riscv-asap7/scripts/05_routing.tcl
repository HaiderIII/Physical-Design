# ============================================================================
# Phase 6: Routing - ASAP7
# ============================================================================
# Tool: OpenROAD
# Target: ASAP7 7nm FinFET
# Frequency: 500 MHz (2ns period)
# ============================================================================

puts "=========================================="
puts "   Phase 6: Routing - ASAP7"
puts "=========================================="

#-------------------------------------------------------------------------------
# Setup paths (BOILERPLATE - same for all phases)
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]
set project_dir [file dirname $script_dir]
set platform_dir "$::env(HOME)/OpenROAD-flow-scripts/flow/platforms/asap7"

puts "Project directory: $project_dir"
puts "Platform directory: $platform_dir"

#-------------------------------------------------------------------------------
# Load LEF files (BOILERPLATE)
#-------------------------------------------------------------------------------

puts ""
puts "Loading LEF files..."

read_lef $platform_dir/lef/asap7_tech_1x_201209.lef
read_lef $platform_dir/lef/asap7sc7p5t_28_R_1x_220121a.lef

puts "LEF files loaded."

#-------------------------------------------------------------------------------
# Load Liberty files (BOILERPLATE)
#-------------------------------------------------------------------------------

puts ""
puts "Loading Liberty files..."

read_liberty $platform_dir/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib
read_liberty $platform_dir/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib
read_liberty $platform_dir/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib
read_liberty $platform_dir/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib
read_liberty $platform_dir/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib

puts "Liberty files loaded."

#-------------------------------------------------------------------------------
# Load CTS DEF (BOILERPLATE)
#-------------------------------------------------------------------------------

puts ""
puts "Loading CTS DEF..."

read_def $project_dir/results/riscv_soc/04_cts/riscv_soc_cts.def

puts "CTS result loaded."

#-------------------------------------------------------------------------------
# Load timing constraints (BOILERPLATE)
#-------------------------------------------------------------------------------

puts ""
puts "Loading timing constraints..."

read_sdc $project_dir/constraints/design.sdc

puts "SDC constraints loaded."

#-------------------------------------------------------------------------------
# Set wire RC for parasitics estimation (BOILERPLATE for ASAP7)
#-------------------------------------------------------------------------------

puts ""
puts "Setting wire RC..."

source $platform_dir/setRC.tcl
set_wire_rc -signal -layer M2
set_wire_rc -clock -layer M8

puts "Wire RC configured."

#===============================================================================
# TODO: GLOBAL ROUTING
#===============================================================================
# Your task: Complete the global routing commands below
#
# Concepts to understand:
# - Global routing: Creates routing guides (coarse grid)
# - Metal layers: M1-M9 in ASAP7 (M1 lowest, M9 highest)
# - Congestion: Too many wires in one area
# - Overflow: When routing demand exceeds capacity
#
# Hints:
# - Use 'global_route' command
# - Check routing layers available in LEF
# - Congestion report helps identify problem areas
#===============================================================================

puts ""
puts "Running Global Routing..."

# TODO 1: Configure and run global routing
# Hint: global_route -guide_file <output_guide> -congestion_iterations <N>
# Hint: For ASAP7, layers M2-M7 are typically used for signal routing

# YOUR CODE HERE:

# Signal routing on M2-M7, clock on M6-M7 (within allowed range)
set_routing_layers -signal M2-M7 -clock M6-M7

global_route -congestion_iterations 30

puts "Global routing complete."

#===============================================================================
# TODO: DETAILED ROUTING
#===============================================================================
# Your task: Complete the detailed routing commands below
#
# Concepts to understand:
# - Detailed routing: Creates actual metal wires following guides
# - DRC: Design Rule Check (spacing, width violations)
# - Via: Vertical connection between metal layers
# - Antenna effect: Long wires can damage transistor gates
#
# Hints:
# - Use 'detailed_route' command
# - May need multiple iterations to fix DRC violations
#===============================================================================

puts ""
puts "Running Detailed Routing..."

# TODO 2: Run detailed routing
# Hint: detailed_route -output_drc <drc_report>
# Hint: Check for DRC violations in the report

# YOUR CODE HERE:

detailed_route

puts "Detailed routing complete."

#-------------------------------------------------------------------------------
# Post-routing optimization (BOILERPLATE)
#-------------------------------------------------------------------------------

puts ""
puts "Running post-routing optimization..."

# Estimate final parasitics
estimate_parasitics -global_routing

puts "Post-routing optimization complete."

#-------------------------------------------------------------------------------
# Reports
#-------------------------------------------------------------------------------

puts ""
puts "Generating reports..."

# TODO 3: Add routing-specific reports
# Hint: report_design_area
# Hint: report_routing_layers (if available)
# Hint: report_checks -path_delay max (timing after routing)

# YOUR CODE HERE:
report_design_area


#-------------------------------------------------------------------------------
# Save routed result (BOILERPLATE)
#-------------------------------------------------------------------------------

puts ""
puts "Saving routed DEF..."

file mkdir $project_dir/results/riscv_soc/05_routing
write_def $project_dir/results/riscv_soc/05_routing/riscv_soc_routed.def

puts "=========================================="
puts "   Routing complete!"
puts "=========================================="
