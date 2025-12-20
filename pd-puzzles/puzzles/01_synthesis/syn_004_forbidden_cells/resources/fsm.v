// FSM - Pre-synthesized netlist with FORBIDDEN CELLS
// Contains dlygate cells that should NOT be used!

module fsm (
    input  wire       clk,
    input  wire       rst_n,
    input  wire [1:0] cmd,
    output wire [2:0] state,
    output wire       ready,
    output wire       err_out
);

    wire [2:0] state_reg;
    wire [2:0] next_state;

    // State FFs
    sky130_fd_sc_hd__dfrtp_1 ff0 (.D(next_state[0]), .CLK(clk), .RESET_B(rst_n), .Q(state_reg[0]));
    sky130_fd_sc_hd__dfrtp_1 ff1 (.D(next_state[1]), .CLK(clk), .RESET_B(rst_n), .Q(state_reg[1]));
    sky130_fd_sc_hd__dfrtp_1 ff2 (.D(next_state[2]), .CLK(clk), .RESET_B(rst_n), .Q(state_reg[2]));

    // Command decode with FORBIDDEN delay gate!
    wire cmd_delayed;
    sky130_fd_sc_hd__dlygate4sd1_1 dly_forbidden (.A(cmd[0]), .X(cmd_delayed));

    wire cmd_n0, cmd_n1;
    sky130_fd_sc_hd__inv_1 inv_cmd0 (.A(cmd_delayed), .Y(cmd_n0));
    sky130_fd_sc_hd__inv_1 inv_cmd1 (.A(cmd[1]), .Y(cmd_n1));

    wire cmd_01, cmd_10, cmd_11, cmd_00;
    sky130_fd_sc_hd__and2_1 cmd01_dec (.A(cmd_delayed), .B(cmd_n1), .X(cmd_01));
    sky130_fd_sc_hd__and2_1 cmd10_dec (.A(cmd_n0), .B(cmd[1]), .X(cmd_10));
    sky130_fd_sc_hd__and2_1 cmd11_dec (.A(cmd_delayed), .B(cmd[1]), .X(cmd_11));
    sky130_fd_sc_hd__nor2_1 cmd00_dec (.A(cmd_delayed), .B(cmd[1]), .Y(cmd_00));

    // State decode
    wire s0_n, s1_n, s2_n;
    sky130_fd_sc_hd__inv_1 inv_s0 (.A(state_reg[0]), .Y(s0_n));
    sky130_fd_sc_hd__inv_1 inv_s1 (.A(state_reg[1]), .Y(s1_n));
    sky130_fd_sc_hd__inv_1 inv_s2 (.A(state_reg[2]), .Y(s2_n));

    wire is_idle, is_fetch, is_decode, is_execute, is_write, is_error;
    sky130_fd_sc_hd__nor3_1 idle_dec (.A(state_reg[0]), .B(state_reg[1]), .C(state_reg[2]), .Y(is_idle));
    sky130_fd_sc_hd__and3_1 fetch_dec (.A(state_reg[0]), .B(s1_n), .C(s2_n), .X(is_fetch));
    sky130_fd_sc_hd__and3_1 decode_dec (.A(s0_n), .B(state_reg[1]), .C(s2_n), .X(is_decode));
    sky130_fd_sc_hd__and3_1 exec_dec (.A(state_reg[0]), .B(state_reg[1]), .C(s2_n), .X(is_execute));
    sky130_fd_sc_hd__and3_1 write_dec (.A(s0_n), .B(s1_n), .C(state_reg[2]), .X(is_write));
    sky130_fd_sc_hd__and3_1 error_dec (.A(state_reg[0]), .B(state_reg[1]), .C(state_reg[2]), .X(is_error));

    // Transition logic with another FORBIDDEN delay!
    wire is_idle_delayed;
    sky130_fd_sc_hd__clkdlybuf4s15_1 dly_forbidden2 (.A(is_idle), .X(is_idle_delayed));

    wire go_fetch, go_error_from_idle;
    sky130_fd_sc_hd__and2_1 tr1 (.A(is_idle_delayed), .B(cmd_01), .X(go_fetch));
    sky130_fd_sc_hd__and2_1 tr2 (.A(is_idle_delayed), .B(cmd_10), .X(go_error_from_idle));

    wire go_execute, go_idle_from_error;
    sky130_fd_sc_hd__and2_1 tr4 (.A(is_decode), .B(cmd_11), .X(go_execute));
    sky130_fd_sc_hd__and2_1 tr6 (.A(is_error), .B(cmd_00), .X(go_idle_from_error));

    // Next state logic
    wire error_stay_n, error_stay;
    sky130_fd_sc_hd__inv_1 inv_go_idle (.A(go_idle_from_error), .Y(error_stay_n));
    sky130_fd_sc_hd__and2_1 err_stay (.A(is_error), .B(error_stay_n), .X(error_stay));

    wire cmd_11_n, go_error_from_decode;
    sky130_fd_sc_hd__inv_1 inv_cmd11 (.A(cmd_11), .Y(cmd_11_n));
    sky130_fd_sc_hd__and2_1 tr5 (.A(is_decode), .B(cmd_11_n), .X(go_error_from_decode));

    sky130_fd_sc_hd__or4_1 ns0_or (.A(go_fetch), .B(is_execute), .C(error_stay), .D(go_error_from_idle), .X(next_state[0]));
    sky130_fd_sc_hd__or4_1 ns1_or (.A(is_fetch), .B(is_execute), .C(error_stay), .D(go_error_from_idle), .X(next_state[1]));

    wire go_error_any;
    sky130_fd_sc_hd__or2_1 err_any (.A(go_error_from_idle), .B(go_error_from_decode), .X(go_error_any));
    sky130_fd_sc_hd__or2_1 ns2_or (.A(go_error_any), .B(error_stay), .X(next_state[2]));

    // Outputs
    sky130_fd_sc_hd__or2_1 ready_or (.A(is_idle), .B(is_write), .X(ready));
    sky130_fd_sc_hd__buf_1 err_buf (.A(is_error), .X(err_out));

    sky130_fd_sc_hd__buf_1 out0 (.A(state_reg[0]), .X(state[0]));
    sky130_fd_sc_hd__buf_1 out1 (.A(state_reg[1]), .X(state[1]));
    sky130_fd_sc_hd__buf_1 out2 (.A(state_reg[2]), .X(state[2]));

endmodule
