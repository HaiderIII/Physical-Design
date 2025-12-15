# Example 2 : Strategic I/O Pin Placement
# ========================================

puts "\n========================================="
puts "Example 2 : Strategic Pin Placement"
puts "=========================================\n"

set TECH_DIR "resources/tech/nangate45"
set RESOURCE_DIR "phases/phase1_floorplanning/lessons/lesson02_io_placement/resources"
set RESULTS_DIR "phases/phase1_floorplanning/lessons/lesson02_io_placement/examples/results"

file mkdir $RESULTS_DIR

proc reload_design {tech_dir resource_dir} {
    clear
    read_lef ${tech_dir}/Nangate45.lef
    read_liberty ${tech_dir}/Nangate45_typ.lib
    read_verilog ${resource_dir}/alu8.v
    link_design alu8
}

proc create_floorplan_with_tracks {} {
    initialize_floorplan \
        -die_area {0 0 800 800} \
        -core_area {50 50 750 750} \
        -site FreePDK45_38x28_10R_NP_162NW_34O
    
    # Add tracks based on LEF data:
    # metal1: HORIZONTAL, PITCH 0.14, OFFSET 0.07
    # metal2: VERTICAL, PITCH 0.19, OFFSET 0.095
    # metal3: HORIZONTAL, PITCH 0.28, OFFSET 0.14
    
    make_tracks metal1 -x_offset 0.07 -x_pitch 0.14 -y_offset 0.07 -y_pitch 0.14
    make_tracks metal2 -x_offset 0.095 -x_pitch 0.19 -y_offset 0.095 -y_pitch 0.19
    make_tracks metal3 -x_offset 0.14 -x_pitch 0.28 -y_offset 0.14 -y_pitch 0.28
}

# ============================================
# SCENARIO A: Random Placement (Baseline)
# ============================================
puts "\n=================================================="
puts "SCENARIO A: Random placement (baseline)"
puts "==================================================\n"

reload_design $TECH_DIR $RESOURCE_DIR
create_floorplan_with_tracks

puts "  All pins randomly distributed\n"

# metal1=horizontal, metal2=vertical (from LEF DIRECTION)
place_pins -hor_layers metal1 -ver_layers metal2 -random

write_def ${RESULTS_DIR}/example2_scenario_a.def
puts "  ✓ Saved: random placement\n"

# ============================================
# SCENARIO B: Functional Grouping
# ============================================
puts "\n=================================================="
puts "SCENARIO B: Functional grouping"
puts "==================================================\n"

reload_design $TECH_DIR $RESOURCE_DIR
create_floorplan_with_tracks

puts "  Grouping related signals by function\n"

# Data inputs on LEFT (vertical edge → metal2)
set_io_pin_constraint -pin_names {data_in[*]} -region left:*

# Results on RIGHT (vertical edge → metal2)
set_io_pin_constraint -pin_names {result[*] valid} -region right:*

# Control signals on BOTTOM (horizontal edge → metal1)
set_io_pin_constraint -pin_names {opcode[*]} -region bottom:*

# Clock/Reset on TOP (horizontal edge → metal1)
set_io_pin_constraint -pin_names {clk rst} -region top:*

place_pins -hor_layers metal1 -ver_layers metal2 -random

write_def ${RESULTS_DIR}/example2_scenario_b.def
puts "  ✓ Saved: functional grouping\n"

# ============================================
# SCENARIO C: Ordered Bus Placement
# ============================================
puts "\n=================================================="
puts "SCENARIO C: Ordered bus placement"
puts "==================================================\n"

reload_design $TECH_DIR $RESOURCE_DIR
create_floorplan_with_tracks

puts "  Buses ordered MSB→LSB for clean routing\n"

# Ordered data inputs (LEFT - vertical)
set_io_pin_constraint -pin_names {data_in[7] data_in[6] data_in[5] data_in[4] data_in[3] data_in[2] data_in[1] data_in[0]} -region left:*

# Ordered results (RIGHT - vertical)
set_io_pin_constraint -pin_names {result[7] result[6] result[5] result[4] result[3] result[2] result[1] result[0] valid} -region right:*

# Ordered opcode (BOTTOM - horizontal)
set_io_pin_constraint -pin_names {opcode[2] opcode[1] opcode[0]} -region bottom:*

# Clock/Reset (TOP - horizontal)
set_io_pin_constraint -pin_names {clk rst} -region top:*

place_pins -hor_layers metal1 -ver_layers metal2 -random

write_def ${RESULTS_DIR}/example2_scenario_c.def
puts "  ✓ Saved: ordered buses\n"

# ============================================
# Summary
# ============================================
puts "\n=================================================="
puts "Summary"
puts "==================================================\n"

puts "✓ Generated 3 placement strategies:"
puts "  A. Random uniform distribution"
puts "  B. Functional grouping (data/control/clock)"
puts "  C. Ordered buses (MSB→LSB)\n"

puts "📊 Layer assignments (from LEF DIRECTION):"
puts "  • Horizontal edges (top/bottom): metal1 (HORIZONTAL)"
puts "  • Vertical edges (left/right): metal2 (VERTICAL)\n"

puts "💡 Compare results:"
puts "  • Scenario A: Pins scattered randomly"
puts "  • Scenario B: Logical grouping by function"
puts "  • Scenario C: Bus bits ordered sequentially\n"

puts "💡 To visualize:"
puts "  openroad -gui"
puts "  read_lef resources/tech/nangate45/Nangate45.lef"
puts "  read_def phases/.../results/example2_scenario_c.def\n"

puts "✓ Example 2 completed!\n"
