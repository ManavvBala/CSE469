module DFF_enable (
    output logic q,
    input logic d, reset, clk, enable
);
    logic temp_q, temp_d;
    // instantiate dff to hold state
    D_FF dff (.d(temp_d), .q(temp_q), .*);

    mux2_1 mux (.sel(enable), .d({temp_q, d}), .q(temp_d));

    assign q = temp_q;

endmodule 