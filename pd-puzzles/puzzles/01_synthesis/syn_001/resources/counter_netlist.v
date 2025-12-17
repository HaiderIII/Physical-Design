// Pre-synthesized netlist for counter design
// This is a gate-level netlist compatible with OpenROAD
// Original: 4-bit counter with enable and async reset

module counter (
    clk,
    rst_n,
    enable,
    count
);
    input clk;
    input rst_n;
    input enable;
    output [3:0] count;

    wire n1, n2, n3, n4, n5, n6, n7, n8, n9, n10;
    wire n11, n12, n13, n14, n15, n16;

    // Flip-flops for counter bits
    DFFRS_X1 count_reg_0 (.D(n1), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(count[0]), .QN(n5));
    DFFRS_X1 count_reg_1 (.D(n2), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(count[1]), .QN(n6));
    DFFRS_X1 count_reg_2 (.D(n3), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(count[2]), .QN(n7));
    DFFRS_X1 count_reg_3 (.D(n4), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(count[3]), .QN(n8));

    // Increment logic for count[0]: toggle when enabled
    // count[0]_next = enable XOR count[0]
    XOR2_X1 U1 (.A(enable), .B(count[0]), .Z(n9));
    MUX2_X1 U2 (.A(count[0]), .B(n9), .S(enable), .Z(n1));

    // Increment logic for count[1]
    // count[1]_next = count[1] XOR (count[0] AND enable)
    AND2_X1 U3 (.A1(count[0]), .A2(enable), .ZN(n10));
    XOR2_X1 U4 (.A(count[1]), .B(n10), .Z(n11));
    MUX2_X1 U5 (.A(count[1]), .B(n11), .S(enable), .Z(n2));

    // Increment logic for count[2]
    AND2_X1 U6 (.A1(count[1]), .A2(n10), .ZN(n12));
    XOR2_X1 U7 (.A(count[2]), .B(n12), .Z(n13));
    MUX2_X1 U8 (.A(count[2]), .B(n13), .S(enable), .Z(n3));

    // Increment logic for count[3]
    AND2_X1 U9 (.A1(count[2]), .A2(n12), .ZN(n14));
    XOR2_X1 U10 (.A(count[3]), .B(n14), .Z(n15));
    MUX2_X1 U11 (.A(count[3]), .B(n15), .S(enable), .Z(n4));

endmodule
