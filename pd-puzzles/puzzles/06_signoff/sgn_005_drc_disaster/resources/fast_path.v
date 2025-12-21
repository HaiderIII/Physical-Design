// ============================================================================
// Fast Path Design - For Hold Violation Puzzle
// ============================================================================
// A design with intentionally short combinational paths that can cause
// hold time violations when clock skew is present
// ============================================================================

module fast_path (
    input  wire        clk,
    input  wire        rst_n,

    // Data inputs
    input  wire [7:0]  data_a,
    input  wire [7:0]  data_b,
    input  wire        sel,

    // Control
    input  wire        enable,
    input  wire [1:0]  mode,

    // Outputs
    output reg  [7:0]  result,
    output reg         valid
);

    // Stage 1: Input registers
    reg [7:0] a_reg, b_reg;
    reg       sel_reg;
    reg       en_reg;
    reg [1:0] mode_reg;

    // Stage 2: Simple operations (VERY SHORT paths - potential hold violations)
    reg [7:0] mux_out;
    reg       valid_s2;

    // Stage 3: Output
    reg [7:0] result_s3;
    reg       valid_s3;

    // Stage 1: Register inputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'd0;
            b_reg <= 8'd0;
            sel_reg <= 1'b0;
            en_reg <= 1'b0;
            mode_reg <= 2'b00;
        end else begin
            a_reg <= data_a;
            b_reg <= data_b;
            sel_reg <= sel;
            en_reg <= enable;
            mode_reg <= mode;
        end
    end

    // Stage 2: Very simple MUX - creates SHORT path (hold risk!)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mux_out <= 8'd0;
            valid_s2 <= 1'b0;
        end else begin
            // Direct pass-through based on sel (minimal logic)
            mux_out <= sel_reg ? b_reg : a_reg;
            valid_s2 <= en_reg;
        end
    end

    // Stage 3: Mode-based output (also short path)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_s3 <= 8'd0;
            valid_s3 <= 1'b0;
        end else begin
            case (mode_reg)
                2'b00: result_s3 <= mux_out;           // Pass through
                2'b01: result_s3 <= mux_out;           // Same
                2'b10: result_s3 <= ~mux_out;          // Invert
                2'b11: result_s3 <= {mux_out[0], mux_out[7:1]}; // Rotate
            endcase
            valid_s3 <= valid_s2;
        end
    end

    // Output stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 8'd0;
            valid <= 1'b0;
        end else begin
            result <= result_s3;
            valid <= valid_s3;
        end
    end

endmodule
