# SDC Constraints for Datapath - Sky130HD
# Target: 100 MHz

create_clock -name clk -period 10.0 [get_ports clk]

set_input_delay -clock clk 2.0 [get_ports {rst_n load data_in[*]}]
set_output_delay -clock clk 2.0 [get_ports data_out[*]]
