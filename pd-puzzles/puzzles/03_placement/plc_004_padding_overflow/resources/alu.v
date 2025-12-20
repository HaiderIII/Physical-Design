// ALU - Pre-synthesized Sky130HD netlist
// For placement displacement puzzle

module alu (
    input  wire        clk,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    input  wire [1:0]  op,
    output wire [7:0]  result
);

    wire [7:0] sum, diff, and_out, or_out;
    wire [7:0] mux_l1_0, mux_l1_1;

    // Adder
    sky130_fd_sc_hd__fa_1 fa0 (.A(a[0]), .B(b[0]), .CIN(1'b0), .SUM(sum[0]), .COUT(c0));
    sky130_fd_sc_hd__fa_1 fa1 (.A(a[1]), .B(b[1]), .CIN(c0), .SUM(sum[1]), .COUT(c1));
    sky130_fd_sc_hd__fa_1 fa2 (.A(a[2]), .B(b[2]), .CIN(c1), .SUM(sum[2]), .COUT(c2));
    sky130_fd_sc_hd__fa_1 fa3 (.A(a[3]), .B(b[3]), .CIN(c2), .SUM(sum[3]), .COUT(c3));
    sky130_fd_sc_hd__fa_1 fa4 (.A(a[4]), .B(b[4]), .CIN(c3), .SUM(sum[4]), .COUT(c4));
    sky130_fd_sc_hd__fa_1 fa5 (.A(a[5]), .B(b[5]), .CIN(c4), .SUM(sum[5]), .COUT(c5));
    sky130_fd_sc_hd__fa_1 fa6 (.A(a[6]), .B(b[6]), .CIN(c5), .SUM(sum[6]), .COUT(c6));
    sky130_fd_sc_hd__fa_1 fa7 (.A(a[7]), .B(b[7]), .CIN(c6), .SUM(sum[7]), .COUT(c7));

    // Subtractor (a - b = a + ~b + 1)
    wire [7:0] b_inv;
    sky130_fd_sc_hd__inv_1 inv0 (.A(b[0]), .Y(b_inv[0]));
    sky130_fd_sc_hd__inv_1 inv1 (.A(b[1]), .Y(b_inv[1]));
    sky130_fd_sc_hd__inv_1 inv2 (.A(b[2]), .Y(b_inv[2]));
    sky130_fd_sc_hd__inv_1 inv3 (.A(b[3]), .Y(b_inv[3]));
    sky130_fd_sc_hd__inv_1 inv4 (.A(b[4]), .Y(b_inv[4]));
    sky130_fd_sc_hd__inv_1 inv5 (.A(b[5]), .Y(b_inv[5]));
    sky130_fd_sc_hd__inv_1 inv6 (.A(b[6]), .Y(b_inv[6]));
    sky130_fd_sc_hd__inv_1 inv7 (.A(b[7]), .Y(b_inv[7]));

    sky130_fd_sc_hd__fa_1 fs0 (.A(a[0]), .B(b_inv[0]), .CIN(1'b1), .SUM(diff[0]), .COUT(d0));
    sky130_fd_sc_hd__fa_1 fs1 (.A(a[1]), .B(b_inv[1]), .CIN(d0), .SUM(diff[1]), .COUT(d1));
    sky130_fd_sc_hd__fa_1 fs2 (.A(a[2]), .B(b_inv[2]), .CIN(d1), .SUM(diff[2]), .COUT(d2));
    sky130_fd_sc_hd__fa_1 fs3 (.A(a[3]), .B(b_inv[3]), .CIN(d2), .SUM(diff[3]), .COUT(d3));
    sky130_fd_sc_hd__fa_1 fs4 (.A(a[4]), .B(b_inv[4]), .CIN(d3), .SUM(diff[4]), .COUT(d4));
    sky130_fd_sc_hd__fa_1 fs5 (.A(a[5]), .B(b_inv[5]), .CIN(d4), .SUM(diff[5]), .COUT(d5));
    sky130_fd_sc_hd__fa_1 fs6 (.A(a[6]), .B(b_inv[6]), .CIN(d5), .SUM(diff[6]), .COUT(d6));
    sky130_fd_sc_hd__fa_1 fs7 (.A(a[7]), .B(b_inv[7]), .CIN(d6), .SUM(diff[7]), .COUT(d7));

    // AND
    sky130_fd_sc_hd__and2_1 and0 (.A(a[0]), .B(b[0]), .X(and_out[0]));
    sky130_fd_sc_hd__and2_1 and1 (.A(a[1]), .B(b[1]), .X(and_out[1]));
    sky130_fd_sc_hd__and2_1 and2 (.A(a[2]), .B(b[2]), .X(and_out[2]));
    sky130_fd_sc_hd__and2_1 and3 (.A(a[3]), .B(b[3]), .X(and_out[3]));
    sky130_fd_sc_hd__and2_1 and4 (.A(a[4]), .B(b[4]), .X(and_out[4]));
    sky130_fd_sc_hd__and2_1 and5 (.A(a[5]), .B(b[5]), .X(and_out[5]));
    sky130_fd_sc_hd__and2_1 and6 (.A(a[6]), .B(b[6]), .X(and_out[6]));
    sky130_fd_sc_hd__and2_1 and7 (.A(a[7]), .B(b[7]), .X(and_out[7]));

    // OR
    sky130_fd_sc_hd__or2_1 or0 (.A(a[0]), .B(b[0]), .X(or_out[0]));
    sky130_fd_sc_hd__or2_1 or1 (.A(a[1]), .B(b[1]), .X(or_out[1]));
    sky130_fd_sc_hd__or2_1 or2 (.A(a[2]), .B(b[2]), .X(or_out[2]));
    sky130_fd_sc_hd__or2_1 or3 (.A(a[3]), .B(b[3]), .X(or_out[3]));
    sky130_fd_sc_hd__or2_1 or4 (.A(a[4]), .B(b[4]), .X(or_out[4]));
    sky130_fd_sc_hd__or2_1 or5 (.A(a[5]), .B(b[5]), .X(or_out[5]));
    sky130_fd_sc_hd__or2_1 or6 (.A(a[6]), .B(b[6]), .X(or_out[6]));
    sky130_fd_sc_hd__or2_1 or7 (.A(a[7]), .B(b[7]), .X(or_out[7]));

    // Output mux: op[1:0] selects result
    // 00=add, 01=sub, 10=and, 11=or
    sky130_fd_sc_hd__mux2_1 mux_l1_0_0 (.A0(sum[0]), .A1(diff[0]), .S(op[0]), .X(mux_l1_0[0]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_1 (.A0(sum[1]), .A1(diff[1]), .S(op[0]), .X(mux_l1_0[1]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_2 (.A0(sum[2]), .A1(diff[2]), .S(op[0]), .X(mux_l1_0[2]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_3 (.A0(sum[3]), .A1(diff[3]), .S(op[0]), .X(mux_l1_0[3]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_4 (.A0(sum[4]), .A1(diff[4]), .S(op[0]), .X(mux_l1_0[4]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_5 (.A0(sum[5]), .A1(diff[5]), .S(op[0]), .X(mux_l1_0[5]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_6 (.A0(sum[6]), .A1(diff[6]), .S(op[0]), .X(mux_l1_0[6]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_7 (.A0(sum[7]), .A1(diff[7]), .S(op[0]), .X(mux_l1_0[7]));

    sky130_fd_sc_hd__mux2_1 mux_l1_1_0 (.A0(and_out[0]), .A1(or_out[0]), .S(op[0]), .X(mux_l1_1[0]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_1 (.A0(and_out[1]), .A1(or_out[1]), .S(op[0]), .X(mux_l1_1[1]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_2 (.A0(and_out[2]), .A1(or_out[2]), .S(op[0]), .X(mux_l1_1[2]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_3 (.A0(and_out[3]), .A1(or_out[3]), .S(op[0]), .X(mux_l1_1[3]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_4 (.A0(and_out[4]), .A1(or_out[4]), .S(op[0]), .X(mux_l1_1[4]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_5 (.A0(and_out[5]), .A1(or_out[5]), .S(op[0]), .X(mux_l1_1[5]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_6 (.A0(and_out[6]), .A1(or_out[6]), .S(op[0]), .X(mux_l1_1[6]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_7 (.A0(and_out[7]), .A1(or_out[7]), .S(op[0]), .X(mux_l1_1[7]));

    sky130_fd_sc_hd__mux2_1 mux_out0 (.A0(mux_l1_0[0]), .A1(mux_l1_1[0]), .S(op[1]), .X(result[0]));
    sky130_fd_sc_hd__mux2_1 mux_out1 (.A0(mux_l1_0[1]), .A1(mux_l1_1[1]), .S(op[1]), .X(result[1]));
    sky130_fd_sc_hd__mux2_1 mux_out2 (.A0(mux_l1_0[2]), .A1(mux_l1_1[2]), .S(op[1]), .X(result[2]));
    sky130_fd_sc_hd__mux2_1 mux_out3 (.A0(mux_l1_0[3]), .A1(mux_l1_1[3]), .S(op[1]), .X(result[3]));
    sky130_fd_sc_hd__mux2_1 mux_out4 (.A0(mux_l1_0[4]), .A1(mux_l1_1[4]), .S(op[1]), .X(result[4]));
    sky130_fd_sc_hd__mux2_1 mux_out5 (.A0(mux_l1_0[5]), .A1(mux_l1_1[5]), .S(op[1]), .X(result[5]));
    sky130_fd_sc_hd__mux2_1 mux_out6 (.A0(mux_l1_0[6]), .A1(mux_l1_1[6]), .S(op[1]), .X(result[6]));
    sky130_fd_sc_hd__mux2_1 mux_out7 (.A0(mux_l1_0[7]), .A1(mux_l1_1[7]), .S(op[1]), .X(result[7]));

endmodule
