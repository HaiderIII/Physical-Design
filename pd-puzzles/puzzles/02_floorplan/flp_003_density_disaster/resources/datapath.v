// 16-bit Datapath Unit - Gate-level netlist for ASAP7 RVT
// Contains registers and combinational logic

module datapath_unit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [15:0] data_in,
    input  wire [15:0] coeff,
    input  wire        load,
    input  wire        compute,
    output wire [15:0] data_out,
    output wire        valid
);

    wire [15:0] reg_out;
    wire [15:0] mult_partial;
    wire [15:0] result;
    wire load_inv, compute_inv;

    // Input registers (16 flip-flops)
    DFFHQNx1_ASAP7_75t_R reg_in_0  (.CLK(clk), .D(data_in[0]),  .Q(reg_out[0]));
    DFFHQNx1_ASAP7_75t_R reg_in_1  (.CLK(clk), .D(data_in[1]),  .Q(reg_out[1]));
    DFFHQNx1_ASAP7_75t_R reg_in_2  (.CLK(clk), .D(data_in[2]),  .Q(reg_out[2]));
    DFFHQNx1_ASAP7_75t_R reg_in_3  (.CLK(clk), .D(data_in[3]),  .Q(reg_out[3]));
    DFFHQNx1_ASAP7_75t_R reg_in_4  (.CLK(clk), .D(data_in[4]),  .Q(reg_out[4]));
    DFFHQNx1_ASAP7_75t_R reg_in_5  (.CLK(clk), .D(data_in[5]),  .Q(reg_out[5]));
    DFFHQNx1_ASAP7_75t_R reg_in_6  (.CLK(clk), .D(data_in[6]),  .Q(reg_out[6]));
    DFFHQNx1_ASAP7_75t_R reg_in_7  (.CLK(clk), .D(data_in[7]),  .Q(reg_out[7]));
    DFFHQNx1_ASAP7_75t_R reg_in_8  (.CLK(clk), .D(data_in[8]),  .Q(reg_out[8]));
    DFFHQNx1_ASAP7_75t_R reg_in_9  (.CLK(clk), .D(data_in[9]),  .Q(reg_out[9]));
    DFFHQNx1_ASAP7_75t_R reg_in_10 (.CLK(clk), .D(data_in[10]), .Q(reg_out[10]));
    DFFHQNx1_ASAP7_75t_R reg_in_11 (.CLK(clk), .D(data_in[11]), .Q(reg_out[11]));
    DFFHQNx1_ASAP7_75t_R reg_in_12 (.CLK(clk), .D(data_in[12]), .Q(reg_out[12]));
    DFFHQNx1_ASAP7_75t_R reg_in_13 (.CLK(clk), .D(data_in[13]), .Q(reg_out[13]));
    DFFHQNx1_ASAP7_75t_R reg_in_14 (.CLK(clk), .D(data_in[14]), .Q(reg_out[14]));
    DFFHQNx1_ASAP7_75t_R reg_in_15 (.CLK(clk), .D(data_in[15]), .Q(reg_out[15]));

    // AND gates for multiplication partial products
    AND2x2_ASAP7_75t_R and_0  (.A(reg_out[0]),  .B(coeff[0]),  .Y(mult_partial[0]));
    AND2x2_ASAP7_75t_R and_1  (.A(reg_out[1]),  .B(coeff[1]),  .Y(mult_partial[1]));
    AND2x2_ASAP7_75t_R and_2  (.A(reg_out[2]),  .B(coeff[2]),  .Y(mult_partial[2]));
    AND2x2_ASAP7_75t_R and_3  (.A(reg_out[3]),  .B(coeff[3]),  .Y(mult_partial[3]));
    AND2x2_ASAP7_75t_R and_4  (.A(reg_out[4]),  .B(coeff[4]),  .Y(mult_partial[4]));
    AND2x2_ASAP7_75t_R and_5  (.A(reg_out[5]),  .B(coeff[5]),  .Y(mult_partial[5]));
    AND2x2_ASAP7_75t_R and_6  (.A(reg_out[6]),  .B(coeff[6]),  .Y(mult_partial[6]));
    AND2x2_ASAP7_75t_R and_7  (.A(reg_out[7]),  .B(coeff[7]),  .Y(mult_partial[7]));
    AND2x2_ASAP7_75t_R and_8  (.A(reg_out[8]),  .B(coeff[8]),  .Y(mult_partial[8]));
    AND2x2_ASAP7_75t_R and_9  (.A(reg_out[9]),  .B(coeff[9]),  .Y(mult_partial[9]));
    AND2x2_ASAP7_75t_R and_10 (.A(reg_out[10]), .B(coeff[10]), .Y(mult_partial[10]));
    AND2x2_ASAP7_75t_R and_11 (.A(reg_out[11]), .B(coeff[11]), .Y(mult_partial[11]));
    AND2x2_ASAP7_75t_R and_12 (.A(reg_out[12]), .B(coeff[12]), .Y(mult_partial[12]));
    AND2x2_ASAP7_75t_R and_13 (.A(reg_out[13]), .B(coeff[13]), .Y(mult_partial[13]));
    AND2x2_ASAP7_75t_R and_14 (.A(reg_out[14]), .B(coeff[14]), .Y(mult_partial[14]));
    AND2x2_ASAP7_75t_R and_15 (.A(reg_out[15]), .B(coeff[15]), .Y(mult_partial[15]));

    // XOR for result mixing
    XOR2x1_ASAP7_75t_R xor_0  (.A(mult_partial[0]),  .B(mult_partial[8]),  .Y(result[0]));
    XOR2x1_ASAP7_75t_R xor_1  (.A(mult_partial[1]),  .B(mult_partial[9]),  .Y(result[1]));
    XOR2x1_ASAP7_75t_R xor_2  (.A(mult_partial[2]),  .B(mult_partial[10]), .Y(result[2]));
    XOR2x1_ASAP7_75t_R xor_3  (.A(mult_partial[3]),  .B(mult_partial[11]), .Y(result[3]));
    XOR2x1_ASAP7_75t_R xor_4  (.A(mult_partial[4]),  .B(mult_partial[12]), .Y(result[4]));
    XOR2x1_ASAP7_75t_R xor_5  (.A(mult_partial[5]),  .B(mult_partial[13]), .Y(result[5]));
    XOR2x1_ASAP7_75t_R xor_6  (.A(mult_partial[6]),  .B(mult_partial[14]), .Y(result[6]));
    XOR2x1_ASAP7_75t_R xor_7  (.A(mult_partial[7]),  .B(mult_partial[15]), .Y(result[7]));
    XOR2x1_ASAP7_75t_R xor_8  (.A(mult_partial[8]),  .B(mult_partial[0]),  .Y(result[8]));
    XOR2x1_ASAP7_75t_R xor_9  (.A(mult_partial[9]),  .B(mult_partial[1]),  .Y(result[9]));
    XOR2x1_ASAP7_75t_R xor_10 (.A(mult_partial[10]), .B(mult_partial[2]),  .Y(result[10]));
    XOR2x1_ASAP7_75t_R xor_11 (.A(mult_partial[11]), .B(mult_partial[3]),  .Y(result[11]));
    XOR2x1_ASAP7_75t_R xor_12 (.A(mult_partial[12]), .B(mult_partial[4]),  .Y(result[12]));
    XOR2x1_ASAP7_75t_R xor_13 (.A(mult_partial[13]), .B(mult_partial[5]),  .Y(result[13]));
    XOR2x1_ASAP7_75t_R xor_14 (.A(mult_partial[14]), .B(mult_partial[6]),  .Y(result[14]));
    XOR2x1_ASAP7_75t_R xor_15 (.A(mult_partial[15]), .B(mult_partial[7]),  .Y(result[15]));

    // Output registers (16 flip-flops)
    DFFHQNx1_ASAP7_75t_R reg_out_0  (.CLK(clk), .D(result[0]),  .Q(data_out[0]));
    DFFHQNx1_ASAP7_75t_R reg_out_1  (.CLK(clk), .D(result[1]),  .Q(data_out[1]));
    DFFHQNx1_ASAP7_75t_R reg_out_2  (.CLK(clk), .D(result[2]),  .Q(data_out[2]));
    DFFHQNx1_ASAP7_75t_R reg_out_3  (.CLK(clk), .D(result[3]),  .Q(data_out[3]));
    DFFHQNx1_ASAP7_75t_R reg_out_4  (.CLK(clk), .D(result[4]),  .Q(data_out[4]));
    DFFHQNx1_ASAP7_75t_R reg_out_5  (.CLK(clk), .D(result[5]),  .Q(data_out[5]));
    DFFHQNx1_ASAP7_75t_R reg_out_6  (.CLK(clk), .D(result[6]),  .Q(data_out[6]));
    DFFHQNx1_ASAP7_75t_R reg_out_7  (.CLK(clk), .D(result[7]),  .Q(data_out[7]));
    DFFHQNx1_ASAP7_75t_R reg_out_8  (.CLK(clk), .D(result[8]),  .Q(data_out[8]));
    DFFHQNx1_ASAP7_75t_R reg_out_9  (.CLK(clk), .D(result[9]),  .Q(data_out[9]));
    DFFHQNx1_ASAP7_75t_R reg_out_10 (.CLK(clk), .D(result[10]), .Q(data_out[10]));
    DFFHQNx1_ASAP7_75t_R reg_out_11 (.CLK(clk), .D(result[11]), .Q(data_out[11]));
    DFFHQNx1_ASAP7_75t_R reg_out_12 (.CLK(clk), .D(result[12]), .Q(data_out[12]));
    DFFHQNx1_ASAP7_75t_R reg_out_13 (.CLK(clk), .D(result[13]), .Q(data_out[13]));
    DFFHQNx1_ASAP7_75t_R reg_out_14 (.CLK(clk), .D(result[14]), .Q(data_out[14]));
    DFFHQNx1_ASAP7_75t_R reg_out_15 (.CLK(clk), .D(result[15]), .Q(data_out[15]));

    // Valid signal generation
    INVx1_ASAP7_75t_R inv_load (.A(load), .Y(load_inv));
    AND2x2_ASAP7_75t_R valid_and (.A(compute), .B(load_inv), .Y(valid));

endmodule
