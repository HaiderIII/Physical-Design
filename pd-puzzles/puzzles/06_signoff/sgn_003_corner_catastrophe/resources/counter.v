// 8-bit Counter - Pre-synthesized ASAP7 RVT netlist
// For multi-corner signoff puzzle

module counter (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       enable,
    output wire [7:0] count
);

    // Counter flip-flops
    wire [7:0] q;
    wire [7:0] d;
    wire [7:0] qn;

    // Carry chain
    wire c0, c1, c2, c3, c4, c5, c6;

    // Enable logic
    wire enable_buf;
    BUFx4_ASAP7_75t_R buf_en (.A(enable), .Y(enable_buf));

    // Bit 0: toggle when enabled
    XOR2x2_ASAP7_75t_R xor0 (.A(q[0]), .B(enable_buf), .Y(d[0]));
    DFFHQNx1_ASAP7_75t_R ff0 (.D(d[0]), .CLK(clk), .QN(qn[0]));
    INVx1_ASAP7_75t_R inv0 (.A(qn[0]), .Y(q[0]));
    AND2x2_ASAP7_75t_R and_c0 (.A(q[0]), .B(enable_buf), .Y(c0));

    // Bit 1
    XOR2x2_ASAP7_75t_R xor1 (.A(q[1]), .B(c0), .Y(d[1]));
    DFFHQNx1_ASAP7_75t_R ff1 (.D(d[1]), .CLK(clk), .QN(qn[1]));
    INVx1_ASAP7_75t_R inv1 (.A(qn[1]), .Y(q[1]));
    AND2x2_ASAP7_75t_R and_c1 (.A(q[1]), .B(c0), .Y(c1));

    // Bit 2
    XOR2x2_ASAP7_75t_R xor2 (.A(q[2]), .B(c1), .Y(d[2]));
    DFFHQNx1_ASAP7_75t_R ff2 (.D(d[2]), .CLK(clk), .QN(qn[2]));
    INVx1_ASAP7_75t_R inv2 (.A(qn[2]), .Y(q[2]));
    AND2x2_ASAP7_75t_R and_c2 (.A(q[2]), .B(c1), .Y(c2));

    // Bit 3
    XOR2x2_ASAP7_75t_R xor3 (.A(q[3]), .B(c2), .Y(d[3]));
    DFFHQNx1_ASAP7_75t_R ff3 (.D(d[3]), .CLK(clk), .QN(qn[3]));
    INVx1_ASAP7_75t_R inv3 (.A(qn[3]), .Y(q[3]));
    AND2x2_ASAP7_75t_R and_c3 (.A(q[3]), .B(c2), .Y(c3));

    // Bit 4
    XOR2x2_ASAP7_75t_R xor4 (.A(q[4]), .B(c3), .Y(d[4]));
    DFFHQNx1_ASAP7_75t_R ff4 (.D(d[4]), .CLK(clk), .QN(qn[4]));
    INVx1_ASAP7_75t_R inv4 (.A(qn[4]), .Y(q[4]));
    AND2x2_ASAP7_75t_R and_c4 (.A(q[4]), .B(c3), .Y(c4));

    // Bit 5
    XOR2x2_ASAP7_75t_R xor5 (.A(q[5]), .B(c4), .Y(d[5]));
    DFFHQNx1_ASAP7_75t_R ff5 (.D(d[5]), .CLK(clk), .QN(qn[5]));
    INVx1_ASAP7_75t_R inv5 (.A(qn[5]), .Y(q[5]));
    AND2x2_ASAP7_75t_R and_c5 (.A(q[5]), .B(c4), .Y(c5));

    // Bit 6
    XOR2x2_ASAP7_75t_R xor6 (.A(q[6]), .B(c5), .Y(d[6]));
    DFFHQNx1_ASAP7_75t_R ff6 (.D(d[6]), .CLK(clk), .QN(qn[6]));
    INVx1_ASAP7_75t_R inv6 (.A(qn[6]), .Y(q[6]));
    AND2x2_ASAP7_75t_R and_c6 (.A(q[6]), .B(c5), .Y(c6));

    // Bit 7 (MSB)
    XOR2x2_ASAP7_75t_R xor7 (.A(q[7]), .B(c6), .Y(d[7]));
    DFFHQNx1_ASAP7_75t_R ff7 (.D(d[7]), .CLK(clk), .QN(qn[7]));
    INVx1_ASAP7_75t_R inv7 (.A(qn[7]), .Y(q[7]));

    // Output buffers
    BUFx2_ASAP7_75t_R buf0 (.A(q[0]), .Y(count[0]));
    BUFx2_ASAP7_75t_R buf1 (.A(q[1]), .Y(count[1]));
    BUFx2_ASAP7_75t_R buf2 (.A(q[2]), .Y(count[2]));
    BUFx2_ASAP7_75t_R buf3 (.A(q[3]), .Y(count[3]));
    BUFx2_ASAP7_75t_R buf4 (.A(q[4]), .Y(count[4]));
    BUFx2_ASAP7_75t_R buf5 (.A(q[5]), .Y(count[5]));
    BUFx2_ASAP7_75t_R buf6 (.A(q[6]), .Y(count[6]));
    BUFx2_ASAP7_75t_R buf7 (.A(q[7]), .Y(count[7]));

endmodule
