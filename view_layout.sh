#!/bin/bash
# Script pour visualiser un DEF dans KLayout avec les LEF Sky130
# Usage: ./view_layout.sh <fichier.def>

DEF_FILE="$1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
RESULTS_DIR="$SCRIPT_DIR/riscv-sky130/results"

if [ -z "$DEF_FILE" ]; then
    echo "Usage: ./view_layout.sh <fichier.def>"
    echo "Exemple: ./view_layout.sh riscv-sky130/results/riscv_soc/03_placement/riscv_soc_placement.def"
    exit 1
fi

# Convertir en chemin absolu si necessaire
if [[ "$DEF_FILE" != /* ]]; then
    DEF_FILE="$SCRIPT_DIR/$DEF_FILE"
fi

# Creer un script Ruby pour charger LEF/DEF
RUBY_SCRIPT="/tmp/klayout_load_$$.rb"
cat > "$RUBY_SCRIPT" << RUBY_EOF
# KLayout Ruby script pour charger LEF/DEF Sky130

lef_files = [
  "$RESULTS_DIR/sky130_fd_sc_hd_tech.lef",
  "$RESULTS_DIR/sky130_fd_sc_hd_merged.lef",
  "$RESULTS_DIR/sky130_sram_1rw1r_128x256_8.lef"
]
def_file = "$DEF_FILE"

# Options pour LEF/DEF
opt = RBA::LoadLayoutOptions.new
lefdef = opt.lefdef_config
lef_files.each { |f| lefdef.lef_files = lefdef.lef_files + [f] if File.exist?(f) }

# Charger le layout
main_window = RBA::Application.instance.main_window
view = main_window.load_layout(def_file, opt, 1)
main_window.current_view.zoom_fit
RUBY_EOF

echo "Lancement de KLayout avec le DEF: $DEF_FILE"

# Lancer KLayout avec le script Ruby
/Applications/klayout.app/Contents/MacOS/klayout -rm "$RUBY_SCRIPT" 2>/dev/null &
