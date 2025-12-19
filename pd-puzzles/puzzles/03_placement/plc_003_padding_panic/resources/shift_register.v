// 16-bit Shift Register - Pre-synthesized ASAP7 RVT netlist
// Dense sequential design for placement padding puzzle

module shift_register (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        shift_en,
    input  wire        data_in,
    output wire        data_out
);

    // Internal signals
    wire [15:0] q;
    wire [15:0] d;
    wire shift_en_buf;

    // Buffer shift enable
    BUFx2_ASAP7_75t_R buf_en (.A(shift_en), .Y(shift_en_buf));

    // Stage 0: Input
    AND2x2_ASAP7_75t_R and_d0 (.A(data_in), .B(shift_en_buf), .Y(d[0]));
    DFFHQNx1_ASAP7_75t_R ff0 (.D(d[0]), .CLK(clk), .QN(qn0));
    INVx1_ASAP7_75t_R inv0 (.A(qn0), .Y(q[0]));

    // Stage 1
    AND2x2_ASAP7_75t_R and_d1 (.A(q[0]), .B(shift_en_buf), .Y(d[1]));
    DFFHQNx1_ASAP7_75t_R ff1 (.D(d[1]), .CLK(clk), .QN(qn1));
    INVx1_ASAP7_75t_R inv1 (.A(qn1), .Y(q[1]));

    // Stage 2
    AND2x2_ASAP7_75t_R and_d2 (.A(q[1]), .B(shift_en_buf), .Y(d[2]));
    DFFHQNx1_ASAP7_75t_R ff2 (.D(d[2]), .CLK(clk), .QN(qn2));
    INVx1_ASAP7_75t_R inv2 (.A(qn2), .Y(q[2]));

    // Stage 3
    AND2x2_ASAP7_75t_R and_d3 (.A(q[2]), .B(shift_en_buf), .Y(d[3]));
    DFFHQNx1_ASAP7_75t_R ff3 (.D(d[3]), .CLK(clk), .QN(qn3));
    INVx1_ASAP7_75t_R inv3 (.A(qn3), .Y(q[3]));

    // Stage 4
    AND2x2_ASAP7_75t_R and_d4 (.A(q[3]), .B(shift_en_buf), .Y(d[4]));
    DFFHQNx1_ASAP7_75t_R ff4 (.D(d[4]), .CLK(clk), .QN(qn4));
    INVx1_ASAP7_75t_R inv4 (.A(qn4), .Y(q[4]));

    // Stage 5
    AND2x2_ASAP7_75t_R and_d5 (.A(q[4]), .B(shift_en_buf), .Y(d[5]));
    DFFHQNx1_ASAP7_75t_R ff5 (.D(d[5]), .CLK(clk), .QN(qn5));
    INVx1_ASAP7_75t_R inv5 (.A(qn5), .Y(q[5]));

    // Stage 6
    AND2x2_ASAP7_75t_R and_d6 (.A(q[5]), .B(shift_en_buf), .Y(d[6]));
    DFFHQNx1_ASAP7_75t_R ff6 (.D(d[6]), .CLK(clk), .QN(qn6));
    INVx1_ASAP7_75t_R inv6 (.A(qn6), .Y(q[6]));

    // Stage 7
    AND2x2_ASAP7_75t_R and_d7 (.A(q[6]), .B(shift_en_buf), .Y(d[7]));
    DFFHQNx1_ASAP7_75t_R ff7 (.D(d[7]), .CLK(clk), .QN(qn7));
    INVx1_ASAP7_75t_R inv7 (.A(qn7), .Y(q[7]));

    // Stage 8
    AND2x2_ASAP7_75t_R and_d8 (.A(q[7]), .B(shift_en_buf), .Y(d[8]));
    DFFHQNx1_ASAP7_75t_R ff8 (.D(d[8]), .CLK(clk), .QN(qn8));
    INVx1_ASAP7_75t_R inv8 (.A(qn8), .Y(q[8]));

    // Stage 9
    AND2x2_ASAP7_75t_R and_d9 (.A(q[8]), .B(shift_en_buf), .Y(d[9]));
    DFFHQNx1_ASAP7_75t_R ff9 (.D(d[9]), .CLK(clk), .QN(qn9));
    INVx1_ASAP7_75t_R inv9 (.A(qn9), .Y(q[9]));

    // Stage 10
    AND2x2_ASAP7_75t_R and_d10 (.A(q[9]), .B(shift_en_buf), .Y(d[10]));
    DFFHQNx1_ASAP7_75t_R ff10 (.D(d[10]), .CLK(clk), .QN(qn10));
    INVx1_ASAP7_75t_R inv10 (.A(qn10), .Y(q[10]));

    // Stage 11
    AND2x2_ASAP7_75t_R and_d11 (.A(q[10]), .B(shift_en_buf), .Y(d[11]));
    DFFHQNx1_ASAP7_75t_R ff11 (.D(d[11]), .CLK(clk), .QN(qn11));
    INVx1_ASAP7_75t_R inv11 (.A(qn11), .Y(q[11]));

    // Stage 12
    AND2x2_ASAP7_75t_R and_d12 (.A(q[11]), .B(shift_en_buf), .Y(d[12]));
    DFFHQNx1_ASAP7_75t_R ff12 (.D(d[12]), .CLK(clk), .QN(qn12));
    INVx1_ASAP7_75t_R inv12 (.A(qn12), .Y(q[12]));

    // Stage 13
    AND2x2_ASAP7_75t_R and_d13 (.A(q[12]), .B(shift_en_buf), .Y(d[13]));
    DFFHQNx1_ASAP7_75t_R ff13 (.D(d[13]), .CLK(clk), .QN(qn13));
    INVx1_ASAP7_75t_R inv13 (.A(qn13), .Y(q[13]));

    // Stage 14
    AND2x2_ASAP7_75t_R and_d14 (.A(q[13]), .B(shift_en_buf), .Y(d[14]));
    DFFHQNx1_ASAP7_75t_R ff14 (.D(d[14]), .CLK(clk), .QN(qn14));
    INVx1_ASAP7_75t_R inv14 (.A(qn14), .Y(q[14]));

    // Stage 15: Output
    AND2x2_ASAP7_75t_R and_d15 (.A(q[14]), .B(shift_en_buf), .Y(d[15]));
    DFFHQNx1_ASAP7_75t_R ff15 (.D(d[15]), .CLK(clk), .QN(qn15));
    INVx1_ASAP7_75t_R inv15 (.A(qn15), .Y(q[15]));

    // Output buffer
    BUFx4_ASAP7_75t_R buf_out (.A(q[15]), .Y(data_out));

endmodule
