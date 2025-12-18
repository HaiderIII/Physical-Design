// SPI Controller - Gate-level netlist for Sky130
// This is a simplified SPI controller for timing analysis practice

module spi_controller (
    input  wire clk,
    input  wire rst_n,
    input  wire spi_start,
    input  wire [7:0] tx_data,
    output wire spi_clk,
    output wire spi_mosi,
    output wire spi_cs_n,
    output wire busy,
    output wire [7:0] rx_data
);

    // Internal wires
    wire [2:0] bit_cnt;
    wire [7:0] shift_reg_tx;
    wire [7:0] shift_reg_rx;
    wire clk_div;

    // State register (one-hot)
    wire state_d_idle, state_d_active;
    wire state_q_idle, state_q_active;

    // Clock divider counter
    wire [3:0] clk_cnt;
    wire [3:0] clk_cnt_next;
    wire w_cout0, w_cout1, w_cout2;

    // Bit counter
    wire [2:0] bit_cnt_next;
    wire bit_cnt_done;
    wire bc_cout0, bc_cout1;

    // TX shift register wires
    wire tx_load, tx_shift;
    wire [7:0] tx_next_shift;
    wire [7:0] tx_next_final;

    //=========================================================================
    // State Machine
    //=========================================================================

    // Idle to Active transition
    sky130_fd_sc_hd__and2_1 u_start_cond (
        .A(state_q_idle),
        .B(spi_start),
        .X(state_d_active)
    );

    // Active to Idle transition
    sky130_fd_sc_hd__and2_1 u_done_cond (
        .A(state_q_active),
        .B(bit_cnt_done),
        .X(state_d_idle)
    );

    // State flip-flops
    sky130_fd_sc_hd__dfrtp_1 u_state_idle (
        .CLK(clk),
        .RESET_B(rst_n),
        .D(state_d_idle),
        .Q(state_q_idle)
    );

    sky130_fd_sc_hd__dfrtp_1 u_state_active (
        .CLK(clk),
        .RESET_B(rst_n),
        .D(state_d_active),
        .Q(state_q_active)
    );

    //=========================================================================
    // Clock Divider (divide by 8)
    //=========================================================================

    // Counter logic
    sky130_fd_sc_hd__fa_1 u_clk_add0 (
        .A(clk_cnt[0]),
        .B(1'b1),
        .CIN(1'b0),
        .SUM(clk_cnt_next[0]),
        .COUT(w_cout0)
    );

    sky130_fd_sc_hd__fa_1 u_clk_add1 (
        .A(clk_cnt[1]),
        .B(1'b0),
        .CIN(w_cout0),
        .SUM(clk_cnt_next[1]),
        .COUT(w_cout1)
    );

    sky130_fd_sc_hd__fa_1 u_clk_add2 (
        .A(clk_cnt[2]),
        .B(1'b0),
        .CIN(w_cout1),
        .SUM(clk_cnt_next[2]),
        .COUT(w_cout2)
    );

    sky130_fd_sc_hd__fa_1 u_clk_add3 (
        .A(clk_cnt[3]),
        .B(1'b0),
        .CIN(w_cout2),
        .SUM(clk_cnt_next[3]),
        .COUT()
    );

    // Clock counter registers
    sky130_fd_sc_hd__dfrtp_1 u_clk_cnt0 (.CLK(clk), .RESET_B(rst_n), .D(clk_cnt_next[0]), .Q(clk_cnt[0]));
    sky130_fd_sc_hd__dfrtp_1 u_clk_cnt1 (.CLK(clk), .RESET_B(rst_n), .D(clk_cnt_next[1]), .Q(clk_cnt[1]));
    sky130_fd_sc_hd__dfrtp_1 u_clk_cnt2 (.CLK(clk), .RESET_B(rst_n), .D(clk_cnt_next[2]), .Q(clk_cnt[2]));
    sky130_fd_sc_hd__dfrtp_1 u_clk_cnt3 (.CLK(clk), .RESET_B(rst_n), .D(clk_cnt_next[3]), .Q(clk_cnt[3]));

    // Generate divided clock
    sky130_fd_sc_hd__and3_1 u_clk_div (
        .A(clk_cnt[0]),
        .B(clk_cnt[1]),
        .C(clk_cnt[2]),
        .X(clk_div)
    );

    //=========================================================================
    // Bit Counter
    //=========================================================================

    wire bc_en;
    sky130_fd_sc_hd__and2_1 u_bc_en (
        .A(state_q_active),
        .B(clk_div),
        .X(bc_en)
    );

    // Bit counter increment
    sky130_fd_sc_hd__fa_1 u_bc_add0 (
        .A(bit_cnt[0]),
        .B(bc_en),
        .CIN(1'b0),
        .SUM(bit_cnt_next[0]),
        .COUT(bc_cout0)
    );

    sky130_fd_sc_hd__fa_1 u_bc_add1 (
        .A(bit_cnt[1]),
        .B(1'b0),
        .CIN(bc_cout0),
        .SUM(bit_cnt_next[1]),
        .COUT(bc_cout1)
    );

    sky130_fd_sc_hd__fa_1 u_bc_add2 (
        .A(bit_cnt[2]),
        .B(1'b0),
        .CIN(bc_cout1),
        .SUM(bit_cnt_next[2]),
        .COUT()
    );

    // Bit counter registers
    sky130_fd_sc_hd__dfrtp_1 u_bit_cnt0 (.CLK(clk), .RESET_B(rst_n), .D(bit_cnt_next[0]), .Q(bit_cnt[0]));
    sky130_fd_sc_hd__dfrtp_1 u_bit_cnt1 (.CLK(clk), .RESET_B(rst_n), .D(bit_cnt_next[1]), .Q(bit_cnt[1]));
    sky130_fd_sc_hd__dfrtp_1 u_bit_cnt2 (.CLK(clk), .RESET_B(rst_n), .D(bit_cnt_next[2]), .Q(bit_cnt[2]));

    // Done when bit_cnt == 7
    sky130_fd_sc_hd__and3_1 u_done (
        .A(bit_cnt[0]),
        .B(bit_cnt[1]),
        .C(bit_cnt[2]),
        .X(bit_cnt_done)
    );

    //=========================================================================
    // TX Shift Register (manually unrolled - no generate)
    //=========================================================================

    // Load or shift control
    sky130_fd_sc_hd__and2_1 u_tx_load (
        .A(state_q_idle),
        .B(spi_start),
        .X(tx_load)
    );

    sky130_fd_sc_hd__and2_1 u_tx_shift (
        .A(state_q_active),
        .B(clk_div),
        .X(tx_shift)
    );

    // Bit 0: shift from bit 1
    sky130_fd_sc_hd__mux2_1 u_tx_mux_shift0 (.A0(shift_reg_tx[0]), .A1(shift_reg_tx[1]), .S(tx_shift), .X(tx_next_shift[0]));
    sky130_fd_sc_hd__mux2_1 u_tx_mux_load0  (.A0(tx_next_shift[0]), .A1(tx_data[0]), .S(tx_load), .X(tx_next_final[0]));
    sky130_fd_sc_hd__dfrtp_1 u_tx_ff0 (.CLK(clk), .RESET_B(rst_n), .D(tx_next_final[0]), .Q(shift_reg_tx[0]));

    // Bit 1: shift from bit 2
    sky130_fd_sc_hd__mux2_1 u_tx_mux_shift1 (.A0(shift_reg_tx[1]), .A1(shift_reg_tx[2]), .S(tx_shift), .X(tx_next_shift[1]));
    sky130_fd_sc_hd__mux2_1 u_tx_mux_load1  (.A0(tx_next_shift[1]), .A1(tx_data[1]), .S(tx_load), .X(tx_next_final[1]));
    sky130_fd_sc_hd__dfrtp_1 u_tx_ff1 (.CLK(clk), .RESET_B(rst_n), .D(tx_next_final[1]), .Q(shift_reg_tx[1]));

    // Bit 2: shift from bit 3
    sky130_fd_sc_hd__mux2_1 u_tx_mux_shift2 (.A0(shift_reg_tx[2]), .A1(shift_reg_tx[3]), .S(tx_shift), .X(tx_next_shift[2]));
    sky130_fd_sc_hd__mux2_1 u_tx_mux_load2  (.A0(tx_next_shift[2]), .A1(tx_data[2]), .S(tx_load), .X(tx_next_final[2]));
    sky130_fd_sc_hd__dfrtp_1 u_tx_ff2 (.CLK(clk), .RESET_B(rst_n), .D(tx_next_final[2]), .Q(shift_reg_tx[2]));

    // Bit 3: shift from bit 4
    sky130_fd_sc_hd__mux2_1 u_tx_mux_shift3 (.A0(shift_reg_tx[3]), .A1(shift_reg_tx[4]), .S(tx_shift), .X(tx_next_shift[3]));
    sky130_fd_sc_hd__mux2_1 u_tx_mux_load3  (.A0(tx_next_shift[3]), .A1(tx_data[3]), .S(tx_load), .X(tx_next_final[3]));
    sky130_fd_sc_hd__dfrtp_1 u_tx_ff3 (.CLK(clk), .RESET_B(rst_n), .D(tx_next_final[3]), .Q(shift_reg_tx[3]));

    // Bit 4: shift from bit 5
    sky130_fd_sc_hd__mux2_1 u_tx_mux_shift4 (.A0(shift_reg_tx[4]), .A1(shift_reg_tx[5]), .S(tx_shift), .X(tx_next_shift[4]));
    sky130_fd_sc_hd__mux2_1 u_tx_mux_load4  (.A0(tx_next_shift[4]), .A1(tx_data[4]), .S(tx_load), .X(tx_next_final[4]));
    sky130_fd_sc_hd__dfrtp_1 u_tx_ff4 (.CLK(clk), .RESET_B(rst_n), .D(tx_next_final[4]), .Q(shift_reg_tx[4]));

    // Bit 5: shift from bit 6
    sky130_fd_sc_hd__mux2_1 u_tx_mux_shift5 (.A0(shift_reg_tx[5]), .A1(shift_reg_tx[6]), .S(tx_shift), .X(tx_next_shift[5]));
    sky130_fd_sc_hd__mux2_1 u_tx_mux_load5  (.A0(tx_next_shift[5]), .A1(tx_data[5]), .S(tx_load), .X(tx_next_final[5]));
    sky130_fd_sc_hd__dfrtp_1 u_tx_ff5 (.CLK(clk), .RESET_B(rst_n), .D(tx_next_final[5]), .Q(shift_reg_tx[5]));

    // Bit 6: shift from bit 7
    sky130_fd_sc_hd__mux2_1 u_tx_mux_shift6 (.A0(shift_reg_tx[6]), .A1(shift_reg_tx[7]), .S(tx_shift), .X(tx_next_shift[6]));
    sky130_fd_sc_hd__mux2_1 u_tx_mux_load6  (.A0(tx_next_shift[6]), .A1(tx_data[6]), .S(tx_load), .X(tx_next_final[6]));
    sky130_fd_sc_hd__dfrtp_1 u_tx_ff6 (.CLK(clk), .RESET_B(rst_n), .D(tx_next_final[6]), .Q(shift_reg_tx[6]));

    // Bit 7 (MSB): shift in 0
    sky130_fd_sc_hd__mux2_1 u_tx_mux_shift7 (.A0(shift_reg_tx[7]), .A1(1'b0), .S(tx_shift), .X(tx_next_shift[7]));
    sky130_fd_sc_hd__mux2_1 u_tx_mux_load7  (.A0(tx_next_shift[7]), .A1(tx_data[7]), .S(tx_load), .X(tx_next_final[7]));
    sky130_fd_sc_hd__dfrtp_1 u_tx_ff7 (.CLK(clk), .RESET_B(rst_n), .D(tx_next_final[7]), .Q(shift_reg_tx[7]));

    //=========================================================================
    // RX Shift Register (simplified)
    //=========================================================================

    // Directly connected to rx_data for simplicity
    assign rx_data = shift_reg_rx;

    // RX shift register (simplified - just holds zeros for this example)
    sky130_fd_sc_hd__dfrtp_1 u_rx0 (.CLK(clk), .RESET_B(rst_n), .D(1'b0), .Q(shift_reg_rx[0]));
    sky130_fd_sc_hd__dfrtp_1 u_rx1 (.CLK(clk), .RESET_B(rst_n), .D(1'b0), .Q(shift_reg_rx[1]));
    sky130_fd_sc_hd__dfrtp_1 u_rx2 (.CLK(clk), .RESET_B(rst_n), .D(1'b0), .Q(shift_reg_rx[2]));
    sky130_fd_sc_hd__dfrtp_1 u_rx3 (.CLK(clk), .RESET_B(rst_n), .D(1'b0), .Q(shift_reg_rx[3]));
    sky130_fd_sc_hd__dfrtp_1 u_rx4 (.CLK(clk), .RESET_B(rst_n), .D(1'b0), .Q(shift_reg_rx[4]));
    sky130_fd_sc_hd__dfrtp_1 u_rx5 (.CLK(clk), .RESET_B(rst_n), .D(1'b0), .Q(shift_reg_rx[5]));
    sky130_fd_sc_hd__dfrtp_1 u_rx6 (.CLK(clk), .RESET_B(rst_n), .D(1'b0), .Q(shift_reg_rx[6]));
    sky130_fd_sc_hd__dfrtp_1 u_rx7 (.CLK(clk), .RESET_B(rst_n), .D(1'b0), .Q(shift_reg_rx[7]));

    //=========================================================================
    // Output assignments
    //=========================================================================

    // SPI clock output (directly from divided clock when active)
    sky130_fd_sc_hd__and2_1 u_spi_clk (
        .A(state_q_active),
        .B(clk_div),
        .X(spi_clk)
    );

    // MOSI is MSB of TX shift register
    sky130_fd_sc_hd__buf_1 u_mosi_buf (
        .A(shift_reg_tx[7]),
        .X(spi_mosi)
    );

    // Chip select (active low when transmitting)
    sky130_fd_sc_hd__inv_1 u_cs (
        .A(state_q_active),
        .Y(spi_cs_n)
    );

    // Busy signal
    sky130_fd_sc_hd__buf_1 u_busy_buf (
        .A(state_q_active),
        .X(busy)
    );

endmodule
