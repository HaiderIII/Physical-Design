// Pre-synthesized netlist for a 4-stage pipeline
// ~100 flip-flops to demonstrate CTS
// Each stage: 16-bit data path

module pipeline (
    input clk,
    input rst_n,
    input [15:0] data_in,
    input valid_in,
    output [15:0] data_out,
    output valid_out
);

    // Pipeline stage wires
    wire [15:0] stage1_data, stage2_data, stage3_data, stage4_data;
    wire stage1_valid, stage2_valid, stage3_valid, stage4_valid;

    // Intermediate processing wires
    wire [15:0] proc1_out, proc2_out, proc3_out;

    // ========================================
    // Stage 1: Input registers
    // ========================================
    DFFRS_X1 s1_d0  (.D(data_in[0]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage1_data[0]));
    DFFRS_X1 s1_d1  (.D(data_in[1]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage1_data[1]));
    DFFRS_X1 s1_d2  (.D(data_in[2]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage1_data[2]));
    DFFRS_X1 s1_d3  (.D(data_in[3]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage1_data[3]));
    DFFRS_X1 s1_d4  (.D(data_in[4]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage1_data[4]));
    DFFRS_X1 s1_d5  (.D(data_in[5]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage1_data[5]));
    DFFRS_X1 s1_d6  (.D(data_in[6]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage1_data[6]));
    DFFRS_X1 s1_d7  (.D(data_in[7]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage1_data[7]));
    DFFRS_X1 s1_d8  (.D(data_in[8]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage1_data[8]));
    DFFRS_X1 s1_d9  (.D(data_in[9]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage1_data[9]));
    DFFRS_X1 s1_d10 (.D(data_in[10]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage1_data[10]));
    DFFRS_X1 s1_d11 (.D(data_in[11]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage1_data[11]));
    DFFRS_X1 s1_d12 (.D(data_in[12]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage1_data[12]));
    DFFRS_X1 s1_d13 (.D(data_in[13]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage1_data[13]));
    DFFRS_X1 s1_d14 (.D(data_in[14]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage1_data[14]));
    DFFRS_X1 s1_d15 (.D(data_in[15]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage1_data[15]));
    DFFRS_X1 s1_v   (.D(valid_in),    .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage1_valid));

    // Processing 1: XOR adjacent bits
    XOR2_X1 p1_x0 (.A(stage1_data[0]),  .B(stage1_data[1]),  .Z(proc1_out[0]));
    XOR2_X1 p1_x1 (.A(stage1_data[1]),  .B(stage1_data[2]),  .Z(proc1_out[1]));
    XOR2_X1 p1_x2 (.A(stage1_data[2]),  .B(stage1_data[3]),  .Z(proc1_out[2]));
    XOR2_X1 p1_x3 (.A(stage1_data[3]),  .B(stage1_data[4]),  .Z(proc1_out[3]));
    XOR2_X1 p1_x4 (.A(stage1_data[4]),  .B(stage1_data[5]),  .Z(proc1_out[4]));
    XOR2_X1 p1_x5 (.A(stage1_data[5]),  .B(stage1_data[6]),  .Z(proc1_out[5]));
    XOR2_X1 p1_x6 (.A(stage1_data[6]),  .B(stage1_data[7]),  .Z(proc1_out[6]));
    XOR2_X1 p1_x7 (.A(stage1_data[7]),  .B(stage1_data[8]),  .Z(proc1_out[7]));
    XOR2_X1 p1_x8 (.A(stage1_data[8]),  .B(stage1_data[9]),  .Z(proc1_out[8]));
    XOR2_X1 p1_x9 (.A(stage1_data[9]),  .B(stage1_data[10]), .Z(proc1_out[9]));
    XOR2_X1 p1_x10(.A(stage1_data[10]), .B(stage1_data[11]), .Z(proc1_out[10]));
    XOR2_X1 p1_x11(.A(stage1_data[11]), .B(stage1_data[12]), .Z(proc1_out[11]));
    XOR2_X1 p1_x12(.A(stage1_data[12]), .B(stage1_data[13]), .Z(proc1_out[12]));
    XOR2_X1 p1_x13(.A(stage1_data[13]), .B(stage1_data[14]), .Z(proc1_out[13]));
    XOR2_X1 p1_x14(.A(stage1_data[14]), .B(stage1_data[15]), .Z(proc1_out[14]));
    XOR2_X1 p1_x15(.A(stage1_data[15]), .B(stage1_data[0]),  .Z(proc1_out[15]));

    // ========================================
    // Stage 2: Pipeline registers
    // ========================================
    DFFRS_X1 s2_d0  (.D(proc1_out[0]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage2_data[0]));
    DFFRS_X1 s2_d1  (.D(proc1_out[1]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage2_data[1]));
    DFFRS_X1 s2_d2  (.D(proc1_out[2]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage2_data[2]));
    DFFRS_X1 s2_d3  (.D(proc1_out[3]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage2_data[3]));
    DFFRS_X1 s2_d4  (.D(proc1_out[4]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage2_data[4]));
    DFFRS_X1 s2_d5  (.D(proc1_out[5]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage2_data[5]));
    DFFRS_X1 s2_d6  (.D(proc1_out[6]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage2_data[6]));
    DFFRS_X1 s2_d7  (.D(proc1_out[7]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage2_data[7]));
    DFFRS_X1 s2_d8  (.D(proc1_out[8]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage2_data[8]));
    DFFRS_X1 s2_d9  (.D(proc1_out[9]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage2_data[9]));
    DFFRS_X1 s2_d10 (.D(proc1_out[10]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage2_data[10]));
    DFFRS_X1 s2_d11 (.D(proc1_out[11]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage2_data[11]));
    DFFRS_X1 s2_d12 (.D(proc1_out[12]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage2_data[12]));
    DFFRS_X1 s2_d13 (.D(proc1_out[13]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage2_data[13]));
    DFFRS_X1 s2_d14 (.D(proc1_out[14]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage2_data[14]));
    DFFRS_X1 s2_d15 (.D(proc1_out[15]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage2_data[15]));
    DFFRS_X1 s2_v   (.D(stage1_valid),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage2_valid));

    // Processing 2: AND with shifted version
    AND2_X1 p2_a0 (.A1(stage2_data[0]),  .A2(stage2_data[8]),  .ZN(proc2_out[0]));
    AND2_X1 p2_a1 (.A1(stage2_data[1]),  .A2(stage2_data[9]),  .ZN(proc2_out[1]));
    AND2_X1 p2_a2 (.A1(stage2_data[2]),  .A2(stage2_data[10]), .ZN(proc2_out[2]));
    AND2_X1 p2_a3 (.A1(stage2_data[3]),  .A2(stage2_data[11]), .ZN(proc2_out[3]));
    AND2_X1 p2_a4 (.A1(stage2_data[4]),  .A2(stage2_data[12]), .ZN(proc2_out[4]));
    AND2_X1 p2_a5 (.A1(stage2_data[5]),  .A2(stage2_data[13]), .ZN(proc2_out[5]));
    AND2_X1 p2_a6 (.A1(stage2_data[6]),  .A2(stage2_data[14]), .ZN(proc2_out[6]));
    AND2_X1 p2_a7 (.A1(stage2_data[7]),  .A2(stage2_data[15]), .ZN(proc2_out[7]));
    AND2_X1 p2_a8 (.A1(stage2_data[8]),  .A2(stage2_data[0]),  .ZN(proc2_out[8]));
    AND2_X1 p2_a9 (.A1(stage2_data[9]),  .A2(stage2_data[1]),  .ZN(proc2_out[9]));
    AND2_X1 p2_a10(.A1(stage2_data[10]), .A2(stage2_data[2]),  .ZN(proc2_out[10]));
    AND2_X1 p2_a11(.A1(stage2_data[11]), .A2(stage2_data[3]),  .ZN(proc2_out[11]));
    AND2_X1 p2_a12(.A1(stage2_data[12]), .A2(stage2_data[4]),  .ZN(proc2_out[12]));
    AND2_X1 p2_a13(.A1(stage2_data[13]), .A2(stage2_data[5]),  .ZN(proc2_out[13]));
    AND2_X1 p2_a14(.A1(stage2_data[14]), .A2(stage2_data[6]),  .ZN(proc2_out[14]));
    AND2_X1 p2_a15(.A1(stage2_data[15]), .A2(stage2_data[7]),  .ZN(proc2_out[15]));

    // ========================================
    // Stage 3: Pipeline registers
    // ========================================
    DFFRS_X1 s3_d0  (.D(proc2_out[0]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage3_data[0]));
    DFFRS_X1 s3_d1  (.D(proc2_out[1]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage3_data[1]));
    DFFRS_X1 s3_d2  (.D(proc2_out[2]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage3_data[2]));
    DFFRS_X1 s3_d3  (.D(proc2_out[3]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage3_data[3]));
    DFFRS_X1 s3_d4  (.D(proc2_out[4]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage3_data[4]));
    DFFRS_X1 s3_d5  (.D(proc2_out[5]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage3_data[5]));
    DFFRS_X1 s3_d6  (.D(proc2_out[6]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage3_data[6]));
    DFFRS_X1 s3_d7  (.D(proc2_out[7]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage3_data[7]));
    DFFRS_X1 s3_d8  (.D(proc2_out[8]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage3_data[8]));
    DFFRS_X1 s3_d9  (.D(proc2_out[9]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage3_data[9]));
    DFFRS_X1 s3_d10 (.D(proc2_out[10]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage3_data[10]));
    DFFRS_X1 s3_d11 (.D(proc2_out[11]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage3_data[11]));
    DFFRS_X1 s3_d12 (.D(proc2_out[12]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage3_data[12]));
    DFFRS_X1 s3_d13 (.D(proc2_out[13]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage3_data[13]));
    DFFRS_X1 s3_d14 (.D(proc2_out[14]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage3_data[14]));
    DFFRS_X1 s3_d15 (.D(proc2_out[15]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage3_data[15]));
    DFFRS_X1 s3_v   (.D(stage2_valid),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage3_valid));

    // Processing 3: OR operation
    OR2_X1 p3_o0 (.A1(stage3_data[0]),  .A2(stage3_data[15]), .ZN(proc3_out[0]));
    OR2_X1 p3_o1 (.A1(stage3_data[1]),  .A2(stage3_data[14]), .ZN(proc3_out[1]));
    OR2_X1 p3_o2 (.A1(stage3_data[2]),  .A2(stage3_data[13]), .ZN(proc3_out[2]));
    OR2_X1 p3_o3 (.A1(stage3_data[3]),  .A2(stage3_data[12]), .ZN(proc3_out[3]));
    OR2_X1 p3_o4 (.A1(stage3_data[4]),  .A2(stage3_data[11]), .ZN(proc3_out[4]));
    OR2_X1 p3_o5 (.A1(stage3_data[5]),  .A2(stage3_data[10]), .ZN(proc3_out[5]));
    OR2_X1 p3_o6 (.A1(stage3_data[6]),  .A2(stage3_data[9]),  .ZN(proc3_out[6]));
    OR2_X1 p3_o7 (.A1(stage3_data[7]),  .A2(stage3_data[8]),  .ZN(proc3_out[7]));
    OR2_X1 p3_o8 (.A1(stage3_data[8]),  .A2(stage3_data[7]),  .ZN(proc3_out[8]));
    OR2_X1 p3_o9 (.A1(stage3_data[9]),  .A2(stage3_data[6]),  .ZN(proc3_out[9]));
    OR2_X1 p3_o10(.A1(stage3_data[10]), .A2(stage3_data[5]),  .ZN(proc3_out[10]));
    OR2_X1 p3_o11(.A1(stage3_data[11]), .A2(stage3_data[4]),  .ZN(proc3_out[11]));
    OR2_X1 p3_o12(.A1(stage3_data[12]), .A2(stage3_data[3]),  .ZN(proc3_out[12]));
    OR2_X1 p3_o13(.A1(stage3_data[13]), .A2(stage3_data[2]),  .ZN(proc3_out[13]));
    OR2_X1 p3_o14(.A1(stage3_data[14]), .A2(stage3_data[1]),  .ZN(proc3_out[14]));
    OR2_X1 p3_o15(.A1(stage3_data[15]), .A2(stage3_data[0]),  .ZN(proc3_out[15]));

    // ========================================
    // Stage 4: Output registers
    // ========================================
    DFFRS_X1 s4_d0  (.D(proc3_out[0]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage4_data[0]));
    DFFRS_X1 s4_d1  (.D(proc3_out[1]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage4_data[1]));
    DFFRS_X1 s4_d2  (.D(proc3_out[2]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage4_data[2]));
    DFFRS_X1 s4_d3  (.D(proc3_out[3]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage4_data[3]));
    DFFRS_X1 s4_d4  (.D(proc3_out[4]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage4_data[4]));
    DFFRS_X1 s4_d5  (.D(proc3_out[5]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage4_data[5]));
    DFFRS_X1 s4_d6  (.D(proc3_out[6]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage4_data[6]));
    DFFRS_X1 s4_d7  (.D(proc3_out[7]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage4_data[7]));
    DFFRS_X1 s4_d8  (.D(proc3_out[8]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage4_data[8]));
    DFFRS_X1 s4_d9  (.D(proc3_out[9]),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage4_data[9]));
    DFFRS_X1 s4_d10 (.D(proc3_out[10]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage4_data[10]));
    DFFRS_X1 s4_d11 (.D(proc3_out[11]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage4_data[11]));
    DFFRS_X1 s4_d12 (.D(proc3_out[12]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage4_data[12]));
    DFFRS_X1 s4_d13 (.D(proc3_out[13]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage4_data[13]));
    DFFRS_X1 s4_d14 (.D(proc3_out[14]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage4_data[14]));
    DFFRS_X1 s4_d15 (.D(proc3_out[15]), .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage4_data[15]));
    DFFRS_X1 s4_v   (.D(stage3_valid),  .CK(clk), .RN(rst_n), .SN(1'b1), .Q(stage4_valid));

    // Output buffers
    BUF_X1 ob0  (.A(stage4_data[0]),  .Z(data_out[0]));
    BUF_X1 ob1  (.A(stage4_data[1]),  .Z(data_out[1]));
    BUF_X1 ob2  (.A(stage4_data[2]),  .Z(data_out[2]));
    BUF_X1 ob3  (.A(stage4_data[3]),  .Z(data_out[3]));
    BUF_X1 ob4  (.A(stage4_data[4]),  .Z(data_out[4]));
    BUF_X1 ob5  (.A(stage4_data[5]),  .Z(data_out[5]));
    BUF_X1 ob6  (.A(stage4_data[6]),  .Z(data_out[6]));
    BUF_X1 ob7  (.A(stage4_data[7]),  .Z(data_out[7]));
    BUF_X1 ob8  (.A(stage4_data[8]),  .Z(data_out[8]));
    BUF_X1 ob9  (.A(stage4_data[9]),  .Z(data_out[9]));
    BUF_X1 ob10 (.A(stage4_data[10]), .Z(data_out[10]));
    BUF_X1 ob11 (.A(stage4_data[11]), .Z(data_out[11]));
    BUF_X1 ob12 (.A(stage4_data[12]), .Z(data_out[12]));
    BUF_X1 ob13 (.A(stage4_data[13]), .Z(data_out[13]));
    BUF_X1 ob14 (.A(stage4_data[14]), .Z(data_out[14]));
    BUF_X1 ob15 (.A(stage4_data[15]), .Z(data_out[15]));
    BUF_X1 obv  (.A(stage4_valid),    .Z(valid_out));

endmodule
