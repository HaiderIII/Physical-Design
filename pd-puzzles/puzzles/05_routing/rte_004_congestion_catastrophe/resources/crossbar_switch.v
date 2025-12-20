// Crossbar Switch 4x4 - 8-bit data paths
// Complex interconnect with maximum wire crossings
// Each output port can select any input port via sel signals

module crossbar_switch (
    input  wire clk,
    input  wire rst_n,
    // 4 input ports x 8 bits = 32 input data bits
    input  wire [7:0] in_port0,
    input  wire [7:0] in_port1,
    input  wire [7:0] in_port2,
    input  wire [7:0] in_port3,
    // Selection signals: 2 bits per output (select 1 of 4 inputs)
    input  wire [1:0] sel_out0,
    input  wire [1:0] sel_out1,
    input  wire [1:0] sel_out2,
    input  wire [1:0] sel_out3,
    // Valid signals for each input
    input  wire valid_in0,
    input  wire valid_in1,
    input  wire valid_in2,
    input  wire valid_in3,
    // 4 output ports x 8 bits = 32 output data bits
    output wire [7:0] out_port0,
    output wire [7:0] out_port1,
    output wire [7:0] out_port2,
    output wire [7:0] out_port3,
    // Valid outputs
    output wire valid_out0,
    output wire valid_out1,
    output wire valid_out2,
    output wire valid_out3
);

    // Internal registered data from input ports
    wire [7:0] in_reg0, in_reg1, in_reg2, in_reg3;
    wire valid_reg0, valid_reg1, valid_reg2, valid_reg3;

    // Registered selection signals
    wire [1:0] sel_reg0, sel_reg1, sel_reg2, sel_reg3;

    // Mux outputs before output registers
    wire [7:0] mux_out0, mux_out1, mux_out2, mux_out3;
    wire mux_valid0, mux_valid1, mux_valid2, mux_valid3;

    // ========================================
    // Input Stage - Register all inputs
    // ========================================

    // Input port 0 registers (8 flip-flops for data + 1 for valid)
    sky130_fd_sc_hd__dfxtp_1 in0_reg_0 (.CLK(clk), .D(in_port0[0]), .Q(in_reg0[0]));
    sky130_fd_sc_hd__dfxtp_1 in0_reg_1 (.CLK(clk), .D(in_port0[1]), .Q(in_reg0[1]));
    sky130_fd_sc_hd__dfxtp_1 in0_reg_2 (.CLK(clk), .D(in_port0[2]), .Q(in_reg0[2]));
    sky130_fd_sc_hd__dfxtp_1 in0_reg_3 (.CLK(clk), .D(in_port0[3]), .Q(in_reg0[3]));
    sky130_fd_sc_hd__dfxtp_1 in0_reg_4 (.CLK(clk), .D(in_port0[4]), .Q(in_reg0[4]));
    sky130_fd_sc_hd__dfxtp_1 in0_reg_5 (.CLK(clk), .D(in_port0[5]), .Q(in_reg0[5]));
    sky130_fd_sc_hd__dfxtp_1 in0_reg_6 (.CLK(clk), .D(in_port0[6]), .Q(in_reg0[6]));
    sky130_fd_sc_hd__dfxtp_1 in0_reg_7 (.CLK(clk), .D(in_port0[7]), .Q(in_reg0[7]));
    sky130_fd_sc_hd__dfxtp_1 in0_valid_reg (.CLK(clk), .D(valid_in0), .Q(valid_reg0));

    // Input port 1 registers
    sky130_fd_sc_hd__dfxtp_1 in1_reg_0 (.CLK(clk), .D(in_port1[0]), .Q(in_reg1[0]));
    sky130_fd_sc_hd__dfxtp_1 in1_reg_1 (.CLK(clk), .D(in_port1[1]), .Q(in_reg1[1]));
    sky130_fd_sc_hd__dfxtp_1 in1_reg_2 (.CLK(clk), .D(in_port1[2]), .Q(in_reg1[2]));
    sky130_fd_sc_hd__dfxtp_1 in1_reg_3 (.CLK(clk), .D(in_port1[3]), .Q(in_reg1[3]));
    sky130_fd_sc_hd__dfxtp_1 in1_reg_4 (.CLK(clk), .D(in_port1[4]), .Q(in_reg1[4]));
    sky130_fd_sc_hd__dfxtp_1 in1_reg_5 (.CLK(clk), .D(in_port1[5]), .Q(in_reg1[5]));
    sky130_fd_sc_hd__dfxtp_1 in1_reg_6 (.CLK(clk), .D(in_port1[6]), .Q(in_reg1[6]));
    sky130_fd_sc_hd__dfxtp_1 in1_reg_7 (.CLK(clk), .D(in_port1[7]), .Q(in_reg1[7]));
    sky130_fd_sc_hd__dfxtp_1 in1_valid_reg (.CLK(clk), .D(valid_in1), .Q(valid_reg1));

    // Input port 2 registers
    sky130_fd_sc_hd__dfxtp_1 in2_reg_0 (.CLK(clk), .D(in_port2[0]), .Q(in_reg2[0]));
    sky130_fd_sc_hd__dfxtp_1 in2_reg_1 (.CLK(clk), .D(in_port2[1]), .Q(in_reg2[1]));
    sky130_fd_sc_hd__dfxtp_1 in2_reg_2 (.CLK(clk), .D(in_port2[2]), .Q(in_reg2[2]));
    sky130_fd_sc_hd__dfxtp_1 in2_reg_3 (.CLK(clk), .D(in_port2[3]), .Q(in_reg2[3]));
    sky130_fd_sc_hd__dfxtp_1 in2_reg_4 (.CLK(clk), .D(in_port2[4]), .Q(in_reg2[4]));
    sky130_fd_sc_hd__dfxtp_1 in2_reg_5 (.CLK(clk), .D(in_port2[5]), .Q(in_reg2[5]));
    sky130_fd_sc_hd__dfxtp_1 in2_reg_6 (.CLK(clk), .D(in_port2[6]), .Q(in_reg2[6]));
    sky130_fd_sc_hd__dfxtp_1 in2_reg_7 (.CLK(clk), .D(in_port2[7]), .Q(in_reg2[7]));
    sky130_fd_sc_hd__dfxtp_1 in2_valid_reg (.CLK(clk), .D(valid_in2), .Q(valid_reg2));

    // Input port 3 registers
    sky130_fd_sc_hd__dfxtp_1 in3_reg_0 (.CLK(clk), .D(in_port3[0]), .Q(in_reg3[0]));
    sky130_fd_sc_hd__dfxtp_1 in3_reg_1 (.CLK(clk), .D(in_port3[1]), .Q(in_reg3[1]));
    sky130_fd_sc_hd__dfxtp_1 in3_reg_2 (.CLK(clk), .D(in_port3[2]), .Q(in_reg3[2]));
    sky130_fd_sc_hd__dfxtp_1 in3_reg_3 (.CLK(clk), .D(in_port3[3]), .Q(in_reg3[3]));
    sky130_fd_sc_hd__dfxtp_1 in3_reg_4 (.CLK(clk), .D(in_port3[4]), .Q(in_reg3[4]));
    sky130_fd_sc_hd__dfxtp_1 in3_reg_5 (.CLK(clk), .D(in_port3[5]), .Q(in_reg3[5]));
    sky130_fd_sc_hd__dfxtp_1 in3_reg_6 (.CLK(clk), .D(in_port3[6]), .Q(in_reg3[6]));
    sky130_fd_sc_hd__dfxtp_1 in3_reg_7 (.CLK(clk), .D(in_port3[7]), .Q(in_reg3[7]));
    sky130_fd_sc_hd__dfxtp_1 in3_valid_reg (.CLK(clk), .D(valid_in3), .Q(valid_reg3));

    // Selection registers
    sky130_fd_sc_hd__dfxtp_1 sel0_reg_0 (.CLK(clk), .D(sel_out0[0]), .Q(sel_reg0[0]));
    sky130_fd_sc_hd__dfxtp_1 sel0_reg_1 (.CLK(clk), .D(sel_out0[1]), .Q(sel_reg0[1]));
    sky130_fd_sc_hd__dfxtp_1 sel1_reg_0 (.CLK(clk), .D(sel_out1[0]), .Q(sel_reg1[0]));
    sky130_fd_sc_hd__dfxtp_1 sel1_reg_1 (.CLK(clk), .D(sel_out1[1]), .Q(sel_reg1[1]));
    sky130_fd_sc_hd__dfxtp_1 sel2_reg_0 (.CLK(clk), .D(sel_out2[0]), .Q(sel_reg2[0]));
    sky130_fd_sc_hd__dfxtp_1 sel2_reg_1 (.CLK(clk), .D(sel_out2[1]), .Q(sel_reg2[1]));
    sky130_fd_sc_hd__dfxtp_1 sel3_reg_0 (.CLK(clk), .D(sel_out3[0]), .Q(sel_reg3[0]));
    sky130_fd_sc_hd__dfxtp_1 sel3_reg_1 (.CLK(clk), .D(sel_out3[1]), .Q(sel_reg3[1]));

    // ========================================
    // Crossbar Mux Stage - 4:1 muxes for each output
    // This creates the maximum crossing pattern
    // ========================================

    // Output 0 mux - selects from all 4 inputs (8 bits + valid)
    sky130_fd_sc_hd__mux4_1 mux0_b0 (.A0(in_reg0[0]), .A1(in_reg1[0]), .A2(in_reg2[0]), .A3(in_reg3[0]), .S0(sel_reg0[0]), .S1(sel_reg0[1]), .X(mux_out0[0]));
    sky130_fd_sc_hd__mux4_1 mux0_b1 (.A0(in_reg0[1]), .A1(in_reg1[1]), .A2(in_reg2[1]), .A3(in_reg3[1]), .S0(sel_reg0[0]), .S1(sel_reg0[1]), .X(mux_out0[1]));
    sky130_fd_sc_hd__mux4_1 mux0_b2 (.A0(in_reg0[2]), .A1(in_reg1[2]), .A2(in_reg2[2]), .A3(in_reg3[2]), .S0(sel_reg0[0]), .S1(sel_reg0[1]), .X(mux_out0[2]));
    sky130_fd_sc_hd__mux4_1 mux0_b3 (.A0(in_reg0[3]), .A1(in_reg1[3]), .A2(in_reg2[3]), .A3(in_reg3[3]), .S0(sel_reg0[0]), .S1(sel_reg0[1]), .X(mux_out0[3]));
    sky130_fd_sc_hd__mux4_1 mux0_b4 (.A0(in_reg0[4]), .A1(in_reg1[4]), .A2(in_reg2[4]), .A3(in_reg3[4]), .S0(sel_reg0[0]), .S1(sel_reg0[1]), .X(mux_out0[4]));
    sky130_fd_sc_hd__mux4_1 mux0_b5 (.A0(in_reg0[5]), .A1(in_reg1[5]), .A2(in_reg2[5]), .A3(in_reg3[5]), .S0(sel_reg0[0]), .S1(sel_reg0[1]), .X(mux_out0[5]));
    sky130_fd_sc_hd__mux4_1 mux0_b6 (.A0(in_reg0[6]), .A1(in_reg1[6]), .A2(in_reg2[6]), .A3(in_reg3[6]), .S0(sel_reg0[0]), .S1(sel_reg0[1]), .X(mux_out0[6]));
    sky130_fd_sc_hd__mux4_1 mux0_b7 (.A0(in_reg0[7]), .A1(in_reg1[7]), .A2(in_reg2[7]), .A3(in_reg3[7]), .S0(sel_reg0[0]), .S1(sel_reg0[1]), .X(mux_out0[7]));
    sky130_fd_sc_hd__mux4_1 mux0_valid (.A0(valid_reg0), .A1(valid_reg1), .A2(valid_reg2), .A3(valid_reg3), .S0(sel_reg0[0]), .S1(sel_reg0[1]), .X(mux_valid0));

    // Output 1 mux
    sky130_fd_sc_hd__mux4_1 mux1_b0 (.A0(in_reg0[0]), .A1(in_reg1[0]), .A2(in_reg2[0]), .A3(in_reg3[0]), .S0(sel_reg1[0]), .S1(sel_reg1[1]), .X(mux_out1[0]));
    sky130_fd_sc_hd__mux4_1 mux1_b1 (.A0(in_reg0[1]), .A1(in_reg1[1]), .A2(in_reg2[1]), .A3(in_reg3[1]), .S0(sel_reg1[0]), .S1(sel_reg1[1]), .X(mux_out1[1]));
    sky130_fd_sc_hd__mux4_1 mux1_b2 (.A0(in_reg0[2]), .A1(in_reg1[2]), .A2(in_reg2[2]), .A3(in_reg3[2]), .S0(sel_reg1[0]), .S1(sel_reg1[1]), .X(mux_out1[2]));
    sky130_fd_sc_hd__mux4_1 mux1_b3 (.A0(in_reg0[3]), .A1(in_reg1[3]), .A2(in_reg2[3]), .A3(in_reg3[3]), .S0(sel_reg1[0]), .S1(sel_reg1[1]), .X(mux_out1[3]));
    sky130_fd_sc_hd__mux4_1 mux1_b4 (.A0(in_reg0[4]), .A1(in_reg1[4]), .A2(in_reg2[4]), .A3(in_reg3[4]), .S0(sel_reg1[0]), .S1(sel_reg1[1]), .X(mux_out1[4]));
    sky130_fd_sc_hd__mux4_1 mux1_b5 (.A0(in_reg0[5]), .A1(in_reg1[5]), .A2(in_reg2[5]), .A3(in_reg3[5]), .S0(sel_reg1[0]), .S1(sel_reg1[1]), .X(mux_out1[5]));
    sky130_fd_sc_hd__mux4_1 mux1_b6 (.A0(in_reg0[6]), .A1(in_reg1[6]), .A2(in_reg2[6]), .A3(in_reg3[6]), .S0(sel_reg1[0]), .S1(sel_reg1[1]), .X(mux_out1[6]));
    sky130_fd_sc_hd__mux4_1 mux1_b7 (.A0(in_reg0[7]), .A1(in_reg1[7]), .A2(in_reg2[7]), .A3(in_reg3[7]), .S0(sel_reg1[0]), .S1(sel_reg1[1]), .X(mux_out1[7]));
    sky130_fd_sc_hd__mux4_1 mux1_valid (.A0(valid_reg0), .A1(valid_reg1), .A2(valid_reg2), .A3(valid_reg3), .S0(sel_reg1[0]), .S1(sel_reg1[1]), .X(mux_valid1));

    // Output 2 mux
    sky130_fd_sc_hd__mux4_1 mux2_b0 (.A0(in_reg0[0]), .A1(in_reg1[0]), .A2(in_reg2[0]), .A3(in_reg3[0]), .S0(sel_reg2[0]), .S1(sel_reg2[1]), .X(mux_out2[0]));
    sky130_fd_sc_hd__mux4_1 mux2_b1 (.A0(in_reg0[1]), .A1(in_reg1[1]), .A2(in_reg2[1]), .A3(in_reg3[1]), .S0(sel_reg2[0]), .S1(sel_reg2[1]), .X(mux_out2[1]));
    sky130_fd_sc_hd__mux4_1 mux2_b2 (.A0(in_reg0[2]), .A1(in_reg1[2]), .A2(in_reg2[2]), .A3(in_reg3[2]), .S0(sel_reg2[0]), .S1(sel_reg2[1]), .X(mux_out2[2]));
    sky130_fd_sc_hd__mux4_1 mux2_b3 (.A0(in_reg0[3]), .A1(in_reg1[3]), .A2(in_reg2[3]), .A3(in_reg3[3]), .S0(sel_reg2[0]), .S1(sel_reg2[1]), .X(mux_out2[3]));
    sky130_fd_sc_hd__mux4_1 mux2_b4 (.A0(in_reg0[4]), .A1(in_reg1[4]), .A2(in_reg2[4]), .A3(in_reg3[4]), .S0(sel_reg2[0]), .S1(sel_reg2[1]), .X(mux_out2[4]));
    sky130_fd_sc_hd__mux4_1 mux2_b5 (.A0(in_reg0[5]), .A1(in_reg1[5]), .A2(in_reg2[5]), .A3(in_reg3[5]), .S0(sel_reg2[0]), .S1(sel_reg2[1]), .X(mux_out2[5]));
    sky130_fd_sc_hd__mux4_1 mux2_b6 (.A0(in_reg0[6]), .A1(in_reg1[6]), .A2(in_reg2[6]), .A3(in_reg3[6]), .S0(sel_reg2[0]), .S1(sel_reg2[1]), .X(mux_out2[6]));
    sky130_fd_sc_hd__mux4_1 mux2_b7 (.A0(in_reg0[7]), .A1(in_reg1[7]), .A2(in_reg2[7]), .A3(in_reg3[7]), .S0(sel_reg2[0]), .S1(sel_reg2[1]), .X(mux_out2[7]));
    sky130_fd_sc_hd__mux4_1 mux2_valid (.A0(valid_reg0), .A1(valid_reg1), .A2(valid_reg2), .A3(valid_reg3), .S0(sel_reg2[0]), .S1(sel_reg2[1]), .X(mux_valid2));

    // Output 3 mux
    sky130_fd_sc_hd__mux4_1 mux3_b0 (.A0(in_reg0[0]), .A1(in_reg1[0]), .A2(in_reg2[0]), .A3(in_reg3[0]), .S0(sel_reg3[0]), .S1(sel_reg3[1]), .X(mux_out3[0]));
    sky130_fd_sc_hd__mux4_1 mux3_b1 (.A0(in_reg0[1]), .A1(in_reg1[1]), .A2(in_reg2[1]), .A3(in_reg3[1]), .S0(sel_reg3[0]), .S1(sel_reg3[1]), .X(mux_out3[1]));
    sky130_fd_sc_hd__mux4_1 mux3_b2 (.A0(in_reg0[2]), .A1(in_reg1[2]), .A2(in_reg2[2]), .A3(in_reg3[2]), .S0(sel_reg3[0]), .S1(sel_reg3[1]), .X(mux_out3[2]));
    sky130_fd_sc_hd__mux4_1 mux3_b3 (.A0(in_reg0[3]), .A1(in_reg1[3]), .A2(in_reg2[3]), .A3(in_reg3[3]), .S0(sel_reg3[0]), .S1(sel_reg3[1]), .X(mux_out3[3]));
    sky130_fd_sc_hd__mux4_1 mux3_b4 (.A0(in_reg0[4]), .A1(in_reg1[4]), .A2(in_reg2[4]), .A3(in_reg3[4]), .S0(sel_reg3[0]), .S1(sel_reg3[1]), .X(mux_out3[4]));
    sky130_fd_sc_hd__mux4_1 mux3_b5 (.A0(in_reg0[5]), .A1(in_reg1[5]), .A2(in_reg2[5]), .A3(in_reg3[5]), .S0(sel_reg3[0]), .S1(sel_reg3[1]), .X(mux_out3[5]));
    sky130_fd_sc_hd__mux4_1 mux3_b6 (.A0(in_reg0[6]), .A1(in_reg1[6]), .A2(in_reg2[6]), .A3(in_reg3[6]), .S0(sel_reg3[0]), .S1(sel_reg3[1]), .X(mux_out3[6]));
    sky130_fd_sc_hd__mux4_1 mux3_b7 (.A0(in_reg0[7]), .A1(in_reg1[7]), .A2(in_reg2[7]), .A3(in_reg3[7]), .S0(sel_reg3[0]), .S1(sel_reg3[1]), .X(mux_out3[7]));
    sky130_fd_sc_hd__mux4_1 mux3_valid (.A0(valid_reg0), .A1(valid_reg1), .A2(valid_reg2), .A3(valid_reg3), .S0(sel_reg3[0]), .S1(sel_reg3[1]), .X(mux_valid3));

    // ========================================
    // Output Stage - Register all outputs
    // ========================================

    // Output port 0 registers
    sky130_fd_sc_hd__dfxtp_1 out0_reg_0 (.CLK(clk), .D(mux_out0[0]), .Q(out_port0[0]));
    sky130_fd_sc_hd__dfxtp_1 out0_reg_1 (.CLK(clk), .D(mux_out0[1]), .Q(out_port0[1]));
    sky130_fd_sc_hd__dfxtp_1 out0_reg_2 (.CLK(clk), .D(mux_out0[2]), .Q(out_port0[2]));
    sky130_fd_sc_hd__dfxtp_1 out0_reg_3 (.CLK(clk), .D(mux_out0[3]), .Q(out_port0[3]));
    sky130_fd_sc_hd__dfxtp_1 out0_reg_4 (.CLK(clk), .D(mux_out0[4]), .Q(out_port0[4]));
    sky130_fd_sc_hd__dfxtp_1 out0_reg_5 (.CLK(clk), .D(mux_out0[5]), .Q(out_port0[5]));
    sky130_fd_sc_hd__dfxtp_1 out0_reg_6 (.CLK(clk), .D(mux_out0[6]), .Q(out_port0[6]));
    sky130_fd_sc_hd__dfxtp_1 out0_reg_7 (.CLK(clk), .D(mux_out0[7]), .Q(out_port0[7]));
    sky130_fd_sc_hd__dfxtp_1 out0_valid_reg (.CLK(clk), .D(mux_valid0), .Q(valid_out0));

    // Output port 1 registers
    sky130_fd_sc_hd__dfxtp_1 out1_reg_0 (.CLK(clk), .D(mux_out1[0]), .Q(out_port1[0]));
    sky130_fd_sc_hd__dfxtp_1 out1_reg_1 (.CLK(clk), .D(mux_out1[1]), .Q(out_port1[1]));
    sky130_fd_sc_hd__dfxtp_1 out1_reg_2 (.CLK(clk), .D(mux_out1[2]), .Q(out_port1[2]));
    sky130_fd_sc_hd__dfxtp_1 out1_reg_3 (.CLK(clk), .D(mux_out1[3]), .Q(out_port1[3]));
    sky130_fd_sc_hd__dfxtp_1 out1_reg_4 (.CLK(clk), .D(mux_out1[4]), .Q(out_port1[4]));
    sky130_fd_sc_hd__dfxtp_1 out1_reg_5 (.CLK(clk), .D(mux_out1[5]), .Q(out_port1[5]));
    sky130_fd_sc_hd__dfxtp_1 out1_reg_6 (.CLK(clk), .D(mux_out1[6]), .Q(out_port1[6]));
    sky130_fd_sc_hd__dfxtp_1 out1_reg_7 (.CLK(clk), .D(mux_out1[7]), .Q(out_port1[7]));
    sky130_fd_sc_hd__dfxtp_1 out1_valid_reg (.CLK(clk), .D(mux_valid1), .Q(valid_out1));

    // Output port 2 registers
    sky130_fd_sc_hd__dfxtp_1 out2_reg_0 (.CLK(clk), .D(mux_out2[0]), .Q(out_port2[0]));
    sky130_fd_sc_hd__dfxtp_1 out2_reg_1 (.CLK(clk), .D(mux_out2[1]), .Q(out_port2[1]));
    sky130_fd_sc_hd__dfxtp_1 out2_reg_2 (.CLK(clk), .D(mux_out2[2]), .Q(out_port2[2]));
    sky130_fd_sc_hd__dfxtp_1 out2_reg_3 (.CLK(clk), .D(mux_out2[3]), .Q(out_port2[3]));
    sky130_fd_sc_hd__dfxtp_1 out2_reg_4 (.CLK(clk), .D(mux_out2[4]), .Q(out_port2[4]));
    sky130_fd_sc_hd__dfxtp_1 out2_reg_5 (.CLK(clk), .D(mux_out2[5]), .Q(out_port2[5]));
    sky130_fd_sc_hd__dfxtp_1 out2_reg_6 (.CLK(clk), .D(mux_out2[6]), .Q(out_port2[6]));
    sky130_fd_sc_hd__dfxtp_1 out2_reg_7 (.CLK(clk), .D(mux_out2[7]), .Q(out_port2[7]));
    sky130_fd_sc_hd__dfxtp_1 out2_valid_reg (.CLK(clk), .D(mux_valid2), .Q(valid_out2));

    // Output port 3 registers
    sky130_fd_sc_hd__dfxtp_1 out3_reg_0 (.CLK(clk), .D(mux_out3[0]), .Q(out_port3[0]));
    sky130_fd_sc_hd__dfxtp_1 out3_reg_1 (.CLK(clk), .D(mux_out3[1]), .Q(out_port3[1]));
    sky130_fd_sc_hd__dfxtp_1 out3_reg_2 (.CLK(clk), .D(mux_out3[2]), .Q(out_port3[2]));
    sky130_fd_sc_hd__dfxtp_1 out3_reg_3 (.CLK(clk), .D(mux_out3[3]), .Q(out_port3[3]));
    sky130_fd_sc_hd__dfxtp_1 out3_reg_4 (.CLK(clk), .D(mux_out3[4]), .Q(out_port3[4]));
    sky130_fd_sc_hd__dfxtp_1 out3_reg_5 (.CLK(clk), .D(mux_out3[5]), .Q(out_port3[5]));
    sky130_fd_sc_hd__dfxtp_1 out3_reg_6 (.CLK(clk), .D(mux_out3[6]), .Q(out_port3[6]));
    sky130_fd_sc_hd__dfxtp_1 out3_reg_7 (.CLK(clk), .D(mux_out3[7]), .Q(out_port3[7]));
    sky130_fd_sc_hd__dfxtp_1 out3_valid_reg (.CLK(clk), .D(mux_valid3), .Q(valid_out3));

endmodule
