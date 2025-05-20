`timescale 1ns/10ps
module alu (
    input logic[63:0] A, B,
    input logic [2:0] cntrl,
    output logic [63:0] result,
    output logic negative, zero, overflow, carry_out
);
    
    // need wires for carry
    logic [63:0] carries;
    // instantiate the bit alus
    alu_1bit firstALU (.control(cntrl), .a(A[0]), .b(B[0]), .cin(cntrl[0]), .out(result[0]), .cout(carries[0]));

    genvar i;
    generate
        for (i = 1; i < 64; i++) begin : newALU
            alu_1bit bitalu (.control(cntrl), .a(A[i]), .b(B[i]), .cin(carries[i - 1]), .out(result[i]), .cout(carries[i]));
        end
    endgenerate
    
    // carry_out
    assign carry_out = carries[63];
    
    // zero
    isZero zeroCheck (.in(result), .out(zero));
    
    // negative
    assign negative = result[63];

    // overflow
    // xor the last two carries
    xor #(50ps) overflowXOR (overflow, carries[63], carries[62]);

endmodule