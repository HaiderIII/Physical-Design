# Timing constraints for crossbar switch
# 100 MHz clock - typical for interconnect fabric

create_clock -name clk -period 10.0 [get_ports clk]

set_input_delay -clock clk 2.0 [get_ports {in_port*}]
set_input_delay -clock clk 2.0 [get_ports {sel_out*}]
set_input_delay -clock clk 2.0 [get_ports {valid_in*}]
set_input_delay -clock clk 1.0 [get_ports rst_n]

set_output_delay -clock clk 2.0 [get_ports {out_port*}]
set_output_delay -clock clk 2.0 [get_ports {valid_out*}]
