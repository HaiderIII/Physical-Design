#!/bin/bash
echo "=========================================="
echo "   GDSII Export (KLayout)"
echo "=========================================="

DESIGN_NAME="alu_8bit"
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SIGNOFF_DIR="${PROJECT_DIR}/results/${DESIGN_NAME}/07_signoff"
GDSII_DIR="${PROJECT_DIR}/results/${DESIGN_NAME}/08_gdsii"
PDK_ROOT="/home/faiz/.volare/volare/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A"

mkdir -p ${GDSII_DIR}

echo "Input DEF: ${SIGNOFF_DIR}/${DESIGN_NAME}_final.def"
echo "Output: ${GDSII_DIR}/${DESIGN_NAME}.gds"

export CELL_GDS="${PDK_ROOT}/libs.ref/sky130_fd_sc_hd/gds/sky130_fd_sc_hd.gds"
export INPUT_DEF="${SIGNOFF_DIR}/${DESIGN_NAME}_final.def"
export OUTPUT_GDS="${GDSII_DIR}/${DESIGN_NAME}.gds"

klayout -b -r ${PROJECT_DIR}/scripts/def2gds.rb

if [ -s "${GDSII_DIR}/${DESIGN_NAME}.gds" ]; then
    echo ""
    echo "SUCCESS: GDSII file generated!"
    ls -lh ${GDSII_DIR}/${DESIGN_NAME}.gds
    echo ""
    echo "View with: klayout ${GDSII_DIR}/${DESIGN_NAME}.gds"
else
    echo "FAILED: GDSII not generated"
fi
