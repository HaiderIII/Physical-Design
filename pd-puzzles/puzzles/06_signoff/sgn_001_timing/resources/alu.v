// Simple 8-bit ALU for timing signoff puzzle
// Pre-synthesized netlist using Nangate45 cells

module alu (
    input clk,
    input rst_n,
    input [7:0] a,
    input [7:0] b,
    input [1:0] op,
    output [7:0] result,
    output zero
);

    // Input register wires
    wire [7:0] a_reg, b_reg;
    wire [1:0] op_reg;

    // Operation result wires
    wire [7:0] add_out, and_out, or_out, xor_out;
    wire [7:0] mux_out;

    // MUX intermediate wires
    wire [7:0] mux_01, mux_23;

    // Output register wires
    wire [7:0] result_reg;

    // Carry wires for adder
    wire c0, c1, c2, c3, c4, c5, c6, c7;

    // ========================================
    // Input Registers
    // ========================================
    DFFR_X1 a_r0 (.D(a[0]), .CK(clk), .RN(rst_n), .Q(a_reg[0]));
    DFFR_X1 a_r1 (.D(a[1]), .CK(clk), .RN(rst_n), .Q(a_reg[1]));
    DFFR_X1 a_r2 (.D(a[2]), .CK(clk), .RN(rst_n), .Q(a_reg[2]));
    DFFR_X1 a_r3 (.D(a[3]), .CK(clk), .RN(rst_n), .Q(a_reg[3]));
    DFFR_X1 a_r4 (.D(a[4]), .CK(clk), .RN(rst_n), .Q(a_reg[4]));
    DFFR_X1 a_r5 (.D(a[5]), .CK(clk), .RN(rst_n), .Q(a_reg[5]));
    DFFR_X1 a_r6 (.D(a[6]), .CK(clk), .RN(rst_n), .Q(a_reg[6]));
    DFFR_X1 a_r7 (.D(a[7]), .CK(clk), .RN(rst_n), .Q(a_reg[7]));

    DFFR_X1 b_r0 (.D(b[0]), .CK(clk), .RN(rst_n), .Q(b_reg[0]));
    DFFR_X1 b_r1 (.D(b[1]), .CK(clk), .RN(rst_n), .Q(b_reg[1]));
    DFFR_X1 b_r2 (.D(b[2]), .CK(clk), .RN(rst_n), .Q(b_reg[2]));
    DFFR_X1 b_r3 (.D(b[3]), .CK(clk), .RN(rst_n), .Q(b_reg[3]));
    DFFR_X1 b_r4 (.D(b[4]), .CK(clk), .RN(rst_n), .Q(b_reg[4]));
    DFFR_X1 b_r5 (.D(b[5]), .CK(clk), .RN(rst_n), .Q(b_reg[5]));
    DFFR_X1 b_r6 (.D(b[6]), .CK(clk), .RN(rst_n), .Q(b_reg[6]));
    DFFR_X1 b_r7 (.D(b[7]), .CK(clk), .RN(rst_n), .Q(b_reg[7]));

    DFFR_X1 op_r0 (.D(op[0]), .CK(clk), .RN(rst_n), .Q(op_reg[0]));
    DFFR_X1 op_r1 (.D(op[1]), .CK(clk), .RN(rst_n), .Q(op_reg[1]));

    // ========================================
    // ADD operation (ripple carry adder)
    // ========================================
    HA_X1 add0 (.A(a_reg[0]), .B(b_reg[0]), .CO(c0), .S(add_out[0]));
    FA_X1 add1 (.A(a_reg[1]), .B(b_reg[1]), .CI(c0), .CO(c1), .S(add_out[1]));
    FA_X1 add2 (.A(a_reg[2]), .B(b_reg[2]), .CI(c1), .CO(c2), .S(add_out[2]));
    FA_X1 add3 (.A(a_reg[3]), .B(b_reg[3]), .CI(c2), .CO(c3), .S(add_out[3]));
    FA_X1 add4 (.A(a_reg[4]), .B(b_reg[4]), .CI(c3), .CO(c4), .S(add_out[4]));
    FA_X1 add5 (.A(a_reg[5]), .B(b_reg[5]), .CI(c4), .CO(c5), .S(add_out[5]));
    FA_X1 add6 (.A(a_reg[6]), .B(b_reg[6]), .CI(c5), .CO(c6), .S(add_out[6]));
    FA_X1 add7 (.A(a_reg[7]), .B(b_reg[7]), .CI(c6), .CO(c7), .S(add_out[7]));

    // ========================================
    // AND operation
    // ========================================
    AND2_X1 and0 (.A1(a_reg[0]), .A2(b_reg[0]), .ZN(and_out[0]));
    AND2_X1 and1 (.A1(a_reg[1]), .A2(b_reg[1]), .ZN(and_out[1]));
    AND2_X1 and2 (.A1(a_reg[2]), .A2(b_reg[2]), .ZN(and_out[2]));
    AND2_X1 and3 (.A1(a_reg[3]), .A2(b_reg[3]), .ZN(and_out[3]));
    AND2_X1 and4 (.A1(a_reg[4]), .A2(b_reg[4]), .ZN(and_out[4]));
    AND2_X1 and5 (.A1(a_reg[5]), .A2(b_reg[5]), .ZN(and_out[5]));
    AND2_X1 and6 (.A1(a_reg[6]), .A2(b_reg[6]), .ZN(and_out[6]));
    AND2_X1 and7 (.A1(a_reg[7]), .A2(b_reg[7]), .ZN(and_out[7]));

    // ========================================
    // OR operation
    // ========================================
    OR2_X1 or0 (.A1(a_reg[0]), .A2(b_reg[0]), .ZN(or_out[0]));
    OR2_X1 or1 (.A1(a_reg[1]), .A2(b_reg[1]), .ZN(or_out[1]));
    OR2_X1 or2 (.A1(a_reg[2]), .A2(b_reg[2]), .ZN(or_out[2]));
    OR2_X1 or3 (.A1(a_reg[3]), .A2(b_reg[3]), .ZN(or_out[3]));
    OR2_X1 or4 (.A1(a_reg[4]), .A2(b_reg[4]), .ZN(or_out[4]));
    OR2_X1 or5 (.A1(a_reg[5]), .A2(b_reg[5]), .ZN(or_out[5]));
    OR2_X1 or6 (.A1(a_reg[6]), .A2(b_reg[6]), .ZN(or_out[6]));
    OR2_X1 or7 (.A1(a_reg[7]), .A2(b_reg[7]), .ZN(or_out[7]));

    // ========================================
    // XOR operation
    // ========================================
    XOR2_X1 xor0 (.A(a_reg[0]), .B(b_reg[0]), .Z(xor_out[0]));
    XOR2_X1 xor1 (.A(a_reg[1]), .B(b_reg[1]), .Z(xor_out[1]));
    XOR2_X1 xor2 (.A(a_reg[2]), .B(b_reg[2]), .Z(xor_out[2]));
    XOR2_X1 xor3 (.A(a_reg[3]), .B(b_reg[3]), .Z(xor_out[3]));
    XOR2_X1 xor4 (.A(a_reg[4]), .B(b_reg[4]), .Z(xor_out[4]));
    XOR2_X1 xor5 (.A(a_reg[5]), .B(b_reg[5]), .Z(xor_out[5]));
    XOR2_X1 xor6 (.A(a_reg[6]), .B(b_reg[6]), .Z(xor_out[6]));
    XOR2_X1 xor7 (.A(a_reg[7]), .B(b_reg[7]), .Z(xor_out[7]));

    // ========================================
    // Output MUX (4:1 using cascade of 2:1)
    // op=00: ADD, op=01: AND, op=10: OR, op=11: XOR
    // MUX2_X1: S=0 -> A, S=1 -> B
    // ========================================
    // First level: select between ADD/AND and OR/XOR
    MUX2_X1 m01_0 (.A(add_out[0]), .B(and_out[0]), .S(op_reg[0]), .Z(mux_01[0]));
    MUX2_X1 m01_1 (.A(add_out[1]), .B(and_out[1]), .S(op_reg[0]), .Z(mux_01[1]));
    MUX2_X1 m01_2 (.A(add_out[2]), .B(and_out[2]), .S(op_reg[0]), .Z(mux_01[2]));
    MUX2_X1 m01_3 (.A(add_out[3]), .B(and_out[3]), .S(op_reg[0]), .Z(mux_01[3]));
    MUX2_X1 m01_4 (.A(add_out[4]), .B(and_out[4]), .S(op_reg[0]), .Z(mux_01[4]));
    MUX2_X1 m01_5 (.A(add_out[5]), .B(and_out[5]), .S(op_reg[0]), .Z(mux_01[5]));
    MUX2_X1 m01_6 (.A(add_out[6]), .B(and_out[6]), .S(op_reg[0]), .Z(mux_01[6]));
    MUX2_X1 m01_7 (.A(add_out[7]), .B(and_out[7]), .S(op_reg[0]), .Z(mux_01[7]));

    MUX2_X1 m23_0 (.A(or_out[0]), .B(xor_out[0]), .S(op_reg[0]), .Z(mux_23[0]));
    MUX2_X1 m23_1 (.A(or_out[1]), .B(xor_out[1]), .S(op_reg[0]), .Z(mux_23[1]));
    MUX2_X1 m23_2 (.A(or_out[2]), .B(xor_out[2]), .S(op_reg[0]), .Z(mux_23[2]));
    MUX2_X1 m23_3 (.A(or_out[3]), .B(xor_out[3]), .S(op_reg[0]), .Z(mux_23[3]));
    MUX2_X1 m23_4 (.A(or_out[4]), .B(xor_out[4]), .S(op_reg[0]), .Z(mux_23[4]));
    MUX2_X1 m23_5 (.A(or_out[5]), .B(xor_out[5]), .S(op_reg[0]), .Z(mux_23[5]));
    MUX2_X1 m23_6 (.A(or_out[6]), .B(xor_out[6]), .S(op_reg[0]), .Z(mux_23[6]));
    MUX2_X1 m23_7 (.A(or_out[7]), .B(xor_out[7]), .S(op_reg[0]), .Z(mux_23[7]));

    // Second level: final selection
    MUX2_X1 mf_0 (.A(mux_01[0]), .B(mux_23[0]), .S(op_reg[1]), .Z(mux_out[0]));
    MUX2_X1 mf_1 (.A(mux_01[1]), .B(mux_23[1]), .S(op_reg[1]), .Z(mux_out[1]));
    MUX2_X1 mf_2 (.A(mux_01[2]), .B(mux_23[2]), .S(op_reg[1]), .Z(mux_out[2]));
    MUX2_X1 mf_3 (.A(mux_01[3]), .B(mux_23[3]), .S(op_reg[1]), .Z(mux_out[3]));
    MUX2_X1 mf_4 (.A(mux_01[4]), .B(mux_23[4]), .S(op_reg[1]), .Z(mux_out[4]));
    MUX2_X1 mf_5 (.A(mux_01[5]), .B(mux_23[5]), .S(op_reg[1]), .Z(mux_out[5]));
    MUX2_X1 mf_6 (.A(mux_01[6]), .B(mux_23[6]), .S(op_reg[1]), .Z(mux_out[6]));
    MUX2_X1 mf_7 (.A(mux_01[7]), .B(mux_23[7]), .S(op_reg[1]), .Z(mux_out[7]));

    // ========================================
    // Output Registers
    // ========================================
    DFFR_X1 res_r0 (.D(mux_out[0]), .CK(clk), .RN(rst_n), .Q(result_reg[0]));
    DFFR_X1 res_r1 (.D(mux_out[1]), .CK(clk), .RN(rst_n), .Q(result_reg[1]));
    DFFR_X1 res_r2 (.D(mux_out[2]), .CK(clk), .RN(rst_n), .Q(result_reg[2]));
    DFFR_X1 res_r3 (.D(mux_out[3]), .CK(clk), .RN(rst_n), .Q(result_reg[3]));
    DFFR_X1 res_r4 (.D(mux_out[4]), .CK(clk), .RN(rst_n), .Q(result_reg[4]));
    DFFR_X1 res_r5 (.D(mux_out[5]), .CK(clk), .RN(rst_n), .Q(result_reg[5]));
    DFFR_X1 res_r6 (.D(mux_out[6]), .CK(clk), .RN(rst_n), .Q(result_reg[6]));
    DFFR_X1 res_r7 (.D(mux_out[7]), .CK(clk), .RN(rst_n), .Q(result_reg[7]));

    // ========================================
    // Output buffers
    // ========================================
    BUF_X1 ob0 (.A(result_reg[0]), .Z(result[0]));
    BUF_X1 ob1 (.A(result_reg[1]), .Z(result[1]));
    BUF_X1 ob2 (.A(result_reg[2]), .Z(result[2]));
    BUF_X1 ob3 (.A(result_reg[3]), .Z(result[3]));
    BUF_X1 ob4 (.A(result_reg[4]), .Z(result[4]));
    BUF_X1 ob5 (.A(result_reg[5]), .Z(result[5]));
    BUF_X1 ob6 (.A(result_reg[6]), .Z(result[6]));
    BUF_X1 ob7 (.A(result_reg[7]), .Z(result[7]));

    // Zero flag (result == 0)
    wire nz0, nz1;
    NOR4_X1 nz_0 (.A1(result_reg[0]), .A2(result_reg[1]), .A3(result_reg[2]), .A4(result_reg[3]), .ZN(nz0));
    NOR4_X1 nz_1 (.A1(result_reg[4]), .A2(result_reg[5]), .A3(result_reg[6]), .A4(result_reg[7]), .ZN(nz1));
    AND2_X1 zf (.A1(nz0), .A2(nz1), .ZN(zero));

endmodule
