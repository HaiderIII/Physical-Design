# ============================================================================
# Phase 4: Placement Script (OpenROAD) - ASAP7
# ============================================================================
# Tool: OpenROAD
# Target: ASAP7 7nm FinFET
# Frequency: 500 MHz (2ns period)
# ============================================================================

puts "=========================================="
puts "   Phase 4: Placement - ASAP7"
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
# Load floorplan DEF (BOILERPLATE)
#-------------------------------------------------------------------------------

puts ""
puts "Loading floorplan DEF..."

read_def $project_dir/results/riscv_soc/02_floorplan/riscv_soc_floorplan.def

puts "Floorplan loaded."

#-------------------------------------------------------------------------------
# Load timing constraints (BOILERPLATE)
#-------------------------------------------------------------------------------

puts ""
puts "Loading timing constraints..."

read_sdc $project_dir/constraints/design.sdc

puts "SDC constraints loaded."

#===============================================================================
# TODO: GLOBAL PLACEMENT
#===============================================================================
# Your task: Complete the global placement command
#
# Concepts to understand:
# - Placement density (% of area filled with cells)
# - Wirelength optimization (HPWL = Half-Perimeter Wire Length)
# - Congestion awareness
#
# Hints:
# - Use 'global_placement' command
# - Typical density: 0.5 to 0.7 (50% to 70%)
# - Lower density = easier routing but larger area
#===============================================================================

puts ""
puts "Running global placement..."

# TODO 1: Run global placement with appropriate density
# Hint: global_placement -density <value>
# Try density values between 0.5 and 0.7

# YOUR CODE HERE:
global_placement -density 0.6

puts "Global placement complete."

#-------------------------------------------------------------------------------
# TODO: Timing analysis after global placement
#-------------------------------------------------------------------------------

puts ""
puts "Running timing optimization..."

# TODO 2: Estimate parasitics and report timing
# Hint: estimate_parasitics -placement
# Hint: report_worst_slack -max (for setup)
# Hint: report_worst_slack -min (for hold)

# YOUR CODE HERE:
estimate_parasitics -placement
report_worst_slack -max
report_worst_slack -min

puts "Timing optimization complete."

#===============================================================================
# TODO: DETAIL PLACEMENT
#===============================================================================
# Your task: Run detail placement to legalize cells
#
# Concepts to understand:
# - Legalization: snapping cells to valid placement sites
# - Removing overlaps between cells
# - Local optimization
#===============================================================================

puts ""
puts "Running detail placement..."

# TODO 3: Run detail placement
# Hint: detailed_placement
# Hint: check_placement (to verify legality)

# YOUR CODE HERE:
detailed_placement
check_placement

puts "Detail placement complete."

#-------------------------------------------------------------------------------
# Post-placement timing (BOILERPLATE)
#-------------------------------------------------------------------------------

puts ""
puts "Running post-placement optimization..."

estimate_parasitics -placement
puts "Timing after detail placement:"
report_worst_slack -max
report_worst_slack -min

puts "Post-placement optimization complete."

#-------------------------------------------------------------------------------
# Reports (BOILERPLATE)
#-------------------------------------------------------------------------------

puts ""
puts "Generating reports..."

report_design_area
report_cell_usage

#-------------------------------------------------------------------------------
# Save placement (BOILERPLATE)
#-------------------------------------------------------------------------------

puts ""
puts "Saving placement DEF..."

file mkdir $project_dir/results/riscv_soc/03_placement
write_def $project_dir/results/riscv_soc/03_placement/riscv_soc_placed.def

puts "=========================================="
puts "   Placement complete!"
puts "=========================================="
