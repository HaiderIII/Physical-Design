// ============================================================================
// RISC-V SoC Top Level - RV32I Core + Memories
// ============================================================================
// This is the top-level module for synthesis and physical design
// Includes: CPU Core + Instruction Memory (4KB) + Data Memory (4KB)
// ============================================================================

module riscv_soc (
    input  wire        clk,
    input  wire        rst_n,

    // GPIO interface (optional external access)
    input  wire [31:0] gpio_in,
    output wire [31:0] gpio_out,

    // Debug interface
    output wire [31:0] debug_pc,
    output wire [31:0] debug_instr
);

    // ========================================================================
    // Internal signals
    // ========================================================================

    // Instruction memory interface
    wire [31:0] imem_addr;
    wire [31:0] imem_rdata;

    // Data memory interface
    wire [31:0] dmem_addr;
    wire [31:0] dmem_wdata;
    wire [3:0]  dmem_be;
    wire        dmem_we;
    wire        dmem_re;
    wire [31:0] dmem_rdata;

    // Memory mapped I/O
    wire        is_gpio_access;
    wire        is_dmem_access;

    // GPIO registers
    reg  [31:0] gpio_out_reg;
    reg  [31:0] gpio_in_reg;

    // ========================================================================
    // Address decoding
    // ========================================================================
    // Memory map:
    //   0x0000_0000 - 0x0000_0FFF : Instruction Memory (4KB)
    //   0x0001_0000 - 0x0001_0FFF : Data Memory (4KB)
    //   0x0002_0000 - 0x0002_0007 : GPIO (0x0: input, 0x4: output)
    // ========================================================================

    assign is_gpio_access = (dmem_addr[31:16] == 16'h0002);
    assign is_dmem_access = (dmem_addr[31:16] == 16'h0001) ||
                            (dmem_addr[31:16] == 16'h0000 && dmem_addr[15:12] != 4'h0);

    // ========================================================================
    // CPU Core
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
    // Instruction Memory (4KB - 1024 x 32-bit)
    // ========================================================================

    sram_32x1024 u_imem (
        .clk  (clk),
        .cs   (1'b1),
        .we   (1'b0),              // Read-only for instructions
        .be   (4'b1111),
        .addr (imem_addr[11:2]),   // Word address
        .din  (32'b0),
        .dout (imem_rdata)
    );

    // ========================================================================
    // Data Memory (4KB - 1024 x 32-bit)
    // ========================================================================

    wire [31:0] dmem_rdata_mem;

    sram_32x1024 u_dmem (
        .clk  (clk),
        .cs   (is_dmem_access),
        .we   (dmem_we && is_dmem_access),
        .be   (dmem_be),
        .addr (dmem_addr[11:2]),   // Word address
        .din  (dmem_wdata),
        .dout (dmem_rdata_mem)
    );

    // ========================================================================
    // GPIO Controller
    // ========================================================================

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            gpio_out_reg <= 32'b0;
            gpio_in_reg  <= 32'b0;
        end else begin
            gpio_in_reg <= gpio_in;
            if (dmem_we && is_gpio_access && dmem_addr[2]) begin
                gpio_out_reg <= dmem_wdata;
            end
        end
    end

    assign gpio_out = gpio_out_reg;

    // Read mux for data memory / GPIO
    assign dmem_rdata = is_gpio_access ?
                        (dmem_addr[2] ? gpio_out_reg : gpio_in_reg) :
                        dmem_rdata_mem;

    // ========================================================================
    // Debug outputs
    // ========================================================================

    assign debug_pc    = imem_addr;
    assign debug_instr = imem_rdata;

endmodule
