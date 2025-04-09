module mux64x32_1 (
    input logic[63:0][31:0] in,
    input logic[4:0] sel,
    output logic[63:0] out
);

genvar i;

generate
    for(int i =0; i<64; i++) begin: each_mux
        mux32_1 mux(.in(in[i]),.sel(sel),.out(out[i]));
    end
endgenerate