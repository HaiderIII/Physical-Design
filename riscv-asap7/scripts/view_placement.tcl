# Script to view Phase 4 Placement in OpenROAD GUI
# Run with: openroad -gui scripts/view_placement.tcl

set script_dir [file dirname [file normalize [info script]]]
set project_dir [file dirname $script_dir]
set platform_dir "$::env(HOME)/OpenROAD-flow-scripts/flow/platforms/asap7"

# Load LEF
read_lef $platform_dir/lef/asap7_tech_1x_201209.lef
read_lef $platform_dir/lef/asap7sc7p5t_28_R_1x_220121a.lef

# Load DEF
read_def $project_dir/results/riscv_soc/03_placement/riscv_soc_placed.def

puts "=========================================="
puts "Phase 4: Placement loaded"
puts "=========================================="
puts ""
puts "To save screenshot:"
puts "  1. Use View menu to adjust zoom"
puts "  2. File -> Save Image (or gui::save_image filename.png)"
puts ""
puts "Save to: $project_dir/docs/images/03_placement/"
