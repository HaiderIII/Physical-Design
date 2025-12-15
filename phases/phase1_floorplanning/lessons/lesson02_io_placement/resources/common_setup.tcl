# ===========================================================================
# Common Setup for I/O Placement Examples
# ===========================================================================

# Technology files
set TECH_LEF "resources/tech/nangate45/Nangate45.lef"

# Results directory
set RESULTS_DIR "phases/phase1_floorplanning/lessons/lesson02_io_placement/results"

# Create results directory if it doesn't exist
file mkdir ${RESULTS_DIR}

# Set command units (required before floorplan commands)
set_cmd_units -time ns -capacitance pF -current mA -voltage V -resistance kOhm -distance um

puts "📁 Setup:"
puts "   Tech LEF: ${TECH_LEF}"
puts "   Results:  ${RESULTS_DIR}"
puts "   Units:    distance=µm, time=ns"
puts ""
