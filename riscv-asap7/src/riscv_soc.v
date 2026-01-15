// ============================================================================
// RISC-V SoC Top Level - ASAP7 Version with Fake SRAM
// ============================================================================
// Ce module connecte ensemble :
// - Le CPU (riscv_core)
// - La mémoire instructions (IMEM)
// - La mémoire données (DMEM)
// - GPIO simple (memory-mapped)
// ============================================================================

module riscv_soc (
    input  wire        clk,
    input  wire        rst_n,      // Reset actif bas (0 = reset)

    // GPIO (entrées/sorties générales)
    input  wire [31:0] gpio_in,
    output reg  [31:0] gpio_out,

    // Debug (pour observer le CPU)
    output wire [31:0] debug_pc,
    output wire [31:0] debug_instr
);

    // =========================================================================
    // Signaux internes (fils entre les modules)
    // =========================================================================

    // Interface mémoire instructions
    wire [31:0] imem_addr;     // Adresse demandée par le CPU
    wire [31:0] imem_rdata;    // Instruction lue

    // Interface mémoire données
    wire [31:0] dmem_addr;     // Adresse demandée par le CPU
    wire [31:0] dmem_wdata;    // Donnée à écrire
    wire [31:0] dmem_rdata;    // Donnée lue
    wire [3:0]  dmem_be;       // Byte enables
    wire        dmem_we;       // Write enable
    wire        dmem_re;       // Read enable

    // Sélection mémoire vs GPIO (simple décodage d'adresse)
    wire        sel_dmem;      // Sélection DMEM
    wire        sel_gpio;      // Sélection GPIO
    wire [31:0] dmem_rdata_mem;
    wire [31:0] dmem_rdata_mux;

    // =========================================================================
    // Décodage d'adresse simple
    // =========================================================================
    // DMEM: 0x0000_0000 - 0x0000_0FFF (4KB)
    // GPIO: 0x1000_0000 - 0x1000_000F

    assign sel_dmem = (dmem_addr[31:28] == 4'h0);
    assign sel_gpio = (dmem_addr[31:28] == 4'h1);

    // Mux de lecture
    assign dmem_rdata = sel_gpio ? {24'b0, gpio_in[7:0]} : dmem_rdata_mem;

    // =========================================================================
    // GPIO Register
    // =========================================================================

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            gpio_out <= 32'b0;
        end else if (sel_gpio && dmem_we) begin
            gpio_out <= dmem_wdata;
        end
    end

    // =========================================================================
    // CPU Core - Le processeur RISC-V
    // =========================================================================

    riscv_core u_riscv_core (
        .clk            (clk),
        .rst_n          (rst_n),

        // Mémoire instructions (lecture seule)
        .imem_addr      (imem_addr),
        .imem_rdata     (imem_rdata),

        // Mémoire données (lecture/écriture)
        .dmem_addr      (dmem_addr),
        .dmem_wdata     (dmem_wdata),
        .dmem_rdata     (dmem_rdata),
        .dmem_be        (dmem_be),
        .dmem_we        (dmem_we),
        .dmem_re        (dmem_re)
    );

    // =========================================================================
    // Instruction Memory (IMEM) - Mémoire programme
    // =========================================================================

    fake_sram u_imem (
        .clk    (clk),
        .cs     (1'b1),                 // Toujours actif
        .we     (1'b0),                 // Jamais d'écriture (ROM)
        .be     (4'b1111),              // Tous les octets
        .addr   (imem_addr[11:2]),      // 10 bits d'adresse (1024 mots)
        .din    (32'b0),                // Pas d'écriture
        .dout   (imem_rdata)            // Instruction lue
    );

    // =========================================================================
    // Data Memory (DMEM) - Mémoire données
    // =========================================================================

    fake_sram u_dmem (
        .clk    (clk),
        .cs     (sel_dmem),             // Actif si adresse DMEM
        .we     (dmem_we),              // Écriture contrôlée par CPU
        .be     (dmem_be),              // Byte enables du CPU
        .addr   (dmem_addr[11:2]),      // 10 bits d'adresse
        .din    (dmem_wdata),           // Donnée du CPU
        .dout   (dmem_rdata_mem)        // Donnée vers CPU
    );

    // =========================================================================
    // Debug outputs
    // =========================================================================

    assign debug_pc = imem_addr;
    assign debug_instr = imem_rdata;

endmodule
