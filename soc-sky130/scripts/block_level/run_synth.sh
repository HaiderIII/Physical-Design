#!/bin/bash
# ============================================================================
# Block-Level Synthesis Runner
# ============================================================================
# Usage: ./run_synth.sh <block_name>
#        ./run_synth.sh all
#
# Available blocks: cpu, uart, spi, timer, gpio, bus, top
# ============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
RTL_DIR="$PROJECT_DIR/rtl"

# Sky130 paths
export SKY130_LIB="$HOME/OpenROAD-flow-scripts/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
export SRAM_LIB="$HOME/OpenROAD-flow-scripts/flow/platforms/sky130ram/sky130_sram_1rw1r_128x256_8/sky130_sram_1rw1r_128x256_8_TT_1p8V_25C.lib"
export SRAM_V="$HOME/OpenROAD-flow-scripts/flow/platforms/sky130ram/sky130_sram_1rw1r_128x256_8/sky130_sram_1rw1r_128x256_8.v"

# Check dependencies
if [ ! -f "$SKY130_LIB" ]; then
    echo "ERROR: Sky130 liberty not found at $SKY130_LIB"
    echo "Please install OpenROAD-flow-scripts"
    exit 1
fi

# Generate Yosys script for a specific block
generate_script() {
    local BLOCK=$1
    local OUTPUT_DIR="$PROJECT_DIR/blocks/$BLOCK/results"
    local SCRIPT_FILE="$OUTPUT_DIR/synth_$BLOCK.ys"

    mkdir -p "$OUTPUT_DIR"

    case $BLOCK in
        cpu)
            TOP_MODULE="cpu_wb_wrapper"
            RTL_FILES="read_verilog -sv $RTL_DIR/core/riscv_pkg.v
read_verilog -sv $RTL_DIR/core/register_file.v
read_verilog -sv $RTL_DIR/core/alu.v
read_verilog -sv $RTL_DIR/core/decoder.v
read_verilog -sv $RTL_DIR/core/branch_unit.v
read_verilog -sv $RTL_DIR/core/hazard_unit.v
read_verilog -sv $RTL_DIR/core/memory_controller.v
read_verilog -sv $RTL_DIR/core/pipeline_registers.v
read_verilog -sv $RTL_DIR/core/riscv_core.v
read_verilog -sv $RTL_DIR/core/cpu_wb_wrapper.v"
            SRAM_LIB_LINE=""
            SRAM_VERILOG_LINE=""
            BLACKBOX_LINE=""
            ;;

        uart)
            TOP_MODULE="uart_wb"
            RTL_FILES="read_verilog -sv $RTL_DIR/peripherals/uart_wb/uart_wb.v"
            SRAM_LIB_LINE=""
            SRAM_VERILOG_LINE=""
            BLACKBOX_LINE=""
            ;;

        spi)
            TOP_MODULE="spi_wb"
            RTL_FILES="read_verilog -sv $RTL_DIR/peripherals/spi_wb/spi_wb.v"
            SRAM_LIB_LINE=""
            SRAM_VERILOG_LINE=""
            BLACKBOX_LINE=""
            ;;

        timer)
            TOP_MODULE="timer_wb"
            RTL_FILES="read_verilog -sv $RTL_DIR/peripherals/timer_wb/timer_wb.v"
            SRAM_LIB_LINE=""
            SRAM_VERILOG_LINE=""
            BLACKBOX_LINE=""
            ;;

        gpio)
            TOP_MODULE="gpio_wb"
            RTL_FILES="read_verilog -sv $RTL_DIR/peripherals/gpio_wb/gpio_wb.v"
            SRAM_LIB_LINE=""
            SRAM_VERILOG_LINE=""
            BLACKBOX_LINE=""
            ;;

        bus)
            TOP_MODULE="wb_interconnect"
            RTL_FILES="read_verilog -sv $RTL_DIR/bus/wb_interconnect.v"
            SRAM_LIB_LINE=""
            SRAM_VERILOG_LINE=""
            BLACKBOX_LINE=""
            ;;

        dmem)
            TOP_MODULE="dmem_wb_wrapper"
            RTL_FILES="read_verilog -sv $RTL_DIR/core/sram_wrapper_4kb.v
read_verilog -sv $RTL_DIR/bus/dmem_wb_wrapper.v"
            SRAM_LIB_LINE="read_liberty -lib $SRAM_LIB"
            SRAM_VERILOG_LINE="read_verilog $SRAM_V"
            BLACKBOX_LINE="setattr -mod -set blackbox 1 sky130_sram_1rw1r_128x256_8"
            ;;

        top)
            OUTPUT_DIR="$PROJECT_DIR/results"
            mkdir -p "$OUTPUT_DIR"
            SCRIPT_FILE="$OUTPUT_DIR/synth_soc_top.ys"
            TOP_MODULE="soc_top"
            RTL_FILES="read_verilog -sv $RTL_DIR/core/riscv_pkg.v
read_verilog -sv $RTL_DIR/core/register_file.v
read_verilog -sv $RTL_DIR/core/alu.v
read_verilog -sv $RTL_DIR/core/decoder.v
read_verilog -sv $RTL_DIR/core/branch_unit.v
read_verilog -sv $RTL_DIR/core/hazard_unit.v
read_verilog -sv $RTL_DIR/core/memory_controller.v
read_verilog -sv $RTL_DIR/core/pipeline_registers.v
read_verilog -sv $RTL_DIR/core/riscv_core.v
read_verilog -sv $RTL_DIR/core/cpu_wb_wrapper.v
read_verilog -sv $RTL_DIR/core/sram_wrapper_4kb.v
read_verilog -sv $RTL_DIR/bus/wb_interconnect.v
read_verilog -sv $RTL_DIR/bus/dmem_wb_wrapper.v
read_verilog -sv $RTL_DIR/peripherals/uart_wb/uart_wb.v
read_verilog -sv $RTL_DIR/peripherals/spi_wb/spi_wb.v
read_verilog -sv $RTL_DIR/peripherals/timer_wb/timer_wb.v
read_verilog -sv $RTL_DIR/peripherals/gpio_wb/gpio_wb.v
read_verilog -sv $RTL_DIR/soc_top.v"
            SRAM_LIB_LINE="read_liberty -lib $SRAM_LIB"
            SRAM_VERILOG_LINE="read_verilog $SRAM_V"
            BLACKBOX_LINE="setattr -mod -set blackbox 1 sky130_sram_1rw1r_128x256_8"
            ;;

        *)
            echo "ERROR: Unknown block '$BLOCK'"
            echo "Available: cpu, uart, spi, timer, gpio, bus, dmem, top"
            exit 1
            ;;
    esac

    # Generate the Yosys script (non-TCL mode with -s flag)
    cat > "$SCRIPT_FILE" <<YOSYS_SCRIPT
# ============================================================================
# Synthesis Script for $BLOCK ($TOP_MODULE)
# Generated by run_synth.sh
# ============================================================================

# Step 1: Read Liberty files
read_liberty -lib $SKY130_LIB
$SRAM_LIB_LINE

# Step 2: Read RTL design
$RTL_FILES
$SRAM_VERILOG_LINE

# Step 3: Elaborate design
hierarchy -check -top $TOP_MODULE

# Step 4: Blackbox SRAM macros
$BLACKBOX_LINE

# Step 5: Synthesis
synth -top $TOP_MODULE

# Step 6: Technology mapping
dfflibmap -liberty $SKY130_LIB
abc -liberty $SKY130_LIB

# Step 7: Clean up
opt_clean -purge

# Step 8: Write netlist
write_verilog -noattr $OUTPUT_DIR/${TOP_MODULE}_synth.v

# Step 9: Statistics
stat -liberty $SKY130_LIB
tee -o $OUTPUT_DIR/${TOP_MODULE}_stats.txt stat -liberty $SKY130_LIB
YOSYS_SCRIPT

    echo "$SCRIPT_FILE"
}

# Run synthesis for a block
run_synth() {
    local BLOCK=$1
    echo ""
    echo "=============================================="
    echo "  Synthesizing: $BLOCK"
    echo "=============================================="

    SCRIPT_FILE=$(generate_script "$BLOCK")

    cd "$PROJECT_DIR"
    yosys -s "$SCRIPT_FILE" 2>&1 | tee "${SCRIPT_FILE%.ys}.log"

    echo ""
    echo "  Done: $BLOCK"
    echo "  Netlist: $(dirname "$SCRIPT_FILE")/*_synth.v"
    echo "  Stats:   $(dirname "$SCRIPT_FILE")/*_stats.txt"
    echo "=============================================="
}

# Main
if [ $# -eq 0 ]; then
    echo "Usage: $0 <block_name|all>"
    echo "Blocks: cpu, uart, spi, timer, gpio, bus, dmem, top"
    exit 1
fi

if [ "$1" = "all" ]; then
    for block in cpu uart spi timer gpio bus dmem; do
        run_synth "$block"
    done
    echo ""
    echo "All blocks synthesized!"
else
    run_synth "$1"
fi
