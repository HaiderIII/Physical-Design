// ============================================================================
// RISC-V Register File - 32 x 32-bit registers
// ============================================================================

module register_file (
    input  wire        clk,
    input  wire        rst_n,

    // Read ports
    input  wire [4:0]  rs1_addr,
    input  wire [4:0]  rs2_addr,
    output wire [31:0] rs1_data,
    output wire [31:0] rs2_data,

    // Write port
    input  wire        wr_en,
    input  wire [4:0]  rd_addr,
    input  wire [31:0] rd_data
);

    // 32 registers of 32 bits each
    reg [31:0] registers [1:31];  // x0 is hardwired to 0

    integer i;

    // Write operation (synchronous)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 1; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else if (wr_en && rd_addr != 5'b0) begin
            registers[rd_addr] <= rd_data;
        end
    end

    // Read operations (asynchronous with bypass)
    assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 :
                      (wr_en && rs1_addr == rd_addr) ? rd_data :
                      registers[rs1_addr];

    assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 :
                      (wr_en && rs2_addr == rd_addr) ? rd_data :
                      registers[rs2_addr];

endmodule
