// ============================================================================
// RISC-V RV32I Core - 5-Stage Pipeline
// ============================================================================
// Pipeline stages: IF -> ID -> EX -> MEM -> WB
// Features: Data forwarding, hazard detection, branch prediction (static)
// ============================================================================

`include "riscv_pkg.v"

module riscv_core (
    input  wire        clk,
    input  wire        rst_n,

    // Instruction memory interface
    output wire [31:0] imem_addr,
    input  wire [31:0] imem_rdata,

    // Data memory interface
    output wire [31:0] dmem_addr,
    output wire [31:0] dmem_wdata,
    output wire [3:0]  dmem_be,
    output wire        dmem_we,
    output wire        dmem_re,
    input  wire [31:0] dmem_rdata
);

    // ========================================================================
    // Wire declarations
    // ========================================================================

    // PC signals
    reg  [31:0] pc;
    wire [31:0] pc_next;
    wire [31:0] pc_plus4;
    wire [31:0] pc_branch;
    wire [31:0] pc_jump;

    // IF stage signals
    wire [31:0] if_instruction;

    // ID stage signals
    wire [31:0] id_pc;
    wire [31:0] id_pc_plus4;
    wire [31:0] id_instruction;
    wire [4:0]  id_rs1_addr;
    wire [4:0]  id_rs2_addr;
    wire [4:0]  id_rd_addr;
    wire [31:0] id_rs1_data;
    wire [31:0] id_rs2_data;
    wire [31:0] id_immediate;
    wire [3:0]  id_alu_op;
    wire        id_alu_src;
    wire        id_mem_read;
    wire        id_mem_write;
    wire [2:0]  id_mem_size;
    wire        id_reg_write;
    wire [1:0]  id_result_src;
    wire        id_branch;
    wire        id_jump;
    wire        id_jalr;
    wire        id_lui;
    wire        id_auipc;
    wire [2:0]  id_funct3;
    wire        id_illegal_instr;

    // EX stage signals
    wire [31:0] ex_pc;
    wire [31:0] ex_pc_plus4;
    wire [31:0] ex_rs1_data;
    wire [31:0] ex_rs2_data;
    wire [31:0] ex_immediate;
    wire [4:0]  ex_rs1_addr;
    wire [4:0]  ex_rs2_addr;
    wire [4:0]  ex_rd_addr;
    wire [3:0]  ex_alu_op;
    wire        ex_alu_src;
    wire        ex_mem_read;
    wire        ex_mem_write;
    wire [2:0]  ex_mem_size;
    wire        ex_reg_write;
    wire [1:0]  ex_result_src;
    wire        ex_branch;
    wire        ex_jump;
    wire        ex_jalr;
    wire        ex_lui;
    wire        ex_auipc;
    wire [2:0]  ex_funct3;

    wire [31:0] ex_alu_operand_a;
    wire [31:0] ex_alu_operand_b;
    wire [31:0] ex_alu_result;
    wire        ex_alu_zero;
    wire        ex_branch_taken;

    wire [31:0] ex_forward_rs1;
    wire [31:0] ex_forward_rs2;

    // MEM stage signals
    wire [31:0] mem_pc_plus4;
    wire [31:0] mem_alu_result;
    wire [31:0] mem_rs2_data;
    wire [4:0]  mem_rd_addr;
    wire        mem_mem_read;
    wire        mem_mem_write;
    wire [2:0]  mem_mem_size;
    wire        mem_reg_write;
    wire [1:0]  mem_result_src;
    wire [31:0] mem_read_data;

    // WB stage signals
    wire [31:0] wb_pc_plus4;
    wire [31:0] wb_alu_result;
    wire [31:0] wb_read_data;
    wire [4:0]  wb_rd_addr;
    wire        wb_reg_write;
    wire [1:0]  wb_result_src;
    reg  [31:0] wb_result;

    // Hazard signals
    wire [1:0]  forward_a;
    wire [1:0]  forward_b;
    wire        stall_if;
    wire        stall_id;
    wire        flush_id;
    wire        flush_ex;

    // ========================================================================
    // IF Stage - Instruction Fetch
    // ========================================================================

    assign pc_plus4  = pc + 32'd4;
    assign pc_branch = ex_pc + ex_immediate;
    assign pc_jump   = ex_jalr ? (ex_forward_rs1 + ex_immediate) & ~32'h1 :
                                 ex_pc + ex_immediate;

    // Next PC selection
    assign pc_next = (ex_branch_taken) ? pc_branch :
                     (ex_jump)         ? pc_jump   :
                                         pc_plus4;

    // PC register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc <= 32'h00000000;
        end else if (!stall_if) begin
            pc <= pc_next;
        end
    end

    assign imem_addr     = pc;
    assign if_instruction = imem_rdata;

    // ========================================================================
    // IF/ID Pipeline Register
    // ========================================================================

    pipe_if_id u_pipe_if_id (
        .clk            (clk),
        .rst_n          (rst_n),
        .stall          (stall_id),
        .flush          (flush_id),
        .if_pc          (pc),
        .if_pc_plus4    (pc_plus4),
        .if_instruction (if_instruction),
        .id_pc          (id_pc),
        .id_pc_plus4    (id_pc_plus4),
        .id_instruction (id_instruction)
    );

    // ========================================================================
    // ID Stage - Instruction Decode
    // ========================================================================

    decoder u_decoder (
        .instruction   (id_instruction),
        .rs1_addr      (id_rs1_addr),
        .rs2_addr      (id_rs2_addr),
        .rd_addr       (id_rd_addr),
        .immediate     (id_immediate),
        .alu_op        (id_alu_op),
        .alu_src       (id_alu_src),
        .mem_read      (id_mem_read),
        .mem_write     (id_mem_write),
        .mem_size      (id_mem_size),
        .reg_write     (id_reg_write),
        .result_src    (id_result_src),
        .branch        (id_branch),
        .jump          (id_jump),
        .jalr          (id_jalr),
        .lui           (id_lui),
        .auipc         (id_auipc),
        .funct3        (id_funct3),
        .illegal_instr (id_illegal_instr)
    );

    register_file u_register_file (
        .clk      (clk),
        .rst_n    (rst_n),
        .rs1_addr (id_rs1_addr),
        .rs2_addr (id_rs2_addr),
        .rs1_data (id_rs1_data),
        .rs2_data (id_rs2_data),
        .wr_en    (wb_reg_write),
        .rd_addr  (wb_rd_addr),
        .rd_data  (wb_result)
    );

    // ========================================================================
    // ID/EX Pipeline Register
    // ========================================================================

    pipe_id_ex u_pipe_id_ex (
        .clk           (clk),
        .rst_n         (rst_n),
        .flush         (flush_ex),
        .id_pc         (id_pc),
        .id_pc_plus4   (id_pc_plus4),
        .id_rs1_data   (id_rs1_data),
        .id_rs2_data   (id_rs2_data),
        .id_immediate  (id_immediate),
        .id_rs1_addr   (id_rs1_addr),
        .id_rs2_addr   (id_rs2_addr),
        .id_rd_addr    (id_rd_addr),
        .id_alu_op     (id_alu_op),
        .id_alu_src    (id_alu_src),
        .id_mem_read   (id_mem_read),
        .id_mem_write  (id_mem_write),
        .id_mem_size   (id_mem_size),
        .id_reg_write  (id_reg_write),
        .id_result_src (id_result_src),
        .id_branch     (id_branch),
        .id_jump       (id_jump),
        .id_jalr       (id_jalr),
        .id_lui        (id_lui),
        .id_auipc      (id_auipc),
        .id_funct3     (id_funct3),
        .ex_pc         (ex_pc),
        .ex_pc_plus4   (ex_pc_plus4),
        .ex_rs1_data   (ex_rs1_data),
        .ex_rs2_data   (ex_rs2_data),
        .ex_immediate  (ex_immediate),
        .ex_rs1_addr   (ex_rs1_addr),
        .ex_rs2_addr   (ex_rs2_addr),
        .ex_rd_addr    (ex_rd_addr),
        .ex_alu_op     (ex_alu_op),
        .ex_alu_src    (ex_alu_src),
        .ex_mem_read   (ex_mem_read),
        .ex_mem_write  (ex_mem_write),
        .ex_mem_size   (ex_mem_size),
        .ex_reg_write  (ex_reg_write),
        .ex_result_src (ex_result_src),
        .ex_branch     (ex_branch),
        .ex_jump       (ex_jump),
        .ex_jalr       (ex_jalr),
        .ex_lui        (ex_lui),
        .ex_auipc      (ex_auipc),
        .ex_funct3     (ex_funct3)
    );

    // ========================================================================
    // EX Stage - Execute
    // ========================================================================

    // Forwarding muxes
    assign ex_forward_rs1 = (forward_a == `FWD_MEM) ? mem_alu_result :
                            (forward_a == `FWD_WB)  ? wb_result      :
                                                      ex_rs1_data;

    assign ex_forward_rs2 = (forward_b == `FWD_MEM) ? mem_alu_result :
                            (forward_b == `FWD_WB)  ? wb_result      :
                                                      ex_rs2_data;

    // ALU operand selection
    assign ex_alu_operand_a = ex_auipc ? ex_pc :
                              ex_lui   ? 32'b0 :
                                         ex_forward_rs1;

    assign ex_alu_operand_b = ex_alu_src ? ex_immediate : ex_forward_rs2;

    alu u_alu (
        .operand_a (ex_alu_operand_a),
        .operand_b (ex_alu_operand_b),
        .alu_op    (ex_alu_op),
        .result    (ex_alu_result),
        .zero      (ex_alu_zero)
    );

    branch_unit u_branch_unit (
        .rs1_data     (ex_forward_rs1),
        .rs2_data     (ex_forward_rs2),
        .funct3       (ex_funct3),
        .branch       (ex_branch),
        .branch_taken (ex_branch_taken)
    );

    // ========================================================================
    // EX/MEM Pipeline Register
    // ========================================================================

    pipe_ex_mem u_pipe_ex_mem (
        .clk            (clk),
        .rst_n          (rst_n),
        .ex_pc_plus4    (ex_pc_plus4),
        .ex_alu_result  (ex_alu_result),
        .ex_rs2_data    (ex_forward_rs2),
        .ex_rd_addr     (ex_rd_addr),
        .ex_mem_read    (ex_mem_read),
        .ex_mem_write   (ex_mem_write),
        .ex_mem_size    (ex_mem_size),
        .ex_reg_write   (ex_reg_write),
        .ex_result_src  (ex_result_src),
        .mem_pc_plus4   (mem_pc_plus4),
        .mem_alu_result (mem_alu_result),
        .mem_rs2_data   (mem_rs2_data),
        .mem_rd_addr    (mem_rd_addr),
        .mem_mem_read   (mem_mem_read),
        .mem_mem_write  (mem_mem_write),
        .mem_mem_size   (mem_mem_size),
        .mem_reg_write  (mem_reg_write),
        .mem_result_src (mem_result_src)
    );

    // ========================================================================
    // MEM Stage - Memory Access
    // ========================================================================

    memory_controller u_memory_controller (
        .clk        (clk),
        .rst_n      (rst_n),
        .addr       (mem_alu_result),
        .write_data (mem_rs2_data),
        .mem_size   (mem_mem_size),
        .mem_read   (mem_mem_read),
        .mem_write  (mem_mem_write),
        .read_data  (mem_read_data),
        .mem_addr   (dmem_addr),
        .mem_wdata  (dmem_wdata),
        .mem_be     (dmem_be),
        .mem_we     (dmem_we),
        .mem_re     (dmem_re),
        .mem_rdata  (dmem_rdata)
    );

    // ========================================================================
    // MEM/WB Pipeline Register
    // ========================================================================

    pipe_mem_wb u_pipe_mem_wb (
        .clk            (clk),
        .rst_n          (rst_n),
        .mem_pc_plus4   (mem_pc_plus4),
        .mem_alu_result (mem_alu_result),
        .mem_read_data  (mem_read_data),
        .mem_rd_addr    (mem_rd_addr),
        .mem_reg_write  (mem_reg_write),
        .mem_result_src (mem_result_src),
        .wb_pc_plus4    (wb_pc_plus4),
        .wb_alu_result  (wb_alu_result),
        .wb_read_data   (wb_read_data),
        .wb_rd_addr     (wb_rd_addr),
        .wb_reg_write   (wb_reg_write),
        .wb_result_src  (wb_result_src)
    );

    // ========================================================================
    // WB Stage - Write Back
    // ========================================================================

    always @(*) begin
        case (wb_result_src)
            2'b00:   wb_result = wb_alu_result;  // ALU result
            2'b01:   wb_result = wb_read_data;   // Memory data
            2'b10:   wb_result = wb_pc_plus4;    // PC+4 (for JAL/JALR)
            default: wb_result = wb_alu_result;
        endcase
    end

    // ========================================================================
    // Hazard Detection Unit
    // ========================================================================

    hazard_unit u_hazard_unit (
        .id_rs1_addr   (ex_rs1_addr),
        .id_rs2_addr   (ex_rs2_addr),
        .ex_rd_addr    (mem_rd_addr),
        .ex_reg_write  (mem_reg_write),
        .ex_mem_read   (ex_mem_read),
        .mem_rd_addr   (wb_rd_addr),
        .mem_reg_write (wb_reg_write),
        .wb_rd_addr    (5'b0),
        .wb_reg_write  (1'b0),
        .branch_taken  (ex_branch_taken),
        .jump          (ex_jump),
        .forward_a     (forward_a),
        .forward_b     (forward_b),
        .stall_if      (stall_if),
        .stall_id      (stall_id),
        .flush_id      (flush_id),
        .flush_ex      (flush_ex)
    );

endmodule
