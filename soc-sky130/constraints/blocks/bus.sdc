# ==============================================================================
# SDC Constraints - Bus Interconnect Block (wb_interconnect)
# ==============================================================================
create_clock -name wb_clk_i -period 10.0 [get_ports wb_clk_i]
set_clock_uncertainty 0.5 [get_clocks wb_clk_i]
set_clock_transition 0.15 [get_clocks wb_clk_i]

# Master interface (from CPU)
set_input_delay  -clock wb_clk_i 3.0 [get_ports m_wb_adr_i[*]]
set_input_delay  -clock wb_clk_i 3.0 [get_ports m_wb_dat_i[*]]
set_input_delay  -clock wb_clk_i 3.0 [get_ports m_wb_sel_i[*]]
set_input_delay  -clock wb_clk_i 3.0 [get_ports m_wb_we_i]
set_input_delay  -clock wb_clk_i 3.0 [get_ports m_wb_stb_i]
set_input_delay  -clock wb_clk_i 3.0 [get_ports m_wb_cyc_i]
set_output_delay -clock wb_clk_i 3.0 [get_ports m_wb_dat_o[*]]
set_output_delay -clock wb_clk_i 3.0 [get_ports m_wb_ack_o]

# Slave interfaces (to peripherals) - all 5 slaves
set_output_delay -clock wb_clk_i 1.0 [get_ports s*_wb_adr_o[*]]
set_output_delay -clock wb_clk_i 1.0 [get_ports s*_wb_dat_o[*]]
set_output_delay -clock wb_clk_i 1.0 [get_ports s*_wb_sel_o[*]]
set_output_delay -clock wb_clk_i 1.0 [get_ports s*_wb_we_o]
set_output_delay -clock wb_clk_i 1.0 [get_ports s*_wb_stb_o]
set_output_delay -clock wb_clk_i 1.0 [get_ports s*_wb_cyc_o]
set_input_delay  -clock wb_clk_i 3.0 [get_ports s*_wb_dat_i[*]]
set_input_delay  -clock wb_clk_i 3.0 [get_ports s*_wb_ack_i]

set_driving_cell -lib_cell sky130_fd_sc_hd__buf_2 [all_inputs]
set_load 0.05 [all_outputs]
set_max_fanout 20 [current_design]
set_false_path -from [get_ports wb_rst_i]
