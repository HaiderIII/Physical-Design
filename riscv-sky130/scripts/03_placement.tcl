# ============================================================================
# Phase 3: Placement Script (OpenROAD) - SKY130
# ============================================================================
# Project: RISC-V Physical Design with SKY130 + SRAM Macros
# Target: 100 MHz
# ============================================================================

# TODO: Implement placement
#
# Steps to implement:
# 1. Read floorplan checkpoint
# 2. Set placement density
# 3. Run global placement
# 4. Run detailed placement (legalization)
# 5. Optimize placement
# 6. Generate reports
# 7. Save checkpoint

puts "=========================================="
puts "   Phase 3: Placement (SKY130)"
puts "=========================================="
#-------------------------------------------------------------------------------
# Setup paths
#-------------------------------------------------------------------------------

# Get project directory (parent of scripts folder)
set script_dir [file dirname [file normalize [info script]]]
set project_dir [file dirname $script_dir]

# SKY130 PDK path (uses HOME environment variable)
set platform_dir "$::env(HOME)/OpenROAD-flow-scripts/flow/platforms/sky130hd"
set sram_dir "$::env(HOME)/OpenROAD-flow-scripts/flow/platforms/sky130ram/sky130_sram_1rw1r_128x256_8"

puts "Project directory: $project_dir"
puts "Platform directory: $platform_dir"
puts "SRAM directory: $sram_dir"

#-------------------------------------------------------------------------------
# Load LEF files (technology + cells + macros)
#-------------------------------------------------------------------------------

puts ""
puts "Loading LEF files..."

read_lef $platform_dir/lef/sky130_fd_sc_hd.tlef
read_lef $platform_dir/lef/sky130_fd_sc_hd_merged.lef
read_lef $sram_dir/sky130_sram_1rw1r_128x256_8.lef

puts "LEF files loaded."

#-------------------------------------------------------------------------------
# Load Liberty files (timing)
#-------------------------------------------------------------------------------

puts ""
puts "Loading Liberty files..."

read_liberty $platform_dir/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_liberty $sram_dir/sky130_sram_1rw1r_128x256_8_TT_1p8V_25C.lib

puts "Liberty files loaded."

#-------------------------------------------------------------------------------
# Load floorplan DEF (contains netlist + placement info)
#-------------------------------------------------------------------------------

puts ""
puts "Loading floorplan DEF..."

read_def $project_dir/results/riscv_soc/02_floorplan/riscv_soc_floorplan.def

puts "Floorplan loaded."
#-------------------------------------------------------------------------------
# Load timing constraints (SDC)
#-------------------------------------------------------------------------------

puts ""
puts "Loading timing constraints..."

read_sdc $project_dir/constraints/design.sdc

puts "SDC constraints loaded."


#-------------------------------------------------------------------------------
# Global placement
#-------------------------------------------------------------------------------

puts ""
puts "Running global placement..."

global_placement -density 0.6

puts "Global placement complete."

#-------------------------------------------------------------------------------
# Detailed placement
#-------------------------------------------------------------------------------

puts ""
puts "Running detailed placement..."

detailed_placement

puts "Detailed placement complete."

# Set wire RC for parasitics estimation (SKY130 met2 typical values)
set_wire_rc -signal -layer met2
set_wire_rc -clock -layer met5

# Estimer les parasites pour le timing
estimate_parasitics -placement

# Optimiser le timing (resize cells, buffer insertion)
repair_design
repair_timing

# Re-légaliser après optimisations
detailed_placement
puts "Placement optimizations complete."

#-------------------------------------------------------------------------------
# Verify placement
#-------------------------------------------------------------------------------

puts ""
puts "Verifying placement..."
check_placement
puts "Placement verification complete."



#-------------------------------------------------------------------------------
# Reports
#-------------------------------------------------------------------------------

puts ""
puts "Generating reports..."
report_design_area
report_cell_usage
report_checks
puts "Reports generated."



#-------------------------------------------------------------------------------
# Save placement
#-------------------------------------------------------------------------------

puts ""
puts "Saving placement DEF..."

file mkdir $project_dir/results/riscv_soc/03_placement
write_def $project_dir/results/riscv_soc/03_placement/riscv_soc_placement.def

puts "DEF saved to results/riscv_soc/03_placement/riscv_soc_placement.def"

puts "=========================================="
puts "   Placement complete!"
puts "=========================================="

