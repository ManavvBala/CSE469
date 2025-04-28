module mux64x32_1 (
    input logic [63:0] in [31:0],
    input logic[4:0] sel,
    output logic[63:0] out
);

genvar i;
genvar j;
 
generate
    for(i = 0; i < 64; i++) begin: each_mux
		  logic [31:0] bits;
		  
		  // loop through i registers take jth bit;
		  for (j = 0; j < 32; j++) begin: each_bit
		     assign bits[j] = in[j][i];
		  end
        mux32_1 mux1 (.d(bits),.sel(sel),.q(out[i]));
    end
endgenerate

endmodule