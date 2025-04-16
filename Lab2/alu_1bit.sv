`timescale 10ps/1fs

module alu_1bit (
    input logic [2:0] control,
	input logic  a, b, cin,
	output logic out, cout,
	logic [3:0] res,
	logic bNot, bPrime
    );

    //And, or, and xor
	and #5 a1 (res[0], b, a);
	or  #5 o1  (res[1], b, a);
	xor #5 x1 (res[2], b, a);

    //Selecting whether add or subtract using a mux
    not #5 n1 (bBar, b); 
	mux2_1 m1 (.in({bNot, b}), .sel(control[0]), .out(bPrime));
	adder_1bit m2 (.a, .b(bPrime), .out(res[3]), .cin, .cout);


    //Control routing
	mux8_1 m3 (.in({1'b0, result[2:0], result[3], result[3], 1'b0, b}), .sel(control), .out);

endmodule