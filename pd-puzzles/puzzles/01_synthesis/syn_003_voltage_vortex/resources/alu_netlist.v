// Simple 8-bit ALU - Gate-level netlist for ASAP7 RVT
// Operations: AND, OR with registered output
// All cells use RVT (_R suffix)

module alu_8bit (
    input  wire        clk,
    input  wire [7:0]  operand_a,
    input  wire [7:0]  operand_b,
    input  wire        op_sel,
    output wire [7:0]  result,
    output wire        zero_flag
);

    wire [7:0] and_result;
    wire [7:0] or_result;
    wire [7:0] mux_result;
    wire sel_inv;

    // AND operation - using RVT cells
    AND2x2_ASAP7_75t_R and_0 (.A(operand_a[0]), .B(operand_b[0]), .Y(and_result[0]));
    AND2x2_ASAP7_75t_R and_1 (.A(operand_a[1]), .B(operand_b[1]), .Y(and_result[1]));
    AND2x2_ASAP7_75t_R and_2 (.A(operand_a[2]), .B(operand_b[2]), .Y(and_result[2]));
    AND2x2_ASAP7_75t_R and_3 (.A(operand_a[3]), .B(operand_b[3]), .Y(and_result[3]));
    AND2x2_ASAP7_75t_R and_4 (.A(operand_a[4]), .B(operand_b[4]), .Y(and_result[4]));
    AND2x2_ASAP7_75t_R and_5 (.A(operand_a[5]), .B(operand_b[5]), .Y(and_result[5]));
    AND2x2_ASAP7_75t_R and_6 (.A(operand_a[6]), .B(operand_b[6]), .Y(and_result[6]));
    AND2x2_ASAP7_75t_R and_7 (.A(operand_a[7]), .B(operand_b[7]), .Y(and_result[7]));

    // OR operation - using RVT cells
    OR2x2_ASAP7_75t_R or_0 (.A(operand_a[0]), .B(operand_b[0]), .Y(or_result[0]));
    OR2x2_ASAP7_75t_R or_1 (.A(operand_a[1]), .B(operand_b[1]), .Y(or_result[1]));
    OR2x2_ASAP7_75t_R or_2 (.A(operand_a[2]), .B(operand_b[2]), .Y(or_result[2]));
    OR2x2_ASAP7_75t_R or_3 (.A(operand_a[3]), .B(operand_b[3]), .Y(or_result[3]));
    OR2x2_ASAP7_75t_R or_4 (.A(operand_a[4]), .B(operand_b[4]), .Y(or_result[4]));
    OR2x2_ASAP7_75t_R or_5 (.A(operand_a[5]), .B(operand_b[5]), .Y(or_result[5]));
    OR2x2_ASAP7_75t_R or_6 (.A(operand_a[6]), .B(operand_b[6]), .Y(or_result[6]));
    OR2x2_ASAP7_75t_R or_7 (.A(operand_a[7]), .B(operand_b[7]), .Y(or_result[7]));

    // Mux select inversion
    INVx1_ASAP7_75t_R inv_sel (.A(op_sel), .Y(sel_inv));

    // MUX using AO22: Y = (A1 & A2) | (B1 & B2)
    AO22x1_ASAP7_75t_R mux_0 (.A1(or_result[0]), .A2(op_sel), .B1(and_result[0]), .B2(sel_inv), .Y(mux_result[0]));
    AO22x1_ASAP7_75t_R mux_1 (.A1(or_result[1]), .A2(op_sel), .B1(and_result[1]), .B2(sel_inv), .Y(mux_result[1]));
    AO22x1_ASAP7_75t_R mux_2 (.A1(or_result[2]), .A2(op_sel), .B1(and_result[2]), .B2(sel_inv), .Y(mux_result[2]));
    AO22x1_ASAP7_75t_R mux_3 (.A1(or_result[3]), .A2(op_sel), .B1(and_result[3]), .B2(sel_inv), .Y(mux_result[3]));
    AO22x1_ASAP7_75t_R mux_4 (.A1(or_result[4]), .A2(op_sel), .B1(and_result[4]), .B2(sel_inv), .Y(mux_result[4]));
    AO22x1_ASAP7_75t_R mux_5 (.A1(or_result[5]), .A2(op_sel), .B1(and_result[5]), .B2(sel_inv), .Y(mux_result[5]));
    AO22x1_ASAP7_75t_R mux_6 (.A1(or_result[6]), .A2(op_sel), .B1(and_result[6]), .B2(sel_inv), .Y(mux_result[6]));
    AO22x1_ASAP7_75t_R mux_7 (.A1(or_result[7]), .A2(op_sel), .B1(and_result[7]), .B2(sel_inv), .Y(mux_result[7]));

    // Output flip-flops - using RVT cells
    DFFHQNx1_ASAP7_75t_R ff_0 (.CLK(clk), .D(mux_result[0]), .Q(result[0]));
    DFFHQNx1_ASAP7_75t_R ff_1 (.CLK(clk), .D(mux_result[1]), .Q(result[1]));
    DFFHQNx1_ASAP7_75t_R ff_2 (.CLK(clk), .D(mux_result[2]), .Q(result[2]));
    DFFHQNx1_ASAP7_75t_R ff_3 (.CLK(clk), .D(mux_result[3]), .Q(result[3]));
    DFFHQNx1_ASAP7_75t_R ff_4 (.CLK(clk), .D(mux_result[4]), .Q(result[4]));
    DFFHQNx1_ASAP7_75t_R ff_5 (.CLK(clk), .D(mux_result[5]), .Q(result[5]));
    DFFHQNx1_ASAP7_75t_R ff_6 (.CLK(clk), .D(mux_result[6]), .Q(result[6]));
    DFFHQNx1_ASAP7_75t_R ff_7 (.CLK(clk), .D(mux_result[7]), .Q(result[7]));

    // Zero flag detection
    wire [1:0] zero_partial;
    NOR4x1_ASAP7_75t_R zero_nor1 (.A(result[0]), .B(result[1]), .C(result[2]), .D(result[3]), .Y(zero_partial[0]));
    NOR4x1_ASAP7_75t_R zero_nor2 (.A(result[4]), .B(result[5]), .C(result[6]), .D(result[7]), .Y(zero_partial[1]));
    AND2x2_ASAP7_75t_R zero_and (.A(zero_partial[0]), .B(zero_partial[1]), .Y(zero_flag));

endmodule
