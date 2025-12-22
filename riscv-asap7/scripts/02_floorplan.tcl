# ============================================================================
# Phase 3: Floorplanning Script (OpenROAD)
# ============================================================================

puts "=========================================="
puts "   Phase 3: Floorplanning"
puts "=========================================="

#-------------------------------------------------------------------------------
# Step 1: Setup paths
#-------------------------------------------------------------------------------

# Get project directory (parent of scripts folder)
set script_dir [file dirname [file normalize [info script]]]
set project_dir [file dirname $script_dir]

# ASAP7 PDK path (uses HOME environment variable)
set platform_dir "$::env(HOME)/OpenROAD-flow-scripts/flow/platforms/asap7"

puts "Project directory: $project_dir"
puts "Platform directory: $platform_dir"

#-------------------------------------------------------------------------------
# Step 2: Load LEF files (technology + cells)
#-------------------------------------------------------------------------------

puts ""
puts "Loading LEF files..."

read_lef $platform_dir/lef/asap7_tech_1x_201209.lef
read_lef $platform_dir/lef/asap7sc7p5t_28_R_1x_220121a.lef

puts "LEF files loaded."

#-------------------------------------------------------------------------------
# Step 3: Load Liberty files (timing)
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
# Step 4: Load synthesized netlist
#-------------------------------------------------------------------------------

puts ""
puts "Loading synthesized netlist..."

read_verilog $project_dir/results/riscv_soc/01_synthesis/riscv_soc_synth.v
link_design riscv_soc

puts "Netlist loaded and linked."

#-------------------------------------------------------------------------------
# Step 5: Load timing constraints (SDC)
#-------------------------------------------------------------------------------

puts ""
puts "Loading timing constraints..."

read_sdc $project_dir/constraints/design.sdc

puts "SDC constraints loaded."

#-------------------------------------------------------------------------------
# Step 6: Initialize floorplan
#-------------------------------------------------------------------------------#
# Useful commands:
#   initialize_floorplan -utilization <percent> -aspect_ratio <ratio> -core_space <microns>
#   OR
#   initialize_floorplan -die_area {x1 y1 x2 y2} -core_area {x1 y1 x2 y2}
#
# For a ~200K cell design in ASAP7, try:
#   - utilization: 40-60%
#   - aspect_ratio: 1.0 (square)
#   - core_space: 5 (microns margin)

initialize_floorplan -utilization 60 -aspect_ratio 1.0 -core_space 5 -site asap7sc7p5t

#-------------------------------------------------------------------------------
# Step 7: Create routing tracks
#-------------------------------------------------------------------------------

# Manual track definition for ASAP7 (to avoid negative offset error)
make_tracks M1 -x_offset 0.018 -x_pitch 0.036 -y_offset 0.018 -y_pitch 0.036
make_tracks M2 -x_offset 0.018 -x_pitch 0.036 -y_offset 0.018 -y_pitch 0.036
make_tracks M3 -x_offset 0.018 -x_pitch 0.036 -y_offset 0.018 -y_pitch 0.036
make_tracks M4 -x_offset 0.018 -x_pitch 0.048 -y_offset 0.018 -y_pitch 0.048
make_tracks M5 -x_offset 0.018 -x_pitch 0.048 -y_offset 0.018 -y_pitch 0.048
make_tracks M6 -x_offset 0.018 -x_pitch 0.048 -y_offset 0.018 -y_pitch 0.048
make_tracks M7 -x_offset 0.018 -x_pitch 0.064 -y_offset 0.018 -y_pitch 0.064
make_tracks M8 -x_offset 0.018 -x_pitch 0.064 -y_offset 0.018 -y_pitch 0.064
make_tracks M9 -x_offset 0.018 -x_pitch 0.064 -y_offset 0.018 -y_pitch 0.064

#-------------------------------------------------------------------------------
# Step 8: Place I/O pins
#-------------------------------------------------------------------------------

#

place_pins -hor_layers M6 -ver_layers M7


#-------------------------------------------------------------------------------
# Step 9: Reports
#-------------------------------------------------------------------------------

puts ""
puts "Generating reports..."
report_design_area
report_checks

#-------------------------------------------------------------------------------
# Step 10: Save floorplan
#-------------------------------------------------------------------------------

puts ""
puts "Saving floorplan DEF..."

file mkdir $project_dir/results/riscv_soc/02_floorplan
write_def $project_dir/results/riscv_soc/02_floorplan/riscv_soc_floorplan.def

puts "DEF saved to results/riscv_soc/02_floorplan/riscv_soc_floorplan.def"

puts "=========================================="
puts "   Floorplan setup complete!"
puts "=========================================="
