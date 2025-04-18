`timescale 10ps/1fss

module adder_1bit (
	input logic  a, b, cin,
	output logic out, cout
    );

    logic[2:0] res;

    xor #5 x1 (res[0], a, b);
    xor #5 x2 (out, cin, res[0]);
    and #5 a1 (res[1], cin, res[0]);
    and #5 a2 (res[2], a, b);
    or #5 o1 (cout, res[1], res[2]);
endmodule