// ============================================================================
// Matrix Multiplier - Dense design for routability puzzle
// ============================================================================
// 2x2 matrix multiplier with accumulation
// Creates dense interconnects that stress routing resources
// ============================================================================

module matrix_mult (
    input  wire        clk,
    input  wire        rst_n,

    // Matrix A elements (8-bit)
    input  wire [7:0]  a00, a01, a10, a11,

    // Matrix B elements (8-bit)
    input  wire [7:0]  b00, b01, b10, b11,

    // Control
    input  wire        start,
    input  wire        accumulate,

    // Matrix C output (16-bit)
    output reg  [15:0] c00, c01, c10, c11,
    output reg         done,
    output reg         overflow
);

    // Pipeline registers
    reg [7:0] a00_r, a01_r, a10_r, a11_r;
    reg [7:0] b00_r, b01_r, b10_r, b11_r;
    reg       start_r, accumulate_r;

    // Multiplication results
    wire [15:0] mult_a00_b00 = a00_r * b00_r;
    wire [15:0] mult_a01_b10 = a01_r * b10_r;
    wire [15:0] mult_a00_b01 = a00_r * b01_r;
    wire [15:0] mult_a01_b11 = a01_r * b11_r;
    wire [15:0] mult_a10_b00 = a10_r * b00_r;
    wire [15:0] mult_a11_b10 = a11_r * b10_r;
    wire [15:0] mult_a10_b01 = a10_r * b01_r;
    wire [15:0] mult_a11_b11 = a11_r * b11_r;

    // Addition stage
    wire [16:0] sum_c00 = mult_a00_b00 + mult_a01_b10;
    wire [16:0] sum_c01 = mult_a00_b01 + mult_a01_b11;
    wire [16:0] sum_c10 = mult_a10_b00 + mult_a11_b10;
    wire [16:0] sum_c11 = mult_a10_b01 + mult_a11_b11;

    // Accumulation values
    wire [16:0] acc_c00 = accumulate_r ? ({1'b0, c00} + sum_c00) : sum_c00;
    wire [16:0] acc_c01 = accumulate_r ? ({1'b0, c01} + sum_c01) : sum_c01;
    wire [16:0] acc_c10 = accumulate_r ? ({1'b0, c10} + sum_c10) : sum_c10;
    wire [16:0] acc_c11 = accumulate_r ? ({1'b0, c11} + sum_c11) : sum_c11;

    // State machine
    reg [1:0] state;
    localparam IDLE = 2'b00;
    localparam MULT = 2'b01;
    localparam ADD  = 2'b10;
    localparam OUT  = 2'b11;

    // Input registration
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a00_r <= 8'd0; a01_r <= 8'd0;
            a10_r <= 8'd0; a11_r <= 8'd0;
            b00_r <= 8'd0; b01_r <= 8'd0;
            b10_r <= 8'd0; b11_r <= 8'd0;
            start_r <= 1'b0;
            accumulate_r <= 1'b0;
        end else begin
            a00_r <= a00; a01_r <= a01;
            a10_r <= a10; a11_r <= a11;
            b00_r <= b00; b01_r <= b01;
            b10_r <= b10; b11_r <= b11;
            start_r <= start;
            accumulate_r <= accumulate;
        end
    end

    // Main state machine and output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            c00 <= 16'd0; c01 <= 16'd0;
            c10 <= 16'd0; c11 <= 16'd0;
            done <= 1'b0;
            overflow <= 1'b0;
            state <= IDLE;
        end else begin
            done <= 1'b0;

            case (state)
                IDLE: begin
                    if (start_r) begin
                        state <= MULT;
                    end
                end

                MULT: begin
                    state <= ADD;
                end

                ADD: begin
                    c00 <= acc_c00[15:0];
                    c01 <= acc_c01[15:0];
                    c10 <= acc_c10[15:0];
                    c11 <= acc_c11[15:0];
                    overflow <= acc_c00[16] | acc_c01[16] | acc_c10[16] | acc_c11[16];
                    state <= OUT;
                end

                OUT: begin
                    done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
