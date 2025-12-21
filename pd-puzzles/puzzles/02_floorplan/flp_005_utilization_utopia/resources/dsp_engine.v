// ============================================================================
// DSP Engine - Large design for floorplan puzzle
// ============================================================================
// A DSP engine with multiple MAC units for signal processing
// This is a larger design that needs adequate die area
// ============================================================================

module dsp_engine (
    input  wire        clk,
    input  wire        rst_n,

    // Input samples
    input  wire signed [15:0] sample_a,
    input  wire signed [15:0] sample_b,
    input  wire signed [15:0] sample_c,
    input  wire signed [15:0] sample_d,
    input  wire        sample_valid,

    // Coefficients
    input  wire signed [15:0] coef_0,
    input  wire signed [15:0] coef_1,
    input  wire signed [15:0] coef_2,
    input  wire signed [15:0] coef_3,
    input  wire        coef_load,

    // Control
    input  wire [1:0]  mode,
    input  wire        accumulate,
    input  wire        clear,

    // Output
    output reg  signed [31:0] result_0,
    output reg  signed [31:0] result_1,
    output reg  signed [31:0] result_2,
    output reg  signed [31:0] result_3,
    output reg         result_valid,

    // Status
    output reg  [7:0]  cycle_count,
    output reg         overflow
);

    // Coefficient registers
    reg signed [15:0] coef_reg [0:3];

    // Pipeline stage 1: Input registers
    reg signed [15:0] s1_a, s1_b, s1_c, s1_d;
    reg        s1_valid;

    // Pipeline stage 2: Multiplication
    reg signed [31:0] s2_mult_0, s2_mult_1, s2_mult_2, s2_mult_3;
    reg        s2_valid;

    // Pipeline stage 3: Cross products
    reg signed [31:0] s3_cross_0, s3_cross_1;
    reg signed [31:0] s3_mult_0, s3_mult_1, s3_mult_2, s3_mult_3;
    reg        s3_valid;

    // Accumulators
    reg signed [39:0] acc_0, acc_1, acc_2, acc_3;

    // Overflow detection
    wire overflow_0 = (acc_0[39] != acc_0[38]);
    wire overflow_1 = (acc_1[39] != acc_1[38]);
    wire overflow_2 = (acc_2[39] != acc_2[38]);
    wire overflow_3 = (acc_3[39] != acc_3[38]);

    // Coefficient loading
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            coef_reg[0] <= 16'd0;
            coef_reg[1] <= 16'd0;
            coef_reg[2] <= 16'd0;
            coef_reg[3] <= 16'd0;
        end else if (coef_load) begin
            coef_reg[0] <= coef_0;
            coef_reg[1] <= coef_1;
            coef_reg[2] <= coef_2;
            coef_reg[3] <= coef_3;
        end
    end

    // Stage 1: Input registration
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s1_a <= 16'd0;
            s1_b <= 16'd0;
            s1_c <= 16'd0;
            s1_d <= 16'd0;
            s1_valid <= 1'b0;
        end else begin
            s1_a <= sample_a;
            s1_b <= sample_b;
            s1_c <= sample_c;
            s1_d <= sample_d;
            s1_valid <= sample_valid;
        end
    end

    // Stage 2: Multiplication (4 parallel multipliers)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s2_mult_0 <= 32'd0;
            s2_mult_1 <= 32'd0;
            s2_mult_2 <= 32'd0;
            s2_mult_3 <= 32'd0;
            s2_valid <= 1'b0;
        end else begin
            s2_mult_0 <= s1_a * coef_reg[0];
            s2_mult_1 <= s1_b * coef_reg[1];
            s2_mult_2 <= s1_c * coef_reg[2];
            s2_mult_3 <= s1_d * coef_reg[3];
            s2_valid <= s1_valid;
        end
    end

    // Stage 3: Mode-dependent processing
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s3_mult_0 <= 32'd0;
            s3_mult_1 <= 32'd0;
            s3_mult_2 <= 32'd0;
            s3_mult_3 <= 32'd0;
            s3_cross_0 <= 32'd0;
            s3_cross_1 <= 32'd0;
            s3_valid <= 1'b0;
        end else begin
            case (mode)
                2'b00: begin  // Direct multiply
                    s3_mult_0 <= s2_mult_0;
                    s3_mult_1 <= s2_mult_1;
                    s3_mult_2 <= s2_mult_2;
                    s3_mult_3 <= s2_mult_3;
                end
                2'b01: begin  // Add pairs
                    s3_mult_0 <= s2_mult_0 + s2_mult_1;
                    s3_mult_1 <= s2_mult_2 + s2_mult_3;
                    s3_mult_2 <= s2_mult_0 - s2_mult_1;
                    s3_mult_3 <= s2_mult_2 - s2_mult_3;
                end
                2'b10: begin  // Cross multiply
                    s3_cross_0 <= s2_mult_0 + s2_mult_2;
                    s3_cross_1 <= s2_mult_1 + s2_mult_3;
                    s3_mult_0 <= s2_mult_0;
                    s3_mult_1 <= s2_mult_1;
                    s3_mult_2 <= s3_cross_0;
                    s3_mult_3 <= s3_cross_1;
                end
                2'b11: begin  // Butterfly
                    s3_mult_0 <= s2_mult_0 + s2_mult_2;
                    s3_mult_1 <= s2_mult_1 + s2_mult_3;
                    s3_mult_2 <= s2_mult_0 - s2_mult_2;
                    s3_mult_3 <= s2_mult_1 - s2_mult_3;
                end
            endcase
            s3_valid <= s2_valid;
        end
    end

    // Accumulation and output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc_0 <= 40'd0;
            acc_1 <= 40'd0;
            acc_2 <= 40'd0;
            acc_3 <= 40'd0;
            result_0 <= 32'd0;
            result_1 <= 32'd0;
            result_2 <= 32'd0;
            result_3 <= 32'd0;
            result_valid <= 1'b0;
        end else begin
            result_valid <= 1'b0;

            if (clear) begin
                acc_0 <= 40'd0;
                acc_1 <= 40'd0;
                acc_2 <= 40'd0;
                acc_3 <= 40'd0;
            end else if (s3_valid) begin
                if (accumulate) begin
                    acc_0 <= acc_0 + {{8{s3_mult_0[31]}}, s3_mult_0};
                    acc_1 <= acc_1 + {{8{s3_mult_1[31]}}, s3_mult_1};
                    acc_2 <= acc_2 + {{8{s3_mult_2[31]}}, s3_mult_2};
                    acc_3 <= acc_3 + {{8{s3_mult_3[31]}}, s3_mult_3};
                end else begin
                    acc_0 <= {{8{s3_mult_0[31]}}, s3_mult_0};
                    acc_1 <= {{8{s3_mult_1[31]}}, s3_mult_1};
                    acc_2 <= {{8{s3_mult_2[31]}}, s3_mult_2};
                    acc_3 <= {{8{s3_mult_3[31]}}, s3_mult_3};
                end

                result_0 <= acc_0[31:0];
                result_1 <= acc_1[31:0];
                result_2 <= acc_2[31:0];
                result_3 <= acc_3[31:0];
                result_valid <= 1'b1;
            end
        end
    end

    // Cycle counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cycle_count <= 8'd0;
        end else if (clear) begin
            cycle_count <= 8'd0;
        end else if (sample_valid) begin
            cycle_count <= cycle_count + 8'd1;
        end
    end

    // Overflow flag
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            overflow <= 1'b0;
        end else if (clear) begin
            overflow <= 1'b0;
        end else if (overflow_0 || overflow_1 || overflow_2 || overflow_3) begin
            overflow <= 1'b1;
        end
    end

endmodule
