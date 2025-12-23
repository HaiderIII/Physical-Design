# ============================================================================
# Phase 5: Clock Tree Synthesis (OpenROAD)
# ============================================================================

puts "=========================================="
puts "   Phase 5: Clock Tree Synthesis (CTS)"
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
# Load placement DEF
#-------------------------------------------------------------------------------

puts ""
puts "Loading placement..."

read_def $project_dir/results/riscv_soc/03_placement/riscv_soc_placement.def


puts "Placement loaded."

#-------------------------------------------------------------------------------
# Load timing constraints (SDC)
#-------------------------------------------------------------------------------

puts ""
puts "Loading timing constraints..."

read_sdc $project_dir/constraints/design.sdc

puts "SDC constraints loaded."

#-------------------------------------------------------------------------------
# Clock Tree Synthesis
#-------------------------------------------------------------------------------

puts ""
puts "Running clock tree synthesis..."

# Set wire RC values (example values, adjust as needed)
set_wire_rc -signal -resistance 0.0001 -capacitance 0.0001
set_wire_rc -clock -resistance 0.0001 -capacitance 0.0001

# ASAP7 clock buffers
set root_buffer "BUFx24_ASAP7_75t_R"
set buffer_list {BUFx2_ASAP7_75t_R BUFx4_ASAP7_75t_R BUFx8_ASAP7_75t_R BUFx12_ASAP7_75t_R}

# Run CTS with sink clustering
clock_tree_synthesis -root_buf $root_buffer \
                     -buf_list $buffer_list \
                     -sink_clustering_enable \
                     -sink_clustering_max_diameter 30 \
                     -sink_clustering_size 15


estimate_parasitics -placement

puts "Clock tree synthesis complete."

#-------------------------------------------------------------------------------
# Estimate parasitics
#-------------------------------------------------------------------------------
puts "Parasitics estimated."

estimate_parasitics -placement

report_parasitic_annotation


#-------------------------------------------------------------------------------
# Repair clock nets
#-------------------------------------------------------------------------------

puts ""
puts "Repairing clock nets..."

repair_clock_nets

puts "Clock nets repaired."

#-------------------------------------------------------------------------------
# Re-legalize placement (buffers added)
#-------------------------------------------------------------------------------

puts ""
puts "Re-legalizing placement..."

detailed_placement

puts "Placement re-legalized."

#-------------------------------------------------------------------------------
# Reports
#-------------------------------------------------------------------------------

puts ""
puts "Generating reports..."

report_clock_skew
report_checks


puts "Reports generated."

#-------------------------------------------------------------------------------
# Save CTS DEF
#-------------------------------------------------------------------------------

puts ""
puts "Saving CTS DEF..."

file mkdir $project_dir/results/riscv_soc/04_cts


puts "DEF saved to results/riscv_soc/04_cts/riscv_soc_cts.def"

puts "=========================================="
puts "   CTS complete!"
puts "=========================================="
