# ============================================================================
# Phase 5: Clock Tree Synthesis (CTS) - ASAP7
# ============================================================================
# Tool: OpenROAD
# Target: ASAP7 7nm FinFET
# Frequency: 500 MHz (2ns period)
# ============================================================================

puts "=========================================="
puts "   Phase 5: Clock Tree Synthesis - ASAP7"
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
# Load placement DEF (BOILERPLATE)
#-------------------------------------------------------------------------------

puts ""
puts "Loading placement DEF..."

read_def $project_dir/results/riscv_soc/03_placement/riscv_soc_placed.def

puts "Placement loaded."

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

# Source ASAP7 RC settings
source $platform_dir/setRC.tcl

puts "Wire RC configured."

#===============================================================================
# TODO: CLOCK TREE SYNTHESIS
#===============================================================================
# Your task: Complete the CTS commands below
#
# Concepts to understand:
# - Clock buffers vs clock inverters
# - Clock tree depth (number of buffer stages)
# - Clock skew (difference in arrival times)
# - Clock latency (time from source to sinks)
#
# Hints:
# - Use 'clock_tree_synthesis' command
# - Buffer cell for ASAP7: BUFx4_ASAP7_75t_R (or similar)
# - Check available buffers: grep "BUF" in LEF file
#===============================================================================

puts ""
puts "Running Clock Tree Synthesis..."

# TODO 1: Configure CTS with appropriate buffer cell
# Hint: set_wire_rc -clock ... (already done in setRC.tcl)
# Hint: clock_tree_synthesis -buf_list {buffer_cell_name} -root_buf {root_buffer}

# YOUR CODE HERE:
# Note: Wire RC already configured by setRC.tcl above
set root_buffer "BUFx12_ASAP7_75t_R"
set buffer_list {
    BUFx2_ASAP7_75t_R
    BUFx3_ASAP7_75t_R
    BUFx4_ASAP7_75t_R
    BUFx5_ASAP7_75t_R
    BUFx8_ASAP7_75t_R
    BUFx10_ASAP7_75t_R
    BUFx12_ASAP7_75t_R
}

clock_tree_synthesis -root_buf $root_buffer -buf_list $buffer_list



puts "CTS complete."

#-------------------------------------------------------------------------------
# TODO: Post-CTS optimization
#-------------------------------------------------------------------------------

puts ""
puts "Running post-CTS optimization..."

# TODO 2: Estimate parasitics and report timing
# Hint: estimate_parasitics -placement
# Hint: report_clock_skew

# YOUR CODE HERE:
estimate_parasitics -placement

report_parasitic_annotation
report_clock_skew

puts "Post-CTS optimization complete."

#-------------------------------------------------------------------------------
# Reports (BOILERPLATE)
#-------------------------------------------------------------------------------

puts ""
puts "Generating reports..."

# TODO 3: Add clock-specific reports
# Hint: report_clock_skew
# Hint: report_checks -path_delay max -through [get_clocks clk]

report_design_area
repair_clock_nets

#-------------------------------------------------------------------------------
# Re-legalize placement (buffers added)
#-------------------------------------------------------------------------------

puts ""
puts "Re-legalizing placement..."

detailed_placement

puts "Placement re-legalized."

#-------------------------------------------------------------------------------
# Save CTS result (BOILERPLATE)
#-------------------------------------------------------------------------------

puts ""
puts "Saving CTS DEF..."

file mkdir $project_dir/results/riscv_soc/04_cts
write_def $project_dir/results/riscv_soc/04_cts/riscv_soc_cts.def

puts "=========================================="
puts "   CTS complete!"
puts "=========================================="
