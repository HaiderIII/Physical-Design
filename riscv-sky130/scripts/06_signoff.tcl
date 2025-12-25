# ============================================================================
# Phase 6: Signoff Script (OpenROAD) - SKY130
# ============================================================================
# Project: RISC-V Physical Design with SKY130 + SRAM Macros
# Target: 100 MHz
# ============================================================================

puts "=========================================="
puts "   Phase 6: Signoff (SKY130)"
puts "=========================================="

#-------------------------------------------------------------------------------
# Setup paths
#-------------------------------------------------------------------------------

set script_dir [file dirname [file normalize [info script]]]
set project_dir [file dirname $script_dir]

set platform_dir "$::env(HOME)/OpenROAD-flow-scripts/flow/platforms/sky130hd"
set sram_dir "$::env(HOME)/OpenROAD-flow-scripts/flow/platforms/sky130ram/sky130_sram_1rw1r_128x256_8"

puts "Project directory: $project_dir"
puts "Platform directory: $platform_dir"

#-------------------------------------------------------------------------------
# Load LEF files
#-------------------------------------------------------------------------------

puts ""
puts "Loading LEF files..."

read_lef $platform_dir/lef/sky130_fd_sc_hd.tlef
read_lef $platform_dir/lef/sky130_fd_sc_hd_merged.lef
read_lef $sram_dir/sky130_sram_1rw1r_128x256_8.lef

puts "LEF files loaded."

#-------------------------------------------------------------------------------
# Load Liberty files
#-------------------------------------------------------------------------------

puts ""
puts "Loading Liberty files..."

read_liberty $platform_dir/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_liberty $sram_dir/sky130_sram_1rw1r_128x256_8_TT_1p8V_25C.lib

puts "Liberty files loaded."

#-------------------------------------------------------------------------------
# Load routed DEF
#-------------------------------------------------------------------------------

puts ""
puts "Loading routed DEF..."

read_def $project_dir/results/riscv_soc/05_routing/riscv_soc_routed.def

puts "Routed design loaded."

#-------------------------------------------------------------------------------
# Load timing constraints
#-------------------------------------------------------------------------------

puts ""
puts "Loading timing constraints..."

read_sdc $project_dir/constraints/design.sdc

puts "SDC constraints loaded."

#-------------------------------------------------------------------------------
# Create output directory
#-------------------------------------------------------------------------------

file mkdir $project_dir/results/riscv_soc/06_signoff
file mkdir $project_dir/reports

#-------------------------------------------------------------------------------
# Parasitic Extraction (SPEF)
#-------------------------------------------------------------------------------

puts ""
puts "Running parasitic extraction..."

set_wire_rc -signal -layer met2
set_wire_rc -clock -layer met5

estimate_parasitics -placement

puts "Parasitic extraction complete."

#-------------------------------------------------------------------------------
# Static Timing Analysis (STA)
#-------------------------------------------------------------------------------

puts ""
puts "Running Static Timing Analysis..."

# Timing reports
report_checks -path_delay max
report_checks -path_delay min
report_worst_slack -max
report_worst_slack -min
report_tns
report_clock_skew

puts "STA complete."

# Print summary to console
puts ""
puts "=== TIMING SUMMARY ==="

#-------------------------------------------------------------------------------
# Design Rule Check (DRC)
#-------------------------------------------------------------------------------

puts ""
puts "Running Design Rule Checks..."

# Report design area
report_design_area

puts "DRC checks complete."

#-------------------------------------------------------------------------------
# Power Analysis
#-------------------------------------------------------------------------------

puts ""
puts "Running Power Analysis..."

# Set activity for power estimation (typical switching)
set_power_activity -global -activity 0.1 -duty 0.5

# Report power
report_power

puts "Power analysis complete."

#-------------------------------------------------------------------------------
# Final Reports
#-------------------------------------------------------------------------------

puts ""
puts "Generating final reports..."

# Design statistics
report_design_area
report_cell_usage

puts "Final reports generated."

#-------------------------------------------------------------------------------
# Write Final DEF
#-------------------------------------------------------------------------------

puts ""
puts "Writing final DEF..."

write_def $project_dir/results/riscv_soc/06_signoff/riscv_soc_final.def

puts "Final DEF saved."

#-------------------------------------------------------------------------------
# Write Verilog Netlist (for LVS)
#-------------------------------------------------------------------------------

puts ""
puts "Writing final Verilog netlist..."

write_verilog $project_dir/results/riscv_soc/06_signoff/riscv_soc_final.v

puts "Verilog netlist saved."

#-------------------------------------------------------------------------------
# Summary
#-------------------------------------------------------------------------------

puts ""
puts "=========================================="
puts "   SIGNOFF SUMMARY"
puts "=========================================="
puts ""
puts "Output files:"
puts "  - DEF:     results/riscv_soc/06_signoff/riscv_soc_final.def"
puts "  - Verilog: results/riscv_soc/06_signoff/riscv_soc_final.v"
puts ""
puts "Next steps for tape-out:"
puts "  1. Run Magic for final DRC/LVS"
puts "  2. Generate GDSII with KLayout or Magic"
puts "  3. Integrate into Caravel for MPW submission"
puts ""
puts "=========================================="
puts "   Signoff complete!"
puts "=========================================="
