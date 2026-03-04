// ============================================================================
// RISC-V Pipeline Registers - IF/ID, ID/EX, EX/MEM, MEM/WB
// ============================================================================
// Project: RISC-V Physical Design with SKY130 + SRAM Macros
// ============================================================================

// ----------------------------------------------------------------------------
// IF/ID Pipeline Register
// ----------------------------------------------------------------------------
module pipe_if_id (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        stall,
    input  wire        flush,

    input  wire [31:0] if_pc,
    input  wire [31:0] if_pc_plus4,
    input  wire [31:0] if_instruction,

    output reg  [31:0] id_pc,
    output reg  [31:0] id_pc_plus4,
    output reg  [31:0] id_instruction
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            id_pc          <= 32'b0;
            id_pc_plus4    <= 32'b0;
            id_instruction <= 32'h00000013;  // NOP (ADDI x0, x0, 0)
        end else if (flush) begin
            id_pc          <= 32'b0;
            id_pc_plus4    <= 32'b0;
            id_instruction <= 32'h00000013;  // NOP
        end else if (!stall) begin
            id_pc          <= if_pc;
            id_pc_plus4    <= if_pc_plus4;
            id_instruction <= if_instruction;
        end
    end

endmodule

// ----------------------------------------------------------------------------
// ID/EX Pipeline Register
// ----------------------------------------------------------------------------
module pipe_id_ex (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        flush,

    // Data inputs
    input  wire [31:0] id_pc,
    input  wire [31:0] id_pc_plus4,
    input  wire [31:0] id_rs1_data,
    input  wire [31:0] id_rs2_data,
    input  wire [31:0] id_immediate,
    input  wire [4:0]  id_rs1_addr,
    input  wire [4:0]  id_rs2_addr,
    input  wire [4:0]  id_rd_addr,

    // Control inputs
    input  wire [3:0]  id_alu_op,
    input  wire        id_alu_src,
    input  wire        id_mem_read,
    input  wire        id_mem_write,
    input  wire [2:0]  id_mem_size,
    input  wire        id_reg_write,
    input  wire [1:0]  id_result_src,
    input  wire        id_branch,
    input  wire        id_jump,
    input  wire        id_jalr,
    input  wire        id_lui,
    input  wire        id_auipc,
    input  wire [2:0]  id_funct3,

    // Data outputs
    output reg  [31:0] ex_pc,
    output reg  [31:0] ex_pc_plus4,
    output reg  [31:0] ex_rs1_data,
    output reg  [31:0] ex_rs2_data,
    output reg  [31:0] ex_immediate,
    output reg  [4:0]  ex_rs1_addr,
    output reg  [4:0]  ex_rs2_addr,
    output reg  [4:0]  ex_rd_addr,

    // Control outputs
    output reg  [3:0]  ex_alu_op,
    output reg         ex_alu_src,
    output reg         ex_mem_read,
    output reg         ex_mem_write,
    output reg  [2:0]  ex_mem_size,
    output reg         ex_reg_write,
    output reg  [1:0]  ex_result_src,
    output reg         ex_branch,
    output reg         ex_jump,
    output reg         ex_jalr,
    output reg         ex_lui,
    output reg         ex_auipc,
    output reg  [2:0]  ex_funct3
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ex_pc         <= 32'b0;
            ex_pc_plus4   <= 32'b0;
            ex_rs1_data   <= 32'b0;
            ex_rs2_data   <= 32'b0;
            ex_immediate  <= 32'b0;
            ex_rs1_addr   <= 5'b0;
            ex_rs2_addr   <= 5'b0;
            ex_rd_addr    <= 5'b0;
            ex_alu_op     <= 4'b0;
            ex_alu_src    <= 1'b0;
            ex_mem_read   <= 1'b0;
            ex_mem_write  <= 1'b0;
            ex_mem_size   <= 3'b0;
            ex_reg_write  <= 1'b0;
            ex_result_src <= 2'b0;
            ex_branch     <= 1'b0;
            ex_jump       <= 1'b0;
            ex_jalr       <= 1'b0;
            ex_lui        <= 1'b0;
            ex_auipc      <= 1'b0;
            ex_funct3     <= 3'b0;
        end else if (flush) begin
            ex_pc         <= 32'b0;
            ex_pc_plus4   <= 32'b0;
            ex_rs1_data   <= 32'b0;
            ex_rs2_data   <= 32'b0;
            ex_immediate  <= 32'b0;
            ex_rs1_addr   <= 5'b0;
            ex_rs2_addr   <= 5'b0;
            ex_rd_addr    <= 5'b0;
            ex_alu_op     <= 4'b0;
            ex_alu_src    <= 1'b0;
            ex_mem_read   <= 1'b0;
            ex_mem_write  <= 1'b0;
            ex_mem_size   <= 3'b0;
            ex_reg_write  <= 1'b0;
            ex_result_src <= 2'b0;
            ex_branch     <= 1'b0;
            ex_jump       <= 1'b0;
            ex_jalr       <= 1'b0;
            ex_lui        <= 1'b0;
            ex_auipc      <= 1'b0;
            ex_funct3     <= 3'b0;
        end else begin
            ex_pc         <= id_pc;
            ex_pc_plus4   <= id_pc_plus4;
            ex_rs1_data   <= id_rs1_data;
            ex_rs2_data   <= id_rs2_data;
            ex_immediate  <= id_immediate;
            ex_rs1_addr   <= id_rs1_addr;
            ex_rs2_addr   <= id_rs2_addr;
            ex_rd_addr    <= id_rd_addr;
            ex_alu_op     <= id_alu_op;
            ex_alu_src    <= id_alu_src;
            ex_mem_read   <= id_mem_read;
            ex_mem_write  <= id_mem_write;
            ex_mem_size   <= id_mem_size;
            ex_reg_write  <= id_reg_write;
            ex_result_src <= id_result_src;
            ex_branch     <= id_branch;
            ex_jump       <= id_jump;
            ex_jalr       <= id_jalr;
            ex_lui        <= id_lui;
            ex_auipc      <= id_auipc;
            ex_funct3     <= id_funct3;
        end
    end

endmodule

// ----------------------------------------------------------------------------
// EX/MEM Pipeline Register
// ----------------------------------------------------------------------------
module pipe_ex_mem (
    input  wire        clk,
    input  wire        rst_n,

    // Data inputs
    input  wire [31:0] ex_pc_plus4,
    input  wire [31:0] ex_alu_result,
    input  wire [31:0] ex_rs2_data,
    input  wire [4:0]  ex_rd_addr,

    // Control inputs
    input  wire        ex_mem_read,
    input  wire        ex_mem_write,
    input  wire [2:0]  ex_mem_size,
    input  wire        ex_reg_write,
    input  wire [1:0]  ex_result_src,

    // Data outputs
    output reg  [31:0] mem_pc_plus4,
    output reg  [31:0] mem_alu_result,
    output reg  [31:0] mem_rs2_data,
    output reg  [4:0]  mem_rd_addr,

    // Control outputs
    output reg         mem_mem_read,
    output reg         mem_mem_write,
    output reg  [2:0]  mem_mem_size,
    output reg         mem_reg_write,
    output reg  [1:0]  mem_result_src
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mem_pc_plus4   <= 32'b0;
            mem_alu_result <= 32'b0;
            mem_rs2_data   <= 32'b0;
            mem_rd_addr    <= 5'b0;
            mem_mem_read   <= 1'b0;
            mem_mem_write  <= 1'b0;
            mem_mem_size   <= 3'b0;
            mem_reg_write  <= 1'b0;
            mem_result_src <= 2'b0;
        end else begin
            mem_pc_plus4   <= ex_pc_plus4;
            mem_alu_result <= ex_alu_result;
            mem_rs2_data   <= ex_rs2_data;
            mem_rd_addr    <= ex_rd_addr;
            mem_mem_read   <= ex_mem_read;
            mem_mem_write  <= ex_mem_write;
            mem_mem_size   <= ex_mem_size;
            mem_reg_write  <= ex_reg_write;
            mem_result_src <= ex_result_src;
        end
    end

endmodule

// ----------------------------------------------------------------------------
// MEM/WB Pipeline Register
// ----------------------------------------------------------------------------
module pipe_mem_wb (
    input  wire        clk,
    input  wire        rst_n,

    // Data inputs
    input  wire [31:0] mem_pc_plus4,
    input  wire [31:0] mem_alu_result,
    input  wire [31:0] mem_read_data,
    input  wire [4:0]  mem_rd_addr,

    // Control inputs
    input  wire        mem_reg_write,
    input  wire [1:0]  mem_result_src,

    // Data outputs
    output reg  [31:0] wb_pc_plus4,
    output reg  [31:0] wb_alu_result,
    output reg  [31:0] wb_read_data,
    output reg  [4:0]  wb_rd_addr,

    // Control outputs
    output reg         wb_reg_write,
    output reg  [1:0]  wb_result_src
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wb_pc_plus4   <= 32'b0;
            wb_alu_result <= 32'b0;
            wb_read_data  <= 32'b0;
            wb_rd_addr    <= 5'b0;
            wb_reg_write  <= 1'b0;
            wb_result_src <= 2'b0;
        end else begin
            wb_pc_plus4   <= mem_pc_plus4;
            wb_alu_result <= mem_alu_result;
            wb_read_data  <= mem_read_data;
            wb_rd_addr    <= mem_rd_addr;
            wb_reg_write  <= mem_reg_write;
            wb_result_src <= mem_result_src;
        end
    end

endmodule
