// ============================================================================
// CPU Wishbone Wrapper - Adapts RISC-V core to Wishbone B4 master interface
// ============================================================================
// Project: RISC-V SoC - Hierarchical Physical Design (SKY130)
//
// This wrapper instantiates the RISC-V core and converts its native
// memory interface to Wishbone B4 classic bus protocol.
//
// Architecture:
//   - IMEM port: Direct connection (Harvard, not on bus)
//   - DMEM port: Converted to Wishbone B4 master
//
// Wishbone B4 Classic Cycle:
//   Master asserts CYC + STB + ADR + DAT + SEL + WE
//   Slave responds with ACK (+ DAT for reads)
//   Single-cycle ACK assumed for all slaves in this SoC
// ============================================================================

module cpu_wb_wrapper (
    input  wire        clk,
    input  wire        rst_n,

    // ---- Instruction Memory (direct, not on Wishbone bus) ----
    output wire [31:0] imem_addr,
    input  wire [31:0] imem_rdata,

    // ---- Wishbone B4 Master Interface (data bus) ----
    output wire [31:0] wb_adr_o,      // Address
    output wire [31:0] wb_dat_o,      // Write data
    input  wire [31:0] wb_dat_i,      // Read data
    output wire [3:0]  wb_sel_o,      // Byte select
    output wire        wb_we_o,       // Write enable
    output wire        wb_stb_o,      // Strobe (valid transfer)
    output wire        wb_cyc_o,      // Bus cycle
    input  wire        wb_ack_i       // Acknowledge
);

    // ========================================================================
    // Internal signals from riscv_core
    // ========================================================================
    wire [31:0] dmem_addr;
    wire [31:0] dmem_wdata;
    wire [3:0]  dmem_be;
    wire        dmem_we;
    wire        dmem_re;
    wire [31:0] dmem_rdata;

    // ========================================================================
    // RISC-V Core Instance
    // ========================================================================
    riscv_core u_riscv_core (
        .clk        (clk),
        .rst_n      (rst_n),
        .imem_addr  (imem_addr),
        .imem_rdata (imem_rdata),
        .dmem_addr  (dmem_addr),
        .dmem_wdata (dmem_wdata),
        .dmem_be    (dmem_be),
        .dmem_we    (dmem_we),
        .dmem_re    (dmem_re),
        .dmem_rdata (dmem_rdata)
    );

    // ========================================================================
    // Native DMEM interface -> Wishbone B4 master conversion
    // ========================================================================
    //
    // Mapping:
    //   dmem_addr   -> wb_adr_o  (pass-through, already word-aligned)
    //   dmem_wdata  -> wb_dat_o  (pass-through)
    //   dmem_be     -> wb_sel_o  (same semantics)
    //   dmem_we     -> wb_we_o   (pass-through)
    //   dmem_we|re  -> wb_stb_o  (strobe when any access)
    //   dmem_we|re  -> wb_cyc_o  (cycle active when any access)
    //   wb_dat_i    -> dmem_rdata (read data from bus)
    //   wb_ack_i    -> (not used for stalling in v1, single-cycle assumed)

    assign wb_adr_o = dmem_addr;
    assign wb_dat_o = dmem_wdata;
    assign wb_sel_o = dmem_be;
    assign wb_we_o  = dmem_we;
    assign wb_stb_o = dmem_we | dmem_re;
    assign wb_cyc_o = dmem_we | dmem_re;

    // Read data from Wishbone bus back to CPU
    assign dmem_rdata = wb_dat_i;

endmodule
