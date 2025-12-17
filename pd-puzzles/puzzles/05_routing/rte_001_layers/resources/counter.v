// Pre-synthesized netlist for counter bank
// 4 x 8-bit counters with routing complexity

module counter_bank (
    input clk,
    input rst_n,
    input enable,
    input [7:0] data_in,
    output [7:0] data_out,
    output overflow
);

    // Counter register wires
    wire [7:0] cnt0, cnt1, cnt2;

    // Adder output wires
    wire [7:0] add0;

    // Pipeline wires
    wire [7:0] pipe1, pipe2;

    // Internal logic wires
    wire [7:0] xor_out, and_out;

    // Carry wires
    wire c0_0, c0_1, c0_2, c0_3, c0_4, c0_5, c0_6, c0_7;

    // ========================================
    // Counter 0: 8-bit register
    // ========================================
    DFFR_X1 c0_r0 (.D(add0[0]), .CK(clk), .RN(rst_n), .Q(cnt0[0]));
    DFFR_X1 c0_r1 (.D(add0[1]), .CK(clk), .RN(rst_n), .Q(cnt0[1]));
    DFFR_X1 c0_r2 (.D(add0[2]), .CK(clk), .RN(rst_n), .Q(cnt0[2]));
    DFFR_X1 c0_r3 (.D(add0[3]), .CK(clk), .RN(rst_n), .Q(cnt0[3]));
    DFFR_X1 c0_r4 (.D(add0[4]), .CK(clk), .RN(rst_n), .Q(cnt0[4]));
    DFFR_X1 c0_r5 (.D(add0[5]), .CK(clk), .RN(rst_n), .Q(cnt0[5]));
    DFFR_X1 c0_r6 (.D(add0[6]), .CK(clk), .RN(rst_n), .Q(cnt0[6]));
    DFFR_X1 c0_r7 (.D(add0[7]), .CK(clk), .RN(rst_n), .Q(cnt0[7]));

    // Counter 0 increment logic (cnt0 + enable)
    HA_X1 c0_ha0 (.A(cnt0[0]), .B(enable),  .CO(c0_0), .S(add0[0]));
    HA_X1 c0_ha1 (.A(cnt0[1]), .B(c0_0),    .CO(c0_1), .S(add0[1]));
    HA_X1 c0_ha2 (.A(cnt0[2]), .B(c0_1),    .CO(c0_2), .S(add0[2]));
    HA_X1 c0_ha3 (.A(cnt0[3]), .B(c0_2),    .CO(c0_3), .S(add0[3]));
    HA_X1 c0_ha4 (.A(cnt0[4]), .B(c0_3),    .CO(c0_4), .S(add0[4]));
    HA_X1 c0_ha5 (.A(cnt0[5]), .B(c0_4),    .CO(c0_5), .S(add0[5]));
    HA_X1 c0_ha6 (.A(cnt0[6]), .B(c0_5),    .CO(c0_6), .S(add0[6]));
    HA_X1 c0_ha7 (.A(cnt0[7]), .B(c0_6),    .CO(c0_7), .S(add0[7]));

    // ========================================
    // Counter 1: XOR with data_in
    // ========================================
    DFFR_X1 c1_r0 (.D(xor_out[0]), .CK(clk), .RN(rst_n), .Q(cnt1[0]));
    DFFR_X1 c1_r1 (.D(xor_out[1]), .CK(clk), .RN(rst_n), .Q(cnt1[1]));
    DFFR_X1 c1_r2 (.D(xor_out[2]), .CK(clk), .RN(rst_n), .Q(cnt1[2]));
    DFFR_X1 c1_r3 (.D(xor_out[3]), .CK(clk), .RN(rst_n), .Q(cnt1[3]));
    DFFR_X1 c1_r4 (.D(xor_out[4]), .CK(clk), .RN(rst_n), .Q(cnt1[4]));
    DFFR_X1 c1_r5 (.D(xor_out[5]), .CK(clk), .RN(rst_n), .Q(cnt1[5]));
    DFFR_X1 c1_r6 (.D(xor_out[6]), .CK(clk), .RN(rst_n), .Q(cnt1[6]));
    DFFR_X1 c1_r7 (.D(xor_out[7]), .CK(clk), .RN(rst_n), .Q(cnt1[7]));

    XOR2_X1 x0 (.A(cnt0[0]), .B(data_in[0]), .Z(xor_out[0]));
    XOR2_X1 x1 (.A(cnt0[1]), .B(data_in[1]), .Z(xor_out[1]));
    XOR2_X1 x2 (.A(cnt0[2]), .B(data_in[2]), .Z(xor_out[2]));
    XOR2_X1 x3 (.A(cnt0[3]), .B(data_in[3]), .Z(xor_out[3]));
    XOR2_X1 x4 (.A(cnt0[4]), .B(data_in[4]), .Z(xor_out[4]));
    XOR2_X1 x5 (.A(cnt0[5]), .B(data_in[5]), .Z(xor_out[5]));
    XOR2_X1 x6 (.A(cnt0[6]), .B(data_in[6]), .Z(xor_out[6]));
    XOR2_X1 x7 (.A(cnt0[7]), .B(data_in[7]), .Z(xor_out[7]));

    // ========================================
    // Counter 2: AND chain
    // ========================================
    DFFR_X1 c2_r0 (.D(and_out[0]), .CK(clk), .RN(rst_n), .Q(cnt2[0]));
    DFFR_X1 c2_r1 (.D(and_out[1]), .CK(clk), .RN(rst_n), .Q(cnt2[1]));
    DFFR_X1 c2_r2 (.D(and_out[2]), .CK(clk), .RN(rst_n), .Q(cnt2[2]));
    DFFR_X1 c2_r3 (.D(and_out[3]), .CK(clk), .RN(rst_n), .Q(cnt2[3]));
    DFFR_X1 c2_r4 (.D(and_out[4]), .CK(clk), .RN(rst_n), .Q(cnt2[4]));
    DFFR_X1 c2_r5 (.D(and_out[5]), .CK(clk), .RN(rst_n), .Q(cnt2[5]));
    DFFR_X1 c2_r6 (.D(and_out[6]), .CK(clk), .RN(rst_n), .Q(cnt2[6]));
    DFFR_X1 c2_r7 (.D(and_out[7]), .CK(clk), .RN(rst_n), .Q(cnt2[7]));

    AND2_X1 a0 (.A1(cnt1[0]), .A2(cnt0[7]), .ZN(and_out[0]));
    AND2_X1 a1 (.A1(cnt1[1]), .A2(cnt0[6]), .ZN(and_out[1]));
    AND2_X1 a2 (.A1(cnt1[2]), .A2(cnt0[5]), .ZN(and_out[2]));
    AND2_X1 a3 (.A1(cnt1[3]), .A2(cnt0[4]), .ZN(and_out[3]));
    AND2_X1 a4 (.A1(cnt1[4]), .A2(cnt0[3]), .ZN(and_out[4]));
    AND2_X1 a5 (.A1(cnt1[5]), .A2(cnt0[2]), .ZN(and_out[5]));
    AND2_X1 a6 (.A1(cnt1[6]), .A2(cnt0[1]), .ZN(and_out[6]));
    AND2_X1 a7 (.A1(cnt1[7]), .A2(cnt0[0]), .ZN(and_out[7]));

    // ========================================
    // Pipeline stage 1
    // ========================================
    DFFR_X1 p1_r0 (.D(cnt2[0]), .CK(clk), .RN(rst_n), .Q(pipe1[0]));
    DFFR_X1 p1_r1 (.D(cnt2[1]), .CK(clk), .RN(rst_n), .Q(pipe1[1]));
    DFFR_X1 p1_r2 (.D(cnt2[2]), .CK(clk), .RN(rst_n), .Q(pipe1[2]));
    DFFR_X1 p1_r3 (.D(cnt2[3]), .CK(clk), .RN(rst_n), .Q(pipe1[3]));
    DFFR_X1 p1_r4 (.D(cnt2[4]), .CK(clk), .RN(rst_n), .Q(pipe1[4]));
    DFFR_X1 p1_r5 (.D(cnt2[5]), .CK(clk), .RN(rst_n), .Q(pipe1[5]));
    DFFR_X1 p1_r6 (.D(cnt2[6]), .CK(clk), .RN(rst_n), .Q(pipe1[6]));
    DFFR_X1 p1_r7 (.D(cnt2[7]), .CK(clk), .RN(rst_n), .Q(pipe1[7]));

    // ========================================
    // Pipeline stage 2
    // ========================================
    DFFR_X1 p2_r0 (.D(pipe1[0]), .CK(clk), .RN(rst_n), .Q(pipe2[0]));
    DFFR_X1 p2_r1 (.D(pipe1[1]), .CK(clk), .RN(rst_n), .Q(pipe2[1]));
    DFFR_X1 p2_r2 (.D(pipe1[2]), .CK(clk), .RN(rst_n), .Q(pipe2[2]));
    DFFR_X1 p2_r3 (.D(pipe1[3]), .CK(clk), .RN(rst_n), .Q(pipe2[3]));
    DFFR_X1 p2_r4 (.D(pipe1[4]), .CK(clk), .RN(rst_n), .Q(pipe2[4]));
    DFFR_X1 p2_r5 (.D(pipe1[5]), .CK(clk), .RN(rst_n), .Q(pipe2[5]));
    DFFR_X1 p2_r6 (.D(pipe1[6]), .CK(clk), .RN(rst_n), .Q(pipe2[6]));
    DFFR_X1 p2_r7 (.D(pipe1[7]), .CK(clk), .RN(rst_n), .Q(pipe2[7]));

    // ========================================
    // Output buffers
    // ========================================
    BUF_X1 ob0 (.A(pipe2[0]), .Z(data_out[0]));
    BUF_X1 ob1 (.A(pipe2[1]), .Z(data_out[1]));
    BUF_X1 ob2 (.A(pipe2[2]), .Z(data_out[2]));
    BUF_X1 ob3 (.A(pipe2[3]), .Z(data_out[3]));
    BUF_X1 ob4 (.A(pipe2[4]), .Z(data_out[4]));
    BUF_X1 ob5 (.A(pipe2[5]), .Z(data_out[5]));
    BUF_X1 ob6 (.A(pipe2[6]), .Z(data_out[6]));
    BUF_X1 ob7 (.A(pipe2[7]), .Z(data_out[7]));

    // Overflow detection
    AND2_X1 ovf (.A1(c0_7), .A2(enable), .ZN(overflow));

endmodule
