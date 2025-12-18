// DSP Core - Pre-synthesized for Sky130HD
// Simple pipelined adder/accumulator
// Target: 100 MHz

module dsp_core (
    input wire clk,
    input wire rst_n,
    input wire [7:0] data_a,
    input wire [7:0] data_b,
    input wire valid_in,
    output wire [15:0] result,
    output wire valid_out
);

    // Pipeline registers
    wire [7:0] s1_a, s1_b;
    wire s1_valid;
    wire [8:0] s2_sum;
    wire s2_valid;
    wire [15:0] s3_accum;
    wire s3_valid;

    //=========================================================================
    // Stage 1: Input Registers
    //=========================================================================

    sky130_fd_sc_hd__dfrtp_1 reg_a_0 (.CLK(clk), .RESET_B(rst_n), .D(data_a[0]), .Q(s1_a[0]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_1 (.CLK(clk), .RESET_B(rst_n), .D(data_a[1]), .Q(s1_a[1]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_2 (.CLK(clk), .RESET_B(rst_n), .D(data_a[2]), .Q(s1_a[2]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_3 (.CLK(clk), .RESET_B(rst_n), .D(data_a[3]), .Q(s1_a[3]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_4 (.CLK(clk), .RESET_B(rst_n), .D(data_a[4]), .Q(s1_a[4]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_5 (.CLK(clk), .RESET_B(rst_n), .D(data_a[5]), .Q(s1_a[5]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_6 (.CLK(clk), .RESET_B(rst_n), .D(data_a[6]), .Q(s1_a[6]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_7 (.CLK(clk), .RESET_B(rst_n), .D(data_a[7]), .Q(s1_a[7]));

    sky130_fd_sc_hd__dfrtp_1 reg_b_0 (.CLK(clk), .RESET_B(rst_n), .D(data_b[0]), .Q(s1_b[0]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_1 (.CLK(clk), .RESET_B(rst_n), .D(data_b[1]), .Q(s1_b[1]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_2 (.CLK(clk), .RESET_B(rst_n), .D(data_b[2]), .Q(s1_b[2]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_3 (.CLK(clk), .RESET_B(rst_n), .D(data_b[3]), .Q(s1_b[3]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_4 (.CLK(clk), .RESET_B(rst_n), .D(data_b[4]), .Q(s1_b[4]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_5 (.CLK(clk), .RESET_B(rst_n), .D(data_b[5]), .Q(s1_b[5]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_6 (.CLK(clk), .RESET_B(rst_n), .D(data_b[6]), .Q(s1_b[6]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_7 (.CLK(clk), .RESET_B(rst_n), .D(data_b[7]), .Q(s1_b[7]));

    sky130_fd_sc_hd__dfrtp_1 reg_v1 (.CLK(clk), .RESET_B(rst_n), .D(valid_in), .Q(s1_valid));

    //=========================================================================
    // Stage 2: Adder
    //=========================================================================

    wire [7:0] add_carry;
    wire [8:0] add_result;

    sky130_fd_sc_hd__fa_1 add_0 (.A(s1_a[0]), .B(s1_b[0]), .CIN(1'b0), .SUM(add_result[0]), .COUT(add_carry[0]));
    sky130_fd_sc_hd__fa_1 add_1 (.A(s1_a[1]), .B(s1_b[1]), .CIN(add_carry[0]), .SUM(add_result[1]), .COUT(add_carry[1]));
    sky130_fd_sc_hd__fa_1 add_2 (.A(s1_a[2]), .B(s1_b[2]), .CIN(add_carry[1]), .SUM(add_result[2]), .COUT(add_carry[2]));
    sky130_fd_sc_hd__fa_1 add_3 (.A(s1_a[3]), .B(s1_b[3]), .CIN(add_carry[2]), .SUM(add_result[3]), .COUT(add_carry[3]));
    sky130_fd_sc_hd__fa_1 add_4 (.A(s1_a[4]), .B(s1_b[4]), .CIN(add_carry[3]), .SUM(add_result[4]), .COUT(add_carry[4]));
    sky130_fd_sc_hd__fa_1 add_5 (.A(s1_a[5]), .B(s1_b[5]), .CIN(add_carry[4]), .SUM(add_result[5]), .COUT(add_carry[5]));
    sky130_fd_sc_hd__fa_1 add_6 (.A(s1_a[6]), .B(s1_b[6]), .CIN(add_carry[5]), .SUM(add_result[6]), .COUT(add_carry[6]));
    sky130_fd_sc_hd__fa_1 add_7 (.A(s1_a[7]), .B(s1_b[7]), .CIN(add_carry[6]), .SUM(add_result[7]), .COUT(add_result[8]));

    // Stage 2 registers
    sky130_fd_sc_hd__dfrtp_1 reg_s2_0 (.CLK(clk), .RESET_B(rst_n), .D(add_result[0]), .Q(s2_sum[0]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_1 (.CLK(clk), .RESET_B(rst_n), .D(add_result[1]), .Q(s2_sum[1]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_2 (.CLK(clk), .RESET_B(rst_n), .D(add_result[2]), .Q(s2_sum[2]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_3 (.CLK(clk), .RESET_B(rst_n), .D(add_result[3]), .Q(s2_sum[3]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_4 (.CLK(clk), .RESET_B(rst_n), .D(add_result[4]), .Q(s2_sum[4]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_5 (.CLK(clk), .RESET_B(rst_n), .D(add_result[5]), .Q(s2_sum[5]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_6 (.CLK(clk), .RESET_B(rst_n), .D(add_result[6]), .Q(s2_sum[6]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_7 (.CLK(clk), .RESET_B(rst_n), .D(add_result[7]), .Q(s2_sum[7]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_8 (.CLK(clk), .RESET_B(rst_n), .D(add_result[8]), .Q(s2_sum[8]));
    sky130_fd_sc_hd__dfrtp_1 reg_v2 (.CLK(clk), .RESET_B(rst_n), .D(s1_valid), .Q(s2_valid));

    //=========================================================================
    // Stage 3: Accumulator (add to previous result)
    //=========================================================================

    wire [15:0] accum_result;
    wire [15:0] accum_carry;

    // Extend s2_sum to 16 bits
    wire [15:0] s2_extended;
    assign s2_extended = {7'b0, s2_sum};

    sky130_fd_sc_hd__fa_1 acc_0 (.A(s2_extended[0]), .B(s3_accum[0]), .CIN(1'b0), .SUM(accum_result[0]), .COUT(accum_carry[0]));
    sky130_fd_sc_hd__fa_1 acc_1 (.A(s2_extended[1]), .B(s3_accum[1]), .CIN(accum_carry[0]), .SUM(accum_result[1]), .COUT(accum_carry[1]));
    sky130_fd_sc_hd__fa_1 acc_2 (.A(s2_extended[2]), .B(s3_accum[2]), .CIN(accum_carry[1]), .SUM(accum_result[2]), .COUT(accum_carry[2]));
    sky130_fd_sc_hd__fa_1 acc_3 (.A(s2_extended[3]), .B(s3_accum[3]), .CIN(accum_carry[2]), .SUM(accum_result[3]), .COUT(accum_carry[3]));
    sky130_fd_sc_hd__fa_1 acc_4 (.A(s2_extended[4]), .B(s3_accum[4]), .CIN(accum_carry[3]), .SUM(accum_result[4]), .COUT(accum_carry[4]));
    sky130_fd_sc_hd__fa_1 acc_5 (.A(s2_extended[5]), .B(s3_accum[5]), .CIN(accum_carry[4]), .SUM(accum_result[5]), .COUT(accum_carry[5]));
    sky130_fd_sc_hd__fa_1 acc_6 (.A(s2_extended[6]), .B(s3_accum[6]), .CIN(accum_carry[5]), .SUM(accum_result[6]), .COUT(accum_carry[6]));
    sky130_fd_sc_hd__fa_1 acc_7 (.A(s2_extended[7]), .B(s3_accum[7]), .CIN(accum_carry[6]), .SUM(accum_result[7]), .COUT(accum_carry[7]));
    sky130_fd_sc_hd__fa_1 acc_8 (.A(s2_extended[8]), .B(s3_accum[8]), .CIN(accum_carry[7]), .SUM(accum_result[8]), .COUT(accum_carry[8]));
    sky130_fd_sc_hd__fa_1 acc_9 (.A(s2_extended[9]), .B(s3_accum[9]), .CIN(accum_carry[8]), .SUM(accum_result[9]), .COUT(accum_carry[9]));
    sky130_fd_sc_hd__fa_1 acc_10 (.A(s2_extended[10]), .B(s3_accum[10]), .CIN(accum_carry[9]), .SUM(accum_result[10]), .COUT(accum_carry[10]));
    sky130_fd_sc_hd__fa_1 acc_11 (.A(s2_extended[11]), .B(s3_accum[11]), .CIN(accum_carry[10]), .SUM(accum_result[11]), .COUT(accum_carry[11]));
    sky130_fd_sc_hd__fa_1 acc_12 (.A(s2_extended[12]), .B(s3_accum[12]), .CIN(accum_carry[11]), .SUM(accum_result[12]), .COUT(accum_carry[12]));
    sky130_fd_sc_hd__fa_1 acc_13 (.A(s2_extended[13]), .B(s3_accum[13]), .CIN(accum_carry[12]), .SUM(accum_result[13]), .COUT(accum_carry[13]));
    sky130_fd_sc_hd__fa_1 acc_14 (.A(s2_extended[14]), .B(s3_accum[14]), .CIN(accum_carry[13]), .SUM(accum_result[14]), .COUT(accum_carry[14]));
    sky130_fd_sc_hd__fa_1 acc_15 (.A(s2_extended[15]), .B(s3_accum[15]), .CIN(accum_carry[14]), .SUM(accum_result[15]), .COUT(accum_carry[15]));

    // Stage 3 registers
    sky130_fd_sc_hd__dfrtp_1 reg_acc_0 (.CLK(clk), .RESET_B(rst_n), .D(accum_result[0]), .Q(s3_accum[0]));
    sky130_fd_sc_hd__dfrtp_1 reg_acc_1 (.CLK(clk), .RESET_B(rst_n), .D(accum_result[1]), .Q(s3_accum[1]));
    sky130_fd_sc_hd__dfrtp_1 reg_acc_2 (.CLK(clk), .RESET_B(rst_n), .D(accum_result[2]), .Q(s3_accum[2]));
    sky130_fd_sc_hd__dfrtp_1 reg_acc_3 (.CLK(clk), .RESET_B(rst_n), .D(accum_result[3]), .Q(s3_accum[3]));
    sky130_fd_sc_hd__dfrtp_1 reg_acc_4 (.CLK(clk), .RESET_B(rst_n), .D(accum_result[4]), .Q(s3_accum[4]));
    sky130_fd_sc_hd__dfrtp_1 reg_acc_5 (.CLK(clk), .RESET_B(rst_n), .D(accum_result[5]), .Q(s3_accum[5]));
    sky130_fd_sc_hd__dfrtp_1 reg_acc_6 (.CLK(clk), .RESET_B(rst_n), .D(accum_result[6]), .Q(s3_accum[6]));
    sky130_fd_sc_hd__dfrtp_1 reg_acc_7 (.CLK(clk), .RESET_B(rst_n), .D(accum_result[7]), .Q(s3_accum[7]));
    sky130_fd_sc_hd__dfrtp_1 reg_acc_8 (.CLK(clk), .RESET_B(rst_n), .D(accum_result[8]), .Q(s3_accum[8]));
    sky130_fd_sc_hd__dfrtp_1 reg_acc_9 (.CLK(clk), .RESET_B(rst_n), .D(accum_result[9]), .Q(s3_accum[9]));
    sky130_fd_sc_hd__dfrtp_1 reg_acc_10 (.CLK(clk), .RESET_B(rst_n), .D(accum_result[10]), .Q(s3_accum[10]));
    sky130_fd_sc_hd__dfrtp_1 reg_acc_11 (.CLK(clk), .RESET_B(rst_n), .D(accum_result[11]), .Q(s3_accum[11]));
    sky130_fd_sc_hd__dfrtp_1 reg_acc_12 (.CLK(clk), .RESET_B(rst_n), .D(accum_result[12]), .Q(s3_accum[12]));
    sky130_fd_sc_hd__dfrtp_1 reg_acc_13 (.CLK(clk), .RESET_B(rst_n), .D(accum_result[13]), .Q(s3_accum[13]));
    sky130_fd_sc_hd__dfrtp_1 reg_acc_14 (.CLK(clk), .RESET_B(rst_n), .D(accum_result[14]), .Q(s3_accum[14]));
    sky130_fd_sc_hd__dfrtp_1 reg_acc_15 (.CLK(clk), .RESET_B(rst_n), .D(accum_result[15]), .Q(s3_accum[15]));
    sky130_fd_sc_hd__dfrtp_1 reg_v3 (.CLK(clk), .RESET_B(rst_n), .D(s2_valid), .Q(s3_valid));

    // Output
    assign result = s3_accum;
    assign valid_out = s3_valid;

endmodule
