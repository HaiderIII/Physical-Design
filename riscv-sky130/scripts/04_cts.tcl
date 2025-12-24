# ============================================================================
# Phase 4: Clock Tree Synthesis Script (OpenROAD) - SKY130
# ============================================================================
# Project: RISC-V Physical Design with SKY130 + SRAM Macros
# Target: 100 MHz
# ============================================================================

# TODO: Implement CTS
#
# Steps to implement:
# 1. Read placement checkpoint
# 2. Set wire RC values
# 3. Configure CTS (buffers, clustering)
# 4. Run clock tree synthesis
# 5. Repair clock tree
# 6. Generate reports (skew, latency)
# 7. Save checkpoint

puts "=========================================="
puts "   Phase 4: Clock Tree Synthesis (SKY130)"
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
# Load placement DEF (contains netlist + placed cells)
#-------------------------------------------------------------------------------

puts ""
puts "Loading placement DEF..."

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
puts "Starting Clock Tree Synthesis..." 
# Configure CTS parameters
# Set wire RC for parasitics estimation (SKY130 met2 typical values)
set_wire_rc -signal -layer met2
set_wire_rc -clock -layer met5


# CTS uses dedicated clock buffers (optimized for low skew)
# Root buffer = strongest (drives entire tree)
# Buffer list = all sizes for algorithm to choose from
set root_buffer "sky130_fd_sc_hd__clkbuf_16"
set buffer_list {
    sky130_fd_sc_hd__clkbuf_1
    sky130_fd_sc_hd__clkbuf_2
    sky130_fd_sc_hd__clkbuf_4
    sky130_fd_sc_hd__clkbuf_8
    sky130_fd_sc_hd__clkbuf_16
}

# Run CTS with sink clustering
clock_tree_synthesis -root_buf $root_buffer \
                     -buf_list $buffer_list \
                     -sink_clustering_enable \
                     -sink_clustering_max_diameter 30 \
                     -sink_clustering_size 15

puts "Clock tree synthesis complete."

            
#-------------------------------------------------------------------------------
# Estimate parasitics
#-------------------------------------------------------------------------------

estimate_parasitics -placement

report_parasitic_annotation
puts "Parasitics estimated."

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
# Post-CTS timing optimization
#-------------------------------------------------------------------------------

puts ""
puts "Optimizing timing post-CTS..."

estimate_parasitics -placement
repair_timing

# Re-legalize after optimization
detailed_placement

puts "Post-CTS optimization complete."

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
write_def  $project_dir/results/riscv_soc/04_cts/riscv_soc_cts.def

puts "DEF saved to results/riscv_soc/04_cts/riscv_soc_cts.def"

puts "=========================================="
puts "   CTS complete!"
puts "=========================================="
