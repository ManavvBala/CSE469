module mux2x64_64 (i1, i0, sel, out);
	input logic [63:0] i1, i0;
	input logic sel;
	output logic [63:0] out;

	genvar i;
	
	generate 
		for (i = 0; i < 64; i++) begin : bitMux
			mux2_1 m(.in({i1[i], i0[i]}), .sel(sel), .out(out[i]));
		end
	endgenerate 

endmodule