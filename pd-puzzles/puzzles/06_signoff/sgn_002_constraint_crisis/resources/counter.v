// Simple 8-bit Counter - Pre-synthesized for Sky130HD

module counter (
    input  wire clk,
    input  wire rst_n,
    input  wire enable,
    output wire [7:0] count
);

    wire [7:0] count_q;
    wire [7:0] count_next;
    wire rst_buf, en_buf;

    // Buffer inputs
    sky130_fd_sc_hd__buf_2 buf_rst (.A(rst_n), .X(rst_buf));
    sky130_fd_sc_hd__buf_2 buf_en (.A(enable), .X(en_buf));

    // Increment logic
    wire [7:0] inc;
    wire c0, c1, c2, c3, c4, c5, c6;

    sky130_fd_sc_hd__ha_1 ha0 (.A(count_q[0]), .B(en_buf), .SUM(inc[0]), .COUT(c0));
    sky130_fd_sc_hd__ha_1 ha1 (.A(count_q[1]), .B(c0), .SUM(inc[1]), .COUT(c1));
    sky130_fd_sc_hd__ha_1 ha2 (.A(count_q[2]), .B(c1), .SUM(inc[2]), .COUT(c2));
    sky130_fd_sc_hd__ha_1 ha3 (.A(count_q[3]), .B(c2), .SUM(inc[3]), .COUT(c3));
    sky130_fd_sc_hd__ha_1 ha4 (.A(count_q[4]), .B(c3), .SUM(inc[4]), .COUT(c4));
    sky130_fd_sc_hd__ha_1 ha5 (.A(count_q[5]), .B(c4), .SUM(inc[5]), .COUT(c5));
    sky130_fd_sc_hd__ha_1 ha6 (.A(count_q[6]), .B(c5), .SUM(inc[6]), .COUT(c6));
    sky130_fd_sc_hd__xor2_1 xor7 (.A(count_q[7]), .B(c6), .X(inc[7]));

    // Registers
    sky130_fd_sc_hd__dfrtp_1 reg0 (.CLK(clk), .D(inc[0]), .RESET_B(rst_buf), .Q(count_q[0]));
    sky130_fd_sc_hd__dfrtp_1 reg1 (.CLK(clk), .D(inc[1]), .RESET_B(rst_buf), .Q(count_q[1]));
    sky130_fd_sc_hd__dfrtp_1 reg2 (.CLK(clk), .D(inc[2]), .RESET_B(rst_buf), .Q(count_q[2]));
    sky130_fd_sc_hd__dfrtp_1 reg3 (.CLK(clk), .D(inc[3]), .RESET_B(rst_buf), .Q(count_q[3]));
    sky130_fd_sc_hd__dfrtp_1 reg4 (.CLK(clk), .D(inc[4]), .RESET_B(rst_buf), .Q(count_q[4]));
    sky130_fd_sc_hd__dfrtp_1 reg5 (.CLK(clk), .D(inc[5]), .RESET_B(rst_buf), .Q(count_q[5]));
    sky130_fd_sc_hd__dfrtp_1 reg6 (.CLK(clk), .D(inc[6]), .RESET_B(rst_buf), .Q(count_q[6]));
    sky130_fd_sc_hd__dfrtp_1 reg7 (.CLK(clk), .D(inc[7]), .RESET_B(rst_buf), .Q(count_q[7]));

    assign count = count_q;

endmodule
