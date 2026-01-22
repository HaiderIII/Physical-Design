# ============================================================================
# Phase 6: Routing - ASAP7
# ============================================================================
# Tool: OpenROAD
# Target: ASAP7 7nm FinFET
# Frequency: 500 MHz (2ns period)
# ============================================================================

puts "=========================================="
puts "   Phase 6: Routing - ASAP7"
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
# Load CTS DEF (BOILERPLATE)
#-------------------------------------------------------------------------------

puts ""
puts "Loading CTS DEF..."

read_def $project_dir/results/riscv_soc/04_cts/riscv_soc_cts.def

puts "CTS result loaded."

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

source $platform_dir/setRC.tcl
set_wire_rc -signal -layer M2
set_wire_rc -clock -layer M8

puts "Wire RC configured."

#-------------------------------------------------------------------------------
# Power Distribution Network (required before routing)
#-------------------------------------------------------------------------------

puts ""
puts "Setting up power distribution..."

# Add global connections for power/ground (ASAP7 pin names)
add_global_connection -net VDD -pin_pattern "^VDD$" -power
add_global_connection -net VSS -pin_pattern "^VSS$" -ground

# Connect all power pins globally
global_connect

# Fix tie-cell nets incorrectly marked as POWER/GROUND
# The 'one_' and 'zero_' nets are logic constants, not power rails
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
puts "Running Global Routing..."

# Signal routing on M2-M7, clock on M6-M7 (within allowed range)
set_routing_layers -signal M2-M7 -clock M6-M7

global_route -congestion_iterations 30

puts "Global routing complete."

#-------------------------------------------------------------------------------
# Detailed routing
#-------------------------------------------------------------------------------

puts ""
puts "Running Detailed Routing..."

detailed_route

puts "Detailed routing complete."

#-------------------------------------------------------------------------------
# Save routed DEF (before reports to avoid losing work if reports fail)
#-------------------------------------------------------------------------------

puts ""
puts "Saving routed DEF..."

file mkdir $project_dir/results/riscv_soc/05_routing
write_def $project_dir/results/riscv_soc/05_routing/riscv_soc_routed.def

puts "DEF saved to results/riscv_soc/05_routing/riscv_soc_routed.def"

#-------------------------------------------------------------------------------
# Reports
#-------------------------------------------------------------------------------

puts ""
puts "Generating reports..."

report_timing
report_design_area

puts "Reports generated."

puts "=========================================="
puts "   Routing complete!"
puts "=========================================="
