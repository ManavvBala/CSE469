module demux5_32 (
    input logic in,
    input logic sel[4:0],
    output logic[31:0] out
);

logic d1,d2,d3,d4;

demux2_4 mid(.in(in),.sel(sel[4:3]),.out({d1,d2,d3,d4}));
demux3_8 m1(.in(d1),.sel(sel[2:0]).out(out[31:24]));
demux3_8 m2(.in(d2),.sel(sel[2:0]).out(out[23:16]));
demux3_8 m3(.in(d3),.sel(sel[2:0]).out(out[15:8]));
demux3_8 m4(.in(d4),.sel(sel[2:0]).out(out[7:0]));

endmodule
