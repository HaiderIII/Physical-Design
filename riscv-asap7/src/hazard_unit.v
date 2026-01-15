// ============================================================================
// RISC-V Hazard Detection and Forwarding Unit
// ============================================================================
// Project: RISC-V Physical Design with SKY130 + SRAM Macros
// ============================================================================

`include "riscv_pkg.v"

module hazard_unit (
    // From ID stage
    input  wire [4:0]  id_rs1_addr,
    input  wire [4:0]  id_rs2_addr,

    // From EX stage
    input  wire [4:0]  ex_rd_addr,
    input  wire        ex_reg_write,
    input  wire        ex_mem_read,

    // From MEM stage
    input  wire [4:0]  mem_rd_addr,
    input  wire        mem_reg_write,

    // From WB stage
    input  wire [4:0]  wb_rd_addr,
    input  wire        wb_reg_write,

    // Branch/Jump signals
    input  wire        branch_taken,
    input  wire        jump,

    // Forwarding outputs
    output reg  [1:0]  forward_a,
    output reg  [1:0]  forward_b,

    // Stall and flush outputs
    output wire        stall_if,
    output wire        stall_id,
    output wire        flush_id,
    output wire        flush_ex
);

    // Load-use hazard detection
    wire load_use_hazard;
    assign load_use_hazard = ex_mem_read &&
                             ((ex_rd_addr == id_rs1_addr) ||
                              (ex_rd_addr == id_rs2_addr)) &&
                             (ex_rd_addr != 5'b0);

    // Control hazard (branch/jump)
    wire control_hazard;
    assign control_hazard = branch_taken || jump;

    // Stall signals
    assign stall_if = load_use_hazard;
    assign stall_id = load_use_hazard;

    // Flush signals
    assign flush_id = control_hazard;
    assign flush_ex = load_use_hazard || control_hazard;

    // Forwarding logic for operand A
    always @(*) begin
        if (ex_reg_write && (ex_rd_addr != 5'b0) &&
            (ex_rd_addr == id_rs1_addr)) begin
            forward_a = `FWD_MEM;  // Forward from MEM stage
        end else if (mem_reg_write && (mem_rd_addr != 5'b0) &&
                     (mem_rd_addr == id_rs1_addr)) begin
            forward_a = `FWD_WB;   // Forward from WB stage
        end else begin
            forward_a = `FWD_NONE;
        end
    end

    // Forwarding logic for operand B
    always @(*) begin
        if (ex_reg_write && (ex_rd_addr != 5'b0) &&
            (ex_rd_addr == id_rs2_addr)) begin
            forward_b = `FWD_MEM;
        end else if (mem_reg_write && (mem_rd_addr != 5'b0) &&
                     (mem_rd_addr == id_rs2_addr)) begin
            forward_b = `FWD_WB;
        end else begin
            forward_b = `FWD_NONE;
        end
    end

endmodule
