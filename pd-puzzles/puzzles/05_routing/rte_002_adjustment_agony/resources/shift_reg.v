// 32-bit Shift Register - Pre-synthesized for Sky130HD
// This design has moderate routing complexity

module shift_reg (
    input  wire clk,
    input  wire rst_n,
    input  wire shift_en,
    input  wire serial_in,
    input  wire [31:0] parallel_in,
    input  wire load,
    output wire serial_out,
    output wire [31:0] parallel_out
);

    // Internal wires
    wire [31:0] reg_q;
    wire [31:0] shift_mux;
    wire [31:0] load_mux;
    wire shift_en_buf, load_buf, rst_n_buf;

    // Buffer control signals
    sky130_fd_sc_hd__buf_2 buf_shift (.A(shift_en), .X(shift_en_buf));
    sky130_fd_sc_hd__buf_2 buf_load (.A(load), .X(load_buf));
    sky130_fd_sc_hd__buf_2 buf_rst (.A(rst_n), .X(rst_n_buf));

    // Bit 0 - gets serial_in
    sky130_fd_sc_hd__mux2_1 mux_shift_0 (.A0(reg_q[0]), .A1(serial_in), .S(shift_en_buf), .X(shift_mux[0]));
    sky130_fd_sc_hd__mux2_1 mux_load_0 (.A0(shift_mux[0]), .A1(parallel_in[0]), .S(load_buf), .X(load_mux[0]));
    sky130_fd_sc_hd__dfrtp_1 reg_0 (.CLK(clk), .D(load_mux[0]), .RESET_B(rst_n_buf), .Q(reg_q[0]));

    // Bits 1-31 - chain from previous bit
    sky130_fd_sc_hd__mux2_1 mux_shift_1 (.A0(reg_q[1]), .A1(reg_q[0]), .S(shift_en_buf), .X(shift_mux[1]));
    sky130_fd_sc_hd__mux2_1 mux_load_1 (.A0(shift_mux[1]), .A1(parallel_in[1]), .S(load_buf), .X(load_mux[1]));
    sky130_fd_sc_hd__dfrtp_1 reg_1 (.CLK(clk), .D(load_mux[1]), .RESET_B(rst_n_buf), .Q(reg_q[1]));

    sky130_fd_sc_hd__mux2_1 mux_shift_2 (.A0(reg_q[2]), .A1(reg_q[1]), .S(shift_en_buf), .X(shift_mux[2]));
    sky130_fd_sc_hd__mux2_1 mux_load_2 (.A0(shift_mux[2]), .A1(parallel_in[2]), .S(load_buf), .X(load_mux[2]));
    sky130_fd_sc_hd__dfrtp_1 reg_2 (.CLK(clk), .D(load_mux[2]), .RESET_B(rst_n_buf), .Q(reg_q[2]));

    sky130_fd_sc_hd__mux2_1 mux_shift_3 (.A0(reg_q[3]), .A1(reg_q[2]), .S(shift_en_buf), .X(shift_mux[3]));
    sky130_fd_sc_hd__mux2_1 mux_load_3 (.A0(shift_mux[3]), .A1(parallel_in[3]), .S(load_buf), .X(load_mux[3]));
    sky130_fd_sc_hd__dfrtp_1 reg_3 (.CLK(clk), .D(load_mux[3]), .RESET_B(rst_n_buf), .Q(reg_q[3]));

    sky130_fd_sc_hd__mux2_1 mux_shift_4 (.A0(reg_q[4]), .A1(reg_q[3]), .S(shift_en_buf), .X(shift_mux[4]));
    sky130_fd_sc_hd__mux2_1 mux_load_4 (.A0(shift_mux[4]), .A1(parallel_in[4]), .S(load_buf), .X(load_mux[4]));
    sky130_fd_sc_hd__dfrtp_1 reg_4 (.CLK(clk), .D(load_mux[4]), .RESET_B(rst_n_buf), .Q(reg_q[4]));

    sky130_fd_sc_hd__mux2_1 mux_shift_5 (.A0(reg_q[5]), .A1(reg_q[4]), .S(shift_en_buf), .X(shift_mux[5]));
    sky130_fd_sc_hd__mux2_1 mux_load_5 (.A0(shift_mux[5]), .A1(parallel_in[5]), .S(load_buf), .X(load_mux[5]));
    sky130_fd_sc_hd__dfrtp_1 reg_5 (.CLK(clk), .D(load_mux[5]), .RESET_B(rst_n_buf), .Q(reg_q[5]));

    sky130_fd_sc_hd__mux2_1 mux_shift_6 (.A0(reg_q[6]), .A1(reg_q[5]), .S(shift_en_buf), .X(shift_mux[6]));
    sky130_fd_sc_hd__mux2_1 mux_load_6 (.A0(shift_mux[6]), .A1(parallel_in[6]), .S(load_buf), .X(load_mux[6]));
    sky130_fd_sc_hd__dfrtp_1 reg_6 (.CLK(clk), .D(load_mux[6]), .RESET_B(rst_n_buf), .Q(reg_q[6]));

    sky130_fd_sc_hd__mux2_1 mux_shift_7 (.A0(reg_q[7]), .A1(reg_q[6]), .S(shift_en_buf), .X(shift_mux[7]));
    sky130_fd_sc_hd__mux2_1 mux_load_7 (.A0(shift_mux[7]), .A1(parallel_in[7]), .S(load_buf), .X(load_mux[7]));
    sky130_fd_sc_hd__dfrtp_1 reg_7 (.CLK(clk), .D(load_mux[7]), .RESET_B(rst_n_buf), .Q(reg_q[7]));

    sky130_fd_sc_hd__mux2_1 mux_shift_8 (.A0(reg_q[8]), .A1(reg_q[7]), .S(shift_en_buf), .X(shift_mux[8]));
    sky130_fd_sc_hd__mux2_1 mux_load_8 (.A0(shift_mux[8]), .A1(parallel_in[8]), .S(load_buf), .X(load_mux[8]));
    sky130_fd_sc_hd__dfrtp_1 reg_8 (.CLK(clk), .D(load_mux[8]), .RESET_B(rst_n_buf), .Q(reg_q[8]));

    sky130_fd_sc_hd__mux2_1 mux_shift_9 (.A0(reg_q[9]), .A1(reg_q[8]), .S(shift_en_buf), .X(shift_mux[9]));
    sky130_fd_sc_hd__mux2_1 mux_load_9 (.A0(shift_mux[9]), .A1(parallel_in[9]), .S(load_buf), .X(load_mux[9]));
    sky130_fd_sc_hd__dfrtp_1 reg_9 (.CLK(clk), .D(load_mux[9]), .RESET_B(rst_n_buf), .Q(reg_q[9]));

    sky130_fd_sc_hd__mux2_1 mux_shift_10 (.A0(reg_q[10]), .A1(reg_q[9]), .S(shift_en_buf), .X(shift_mux[10]));
    sky130_fd_sc_hd__mux2_1 mux_load_10 (.A0(shift_mux[10]), .A1(parallel_in[10]), .S(load_buf), .X(load_mux[10]));
    sky130_fd_sc_hd__dfrtp_1 reg_10 (.CLK(clk), .D(load_mux[10]), .RESET_B(rst_n_buf), .Q(reg_q[10]));

    sky130_fd_sc_hd__mux2_1 mux_shift_11 (.A0(reg_q[11]), .A1(reg_q[10]), .S(shift_en_buf), .X(shift_mux[11]));
    sky130_fd_sc_hd__mux2_1 mux_load_11 (.A0(shift_mux[11]), .A1(parallel_in[11]), .S(load_buf), .X(load_mux[11]));
    sky130_fd_sc_hd__dfrtp_1 reg_11 (.CLK(clk), .D(load_mux[11]), .RESET_B(rst_n_buf), .Q(reg_q[11]));

    sky130_fd_sc_hd__mux2_1 mux_shift_12 (.A0(reg_q[12]), .A1(reg_q[11]), .S(shift_en_buf), .X(shift_mux[12]));
    sky130_fd_sc_hd__mux2_1 mux_load_12 (.A0(shift_mux[12]), .A1(parallel_in[12]), .S(load_buf), .X(load_mux[12]));
    sky130_fd_sc_hd__dfrtp_1 reg_12 (.CLK(clk), .D(load_mux[12]), .RESET_B(rst_n_buf), .Q(reg_q[12]));

    sky130_fd_sc_hd__mux2_1 mux_shift_13 (.A0(reg_q[13]), .A1(reg_q[12]), .S(shift_en_buf), .X(shift_mux[13]));
    sky130_fd_sc_hd__mux2_1 mux_load_13 (.A0(shift_mux[13]), .A1(parallel_in[13]), .S(load_buf), .X(load_mux[13]));
    sky130_fd_sc_hd__dfrtp_1 reg_13 (.CLK(clk), .D(load_mux[13]), .RESET_B(rst_n_buf), .Q(reg_q[13]));

    sky130_fd_sc_hd__mux2_1 mux_shift_14 (.A0(reg_q[14]), .A1(reg_q[13]), .S(shift_en_buf), .X(shift_mux[14]));
    sky130_fd_sc_hd__mux2_1 mux_load_14 (.A0(shift_mux[14]), .A1(parallel_in[14]), .S(load_buf), .X(load_mux[14]));
    sky130_fd_sc_hd__dfrtp_1 reg_14 (.CLK(clk), .D(load_mux[14]), .RESET_B(rst_n_buf), .Q(reg_q[14]));

    sky130_fd_sc_hd__mux2_1 mux_shift_15 (.A0(reg_q[15]), .A1(reg_q[14]), .S(shift_en_buf), .X(shift_mux[15]));
    sky130_fd_sc_hd__mux2_1 mux_load_15 (.A0(shift_mux[15]), .A1(parallel_in[15]), .S(load_buf), .X(load_mux[15]));
    sky130_fd_sc_hd__dfrtp_1 reg_15 (.CLK(clk), .D(load_mux[15]), .RESET_B(rst_n_buf), .Q(reg_q[15]));

    sky130_fd_sc_hd__mux2_1 mux_shift_16 (.A0(reg_q[16]), .A1(reg_q[15]), .S(shift_en_buf), .X(shift_mux[16]));
    sky130_fd_sc_hd__mux2_1 mux_load_16 (.A0(shift_mux[16]), .A1(parallel_in[16]), .S(load_buf), .X(load_mux[16]));
    sky130_fd_sc_hd__dfrtp_1 reg_16 (.CLK(clk), .D(load_mux[16]), .RESET_B(rst_n_buf), .Q(reg_q[16]));

    sky130_fd_sc_hd__mux2_1 mux_shift_17 (.A0(reg_q[17]), .A1(reg_q[16]), .S(shift_en_buf), .X(shift_mux[17]));
    sky130_fd_sc_hd__mux2_1 mux_load_17 (.A0(shift_mux[17]), .A1(parallel_in[17]), .S(load_buf), .X(load_mux[17]));
    sky130_fd_sc_hd__dfrtp_1 reg_17 (.CLK(clk), .D(load_mux[17]), .RESET_B(rst_n_buf), .Q(reg_q[17]));

    sky130_fd_sc_hd__mux2_1 mux_shift_18 (.A0(reg_q[18]), .A1(reg_q[17]), .S(shift_en_buf), .X(shift_mux[18]));
    sky130_fd_sc_hd__mux2_1 mux_load_18 (.A0(shift_mux[18]), .A1(parallel_in[18]), .S(load_buf), .X(load_mux[18]));
    sky130_fd_sc_hd__dfrtp_1 reg_18 (.CLK(clk), .D(load_mux[18]), .RESET_B(rst_n_buf), .Q(reg_q[18]));

    sky130_fd_sc_hd__mux2_1 mux_shift_19 (.A0(reg_q[19]), .A1(reg_q[18]), .S(shift_en_buf), .X(shift_mux[19]));
    sky130_fd_sc_hd__mux2_1 mux_load_19 (.A0(shift_mux[19]), .A1(parallel_in[19]), .S(load_buf), .X(load_mux[19]));
    sky130_fd_sc_hd__dfrtp_1 reg_19 (.CLK(clk), .D(load_mux[19]), .RESET_B(rst_n_buf), .Q(reg_q[19]));

    sky130_fd_sc_hd__mux2_1 mux_shift_20 (.A0(reg_q[20]), .A1(reg_q[19]), .S(shift_en_buf), .X(shift_mux[20]));
    sky130_fd_sc_hd__mux2_1 mux_load_20 (.A0(shift_mux[20]), .A1(parallel_in[20]), .S(load_buf), .X(load_mux[20]));
    sky130_fd_sc_hd__dfrtp_1 reg_20 (.CLK(clk), .D(load_mux[20]), .RESET_B(rst_n_buf), .Q(reg_q[20]));

    sky130_fd_sc_hd__mux2_1 mux_shift_21 (.A0(reg_q[21]), .A1(reg_q[20]), .S(shift_en_buf), .X(shift_mux[21]));
    sky130_fd_sc_hd__mux2_1 mux_load_21 (.A0(shift_mux[21]), .A1(parallel_in[21]), .S(load_buf), .X(load_mux[21]));
    sky130_fd_sc_hd__dfrtp_1 reg_21 (.CLK(clk), .D(load_mux[21]), .RESET_B(rst_n_buf), .Q(reg_q[21]));

    sky130_fd_sc_hd__mux2_1 mux_shift_22 (.A0(reg_q[22]), .A1(reg_q[21]), .S(shift_en_buf), .X(shift_mux[22]));
    sky130_fd_sc_hd__mux2_1 mux_load_22 (.A0(shift_mux[22]), .A1(parallel_in[22]), .S(load_buf), .X(load_mux[22]));
    sky130_fd_sc_hd__dfrtp_1 reg_22 (.CLK(clk), .D(load_mux[22]), .RESET_B(rst_n_buf), .Q(reg_q[22]));

    sky130_fd_sc_hd__mux2_1 mux_shift_23 (.A0(reg_q[23]), .A1(reg_q[22]), .S(shift_en_buf), .X(shift_mux[23]));
    sky130_fd_sc_hd__mux2_1 mux_load_23 (.A0(shift_mux[23]), .A1(parallel_in[23]), .S(load_buf), .X(load_mux[23]));
    sky130_fd_sc_hd__dfrtp_1 reg_23 (.CLK(clk), .D(load_mux[23]), .RESET_B(rst_n_buf), .Q(reg_q[23]));

    sky130_fd_sc_hd__mux2_1 mux_shift_24 (.A0(reg_q[24]), .A1(reg_q[23]), .S(shift_en_buf), .X(shift_mux[24]));
    sky130_fd_sc_hd__mux2_1 mux_load_24 (.A0(shift_mux[24]), .A1(parallel_in[24]), .S(load_buf), .X(load_mux[24]));
    sky130_fd_sc_hd__dfrtp_1 reg_24 (.CLK(clk), .D(load_mux[24]), .RESET_B(rst_n_buf), .Q(reg_q[24]));

    sky130_fd_sc_hd__mux2_1 mux_shift_25 (.A0(reg_q[25]), .A1(reg_q[24]), .S(shift_en_buf), .X(shift_mux[25]));
    sky130_fd_sc_hd__mux2_1 mux_load_25 (.A0(shift_mux[25]), .A1(parallel_in[25]), .S(load_buf), .X(load_mux[25]));
    sky130_fd_sc_hd__dfrtp_1 reg_25 (.CLK(clk), .D(load_mux[25]), .RESET_B(rst_n_buf), .Q(reg_q[25]));

    sky130_fd_sc_hd__mux2_1 mux_shift_26 (.A0(reg_q[26]), .A1(reg_q[25]), .S(shift_en_buf), .X(shift_mux[26]));
    sky130_fd_sc_hd__mux2_1 mux_load_26 (.A0(shift_mux[26]), .A1(parallel_in[26]), .S(load_buf), .X(load_mux[26]));
    sky130_fd_sc_hd__dfrtp_1 reg_26 (.CLK(clk), .D(load_mux[26]), .RESET_B(rst_n_buf), .Q(reg_q[26]));

    sky130_fd_sc_hd__mux2_1 mux_shift_27 (.A0(reg_q[27]), .A1(reg_q[26]), .S(shift_en_buf), .X(shift_mux[27]));
    sky130_fd_sc_hd__mux2_1 mux_load_27 (.A0(shift_mux[27]), .A1(parallel_in[27]), .S(load_buf), .X(load_mux[27]));
    sky130_fd_sc_hd__dfrtp_1 reg_27 (.CLK(clk), .D(load_mux[27]), .RESET_B(rst_n_buf), .Q(reg_q[27]));

    sky130_fd_sc_hd__mux2_1 mux_shift_28 (.A0(reg_q[28]), .A1(reg_q[27]), .S(shift_en_buf), .X(shift_mux[28]));
    sky130_fd_sc_hd__mux2_1 mux_load_28 (.A0(shift_mux[28]), .A1(parallel_in[28]), .S(load_buf), .X(load_mux[28]));
    sky130_fd_sc_hd__dfrtp_1 reg_28 (.CLK(clk), .D(load_mux[28]), .RESET_B(rst_n_buf), .Q(reg_q[28]));

    sky130_fd_sc_hd__mux2_1 mux_shift_29 (.A0(reg_q[29]), .A1(reg_q[28]), .S(shift_en_buf), .X(shift_mux[29]));
    sky130_fd_sc_hd__mux2_1 mux_load_29 (.A0(shift_mux[29]), .A1(parallel_in[29]), .S(load_buf), .X(load_mux[29]));
    sky130_fd_sc_hd__dfrtp_1 reg_29 (.CLK(clk), .D(load_mux[29]), .RESET_B(rst_n_buf), .Q(reg_q[29]));

    sky130_fd_sc_hd__mux2_1 mux_shift_30 (.A0(reg_q[30]), .A1(reg_q[29]), .S(shift_en_buf), .X(shift_mux[30]));
    sky130_fd_sc_hd__mux2_1 mux_load_30 (.A0(shift_mux[30]), .A1(parallel_in[30]), .S(load_buf), .X(load_mux[30]));
    sky130_fd_sc_hd__dfrtp_1 reg_30 (.CLK(clk), .D(load_mux[30]), .RESET_B(rst_n_buf), .Q(reg_q[30]));

    sky130_fd_sc_hd__mux2_1 mux_shift_31 (.A0(reg_q[31]), .A1(reg_q[30]), .S(shift_en_buf), .X(shift_mux[31]));
    sky130_fd_sc_hd__mux2_1 mux_load_31 (.A0(shift_mux[31]), .A1(parallel_in[31]), .S(load_buf), .X(load_mux[31]));
    sky130_fd_sc_hd__dfrtp_1 reg_31 (.CLK(clk), .D(load_mux[31]), .RESET_B(rst_n_buf), .Q(reg_q[31]));

    // Output assignments
    assign serial_out = reg_q[31];
    assign parallel_out = reg_q;

endmodule
