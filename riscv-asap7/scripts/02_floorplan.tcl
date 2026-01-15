# ============================================================================
# Phase 3: Floorplan Script (OpenROAD) - ASAP7
# ============================================================================
# Tool: OpenROAD
# Target: ASAP7 7nm FinFET
# Frequency: 500 MHz (2ns period)
# ============================================================================

puts "=========================================="
puts "   Phase 3: Floorplanning - ASAP7"
puts "=========================================="

#-------------------------------------------------------------------------------
# Setup paths
#-------------------------------------------------------------------------------

# Get project directory (parent of scripts folder)
set script_dir [file dirname [file normalize [info script]]]
set project_dir [file dirname $script_dir]

# ASAP7 PDK path (uses HOME environment variable)
set platform_dir "$::env(HOME)/OpenROAD-flow-scripts/flow/platforms/asap7"

# NOTE: No SRAM macros for ASAP7 - we use fake SRAM (synthesized to flip-flops)

puts "Project directory: $project_dir"
puts "Platform directory: $platform_dir"

#-------------------------------------------------------------------------------
# Load LEF files (technology + cells)
#-------------------------------------------------------------------------------

puts ""
puts "Loading LEF files..."

# Tech LEF (metal layers, vias, design rules)
read_lef $platform_dir/lef/asap7_tech_1x_201209.lef

# Cell LEF (standard cell physical definitions)
read_lef $platform_dir/lef/asap7sc7p5t_28_R_1x_220121a.lef

puts "LEF files loaded."

#-------------------------------------------------------------------------------
# Load Liberty files (timing)
#-------------------------------------------------------------------------------

puts ""
puts "Loading Liberty files..."

# Sequential cells (flip-flops)
read_liberty $platform_dir/lib/NLDM/asap7sc7p5t_SEQ_RVT_FF_nldm_220123.lib

# Combinational cells - ALL libraries used during synthesis
read_liberty $platform_dir/lib/NLDM/asap7sc7p5t_SIMPLE_RVT_FF_nldm_211120.lib

# Inverters and buffers
read_liberty $platform_dir/lib/NLDM/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib

# AND-OR complex gates (AOI21, AOI211, AOI22, etc.)
read_liberty $platform_dir/lib/NLDM/asap7sc7p5t_AO_RVT_FF_nldm_211120.lib

# OR-AND complex gates (OAI21, OAI211, OAI22, etc.)
read_liberty $platform_dir/lib/NLDM/asap7sc7p5t_OA_RVT_FF_nldm_211120.lib

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
# For ASAP7 with ~68,000 cells (mostly DFFs for fake SRAM):
#   - Site name: asap7sc7p5t (from LEF)
#   - Lower utilization because of many flip-flops
#   - Estimated die area needed: ~800x800 um

puts ""
puts "Initializing floorplan..."

# TODO: Adjust utilization if placement fails
initialize_floorplan \
    -utilization 40 \
    -aspect_ratio 1.0 \
    -core_space 5 \
    -site asap7sc7p5t

puts "Floorplan initialized."

#-------------------------------------------------------------------------------
# Create routing tracks
#-------------------------------------------------------------------------------

puts ""
puts "Creating routing tracks..."

# Source ASAP7 track definitions
source $platform_dir/openRoad/make_tracks.tcl

puts "Routing tracks created."

#-------------------------------------------------------------------------------
# Place I/O pins
#-------------------------------------------------------------------------------
# ASAP7 metal layers: M1-M9
# Use M4 (horizontal) and M5 (vertical) for IO pins

puts ""
puts "Placing I/O pins..."

# TODO: Adjust metal layers if needed (check LEF for layer names)
place_pins -hor_layers M4 -ver_layers M5

puts "I/O pins placed."

#-------------------------------------------------------------------------------
# Insert tap cells (well tie-off)
#-------------------------------------------------------------------------------

puts ""
puts "Inserting tap cells..."

# TODO: Find correct tap cell name in ASAP7 library
# tapcell -distance 25 -tapcell_master TAPCELLx1_ASAP7_75t_R

puts "Tap cells step (check if needed for ASAP7)."

#-------------------------------------------------------------------------------
# Power Distribution Network (PDN)
#-------------------------------------------------------------------------------

puts ""
puts "Setting up power grid..."

# Add global power connections
add_global_connection -net VDD -pin_pattern {^VDD$} -power
add_global_connection -net VSS -pin_pattern {^VSS$} -ground

# TODO: Configure power stripes with pdngen if needed

puts "Power grid configured."

#-------------------------------------------------------------------------------
# Reports
#-------------------------------------------------------------------------------

puts ""
puts "Generating reports..."

report_design_area

#-------------------------------------------------------------------------------
# Save floorplan
#-------------------------------------------------------------------------------

puts ""
puts "Saving floorplan DEF..."

file mkdir $project_dir/results/riscv_soc/02_floorplan
write_def $project_dir/results/riscv_soc/02_floorplan/riscv_soc_floorplan.def

puts "=========================================="
puts "   Floorplan complete!"
puts "=========================================="
