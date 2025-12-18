# Timing constraints for SPI Controller
# Target frequency: 100 MHz (10ns period)

# Create main clock
create_clock -name clk -period 10.0 [get_ports clk]

# Clock uncertainty (jitter + skew estimate)
set_clock_uncertainty 0.3 [get_clocks clk]

# Input delays (from external SPI master perspective)
set_input_delay -clock clk -max 3.0 [get_ports {spi_start tx_data[*]}]
set_input_delay -clock clk -min 0.5 [get_ports {spi_start tx_data[*]}]

# Output delays (to external SPI slave)
set_output_delay -clock clk -max 3.0 [get_ports {spi_clk spi_mosi spi_cs_n busy rx_data[*]}]
set_output_delay -clock clk -min 0.5 [get_ports {spi_clk spi_mosi spi_cs_n busy rx_data[*]}]

# Reset is asynchronous but we still constrain it
set_input_delay -clock clk -max 2.0 [get_ports rst_n]

# Driving cell and load assumptions
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 [all_inputs]
set_load 0.05 [all_outputs]
