# ==============================================================================
# SDC Constraints - GPIO Block (gpio_wb)
# ==============================================================================
create_clock -name wb_clk_i -period 10.0 [get_ports wb_clk_i]
set_clock_uncertainty 0.5 [get_clocks wb_clk_i]
set_clock_transition 0.15 [get_clocks wb_clk_i]

# Wishbone slave port
set_input_delay  -clock wb_clk_i 3.0 [get_ports wb_adr_i[*]]
set_input_delay  -clock wb_clk_i 3.0 [get_ports wb_dat_i[*]]
set_input_delay  -clock wb_clk_i 3.0 [get_ports wb_sel_i[*]]
set_input_delay  -clock wb_clk_i 3.0 [get_ports wb_we_i]
set_input_delay  -clock wb_clk_i 3.0 [get_ports wb_stb_i]
set_input_delay  -clock wb_clk_i 3.0 [get_ports wb_cyc_i]
set_output_delay -clock wb_clk_i 3.0 [get_ports wb_dat_o[*]]
set_output_delay -clock wb_clk_i 3.0 [get_ports wb_ack_o]

# External GPIO pins
set_input_delay  -clock wb_clk_i 5.0 [get_ports gpio_in[*]]
set_output_delay -clock wb_clk_i 5.0 [get_ports gpio_out[*]]
set_output_delay -clock wb_clk_i 5.0 [get_ports gpio_oe[*]]
set_output_delay -clock wb_clk_i 5.0 [get_ports irq]

set_driving_cell -lib_cell sky130_fd_sc_hd__buf_2 [all_inputs]
set_load 0.05 [all_outputs]
set_max_fanout 20 [current_design]
set_false_path -from [get_ports wb_rst_i]
