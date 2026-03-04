// ============================================================================
// Timer with Wishbone B4 Slave Interface
// ============================================================================
// Project: RISC-V SoC - Hierarchical Physical Design (SKY130)
//
// 32-bit timer with compare match and prescaler.
// Generates interrupt on compare match or overflow.
//
// Register Map (byte offsets from base address):
//   0x00 : CTRL     [3:0]  (RW) - {overflow_irq_en, match_irq_en, auto_reload, enable}
//   0x04 : COUNT    [31:0] (RW) - Current counter value
//   0x08 : COMPARE  [31:0] (RW) - Compare match value
//   0x0C : STATUS   [1:0]  (R/W1C) - {overflow, match} (write 1 to clear)
//   0x10 : PRESCALER[15:0] (RW) - Prescaler divider (count_clk = clk / (prescaler+1))
// ============================================================================

module timer_wb (
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
    reg [3:0]  ctrl;        // {overflow_irq_en, match_irq_en, auto_reload, enable}
    reg [31:0] count;
    reg [31:0] compare;
    reg [1:0]  status;      // {overflow, match}
    reg [15:0] prescaler;

    wire enable          = ctrl[0];
    wire auto_reload     = ctrl[1];
    wire match_irq_en    = ctrl[2];
    wire overflow_irq_en = ctrl[3];

    // ========================================================================
    // Prescaler
    // ========================================================================
    reg [15:0] prescale_cnt;
    wire       tick;

    assign tick = (prescale_cnt == prescaler);

    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            prescale_cnt <= 16'd0;
        end else if (enable) begin
            if (tick)
                prescale_cnt <= 16'd0;
            else
                prescale_cnt <= prescale_cnt + 16'd1;
        end else begin
            prescale_cnt <= 16'd0;
        end
    end

    // ========================================================================
    // Counter logic
    // ========================================================================
    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            count  <= 32'd0;
            status <= 2'b00;
        end else begin
            // Write-1-to-clear for STATUS
            if (wb_valid && wb_we_i && wb_adr_i[4:2] == 3'd3) begin
                status <= status & ~wb_dat_i[1:0];
            end

            // Direct write to COUNT
            if (wb_valid && wb_we_i && wb_adr_i[4:2] == 3'd1) begin
                count <= wb_dat_i;
            end else if (enable && tick) begin
                if (count == compare) begin
                    status[0] <= 1'b1;  // Match flag
                    if (auto_reload)
                        count <= 32'd0;
                    else
                        count <= count + 32'd1;
                end else if (count == 32'hFFFF_FFFF) begin
                    status[1] <= 1'b1;  // Overflow flag
                    count <= 32'd0;
                end else begin
                    count <= count + 32'd1;
                end
            end
        end
    end

    // ========================================================================
    // Register write logic
    // ========================================================================
    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            ctrl      <= 4'b0000;
            compare   <= 32'hFFFF_FFFF;
            prescaler <= 16'd0;
        end else if (wb_valid && wb_we_i) begin
            case (wb_adr_i[4:2])
                3'd0: ctrl      <= wb_dat_i[3:0];
                3'd2: compare   <= wb_dat_i;
                3'd4: prescaler <= wb_dat_i[15:0];
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
            3'd0: wb_dat_o = {28'd0, ctrl};
            3'd1: wb_dat_o = count;
            3'd2: wb_dat_o = compare;
            3'd3: wb_dat_o = {30'd0, status};
            3'd4: wb_dat_o = {16'd0, prescaler};
            default: wb_dat_o = 32'd0;
        endcase
    end

    // ========================================================================
    // Interrupt
    // ========================================================================
    assign irq = (match_irq_en    & status[0]) |
                 (overflow_irq_en & status[1]);

endmodule
