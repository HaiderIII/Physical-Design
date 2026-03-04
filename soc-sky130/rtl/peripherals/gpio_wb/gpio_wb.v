// ============================================================================
// GPIO with Wishbone B4 Slave Interface
// ============================================================================
// Project: RISC-V SoC - Hierarchical Physical Design (SKY130)
//
// 32-bit GPIO controller with direction control and interrupt support.
//
// Register Map (byte offsets from base address):
//   0x00 : DATA_IN   [31:0] (R)  - Input pin values (synchronized)
//   0x04 : DATA_OUT  [31:0] (RW) - Output pin values
//   0x08 : DIR       [31:0] (RW) - Direction (0=input, 1=output)
//   0x0C : IRQ_EN    [31:0] (RW) - Interrupt enable per pin (rising edge)
//   0x10 : IRQ_STATUS[31:0] (R/W1C) - Interrupt status (write 1 to clear)
// ============================================================================

module gpio_wb (
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

    // GPIO external pins
    input  wire [31:0] gpio_in,
    output wire [31:0] gpio_out,
    output wire [31:0] gpio_oe,       // Output enable (active high)

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
    reg [31:0] data_out_reg;
    reg [31:0] dir_reg;
    reg [31:0] irq_en_reg;
    reg [31:0] irq_status_reg;

    // Input synchronizer (2-stage)
    reg [31:0] gpio_sync1;
    reg [31:0] gpio_sync2;
    reg [31:0] gpio_prev;

    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            gpio_sync1 <= 32'd0;
            gpio_sync2 <= 32'd0;
            gpio_prev  <= 32'd0;
        end else begin
            gpio_sync1 <= gpio_in;
            gpio_sync2 <= gpio_sync1;
            gpio_prev  <= gpio_sync2;
        end
    end

    // Output assignments
    assign gpio_out = data_out_reg;
    assign gpio_oe  = dir_reg;

    // ========================================================================
    // Rising edge detection for interrupts
    // ========================================================================
    wire [31:0] rising_edge = gpio_sync2 & ~gpio_prev;

    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            irq_status_reg <= 32'd0;
        end else begin
            // Set on rising edge (masked by irq_en)
            irq_status_reg <= irq_status_reg | (rising_edge & irq_en_reg);

            // Write-1-to-clear
            if (wb_valid && wb_we_i && wb_adr_i[4:2] == 3'd4) begin
                irq_status_reg <= (irq_status_reg | (rising_edge & irq_en_reg))
                                  & ~wb_dat_i;
            end
        end
    end

    assign irq = |irq_status_reg;

    // ========================================================================
    // Register write logic
    // ========================================================================
    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            data_out_reg <= 32'd0;
            dir_reg      <= 32'd0;   // All inputs by default
            irq_en_reg   <= 32'd0;
        end else if (wb_valid && wb_we_i) begin
            case (wb_adr_i[4:2])
                3'd1: data_out_reg <= wb_dat_i;
                3'd2: dir_reg      <= wb_dat_i;
                3'd3: irq_en_reg   <= wb_dat_i;
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
            3'd0: wb_dat_o = gpio_sync2;       // DATA_IN
            3'd1: wb_dat_o = data_out_reg;      // DATA_OUT
            3'd2: wb_dat_o = dir_reg;           // DIR
            3'd3: wb_dat_o = irq_en_reg;        // IRQ_EN
            3'd4: wb_dat_o = irq_status_reg;    // IRQ_STATUS
            default: wb_dat_o = 32'd0;
        endcase
    end

endmodule
