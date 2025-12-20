// Register File - Pre-synthesized Sky130HD netlist
// Simplified 8-bit register with clock

module register_file (
    input  wire        clk,
    input  wire        we,
    input  wire [7:0]  din,
    output wire [7:0]  dout
);

    // 8 flip-flops with enable
    wire [7:0] d_mux;

    // Mux for write enable (din when we=1, else feedback)
    sky130_fd_sc_hd__mux2_1 mux0 (.A0(dout[0]), .A1(din[0]), .S(we), .X(d_mux[0]));
    sky130_fd_sc_hd__mux2_1 mux1 (.A0(dout[1]), .A1(din[1]), .S(we), .X(d_mux[1]));
    sky130_fd_sc_hd__mux2_1 mux2 (.A0(dout[2]), .A1(din[2]), .S(we), .X(d_mux[2]));
    sky130_fd_sc_hd__mux2_1 mux3 (.A0(dout[3]), .A1(din[3]), .S(we), .X(d_mux[3]));
    sky130_fd_sc_hd__mux2_1 mux4 (.A0(dout[4]), .A1(din[4]), .S(we), .X(d_mux[4]));
    sky130_fd_sc_hd__mux2_1 mux5 (.A0(dout[5]), .A1(din[5]), .S(we), .X(d_mux[5]));
    sky130_fd_sc_hd__mux2_1 mux6 (.A0(dout[6]), .A1(din[6]), .S(we), .X(d_mux[6]));
    sky130_fd_sc_hd__mux2_1 mux7 (.A0(dout[7]), .A1(din[7]), .S(we), .X(d_mux[7]));

    // Register bank 0 (bits 0-7)
    sky130_fd_sc_hd__dfxtp_1 r0 (.CLK(clk), .D(d_mux[0]), .Q(dout[0]));
    sky130_fd_sc_hd__dfxtp_1 r1 (.CLK(clk), .D(d_mux[1]), .Q(dout[1]));
    sky130_fd_sc_hd__dfxtp_1 r2 (.CLK(clk), .D(d_mux[2]), .Q(dout[2]));
    sky130_fd_sc_hd__dfxtp_1 r3 (.CLK(clk), .D(d_mux[3]), .Q(dout[3]));
    sky130_fd_sc_hd__dfxtp_1 r4 (.CLK(clk), .D(d_mux[4]), .Q(dout[4]));
    sky130_fd_sc_hd__dfxtp_1 r5 (.CLK(clk), .D(d_mux[5]), .Q(dout[5]));
    sky130_fd_sc_hd__dfxtp_1 r6 (.CLK(clk), .D(d_mux[6]), .Q(dout[6]));
    sky130_fd_sc_hd__dfxtp_1 r7 (.CLK(clk), .D(d_mux[7]), .Q(dout[7]));

    // Extra register banks for more clock sinks (simulating larger design)
    wire [7:0] q1, q2, q3;
    wire [7:0] d1, d2, d3;

    // Bank 1
    sky130_fd_sc_hd__mux2_1 mux1_0 (.A0(q1[0]), .A1(dout[0]), .S(we), .X(d1[0]));
    sky130_fd_sc_hd__mux2_1 mux1_1 (.A0(q1[1]), .A1(dout[1]), .S(we), .X(d1[1]));
    sky130_fd_sc_hd__mux2_1 mux1_2 (.A0(q1[2]), .A1(dout[2]), .S(we), .X(d1[2]));
    sky130_fd_sc_hd__mux2_1 mux1_3 (.A0(q1[3]), .A1(dout[3]), .S(we), .X(d1[3]));
    sky130_fd_sc_hd__mux2_1 mux1_4 (.A0(q1[4]), .A1(dout[4]), .S(we), .X(d1[4]));
    sky130_fd_sc_hd__mux2_1 mux1_5 (.A0(q1[5]), .A1(dout[5]), .S(we), .X(d1[5]));
    sky130_fd_sc_hd__mux2_1 mux1_6 (.A0(q1[6]), .A1(dout[6]), .S(we), .X(d1[6]));
    sky130_fd_sc_hd__mux2_1 mux1_7 (.A0(q1[7]), .A1(dout[7]), .S(we), .X(d1[7]));

    sky130_fd_sc_hd__dfxtp_1 r1_0 (.CLK(clk), .D(d1[0]), .Q(q1[0]));
    sky130_fd_sc_hd__dfxtp_1 r1_1 (.CLK(clk), .D(d1[1]), .Q(q1[1]));
    sky130_fd_sc_hd__dfxtp_1 r1_2 (.CLK(clk), .D(d1[2]), .Q(q1[2]));
    sky130_fd_sc_hd__dfxtp_1 r1_3 (.CLK(clk), .D(d1[3]), .Q(q1[3]));
    sky130_fd_sc_hd__dfxtp_1 r1_4 (.CLK(clk), .D(d1[4]), .Q(q1[4]));
    sky130_fd_sc_hd__dfxtp_1 r1_5 (.CLK(clk), .D(d1[5]), .Q(q1[5]));
    sky130_fd_sc_hd__dfxtp_1 r1_6 (.CLK(clk), .D(d1[6]), .Q(q1[6]));
    sky130_fd_sc_hd__dfxtp_1 r1_7 (.CLK(clk), .D(d1[7]), .Q(q1[7]));

    // Bank 2
    sky130_fd_sc_hd__mux2_1 mux2_0 (.A0(q2[0]), .A1(q1[0]), .S(we), .X(d2[0]));
    sky130_fd_sc_hd__mux2_1 mux2_1 (.A0(q2[1]), .A1(q1[1]), .S(we), .X(d2[1]));
    sky130_fd_sc_hd__mux2_1 mux2_2 (.A0(q2[2]), .A1(q1[2]), .S(we), .X(d2[2]));
    sky130_fd_sc_hd__mux2_1 mux2_3 (.A0(q2[3]), .A1(q1[3]), .S(we), .X(d2[3]));
    sky130_fd_sc_hd__mux2_1 mux2_4 (.A0(q2[4]), .A1(q1[4]), .S(we), .X(d2[4]));
    sky130_fd_sc_hd__mux2_1 mux2_5 (.A0(q2[5]), .A1(q1[5]), .S(we), .X(d2[5]));
    sky130_fd_sc_hd__mux2_1 mux2_6 (.A0(q2[6]), .A1(q1[6]), .S(we), .X(d2[6]));
    sky130_fd_sc_hd__mux2_1 mux2_7 (.A0(q2[7]), .A1(q1[7]), .S(we), .X(d2[7]));

    sky130_fd_sc_hd__dfxtp_1 r2_0 (.CLK(clk), .D(d2[0]), .Q(q2[0]));
    sky130_fd_sc_hd__dfxtp_1 r2_1 (.CLK(clk), .D(d2[1]), .Q(q2[1]));
    sky130_fd_sc_hd__dfxtp_1 r2_2 (.CLK(clk), .D(d2[2]), .Q(q2[2]));
    sky130_fd_sc_hd__dfxtp_1 r2_3 (.CLK(clk), .D(d2[3]), .Q(q2[3]));
    sky130_fd_sc_hd__dfxtp_1 r2_4 (.CLK(clk), .D(d2[4]), .Q(q2[4]));
    sky130_fd_sc_hd__dfxtp_1 r2_5 (.CLK(clk), .D(d2[5]), .Q(q2[5]));
    sky130_fd_sc_hd__dfxtp_1 r2_6 (.CLK(clk), .D(d2[6]), .Q(q2[6]));
    sky130_fd_sc_hd__dfxtp_1 r2_7 (.CLK(clk), .D(d2[7]), .Q(q2[7]));

    // Bank 3
    sky130_fd_sc_hd__mux2_1 mux3_0 (.A0(q3[0]), .A1(q2[0]), .S(we), .X(d3[0]));
    sky130_fd_sc_hd__mux2_1 mux3_1 (.A0(q3[1]), .A1(q2[1]), .S(we), .X(d3[1]));
    sky130_fd_sc_hd__mux2_1 mux3_2 (.A0(q3[2]), .A1(q2[2]), .S(we), .X(d3[2]));
    sky130_fd_sc_hd__mux2_1 mux3_3 (.A0(q3[3]), .A1(q2[3]), .S(we), .X(d3[3]));
    sky130_fd_sc_hd__mux2_1 mux3_4 (.A0(q3[4]), .A1(q2[4]), .S(we), .X(d3[4]));
    sky130_fd_sc_hd__mux2_1 mux3_5 (.A0(q3[5]), .A1(q2[5]), .S(we), .X(d3[5]));
    sky130_fd_sc_hd__mux2_1 mux3_6 (.A0(q3[6]), .A1(q2[6]), .S(we), .X(d3[6]));
    sky130_fd_sc_hd__mux2_1 mux3_7 (.A0(q3[7]), .A1(q2[7]), .S(we), .X(d3[7]));

    sky130_fd_sc_hd__dfxtp_1 r3_0 (.CLK(clk), .D(d3[0]), .Q(q3[0]));
    sky130_fd_sc_hd__dfxtp_1 r3_1 (.CLK(clk), .D(d3[1]), .Q(q3[1]));
    sky130_fd_sc_hd__dfxtp_1 r3_2 (.CLK(clk), .D(d3[2]), .Q(q3[2]));
    sky130_fd_sc_hd__dfxtp_1 r3_3 (.CLK(clk), .D(d3[3]), .Q(q3[3]));
    sky130_fd_sc_hd__dfxtp_1 r3_4 (.CLK(clk), .D(d3[4]), .Q(q3[4]));
    sky130_fd_sc_hd__dfxtp_1 r3_5 (.CLK(clk), .D(d3[5]), .Q(q3[5]));
    sky130_fd_sc_hd__dfxtp_1 r3_6 (.CLK(clk), .D(d3[6]), .Q(q3[6]));
    sky130_fd_sc_hd__dfxtp_1 r3_7 (.CLK(clk), .D(d3[7]), .Q(q3[7]));

endmodule
