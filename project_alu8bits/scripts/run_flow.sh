#!/bin/bash

# Main script to run complete Physical Design flow
# This script executes all phases sequentially

echo "=========================================="
echo "   Physical Design Flow - ALU 8-bit"
echo "=========================================="
echo ""

# Set working directory
WORK_DIR=$(pwd)/..
DESIGN_NAME="alu_8bit"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to run a phase
run_phase() {
    phase_num=$1
    phase_name=$2
    script_file=$3
    
    echo -e "${YELLOW}>>> Phase ${phase_num}: ${phase_name}${NC}"
    
    if [ -f "${script_file}" ]; then
        openroad ${script_file}
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Phase ${phase_num} completed successfully${NC}"
        else
            echo -e "${RED}✗ Phase ${phase_num} failed${NC}"
            exit 1
        fi
    else
        echo -e "${RED}✗ Script ${script_file} not found${NC}"
        exit 1
    fi
    echo ""
}

# Execute all phases
echo "Starting Physical Design flow..."
echo ""

# TODO: Uncomment phases as they are implemented
# run_phase "01" "Synthesis" "01_synthesis.tcl"
# run_phase "02" "Floorplanning" "02_floorplan.tcl"
# run_phase "03" "Placement" "03_placement.tcl"
# run_phase "04" "Clock Tree Synthesis" "04_cts.tcl"
# run_phase "05" "Routing" "05_routing.tcl"
# run_phase "06" "Optimization" "06_optimization.tcl"
# run_phase "07" "Sign-off" "07_signoff.tcl"

echo "=========================================="
echo "   Flow execution completed!"
echo "=========================================="
echo ""
echo "Results are available in: ${WORK_DIR}/results/${DESIGN_NAME}/"
