// 8-bit ALU (Arithmetic Logic Unit)
// Educational design for Physical Design flow learning

module alu_8bit (
    input  wire [7:0] a,           // First operand
    input  wire [7:0] b,           // Second operand
    input  wire [2:0] opcode,      // Operation select
    input  wire       clk,         // Clock signal
    input  wire       rst_n,       // Active-low reset
    output reg  [7:0] result,      // ALU result
    output reg        zero,        // Zero flag
    output reg        carry,       // Carry flag
    output reg        overflow     // Overflow flag
);

    // Internal signals
    reg [8:0] temp_result;  // 9-bit for carry detection
    
    // Operation codes
    localparam OP_ADD  = 3'b000;  // Addition
    localparam OP_SUB  = 3'b001;  // Subtraction
    localparam OP_AND  = 3'b010;  // Bitwise AND
    localparam OP_OR   = 3'b011;  // Bitwise OR
    localparam OP_XOR  = 3'b100;  // Bitwise XOR
    localparam OP_SLL  = 3'b101;  // Shift left logical
    localparam OP_SRL  = 3'b110;  // Shift right logical
    localparam OP_NOT  = 3'b111;  // Bitwise NOT
    
    // ALU operations
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result   <= 8'b0;
            zero     <= 1'b0;
            carry    <= 1'b0;
            overflow <= 1'b0;
        end else begin
            case (opcode)
                OP_ADD: begin
                    temp_result = {1'b0, a} + {1'b0, b};
                    result      = temp_result[7:0];
                    carry       = temp_result[8];
                    overflow    = (a[7] == b[7]) && (result[7] != a[7]);
                end
                
                OP_SUB: begin
                    temp_result = {1'b0, a} - {1'b0, b};
                    result      = temp_result[7:0];
                    carry       = temp_result[8];
                    overflow    = (a[7] != b[7]) && (result[7] != a[7]);
                end
                
                OP_AND: begin
                    result   = a & b;
                    carry    = 1'b0;
                    overflow = 1'b0;
                end
                
                OP_OR: begin
                    result   = a | b;
                    carry    = 1'b0;
                    overflow = 1'b0;
                end
                
                OP_XOR: begin
                    result   = a ^ b;
                    carry    = 1'b0;
                    overflow = 1'b0;
                end
                
                OP_SLL: begin
                    result   = a << b[2:0];
                    carry    = 1'b0;
                    overflow = 1'b0;
                end
                
                OP_SRL: begin
                    result   = a >> b[2:0];
                    carry    = 1'b0;
                    overflow = 1'b0;
                end
                
                OP_NOT: begin
                    result   = ~a;
                    carry    = 1'b0;
                    overflow = 1'b0;
                end
                
                default: begin
                    result   = 8'b0;
                    carry    = 1'b0;
                    overflow = 1'b0;
                end
            endcase
            
            // Zero flag
            zero = (result == 8'b0);
        end
    end

endmodule
