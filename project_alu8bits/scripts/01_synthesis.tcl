# ============================================================================
# Phase 1: Synthesis Script
# ============================================================================
# This script performs RTL synthesis using Yosys and prepares the design
# for physical design flow in OpenROAD.
#
# Learning Objectives:
# - Understand RTL to gate-level netlist conversion
# - Learn technology mapping to standard cells
# - Practice timing constraint application
# - Analyze synthesis reports
# ============================================================================

puts "=========================================="
puts "   Phase 1: Synthesis"
puts "=========================================="
puts ""

# ============================================================================
# TODO 1: Setup Design Variables
# ============================================================================
# Define the basic design parameters that will be used throughout the script.
# These variables make the script more maintainable and reusable.
#
# TASK: Set the following variables:
# - DESIGN_NAME: Name of your top module (should be "alu_8bit")
# - PLATFORM: Technology platform (should be "sky130hd")
# - PROJECT_DIR: Root directory of the project (use: [file normalize [file dirname [info script]]/..]  )
# - RESULTS_DIR: Where to save synthesis outputs (use: ${PROJECT_DIR}/results/${DESIGN_NAME}/01_synthesis)
#
# Write your code below this line:
# --------------------------------

# TODO 1: WRITE YOUR CODE HERE

set DESIGN_NAME "alu_8bit"
set PLATFORM "sky130hd"
set PROJECT_DIR [file normalize [file dirname [info script]]/..]
set RESULTS_DIR "${PROJECT_DIR}/results/${DESIGN_NAME}/01_synthesis" 

# --------------------------------
# End of TODO 1

puts "Design: $DESIGN_NAME"
puts "Platform: $PLATFORM"
puts "Results directory: $RESULTS_DIR"
puts ""

# ============================================================================
# TODO 2: Create Output Directory
# ============================================================================
# Before running synthesis, ensure the output directory exists.
#
# TASK: Create the results directory if it doesn't exist
# HINT: Use 'file mkdir $RESULTS_DIR'
#
# Write your code below this line:
# --------------------------------

# TODO 2: WRITE YOUR CODE HERE

set ret [file mkdir $RESULTS_DIR]
if {$ret == 1} {
    puts "Created results directory: $RESULTS_DIR"
} else {
    puts "Results directory already exists: $RESULTS_DIR"
}       


# --------------------------------
# End of TODO 2

# ============================================================================
# TODO 3: Source Technology Configuration
# ============================================================================
# Load the technology-specific settings (PDK paths, library files, etc.)
#
# TASK: Source the tech_config.tcl file
# HINT: Use 'source ${PROJECT_DIR}/config/tech_config.tcl'
#
# Write your code below this line:
# --------------------------------

# TODO 3: WRITE YOUR CODE HERE
source "${PROJECT_DIR}/config/tech_config.tcl"


# --------------------------------
# End of TODO 3

puts "Technology configuration loaded"
puts ""

# ============================================================================
# TODO 4: Run Yosys Synthesis - Part A: Setup Variables
# ============================================================================
# Define paths for Yosys synthesis
#
# TASK: Set the following variables:
# - yosys_script: Path to Yosys script to be created (${RESULTS_DIR}/yosys_synthesis.ys)
# - input_rtl: Path to input RTL file (${PROJECT_DIR}/designs/${DESIGN_NAME}/rtl/${DESIGN_NAME}.v)
# - output_netlist: Path to output netlist (${RESULTS_DIR}/${DESIGN_NAME}_synth.v)
# - yosys_log: Path to Yosys log file (${RESULTS_DIR}/yosys.log)
#
# Write your code below this line:
# --------------------------------

# TODO 4A: WRITE YOUR CODE HERE
set yosys_script "${RESULTS_DIR}/yosys_synthesis.ys"
set input_rtl "${PROJECT_DIR}/designs/${DESIGN_NAME}/rtl/${DESIGN_NAME}.v"
set output_netlist "${RESULTS_DIR}/${DESIGN_NAME}_synth.v"
set yosys_log "${RESULTS_DIR}/yosys.log"    


# --------------------------------
# End of TODO 4A

# ============================================================================
# TODO 4: Run Yosys Synthesis - Part B: Create Yosys Script
# ============================================================================
# Create a Yosys script that performs synthesis
#
# LEARNING POINT: Yosys synthesis steps:
# 1. Read RTL (read_verilog)
# 2. Elaborate design (hierarchy -check -top)
# 3. Synthesize to generic gates (synth -top)
# 4. Map to technology library (dfflibmap, abc)
# 5. Cleanup (clean)
# 6. Write netlist (write_verilog -noattr)
# 7. Statistics (stat -liberty)
#
# TASK: Create the Yosys script file with the commands above
# HINT: Use 'set fp [open $yosys_script w]' then 'puts $fp "command"' then 'close $fp'
#
# Write your code below this line:
# --------------------------------

# TODO 4B: WRITE YOUR CODE HERE
# Open file for writing
# Write each Yosys command as a line
# Close file

set fp [open $yosys_script w]
puts $fp "read_verilog $input_rtl"
puts $fp "hierarchy -check -top $DESIGN_NAME"
puts $fp "synth -top $DESIGN_NAME"
puts $fp "dfflibmap -liberty $LIB_TYPICAL"
puts $fp "abc -liberty $LIB_TYPICAL"
puts $fp "clean"
puts $fp "write_verilog -noattr $output_netlist"
puts $fp "stat -liberty $LIB_TYPICAL"
close $fp


# --------------------------------
# End of TODO 4B

puts "Yosys script created: $yosys_script"

# ============================================================================
# TODO 5: Execute Yosys Synthesis
# ============================================================================
# Run Yosys with the generated script.
#
# TASK: Execute Yosys using the 'exec' command with error handling
# HINT: Use 'if {[catch {exec yosys -s $yosys_script -l $yosys_log} result]} { ... }'
#
# Write your code below this line:
# --------------------------------

puts "Running Yosys synthesis..."

# TODO 5: WRITE YOUR CODE HERE

if {[catch {exec yosys -s $yosys_script -l $yosys_log} result]} {
    puts "Error during Yosys synthesis. Check log file: $yosys_log"
    puts $result
    exit 1
}


# --------------------------------
# End of TODO 5

puts "Yosys synthesis completed successfully"
puts "Log file: $yosys_log"
puts ""

# ============================================================================
# TODO 6: Load Synthesized Design in OpenROAD
# ============================================================================
# Load the gate-level netlist into OpenROAD
#
# LEARNING POINT: OpenROAD needs these files in order:
# 1. Technology LEF (read_lef $TECH_LEF)
# 2. Standard cell LEF (read_lef $SC_LEF)
# 3. Liberty timing library (read_liberty $LIB_TYPICAL)
# 4. Synthesized netlist (read_verilog $output_netlist)
# 5. Link the design (link_design $DESIGN_NAME)
#
# TASK: Read all necessary files into OpenROAD in the correct order
#
# Write your code below this line:
# --------------------------------

puts "Loading design into OpenROAD..."

# TODO 6: WRITE YOUR CODE HERE
read_lef $TECH_LEF
read_lef $SC_LEF
read_liberty $LIB_TYPICAL
read_verilog $output_netlist
link_design $DESIGN_NAME


# --------------------------------
# End of TODO 6

puts "Design loaded successfully"
puts ""

# ============================================================================
# TODO 7: Read Timing Constraints
# ============================================================================
# Load the SDC file that contains timing constraints for the design.
#
# TASK: 
# 1. Set sdc_file variable to: ${PROJECT_DIR}/designs/${DESIGN_NAME}/constraints/${DESIGN_NAME}.sdc
# 2. Read the SDC file using 'read_sdc $sdc_file'
#
# Write your code below this line:
# --------------------------------

# TODO 7: WRITE YOUR CODE HERE

set sdc_file "${PROJECT_DIR}/designs/${DESIGN_NAME}/constraints/${DESIGN_NAME}.sdc"
read_sdc $sdc_file


# --------------------------------
# End of TODO 7

puts "Timing constraints loaded"
puts ""

# ============================================================================
# TODO 8: Check Design Integrity
# ============================================================================
# Verify that the design is properly loaded and linked.
#
# TASK: Run design checks using 'check_setup'
#
# Write your code below this line:
# --------------------------------

puts "Checking design setup..."

# TODO 8: WRITE YOUR CODE HERE

check_setup


# --------------------------------
# End of TODO 8

# ============================================================================
# TODO 9: Generate Reports
# ============================================================================
# Create timing and design statistics reports
#
# TASK: 
# Part A: Create timing report
# 1. Set timing_rpt to ${RESULTS_DIR}/timing_report.txt
# 2. Use: report_checks -path_delay min_max -format full_clock_expanded > $timing_rpt
#
# Part B: Create design statistics report
# 1. Set stats_rpt to ${RESULTS_DIR}/design_stats.txt
# 2. Use: report_design_area > $stats_rpt
#
# Write your code below this line:
# --------------------------------

puts ""
puts "Generating reports..."

# TODO 9: WRITE YOUR CODE HERE

# Part A: Timing report
set timing_rpt "${RESULTS_DIR}/timing_report.txt"
report_checks -path_delay min_max -format full_clock_expanded > $timing_rpt
# Part B: Design statistics report
set stats_rpt "${RESULTS_DIR}/design_stats.txt"
report_design_area > $stats_rpt


# --------------------------------
# End of TODO 9

puts "Timing report: $timing_rpt"
puts "Design statistics: $stats_rpt"

# ============================================================================
# TODO 10: Save Design Database
# ============================================================================
# Save the current design state to OpenROAD database format (.odb).
#
# TASK:
# 1. Set odb_file to ${RESULTS_DIR}/${DESIGN_NAME}.odb
# 2. Write database using 'write_db $odb_file'
# 3. Set def_file to ${RESULTS_DIR}/${DESIGN_NAME}.def
# 4. Write DEF using 'write_def $def_file'
#
# Write your code below this line:
# --------------------------------

# TODO 10: WRITE YOUR CODE HERE

set odb_file "${RESULTS_DIR}/${DESIGN_NAME}.odb"
write_db $odb_file
set def_file "${RESULTS_DIR}/${DESIGN_NAME}.def"
write_def $def_file


# --------------------------------
# End of TODO 10

puts "Design database saved: $odb_file"
puts "DEF file saved: $def_file"
puts ""

# ============================================================================
# Summary
# ============================================================================

puts "=========================================="
puts "   Synthesis Phase Completed!"
puts "=========================================="
puts ""
puts "Output Files:"
puts "  - Netlist: $output_netlist"
puts "  - Database: $odb_file"
puts "  - DEF: $def_file"
puts "  - Timing Report: $timing_rpt"
puts "  - Statistics: $stats_rpt"
puts "  - Yosys Log: $yosys_log"
puts ""
puts "Next Phase: Floorplanning"
puts ""

exit
