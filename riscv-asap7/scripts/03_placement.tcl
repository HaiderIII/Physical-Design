# ============================================================================
# Phase 4: Placement Script (OpenROAD)
# ============================================================================

puts "=========================================="
puts "   Phase 4: Placement"
puts "=========================================="

#-------------------------------------------------------------------------------
# Setup paths
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]
set project_dir [file dirname $script_dir]
set platform_dir "$::env(HOME)/OpenROAD-flow-scripts/flow/platforms/asap7"

puts "Project directory: $project_dir"
puts "Platform directory: $platform_dir"

#-------------------------------------------------------------------------------
# Load LEF files (technology + cells)
#-------------------------------------------------------------------------------

puts ""
puts "Loading LEF files..."

read_lef $platform_dir/lef/asap7_tech_1x_201209.lef
read_lef $platform_dir/lef/asap7sc7p5t_28_R_1x_220121a.lef

puts "LEF files loaded."

#-------------------------------------------------------------------------------
# Load Liberty files (timing)
#-------------------------------------------------------------------------------

puts ""
puts "Loading Liberty files..."

read_liberty $platform_dir/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_TT_nldm_211120.lib.gz
read_liberty $platform_dir/lib/NLDM/asap7sc7p5t_SEQ_RVT_TT_nldm_220123.lib
read_liberty $platform_dir/lib/NLDM/asap7sc7p5t_INVBUF_RVT_TT_nldm_220122.lib.gz
read_liberty $platform_dir/lib/NLDM/asap7sc7p5t_AO_RVT_TT_nldm_211120.lib.gz
read_liberty $platform_dir/lib/NLDM/asap7sc7p5t_OA_RVT_TT_nldm_211120.lib.gz

puts "Liberty files loaded."

#-------------------------------------------------------------------------------
# Load floorplan DEF
#-------------------------------------------------------------------------------

puts ""
puts "Loading floorplan..."

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
