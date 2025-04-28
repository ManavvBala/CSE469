module mux32_1 (
    input logic[31:0] d,
    input logic[4:0] sel,
    output logic q
);

    logic [1:0] temp;

    // in 15 - 0
    mux16_1 m0 (.sel(sel[3:0]), .d(d[15:0]), .q(temp[0]));
    
    // in 31 - 16
    mux16_1 m1 (.sel(sel[3:0]), .d(d[31:16]), .q(temp[1]));

    mux2_1 s0 (.sel(sel[4]), .d(temp), .q(q));

endmodule