# ============================================================================
# Phase 2: Floorplanning Script (OpenROAD) - SKY130
# ============================================================================

puts "=========================================="
puts "   Phase 2: Floorplanning"
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
# Load synthesized netlist
#-------------------------------------------------------------------------------

puts ""
puts "Loading synthesized netlist..."

read_verilog $project_dir/results/riscv_soc/01_synthesis/riscv_soc_synth.v
link_design riscv_soc

puts "Netlist loaded and linked."

#-------------------------------------------------------------------------------
# Load timing constraints (SDC)
#-------------------------------------------------------------------------------

puts ""
puts "Loading timing constraints..."

read_sdc $project_dir/constraints/design.sdc

puts "SDC constraints loaded."

#-------------------------------------------------------------------------------
# Initialize floorplan
#-------------------------------------------------------------------------------
# For SKY130 with 2x SRAM macros (~250x500 µm each) + ~85K µm² logic:
#   - Need ~335K µm² total (logic + SRAMs)
#   - Site name: unithd
#   - Consider utilization 40-50% (lower because of macros)

# TODO: initialize_floorplan ...

initialize_floorplan -utilization 30 -aspect_ratio 1.0 -core_space 5 -site unithd

puts "Floorplan initialized."
#-------------------------------------------------------------------------------
# Create routing tracks
#-------------------------------------------------------------------------------
# Check $platform_dir/make_tracks.tcl for reference

# TODO: source or make_tracks ...
source $platform_dir/make_tracks.tcl


puts "Routing tracks created."

#-------------------------------------------------------------------------------
# Place SRAM macros
#-------------------------------------------------------------------------------
# SRAM macro: sky130_sram_1rw1r_128x256_8
# Dimensions from LEF: 1141.72 x 632.475 µm
# Instance names: u_imem/u_sram, u_dmem/u_sram

# Place SRAMs side by side with R90 (compact square layout)
# R90 dimensions: 632.475 (W) × 1141.72 (H)
place_macro -macro_name u_imem/u_sram -location {50 50} -orientation R90
place_macro -macro_name u_dmem/u_sram -location {750 50} -orientation R90

puts "SRAM macros placed."

#-------------------------------------------------------------------------------
# Place I/O pins
#-------------------------------------------------------------------------------
# Use appropriate metal layers for SKY130

# TODO: place_pins ...
place_pins -hor_layers met3 -ver_layers met2
puts "I/O pins placed."

#-------------------------------------------------------------------------------
# Reports
#-------------------------------------------------------------------------------

puts ""
puts "Generating reports..."
report_design_area
report_checks

# TODO: report_design_area, report_checks ...

#-------------------------------------------------------------------------------
# Save floorplan
#-------------------------------------------------------------------------------

puts ""
puts "Saving floorplan DEF..."

file mkdir $project_dir/results/riscv_soc/02_floorplan
write_def $project_dir/results/riscv_soc/02_floorplan/riscv_soc_floorplan.def
# TODO: write_def ...

puts "=========================================="
puts "   Floorplan setup complete!"
puts "=========================================="
