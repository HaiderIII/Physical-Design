# Script to view Phase 5 CTS in OpenROAD GUI
# Run with: openroad -gui scripts/view_cts.tcl

set script_dir [file dirname [file normalize [info script]]]
set project_dir [file dirname $script_dir]
set platform_dir "$::env(HOME)/OpenROAD-flow-scripts/flow/platforms/asap7"

# Load LEF
read_lef $platform_dir/lef/asap7_tech_1x_201209.lef
read_lef $platform_dir/lef/asap7sc7p5t_28_R_1x_220121a.lef

# Load DEF
read_def $project_dir/results/riscv_soc/04_cts/riscv_soc_cts.def

puts "=========================================="
puts "Phase 5: CTS loaded"
puts "=========================================="
puts ""
puts "To view clock tree:"
puts "  1. Display -> Clock Tree Visualizer"
puts "  2. Or: View -> Timing -> Clock Tree"
puts ""
puts "To save screenshot:"
puts "  1. Use View menu to adjust zoom"
puts "  2. File -> Save Image (or gui::save_image filename.png)"
puts ""
puts "Save to: $project_dir/docs/images/04_cts/"
