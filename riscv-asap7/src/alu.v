// ============================================================================
// RISC-V ALU - 32-bit Arithmetic Logic Unit
// ============================================================================

`include "riscv_pkg.v"

module alu (
    input  wire [31:0] operand_a,
    input  wire [31:0] operand_b,
    input  wire [3:0]  alu_op,

    output reg  [31:0] result,
    output wire        zero
);

    wire signed [31:0] signed_a;
    wire signed [31:0] signed_b;

    assign signed_a = operand_a;
    assign signed_b = operand_b;
    assign zero = (result == 32'b0);

    always @(*) begin
        case (alu_op)
            `ALU_ADD:    result = operand_a + operand_b;
            `ALU_SUB:    result = operand_a - operand_b;
            `ALU_SLL:    result = operand_a << operand_b[4:0];
            `ALU_SLT:    result = (signed_a < signed_b) ? 32'd1 : 32'd0;
            `ALU_SLTU:   result = (operand_a < operand_b) ? 32'd1 : 32'd0;
            `ALU_XOR:    result = operand_a ^ operand_b;
            `ALU_SRL:    result = operand_a >> operand_b[4:0];
            `ALU_SRA:    result = signed_a >>> operand_b[4:0];
            `ALU_OR:     result = operand_a | operand_b;
            `ALU_AND:    result = operand_a & operand_b;
            `ALU_PASS_B: result = operand_b;
            default:     result = 32'b0;
        endcase
    end

endmodule
