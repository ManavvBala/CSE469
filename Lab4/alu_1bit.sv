//`timescale 10ps/1fs
`timescale 1ns/10ps
module alu_1bit (
    input logic [2:0] control,
	input logic  a, b, cin,
	output logic out, cout
    );
	logic [3:0] res;
	logic bNot, bPrime;
    //And, or, and xor
	and #(50ps) a1 (res[0], b, a);
	or  #(50ps) o1  (res[1], b, a);
	xor #(50ps) x1 (res[2], b, a);

    //Selecting whether add or subtract using a mux
    not #(50ps) n1 (bNot, b); 
	mux2_1 m1 (.d({bNot, b}), .sel(control[0]), .q(bPrime));
	
	adder_1bit m2 (.a, .b(bPrime), .out(res[3]), .cin, .cout);


    //Control routing
	mux8_1 m3 (.d({1'b0, res[2:0], res[3], res[3], 1'b0, b}), .sel(control), .q(out));
endmodule
