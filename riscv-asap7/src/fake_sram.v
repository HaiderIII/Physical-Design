// ============================================================================
// Fake SRAM - Synthesizable Memory (32-bit x 1024 words = 4KB)
// ============================================================================
// ASAP7 n'a pas de macro SRAM disponible, donc on utilise une mémoire
// comportementale qui sera synthétisée en flip-flops.
//
// Avantages : Simple, portable, fonctionne avec n'importe quel PDK
// Inconvénients : Grande surface (1 FF = 1 bit), consommation élevée
// ============================================================================

module fake_sram #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10,    // 2^10 = 1024 words
    parameter DEPTH = 1024
)(
    input  wire                    clk,
    input  wire                    cs,       // Chip select (active = on peut accéder)
    input  wire                    we,       // Write enable (1 = écriture, 0 = lecture)
    input  wire [3:0]              be,       // Byte enables (quel octet écrire)
    input  wire [ADDR_WIDTH-1:0]   addr,     // Adresse (0 à 1023)
    input  wire [DATA_WIDTH-1:0]   din,      // Data in (donnée à écrire)
    output reg  [DATA_WIDTH-1:0]   dout      // Data out (donnée lue)
);

    // =========================================================================
    // Tableau mémoire : 1024 mots de 32 bits
    // =========================================================================
    // C'est comme un tableau : mem[0], mem[1], ... mem[1023]
    // Chaque case contient 32 bits

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // =========================================================================
    // Logique synchrone : tout se passe sur le front montant de l'horloge
    // =========================================================================

    always @(posedge clk) begin
        if (cs) begin  // Si chip select actif

            // --- ÉCRITURE (si we = 1) ---
            if (we) begin
                // Écriture avec byte enables
                // be[0] = 1 → écrire l'octet 0 (bits 7:0)
                // be[1] = 1 → écrire l'octet 1 (bits 15:8)
                // etc.
                if (be[0]) mem[addr][7:0]   <= din[7:0];
                if (be[1]) mem[addr][15:8]  <= din[15:8];
                if (be[2]) mem[addr][23:16] <= din[23:16];
                if (be[3]) mem[addr][31:24] <= din[31:24];
            end

            // --- LECTURE (toujours) ---
            // On lit l'adresse demandée et on met dans dout
            dout <= mem[addr];

        end
    end

endmodule
