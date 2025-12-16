# Magic script to convert DEF to GDSII

# Read standard cell GDS first
puts "Reading standard cell GDS..."
gds read /home/faiz/.volare/volare/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds

# Read LEF files
puts "Reading LEF files..."
lef read /home/faiz/.volare/volare/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef
lef read /home/faiz/.volare/volare/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef

# Read DEF file
puts "Reading DEF file..."
def read /home/faiz/projects/Physical-Design/project_alu8bits/results/alu_8bit/07_signoff/alu_8bit_final.def

# Load the design
puts "Loading design..."
load alu_8bit

# Select top cell
select top cell

# Write GDSII
puts "Writing GDSII..."
gds write /home/faiz/projects/Physical-Design/project_alu8bits/results/alu_8bit/08_gdsii/alu_8bit.gds

puts ""
puts "GDSII export complete!"

quit -noprompt
