# ==============================================================================
# SDC Constraints - CPU Block (cpu_wb_wrapper)
# ==============================================================================
# Block-level constraints for hierarchical PD
# Target: 100 MHz (10 ns period)
# ==============================================================================

create_clock -name clk -period 10.0 [get_ports clk]
set_clock_uncertainty 0.5 [get_clocks clk]
set_clock_transition 0.15 [get_clocks clk]

# IMEM port (direct connection, tight timing)
set_input_delay  -clock clk 1.5 [get_ports imem_rdata[*]]
set_output_delay -clock clk 1.5 [get_ports imem_addr[*]]

# Wishbone master port (timing budget: 3ns for bus + slave)
set_input_delay  -clock clk 3.0 [get_ports wb_dat_i[*]]
set_input_delay  -clock clk 3.0 [get_ports wb_ack_i]
set_output_delay -clock clk 3.0 [get_ports wb_adr_o[*]]
set_output_delay -clock clk 3.0 [get_ports wb_dat_o[*]]
set_output_delay -clock clk 3.0 [get_ports wb_sel_o[*]]
set_output_delay -clock clk 3.0 [get_ports wb_we_o]
set_output_delay -clock clk 3.0 [get_ports wb_stb_o]
set_output_delay -clock clk 3.0 [get_ports wb_cyc_o]

set_driving_cell -lib_cell sky130_fd_sc_hd__buf_2 [all_inputs]
set_load 0.05 [all_outputs]
set_max_fanout 20 [current_design]
set_false_path -from [get_ports rst_n]
