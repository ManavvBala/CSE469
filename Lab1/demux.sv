module demux (
    input logic in,
    input logic[4:0] sel,
    output logic[30:0] out
);

always_comb begin
    out = 31'b0;          
    if (sel < 31)         
        out[sel] = in;
end

endmodule