module mux16_1 (
    input logic [3:0] sel,
    input logic [15:0] d,
    output logic q,
);
// first stage of four
// generate four 
    // temp for transferring between first and second stage
    logic [3:0] temp;
    // d 0-3
    mux4_1 m0 (.sel(sel[1:0]), .d(d[3:0]), .q(temp[0]));
    // d 4-7
    mux4_1 m1 (.sel(sel[1:0]), .d(d[7:4]), .q(temp[1]));
    // d 8-11
    mux4_1 m2 (.sel(sel[1:0]), .d(d[11:8]), .q(temp[2]));
    // d 12-15
    mux4_1 m3 (.sel(sel[1:0]), .d(d[15:12]), .q(temp[3]));

    mux4_1 second_stage_m1 (.sel(sel[3:2]), .d(temp), .q);

endmodule