# ============================================================================
# Phase 6: Routing Script (OpenROAD)
# ============================================================================

puts "=========================================="
puts "   Phase 6: Routing"
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
# Load CTS DEF
#-------------------------------------------------------------------------------

puts ""
puts "Loading CTS result..."

read_def $project_dir/results/riscv_soc/04_cts/riscv_soc_cts.def

puts "CTS loaded."

#-------------------------------------------------------------------------------
# Load timing constraints (SDC)
#-------------------------------------------------------------------------------

puts ""
puts "Loading timing constraints..."

read_sdc $project_dir/constraints/design.sdc

puts "SDC constraints loaded."

#-------------------------------------------------------------------------------
# Set wire RC for parasitics
#-------------------------------------------------------------------------------

puts ""
puts "Setting wire RC..."

set_wire_rc -signal -resistance 0.0001 -capacitance 0.0001
set_wire_rc -clock -resistance 0.0001 -capacitance 0.0001

puts "Wire RC set."

#-------------------------------------------------------------------------------
# Global routing
#-------------------------------------------------------------------------------

puts ""
puts "Running global routing..."

global_route 

puts "Global routing complete."

#-------------------------------------------------------------------------------
# Detailed routing
#-------------------------------------------------------------------------------

puts ""
puts "Running detailed routing (this may take several minutes)..."

detailed_route

puts "Detailed routing complete."

#-------------------------------------------------------------------------------
# Reports
#-------------------------------------------------------------------------------

puts ""
puts "Generating reports..."

report_timing -path_type full_clock -delay_type max -sort_by slack -nworst 10 -output $project_dir/results/riscv_soc/05_routing/timing_report.txt
report_drc -output $project_dir/results/riscv_soc/05_routing/drc_report.txt
report_routing -output $project_dir/results/riscv_soc/05_routing/routing_report.txt


puts "Reports generated."

#-------------------------------------------------------------------------------
# Save routed DEF
#-------------------------------------------------------------------------------

puts ""
puts "Saving routed DEF..."

file mkdir $project_dir/results/riscv_soc/05_routing
write_def $project_dir/results/riscv_soc/05_routing/riscv_soc_routed.def

puts "DEF saved to results/riscv_soc/05_routing/riscv_soc_routed.def"

puts "=========================================="
puts "   Routing complete!"
puts "=========================================="
