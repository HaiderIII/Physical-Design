# KLayout Ruby script for DEF to GDSII conversion

cell_gds = ENV["CELL_GDS"]
input_def = ENV["INPUT_DEF"]
output_gds = ENV["OUTPUT_GDS"]

puts "Reading cell GDS: #{cell_gds}"
layout = RBA::Layout.new
layout.read(cell_gds)

puts "Reading DEF: #{input_def}"
layout.read(input_def)

puts "Writing GDSII: #{output_gds}"
layout.write(output_gds)

puts "Done!"
