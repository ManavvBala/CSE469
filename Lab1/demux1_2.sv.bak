module demux1_2 (
    input logic in,
    input logic sel,
    output logic[1:0] out
);

wire w;

not #5 n1 (w,sel);
and #5 a1 (out[0],w,in);
and #5 a2 (out[1],sel,in);

endmodule
