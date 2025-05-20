module PC #(parameter WIDTH = 64)(
input logic rst,
    input logic clk,
    input logic[WIDTH-1:0] DataIn,
    output logic[WIDTH-1:0] DataOut
);

	// generate multiple DFFs and chain together
	genvar i;
	generate
		 for (i = 0; i < WIDTH; i++) begin : genDFF
			  D_FF newDFF (.d(DataIn[i]), .q(DataOut[i]), .reset(rst), .clk);
		 end
	endgenerate

endmodule 