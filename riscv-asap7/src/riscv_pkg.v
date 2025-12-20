// ============================================================================
// RISC-V RV32I Package - Constants and Definitions
// ============================================================================
// Project: Complex ASAP7 Physical Design
// Author: Faiz (with Claude assistance for RTL generation)
// Description: Package containing all RISC-V RV32I constants, opcodes, and
//              function codes used throughout the processor design.
// ============================================================================

// Opcodes (bits [6:0] of instruction)
`define OPCODE_LUI      7'b0110111
`define OPCODE_AUIPC    7'b0010111
`define OPCODE_JAL      7'b1101111
`define OPCODE_JALR     7'b1100111
`define OPCODE_BRANCH   7'b1100011
`define OPCODE_LOAD     7'b0000011
`define OPCODE_STORE    7'b0100011
`define OPCODE_OP_IMM   7'b0010011
`define OPCODE_OP       7'b0110011
`define OPCODE_FENCE    7'b0001111
`define OPCODE_SYSTEM   7'b1110011

// ALU Operations
`define ALU_ADD     4'b0000
`define ALU_SUB     4'b0001
`define ALU_SLL     4'b0010
`define ALU_SLT     4'b0011
`define ALU_SLTU    4'b0100
`define ALU_XOR     4'b0101
`define ALU_SRL     4'b0110
`define ALU_SRA     4'b0111
`define ALU_OR      4'b1000
`define ALU_AND     4'b1001
`define ALU_PASS_B  4'b1010

// Branch Types (funct3)
`define BRANCH_BEQ  3'b000
`define BRANCH_BNE  3'b001
`define BRANCH_BLT  3'b100
`define BRANCH_BGE  3'b101
`define BRANCH_BLTU 3'b110
`define BRANCH_BGEU 3'b111

// Load/Store Types (funct3)
`define MEM_BYTE    3'b000
`define MEM_HALF    3'b001
`define MEM_WORD    3'b010
`define MEM_BYTE_U  3'b100
`define MEM_HALF_U  3'b101

// Forwarding Mux Select
`define FWD_NONE    2'b00
`define FWD_MEM     2'b01
`define FWD_WB      2'b10

// PC Source Select
`define PC_PLUS_4   2'b00
`define PC_BRANCH   2'b01
`define PC_JUMP     2'b10
`define PC_JALR     2'b11
