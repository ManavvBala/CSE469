module mux4_1 (
    input logic [3:0] d,
    input logic [1:0] sel,
    output logic q
);

    logic [1:0] temp;
    mux2_1 first_stage1 (.sel(sel[0]), .d(d[1:0]), .q(temp[0]));
    mux2_1 first_stage2 (.sel(sel[0]), .d(d[3:2]), .q(temp[1]));
    mux2_1 second_stage (.sel(sel[1]), .d(temp), .q(q));

endmodule