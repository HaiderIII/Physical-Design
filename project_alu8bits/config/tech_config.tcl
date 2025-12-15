# Configuration de la technologie Sky130

# Chemin vers le PDK Sky130
set PDK_ROOT $::env(HOME)/.volare/volare/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A

# Librairie standard cells (High Density)
set LIB_PATH ${PDK_ROOT}/libs.ref/sky130_fd_sc_hd/lib
set LEF_PATH ${PDK_ROOT}/libs.ref/sky130_fd_sc_hd/lef
set TECHLEF_PATH ${PDK_ROOT}/libs.ref/sky130_fd_sc_hd/techlef

# Fichiers de librairie
set LIB_TYPICAL ${LIB_PATH}/sky130_fd_sc_hd__tt_025C_1v80.lib
set LIB_FAST ${LIB_PATH}/sky130_fd_sc_hd__ff_100C_1v95.lib
set LIB_SLOW ${LIB_PATH}/sky130_fd_sc_hd__ss_100C_1v60.lib

# Fichiers LEF
set TECH_LEF ${TECHLEF_PATH}/sky130_fd_sc_hd__nom.tlef
set SC_LEF ${LEF_PATH}/sky130_fd_sc_hd.lef

puts "Technology: Sky130A - 130nm"
puts "Library: sky130_fd_sc_hd (High Density)"
puts "Typical Liberty: $LIB_TYPICAL"
puts "Tech LEF: $TECH_LEF"
puts "Standard Cell LEF: $SC_LEF"

