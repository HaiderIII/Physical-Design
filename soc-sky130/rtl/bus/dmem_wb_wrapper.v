// ============================================================================
// DMEM Wishbone Wrapper - SRAM with Wishbone B4 Slave Interface
// ============================================================================
// Project: RISC-V SoC - Hierarchical Physical Design (SKY130)
//
// Wraps the sram_wrapper_4kb with a Wishbone B4 slave interface.
// Provides 4KB of data memory accessible via the Wishbone bus.
//
// Address range: 0x0001_0000 - 0x0001_0FFF (4KB)
// ============================================================================

module dmem_wb_wrapper (
    // Wishbone B4 Slave Interface
    input  wire        wb_clk_i,
    input  wire        wb_rst_i,
    input  wire [31:0] wb_adr_i,
    input  wire [31:0] wb_dat_i,
    output wire [31:0] wb_dat_o,
    input  wire [3:0]  wb_sel_i,
    input  wire        wb_we_i,
    input  wire        wb_stb_i,
    input  wire        wb_cyc_i,
    output wire        wb_ack_o
);

    // ========================================================================
    // Wishbone handshake
    // ========================================================================
    // SRAM has 1-cycle read latency, so ACK is delayed by 1 cycle
    reg ack_r;
    assign wb_ack_o = ack_r;

    always @(posedge wb_clk_i) begin
        if (wb_rst_i)
            ack_r <= 1'b0;
        else
            ack_r <= wb_stb_i & wb_cyc_i & ~ack_r;
    end

    wire wb_valid = wb_stb_i & wb_cyc_i;

    // ========================================================================
    // SRAM Instance
    // ========================================================================
    sram_wrapper_4kb u_dmem_sram (
        .clk   (wb_clk_i),
        .rst_n (~wb_rst_i),
        .cs    (wb_valid),
        .we    (wb_we_i & wb_valid),
        .be    (wb_sel_i),
        .addr  (wb_adr_i[11:2]),    // Word address (1024 words)
        .din   (wb_dat_i),
        .dout  (wb_dat_o)
    );

endmodule
