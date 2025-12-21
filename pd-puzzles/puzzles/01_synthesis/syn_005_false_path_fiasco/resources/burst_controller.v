// ============================================================================
// Burst Controller - Communication controller with tricky signal names
// ============================================================================
// This controller handles burst data transfers with:
// - Asynchronous reset (rst_n) - legitimately a false path
// - "first_beat" signal - marks first beat of burst (NOT a reset!)
// - "burst_mode" register - controls burst behavior (NOT a reset!)
// - "first_data" - first data word capture (NOT a reset!)
//
// The signal names containing "rst" or "first" can be accidentally
// matched by overly broad set_false_path wildcards.
// ============================================================================

module burst_controller (
    input  wire        clk,
    input  wire        rst_n,          // Async reset - OK to be false path

    // Control interface
    input  wire        start_burst,
    input  wire [3:0]  burst_length,
    input  wire [1:0]  burst_mode,     // Contains "rst" in name!
    output reg         burst_active,
    output reg         burst_done,

    // Data interface
    input  wire [31:0] data_in,
    input  wire        data_valid,
    output reg  [31:0] data_out,
    output reg         data_ready,

    // First beat signals - contain "rst" or "first"!
    output reg         first_beat,     // Marks first beat of burst
    output reg  [31:0] first_data,     // Captures first data word
    input  wire        first_ack,      // Acknowledge first beat

    // Status
    output reg  [3:0]  beat_count,
    output reg         error_flag
);

    // State machine
    localparam S_IDLE     = 3'd0;
    localparam S_FIRST    = 3'd1;  // First beat - special handling
    localparam S_BURST    = 3'd2;  // Subsequent beats
    localparam S_WAIT     = 3'd3;  // Wait for ack
    localparam S_DONE     = 3'd4;

    reg [2:0] state, next_state;
    reg [3:0] burst_len_reg;
    reg [1:0] mode_reg;

    // Combinational next state logic
    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE: begin
                if (start_burst)
                    next_state = S_FIRST;
            end
            S_FIRST: begin
                if (data_valid)
                    next_state = S_WAIT;
            end
            S_WAIT: begin
                if (first_ack) begin
                    if (beat_count >= burst_len_reg)
                        next_state = S_DONE;
                    else
                        next_state = S_BURST;
                end
            end
            S_BURST: begin
                if (data_valid) begin
                    if (beat_count >= burst_len_reg)
                        next_state = S_DONE;
                end
            end
            S_DONE: begin
                next_state = S_IDLE;
            end
        endcase
    end

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Burst length and mode capture
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            burst_len_reg <= 4'd0;
            mode_reg <= 2'd0;
        end else if (state == S_IDLE && start_burst) begin
            burst_len_reg <= burst_length;
            mode_reg <= burst_mode;  // This path should be timed!
        end
    end

    // Beat counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            beat_count <= 4'd0;
        end else begin
            case (state)
                S_IDLE: beat_count <= 4'd0;
                S_FIRST: if (data_valid) beat_count <= 4'd1;
                S_BURST: if (data_valid) beat_count <= beat_count + 4'd1;
                default: beat_count <= beat_count;
            endcase
        end
    end

    // First beat handling - CRITICAL TIMING PATH!
    // first_beat and first_data are NOT reset signals!
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_beat <= 1'b0;
            first_data <= 32'd0;
        end else begin
            case (state)
                S_IDLE: begin
                    first_beat <= 1'b0;
                    first_data <= 32'd0;
                end
                S_FIRST: begin
                    if (data_valid) begin
                        first_beat <= 1'b1;
                        first_data <= data_in;  // Capture first word
                    end
                end
                S_WAIT: begin
                    if (first_ack)
                        first_beat <= 1'b0;
                end
                default: begin
                    first_beat <= first_beat;
                    first_data <= first_data;
                end
            endcase
        end
    end

    // Data output with mode-dependent processing
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 32'd0;
            data_ready <= 1'b0;
        end else begin
            data_ready <= 1'b0;
            if ((state == S_FIRST || state == S_BURST) && data_valid) begin
                // Mode-dependent processing - burst_mode affects timing!
                case (mode_reg)
                    2'b00: data_out <= data_in;                      // Pass-through
                    2'b01: data_out <= data_in ^ first_data;         // XOR with first
                    2'b10: data_out <= data_in + first_data;         // Add first
                    2'b11: data_out <= {data_in[15:0], first_data[31:16]}; // Mix
                endcase
                data_ready <= 1'b1;
            end
        end
    end

    // Status outputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            burst_active <= 1'b0;
            burst_done <= 1'b0;
            error_flag <= 1'b0;
        end else begin
            burst_active <= (state != S_IDLE && state != S_DONE);
            burst_done <= (state == S_DONE);

            // Error: data valid without being in right state
            if (data_valid && state == S_IDLE)
                error_flag <= 1'b1;
            else if (state == S_IDLE)
                error_flag <= 1'b0;
        end
    end

endmodule
