# Example 1 : Placement basique de pins I/O
# ==========================================

puts "\n========================================="
puts "Example 1 : Basic I/O Pin Placement"
puts "=========================================\n"

# Configuration des chemins
set TECH_DIR "/work/resources/tech/nangate45"
set RESOURCE_DIR "/work/phases/phase1_floorplanning/lessons/lesson02_io_placement/resources"
set RESULTS_DIR "/work/phases/phase1_floorplanning/lessons/lesson02_io_placement/examples/results"

file mkdir $RESULTS_DIR

# Step 1: Charger la technologie
puts "Step 1: Loading technology files..."
read_lef ${TECH_DIR}/Nangate45.lef
puts "  ✓ Technology LEF loaded: Nangate45"

read_liberty ${TECH_DIR}/Nangate45_typ.lib
puts "  ✓ Liberty timing library loaded"

# Step 2: Charger le design
puts "\nStep 2: Loading design netlist..."
read_verilog ${RESOURCE_DIR}/adder4.v
link_design adder4
puts "  ✓ Design 'adder4' linked successfully"

# Step 3: Lister les ports disponibles
puts "\nStep 3: Reporting ports..."
set port_count [llength [get_ports *]]
puts "  → Total ports: $port_count"

puts "\n  Port details:"
puts "  ┌──────────────┬───────────┐"
puts "  │ Port Name    │ Direction │"
puts "  ├──────────────┼───────────┤"
foreach port [get_ports *] {
    set port_name [get_property $port full_name]
    set direction [get_property $port direction]
    puts [format "  │ %-12s │ %-9s │" $port_name $direction]
}
puts "  └──────────────┴───────────┘"

# Step 4: Créer le floorplan avec tracks explicites
puts "\nStep 4: Creating floorplan..."
initialize_floorplan \
    -die_area {0 0 500 500} \
    -core_area {50 50 450 450} \
    -site FreePDK45_38x28_10R_NP_162NW_34O

# Ajouter les tracks manuellement
puts "  → Adding routing tracks..."
make_tracks metal1 -x_offset 0 -x_pitch 0.19 -y_offset 0 -y_pitch 0.19
make_tracks metal2 -x_offset 0 -x_pitch 0.19 -y_offset 0 -y_pitch 0.19
make_tracks metal3 -x_offset 0 -x_pitch 0.19 -y_offset 0 -y_pitch 0.19

puts "  ✓ Die area: 500x500 µm²"
puts "  ✓ Core area: 400x400 µm² (50µm offset)"

# Step 5: Placer les pins I/O
puts "\nStep 5: Placing I/O pins (random strategy)..."
place_pins \
    -hor_layers metal3 \
    -ver_layers metal2 \
    -random \
    -random_seed 42

puts "  ✓ Pin placement completed"

# Step 6: Rapport
puts "\nStep 6: Design area report..."
report_design_area

# Step 7: Sauvegarder
puts "\nStep 7: Exporting results..."
write_def ${RESULTS_DIR}/example1_output.def
write_db ${RESULTS_DIR}/example1_output.odb
puts "  ✓ Saved: ${RESULTS_DIR}/example1_output.def"
puts "  ✓ Saved: ${RESULTS_DIR}/example1_output.odb"

puts "\n========================================="
puts "Example 1 completed successfully!"
puts "=========================================\n"
