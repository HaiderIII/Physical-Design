// ============================================================================
// Pipelined Adder - Design for CTS puzzle
// ============================================================================
// A 32-bit pipelined adder with multiple stages
// Creates a spread-out register file that challenges clock tree synthesis
// ============================================================================

module pipelined_adder (
    input  wire        clk,
    input  wire        rst_n,

    // Operands
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire        valid_in,

    // Control
    input  wire [1:0]  op_mode,  // 00=add, 01=sub, 10=and, 11=or

    // Output
    output reg  [31:0] result,
    output reg         valid_out,
    output reg         carry_out,
    output reg         overflow
);

    // Pipeline stage 1: Input registration
    reg [31:0] a_s1, b_s1;
    reg        valid_s1;
    reg [1:0]  op_s1;

    // Pipeline stage 2: Split computation (lower 16 bits)
    reg [16:0] sum_lo_s2;
    reg [31:0] a_s2, b_s2;
    reg        valid_s2;
    reg [1:0]  op_s2;

    // Pipeline stage 3: Complete computation (upper 16 bits)
    reg [16:0] sum_hi_s3;
    reg [15:0] sum_lo_s3;
    reg        valid_s3;
    reg [1:0]  op_s3;
    reg        carry_s3;

    // Pipeline stage 4: Final result assembly
    reg [31:0] result_s4;
    reg        valid_s4;
    reg        carry_s4;
    reg        overflow_s4;

    // Stage 1: Input registration
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_s1 <= 32'd0;
            b_s1 <= 32'd0;
            valid_s1 <= 1'b0;
            op_s1 <= 2'b00;
        end else begin
            a_s1 <= a;
            b_s1 <= b;
            valid_s1 <= valid_in;
            op_s1 <= op_mode;
        end
    end

    // Stage 2: Lower 16-bit computation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_lo_s2 <= 17'd0;
            a_s2 <= 32'd0;
            b_s2 <= 32'd0;
            valid_s2 <= 1'b0;
            op_s2 <= 2'b00;
        end else begin
            case (op_s1)
                2'b00: sum_lo_s2 <= {1'b0, a_s1[15:0]} + {1'b0, b_s1[15:0]};
                2'b01: sum_lo_s2 <= {1'b0, a_s1[15:0]} - {1'b0, b_s1[15:0]};
                2'b10: sum_lo_s2 <= {1'b0, a_s1[15:0] & b_s1[15:0]};
                2'b11: sum_lo_s2 <= {1'b0, a_s1[15:0] | b_s1[15:0]};
            endcase
            a_s2 <= a_s1;
            b_s2 <= b_s1;
            valid_s2 <= valid_s1;
            op_s2 <= op_s1;
        end
    end

    // Stage 3: Upper 16-bit computation with carry
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_hi_s3 <= 17'd0;
            sum_lo_s3 <= 16'd0;
            valid_s3 <= 1'b0;
            op_s3 <= 2'b00;
            carry_s3 <= 1'b0;
        end else begin
            case (op_s2)
                2'b00: sum_hi_s3 <= {1'b0, a_s2[31:16]} + {1'b0, b_s2[31:16]} + sum_lo_s2[16];
                2'b01: sum_hi_s3 <= {1'b0, a_s2[31:16]} - {1'b0, b_s2[31:16]} - sum_lo_s2[16];
                2'b10: sum_hi_s3 <= {1'b0, a_s2[31:16] & b_s2[31:16]};
                2'b11: sum_hi_s3 <= {1'b0, a_s2[31:16] | b_s2[31:16]};
            endcase
            sum_lo_s3 <= sum_lo_s2[15:0];
            valid_s3 <= valid_s2;
            op_s3 <= op_s2;
            carry_s3 <= sum_lo_s2[16];
        end
    end

    // Stage 4: Result assembly and flags
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result_s4 <= 32'd0;
            valid_s4 <= 1'b0;
            carry_s4 <= 1'b0;
            overflow_s4 <= 1'b0;
        end else begin
            result_s4 <= {sum_hi_s3[15:0], sum_lo_s3};
            valid_s4 <= valid_s3;
            carry_s4 <= sum_hi_s3[16];
            // Overflow for signed arithmetic
            overflow_s4 <= (op_s3 == 2'b00 || op_s3 == 2'b01) ?
                           (sum_hi_s3[15] != sum_hi_s3[16]) : 1'b0;
        end
    end

    // Output stage
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 32'd0;
            valid_out <= 1'b0;
            carry_out <= 1'b0;
            overflow <= 1'b0;
        end else begin
            result <= result_s4;
            valid_out <= valid_s4;
            carry_out <= carry_s4;
            overflow <= overflow_s4;
        end
    end

endmodule
