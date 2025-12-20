// Datapath - Pre-synthesized Sky130HD netlist
// For placement blockage puzzle

module datapath (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    input  wire        load,
    output wire [7:0]  data_out
);

    wire [7:0] reg_q;
    wire [7:0] mux_out;

    // Input mux: load ? data_in : reg_q
    sky130_fd_sc_hd__mux2_1 mux0 (.A0(reg_q[0]), .A1(data_in[0]), .S(load), .X(mux_out[0]));
    sky130_fd_sc_hd__mux2_1 mux1 (.A0(reg_q[1]), .A1(data_in[1]), .S(load), .X(mux_out[1]));
    sky130_fd_sc_hd__mux2_1 mux2 (.A0(reg_q[2]), .A1(data_in[2]), .S(load), .X(mux_out[2]));
    sky130_fd_sc_hd__mux2_1 mux3 (.A0(reg_q[3]), .A1(data_in[3]), .S(load), .X(mux_out[3]));
    sky130_fd_sc_hd__mux2_1 mux4 (.A0(reg_q[4]), .A1(data_in[4]), .S(load), .X(mux_out[4]));
    sky130_fd_sc_hd__mux2_1 mux5 (.A0(reg_q[5]), .A1(data_in[5]), .S(load), .X(mux_out[5]));
    sky130_fd_sc_hd__mux2_1 mux6 (.A0(reg_q[6]), .A1(data_in[6]), .S(load), .X(mux_out[6]));
    sky130_fd_sc_hd__mux2_1 mux7 (.A0(reg_q[7]), .A1(data_in[7]), .S(load), .X(mux_out[7]));

    // Register
    sky130_fd_sc_hd__dfrtp_1 ff0 (.D(mux_out[0]), .CLK(clk), .RESET_B(rst_n), .Q(reg_q[0]));
    sky130_fd_sc_hd__dfrtp_1 ff1 (.D(mux_out[1]), .CLK(clk), .RESET_B(rst_n), .Q(reg_q[1]));
    sky130_fd_sc_hd__dfrtp_1 ff2 (.D(mux_out[2]), .CLK(clk), .RESET_B(rst_n), .Q(reg_q[2]));
    sky130_fd_sc_hd__dfrtp_1 ff3 (.D(mux_out[3]), .CLK(clk), .RESET_B(rst_n), .Q(reg_q[3]));
    sky130_fd_sc_hd__dfrtp_1 ff4 (.D(mux_out[4]), .CLK(clk), .RESET_B(rst_n), .Q(reg_q[4]));
    sky130_fd_sc_hd__dfrtp_1 ff5 (.D(mux_out[5]), .CLK(clk), .RESET_B(rst_n), .Q(reg_q[5]));
    sky130_fd_sc_hd__dfrtp_1 ff6 (.D(mux_out[6]), .CLK(clk), .RESET_B(rst_n), .Q(reg_q[6]));
    sky130_fd_sc_hd__dfrtp_1 ff7 (.D(mux_out[7]), .CLK(clk), .RESET_B(rst_n), .Q(reg_q[7]));

    // Output buffers
    sky130_fd_sc_hd__buf_2 buf0 (.A(reg_q[0]), .X(data_out[0]));
    sky130_fd_sc_hd__buf_2 buf1 (.A(reg_q[1]), .X(data_out[1]));
    sky130_fd_sc_hd__buf_2 buf2 (.A(reg_q[2]), .X(data_out[2]));
    sky130_fd_sc_hd__buf_2 buf3 (.A(reg_q[3]), .X(data_out[3]));
    sky130_fd_sc_hd__buf_2 buf4 (.A(reg_q[4]), .X(data_out[4]));
    sky130_fd_sc_hd__buf_2 buf5 (.A(reg_q[5]), .X(data_out[5]));
    sky130_fd_sc_hd__buf_2 buf6 (.A(reg_q[6]), .X(data_out[6]));
    sky130_fd_sc_hd__buf_2 buf7 (.A(reg_q[7]), .X(data_out[7]));

endmodule
