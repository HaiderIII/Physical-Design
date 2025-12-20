# Timing constraints for data processor
# Aggressive 200 MHz clock for timing stress

create_clock -name clk -period 5.0 [get_ports clk]

set_input_delay -clock clk 1.0 [get_ports {data_in[*]}]
set_input_delay -clock clk 1.0 [get_ports {opcode[*]}]
set_input_delay -clock clk 1.0 [get_ports valid_in]
set_input_delay -clock clk 0.5 [get_ports rst_n]

set_output_delay -clock clk 1.0 [get_ports {data_out[*]}]
set_output_delay -clock clk 1.0 [get_ports valid_out]
set_output_delay -clock clk 1.0 [get_ports overflow]

set_max_transition 0.3 [get_clocks clk]
set_max_transition 1.0 [current_design]
