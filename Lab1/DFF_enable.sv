module DFF_enable (
    output logic q,
    input logic d, reset, clk, enable
);
    logic out;
    logic [1:0] in;

    assign in[0] = q; // Feed back the actual output
    assign in[1] = d;
    
    // instantiate dff to hold state
    D_FF dff (.d(out), .q(q), .*);

    mux2_1 mux (.sel(enable), .d(in[1:0]), .q(out));

endmodule 
