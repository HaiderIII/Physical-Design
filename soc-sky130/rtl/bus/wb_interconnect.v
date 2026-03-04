// ============================================================================
// Wishbone B4 Bus Interconnect - Shared Bus Topology
// ============================================================================
// Project: RISC-V SoC - Hierarchical Physical Design (SKY130)
//
// Single-master, multi-slave Wishbone B4 classic interconnect.
// Address decoder + read data multiplexer.
//
// Architecture:
//   1 Master (CPU data port) -> 5 Slaves via shared bus
//
// Memory Map:
//   Slave 0: 0x0001_0000 - 0x0001_0FFF  DMEM   (4KB SRAM)
//   Slave 1: 0x1000_0000 - 0x1000_00FF  UART
//   Slave 2: 0x1000_1000 - 0x1000_10FF  SPI
//   Slave 3: 0x1000_2000 - 0x1000_20FF  Timer
//   Slave 4: 0x1000_3000 - 0x1000_30FF  GPIO
//
// Address Decoding:
//   DMEM:  addr[31:16] == 16'h0001
//   UART:  addr[31:12] == 20'h1000_0
//   SPI:   addr[31:12] == 20'h1000_1
//   Timer: addr[31:12] == 20'h1000_2
//   GPIO:  addr[31:12] == 20'h1000_3
// ============================================================================

module wb_interconnect (
    input  wire        wb_clk_i,
    input  wire        wb_rst_i,

    // ---- Master Interface (from CPU) ----
    input  wire [31:0] m_wb_adr_i,
    input  wire [31:0] m_wb_dat_i,
    output wire [31:0] m_wb_dat_o,
    input  wire [3:0]  m_wb_sel_i,
    input  wire        m_wb_we_i,
    input  wire        m_wb_stb_i,
    input  wire        m_wb_cyc_i,
    output wire        m_wb_ack_o,

    // ---- Slave 0: DMEM ----
    output wire [31:0] s0_wb_adr_o,
    output wire [31:0] s0_wb_dat_o,
    input  wire [31:0] s0_wb_dat_i,
    output wire [3:0]  s0_wb_sel_o,
    output wire        s0_wb_we_o,
    output wire        s0_wb_stb_o,
    output wire        s0_wb_cyc_o,
    input  wire        s0_wb_ack_i,

    // ---- Slave 1: UART ----
    output wire [31:0] s1_wb_adr_o,
    output wire [31:0] s1_wb_dat_o,
    input  wire [31:0] s1_wb_dat_i,
    output wire [3:0]  s1_wb_sel_o,
    output wire        s1_wb_we_o,
    output wire        s1_wb_stb_o,
    output wire        s1_wb_cyc_o,
    input  wire        s1_wb_ack_i,

    // ---- Slave 2: SPI ----
    output wire [31:0] s2_wb_adr_o,
    output wire [31:0] s2_wb_dat_o,
    input  wire [31:0] s2_wb_dat_i,
    output wire [3:0]  s2_wb_sel_o,
    output wire        s2_wb_we_o,
    output wire        s2_wb_stb_o,
    output wire        s2_wb_cyc_o,
    input  wire        s2_wb_ack_i,

    // ---- Slave 3: Timer ----
    output wire [31:0] s3_wb_adr_o,
    output wire [31:0] s3_wb_dat_o,
    input  wire [31:0] s3_wb_dat_i,
    output wire [3:0]  s3_wb_sel_o,
    output wire        s3_wb_we_o,
    output wire        s3_wb_stb_o,
    output wire        s3_wb_cyc_o,
    input  wire        s3_wb_ack_i,

    // ---- Slave 4: GPIO ----
    output wire [31:0] s4_wb_adr_o,
    output wire [31:0] s4_wb_dat_o,
    input  wire [31:0] s4_wb_dat_i,
    output wire [3:0]  s4_wb_sel_o,
    output wire        s4_wb_we_o,
    output wire        s4_wb_stb_o,
    output wire        s4_wb_cyc_o,
    input  wire        s4_wb_ack_i
);

    // ========================================================================
    // Address decoding
    // ========================================================================
    wire sel_dmem  = (m_wb_adr_i[31:16] == 16'h0001);
    wire sel_uart  = (m_wb_adr_i[31:12] == 20'h10000);
    wire sel_spi   = (m_wb_adr_i[31:12] == 20'h10001);
    wire sel_timer = (m_wb_adr_i[31:12] == 20'h10002);
    wire sel_gpio  = (m_wb_adr_i[31:12] == 20'h10003);

    // ========================================================================
    // Address, data, select, write-enable broadcast (shared bus)
    // ========================================================================
    // All slaves see the same address/data/control - only STB is gated

    assign s0_wb_adr_o = m_wb_adr_i;
    assign s1_wb_adr_o = m_wb_adr_i;
    assign s2_wb_adr_o = m_wb_adr_i;
    assign s3_wb_adr_o = m_wb_adr_i;
    assign s4_wb_adr_o = m_wb_adr_i;

    assign s0_wb_dat_o = m_wb_dat_i;
    assign s1_wb_dat_o = m_wb_dat_i;
    assign s2_wb_dat_o = m_wb_dat_i;
    assign s3_wb_dat_o = m_wb_dat_i;
    assign s4_wb_dat_o = m_wb_dat_i;

    assign s0_wb_sel_o = m_wb_sel_i;
    assign s1_wb_sel_o = m_wb_sel_i;
    assign s2_wb_sel_o = m_wb_sel_i;
    assign s3_wb_sel_o = m_wb_sel_i;
    assign s4_wb_sel_o = m_wb_sel_i;

    assign s0_wb_we_o = m_wb_we_i;
    assign s1_wb_we_o = m_wb_we_i;
    assign s2_wb_we_o = m_wb_we_i;
    assign s3_wb_we_o = m_wb_we_i;
    assign s4_wb_we_o = m_wb_we_i;

    // ========================================================================
    // Strobe gating (only selected slave sees STB)
    // ========================================================================
    assign s0_wb_stb_o = m_wb_stb_i & sel_dmem;
    assign s1_wb_stb_o = m_wb_stb_i & sel_uart;
    assign s2_wb_stb_o = m_wb_stb_i & sel_spi;
    assign s3_wb_stb_o = m_wb_stb_i & sel_timer;
    assign s4_wb_stb_o = m_wb_stb_i & sel_gpio;

    assign s0_wb_cyc_o = m_wb_cyc_i & sel_dmem;
    assign s1_wb_cyc_o = m_wb_cyc_i & sel_uart;
    assign s2_wb_cyc_o = m_wb_cyc_i & sel_spi;
    assign s3_wb_cyc_o = m_wb_cyc_i & sel_timer;
    assign s4_wb_cyc_o = m_wb_cyc_i & sel_gpio;

    // ========================================================================
    // Read data multiplexer
    // ========================================================================
    reg [31:0] rdata_mux;

    always @(*) begin
        case (1'b1)
            sel_dmem:  rdata_mux = s0_wb_dat_i;
            sel_uart:  rdata_mux = s1_wb_dat_i;
            sel_spi:   rdata_mux = s2_wb_dat_i;
            sel_timer: rdata_mux = s3_wb_dat_i;
            sel_gpio:  rdata_mux = s4_wb_dat_i;
            default:   rdata_mux = 32'hDEAD_BEEF;  // Bus error pattern
        endcase
    end

    assign m_wb_dat_o = rdata_mux;

    // ========================================================================
    // ACK multiplexer
    // ========================================================================
    assign m_wb_ack_o = (sel_dmem  & s0_wb_ack_i) |
                        (sel_uart  & s1_wb_ack_i) |
                        (sel_spi   & s2_wb_ack_i) |
                        (sel_timer & s3_wb_ack_i) |
                        (sel_gpio  & s4_wb_ack_i);

endmodule
