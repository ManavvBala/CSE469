module mux32_1 (
    input logic[31:0] in,
    input logic[4:0] sel,
    output logic out
);

assign out = in[sel];

endmodule