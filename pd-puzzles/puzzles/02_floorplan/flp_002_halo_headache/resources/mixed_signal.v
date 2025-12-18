// Mixed-Signal Top Module with Analog Macro Instances
// Gate-level netlist for Sky130

module mixed_signal_top (
    input  wire clk,
    input  wire rst_n,
    input  wire [7:0] digital_in,
    input  wire analog_ctrl,
    output wire [7:0] digital_out,
    output wire analog_out_0,
    output wire analog_out_1
);

    // Internal signals
    wire [7:0] processed_data;
    wire [7:0] reg_data;
    wire ctrl_sync;
    wire enable;

    // Analog macro output wires
    wire aout0, aout1;

    //=========================================================================
    // Digital Processing Logic
    //=========================================================================

    // Input synchronizer for analog control
    wire ctrl_d1, ctrl_d2;
    sky130_fd_sc_hd__dfrtp_1 u_sync1 (.CLK(clk), .RESET_B(rst_n), .D(analog_ctrl), .Q(ctrl_d1));
    sky130_fd_sc_hd__dfrtp_1 u_sync2 (.CLK(clk), .RESET_B(rst_n), .D(ctrl_d1), .Q(ctrl_sync));

    // Enable logic
    sky130_fd_sc_hd__and2_1 u_enable (
        .A(ctrl_sync),
        .B(rst_n),
        .X(enable)
    );

    // Data processing pipeline - Stage 1: Input registers
    sky130_fd_sc_hd__dfrtp_1 u_in_reg0 (.CLK(clk), .RESET_B(rst_n), .D(digital_in[0]), .Q(reg_data[0]));
    sky130_fd_sc_hd__dfrtp_1 u_in_reg1 (.CLK(clk), .RESET_B(rst_n), .D(digital_in[1]), .Q(reg_data[1]));
    sky130_fd_sc_hd__dfrtp_1 u_in_reg2 (.CLK(clk), .RESET_B(rst_n), .D(digital_in[2]), .Q(reg_data[2]));
    sky130_fd_sc_hd__dfrtp_1 u_in_reg3 (.CLK(clk), .RESET_B(rst_n), .D(digital_in[3]), .Q(reg_data[3]));
    sky130_fd_sc_hd__dfrtp_1 u_in_reg4 (.CLK(clk), .RESET_B(rst_n), .D(digital_in[4]), .Q(reg_data[4]));
    sky130_fd_sc_hd__dfrtp_1 u_in_reg5 (.CLK(clk), .RESET_B(rst_n), .D(digital_in[5]), .Q(reg_data[5]));
    sky130_fd_sc_hd__dfrtp_1 u_in_reg6 (.CLK(clk), .RESET_B(rst_n), .D(digital_in[6]), .Q(reg_data[6]));
    sky130_fd_sc_hd__dfrtp_1 u_in_reg7 (.CLK(clk), .RESET_B(rst_n), .D(digital_in[7]), .Q(reg_data[7]));

    // Stage 2: XOR processing with enable
    wire [7:0] xor_out;
    sky130_fd_sc_hd__xor2_1 u_xor0 (.A(reg_data[0]), .B(enable), .X(xor_out[0]));
    sky130_fd_sc_hd__xor2_1 u_xor1 (.A(reg_data[1]), .B(enable), .X(xor_out[1]));
    sky130_fd_sc_hd__xor2_1 u_xor2 (.A(reg_data[2]), .B(enable), .X(xor_out[2]));
    sky130_fd_sc_hd__xor2_1 u_xor3 (.A(reg_data[3]), .B(enable), .X(xor_out[3]));
    sky130_fd_sc_hd__xor2_1 u_xor4 (.A(reg_data[4]), .B(enable), .X(xor_out[4]));
    sky130_fd_sc_hd__xor2_1 u_xor5 (.A(reg_data[5]), .B(enable), .X(xor_out[5]));
    sky130_fd_sc_hd__xor2_1 u_xor6 (.A(reg_data[6]), .B(enable), .X(xor_out[6]));
    sky130_fd_sc_hd__xor2_1 u_xor7 (.A(reg_data[7]), .B(enable), .X(xor_out[7]));

    // Stage 3: Output registers
    sky130_fd_sc_hd__dfrtp_1 u_out_reg0 (.CLK(clk), .RESET_B(rst_n), .D(xor_out[0]), .Q(processed_data[0]));
    sky130_fd_sc_hd__dfrtp_1 u_out_reg1 (.CLK(clk), .RESET_B(rst_n), .D(xor_out[1]), .Q(processed_data[1]));
    sky130_fd_sc_hd__dfrtp_1 u_out_reg2 (.CLK(clk), .RESET_B(rst_n), .D(xor_out[2]), .Q(processed_data[2]));
    sky130_fd_sc_hd__dfrtp_1 u_out_reg3 (.CLK(clk), .RESET_B(rst_n), .D(xor_out[3]), .Q(processed_data[3]));
    sky130_fd_sc_hd__dfrtp_1 u_out_reg4 (.CLK(clk), .RESET_B(rst_n), .D(xor_out[4]), .Q(processed_data[4]));
    sky130_fd_sc_hd__dfrtp_1 u_out_reg5 (.CLK(clk), .RESET_B(rst_n), .D(xor_out[5]), .Q(processed_data[5]));
    sky130_fd_sc_hd__dfrtp_1 u_out_reg6 (.CLK(clk), .RESET_B(rst_n), .D(xor_out[6]), .Q(processed_data[6]));
    sky130_fd_sc_hd__dfrtp_1 u_out_reg7 (.CLK(clk), .RESET_B(rst_n), .D(xor_out[7]), .Q(processed_data[7]));

    // Output buffers
    sky130_fd_sc_hd__buf_2 u_obuf0 (.A(processed_data[0]), .X(digital_out[0]));
    sky130_fd_sc_hd__buf_2 u_obuf1 (.A(processed_data[1]), .X(digital_out[1]));
    sky130_fd_sc_hd__buf_2 u_obuf2 (.A(processed_data[2]), .X(digital_out[2]));
    sky130_fd_sc_hd__buf_2 u_obuf3 (.A(processed_data[3]), .X(digital_out[3]));
    sky130_fd_sc_hd__buf_2 u_obuf4 (.A(processed_data[4]), .X(digital_out[4]));
    sky130_fd_sc_hd__buf_2 u_obuf5 (.A(processed_data[5]), .X(digital_out[5]));
    sky130_fd_sc_hd__buf_2 u_obuf6 (.A(processed_data[6]), .X(digital_out[6]));
    sky130_fd_sc_hd__buf_2 u_obuf7 (.A(processed_data[7]), .X(digital_out[7]));

    //=========================================================================
    // Analog Macro Instances (Black Boxes)
    //=========================================================================

    // Analog Block 0: Connected to lower 4 bits
    analog_macro ANALOG_BLOCK_0 (
        .clk(clk),
        .enable(enable),
        .data_in(processed_data[3:0]),
        .analog_out(aout0)
    );

    // Analog Block 1: Connected to upper 4 bits
    analog_macro ANALOG_BLOCK_1 (
        .clk(clk),
        .enable(enable),
        .data_in(processed_data[7:4]),
        .analog_out(aout1)
    );

    // Analog output buffers
    sky130_fd_sc_hd__buf_4 u_aout0_buf (.A(aout0), .X(analog_out_0));
    sky130_fd_sc_hd__buf_4 u_aout1_buf (.A(aout1), .X(analog_out_1));

endmodule
