#!/usr/bin/env openroad
# ===========================================================================
# Example 3: Constraint-Driven I/O Placement
# ===========================================================================

puts "\n========================================="
puts "Example 3 : Constraint-Driven Placement"
puts "=========================================\n"

# Design Overview
puts "Design: Memory Interface"
puts "  • Control signals : 4 pins"
puts "  • Address bus     : 16 pins (addr_0 to addr_15)"
puts "  • Data input      : 8 pins (data_in_0 to data_in_7)"
puts "  • Data output     : 8 pins (data_out_0 to data_out_7)"
puts "  • Status          : 2 pins (ready, error)"
puts "  ────────────────────────────────────────"
puts "  TOTAL: 38 I/O pins\n"

# ============================================
# Step 1: Setup Design
# ============================================
puts "Step 1: Loading design..."

set TECH_LEF "resources/tech/nangate45/Nangate45.lef"
set RESULTS_DIR "phases/phase1_floorplanning/lessons/lesson02_io_placement/results"
file mkdir ${RESULTS_DIR}

read_lef ${TECH_LEF}

# Set units AFTER reading LEF
set_cmd_units -time ns -capacitance pF -current mA -voltage V -resistance kOhm -distance um

read_verilog phases/phase1_floorplanning/lessons/lesson02_io_placement/resources/mem_interface.v
link_design mem_interface

puts "  ✓ Design linked\n"

# ============================================
# Step 2: Create Floorplan
# ============================================
puts "Step 2: Creating floorplan..."

initialize_floorplan \
    -die_area "0 0 1200 1200" \
    -core_area "150 150 1050 1050" \
    -site FreePDK45_38x28_10R_NP_162NW_34O

puts "  ✓ Floorplan: 1200x1200 µm (core: 900x900 µm)\n"

# ============================================
# Step 3: Set I/O Constraints
# ============================================
puts "Step 3: Applying I/O constraints...\n"

# Control signals on TOP edge
puts "  → TOP: Control signals"
set_io_pin_constraint -pin_names {clk rst_n read_enable write_enable} -region top:*

# Address bus on LEFT edge (ordered)
puts "  → LEFT: Address bus (ordered)"
set_io_pin_constraint -pin_names {addr_*} -region left:*

# Data input on BOTTOM edge
puts "  → BOTTOM: Data input bus"
set_io_pin_constraint -pin_names {data_in_*} -region bottom:*

# Data output on RIGHT edge  
puts "  → RIGHT: Data output bus"
set_io_pin_constraint -pin_names {data_out_*} -region right:*

# Status signals on TOP edge (near control)
puts "  → TOP: Status signals"
set_io_pin_constraint -pin_names {ready error} -region top:*

puts ""

# ============================================
# Step 4: Place Pins
# ============================================
puts "Step 4: Placing pins with constraints..."

place_pins -hor_layers metal3 -ver_layers metal2

puts "  ✓ Pins placed\n"

# ============================================
# Step 5: Save and Report
# ============================================
write_def ${RESULTS_DIR}/example3_constrained.def
puts "  ✓ Saved: ${RESULTS_DIR}/example3_constrained.def"

# Report pin statistics
set total_pins [llength [get_ports *]]
puts "\n📊 Pin Placement Summary:"
puts "   Total pins placed: $total_pins"
puts "   Distribution:"
puts "     • TOP    : Control + Status (6 pins)"
puts "     • LEFT   : Address bus (16 pins)"
puts "     • BOTTOM : Data input (8 pins)"
puts "     • RIGHT  : Data output (8 pins)"

puts "\n✅ Example 3 completed successfully!\n"
puts "Next: Open in GUI to visualize the organized layout:"
puts "  or-gui ${RESULTS_DIR}/example3_constrained.def\n"

exit
