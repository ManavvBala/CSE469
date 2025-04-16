`timescale 1ns/10ps
module demux1_2 (
    input logic in,
    input logic sel,
    output logic[1:0] out
);

wire w;

not #(50ps) n1 (w,sel);
and #(50ps) a1 (out[0],w,in);
and #(50ps) a2 (out[1],sel,in);

endmodule
