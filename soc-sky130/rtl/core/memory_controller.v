// ============================================================================
// RISC-V Memory Controller - Load/Store Unit with byte/half/word support
// ============================================================================
// Project: RISC-V Physical Design with SKY130 + SRAM Macros
// ============================================================================

`include "riscv_pkg.v"

module memory_controller (
    input  wire        clk,
    input  wire        rst_n,

    // CPU interface
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    input  wire [2:0]  mem_size,
    input  wire        mem_read,
    input  wire        mem_write,
    output reg  [31:0] read_data,

    // Memory interface
    output wire [31:0] mem_addr,
    output reg  [31:0] mem_wdata,
    output reg  [3:0]  mem_be,       // Byte enables
    output wire        mem_we,
    output wire        mem_re,
    input  wire [31:0] mem_rdata
);

    assign mem_addr = {addr[31:2], 2'b00};  // Word-aligned address
    assign mem_we   = mem_write;
    assign mem_re   = mem_read;

    wire [1:0] byte_offset;
    assign byte_offset = addr[1:0];

    // Write data alignment and byte enables
    always @(*) begin
        mem_wdata = 32'b0;
        mem_be    = 4'b0000;

        if (mem_write) begin
            case (mem_size)
                `MEM_BYTE: begin
                    case (byte_offset)
                        2'b00: begin mem_wdata = {24'b0, write_data[7:0]};       mem_be = 4'b0001; end
                        2'b01: begin mem_wdata = {16'b0, write_data[7:0], 8'b0}; mem_be = 4'b0010; end
                        2'b10: begin mem_wdata = {8'b0, write_data[7:0], 16'b0}; mem_be = 4'b0100; end
                        2'b11: begin mem_wdata = {write_data[7:0], 24'b0};       mem_be = 4'b1000; end
                    endcase
                end
                `MEM_HALF: begin
                    case (byte_offset[1])
                        1'b0: begin mem_wdata = {16'b0, write_data[15:0]};       mem_be = 4'b0011; end
                        1'b1: begin mem_wdata = {write_data[15:0], 16'b0};       mem_be = 4'b1100; end
                    endcase
                end
                `MEM_WORD: begin
                    mem_wdata = write_data;
                    mem_be    = 4'b1111;
                end
                default: begin
                    mem_wdata = write_data;
                    mem_be    = 4'b1111;
                end
            endcase
        end
    end

    // Read data alignment and sign extension
    always @(*) begin
        read_data = 32'b0;

        if (mem_read) begin
            case (mem_size)
                `MEM_BYTE: begin
                    case (byte_offset)
                        2'b00: read_data = {{24{mem_rdata[7]}},  mem_rdata[7:0]};
                        2'b01: read_data = {{24{mem_rdata[15]}}, mem_rdata[15:8]};
                        2'b10: read_data = {{24{mem_rdata[23]}}, mem_rdata[23:16]};
                        2'b11: read_data = {{24{mem_rdata[31]}}, mem_rdata[31:24]};
                    endcase
                end
                `MEM_BYTE_U: begin
                    case (byte_offset)
                        2'b00: read_data = {24'b0, mem_rdata[7:0]};
                        2'b01: read_data = {24'b0, mem_rdata[15:8]};
                        2'b10: read_data = {24'b0, mem_rdata[23:16]};
                        2'b11: read_data = {24'b0, mem_rdata[31:24]};
                    endcase
                end
                `MEM_HALF: begin
                    case (byte_offset[1])
                        1'b0: read_data = {{16{mem_rdata[15]}}, mem_rdata[15:0]};
                        1'b1: read_data = {{16{mem_rdata[31]}}, mem_rdata[31:16]};
                    endcase
                end
                `MEM_HALF_U: begin
                    case (byte_offset[1])
                        1'b0: read_data = {16'b0, mem_rdata[15:0]};
                        1'b1: read_data = {16'b0, mem_rdata[31:16]};
                    endcase
                end
                `MEM_WORD: begin
                    read_data = mem_rdata;
                end
                default: begin
                    read_data = mem_rdata;
                end
            endcase
        end
    end

endmodule
