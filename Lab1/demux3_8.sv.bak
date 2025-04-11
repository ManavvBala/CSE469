module demux3_8 (
    input logic in,
    input logic sel[2:0],
    output logic[7:0] out
);

logic up,down;

demux1_2 mid(.in(in),.sel(sel[2]),.out({up,down}));
demux2_4 m1(.in(up),.sel(sel[1:0]).out(out[3:0]));
demux2_4 m2(.in(down),.sel(sel[1:0]).out(out[7:4]));

endmodule
