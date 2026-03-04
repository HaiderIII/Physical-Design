// ============================================================================
// SPI Master with Wishbone B4 Slave Interface
// ============================================================================
// Project: RISC-V SoC - Hierarchical Physical Design (SKY130)
//
// Simple SPI master controller. Supports CPOL/CPHA configuration.
// 8-bit transfers, configurable clock divider.
//
// Register Map (byte offsets from base address):
//   0x00 : TX_DATA  [7:0]  (W)  - Write byte to transmit (starts transfer)
//   0x04 : RX_DATA  [7:0]  (R)  - Read received byte
//   0x08 : STATUS   [0:0]  (R)  - {busy}
//   0x0C : CTRL     [3:0]  (RW) - {cs_manual, cpol, cpha, enable}
//   0x10 : DIVIDER  [7:0]  (RW) - Clock divider (sclk = clk / (2*(div+1)))
//   0x14 : CS       [0:0]  (RW) - Chip select output (active low)
//
// SPI clock: sclk_freq = clk_freq / (2 * (divider + 1))
//   Example: 100 MHz / (2 * 50) = 1 MHz -> divider = 49
// ============================================================================

module spi_wb (
    // Wishbone B4 Slave Interface
    input  wire        wb_clk_i,
    input  wire        wb_rst_i,
    input  wire [31:0] wb_adr_i,
    input  wire [31:0] wb_dat_i,
    output reg  [31:0] wb_dat_o,
    input  wire [3:0]  wb_sel_i,
    input  wire        wb_we_i,
    input  wire        wb_stb_i,
    input  wire        wb_cyc_i,
    output wire        wb_ack_o,

    // SPI external pins
    output wire        spi_sclk,
    output wire        spi_mosi,
    input  wire        spi_miso,
    output wire        spi_cs_n,

    // Interrupt output
    output wire        irq
);

    // ========================================================================
    // Wishbone handshake (single-cycle ACK)
    // ========================================================================
    reg ack_r;
    assign wb_ack_o = ack_r;

    always @(posedge wb_clk_i) begin
        if (wb_rst_i)
            ack_r <= 1'b0;
        else
            ack_r <= wb_stb_i & wb_cyc_i & ~ack_r;
    end

    wire wb_valid = wb_stb_i & wb_cyc_i & ~ack_r;

    // ========================================================================
    // Registers
    // ========================================================================
    reg [7:0]  divider;
    reg [3:0]  ctrl;       // {cs_manual, cpol, cpha, enable}
    reg        cs_reg;
    reg [7:0]  rx_data_reg;

    wire enable    = ctrl[0];
    wire cpha      = ctrl[1];
    wire cpol      = ctrl[2];
    wire cs_manual = ctrl[3];

    // ========================================================================
    // SPI master state machine
    // ========================================================================
    reg [7:0]  tx_shift;
    reg [7:0]  rx_shift;
    reg [2:0]  bit_cnt;
    reg [7:0]  clk_cnt;
    reg        busy;
    reg        sclk_reg;
    reg        sclk_edge;  // 0 = leading edge coming, 1 = trailing edge coming

    assign spi_sclk = sclk_reg;
    assign spi_mosi = tx_shift[7];  // MSB first
    assign spi_cs_n = cs_manual ? cs_reg : ~busy;

    // Transfer done pulse
    reg busy_prev;
    always @(posedge wb_clk_i) begin
        if (wb_rst_i)
            busy_prev <= 1'b0;
        else
            busy_prev <= busy;
    end
    wire transfer_done = busy_prev & ~busy;

    assign irq = transfer_done;

    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            tx_shift    <= 8'd0;
            rx_shift    <= 8'd0;
            rx_data_reg <= 8'd0;
            bit_cnt     <= 3'd0;
            clk_cnt     <= 8'd0;
            busy        <= 1'b0;
            sclk_reg    <= 1'b0;
            sclk_edge   <= 1'b0;
        end else begin
            sclk_reg <= cpol;  // Default idle state

            if (!busy) begin
                // Start new transfer on TX_DATA write
                if (wb_valid && wb_we_i && wb_adr_i[4:2] == 3'd0 && enable) begin
                    tx_shift  <= wb_dat_i[7:0];
                    bit_cnt   <= 3'd0;
                    clk_cnt   <= 8'd0;
                    busy      <= 1'b1;
                    sclk_edge <= 1'b0;
                    sclk_reg  <= cpol;
                end
            end else begin
                if (clk_cnt == divider) begin
                    clk_cnt <= 8'd0;

                    if (!sclk_edge) begin
                        // Leading edge
                        sclk_reg  <= ~cpol;
                        sclk_edge <= 1'b1;
                        if (cpha) begin
                            // CPHA=1: shift out on leading edge
                            if (bit_cnt > 0)
                                tx_shift <= {tx_shift[6:0], 1'b0};
                        end else begin
                            // CPHA=0: sample on leading edge
                            rx_shift <= {rx_shift[6:0], spi_miso};
                        end
                    end else begin
                        // Trailing edge
                        sclk_reg  <= cpol;
                        sclk_edge <= 1'b0;
                        if (cpha) begin
                            // CPHA=1: sample on trailing edge
                            rx_shift <= {rx_shift[6:0], spi_miso};
                        end else begin
                            // CPHA=0: shift out on trailing edge
                            tx_shift <= {tx_shift[6:0], 1'b0};
                        end

                        bit_cnt <= bit_cnt + 3'd1;
                        if (bit_cnt == 3'd7) begin
                            busy        <= 1'b0;
                            rx_data_reg <= cpha ?
                                {rx_shift[6:0], spi_miso} : rx_shift;
                        end
                    end
                end else begin
                    clk_cnt  <= clk_cnt + 8'd1;
                    sclk_reg <= busy ? (sclk_edge ? ~cpol : cpol) : cpol;
                end
            end
        end
    end

    // ========================================================================
    // Register write logic
    // ========================================================================
    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            ctrl    <= 4'b0001;   // Enable by default
            divider <= 8'd49;     // 1 MHz SPI @ 100 MHz sys clock
            cs_reg  <= 1'b1;      // CS deasserted (active low)
        end else if (wb_valid && wb_we_i) begin
            case (wb_adr_i[4:2])
                3'd3: ctrl    <= wb_dat_i[3:0];
                3'd4: divider <= wb_dat_i[7:0];
                3'd5: cs_reg  <= wb_dat_i[0];
                default: ;
            endcase
        end
    end

    // ========================================================================
    // Register read mux
    // ========================================================================
    always @(*) begin
        wb_dat_o = 32'd0;
        case (wb_adr_i[4:2])
            3'd0: wb_dat_o = 32'd0;                   // TX_DATA (write-only)
            3'd1: wb_dat_o = {24'd0, rx_data_reg};     // RX_DATA
            3'd2: wb_dat_o = {31'd0, busy};            // STATUS
            3'd3: wb_dat_o = {28'd0, ctrl};             // CTRL
            3'd4: wb_dat_o = {24'd0, divider};          // DIVIDER
            3'd5: wb_dat_o = {31'd0, cs_reg};           // CS
            default: wb_dat_o = 32'd0;
        endcase
    end

endmodule
