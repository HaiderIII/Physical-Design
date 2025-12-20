// Data Processor - 4-stage pipeline with high fanout
// Complex design to demonstrate slew/transition issues
// Stage 1: Input registers
// Stage 2: Arithmetic (add/shift)
// Stage 3: Logic operations
// Stage 4: Output registers

module data_processor (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_in,
    input  wire [15:0] data_in,
    input  wire [3:0]  opcode,
    output wire        valid_out,
    output wire [15:0] data_out,
    output wire        overflow
);

    // ========================================
    // Stage 1: Input Registers (16 + 4 + 1 = 21 FFs)
    // ========================================
    wire [15:0] s1_data;
    wire [3:0]  s1_opcode;
    wire        s1_valid;

    // Data input registers
    sky130_fd_sc_hd__dfxtp_1 s1_data_0  (.CLK(clk), .D(data_in[0]),  .Q(s1_data[0]));
    sky130_fd_sc_hd__dfxtp_1 s1_data_1  (.CLK(clk), .D(data_in[1]),  .Q(s1_data[1]));
    sky130_fd_sc_hd__dfxtp_1 s1_data_2  (.CLK(clk), .D(data_in[2]),  .Q(s1_data[2]));
    sky130_fd_sc_hd__dfxtp_1 s1_data_3  (.CLK(clk), .D(data_in[3]),  .Q(s1_data[3]));
    sky130_fd_sc_hd__dfxtp_1 s1_data_4  (.CLK(clk), .D(data_in[4]),  .Q(s1_data[4]));
    sky130_fd_sc_hd__dfxtp_1 s1_data_5  (.CLK(clk), .D(data_in[5]),  .Q(s1_data[5]));
    sky130_fd_sc_hd__dfxtp_1 s1_data_6  (.CLK(clk), .D(data_in[6]),  .Q(s1_data[6]));
    sky130_fd_sc_hd__dfxtp_1 s1_data_7  (.CLK(clk), .D(data_in[7]),  .Q(s1_data[7]));
    sky130_fd_sc_hd__dfxtp_1 s1_data_8  (.CLK(clk), .D(data_in[8]),  .Q(s1_data[8]));
    sky130_fd_sc_hd__dfxtp_1 s1_data_9  (.CLK(clk), .D(data_in[9]),  .Q(s1_data[9]));
    sky130_fd_sc_hd__dfxtp_1 s1_data_10 (.CLK(clk), .D(data_in[10]), .Q(s1_data[10]));
    sky130_fd_sc_hd__dfxtp_1 s1_data_11 (.CLK(clk), .D(data_in[11]), .Q(s1_data[11]));
    sky130_fd_sc_hd__dfxtp_1 s1_data_12 (.CLK(clk), .D(data_in[12]), .Q(s1_data[12]));
    sky130_fd_sc_hd__dfxtp_1 s1_data_13 (.CLK(clk), .D(data_in[13]), .Q(s1_data[13]));
    sky130_fd_sc_hd__dfxtp_1 s1_data_14 (.CLK(clk), .D(data_in[14]), .Q(s1_data[14]));
    sky130_fd_sc_hd__dfxtp_1 s1_data_15 (.CLK(clk), .D(data_in[15]), .Q(s1_data[15]));

    // Opcode registers
    sky130_fd_sc_hd__dfxtp_1 s1_op_0 (.CLK(clk), .D(opcode[0]), .Q(s1_opcode[0]));
    sky130_fd_sc_hd__dfxtp_1 s1_op_1 (.CLK(clk), .D(opcode[1]), .Q(s1_opcode[1]));
    sky130_fd_sc_hd__dfxtp_1 s1_op_2 (.CLK(clk), .D(opcode[2]), .Q(s1_opcode[2]));
    sky130_fd_sc_hd__dfxtp_1 s1_op_3 (.CLK(clk), .D(opcode[3]), .Q(s1_opcode[3]));

    // Valid register
    sky130_fd_sc_hd__dfxtp_1 s1_valid_reg (.CLK(clk), .D(valid_in), .Q(s1_valid));

    // ========================================
    // Stage 2: Arithmetic Operations
    // High fanout from opcode decode
    // ========================================
    wire [15:0] s2_result;
    wire        s2_valid;
    wire        s2_overflow;

    // Opcode decode - HIGH FANOUT (each bit controls many muxes)
    wire op_add, op_sub, op_shl, op_shr;
    wire op_sel0_inv, op_sel1_inv;

    sky130_fd_sc_hd__inv_1 inv_sel0 (.A(s1_opcode[0]), .Y(op_sel0_inv));
    sky130_fd_sc_hd__inv_1 inv_sel1 (.A(s1_opcode[1]), .Y(op_sel1_inv));

    // Decode: 00=add, 01=sub, 10=shl, 11=shr
    sky130_fd_sc_hd__and2_1 dec_add (.A(op_sel0_inv), .B(op_sel1_inv), .X(op_add));
    sky130_fd_sc_hd__and2_1 dec_sub (.A(s1_opcode[0]), .B(op_sel1_inv), .X(op_sub));
    sky130_fd_sc_hd__and2_1 dec_shl (.A(op_sel0_inv), .B(s1_opcode[1]), .X(op_shl));
    sky130_fd_sc_hd__and2_1 dec_shr (.A(s1_opcode[0]), .B(s1_opcode[1]), .X(op_shr));

    // Increment by 1 for add operation (simple adder)
    wire [15:0] add_result;
    wire c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15;

    sky130_fd_sc_hd__ha_1 ha0  (.A(s1_data[0]),  .B(1'b1), .COUT(c0),  .SUM(add_result[0]));
    sky130_fd_sc_hd__ha_1 ha1  (.A(s1_data[1]),  .B(c0),   .COUT(c1),  .SUM(add_result[1]));
    sky130_fd_sc_hd__ha_1 ha2  (.A(s1_data[2]),  .B(c1),   .COUT(c2),  .SUM(add_result[2]));
    sky130_fd_sc_hd__ha_1 ha3  (.A(s1_data[3]),  .B(c2),   .COUT(c3),  .SUM(add_result[3]));
    sky130_fd_sc_hd__ha_1 ha4  (.A(s1_data[4]),  .B(c3),   .COUT(c4),  .SUM(add_result[4]));
    sky130_fd_sc_hd__ha_1 ha5  (.A(s1_data[5]),  .B(c4),   .COUT(c5),  .SUM(add_result[5]));
    sky130_fd_sc_hd__ha_1 ha6  (.A(s1_data[6]),  .B(c5),   .COUT(c6),  .SUM(add_result[6]));
    sky130_fd_sc_hd__ha_1 ha7  (.A(s1_data[7]),  .B(c6),   .COUT(c7),  .SUM(add_result[7]));
    sky130_fd_sc_hd__ha_1 ha8  (.A(s1_data[8]),  .B(c7),   .COUT(c8),  .SUM(add_result[8]));
    sky130_fd_sc_hd__ha_1 ha9  (.A(s1_data[9]),  .B(c8),   .COUT(c9),  .SUM(add_result[9]));
    sky130_fd_sc_hd__ha_1 ha10 (.A(s1_data[10]), .B(c9),   .COUT(c10), .SUM(add_result[10]));
    sky130_fd_sc_hd__ha_1 ha11 (.A(s1_data[11]), .B(c10),  .COUT(c11), .SUM(add_result[11]));
    sky130_fd_sc_hd__ha_1 ha12 (.A(s1_data[12]), .B(c11),  .COUT(c12), .SUM(add_result[12]));
    sky130_fd_sc_hd__ha_1 ha13 (.A(s1_data[13]), .B(c12),  .COUT(c13), .SUM(add_result[13]));
    sky130_fd_sc_hd__ha_1 ha14 (.A(s1_data[14]), .B(c13),  .COUT(c14), .SUM(add_result[14]));
    sky130_fd_sc_hd__ha_1 ha15 (.A(s1_data[15]), .B(c14),  .COUT(c15), .SUM(add_result[15]));

    // Shift left by 1
    wire [15:0] shl_result;
    assign shl_result = {s1_data[14:0], 1'b0};

    // Shift right by 1
    wire [15:0] shr_result;
    assign shr_result = {1'b0, s1_data[15:1]};

    // Decrement by 1 for sub (invert and add 1 simplified to just pass through inverted for demo)
    wire [15:0] sub_result;
    sky130_fd_sc_hd__inv_1 sub_inv_0  (.A(s1_data[0]),  .Y(sub_result[0]));
    sky130_fd_sc_hd__inv_1 sub_inv_1  (.A(s1_data[1]),  .Y(sub_result[1]));
    sky130_fd_sc_hd__inv_1 sub_inv_2  (.A(s1_data[2]),  .Y(sub_result[2]));
    sky130_fd_sc_hd__inv_1 sub_inv_3  (.A(s1_data[3]),  .Y(sub_result[3]));
    sky130_fd_sc_hd__inv_1 sub_inv_4  (.A(s1_data[4]),  .Y(sub_result[4]));
    sky130_fd_sc_hd__inv_1 sub_inv_5  (.A(s1_data[5]),  .Y(sub_result[5]));
    sky130_fd_sc_hd__inv_1 sub_inv_6  (.A(s1_data[6]),  .Y(sub_result[6]));
    sky130_fd_sc_hd__inv_1 sub_inv_7  (.A(s1_data[7]),  .Y(sub_result[7]));
    sky130_fd_sc_hd__inv_1 sub_inv_8  (.A(s1_data[8]),  .Y(sub_result[8]));
    sky130_fd_sc_hd__inv_1 sub_inv_9  (.A(s1_data[9]),  .Y(sub_result[9]));
    sky130_fd_sc_hd__inv_1 sub_inv_10 (.A(s1_data[10]), .Y(sub_result[10]));
    sky130_fd_sc_hd__inv_1 sub_inv_11 (.A(s1_data[11]), .Y(sub_result[11]));
    sky130_fd_sc_hd__inv_1 sub_inv_12 (.A(s1_data[12]), .Y(sub_result[12]));
    sky130_fd_sc_hd__inv_1 sub_inv_13 (.A(s1_data[13]), .Y(sub_result[13]));
    sky130_fd_sc_hd__inv_1 sub_inv_14 (.A(s1_data[14]), .Y(sub_result[14]));
    sky130_fd_sc_hd__inv_1 sub_inv_15 (.A(s1_data[15]), .Y(sub_result[15]));

    // 4:1 Mux for each bit (using 2 levels of 2:1 mux)
    wire [15:0] mux_l1_0, mux_l1_1;

    // Level 1: select between add/sub and shl/shr
    sky130_fd_sc_hd__mux2_1 mux_l1_0_b0  (.A0(add_result[0]),  .A1(sub_result[0]),  .S(s1_opcode[0]), .X(mux_l1_0[0]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_b1  (.A0(add_result[1]),  .A1(sub_result[1]),  .S(s1_opcode[0]), .X(mux_l1_0[1]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_b2  (.A0(add_result[2]),  .A1(sub_result[2]),  .S(s1_opcode[0]), .X(mux_l1_0[2]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_b3  (.A0(add_result[3]),  .A1(sub_result[3]),  .S(s1_opcode[0]), .X(mux_l1_0[3]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_b4  (.A0(add_result[4]),  .A1(sub_result[4]),  .S(s1_opcode[0]), .X(mux_l1_0[4]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_b5  (.A0(add_result[5]),  .A1(sub_result[5]),  .S(s1_opcode[0]), .X(mux_l1_0[5]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_b6  (.A0(add_result[6]),  .A1(sub_result[6]),  .S(s1_opcode[0]), .X(mux_l1_0[6]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_b7  (.A0(add_result[7]),  .A1(sub_result[7]),  .S(s1_opcode[0]), .X(mux_l1_0[7]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_b8  (.A0(add_result[8]),  .A1(sub_result[8]),  .S(s1_opcode[0]), .X(mux_l1_0[8]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_b9  (.A0(add_result[9]),  .A1(sub_result[9]),  .S(s1_opcode[0]), .X(mux_l1_0[9]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_b10 (.A0(add_result[10]), .A1(sub_result[10]), .S(s1_opcode[0]), .X(mux_l1_0[10]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_b11 (.A0(add_result[11]), .A1(sub_result[11]), .S(s1_opcode[0]), .X(mux_l1_0[11]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_b12 (.A0(add_result[12]), .A1(sub_result[12]), .S(s1_opcode[0]), .X(mux_l1_0[12]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_b13 (.A0(add_result[13]), .A1(sub_result[13]), .S(s1_opcode[0]), .X(mux_l1_0[13]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_b14 (.A0(add_result[14]), .A1(sub_result[14]), .S(s1_opcode[0]), .X(mux_l1_0[14]));
    sky130_fd_sc_hd__mux2_1 mux_l1_0_b15 (.A0(add_result[15]), .A1(sub_result[15]), .S(s1_opcode[0]), .X(mux_l1_0[15]));

    sky130_fd_sc_hd__mux2_1 mux_l1_1_b0  (.A0(shl_result[0]),  .A1(shr_result[0]),  .S(s1_opcode[0]), .X(mux_l1_1[0]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_b1  (.A0(shl_result[1]),  .A1(shr_result[1]),  .S(s1_opcode[0]), .X(mux_l1_1[1]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_b2  (.A0(shl_result[2]),  .A1(shr_result[2]),  .S(s1_opcode[0]), .X(mux_l1_1[2]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_b3  (.A0(shl_result[3]),  .A1(shr_result[3]),  .S(s1_opcode[0]), .X(mux_l1_1[3]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_b4  (.A0(shl_result[4]),  .A1(shr_result[4]),  .S(s1_opcode[0]), .X(mux_l1_1[4]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_b5  (.A0(shl_result[5]),  .A1(shr_result[5]),  .S(s1_opcode[0]), .X(mux_l1_1[5]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_b6  (.A0(shl_result[6]),  .A1(shr_result[6]),  .S(s1_opcode[0]), .X(mux_l1_1[6]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_b7  (.A0(shl_result[7]),  .A1(shr_result[7]),  .S(s1_opcode[0]), .X(mux_l1_1[7]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_b8  (.A0(shl_result[8]),  .A1(shr_result[8]),  .S(s1_opcode[0]), .X(mux_l1_1[8]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_b9  (.A0(shl_result[9]),  .A1(shr_result[9]),  .S(s1_opcode[0]), .X(mux_l1_1[9]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_b10 (.A0(shl_result[10]), .A1(shr_result[10]), .S(s1_opcode[0]), .X(mux_l1_1[10]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_b11 (.A0(shl_result[11]), .A1(shr_result[11]), .S(s1_opcode[0]), .X(mux_l1_1[11]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_b12 (.A0(shl_result[12]), .A1(shr_result[12]), .S(s1_opcode[0]), .X(mux_l1_1[12]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_b13 (.A0(shl_result[13]), .A1(shr_result[13]), .S(s1_opcode[0]), .X(mux_l1_1[13]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_b14 (.A0(shl_result[14]), .A1(shr_result[14]), .S(s1_opcode[0]), .X(mux_l1_1[14]));
    sky130_fd_sc_hd__mux2_1 mux_l1_1_b15 (.A0(shl_result[15]), .A1(shr_result[15]), .S(s1_opcode[0]), .X(mux_l1_1[15]));

    // Level 2: select between arithmetic and shift
    wire [15:0] alu_out;
    sky130_fd_sc_hd__mux2_1 mux_l2_b0  (.A0(mux_l1_0[0]),  .A1(mux_l1_1[0]),  .S(s1_opcode[1]), .X(alu_out[0]));
    sky130_fd_sc_hd__mux2_1 mux_l2_b1  (.A0(mux_l1_0[1]),  .A1(mux_l1_1[1]),  .S(s1_opcode[1]), .X(alu_out[1]));
    sky130_fd_sc_hd__mux2_1 mux_l2_b2  (.A0(mux_l1_0[2]),  .A1(mux_l1_1[2]),  .S(s1_opcode[1]), .X(alu_out[2]));
    sky130_fd_sc_hd__mux2_1 mux_l2_b3  (.A0(mux_l1_0[3]),  .A1(mux_l1_1[3]),  .S(s1_opcode[1]), .X(alu_out[3]));
    sky130_fd_sc_hd__mux2_1 mux_l2_b4  (.A0(mux_l1_0[4]),  .A1(mux_l1_1[4]),  .S(s1_opcode[1]), .X(alu_out[4]));
    sky130_fd_sc_hd__mux2_1 mux_l2_b5  (.A0(mux_l1_0[5]),  .A1(mux_l1_1[5]),  .S(s1_opcode[1]), .X(alu_out[5]));
    sky130_fd_sc_hd__mux2_1 mux_l2_b6  (.A0(mux_l1_0[6]),  .A1(mux_l1_1[6]),  .S(s1_opcode[1]), .X(alu_out[6]));
    sky130_fd_sc_hd__mux2_1 mux_l2_b7  (.A0(mux_l1_0[7]),  .A1(mux_l1_1[7]),  .S(s1_opcode[1]), .X(alu_out[7]));
    sky130_fd_sc_hd__mux2_1 mux_l2_b8  (.A0(mux_l1_0[8]),  .A1(mux_l1_1[8]),  .S(s1_opcode[1]), .X(alu_out[8]));
    sky130_fd_sc_hd__mux2_1 mux_l2_b9  (.A0(mux_l1_0[9]),  .A1(mux_l1_1[9]),  .S(s1_opcode[1]), .X(alu_out[9]));
    sky130_fd_sc_hd__mux2_1 mux_l2_b10 (.A0(mux_l1_0[10]), .A1(mux_l1_1[10]), .S(s1_opcode[1]), .X(alu_out[10]));
    sky130_fd_sc_hd__mux2_1 mux_l2_b11 (.A0(mux_l1_0[11]), .A1(mux_l1_1[11]), .S(s1_opcode[1]), .X(alu_out[11]));
    sky130_fd_sc_hd__mux2_1 mux_l2_b12 (.A0(mux_l1_0[12]), .A1(mux_l1_1[12]), .S(s1_opcode[1]), .X(alu_out[12]));
    sky130_fd_sc_hd__mux2_1 mux_l2_b13 (.A0(mux_l1_0[13]), .A1(mux_l1_1[13]), .S(s1_opcode[1]), .X(alu_out[13]));
    sky130_fd_sc_hd__mux2_1 mux_l2_b14 (.A0(mux_l1_0[14]), .A1(mux_l1_1[14]), .S(s1_opcode[1]), .X(alu_out[14]));
    sky130_fd_sc_hd__mux2_1 mux_l2_b15 (.A0(mux_l1_0[15]), .A1(mux_l1_1[15]), .S(s1_opcode[1]), .X(alu_out[15]));

    // Stage 2 registers
    sky130_fd_sc_hd__dfxtp_1 s2_reg_0  (.CLK(clk), .D(alu_out[0]),  .Q(s2_result[0]));
    sky130_fd_sc_hd__dfxtp_1 s2_reg_1  (.CLK(clk), .D(alu_out[1]),  .Q(s2_result[1]));
    sky130_fd_sc_hd__dfxtp_1 s2_reg_2  (.CLK(clk), .D(alu_out[2]),  .Q(s2_result[2]));
    sky130_fd_sc_hd__dfxtp_1 s2_reg_3  (.CLK(clk), .D(alu_out[3]),  .Q(s2_result[3]));
    sky130_fd_sc_hd__dfxtp_1 s2_reg_4  (.CLK(clk), .D(alu_out[4]),  .Q(s2_result[4]));
    sky130_fd_sc_hd__dfxtp_1 s2_reg_5  (.CLK(clk), .D(alu_out[5]),  .Q(s2_result[5]));
    sky130_fd_sc_hd__dfxtp_1 s2_reg_6  (.CLK(clk), .D(alu_out[6]),  .Q(s2_result[6]));
    sky130_fd_sc_hd__dfxtp_1 s2_reg_7  (.CLK(clk), .D(alu_out[7]),  .Q(s2_result[7]));
    sky130_fd_sc_hd__dfxtp_1 s2_reg_8  (.CLK(clk), .D(alu_out[8]),  .Q(s2_result[8]));
    sky130_fd_sc_hd__dfxtp_1 s2_reg_9  (.CLK(clk), .D(alu_out[9]),  .Q(s2_result[9]));
    sky130_fd_sc_hd__dfxtp_1 s2_reg_10 (.CLK(clk), .D(alu_out[10]), .Q(s2_result[10]));
    sky130_fd_sc_hd__dfxtp_1 s2_reg_11 (.CLK(clk), .D(alu_out[11]), .Q(s2_result[11]));
    sky130_fd_sc_hd__dfxtp_1 s2_reg_12 (.CLK(clk), .D(alu_out[12]), .Q(s2_result[12]));
    sky130_fd_sc_hd__dfxtp_1 s2_reg_13 (.CLK(clk), .D(alu_out[13]), .Q(s2_result[13]));
    sky130_fd_sc_hd__dfxtp_1 s2_reg_14 (.CLK(clk), .D(alu_out[14]), .Q(s2_result[14]));
    sky130_fd_sc_hd__dfxtp_1 s2_reg_15 (.CLK(clk), .D(alu_out[15]), .Q(s2_result[15]));

    sky130_fd_sc_hd__dfxtp_1 s2_valid_reg (.CLK(clk), .D(s1_valid), .Q(s2_valid));
    sky130_fd_sc_hd__dfxtp_1 s2_ovf_reg (.CLK(clk), .D(c15), .Q(s2_overflow));

    // ========================================
    // Stage 3: Logic Operations (XOR pattern)
    // ========================================
    wire [15:0] s3_result;
    wire        s3_valid;
    wire        s3_overflow;

    // XOR with constant pattern for parity check
    wire [15:0] xor_out;
    sky130_fd_sc_hd__xor2_1 xor_0  (.A(s2_result[0]),  .B(s2_result[8]),  .X(xor_out[0]));
    sky130_fd_sc_hd__xor2_1 xor_1  (.A(s2_result[1]),  .B(s2_result[9]),  .X(xor_out[1]));
    sky130_fd_sc_hd__xor2_1 xor_2  (.A(s2_result[2]),  .B(s2_result[10]), .X(xor_out[2]));
    sky130_fd_sc_hd__xor2_1 xor_3  (.A(s2_result[3]),  .B(s2_result[11]), .X(xor_out[3]));
    sky130_fd_sc_hd__xor2_1 xor_4  (.A(s2_result[4]),  .B(s2_result[12]), .X(xor_out[4]));
    sky130_fd_sc_hd__xor2_1 xor_5  (.A(s2_result[5]),  .B(s2_result[13]), .X(xor_out[5]));
    sky130_fd_sc_hd__xor2_1 xor_6  (.A(s2_result[6]),  .B(s2_result[14]), .X(xor_out[6]));
    sky130_fd_sc_hd__xor2_1 xor_7  (.A(s2_result[7]),  .B(s2_result[15]), .X(xor_out[7]));

    // Pass through upper bits
    sky130_fd_sc_hd__buf_1 buf_8  (.A(s2_result[8]),  .X(xor_out[8]));
    sky130_fd_sc_hd__buf_1 buf_9  (.A(s2_result[9]),  .X(xor_out[9]));
    sky130_fd_sc_hd__buf_1 buf_10 (.A(s2_result[10]), .X(xor_out[10]));
    sky130_fd_sc_hd__buf_1 buf_11 (.A(s2_result[11]), .X(xor_out[11]));
    sky130_fd_sc_hd__buf_1 buf_12 (.A(s2_result[12]), .X(xor_out[12]));
    sky130_fd_sc_hd__buf_1 buf_13 (.A(s2_result[13]), .X(xor_out[13]));
    sky130_fd_sc_hd__buf_1 buf_14 (.A(s2_result[14]), .X(xor_out[14]));
    sky130_fd_sc_hd__buf_1 buf_15 (.A(s2_result[15]), .X(xor_out[15]));

    // Stage 3 registers
    sky130_fd_sc_hd__dfxtp_1 s3_reg_0  (.CLK(clk), .D(xor_out[0]),  .Q(s3_result[0]));
    sky130_fd_sc_hd__dfxtp_1 s3_reg_1  (.CLK(clk), .D(xor_out[1]),  .Q(s3_result[1]));
    sky130_fd_sc_hd__dfxtp_1 s3_reg_2  (.CLK(clk), .D(xor_out[2]),  .Q(s3_result[2]));
    sky130_fd_sc_hd__dfxtp_1 s3_reg_3  (.CLK(clk), .D(xor_out[3]),  .Q(s3_result[3]));
    sky130_fd_sc_hd__dfxtp_1 s3_reg_4  (.CLK(clk), .D(xor_out[4]),  .Q(s3_result[4]));
    sky130_fd_sc_hd__dfxtp_1 s3_reg_5  (.CLK(clk), .D(xor_out[5]),  .Q(s3_result[5]));
    sky130_fd_sc_hd__dfxtp_1 s3_reg_6  (.CLK(clk), .D(xor_out[6]),  .Q(s3_result[6]));
    sky130_fd_sc_hd__dfxtp_1 s3_reg_7  (.CLK(clk), .D(xor_out[7]),  .Q(s3_result[7]));
    sky130_fd_sc_hd__dfxtp_1 s3_reg_8  (.CLK(clk), .D(xor_out[8]),  .Q(s3_result[8]));
    sky130_fd_sc_hd__dfxtp_1 s3_reg_9  (.CLK(clk), .D(xor_out[9]),  .Q(s3_result[9]));
    sky130_fd_sc_hd__dfxtp_1 s3_reg_10 (.CLK(clk), .D(xor_out[10]), .Q(s3_result[10]));
    sky130_fd_sc_hd__dfxtp_1 s3_reg_11 (.CLK(clk), .D(xor_out[11]), .Q(s3_result[11]));
    sky130_fd_sc_hd__dfxtp_1 s3_reg_12 (.CLK(clk), .D(xor_out[12]), .Q(s3_result[12]));
    sky130_fd_sc_hd__dfxtp_1 s3_reg_13 (.CLK(clk), .D(xor_out[13]), .Q(s3_result[13]));
    sky130_fd_sc_hd__dfxtp_1 s3_reg_14 (.CLK(clk), .D(xor_out[14]), .Q(s3_result[14]));
    sky130_fd_sc_hd__dfxtp_1 s3_reg_15 (.CLK(clk), .D(xor_out[15]), .Q(s3_result[15]));

    sky130_fd_sc_hd__dfxtp_1 s3_valid_reg (.CLK(clk), .D(s2_valid), .Q(s3_valid));
    sky130_fd_sc_hd__dfxtp_1 s3_ovf_reg (.CLK(clk), .D(s2_overflow), .Q(s3_overflow));

    // ========================================
    // Stage 4: Output Registers
    // ========================================
    sky130_fd_sc_hd__dfxtp_1 out_reg_0  (.CLK(clk), .D(s3_result[0]),  .Q(data_out[0]));
    sky130_fd_sc_hd__dfxtp_1 out_reg_1  (.CLK(clk), .D(s3_result[1]),  .Q(data_out[1]));
    sky130_fd_sc_hd__dfxtp_1 out_reg_2  (.CLK(clk), .D(s3_result[2]),  .Q(data_out[2]));
    sky130_fd_sc_hd__dfxtp_1 out_reg_3  (.CLK(clk), .D(s3_result[3]),  .Q(data_out[3]));
    sky130_fd_sc_hd__dfxtp_1 out_reg_4  (.CLK(clk), .D(s3_result[4]),  .Q(data_out[4]));
    sky130_fd_sc_hd__dfxtp_1 out_reg_5  (.CLK(clk), .D(s3_result[5]),  .Q(data_out[5]));
    sky130_fd_sc_hd__dfxtp_1 out_reg_6  (.CLK(clk), .D(s3_result[6]),  .Q(data_out[6]));
    sky130_fd_sc_hd__dfxtp_1 out_reg_7  (.CLK(clk), .D(s3_result[7]),  .Q(data_out[7]));
    sky130_fd_sc_hd__dfxtp_1 out_reg_8  (.CLK(clk), .D(s3_result[8]),  .Q(data_out[8]));
    sky130_fd_sc_hd__dfxtp_1 out_reg_9  (.CLK(clk), .D(s3_result[9]),  .Q(data_out[9]));
    sky130_fd_sc_hd__dfxtp_1 out_reg_10 (.CLK(clk), .D(s3_result[10]), .Q(data_out[10]));
    sky130_fd_sc_hd__dfxtp_1 out_reg_11 (.CLK(clk), .D(s3_result[11]), .Q(data_out[11]));
    sky130_fd_sc_hd__dfxtp_1 out_reg_12 (.CLK(clk), .D(s3_result[12]), .Q(data_out[12]));
    sky130_fd_sc_hd__dfxtp_1 out_reg_13 (.CLK(clk), .D(s3_result[13]), .Q(data_out[13]));
    sky130_fd_sc_hd__dfxtp_1 out_reg_14 (.CLK(clk), .D(s3_result[14]), .Q(data_out[14]));
    sky130_fd_sc_hd__dfxtp_1 out_reg_15 (.CLK(clk), .D(s3_result[15]), .Q(data_out[15]));

    sky130_fd_sc_hd__dfxtp_1 out_valid_reg (.CLK(clk), .D(s3_valid), .Q(valid_out));
    sky130_fd_sc_hd__dfxtp_1 out_ovf_reg (.CLK(clk), .D(s3_overflow), .Q(overflow));

endmodule
