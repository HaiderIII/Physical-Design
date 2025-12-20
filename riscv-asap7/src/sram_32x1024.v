// ============================================================================
// Single-Port SRAM - 32-bit x 1024 words (4KB)
// ============================================================================
// Synthesizable behavioral model - will be mapped to ASAP7 SRAM macros
// or synthesized to flip-flops for smaller designs
// ============================================================================

module sram_32x1024 (
    input  wire        clk,
    input  wire        cs,      // Chip select (active high)
    input  wire        we,      // Write enable
    input  wire [3:0]  be,      // Byte enables
    input  wire [9:0]  addr,    // 10-bit address for 1024 words
    input  wire [31:0] din,     // Write data
    output reg  [31:0] dout     // Read data
);

    // Memory array
    reg [31:0] mem [0:1023];

    integer i;

    // Initialize memory to zero (for simulation)
    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            mem[i] = 32'b0;
        end
    end

    // Synchronous read/write
    always @(posedge clk) begin
        if (cs) begin
            if (we) begin
                // Byte-masked write
                if (be[0]) mem[addr][7:0]   <= din[7:0];
                if (be[1]) mem[addr][15:8]  <= din[15:8];
                if (be[2]) mem[addr][23:16] <= din[23:16];
                if (be[3]) mem[addr][31:24] <= din[31:24];
            end
            // Read (synchronous)
            dout <= mem[addr];
        end
    end

endmodule
