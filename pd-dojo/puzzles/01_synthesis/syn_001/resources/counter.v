//-----------------------------------------------------------------------------
// Module: counter
// Description: Simple 4-bit synchronous counter with enable and reset
//
// This is a basic design used for learning synthesis flow.
//-----------------------------------------------------------------------------

module counter (
    input  wire       clk,      // Clock input
    input  wire       rst_n,    // Active-low asynchronous reset
    input  wire       enable,   // Count enable
    output reg  [3:0] count     // 4-bit counter output
);

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Asynchronous reset - clear counter
            count <= 4'b0000;
        end else if (enable) begin
            // Increment counter when enabled
            count <= count + 1'b1;
        end
        // Hold value when not enabled
    end

endmodule
