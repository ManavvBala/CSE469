
module demux2_4 (
    input logic in,
    input logic [1:0] sel,
    output logic[3:0] out
);

logic up,down;

	demux1_2 mid(.in(in),.sel(sel[1]),.out({up,down}));
	demux1_2 m1(.in(up),.sel(sel[0]),.out(out[1:0]));
	demux1_2 m2(.in(down),.sel(sel[0]),.out(out[3:2]));

endmodule
