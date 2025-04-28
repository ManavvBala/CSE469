module adder_64bit (
    input logic [63:0] A, B;
	output logic [63:0] out;
)

logic [63:0] chain;

adder_1bit a1 (.a(A[0]), .b(B[0]), .out(out[0]), .cin(1'b0), .cout(chain[0]));

genvar i;
generate 
    for (i = 1; i < 63; i++) begin: makeAdder
        adder_1bit an (.a(A[i]), .b(B[i]), .out(out[i]), .cin(chain[i - 1]), .cout(chain[i]));
    end
endgenerate

adder_1bit a64 (.a(A[63]), .b(B[63]), .out(out[63]), .cin(chain[62]), .cout(chain[63]));