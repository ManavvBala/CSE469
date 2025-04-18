module alu (
    input logic[63:0] A, B,
    input logic [2:0] cntrl;
    output logic [63:0] result,
    output logic negative, zero, overflow, carry_out
);
    
    // need wires for carry
    logic [63:0] carry;
    // instantiate the bit alus
    alu_1bit 1bitalu (.control(cntrl), .a(A[i]), .b(B[i]), .cin(0), .out(result[0]), .cout(carry[0]));

    genvar i
    generate
        for (i = 1; i < 64; i++) begin : newALU
            alu_1bit 1bitalu (.control(cntrl), .a(A[i]), .b(B[i]), .cin(carry[i - 1]), .out(result[i]), .cout(carry[i]));
        end
    endgenerate
    
    // carry_out
    assign carry_out = carry[63];
    
    // zero
    isZero zeroCheck (.in(result), .out(zero));
    
    // negative
    assign negative = result[63];

    // overflow
    // xor the last two carries
    xor overflowXOR (overflow, carry[63], carry[62]);

endmodule