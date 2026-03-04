// ============================================================================
// UART with Wishbone B4 Slave Interface
// ============================================================================
// Project: RISC-V SoC - Hierarchical Physical Design (SKY130)
//
// Simple UART transmitter/receiver with configurable baud rate.
// Wishbone B4 classic slave interface.
//
// Register Map (byte offsets from base address):
//   0x00 : TX_DATA  [7:0]  (W)  - Write byte to transmit
//   0x04 : RX_DATA  [7:0]  (R)  - Read received byte
//   0x08 : STATUS   [2:0]  (R)  - {rx_overrun, rx_valid, tx_busy}
//   0x0C : CTRL     [1:0]  (RW) - {rx_irq_en, tx_irq_en}
//   0x10 : DIVISOR  [15:0] (RW) - Baud rate divisor (clk_freq / baud - 1)
//
// Baud rate: baud = clk_freq / (divisor + 1)
//   Example: 100 MHz / (868) = 115200 baud -> divisor = 867
// ============================================================================

module uart_wb (
    // Wishbone B4 Slave Interface
    input  wire        wb_clk_i,
    input  wire        wb_rst_i,      // Active high (Wishbone convention)
    input  wire [31:0] wb_adr_i,
    input  wire [31:0] wb_dat_i,
    output reg  [31:0] wb_dat_o,
    input  wire [3:0]  wb_sel_i,
    input  wire        wb_we_i,
    input  wire        wb_stb_i,
    input  wire        wb_cyc_i,
    output wire        wb_ack_o,

    // UART external pins
    output wire        uart_tx,
    input  wire        uart_rx,

    // Interrupt output
    output wire        irq
);

    // ========================================================================
    // Wishbone handshake
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
    reg [15:0] divisor;
    reg [1:0]  ctrl;
    reg [7:0]  rx_data_reg;
    reg        rx_valid;
    reg        rx_overrun;

    // ========================================================================
    // TX logic
    // ========================================================================
    reg [7:0]  tx_shift;
    reg [3:0]  tx_bit_cnt;   // 0=idle, 1=start, 2-9=data, 10=stop
    reg [15:0] tx_clk_cnt;
    reg        tx_busy;
    reg        tx_out;

    assign uart_tx = tx_out;

    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            tx_out     <= 1'b1;   // Idle high
            tx_busy    <= 1'b0;
            tx_bit_cnt <= 4'd0;
            tx_clk_cnt <= 16'd0;
            tx_shift   <= 8'd0;
        end else if (!tx_busy) begin
            // Load new byte to transmit
            if (wb_valid && wb_we_i && wb_adr_i[4:2] == 3'd0) begin
                tx_shift   <= wb_dat_i[7:0];
                tx_busy    <= 1'b1;
                tx_bit_cnt <= 4'd0;
                tx_clk_cnt <= 16'd0;
                tx_out     <= 1'b0;   // Start bit
            end
        end else begin
            if (tx_clk_cnt == divisor) begin
                tx_clk_cnt <= 16'd0;
                tx_bit_cnt <= tx_bit_cnt + 4'd1;
                case (tx_bit_cnt)
                    4'd0: tx_out <= tx_shift[0]; // Bit 0
                    4'd1: tx_out <= tx_shift[1];
                    4'd2: tx_out <= tx_shift[2];
                    4'd3: tx_out <= tx_shift[3];
                    4'd4: tx_out <= tx_shift[4];
                    4'd5: tx_out <= tx_shift[5];
                    4'd6: tx_out <= tx_shift[6];
                    4'd7: tx_out <= tx_shift[7]; // Bit 7
                    4'd8: begin
                        tx_out  <= 1'b1;         // Stop bit
                    end
                    4'd9: begin
                        tx_busy <= 1'b0;         // Done
                        tx_out  <= 1'b1;
                    end
                    default: begin
                        tx_busy <= 1'b0;
                        tx_out  <= 1'b1;
                    end
                endcase
            end else begin
                tx_clk_cnt <= tx_clk_cnt + 16'd1;
            end
        end
    end

    // ========================================================================
    // RX logic
    // ========================================================================
    reg [7:0]  rx_shift;
    reg [3:0]  rx_bit_cnt;
    reg [15:0] rx_clk_cnt;
    reg        rx_active;
    reg [2:0]  rx_sync;       // Metastability synchronizer

    always @(posedge wb_clk_i) begin
        if (wb_rst_i)
            rx_sync <= 3'b111;
        else
            rx_sync <= {rx_sync[1:0], uart_rx};
    end

    wire rx_pin = rx_sync[2];

    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            rx_active   <= 1'b0;
            rx_bit_cnt  <= 4'd0;
            rx_clk_cnt  <= 16'd0;
            rx_shift    <= 8'd0;
            rx_data_reg <= 8'd0;
            rx_valid    <= 1'b0;
            rx_overrun  <= 1'b0;
        end else begin
            // Clear rx_valid on read of RX_DATA register
            if (wb_valid && !wb_we_i && wb_adr_i[4:2] == 3'd1) begin
                rx_valid   <= 1'b0;
                rx_overrun <= 1'b0;
            end

            if (!rx_active) begin
                // Detect start bit (falling edge)
                if (!rx_pin) begin
                    rx_active  <= 1'b1;
                    rx_clk_cnt <= {1'b0, divisor[15:1]}; // Sample at mid-bit
                    rx_bit_cnt <= 4'd0;
                end
            end else begin
                if (rx_clk_cnt == divisor) begin
                    rx_clk_cnt <= 16'd0;
                    rx_bit_cnt <= rx_bit_cnt + 4'd1;
                    if (rx_bit_cnt < 4'd8) begin
                        rx_shift <= {rx_pin, rx_shift[7:1]};
                    end else begin
                        // Stop bit
                        if (rx_pin) begin // Valid stop bit
                            rx_data_reg <= rx_shift;
                            if (rx_valid)
                                rx_overrun <= 1'b1;
                            rx_valid <= 1'b1;
                        end
                        rx_active <= 1'b0;
                    end
                end else begin
                    rx_clk_cnt <= rx_clk_cnt + 16'd1;
                end
            end
        end
    end

    // ========================================================================
    // Register write logic
    // ========================================================================
    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            divisor <= 16'd867;    // Default: 115200 baud @ 100 MHz
            ctrl    <= 2'b00;
        end else if (wb_valid && wb_we_i) begin
            case (wb_adr_i[4:2])
                3'd3: ctrl    <= wb_dat_i[1:0];     // CTRL
                3'd4: divisor <= wb_dat_i[15:0];     // DIVISOR
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
            3'd0: wb_dat_o = {24'd0, 8'd0};                        // TX_DATA (write-only)
            3'd1: wb_dat_o = {24'd0, rx_data_reg};                  // RX_DATA
            3'd2: wb_dat_o = {29'd0, rx_overrun, rx_valid, tx_busy}; // STATUS
            3'd3: wb_dat_o = {30'd0, ctrl};                          // CTRL
            3'd4: wb_dat_o = {16'd0, divisor};                       // DIVISOR
            default: wb_dat_o = 32'd0;
        endcase
    end

    // ========================================================================
    // Interrupt
    // ========================================================================
    assign irq = (ctrl[0] & ~tx_busy) |   // TX done interrupt
                 (ctrl[1] & rx_valid);     // RX data ready interrupt

endmodule
