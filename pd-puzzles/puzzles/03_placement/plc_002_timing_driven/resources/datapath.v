// Pipelined Datapath - Pre-synthesized for Sky130HD
// Target: 100 MHz (10ns period)
//
// This is a 4-stage pipelined datapath with:
// - Input registers
// - ALU stage
// - Accumulator stage
// - Output registers

module datapath (
    input wire clk,
    input wire rst_n,
    input wire [15:0] data_a,
    input wire [15:0] data_b,
    input wire [2:0] op_sel,
    input wire valid_in,
    output wire [15:0] result,
    output wire valid_out
);

    // Pipeline stage 1: Input registers
    wire [15:0] stage1_a, stage1_b;
    wire [2:0] stage1_op;
    wire stage1_valid;

    // Pipeline stage 2: ALU operation
    wire [15:0] stage2_result;
    wire stage2_valid;

    // Pipeline stage 3: Accumulator
    wire [15:0] stage3_accum;
    wire stage3_valid;

    // Pipeline stage 4: Output
    wire [15:0] stage4_out;
    wire stage4_valid;

    //=========================================================================
    // Stage 1: Input Registers
    //=========================================================================

    sky130_fd_sc_hd__dfrtp_1 reg_a_0 (.CLK(clk), .RESET_B(rst_n), .D(data_a[0]), .Q(stage1_a[0]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_1 (.CLK(clk), .RESET_B(rst_n), .D(data_a[1]), .Q(stage1_a[1]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_2 (.CLK(clk), .RESET_B(rst_n), .D(data_a[2]), .Q(stage1_a[2]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_3 (.CLK(clk), .RESET_B(rst_n), .D(data_a[3]), .Q(stage1_a[3]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_4 (.CLK(clk), .RESET_B(rst_n), .D(data_a[4]), .Q(stage1_a[4]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_5 (.CLK(clk), .RESET_B(rst_n), .D(data_a[5]), .Q(stage1_a[5]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_6 (.CLK(clk), .RESET_B(rst_n), .D(data_a[6]), .Q(stage1_a[6]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_7 (.CLK(clk), .RESET_B(rst_n), .D(data_a[7]), .Q(stage1_a[7]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_8 (.CLK(clk), .RESET_B(rst_n), .D(data_a[8]), .Q(stage1_a[8]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_9 (.CLK(clk), .RESET_B(rst_n), .D(data_a[9]), .Q(stage1_a[9]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_10 (.CLK(clk), .RESET_B(rst_n), .D(data_a[10]), .Q(stage1_a[10]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_11 (.CLK(clk), .RESET_B(rst_n), .D(data_a[11]), .Q(stage1_a[11]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_12 (.CLK(clk), .RESET_B(rst_n), .D(data_a[12]), .Q(stage1_a[12]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_13 (.CLK(clk), .RESET_B(rst_n), .D(data_a[13]), .Q(stage1_a[13]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_14 (.CLK(clk), .RESET_B(rst_n), .D(data_a[14]), .Q(stage1_a[14]));
    sky130_fd_sc_hd__dfrtp_1 reg_a_15 (.CLK(clk), .RESET_B(rst_n), .D(data_a[15]), .Q(stage1_a[15]));

    sky130_fd_sc_hd__dfrtp_1 reg_b_0 (.CLK(clk), .RESET_B(rst_n), .D(data_b[0]), .Q(stage1_b[0]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_1 (.CLK(clk), .RESET_B(rst_n), .D(data_b[1]), .Q(stage1_b[1]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_2 (.CLK(clk), .RESET_B(rst_n), .D(data_b[2]), .Q(stage1_b[2]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_3 (.CLK(clk), .RESET_B(rst_n), .D(data_b[3]), .Q(stage1_b[3]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_4 (.CLK(clk), .RESET_B(rst_n), .D(data_b[4]), .Q(stage1_b[4]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_5 (.CLK(clk), .RESET_B(rst_n), .D(data_b[5]), .Q(stage1_b[5]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_6 (.CLK(clk), .RESET_B(rst_n), .D(data_b[6]), .Q(stage1_b[6]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_7 (.CLK(clk), .RESET_B(rst_n), .D(data_b[7]), .Q(stage1_b[7]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_8 (.CLK(clk), .RESET_B(rst_n), .D(data_b[8]), .Q(stage1_b[8]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_9 (.CLK(clk), .RESET_B(rst_n), .D(data_b[9]), .Q(stage1_b[9]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_10 (.CLK(clk), .RESET_B(rst_n), .D(data_b[10]), .Q(stage1_b[10]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_11 (.CLK(clk), .RESET_B(rst_n), .D(data_b[11]), .Q(stage1_b[11]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_12 (.CLK(clk), .RESET_B(rst_n), .D(data_b[12]), .Q(stage1_b[12]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_13 (.CLK(clk), .RESET_B(rst_n), .D(data_b[13]), .Q(stage1_b[13]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_14 (.CLK(clk), .RESET_B(rst_n), .D(data_b[14]), .Q(stage1_b[14]));
    sky130_fd_sc_hd__dfrtp_1 reg_b_15 (.CLK(clk), .RESET_B(rst_n), .D(data_b[15]), .Q(stage1_b[15]));

    sky130_fd_sc_hd__dfrtp_1 reg_op_0 (.CLK(clk), .RESET_B(rst_n), .D(op_sel[0]), .Q(stage1_op[0]));
    sky130_fd_sc_hd__dfrtp_1 reg_op_1 (.CLK(clk), .RESET_B(rst_n), .D(op_sel[1]), .Q(stage1_op[1]));
    sky130_fd_sc_hd__dfrtp_1 reg_op_2 (.CLK(clk), .RESET_B(rst_n), .D(op_sel[2]), .Q(stage1_op[2]));

    sky130_fd_sc_hd__dfrtp_1 reg_valid_1 (.CLK(clk), .RESET_B(rst_n), .D(valid_in), .Q(stage1_valid));

    //=========================================================================
    // Stage 2: ALU Operations (ADD/SUB/AND/OR/XOR)
    //=========================================================================

    // ALU intermediate signals
    wire [15:0] alu_add, alu_sub, alu_and, alu_or, alu_xor;
    wire [15:0] alu_mux_out;

    // Full adder chain for addition
    wire [15:0] add_carry;

    sky130_fd_sc_hd__fa_1 fa_0 (.A(stage1_a[0]), .B(stage1_b[0]), .CIN(1'b0), .SUM(alu_add[0]), .COUT(add_carry[0]));
    sky130_fd_sc_hd__fa_1 fa_1 (.A(stage1_a[1]), .B(stage1_b[1]), .CIN(add_carry[0]), .SUM(alu_add[1]), .COUT(add_carry[1]));
    sky130_fd_sc_hd__fa_1 fa_2 (.A(stage1_a[2]), .B(stage1_b[2]), .CIN(add_carry[1]), .SUM(alu_add[2]), .COUT(add_carry[2]));
    sky130_fd_sc_hd__fa_1 fa_3 (.A(stage1_a[3]), .B(stage1_b[3]), .CIN(add_carry[2]), .SUM(alu_add[3]), .COUT(add_carry[3]));
    sky130_fd_sc_hd__fa_1 fa_4 (.A(stage1_a[4]), .B(stage1_b[4]), .CIN(add_carry[3]), .SUM(alu_add[4]), .COUT(add_carry[4]));
    sky130_fd_sc_hd__fa_1 fa_5 (.A(stage1_a[5]), .B(stage1_b[5]), .CIN(add_carry[4]), .SUM(alu_add[5]), .COUT(add_carry[5]));
    sky130_fd_sc_hd__fa_1 fa_6 (.A(stage1_a[6]), .B(stage1_b[6]), .CIN(add_carry[5]), .SUM(alu_add[6]), .COUT(add_carry[6]));
    sky130_fd_sc_hd__fa_1 fa_7 (.A(stage1_a[7]), .B(stage1_b[7]), .CIN(add_carry[6]), .SUM(alu_add[7]), .COUT(add_carry[7]));
    sky130_fd_sc_hd__fa_1 fa_8 (.A(stage1_a[8]), .B(stage1_b[8]), .CIN(add_carry[7]), .SUM(alu_add[8]), .COUT(add_carry[8]));
    sky130_fd_sc_hd__fa_1 fa_9 (.A(stage1_a[9]), .B(stage1_b[9]), .CIN(add_carry[8]), .SUM(alu_add[9]), .COUT(add_carry[9]));
    sky130_fd_sc_hd__fa_1 fa_10 (.A(stage1_a[10]), .B(stage1_b[10]), .CIN(add_carry[9]), .SUM(alu_add[10]), .COUT(add_carry[10]));
    sky130_fd_sc_hd__fa_1 fa_11 (.A(stage1_a[11]), .B(stage1_b[11]), .CIN(add_carry[10]), .SUM(alu_add[11]), .COUT(add_carry[11]));
    sky130_fd_sc_hd__fa_1 fa_12 (.A(stage1_a[12]), .B(stage1_b[12]), .CIN(add_carry[11]), .SUM(alu_add[12]), .COUT(add_carry[12]));
    sky130_fd_sc_hd__fa_1 fa_13 (.A(stage1_a[13]), .B(stage1_b[13]), .CIN(add_carry[12]), .SUM(alu_add[13]), .COUT(add_carry[13]));
    sky130_fd_sc_hd__fa_1 fa_14 (.A(stage1_a[14]), .B(stage1_b[14]), .CIN(add_carry[13]), .SUM(alu_add[14]), .COUT(add_carry[14]));
    sky130_fd_sc_hd__fa_1 fa_15 (.A(stage1_a[15]), .B(stage1_b[15]), .CIN(add_carry[14]), .SUM(alu_add[15]), .COUT(add_carry[15]));

    // Subtraction (A - B = A + ~B + 1)
    wire [15:0] b_inv;
    wire [15:0] sub_carry;

    sky130_fd_sc_hd__inv_1 inv_b_0 (.A(stage1_b[0]), .Y(b_inv[0]));
    sky130_fd_sc_hd__inv_1 inv_b_1 (.A(stage1_b[1]), .Y(b_inv[1]));
    sky130_fd_sc_hd__inv_1 inv_b_2 (.A(stage1_b[2]), .Y(b_inv[2]));
    sky130_fd_sc_hd__inv_1 inv_b_3 (.A(stage1_b[3]), .Y(b_inv[3]));
    sky130_fd_sc_hd__inv_1 inv_b_4 (.A(stage1_b[4]), .Y(b_inv[4]));
    sky130_fd_sc_hd__inv_1 inv_b_5 (.A(stage1_b[5]), .Y(b_inv[5]));
    sky130_fd_sc_hd__inv_1 inv_b_6 (.A(stage1_b[6]), .Y(b_inv[6]));
    sky130_fd_sc_hd__inv_1 inv_b_7 (.A(stage1_b[7]), .Y(b_inv[7]));
    sky130_fd_sc_hd__inv_1 inv_b_8 (.A(stage1_b[8]), .Y(b_inv[8]));
    sky130_fd_sc_hd__inv_1 inv_b_9 (.A(stage1_b[9]), .Y(b_inv[9]));
    sky130_fd_sc_hd__inv_1 inv_b_10 (.A(stage1_b[10]), .Y(b_inv[10]));
    sky130_fd_sc_hd__inv_1 inv_b_11 (.A(stage1_b[11]), .Y(b_inv[11]));
    sky130_fd_sc_hd__inv_1 inv_b_12 (.A(stage1_b[12]), .Y(b_inv[12]));
    sky130_fd_sc_hd__inv_1 inv_b_13 (.A(stage1_b[13]), .Y(b_inv[13]));
    sky130_fd_sc_hd__inv_1 inv_b_14 (.A(stage1_b[14]), .Y(b_inv[14]));
    sky130_fd_sc_hd__inv_1 inv_b_15 (.A(stage1_b[15]), .Y(b_inv[15]));

    sky130_fd_sc_hd__fa_1 fs_0 (.A(stage1_a[0]), .B(b_inv[0]), .CIN(1'b1), .SUM(alu_sub[0]), .COUT(sub_carry[0]));
    sky130_fd_sc_hd__fa_1 fs_1 (.A(stage1_a[1]), .B(b_inv[1]), .CIN(sub_carry[0]), .SUM(alu_sub[1]), .COUT(sub_carry[1]));
    sky130_fd_sc_hd__fa_1 fs_2 (.A(stage1_a[2]), .B(b_inv[2]), .CIN(sub_carry[1]), .SUM(alu_sub[2]), .COUT(sub_carry[2]));
    sky130_fd_sc_hd__fa_1 fs_3 (.A(stage1_a[3]), .B(b_inv[3]), .CIN(sub_carry[2]), .SUM(alu_sub[3]), .COUT(sub_carry[3]));
    sky130_fd_sc_hd__fa_1 fs_4 (.A(stage1_a[4]), .B(b_inv[4]), .CIN(sub_carry[3]), .SUM(alu_sub[4]), .COUT(sub_carry[4]));
    sky130_fd_sc_hd__fa_1 fs_5 (.A(stage1_a[5]), .B(b_inv[5]), .CIN(sub_carry[4]), .SUM(alu_sub[5]), .COUT(sub_carry[5]));
    sky130_fd_sc_hd__fa_1 fs_6 (.A(stage1_a[6]), .B(b_inv[6]), .CIN(sub_carry[5]), .SUM(alu_sub[6]), .COUT(sub_carry[6]));
    sky130_fd_sc_hd__fa_1 fs_7 (.A(stage1_a[7]), .B(b_inv[7]), .CIN(sub_carry[6]), .SUM(alu_sub[7]), .COUT(sub_carry[7]));
    sky130_fd_sc_hd__fa_1 fs_8 (.A(stage1_a[8]), .B(b_inv[8]), .CIN(sub_carry[7]), .SUM(alu_sub[8]), .COUT(sub_carry[8]));
    sky130_fd_sc_hd__fa_1 fs_9 (.A(stage1_a[9]), .B(b_inv[9]), .CIN(sub_carry[8]), .SUM(alu_sub[9]), .COUT(sub_carry[9]));
    sky130_fd_sc_hd__fa_1 fs_10 (.A(stage1_a[10]), .B(b_inv[10]), .CIN(sub_carry[9]), .SUM(alu_sub[10]), .COUT(sub_carry[10]));
    sky130_fd_sc_hd__fa_1 fs_11 (.A(stage1_a[11]), .B(b_inv[11]), .CIN(sub_carry[10]), .SUM(alu_sub[11]), .COUT(sub_carry[11]));
    sky130_fd_sc_hd__fa_1 fs_12 (.A(stage1_a[12]), .B(b_inv[12]), .CIN(sub_carry[11]), .SUM(alu_sub[12]), .COUT(sub_carry[12]));
    sky130_fd_sc_hd__fa_1 fs_13 (.A(stage1_a[13]), .B(b_inv[13]), .CIN(sub_carry[12]), .SUM(alu_sub[13]), .COUT(sub_carry[13]));
    sky130_fd_sc_hd__fa_1 fs_14 (.A(stage1_a[14]), .B(b_inv[14]), .CIN(sub_carry[13]), .SUM(alu_sub[14]), .COUT(sub_carry[14]));
    sky130_fd_sc_hd__fa_1 fs_15 (.A(stage1_a[15]), .B(b_inv[15]), .CIN(sub_carry[14]), .SUM(alu_sub[15]), .COUT(sub_carry[15]));

    // AND operation
    sky130_fd_sc_hd__and2_1 and_0 (.A(stage1_a[0]), .B(stage1_b[0]), .X(alu_and[0]));
    sky130_fd_sc_hd__and2_1 and_1 (.A(stage1_a[1]), .B(stage1_b[1]), .X(alu_and[1]));
    sky130_fd_sc_hd__and2_1 and_2 (.A(stage1_a[2]), .B(stage1_b[2]), .X(alu_and[2]));
    sky130_fd_sc_hd__and2_1 and_3 (.A(stage1_a[3]), .B(stage1_b[3]), .X(alu_and[3]));
    sky130_fd_sc_hd__and2_1 and_4 (.A(stage1_a[4]), .B(stage1_b[4]), .X(alu_and[4]));
    sky130_fd_sc_hd__and2_1 and_5 (.A(stage1_a[5]), .B(stage1_b[5]), .X(alu_and[5]));
    sky130_fd_sc_hd__and2_1 and_6 (.A(stage1_a[6]), .B(stage1_b[6]), .X(alu_and[6]));
    sky130_fd_sc_hd__and2_1 and_7 (.A(stage1_a[7]), .B(stage1_b[7]), .X(alu_and[7]));
    sky130_fd_sc_hd__and2_1 and_8 (.A(stage1_a[8]), .B(stage1_b[8]), .X(alu_and[8]));
    sky130_fd_sc_hd__and2_1 and_9 (.A(stage1_a[9]), .B(stage1_b[9]), .X(alu_and[9]));
    sky130_fd_sc_hd__and2_1 and_10 (.A(stage1_a[10]), .B(stage1_b[10]), .X(alu_and[10]));
    sky130_fd_sc_hd__and2_1 and_11 (.A(stage1_a[11]), .B(stage1_b[11]), .X(alu_and[11]));
    sky130_fd_sc_hd__and2_1 and_12 (.A(stage1_a[12]), .B(stage1_b[12]), .X(alu_and[12]));
    sky130_fd_sc_hd__and2_1 and_13 (.A(stage1_a[13]), .B(stage1_b[13]), .X(alu_and[13]));
    sky130_fd_sc_hd__and2_1 and_14 (.A(stage1_a[14]), .B(stage1_b[14]), .X(alu_and[14]));
    sky130_fd_sc_hd__and2_1 and_15 (.A(stage1_a[15]), .B(stage1_b[15]), .X(alu_and[15]));

    // OR operation
    sky130_fd_sc_hd__or2_1 or_0 (.A(stage1_a[0]), .B(stage1_b[0]), .X(alu_or[0]));
    sky130_fd_sc_hd__or2_1 or_1 (.A(stage1_a[1]), .B(stage1_b[1]), .X(alu_or[1]));
    sky130_fd_sc_hd__or2_1 or_2 (.A(stage1_a[2]), .B(stage1_b[2]), .X(alu_or[2]));
    sky130_fd_sc_hd__or2_1 or_3 (.A(stage1_a[3]), .B(stage1_b[3]), .X(alu_or[3]));
    sky130_fd_sc_hd__or2_1 or_4 (.A(stage1_a[4]), .B(stage1_b[4]), .X(alu_or[4]));
    sky130_fd_sc_hd__or2_1 or_5 (.A(stage1_a[5]), .B(stage1_b[5]), .X(alu_or[5]));
    sky130_fd_sc_hd__or2_1 or_6 (.A(stage1_a[6]), .B(stage1_b[6]), .X(alu_or[6]));
    sky130_fd_sc_hd__or2_1 or_7 (.A(stage1_a[7]), .B(stage1_b[7]), .X(alu_or[7]));
    sky130_fd_sc_hd__or2_1 or_8 (.A(stage1_a[8]), .B(stage1_b[8]), .X(alu_or[8]));
    sky130_fd_sc_hd__or2_1 or_9 (.A(stage1_a[9]), .B(stage1_b[9]), .X(alu_or[9]));
    sky130_fd_sc_hd__or2_1 or_10 (.A(stage1_a[10]), .B(stage1_b[10]), .X(alu_or[10]));
    sky130_fd_sc_hd__or2_1 or_11 (.A(stage1_a[11]), .B(stage1_b[11]), .X(alu_or[11]));
    sky130_fd_sc_hd__or2_1 or_12 (.A(stage1_a[12]), .B(stage1_b[12]), .X(alu_or[12]));
    sky130_fd_sc_hd__or2_1 or_13 (.A(stage1_a[13]), .B(stage1_b[13]), .X(alu_or[13]));
    sky130_fd_sc_hd__or2_1 or_14 (.A(stage1_a[14]), .B(stage1_b[14]), .X(alu_or[14]));
    sky130_fd_sc_hd__or2_1 or_15 (.A(stage1_a[15]), .B(stage1_b[15]), .X(alu_or[15]));

    // XOR operation
    sky130_fd_sc_hd__xor2_1 xor_0 (.A(stage1_a[0]), .B(stage1_b[0]), .X(alu_xor[0]));
    sky130_fd_sc_hd__xor2_1 xor_1 (.A(stage1_a[1]), .B(stage1_b[1]), .X(alu_xor[1]));
    sky130_fd_sc_hd__xor2_1 xor_2 (.A(stage1_a[2]), .B(stage1_b[2]), .X(alu_xor[2]));
    sky130_fd_sc_hd__xor2_1 xor_3 (.A(stage1_a[3]), .B(stage1_b[3]), .X(alu_xor[3]));
    sky130_fd_sc_hd__xor2_1 xor_4 (.A(stage1_a[4]), .B(stage1_b[4]), .X(alu_xor[4]));
    sky130_fd_sc_hd__xor2_1 xor_5 (.A(stage1_a[5]), .B(stage1_b[5]), .X(alu_xor[5]));
    sky130_fd_sc_hd__xor2_1 xor_6 (.A(stage1_a[6]), .B(stage1_b[6]), .X(alu_xor[6]));
    sky130_fd_sc_hd__xor2_1 xor_7 (.A(stage1_a[7]), .B(stage1_b[7]), .X(alu_xor[7]));
    sky130_fd_sc_hd__xor2_1 xor_8 (.A(stage1_a[8]), .B(stage1_b[8]), .X(alu_xor[8]));
    sky130_fd_sc_hd__xor2_1 xor_9 (.A(stage1_a[9]), .B(stage1_b[9]), .X(alu_xor[9]));
    sky130_fd_sc_hd__xor2_1 xor_10 (.A(stage1_a[10]), .B(stage1_b[10]), .X(alu_xor[10]));
    sky130_fd_sc_hd__xor2_1 xor_11 (.A(stage1_a[11]), .B(stage1_b[11]), .X(alu_xor[11]));
    sky130_fd_sc_hd__xor2_1 xor_12 (.A(stage1_a[12]), .B(stage1_b[12]), .X(alu_xor[12]));
    sky130_fd_sc_hd__xor2_1 xor_13 (.A(stage1_a[13]), .B(stage1_b[13]), .X(alu_xor[13]));
    sky130_fd_sc_hd__xor2_1 xor_14 (.A(stage1_a[14]), .B(stage1_b[14]), .X(alu_xor[14]));
    sky130_fd_sc_hd__xor2_1 xor_15 (.A(stage1_a[15]), .B(stage1_b[15]), .X(alu_xor[15]));

    // MUX for operation selection (simplified - using ADD result based on op_sel[0])
    // op_sel: 000=ADD, 001=SUB, 010=AND, 011=OR, 100=XOR
    wire [15:0] mux_sel_01, mux_sel_23;

    // Level 1: Select between ADD/SUB and AND/OR
    sky130_fd_sc_hd__mux2_1 mux01_0 (.A0(alu_add[0]), .A1(alu_sub[0]), .S(stage1_op[0]), .X(mux_sel_01[0]));
    sky130_fd_sc_hd__mux2_1 mux01_1 (.A0(alu_add[1]), .A1(alu_sub[1]), .S(stage1_op[0]), .X(mux_sel_01[1]));
    sky130_fd_sc_hd__mux2_1 mux01_2 (.A0(alu_add[2]), .A1(alu_sub[2]), .S(stage1_op[0]), .X(mux_sel_01[2]));
    sky130_fd_sc_hd__mux2_1 mux01_3 (.A0(alu_add[3]), .A1(alu_sub[3]), .S(stage1_op[0]), .X(mux_sel_01[3]));
    sky130_fd_sc_hd__mux2_1 mux01_4 (.A0(alu_add[4]), .A1(alu_sub[4]), .S(stage1_op[0]), .X(mux_sel_01[4]));
    sky130_fd_sc_hd__mux2_1 mux01_5 (.A0(alu_add[5]), .A1(alu_sub[5]), .S(stage1_op[0]), .X(mux_sel_01[5]));
    sky130_fd_sc_hd__mux2_1 mux01_6 (.A0(alu_add[6]), .A1(alu_sub[6]), .S(stage1_op[0]), .X(mux_sel_01[6]));
    sky130_fd_sc_hd__mux2_1 mux01_7 (.A0(alu_add[7]), .A1(alu_sub[7]), .S(stage1_op[0]), .X(mux_sel_01[7]));
    sky130_fd_sc_hd__mux2_1 mux01_8 (.A0(alu_add[8]), .A1(alu_sub[8]), .S(stage1_op[0]), .X(mux_sel_01[8]));
    sky130_fd_sc_hd__mux2_1 mux01_9 (.A0(alu_add[9]), .A1(alu_sub[9]), .S(stage1_op[0]), .X(mux_sel_01[9]));
    sky130_fd_sc_hd__mux2_1 mux01_10 (.A0(alu_add[10]), .A1(alu_sub[10]), .S(stage1_op[0]), .X(mux_sel_01[10]));
    sky130_fd_sc_hd__mux2_1 mux01_11 (.A0(alu_add[11]), .A1(alu_sub[11]), .S(stage1_op[0]), .X(mux_sel_01[11]));
    sky130_fd_sc_hd__mux2_1 mux01_12 (.A0(alu_add[12]), .A1(alu_sub[12]), .S(stage1_op[0]), .X(mux_sel_01[12]));
    sky130_fd_sc_hd__mux2_1 mux01_13 (.A0(alu_add[13]), .A1(alu_sub[13]), .S(stage1_op[0]), .X(mux_sel_01[13]));
    sky130_fd_sc_hd__mux2_1 mux01_14 (.A0(alu_add[14]), .A1(alu_sub[14]), .S(stage1_op[0]), .X(mux_sel_01[14]));
    sky130_fd_sc_hd__mux2_1 mux01_15 (.A0(alu_add[15]), .A1(alu_sub[15]), .S(stage1_op[0]), .X(mux_sel_01[15]));

    sky130_fd_sc_hd__mux2_1 mux23_0 (.A0(alu_and[0]), .A1(alu_or[0]), .S(stage1_op[0]), .X(mux_sel_23[0]));
    sky130_fd_sc_hd__mux2_1 mux23_1 (.A0(alu_and[1]), .A1(alu_or[1]), .S(stage1_op[0]), .X(mux_sel_23[1]));
    sky130_fd_sc_hd__mux2_1 mux23_2 (.A0(alu_and[2]), .A1(alu_or[2]), .S(stage1_op[0]), .X(mux_sel_23[2]));
    sky130_fd_sc_hd__mux2_1 mux23_3 (.A0(alu_and[3]), .A1(alu_or[3]), .S(stage1_op[0]), .X(mux_sel_23[3]));
    sky130_fd_sc_hd__mux2_1 mux23_4 (.A0(alu_and[4]), .A1(alu_or[4]), .S(stage1_op[0]), .X(mux_sel_23[4]));
    sky130_fd_sc_hd__mux2_1 mux23_5 (.A0(alu_and[5]), .A1(alu_or[5]), .S(stage1_op[0]), .X(mux_sel_23[5]));
    sky130_fd_sc_hd__mux2_1 mux23_6 (.A0(alu_and[6]), .A1(alu_or[6]), .S(stage1_op[0]), .X(mux_sel_23[6]));
    sky130_fd_sc_hd__mux2_1 mux23_7 (.A0(alu_and[7]), .A1(alu_or[7]), .S(stage1_op[0]), .X(mux_sel_23[7]));
    sky130_fd_sc_hd__mux2_1 mux23_8 (.A0(alu_and[8]), .A1(alu_or[8]), .S(stage1_op[0]), .X(mux_sel_23[8]));
    sky130_fd_sc_hd__mux2_1 mux23_9 (.A0(alu_and[9]), .A1(alu_or[9]), .S(stage1_op[0]), .X(mux_sel_23[9]));
    sky130_fd_sc_hd__mux2_1 mux23_10 (.A0(alu_and[10]), .A1(alu_or[10]), .S(stage1_op[0]), .X(mux_sel_23[10]));
    sky130_fd_sc_hd__mux2_1 mux23_11 (.A0(alu_and[11]), .A1(alu_or[11]), .S(stage1_op[0]), .X(mux_sel_23[11]));
    sky130_fd_sc_hd__mux2_1 mux23_12 (.A0(alu_and[12]), .A1(alu_or[12]), .S(stage1_op[0]), .X(mux_sel_23[12]));
    sky130_fd_sc_hd__mux2_1 mux23_13 (.A0(alu_and[13]), .A1(alu_or[13]), .S(stage1_op[0]), .X(mux_sel_23[13]));
    sky130_fd_sc_hd__mux2_1 mux23_14 (.A0(alu_and[14]), .A1(alu_or[14]), .S(stage1_op[0]), .X(mux_sel_23[14]));
    sky130_fd_sc_hd__mux2_1 mux23_15 (.A0(alu_and[15]), .A1(alu_or[15]), .S(stage1_op[0]), .X(mux_sel_23[15]));

    // Level 2: Select between arithmetic (ADD/SUB) and logic (AND/OR)
    wire [15:0] mux_arith_logic;
    sky130_fd_sc_hd__mux2_1 muxal_0 (.A0(mux_sel_01[0]), .A1(mux_sel_23[0]), .S(stage1_op[1]), .X(mux_arith_logic[0]));
    sky130_fd_sc_hd__mux2_1 muxal_1 (.A0(mux_sel_01[1]), .A1(mux_sel_23[1]), .S(stage1_op[1]), .X(mux_arith_logic[1]));
    sky130_fd_sc_hd__mux2_1 muxal_2 (.A0(mux_sel_01[2]), .A1(mux_sel_23[2]), .S(stage1_op[1]), .X(mux_arith_logic[2]));
    sky130_fd_sc_hd__mux2_1 muxal_3 (.A0(mux_sel_01[3]), .A1(mux_sel_23[3]), .S(stage1_op[1]), .X(mux_arith_logic[3]));
    sky130_fd_sc_hd__mux2_1 muxal_4 (.A0(mux_sel_01[4]), .A1(mux_sel_23[4]), .S(stage1_op[1]), .X(mux_arith_logic[4]));
    sky130_fd_sc_hd__mux2_1 muxal_5 (.A0(mux_sel_01[5]), .A1(mux_sel_23[5]), .S(stage1_op[1]), .X(mux_arith_logic[5]));
    sky130_fd_sc_hd__mux2_1 muxal_6 (.A0(mux_sel_01[6]), .A1(mux_sel_23[6]), .S(stage1_op[1]), .X(mux_arith_logic[6]));
    sky130_fd_sc_hd__mux2_1 muxal_7 (.A0(mux_sel_01[7]), .A1(mux_sel_23[7]), .S(stage1_op[1]), .X(mux_arith_logic[7]));
    sky130_fd_sc_hd__mux2_1 muxal_8 (.A0(mux_sel_01[8]), .A1(mux_sel_23[8]), .S(stage1_op[1]), .X(mux_arith_logic[8]));
    sky130_fd_sc_hd__mux2_1 muxal_9 (.A0(mux_sel_01[9]), .A1(mux_sel_23[9]), .S(stage1_op[1]), .X(mux_arith_logic[9]));
    sky130_fd_sc_hd__mux2_1 muxal_10 (.A0(mux_sel_01[10]), .A1(mux_sel_23[10]), .S(stage1_op[1]), .X(mux_arith_logic[10]));
    sky130_fd_sc_hd__mux2_1 muxal_11 (.A0(mux_sel_01[11]), .A1(mux_sel_23[11]), .S(stage1_op[1]), .X(mux_arith_logic[11]));
    sky130_fd_sc_hd__mux2_1 muxal_12 (.A0(mux_sel_01[12]), .A1(mux_sel_23[12]), .S(stage1_op[1]), .X(mux_arith_logic[12]));
    sky130_fd_sc_hd__mux2_1 muxal_13 (.A0(mux_sel_01[13]), .A1(mux_sel_23[13]), .S(stage1_op[1]), .X(mux_arith_logic[13]));
    sky130_fd_sc_hd__mux2_1 muxal_14 (.A0(mux_sel_01[14]), .A1(mux_sel_23[14]), .S(stage1_op[1]), .X(mux_arith_logic[14]));
    sky130_fd_sc_hd__mux2_1 muxal_15 (.A0(mux_sel_01[15]), .A1(mux_sel_23[15]), .S(stage1_op[1]), .X(mux_arith_logic[15]));

    // Level 3: Select between arith/logic result and XOR
    sky130_fd_sc_hd__mux2_1 muxf_0 (.A0(mux_arith_logic[0]), .A1(alu_xor[0]), .S(stage1_op[2]), .X(alu_mux_out[0]));
    sky130_fd_sc_hd__mux2_1 muxf_1 (.A0(mux_arith_logic[1]), .A1(alu_xor[1]), .S(stage1_op[2]), .X(alu_mux_out[1]));
    sky130_fd_sc_hd__mux2_1 muxf_2 (.A0(mux_arith_logic[2]), .A1(alu_xor[2]), .S(stage1_op[2]), .X(alu_mux_out[2]));
    sky130_fd_sc_hd__mux2_1 muxf_3 (.A0(mux_arith_logic[3]), .A1(alu_xor[3]), .S(stage1_op[2]), .X(alu_mux_out[3]));
    sky130_fd_sc_hd__mux2_1 muxf_4 (.A0(mux_arith_logic[4]), .A1(alu_xor[4]), .S(stage1_op[2]), .X(alu_mux_out[4]));
    sky130_fd_sc_hd__mux2_1 muxf_5 (.A0(mux_arith_logic[5]), .A1(alu_xor[5]), .S(stage1_op[2]), .X(alu_mux_out[5]));
    sky130_fd_sc_hd__mux2_1 muxf_6 (.A0(mux_arith_logic[6]), .A1(alu_xor[6]), .S(stage1_op[2]), .X(alu_mux_out[6]));
    sky130_fd_sc_hd__mux2_1 muxf_7 (.A0(mux_arith_logic[7]), .A1(alu_xor[7]), .S(stage1_op[2]), .X(alu_mux_out[7]));
    sky130_fd_sc_hd__mux2_1 muxf_8 (.A0(mux_arith_logic[8]), .A1(alu_xor[8]), .S(stage1_op[2]), .X(alu_mux_out[8]));
    sky130_fd_sc_hd__mux2_1 muxf_9 (.A0(mux_arith_logic[9]), .A1(alu_xor[9]), .S(stage1_op[2]), .X(alu_mux_out[9]));
    sky130_fd_sc_hd__mux2_1 muxf_10 (.A0(mux_arith_logic[10]), .A1(alu_xor[10]), .S(stage1_op[2]), .X(alu_mux_out[10]));
    sky130_fd_sc_hd__mux2_1 muxf_11 (.A0(mux_arith_logic[11]), .A1(alu_xor[11]), .S(stage1_op[2]), .X(alu_mux_out[11]));
    sky130_fd_sc_hd__mux2_1 muxf_12 (.A0(mux_arith_logic[12]), .A1(alu_xor[12]), .S(stage1_op[2]), .X(alu_mux_out[12]));
    sky130_fd_sc_hd__mux2_1 muxf_13 (.A0(mux_arith_logic[13]), .A1(alu_xor[13]), .S(stage1_op[2]), .X(alu_mux_out[13]));
    sky130_fd_sc_hd__mux2_1 muxf_14 (.A0(mux_arith_logic[14]), .A1(alu_xor[14]), .S(stage1_op[2]), .X(alu_mux_out[14]));
    sky130_fd_sc_hd__mux2_1 muxf_15 (.A0(mux_arith_logic[15]), .A1(alu_xor[15]), .S(stage1_op[2]), .X(alu_mux_out[15]));

    // Stage 2 pipeline registers
    sky130_fd_sc_hd__dfrtp_1 reg_s2_0 (.CLK(clk), .RESET_B(rst_n), .D(alu_mux_out[0]), .Q(stage2_result[0]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_1 (.CLK(clk), .RESET_B(rst_n), .D(alu_mux_out[1]), .Q(stage2_result[1]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_2 (.CLK(clk), .RESET_B(rst_n), .D(alu_mux_out[2]), .Q(stage2_result[2]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_3 (.CLK(clk), .RESET_B(rst_n), .D(alu_mux_out[3]), .Q(stage2_result[3]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_4 (.CLK(clk), .RESET_B(rst_n), .D(alu_mux_out[4]), .Q(stage2_result[4]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_5 (.CLK(clk), .RESET_B(rst_n), .D(alu_mux_out[5]), .Q(stage2_result[5]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_6 (.CLK(clk), .RESET_B(rst_n), .D(alu_mux_out[6]), .Q(stage2_result[6]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_7 (.CLK(clk), .RESET_B(rst_n), .D(alu_mux_out[7]), .Q(stage2_result[7]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_8 (.CLK(clk), .RESET_B(rst_n), .D(alu_mux_out[8]), .Q(stage2_result[8]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_9 (.CLK(clk), .RESET_B(rst_n), .D(alu_mux_out[9]), .Q(stage2_result[9]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_10 (.CLK(clk), .RESET_B(rst_n), .D(alu_mux_out[10]), .Q(stage2_result[10]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_11 (.CLK(clk), .RESET_B(rst_n), .D(alu_mux_out[11]), .Q(stage2_result[11]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_12 (.CLK(clk), .RESET_B(rst_n), .D(alu_mux_out[12]), .Q(stage2_result[12]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_13 (.CLK(clk), .RESET_B(rst_n), .D(alu_mux_out[13]), .Q(stage2_result[13]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_14 (.CLK(clk), .RESET_B(rst_n), .D(alu_mux_out[14]), .Q(stage2_result[14]));
    sky130_fd_sc_hd__dfrtp_1 reg_s2_15 (.CLK(clk), .RESET_B(rst_n), .D(alu_mux_out[15]), .Q(stage2_result[15]));
    sky130_fd_sc_hd__dfrtp_1 reg_valid_2 (.CLK(clk), .RESET_B(rst_n), .D(stage1_valid), .Q(stage2_valid));

    //=========================================================================
    // Stage 3: Accumulator
    //=========================================================================

    wire [15:0] accum_sum;
    wire [15:0] accum_carry;

    sky130_fd_sc_hd__fa_1 acc_0 (.A(stage2_result[0]), .B(stage3_accum[0]), .CIN(1'b0), .SUM(accum_sum[0]), .COUT(accum_carry[0]));
    sky130_fd_sc_hd__fa_1 acc_1 (.A(stage2_result[1]), .B(stage3_accum[1]), .CIN(accum_carry[0]), .SUM(accum_sum[1]), .COUT(accum_carry[1]));
    sky130_fd_sc_hd__fa_1 acc_2 (.A(stage2_result[2]), .B(stage3_accum[2]), .CIN(accum_carry[1]), .SUM(accum_sum[2]), .COUT(accum_carry[2]));
    sky130_fd_sc_hd__fa_1 acc_3 (.A(stage2_result[3]), .B(stage3_accum[3]), .CIN(accum_carry[2]), .SUM(accum_sum[3]), .COUT(accum_carry[3]));
    sky130_fd_sc_hd__fa_1 acc_4 (.A(stage2_result[4]), .B(stage3_accum[4]), .CIN(accum_carry[3]), .SUM(accum_sum[4]), .COUT(accum_carry[4]));
    sky130_fd_sc_hd__fa_1 acc_5 (.A(stage2_result[5]), .B(stage3_accum[5]), .CIN(accum_carry[4]), .SUM(accum_sum[5]), .COUT(accum_carry[5]));
    sky130_fd_sc_hd__fa_1 acc_6 (.A(stage2_result[6]), .B(stage3_accum[6]), .CIN(accum_carry[5]), .SUM(accum_sum[6]), .COUT(accum_carry[6]));
    sky130_fd_sc_hd__fa_1 acc_7 (.A(stage2_result[7]), .B(stage3_accum[7]), .CIN(accum_carry[6]), .SUM(accum_sum[7]), .COUT(accum_carry[7]));
    sky130_fd_sc_hd__fa_1 acc_8 (.A(stage2_result[8]), .B(stage3_accum[8]), .CIN(accum_carry[7]), .SUM(accum_sum[8]), .COUT(accum_carry[8]));
    sky130_fd_sc_hd__fa_1 acc_9 (.A(stage2_result[9]), .B(stage3_accum[9]), .CIN(accum_carry[8]), .SUM(accum_sum[9]), .COUT(accum_carry[9]));
    sky130_fd_sc_hd__fa_1 acc_10 (.A(stage2_result[10]), .B(stage3_accum[10]), .CIN(accum_carry[9]), .SUM(accum_sum[10]), .COUT(accum_carry[10]));
    sky130_fd_sc_hd__fa_1 acc_11 (.A(stage2_result[11]), .B(stage3_accum[11]), .CIN(accum_carry[10]), .SUM(accum_sum[11]), .COUT(accum_carry[11]));
    sky130_fd_sc_hd__fa_1 acc_12 (.A(stage2_result[12]), .B(stage3_accum[12]), .CIN(accum_carry[11]), .SUM(accum_sum[12]), .COUT(accum_carry[12]));
    sky130_fd_sc_hd__fa_1 acc_13 (.A(stage2_result[13]), .B(stage3_accum[13]), .CIN(accum_carry[12]), .SUM(accum_sum[13]), .COUT(accum_carry[13]));
    sky130_fd_sc_hd__fa_1 acc_14 (.A(stage2_result[14]), .B(stage3_accum[14]), .CIN(accum_carry[13]), .SUM(accum_sum[14]), .COUT(accum_carry[14]));
    sky130_fd_sc_hd__fa_1 acc_15 (.A(stage2_result[15]), .B(stage3_accum[15]), .CIN(accum_carry[14]), .SUM(accum_sum[15]), .COUT(accum_carry[15]));

    // Stage 3 registers (accumulator)
    sky130_fd_sc_hd__dfrtp_1 reg_s3_0 (.CLK(clk), .RESET_B(rst_n), .D(accum_sum[0]), .Q(stage3_accum[0]));
    sky130_fd_sc_hd__dfrtp_1 reg_s3_1 (.CLK(clk), .RESET_B(rst_n), .D(accum_sum[1]), .Q(stage3_accum[1]));
    sky130_fd_sc_hd__dfrtp_1 reg_s3_2 (.CLK(clk), .RESET_B(rst_n), .D(accum_sum[2]), .Q(stage3_accum[2]));
    sky130_fd_sc_hd__dfrtp_1 reg_s3_3 (.CLK(clk), .RESET_B(rst_n), .D(accum_sum[3]), .Q(stage3_accum[3]));
    sky130_fd_sc_hd__dfrtp_1 reg_s3_4 (.CLK(clk), .RESET_B(rst_n), .D(accum_sum[4]), .Q(stage3_accum[4]));
    sky130_fd_sc_hd__dfrtp_1 reg_s3_5 (.CLK(clk), .RESET_B(rst_n), .D(accum_sum[5]), .Q(stage3_accum[5]));
    sky130_fd_sc_hd__dfrtp_1 reg_s3_6 (.CLK(clk), .RESET_B(rst_n), .D(accum_sum[6]), .Q(stage3_accum[6]));
    sky130_fd_sc_hd__dfrtp_1 reg_s3_7 (.CLK(clk), .RESET_B(rst_n), .D(accum_sum[7]), .Q(stage3_accum[7]));
    sky130_fd_sc_hd__dfrtp_1 reg_s3_8 (.CLK(clk), .RESET_B(rst_n), .D(accum_sum[8]), .Q(stage3_accum[8]));
    sky130_fd_sc_hd__dfrtp_1 reg_s3_9 (.CLK(clk), .RESET_B(rst_n), .D(accum_sum[9]), .Q(stage3_accum[9]));
    sky130_fd_sc_hd__dfrtp_1 reg_s3_10 (.CLK(clk), .RESET_B(rst_n), .D(accum_sum[10]), .Q(stage3_accum[10]));
    sky130_fd_sc_hd__dfrtp_1 reg_s3_11 (.CLK(clk), .RESET_B(rst_n), .D(accum_sum[11]), .Q(stage3_accum[11]));
    sky130_fd_sc_hd__dfrtp_1 reg_s3_12 (.CLK(clk), .RESET_B(rst_n), .D(accum_sum[12]), .Q(stage3_accum[12]));
    sky130_fd_sc_hd__dfrtp_1 reg_s3_13 (.CLK(clk), .RESET_B(rst_n), .D(accum_sum[13]), .Q(stage3_accum[13]));
    sky130_fd_sc_hd__dfrtp_1 reg_s3_14 (.CLK(clk), .RESET_B(rst_n), .D(accum_sum[14]), .Q(stage3_accum[14]));
    sky130_fd_sc_hd__dfrtp_1 reg_s3_15 (.CLK(clk), .RESET_B(rst_n), .D(accum_sum[15]), .Q(stage3_accum[15]));
    sky130_fd_sc_hd__dfrtp_1 reg_valid_3 (.CLK(clk), .RESET_B(rst_n), .D(stage2_valid), .Q(stage3_valid));

    //=========================================================================
    // Stage 4: Output Registers
    //=========================================================================

    sky130_fd_sc_hd__dfrtp_1 reg_s4_0 (.CLK(clk), .RESET_B(rst_n), .D(stage3_accum[0]), .Q(stage4_out[0]));
    sky130_fd_sc_hd__dfrtp_1 reg_s4_1 (.CLK(clk), .RESET_B(rst_n), .D(stage3_accum[1]), .Q(stage4_out[1]));
    sky130_fd_sc_hd__dfrtp_1 reg_s4_2 (.CLK(clk), .RESET_B(rst_n), .D(stage3_accum[2]), .Q(stage4_out[2]));
    sky130_fd_sc_hd__dfrtp_1 reg_s4_3 (.CLK(clk), .RESET_B(rst_n), .D(stage3_accum[3]), .Q(stage4_out[3]));
    sky130_fd_sc_hd__dfrtp_1 reg_s4_4 (.CLK(clk), .RESET_B(rst_n), .D(stage3_accum[4]), .Q(stage4_out[4]));
    sky130_fd_sc_hd__dfrtp_1 reg_s4_5 (.CLK(clk), .RESET_B(rst_n), .D(stage3_accum[5]), .Q(stage4_out[5]));
    sky130_fd_sc_hd__dfrtp_1 reg_s4_6 (.CLK(clk), .RESET_B(rst_n), .D(stage3_accum[6]), .Q(stage4_out[6]));
    sky130_fd_sc_hd__dfrtp_1 reg_s4_7 (.CLK(clk), .RESET_B(rst_n), .D(stage3_accum[7]), .Q(stage4_out[7]));
    sky130_fd_sc_hd__dfrtp_1 reg_s4_8 (.CLK(clk), .RESET_B(rst_n), .D(stage3_accum[8]), .Q(stage4_out[8]));
    sky130_fd_sc_hd__dfrtp_1 reg_s4_9 (.CLK(clk), .RESET_B(rst_n), .D(stage3_accum[9]), .Q(stage4_out[9]));
    sky130_fd_sc_hd__dfrtp_1 reg_s4_10 (.CLK(clk), .RESET_B(rst_n), .D(stage3_accum[10]), .Q(stage4_out[10]));
    sky130_fd_sc_hd__dfrtp_1 reg_s4_11 (.CLK(clk), .RESET_B(rst_n), .D(stage3_accum[11]), .Q(stage4_out[11]));
    sky130_fd_sc_hd__dfrtp_1 reg_s4_12 (.CLK(clk), .RESET_B(rst_n), .D(stage3_accum[12]), .Q(stage4_out[12]));
    sky130_fd_sc_hd__dfrtp_1 reg_s4_13 (.CLK(clk), .RESET_B(rst_n), .D(stage3_accum[13]), .Q(stage4_out[13]));
    sky130_fd_sc_hd__dfrtp_1 reg_s4_14 (.CLK(clk), .RESET_B(rst_n), .D(stage3_accum[14]), .Q(stage4_out[14]));
    sky130_fd_sc_hd__dfrtp_1 reg_s4_15 (.CLK(clk), .RESET_B(rst_n), .D(stage3_accum[15]), .Q(stage4_out[15]));
    sky130_fd_sc_hd__dfrtp_1 reg_valid_4 (.CLK(clk), .RESET_B(rst_n), .D(stage3_valid), .Q(stage4_valid));

    // Output assignments
    assign result = stage4_out;
    assign valid_out = stage4_valid;

endmodule
