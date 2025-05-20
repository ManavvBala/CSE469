module DFF_enable (
    output logic q,
    input logic d, reset, clk, enable
);
    logic mux_out;
    
    // Multiplexer: chooses between q (hold) and d (new data)
    mux2_1 mux (
        .sel(enable),
        .d({d,q}),     // New value
        .q(mux_out)
    );

    // D Flip-Flop with reset
    D_FF dff (
        .d(mux_out),
        .q(q),
        .clk(clk),
        .reset(reset)
    );
endmodule