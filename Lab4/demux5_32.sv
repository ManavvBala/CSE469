module demux5_32 (
    input  logic in,
    input  logic [4:0] sel,
    output logic [31:0] out
);

    logic [3:0] enable_8;
    demux2_4 top_stage (.in(in), .sel(sel[4:3]), .out(enable_8));


    demux3_8 d0 (.in(enable_8[0]), .sel(sel[2:0]), .out(out[7:0]));
    demux3_8 d1 (.in(enable_8[1]), .sel(sel[2:0]), .out(out[15:8]));
    demux3_8 d2 (.in(enable_8[2]), .sel(sel[2:0]), .out(out[23:16]));
    demux3_8 d3 (.in(enable_8[3]), .sel(sel[2:0]), .out(out[31:24]));
endmodule