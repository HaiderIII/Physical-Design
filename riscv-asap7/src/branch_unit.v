// ============================================================================
// RISC-V Branch Unit - Branch condition evaluation
// ============================================================================

`include "riscv_pkg.v"

module branch_unit (
    input  wire [31:0] rs1_data,
    input  wire [31:0] rs2_data,
    input  wire [2:0]  funct3,
    input  wire        branch,

    output reg         branch_taken
);

    wire signed [31:0] signed_rs1;
    wire signed [31:0] signed_rs2;

    assign signed_rs1 = rs1_data;
    assign signed_rs2 = rs2_data;

    always @(*) begin
        branch_taken = 1'b0;
        if (branch) begin
            case (funct3)
                `BRANCH_BEQ:  branch_taken = (rs1_data == rs2_data);
                `BRANCH_BNE:  branch_taken = (rs1_data != rs2_data);
                `BRANCH_BLT:  branch_taken = (signed_rs1 < signed_rs2);
                `BRANCH_BGE:  branch_taken = (signed_rs1 >= signed_rs2);
                `BRANCH_BLTU: branch_taken = (rs1_data < rs2_data);
                `BRANCH_BGEU: branch_taken = (rs1_data >= rs2_data);
                default:      branch_taken = 1'b0;
            endcase
        end
    end

endmodule
