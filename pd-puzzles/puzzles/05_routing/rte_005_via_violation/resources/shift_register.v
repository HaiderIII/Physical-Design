// ============================================================================
// Shift Register Chain - Design for Routing puzzle
// ============================================================================
// A 64-bit shift register with parallel load capability
// Creates long routing chains that stress the routing infrastructure
// ============================================================================

module shift_register (
    input  wire        clk,
    input  wire        rst_n,

    // Shift control
    input  wire        shift_en,
    input  wire        load_en,
    input  wire        shift_dir,  // 0=left, 1=right

    // Parallel I/O
    input  wire [63:0] data_in,
    output reg  [63:0] data_out,

    // Serial I/O
    input  wire        serial_in,
    output wire        serial_out_left,
    output wire        serial_out_right
);

    // Internal shift register
    reg [63:0] shift_reg;

    // Shift operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 64'd0;
        end else if (load_en) begin
            shift_reg <= data_in;
        end else if (shift_en) begin
            if (shift_dir) begin
                // Shift right
                shift_reg <= {serial_in, shift_reg[63:1]};
            end else begin
                // Shift left
                shift_reg <= {shift_reg[62:0], serial_in};
            end
        end
    end

    // Output register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 64'd0;
        end else begin
            data_out <= shift_reg;
        end
    end

    // Serial outputs
    assign serial_out_left = shift_reg[63];
    assign serial_out_right = shift_reg[0];

endmodule
