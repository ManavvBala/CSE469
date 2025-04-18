module mux8_1 (
    input logic [7:0] d,
    input logic [2:0] sel,
    output logic q
);

    logic [1:0] temp;
    mux4_1 first_stage1 (.sel(sel[1:0]), .d(d[3:0]), .q(temp[0]));
    mux4_1 first_stage2 (.sel(sel[1:0]), .d(d[7:4]), .q(temp[1]));
    mux2_1 second_stage (.sel(sel[2]), .d(temp), .q(q));

endmodule