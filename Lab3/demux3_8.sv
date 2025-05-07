module demux3_8 (
    input logic in,
    input logic [2:0] sel,
    output logic [7:0] out
	 );

    logic top_en, bottom_en;
    demux1_2 first_stage (.in(in), .sel(sel[2]), .out({top_en, bottom_en}));

    // out[7]: sel = 3'b111
    demux2_4 bottom_demux (.in(bottom_en), .sel(sel[1:0]), .out(out[3:0]));
    demux2_4 top_demux (.in(top_en), .sel(sel[1:0]), .out(out[7:4]));
    
endmodule