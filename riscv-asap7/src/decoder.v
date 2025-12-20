// ============================================================================
// RISC-V Instruction Decoder
// ============================================================================

`include "riscv_pkg.v"

module decoder (
    input  wire [31:0] instruction,

    // Register addresses
    output wire [4:0]  rs1_addr,
    output wire [4:0]  rs2_addr,
    output wire [4:0]  rd_addr,

    // Immediate value
    output reg  [31:0] immediate,

    // Control signals
    output reg  [3:0]  alu_op,
    output reg         alu_src,        // 0: rs2, 1: immediate
    output reg         mem_read,
    output reg         mem_write,
    output reg  [2:0]  mem_size,
    output reg         reg_write,
    output reg  [1:0]  result_src,     // 0: ALU, 1: Memory, 2: PC+4
    output reg         branch,
    output reg         jump,
    output reg         jalr,
    output reg         lui,
    output reg         auipc,
    output reg  [2:0]  funct3,
    output wire        illegal_instr
);

    wire [6:0] opcode;
    wire [6:0] funct7;

    assign opcode   = instruction[6:0];
    assign funct3   = instruction[14:12];
    assign funct7   = instruction[31:25];
    assign rs1_addr = instruction[19:15];
    assign rs2_addr = instruction[24:20];
    assign rd_addr  = instruction[11:7];

    reg valid_opcode;
    assign illegal_instr = ~valid_opcode;

    // Immediate generation
    always @(*) begin
        case (opcode)
            `OPCODE_LUI,
            `OPCODE_AUIPC:   // U-type
                immediate = {instruction[31:12], 12'b0};

            `OPCODE_JAL:     // J-type
                immediate = {{12{instruction[31]}}, instruction[19:12],
                            instruction[20], instruction[30:21], 1'b0};

            `OPCODE_JALR,
            `OPCODE_LOAD,
            `OPCODE_OP_IMM:  // I-type
                immediate = {{20{instruction[31]}}, instruction[31:20]};

            `OPCODE_BRANCH:  // B-type
                immediate = {{20{instruction[31]}}, instruction[7],
                            instruction[30:25], instruction[11:8], 1'b0};

            `OPCODE_STORE:   // S-type
                immediate = {{20{instruction[31]}}, instruction[31:25],
                            instruction[11:7]};

            default:
                immediate = 32'b0;
        endcase
    end

    // Control signal generation
    always @(*) begin
        // Default values
        alu_op      = `ALU_ADD;
        alu_src     = 1'b0;
        mem_read    = 1'b0;
        mem_write   = 1'b0;
        mem_size    = 3'b010;
        reg_write   = 1'b0;
        result_src  = 2'b00;
        branch      = 1'b0;
        jump        = 1'b0;
        jalr        = 1'b0;
        lui         = 1'b0;
        auipc       = 1'b0;
        valid_opcode = 1'b1;

        case (opcode)
            `OPCODE_LUI: begin
                lui       = 1'b1;
                reg_write = 1'b1;
                alu_op    = `ALU_PASS_B;
                alu_src   = 1'b1;
            end

            `OPCODE_AUIPC: begin
                auipc     = 1'b1;
                reg_write = 1'b1;
                alu_op    = `ALU_ADD;
                alu_src   = 1'b1;
            end

            `OPCODE_JAL: begin
                jump      = 1'b1;
                reg_write = 1'b1;
                result_src = 2'b10;  // PC+4
            end

            `OPCODE_JALR: begin
                jalr      = 1'b1;
                jump      = 1'b1;
                reg_write = 1'b1;
                result_src = 2'b10;  // PC+4
                alu_src   = 1'b1;
                alu_op    = `ALU_ADD;
            end

            `OPCODE_BRANCH: begin
                branch    = 1'b1;
                alu_op    = `ALU_SUB;
            end

            `OPCODE_LOAD: begin
                mem_read  = 1'b1;
                reg_write = 1'b1;
                result_src = 2'b01;  // Memory
                alu_src   = 1'b1;
                alu_op    = `ALU_ADD;
                mem_size  = funct3;
            end

            `OPCODE_STORE: begin
                mem_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = `ALU_ADD;
                mem_size  = funct3;
            end

            `OPCODE_OP_IMM: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                case (funct3)
                    3'b000: alu_op = `ALU_ADD;   // ADDI
                    3'b010: alu_op = `ALU_SLT;   // SLTI
                    3'b011: alu_op = `ALU_SLTU;  // SLTIU
                    3'b100: alu_op = `ALU_XOR;   // XORI
                    3'b110: alu_op = `ALU_OR;    // ORI
                    3'b111: alu_op = `ALU_AND;   // ANDI
                    3'b001: alu_op = `ALU_SLL;   // SLLI
                    3'b101: alu_op = funct7[5] ? `ALU_SRA : `ALU_SRL;  // SRAI/SRLI
                endcase
            end

            `OPCODE_OP: begin
                reg_write = 1'b1;
                case (funct3)
                    3'b000: alu_op = funct7[5] ? `ALU_SUB : `ALU_ADD;  // SUB/ADD
                    3'b001: alu_op = `ALU_SLL;   // SLL
                    3'b010: alu_op = `ALU_SLT;   // SLT
                    3'b011: alu_op = `ALU_SLTU;  // SLTU
                    3'b100: alu_op = `ALU_XOR;   // XOR
                    3'b101: alu_op = funct7[5] ? `ALU_SRA : `ALU_SRL;  // SRA/SRL
                    3'b110: alu_op = `ALU_OR;    // OR
                    3'b111: alu_op = `ALU_AND;   // AND
                endcase
            end

            `OPCODE_FENCE: begin
                // NOP for now
            end

            `OPCODE_SYSTEM: begin
                // NOP for now (ECALL, EBREAK)
            end

            default: begin
                valid_opcode = 1'b0;
            end
        endcase
    end

endmodule
