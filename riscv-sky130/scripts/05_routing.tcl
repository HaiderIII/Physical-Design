# ============================================================================
# Phase 5: Routing Script (OpenROAD) - SKY130
# ============================================================================
# Project: RISC-V Physical Design with SKY130 + SRAM Macros
# Target: 100 MHz
# ============================================================================

# TODO: Implement routing
#
# Steps to implement:
# 1. Read CTS checkpoint
# 2. Set global routing layers
# 3. Run global routing
# 4. Run detailed routing
# 5. Fix DRC violations
# 6. Fix antenna violations
# 7. Generate reports
# 8. Save checkpoint

puts "=========================================="
puts "   Phase 5: Routing (SKY130)"
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

read_def $project_dir/results/riscv_soc/04_cts/riscv_soc_cts.def

puts "Placement loaded."
#-------------------------------------------------------------------------------
# Load timing constraints (SDC)
#-------------------------------------------------------------------------------

puts ""
puts "Loading timing constraints..."

read_sdc $project_dir/constraints/design.sdc

puts "SDC constraints loaded."

# Set wire RC for parasitics estimation (SKY130 met2 typical values)
set_wire_rc -signal -layer met2
set_wire_rc -clock -layer met5

#-------------------------------------------------------------------------------
# Setup for routing
#-------------------------------------------------------------------------------

puts ""
puts "Setting up routing..."

# Set global routing layer range (li1 to met5 for SKY130)
set_routing_layers -signal li1-met5 -clock met3-met5

puts "Routing setup complete."

#-------------------------------------------------------------------------------
# Power Distribution Network (required before routing)
#-------------------------------------------------------------------------------

puts ""
puts "Setting up power distribution..."

# Add global connections for power/ground
add_global_connection -net VDD -pin_pattern "^VPWR$" -power
add_global_connection -net VDD -pin_pattern "^VPB$" -power
add_global_connection -net VSS -pin_pattern "^VGND$" -ground
add_global_connection -net VSS -pin_pattern "^VNB$" -ground

# Connect all power pins globally
global_connect

# Fix tie-cell nets incorrectly marked as POWER/GROUND
# The 'one_' and 'zero_' nets are logic constants, not power rails
# Use pattern matching to catch hierarchical names like u_dmem/one_, u_imem/zero_, etc.
set block [ord::get_db_block]
foreach net [$block getNets] {
    set net_name [$net getName]
    set sig_type [$net getSigType]
    if {($sig_type == "POWER" || $sig_type == "GROUND") &&
        ([string match "*one_*" $net_name] || [string match "*zero_*" $net_name])} {
        puts "Reclassifying tie net: $net_name from $sig_type to SIGNAL"
        $net setSigType "SIGNAL"
    }
}


puts "Power distribution setup complete."


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
