// ============================================================================
// SoC Top-Level - RISC-V SoC with Wishbone Bus (SKY130)
// ============================================================================
// Project: RISC-V SoC - Hierarchical Physical Design (SKY130)
// Target: SKY130 (130nm) @ 100 MHz
//
// Architecture:
//   - RISC-V RV32I 5-stage pipeline CPU
//   - Harvard architecture: dedicated IMEM port + Wishbone data bus
//   - Wishbone B4 shared bus with 5 slaves
//   - 2x 4KB SRAM (IMEM + DMEM) using OpenRAM macros
//   - Peripherals: UART, SPI, Timer, GPIO
//
// Memory Map:
//   0x0000_0000 - 0x0000_0FFF : IMEM (4KB SRAM, direct port)
//   0x0001_0000 - 0x0001_0FFF : DMEM (4KB SRAM, via Wishbone)
//   0x1000_0000 - 0x1000_00FF : UART
//   0x1000_1000 - 0x1000_10FF : SPI
//   0x1000_2000 - 0x1000_20FF : Timer
//   0x1000_3000 - 0x1000_30FF : GPIO
//
// Block Hierarchy (for hierarchical PD):
//   soc_top
//   ├── u_cpu          (cpu_wb_wrapper)    -> Block: CPU
//   ├── u_imem         (sram_wrapper_4kb)  -> Macro: SRAM
//   ├── u_wb_bus       (wb_interconnect)   -> Block: BUS
//   ├── u_dmem         (dmem_wb_wrapper)   -> Block: DMEM (contains SRAM macro)
//   ├── u_uart         (uart_wb)           -> Block: UART
//   ├── u_spi          (spi_wb)            -> Block: SPI
//   ├── u_timer        (timer_wb)          -> Block: TIMER
//   └── u_gpio         (gpio_wb)           -> Block: GPIO
// ============================================================================

module soc_top (
    input  wire        clk,
    input  wire        rst_n,

    // UART
    output wire        uart_tx,
    input  wire        uart_rx,

    // SPI
    output wire        spi_sclk,
    output wire        spi_mosi,
    input  wire        spi_miso,
    output wire        spi_cs_n,

    // GPIO
    input  wire [31:0] gpio_in,
    output wire [31:0] gpio_out,
    output wire [31:0] gpio_oe,

    // Debug
    output wire [31:0] debug_pc,
    output wire [31:0] debug_instr,

    // Interrupts (active high, directly exposed for now)
    output wire        irq_uart,
    output wire        irq_spi,
    output wire        irq_timer,
    output wire        irq_gpio
);

    // ========================================================================
    // Reset polarity conversion (SoC uses active-low, Wishbone uses active-high)
    // ========================================================================
    wire wb_rst = ~rst_n;

    // ========================================================================
    // CPU <-> IMEM direct connection (Harvard architecture)
    // ========================================================================
    wire [31:0] imem_addr;
    wire [31:0] imem_rdata;

    // ========================================================================
    // CPU Wishbone master signals (data bus)
    // ========================================================================
    wire [31:0] cpu_wb_adr;
    wire [31:0] cpu_wb_dat_w;   // CPU write data
    wire [31:0] cpu_wb_dat_r;   // CPU read data
    wire [3:0]  cpu_wb_sel;
    wire        cpu_wb_we;
    wire        cpu_wb_stb;
    wire        cpu_wb_cyc;
    wire        cpu_wb_ack;

    // ========================================================================
    // Slave Wishbone signals
    // ========================================================================

    // Slave 0: DMEM
    wire [31:0] dmem_wb_adr,  dmem_wb_dat_w, dmem_wb_dat_r;
    wire [3:0]  dmem_wb_sel;
    wire        dmem_wb_we,   dmem_wb_stb,   dmem_wb_cyc,  dmem_wb_ack;

    // Slave 1: UART
    wire [31:0] uart_wb_adr,  uart_wb_dat_w, uart_wb_dat_r;
    wire [3:0]  uart_wb_sel;
    wire        uart_wb_we,   uart_wb_stb,   uart_wb_cyc,  uart_wb_ack;

    // Slave 2: SPI
    wire [31:0] spi_wb_adr,   spi_wb_dat_w,  spi_wb_dat_r;
    wire [3:0]  spi_wb_sel;
    wire        spi_wb_we,    spi_wb_stb,    spi_wb_cyc,   spi_wb_ack;

    // Slave 3: Timer
    wire [31:0] timer_wb_adr, timer_wb_dat_w, timer_wb_dat_r;
    wire [3:0]  timer_wb_sel;
    wire        timer_wb_we,  timer_wb_stb,  timer_wb_cyc,  timer_wb_ack;

    // Slave 4: GPIO
    wire [31:0] gpio_wb_adr,  gpio_wb_dat_w, gpio_wb_dat_r;
    wire [3:0]  gpio_wb_sel;
    wire        gpio_wb_we,   gpio_wb_stb,   gpio_wb_cyc,   gpio_wb_ack;

    // ========================================================================
    // CPU + Wishbone Master Wrapper
    // ========================================================================

    cpu_wb_wrapper u_cpu (
        .clk        (clk),
        .rst_n      (rst_n),
        // IMEM direct port
        .imem_addr  (imem_addr),
        .imem_rdata (imem_rdata),
        // Wishbone master (data bus)
        .wb_adr_o   (cpu_wb_adr),
        .wb_dat_o   (cpu_wb_dat_w),
        .wb_dat_i   (cpu_wb_dat_r),
        .wb_sel_o   (cpu_wb_sel),
        .wb_we_o    (cpu_wb_we),
        .wb_stb_o   (cpu_wb_stb),
        .wb_cyc_o   (cpu_wb_cyc),
        .wb_ack_i   (cpu_wb_ack)
    );

    // ========================================================================
    // Instruction Memory (4KB SRAM - direct connection, not on bus)
    // ========================================================================

    sram_wrapper_4kb u_imem (
        .clk   (clk),
        .rst_n (rst_n),
        .cs    (1'b1),
        .we    (1'b0),              // Read-only
        .be    (4'b1111),
        .addr  (imem_addr[11:2]),   // Word address
        .din   (32'b0),
        .dout  (imem_rdata)
    );

    // ========================================================================
    // Wishbone Bus Interconnect
    // ========================================================================

    wb_interconnect u_wb_bus (
        .wb_clk_i    (clk),
        .wb_rst_i    (wb_rst),

        // Master (CPU)
        .m_wb_adr_i  (cpu_wb_adr),
        .m_wb_dat_i  (cpu_wb_dat_w),
        .m_wb_dat_o  (cpu_wb_dat_r),
        .m_wb_sel_i  (cpu_wb_sel),
        .m_wb_we_i   (cpu_wb_we),
        .m_wb_stb_i  (cpu_wb_stb),
        .m_wb_cyc_i  (cpu_wb_cyc),
        .m_wb_ack_o  (cpu_wb_ack),

        // Slave 0: DMEM
        .s0_wb_adr_o (dmem_wb_adr),
        .s0_wb_dat_o (dmem_wb_dat_w),
        .s0_wb_dat_i (dmem_wb_dat_r),
        .s0_wb_sel_o (dmem_wb_sel),
        .s0_wb_we_o  (dmem_wb_we),
        .s0_wb_stb_o (dmem_wb_stb),
        .s0_wb_cyc_o (dmem_wb_cyc),
        .s0_wb_ack_i (dmem_wb_ack),

        // Slave 1: UART
        .s1_wb_adr_o (uart_wb_adr),
        .s1_wb_dat_o (uart_wb_dat_w),
        .s1_wb_dat_i (uart_wb_dat_r),
        .s1_wb_sel_o (uart_wb_sel),
        .s1_wb_we_o  (uart_wb_we),
        .s1_wb_stb_o (uart_wb_stb),
        .s1_wb_cyc_o (uart_wb_cyc),
        .s1_wb_ack_i (uart_wb_ack),

        // Slave 2: SPI
        .s2_wb_adr_o (spi_wb_adr),
        .s2_wb_dat_o (spi_wb_dat_w),
        .s2_wb_dat_i (spi_wb_dat_r),
        .s2_wb_sel_o (spi_wb_sel),
        .s2_wb_we_o  (spi_wb_we),
        .s2_wb_stb_o (spi_wb_stb),
        .s2_wb_cyc_o (spi_wb_cyc),
        .s2_wb_ack_i (spi_wb_ack),

        // Slave 3: Timer
        .s3_wb_adr_o (timer_wb_adr),
        .s3_wb_dat_o (timer_wb_dat_w),
        .s3_wb_dat_i (timer_wb_dat_r),
        .s3_wb_sel_o (timer_wb_sel),
        .s3_wb_we_o  (timer_wb_we),
        .s3_wb_stb_o (timer_wb_stb),
        .s3_wb_cyc_o (timer_wb_cyc),
        .s3_wb_ack_i (timer_wb_ack),

        // Slave 4: GPIO
        .s4_wb_adr_o (gpio_wb_adr),
        .s4_wb_dat_o (gpio_wb_dat_w),
        .s4_wb_dat_i (gpio_wb_dat_r),
        .s4_wb_sel_o (gpio_wb_sel),
        .s4_wb_we_o  (gpio_wb_we),
        .s4_wb_stb_o (gpio_wb_stb),
        .s4_wb_cyc_o (gpio_wb_cyc),
        .s4_wb_ack_i (gpio_wb_ack)
    );

    // ========================================================================
    // Slave 0: Data Memory (4KB SRAM via Wishbone)
    // ========================================================================

    dmem_wb_wrapper u_dmem (
        .wb_clk_i (clk),
        .wb_rst_i (wb_rst),
        .wb_adr_i (dmem_wb_adr),
        .wb_dat_i (dmem_wb_dat_w),
        .wb_dat_o (dmem_wb_dat_r),
        .wb_sel_i (dmem_wb_sel),
        .wb_we_i  (dmem_wb_we),
        .wb_stb_i (dmem_wb_stb),
        .wb_cyc_i (dmem_wb_cyc),
        .wb_ack_o (dmem_wb_ack)
    );

    // ========================================================================
    // Slave 1: UART
    // ========================================================================

    uart_wb u_uart (
        .wb_clk_i (clk),
        .wb_rst_i (wb_rst),
        .wb_adr_i (uart_wb_adr),
        .wb_dat_i (uart_wb_dat_w),
        .wb_dat_o (uart_wb_dat_r),
        .wb_sel_i (uart_wb_sel),
        .wb_we_i  (uart_wb_we),
        .wb_stb_i (uart_wb_stb),
        .wb_cyc_i (uart_wb_cyc),
        .wb_ack_o (uart_wb_ack),
        .uart_tx  (uart_tx),
        .uart_rx  (uart_rx),
        .irq      (irq_uart)
    );

    // ========================================================================
    // Slave 2: SPI
    // ========================================================================

    spi_wb u_spi (
        .wb_clk_i (clk),
        .wb_rst_i (wb_rst),
        .wb_adr_i (spi_wb_adr),
        .wb_dat_i (spi_wb_dat_w),
        .wb_dat_o (spi_wb_dat_r),
        .wb_sel_i (spi_wb_sel),
        .wb_we_i  (spi_wb_we),
        .wb_stb_i (spi_wb_stb),
        .wb_cyc_i (spi_wb_cyc),
        .wb_ack_o (spi_wb_ack),
        .spi_sclk (spi_sclk),
        .spi_mosi (spi_mosi),
        .spi_miso (spi_miso),
        .spi_cs_n (spi_cs_n),
        .irq      (irq_spi)
    );

    // ========================================================================
    // Slave 3: Timer
    // ========================================================================

    timer_wb u_timer (
        .wb_clk_i (clk),
        .wb_rst_i (wb_rst),
        .wb_adr_i (timer_wb_adr),
        .wb_dat_i (timer_wb_dat_w),
        .wb_dat_o (timer_wb_dat_r),
        .wb_sel_i (timer_wb_sel),
        .wb_we_i  (timer_wb_we),
        .wb_stb_i (timer_wb_stb),
        .wb_cyc_i (timer_wb_cyc),
        .wb_ack_o (timer_wb_ack),
        .irq      (irq_timer)
    );

    // ========================================================================
    // Slave 4: GPIO
    // ========================================================================

    gpio_wb u_gpio (
        .wb_clk_i (clk),
        .wb_rst_i (wb_rst),
        .wb_adr_i (gpio_wb_adr),
        .wb_dat_i (gpio_wb_dat_w),
        .wb_dat_o (gpio_wb_dat_r),
        .wb_sel_i (gpio_wb_sel),
        .wb_we_i  (gpio_wb_we),
        .wb_stb_i (gpio_wb_stb),
        .wb_cyc_i (gpio_wb_cyc),
        .wb_ack_o (gpio_wb_ack),
        .gpio_in  (gpio_in),
        .gpio_out (gpio_out),
        .gpio_oe  (gpio_oe),
        .irq      (irq_gpio)
    );

    // ========================================================================
    // Debug outputs
    // ========================================================================
    assign debug_pc    = imem_addr;
    assign debug_instr = imem_rdata;

endmodule
