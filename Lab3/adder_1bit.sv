//`timescale 10ps/1fs
`timescale 1ns/10ps
module adder_1bit (
	input logic  a, b, cin,
	output logic out, cout
    );

    logic[2:0] res;

    xor #(50ps) x1 (res[0], a, b);
    xor #(50ps) x2 (out, cin, res[0]);
    and #(50ps) a1 (res[1], cin, res[0]);
    and #(50ps) a2 (res[2], a, b);
    or #(50ps) o1 (cout, res[1], res[2]);
endmodule