// ==================================================
// Memory Interface - Example 3 Design
// ==================================================
//
// Minimal design for OpenROAD I/O placement demonstration
// 38 I/O pins - Pure structural description

module mem_interface (
    clk,
    rst_n,
    wr_en,
    rd_en,
    addr_0, addr_1, addr_2, addr_3, addr_4, addr_5, addr_6, addr_7,
    addr_8, addr_9, addr_10, addr_11, addr_12, addr_13, addr_14, addr_15,
    data_in_0, data_in_1, data_in_2, data_in_3, 
    data_in_4, data_in_5, data_in_6, data_in_7,
    data_out_0, data_out_1, data_out_2, data_out_3,
    data_out_4, data_out_5, data_out_6, data_out_7,
    ready,
    error
);

    // Control inputs
    input clk;
    input rst_n;
    input wr_en;
    input rd_en;
    
    // Address bus (16 bits)
    input addr_0, addr_1, addr_2, addr_3;
    input addr_4, addr_5, addr_6, addr_7;
    input addr_8, addr_9, addr_10, addr_11;
    input addr_12, addr_13, addr_14, addr_15;
    
    // Data input bus (8 bits)
    input data_in_0, data_in_1, data_in_2, data_in_3;
    input data_in_4, data_in_5, data_in_6, data_in_7;
    
    // Data output bus (8 bits)
    output data_out_0, data_out_1, data_out_2, data_out_3;
    output data_out_4, data_out_5, data_out_6, data_out_7;
    
    // Status outputs
    output ready;
    output error;
    
    // Simple pass-through logic (combinational)
    assign data_out_0 = data_in_0;
    assign data_out_1 = data_in_1;
    assign data_out_2 = data_in_2;
    assign data_out_3 = data_in_3;
    assign data_out_4 = data_in_4;
    assign data_out_5 = data_in_5;
    assign data_out_6 = data_in_6;
    assign data_out_7 = data_in_7;
    
    // Status signals
    assign ready = wr_en;
    assign error = rd_en;

endmodule
