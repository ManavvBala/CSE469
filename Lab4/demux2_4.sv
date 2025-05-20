module demux2_4 (
    input logic in,
    input logic [1:0] sel,
    output logic [3:0] out
);

    logic top_en, bottom_en;
    demux1_2 first_stage (.in(in), .sel(sel[1]), .out({top_en, bottom_en}));
    

    demux1_2 bottom_demux (.in(bottom_en), .sel(sel[0]), .out({out[1], out[0]}));
    demux1_2 top_demux (.in(top_en), .sel(sel[0]), .out({out[3], out[2]}));
    
endmodule