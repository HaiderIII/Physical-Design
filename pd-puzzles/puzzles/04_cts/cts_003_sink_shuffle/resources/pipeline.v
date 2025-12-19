// 8-stage Pipeline Register - Pre-synthesized ASAP7 RVT netlist
// For CTS sink clustering puzzle

module pipeline (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  data_in,
    output wire [7:0]  data_out
);

    // Pipeline stage signals
    wire [7:0] stage0, stage1, stage2, stage3;
    wire [7:0] stage4, stage5, stage6, stage7;

    // Stage 0: Input register
    DFFHQNx1_ASAP7_75t_R ff0_0 (.D(data_in[0]), .CLK(clk), .QN(stage0_n[0]));
    DFFHQNx1_ASAP7_75t_R ff0_1 (.D(data_in[1]), .CLK(clk), .QN(stage0_n[1]));
    DFFHQNx1_ASAP7_75t_R ff0_2 (.D(data_in[2]), .CLK(clk), .QN(stage0_n[2]));
    DFFHQNx1_ASAP7_75t_R ff0_3 (.D(data_in[3]), .CLK(clk), .QN(stage0_n[3]));
    DFFHQNx1_ASAP7_75t_R ff0_4 (.D(data_in[4]), .CLK(clk), .QN(stage0_n[4]));
    DFFHQNx1_ASAP7_75t_R ff0_5 (.D(data_in[5]), .CLK(clk), .QN(stage0_n[5]));
    DFFHQNx1_ASAP7_75t_R ff0_6 (.D(data_in[6]), .CLK(clk), .QN(stage0_n[6]));
    DFFHQNx1_ASAP7_75t_R ff0_7 (.D(data_in[7]), .CLK(clk), .QN(stage0_n[7]));

    INVx1_ASAP7_75t_R inv0_0 (.A(stage0_n[0]), .Y(stage0[0]));
    INVx1_ASAP7_75t_R inv0_1 (.A(stage0_n[1]), .Y(stage0[1]));
    INVx1_ASAP7_75t_R inv0_2 (.A(stage0_n[2]), .Y(stage0[2]));
    INVx1_ASAP7_75t_R inv0_3 (.A(stage0_n[3]), .Y(stage0[3]));
    INVx1_ASAP7_75t_R inv0_4 (.A(stage0_n[4]), .Y(stage0[4]));
    INVx1_ASAP7_75t_R inv0_5 (.A(stage0_n[5]), .Y(stage0[5]));
    INVx1_ASAP7_75t_R inv0_6 (.A(stage0_n[6]), .Y(stage0[6]));
    INVx1_ASAP7_75t_R inv0_7 (.A(stage0_n[7]), .Y(stage0[7]));

    // Stage 1
    DFFHQNx1_ASAP7_75t_R ff1_0 (.D(stage0[0]), .CLK(clk), .QN(stage1_n[0]));
    DFFHQNx1_ASAP7_75t_R ff1_1 (.D(stage0[1]), .CLK(clk), .QN(stage1_n[1]));
    DFFHQNx1_ASAP7_75t_R ff1_2 (.D(stage0[2]), .CLK(clk), .QN(stage1_n[2]));
    DFFHQNx1_ASAP7_75t_R ff1_3 (.D(stage0[3]), .CLK(clk), .QN(stage1_n[3]));
    DFFHQNx1_ASAP7_75t_R ff1_4 (.D(stage0[4]), .CLK(clk), .QN(stage1_n[4]));
    DFFHQNx1_ASAP7_75t_R ff1_5 (.D(stage0[5]), .CLK(clk), .QN(stage1_n[5]));
    DFFHQNx1_ASAP7_75t_R ff1_6 (.D(stage0[6]), .CLK(clk), .QN(stage1_n[6]));
    DFFHQNx1_ASAP7_75t_R ff1_7 (.D(stage0[7]), .CLK(clk), .QN(stage1_n[7]));

    INVx1_ASAP7_75t_R inv1_0 (.A(stage1_n[0]), .Y(stage1[0]));
    INVx1_ASAP7_75t_R inv1_1 (.A(stage1_n[1]), .Y(stage1[1]));
    INVx1_ASAP7_75t_R inv1_2 (.A(stage1_n[2]), .Y(stage1[2]));
    INVx1_ASAP7_75t_R inv1_3 (.A(stage1_n[3]), .Y(stage1[3]));
    INVx1_ASAP7_75t_R inv1_4 (.A(stage1_n[4]), .Y(stage1[4]));
    INVx1_ASAP7_75t_R inv1_5 (.A(stage1_n[5]), .Y(stage1[5]));
    INVx1_ASAP7_75t_R inv1_6 (.A(stage1_n[6]), .Y(stage1[6]));
    INVx1_ASAP7_75t_R inv1_7 (.A(stage1_n[7]), .Y(stage1[7]));

    // Stage 2
    DFFHQNx1_ASAP7_75t_R ff2_0 (.D(stage1[0]), .CLK(clk), .QN(stage2_n[0]));
    DFFHQNx1_ASAP7_75t_R ff2_1 (.D(stage1[1]), .CLK(clk), .QN(stage2_n[1]));
    DFFHQNx1_ASAP7_75t_R ff2_2 (.D(stage1[2]), .CLK(clk), .QN(stage2_n[2]));
    DFFHQNx1_ASAP7_75t_R ff2_3 (.D(stage1[3]), .CLK(clk), .QN(stage2_n[3]));
    DFFHQNx1_ASAP7_75t_R ff2_4 (.D(stage1[4]), .CLK(clk), .QN(stage2_n[4]));
    DFFHQNx1_ASAP7_75t_R ff2_5 (.D(stage1[5]), .CLK(clk), .QN(stage2_n[5]));
    DFFHQNx1_ASAP7_75t_R ff2_6 (.D(stage1[6]), .CLK(clk), .QN(stage2_n[6]));
    DFFHQNx1_ASAP7_75t_R ff2_7 (.D(stage1[7]), .CLK(clk), .QN(stage2_n[7]));

    INVx1_ASAP7_75t_R inv2_0 (.A(stage2_n[0]), .Y(stage2[0]));
    INVx1_ASAP7_75t_R inv2_1 (.A(stage2_n[1]), .Y(stage2[1]));
    INVx1_ASAP7_75t_R inv2_2 (.A(stage2_n[2]), .Y(stage2[2]));
    INVx1_ASAP7_75t_R inv2_3 (.A(stage2_n[3]), .Y(stage2[3]));
    INVx1_ASAP7_75t_R inv2_4 (.A(stage2_n[4]), .Y(stage2[4]));
    INVx1_ASAP7_75t_R inv2_5 (.A(stage2_n[5]), .Y(stage2[5]));
    INVx1_ASAP7_75t_R inv2_6 (.A(stage2_n[6]), .Y(stage2[6]));
    INVx1_ASAP7_75t_R inv2_7 (.A(stage2_n[7]), .Y(stage2[7]));

    // Stage 3
    DFFHQNx1_ASAP7_75t_R ff3_0 (.D(stage2[0]), .CLK(clk), .QN(stage3_n[0]));
    DFFHQNx1_ASAP7_75t_R ff3_1 (.D(stage2[1]), .CLK(clk), .QN(stage3_n[1]));
    DFFHQNx1_ASAP7_75t_R ff3_2 (.D(stage2[2]), .CLK(clk), .QN(stage3_n[2]));
    DFFHQNx1_ASAP7_75t_R ff3_3 (.D(stage2[3]), .CLK(clk), .QN(stage3_n[3]));
    DFFHQNx1_ASAP7_75t_R ff3_4 (.D(stage2[4]), .CLK(clk), .QN(stage3_n[4]));
    DFFHQNx1_ASAP7_75t_R ff3_5 (.D(stage2[5]), .CLK(clk), .QN(stage3_n[5]));
    DFFHQNx1_ASAP7_75t_R ff3_6 (.D(stage2[6]), .CLK(clk), .QN(stage3_n[6]));
    DFFHQNx1_ASAP7_75t_R ff3_7 (.D(stage2[7]), .CLK(clk), .QN(stage3_n[7]));

    INVx1_ASAP7_75t_R inv3_0 (.A(stage3_n[0]), .Y(stage3[0]));
    INVx1_ASAP7_75t_R inv3_1 (.A(stage3_n[1]), .Y(stage3[1]));
    INVx1_ASAP7_75t_R inv3_2 (.A(stage3_n[2]), .Y(stage3[2]));
    INVx1_ASAP7_75t_R inv3_3 (.A(stage3_n[3]), .Y(stage3[3]));
    INVx1_ASAP7_75t_R inv3_4 (.A(stage3_n[4]), .Y(stage3[4]));
    INVx1_ASAP7_75t_R inv3_5 (.A(stage3_n[5]), .Y(stage3[5]));
    INVx1_ASAP7_75t_R inv3_6 (.A(stage3_n[6]), .Y(stage3[6]));
    INVx1_ASAP7_75t_R inv3_7 (.A(stage3_n[7]), .Y(stage3[7]));

    // Stage 4
    DFFHQNx1_ASAP7_75t_R ff4_0 (.D(stage3[0]), .CLK(clk), .QN(stage4_n[0]));
    DFFHQNx1_ASAP7_75t_R ff4_1 (.D(stage3[1]), .CLK(clk), .QN(stage4_n[1]));
    DFFHQNx1_ASAP7_75t_R ff4_2 (.D(stage3[2]), .CLK(clk), .QN(stage4_n[2]));
    DFFHQNx1_ASAP7_75t_R ff4_3 (.D(stage3[3]), .CLK(clk), .QN(stage4_n[3]));
    DFFHQNx1_ASAP7_75t_R ff4_4 (.D(stage3[4]), .CLK(clk), .QN(stage4_n[4]));
    DFFHQNx1_ASAP7_75t_R ff4_5 (.D(stage3[5]), .CLK(clk), .QN(stage4_n[5]));
    DFFHQNx1_ASAP7_75t_R ff4_6 (.D(stage3[6]), .CLK(clk), .QN(stage4_n[6]));
    DFFHQNx1_ASAP7_75t_R ff4_7 (.D(stage3[7]), .CLK(clk), .QN(stage4_n[7]));

    INVx1_ASAP7_75t_R inv4_0 (.A(stage4_n[0]), .Y(stage4[0]));
    INVx1_ASAP7_75t_R inv4_1 (.A(stage4_n[1]), .Y(stage4[1]));
    INVx1_ASAP7_75t_R inv4_2 (.A(stage4_n[2]), .Y(stage4[2]));
    INVx1_ASAP7_75t_R inv4_3 (.A(stage4_n[3]), .Y(stage4[3]));
    INVx1_ASAP7_75t_R inv4_4 (.A(stage4_n[4]), .Y(stage4[4]));
    INVx1_ASAP7_75t_R inv4_5 (.A(stage4_n[5]), .Y(stage4[5]));
    INVx1_ASAP7_75t_R inv4_6 (.A(stage4_n[6]), .Y(stage4[6]));
    INVx1_ASAP7_75t_R inv4_7 (.A(stage4_n[7]), .Y(stage4[7]));

    // Stage 5
    DFFHQNx1_ASAP7_75t_R ff5_0 (.D(stage4[0]), .CLK(clk), .QN(stage5_n[0]));
    DFFHQNx1_ASAP7_75t_R ff5_1 (.D(stage4[1]), .CLK(clk), .QN(stage5_n[1]));
    DFFHQNx1_ASAP7_75t_R ff5_2 (.D(stage4[2]), .CLK(clk), .QN(stage5_n[2]));
    DFFHQNx1_ASAP7_75t_R ff5_3 (.D(stage4[3]), .CLK(clk), .QN(stage5_n[3]));
    DFFHQNx1_ASAP7_75t_R ff5_4 (.D(stage4[4]), .CLK(clk), .QN(stage5_n[4]));
    DFFHQNx1_ASAP7_75t_R ff5_5 (.D(stage4[5]), .CLK(clk), .QN(stage5_n[5]));
    DFFHQNx1_ASAP7_75t_R ff5_6 (.D(stage4[6]), .CLK(clk), .QN(stage5_n[6]));
    DFFHQNx1_ASAP7_75t_R ff5_7 (.D(stage4[7]), .CLK(clk), .QN(stage5_n[7]));

    INVx1_ASAP7_75t_R inv5_0 (.A(stage5_n[0]), .Y(stage5[0]));
    INVx1_ASAP7_75t_R inv5_1 (.A(stage5_n[1]), .Y(stage5[1]));
    INVx1_ASAP7_75t_R inv5_2 (.A(stage5_n[2]), .Y(stage5[2]));
    INVx1_ASAP7_75t_R inv5_3 (.A(stage5_n[3]), .Y(stage5[3]));
    INVx1_ASAP7_75t_R inv5_4 (.A(stage5_n[4]), .Y(stage5[4]));
    INVx1_ASAP7_75t_R inv5_5 (.A(stage5_n[5]), .Y(stage5[5]));
    INVx1_ASAP7_75t_R inv5_6 (.A(stage5_n[6]), .Y(stage5[6]));
    INVx1_ASAP7_75t_R inv5_7 (.A(stage5_n[7]), .Y(stage5[7]));

    // Stage 6
    DFFHQNx1_ASAP7_75t_R ff6_0 (.D(stage5[0]), .CLK(clk), .QN(stage6_n[0]));
    DFFHQNx1_ASAP7_75t_R ff6_1 (.D(stage5[1]), .CLK(clk), .QN(stage6_n[1]));
    DFFHQNx1_ASAP7_75t_R ff6_2 (.D(stage5[2]), .CLK(clk), .QN(stage6_n[2]));
    DFFHQNx1_ASAP7_75t_R ff6_3 (.D(stage5[3]), .CLK(clk), .QN(stage6_n[3]));
    DFFHQNx1_ASAP7_75t_R ff6_4 (.D(stage5[4]), .CLK(clk), .QN(stage6_n[4]));
    DFFHQNx1_ASAP7_75t_R ff6_5 (.D(stage5[5]), .CLK(clk), .QN(stage6_n[5]));
    DFFHQNx1_ASAP7_75t_R ff6_6 (.D(stage5[6]), .CLK(clk), .QN(stage6_n[6]));
    DFFHQNx1_ASAP7_75t_R ff6_7 (.D(stage5[7]), .CLK(clk), .QN(stage6_n[7]));

    INVx1_ASAP7_75t_R inv6_0 (.A(stage6_n[0]), .Y(stage6[0]));
    INVx1_ASAP7_75t_R inv6_1 (.A(stage6_n[1]), .Y(stage6[1]));
    INVx1_ASAP7_75t_R inv6_2 (.A(stage6_n[2]), .Y(stage6[2]));
    INVx1_ASAP7_75t_R inv6_3 (.A(stage6_n[3]), .Y(stage6[3]));
    INVx1_ASAP7_75t_R inv6_4 (.A(stage6_n[4]), .Y(stage6[4]));
    INVx1_ASAP7_75t_R inv6_5 (.A(stage6_n[5]), .Y(stage6[5]));
    INVx1_ASAP7_75t_R inv6_6 (.A(stage6_n[6]), .Y(stage6[6]));
    INVx1_ASAP7_75t_R inv6_7 (.A(stage6_n[7]), .Y(stage6[7]));

    // Stage 7: Output register
    DFFHQNx1_ASAP7_75t_R ff7_0 (.D(stage6[0]), .CLK(clk), .QN(stage7_n[0]));
    DFFHQNx1_ASAP7_75t_R ff7_1 (.D(stage6[1]), .CLK(clk), .QN(stage7_n[1]));
    DFFHQNx1_ASAP7_75t_R ff7_2 (.D(stage6[2]), .CLK(clk), .QN(stage7_n[2]));
    DFFHQNx1_ASAP7_75t_R ff7_3 (.D(stage6[3]), .CLK(clk), .QN(stage7_n[3]));
    DFFHQNx1_ASAP7_75t_R ff7_4 (.D(stage6[4]), .CLK(clk), .QN(stage7_n[4]));
    DFFHQNx1_ASAP7_75t_R ff7_5 (.D(stage6[5]), .CLK(clk), .QN(stage7_n[5]));
    DFFHQNx1_ASAP7_75t_R ff7_6 (.D(stage6[6]), .CLK(clk), .QN(stage7_n[6]));
    DFFHQNx1_ASAP7_75t_R ff7_7 (.D(stage6[7]), .CLK(clk), .QN(stage7_n[7]));

    INVx1_ASAP7_75t_R inv7_0 (.A(stage7_n[0]), .Y(stage7[0]));
    INVx1_ASAP7_75t_R inv7_1 (.A(stage7_n[1]), .Y(stage7[1]));
    INVx1_ASAP7_75t_R inv7_2 (.A(stage7_n[2]), .Y(stage7[2]));
    INVx1_ASAP7_75t_R inv7_3 (.A(stage7_n[3]), .Y(stage7[3]));
    INVx1_ASAP7_75t_R inv7_4 (.A(stage7_n[4]), .Y(stage7[4]));
    INVx1_ASAP7_75t_R inv7_5 (.A(stage7_n[5]), .Y(stage7[5]));
    INVx1_ASAP7_75t_R inv7_6 (.A(stage7_n[6]), .Y(stage7[6]));
    INVx1_ASAP7_75t_R inv7_7 (.A(stage7_n[7]), .Y(stage7[7]));

    // Output buffers
    BUFx2_ASAP7_75t_R buf_out_0 (.A(stage7[0]), .Y(data_out[0]));
    BUFx2_ASAP7_75t_R buf_out_1 (.A(stage7[1]), .Y(data_out[1]));
    BUFx2_ASAP7_75t_R buf_out_2 (.A(stage7[2]), .Y(data_out[2]));
    BUFx2_ASAP7_75t_R buf_out_3 (.A(stage7[3]), .Y(data_out[3]));
    BUFx2_ASAP7_75t_R buf_out_4 (.A(stage7[4]), .Y(data_out[4]));
    BUFx2_ASAP7_75t_R buf_out_5 (.A(stage7[5]), .Y(data_out[5]));
    BUFx2_ASAP7_75t_R buf_out_6 (.A(stage7[6]), .Y(data_out[6]));
    BUFx2_ASAP7_75t_R buf_out_7 (.A(stage7[7]), .Y(data_out[7]));

endmodule
