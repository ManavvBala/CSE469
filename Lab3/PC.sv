module register #(parameter WIDTH = 64)(
    input logic clk,
    input logic[WIDTH-1:0] DataIn,
    output logic[WIDTH-1:0] DataOut
);

	// generate multiple DFFs and chain together
	genvar i;
	generate
		 for (i = 0; i < WIDTH; i++) begin : genDFF
			  DFF newDFF (.d(DataIn[i]), .q(DataOut[i]), .reset(0), .clk);
		 end
	endgenerate

endmodule 