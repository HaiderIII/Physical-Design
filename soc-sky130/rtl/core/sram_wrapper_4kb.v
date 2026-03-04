// ============================================================================
// SRAM Wrapper - 32-bit x 1024 words (4KB) using sky130_sram_1rw1r_128x256_8
// ============================================================================
// Project: RISC-V Physical Design with SKY130 + SRAM Macros
//
// This wrapper adapts the 128-bit x 256 word SRAM macro to a 32-bit interface
//
// SRAM Macro specs (sky130_sram_1rw1r_128x256_8):
//   - DATA_WIDTH = 128 bits (4 x 32-bit words per row)
//   - ADDR_WIDTH = 8 bits (256 rows)
//   - Write mask = 16 bits (8-bit granularity)
//   - Total = 128 x 256 = 32,768 bits = 4 KB
//   - Ports: 1RW (read/write) + 1R (read-only)
//
// Wrapper interface:
//   - 32-bit data width
//   - 1024 word depth (10-bit address)
//   - Byte-write enable (4 bits)
// ============================================================================

module sram_wrapper_4kb (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        cs,       // Chip select (active high)
    input  wire        we,       // Write enable (active high)
    input  wire [3:0]  be,       // Byte enables
    input  wire [9:0]  addr,     // 10-bit address for 1024 x 32-bit words
    input  wire [31:0] din,      // Write data
    output wire [31:0] dout      // Read data
);

    // ========================================================================
    // Address decoding
    // ========================================================================
    // addr[9:2]  -> SRAM row address (256 rows)
    // addr[1:0]  -> Word select within 128-bit row (4 words per row)

    wire [7:0]  sram_addr;
    wire [1:0]  word_sel;

    assign sram_addr = addr[9:2];   // Upper 8 bits select SRAM row
    assign word_sel  = addr[1:0];   // Lower 2 bits select word within row

    // ========================================================================
    // Write mask generation
    // ========================================================================
    // SRAM has 16-bit write mask (8-bit granularity for 128 bits)
    // Map 4-bit byte-enable to correct position in 16-bit mask

    reg [15:0] wmask;

    always @(*) begin
        wmask = 16'h0000;  // Default: no write
        case (word_sel)
            2'b00: wmask = {12'b0, be};           // Word 0: bits [31:0]
            2'b01: wmask = {8'b0, be, 4'b0};      // Word 1: bits [63:32]
            2'b10: wmask = {4'b0, be, 8'b0};      // Word 2: bits [95:64]
            2'b11: wmask = {be, 12'b0};           // Word 3: bits [127:96]
        endcase
    end

    // ========================================================================
    // Write data positioning
    // ========================================================================
    // Replicate 32-bit data across all 4 positions in 128-bit bus

    wire [127:0] sram_din;
    assign sram_din = {din, din, din, din};

    // ========================================================================
    // SRAM control signals
    // ========================================================================
    // SRAM macro uses active-low signals (csb, web)

    wire        sram_csb0;
    wire        sram_web0;
    wire [15:0] sram_wmask0;

    assign sram_csb0   = ~cs;
    assign sram_web0   = ~we;
    assign sram_wmask0 = we ? wmask : 16'h0000;

    // ========================================================================
    // SRAM Macro Instance
    // ========================================================================

    wire [127:0] sram_dout;

    sky130_sram_1rw1r_128x256_8 u_sram (
        // Port 0: Read/Write
        .clk0   (clk),
        .csb0   (sram_csb0),
        .web0   (sram_web0),
        .wmask0 (sram_wmask0),
        .addr0  (sram_addr),
        .din0   (sram_din),
        .dout0  (sram_dout),

        // Port 1: Read-only (unused)
        .clk1   (clk),
        .csb1   (1'b1),         // Disabled (active low)
        .addr1  (8'b0),
        .dout1  ()              // Unconnected
    );

    // ========================================================================
    // Read data mux
    // ========================================================================
    // Register word_sel to match SRAM output timing (1 cycle latency)

    reg [1:0] word_sel_r;

    always @(posedge clk) begin
        if (!rst_n)
            word_sel_r <= 2'b0;
        else if (cs && !we)
            word_sel_r <= word_sel;
    end

    // Select correct 32-bit word from 128-bit output
    reg [31:0] dout_mux;

    always @(*) begin
        case (word_sel_r)
            2'b00: dout_mux = sram_dout[31:0];
            2'b01: dout_mux = sram_dout[63:32];
            2'b10: dout_mux = sram_dout[95:64];
            2'b11: dout_mux = sram_dout[127:96];
        endcase
    end

    assign dout = dout_mux;

endmodule
